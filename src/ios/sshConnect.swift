//
//  SSHConnect.swift
//  Cordova SSH Connect Plugin for iOS.
//
//  Created by Tzuig, Ltd on 10/6/20.
//

import Foundation
import NMSSH

@objc(sshConnect)
class SSHConnect: CDVPlugin {
    private var session: NMSSHSession?

    @objc(connect:)
    func connect(_ command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult

        guard
            let user = command.arguments[0] as? String,
            let password = command.arguments[1] as? String,
            let host = command.arguments[2] as? String,
            let port = command.arguments[3] as? Int
        else {
            pluginResult = buildPluginResult(error: .incorrectParameters())
            self.commandDelegate?.send(pluginResult, callbackId: command.callbackId)
            return
        }

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

        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
    }

    @objc(disconnect:)
    func disconnect(_ command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult

        if let session = session,
           session.isConnected,
           session.isAuthorized {
            session.disconnect()
            pluginResult = buildPluginResult()
        } else {
            pluginResult = buildPluginResult(error: .commandExecutionFailed(message: "SSH not connected/authorized"))
        }

        self.commandDelegate?.send(pluginResult, callbackId: command.callbackId)
    }

    @objc(executeCommand:)
    func executeCommand(_ command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult

        guard
            let execCommand = command.arguments[0] as? String
        else {
            pluginResult = buildPluginResult(error: .incorrectParameters())
            self.commandDelegate?.send(pluginResult, callbackId: command.callbackId)
            return
        }

        if let session = session,
           session.isConnected,
           session.isAuthorized {

            var error: NSError?
            let executeCommand = session.channel.execute(execCommand, error: &error)

            if error != nil {
                pluginResult = buildPluginResult(error: .commandExecutionFailed(message: error?.localizedDescription))
            } else {
                pluginResult = buildPluginResult(message: executeCommand)
            }
        } else {
            pluginResult = buildPluginResult(error: .commandExecutionFailed(message: "SSH not connected/authorized"))
        }

        self.commandDelegate?.send(pluginResult, callbackId: command.callbackId)
    }

    private func buildPluginResult(message: String? = nil, error: SSHConnectError? = nil) -> CDVPluginResult {
        var pluginResult: CDVPluginResult

        if let error = error {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.description)
            return pluginResult
        }

        if message != nil {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: message)
            return pluginResult
        }

        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: true)
        return pluginResult
    }
}
