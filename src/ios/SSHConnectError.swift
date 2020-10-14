//
//  SSHConnectError.swift
//  Cordova SSH Connect Plugin for iOS.
//
//  Created by Tzuig, Ltd on 10/6/20.
//

import Foundation

enum SSHConnectError: Error {
    case incorrectParameters(message: String? = nil)
    case connectionFailed(message: String? = nil)
    case authorizationFailed(message: String? = nil)
    case commandExecutionFailed(message: String? = nil)
    case disconnectFailed(message: String? = nil)

    var description: String {
        switch self {
        case .incorrectParameters(let message):
            return "Incorrect or empty parameters sent. \(message ?? "")"
        case .connectionFailed(let message):
            return "Connection failed. \(message ?? "")"
        case .authorizationFailed(let message):
            return "Authorization failed. \(message ?? "")"
        case .commandExecutionFailed(let message):
            return "Command execution failed. \(message ?? "")"
        case .disconnectFailed(let message):
            return "Disconnect failed. \(message ?? "")"
        }
    }
}
