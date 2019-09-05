/*
 * Cordova SSH Connect Plugin for Android.
 * Author: Jose Andrés Pérez Arévalo <joseaperez27@outlook.com> (https://github.com/JosePerez27)
 * Date: Thu, 05 Sep 2019 11:18:07 -0500
 */

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.apache.cordova.PluginResult.Status;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import android.util.Log;

public class sshConnect extends CordovaPlugin {

    private static final String ENTER_KEY = "\n";
    private Session session;
 

    public void initialize(CordovaInterface cordova, CordovaWebView webView) {

        super.initialize(cordova, webView);
        Log.d("sshConnect", "Starting...");
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        try {
    
            if (action.equals("connect")) {
                String user = args.getString(0);
                String password = args.getString(1);
                String host = args.getString(2);
                int port = Integer.parseInt(args.getString(3));
                this.connect(user, password, host, port, callbackContext);
                return true;
            }
    
            if (action.equals("executeCommand")) {
                String command = args.getString(0);
                this.executeCommand(command, callbackContext);
                return true;
            }
    
            if (action.equals("disconnect")) {
                this.disconnect(callbackContext);
                return true;
            }

            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, "Error no such method '" + action + "'"));
            return false;

        } catch (Exception e) {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, "Error while calling '" + action + "' '" + e.getMessage() + "'"));
            return false;
        }
    }

    private void connect(String user, String password, String host, int port, CallbackContext callbackContext) {
        try {

            if (this.session == null || !this.session.isConnected()) {

                JSch jsch = new JSch();
                this.session = jsch.getSession(user, host, port);
                this.session.setPassword(password);
        
                // Parameter for not validating connection key
                this.session.setConfig("StrictHostKeyChecking", "no");
                this.session.connect();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, true));
    
            } else {
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, "SSH session already started"));
            }
            
        } catch (JSchException e) {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, "Exception: " + e.getMessage()));
        }
    }

    private final void executeCommand(String command, CallbackContext callbackContext) {
        try {

            if (this.session != null && this.session.isConnected()) {

                // Open a SSH channel
                ChannelExec channelExec = (ChannelExec) this.session.openChannel("exec");
                InputStream in = channelExec.getInputStream();
        
                // Execute the command
                channelExec.setCommand(command);
                channelExec.connect();
        
                // Get the text printed on the console
                BufferedReader reader = new BufferedReader(new InputStreamReader(in));
                StringBuilder builder = new StringBuilder();
                String linea;
        
                while ((linea = reader.readLine()) != null) {
                    builder.append(linea);
                    builder.append(ENTER_KEY);
                }
        
                // Close the SSH channel
                channelExec.disconnect();
        
                // Return the printed text on the console
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, builder.toString()));
    
            } else {
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, "There is no SSH session started"));
            }
            
        } catch (JSchException e) {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, "Exception: " + e.getMessage()));
        } catch (IOException e) {
            callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, "Exception: " + e.getMessage()));
        }
    }

    private final void disconnect(CallbackContext callbackContext) {
        this.session.disconnect();
        callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, true));
    }
}
