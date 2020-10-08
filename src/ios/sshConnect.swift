//
//  SSHConnect.swift
//  Cordova SSH Connect Plugin for iOS.
//
//  Created by Tzuig, Ltd on 10/6/20.
//

import Foundation
import NMSSH

@objc(SSHConnect) class SSHConnect: CDVPlugin {
    private var session: NMSSHSession?

    @objc(connect:user:password:host:port:)
    func connect(urlCommand: CDVInvokedUrlCommand, user: String, password: String, host: String, port: Int = 22) {
        var pluginResult = buildPluginResult(error: .connectionFailed())

        session = NMSSHSession(host: host, configs: [], withDefaultPort: port, defaultUsername: user)
        session?.connect()

        if let session = session,
           session.isConnected {
            session.authenticate(byPassword: password)

            if session.isAuthorized {
                pluginResult = buildPluginResult()
            } else {
                pluginResult = buildPluginResult(error: .authorizationFailed(message: "Make sure your password is correct"))
            }
        } else {
            pluginResult = buildPluginResult(error: .connectionFailed(message: "Could not connect"))
        }

        self.commandDelegate?.send(pluginResult, callbackId: urlCommand.callbackId)
    }

    @objc(disconnect:)
    func disconnect(urlCommand: CDVInvokedUrlCommand) {
        var pluginResult = buildPluginResult(error: .disconnectFailed())

        if let session = session,
           session.isConnected,
           session.isAuthorized {
            session.disconnect()
            pluginResult = buildPluginResult()
        } else {
            pluginResult = buildPluginResult(error: .commandExecutionFailed(message: "SSH not connected/authorized"))
        }

        self.commandDelegate?.send(pluginResult, callbackId: urlCommand.callbackId)
    }

    @objc(executeCommand:command:)
    func executeCommand(urlCommand: CDVInvokedUrlCommand, command: String) {
        var pluginResult = buildPluginResult(message: "Failed", error: .commandExecutionFailed())

        if let session = session,
           session.isConnected,
           session.isAuthorized {

            var error: NSError?
            let executeCommand = session.channel.execute(command, error: &error)

            if error != nil {
                pluginResult = buildPluginResult(error: .commandExecutionFailed(message: error?.localizedDescription))
            } else {
                pluginResult = buildPluginResult(message: executeCommand)
            }
        } else {
            pluginResult = buildPluginResult(error: .commandExecutionFailed(message: "SSH not connected/authorized"))
        }

        self.commandDelegate?.send(pluginResult, callbackId: urlCommand.callbackId)
    }

    private func buildPluginResult(message: String? = nil, error: SSHConnectError? = nil) -> CDVPluginResult {
        var pluginResult: CDVPluginResult

        if let error = error {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.description)
            return pluginResult
        }

        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: message)
        return pluginResult
    }
}
