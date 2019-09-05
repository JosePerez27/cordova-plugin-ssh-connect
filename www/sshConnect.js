var exec = require('cordova/exec');

exports.connect = function (user, password, host, port, success, error) {
    exec(success, error, 'sshConnect', 'connect', [user, password, host, port]);
};

exports.executeCommand = function (command, success, error) {
    exec(success, error, 'sshConnect', 'executeCommand', [command]);
};

exports.disconnect = function (success, error) {
    exec(success, error, 'sshConnect', 'disconnect', []);
};
