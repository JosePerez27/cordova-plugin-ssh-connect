[![Licence](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![npm](https://img.shields.io/npm/dt/cordova-plugin-ssh-connect.svg?label=npm%20downloads)](https://www.npmjs.com/package/cordova-plugin-ssh-connect)
[![npm](https://img.shields.io/npm/v/cordova-plugin-ssh-connect)](https://www.npmjs.com/package/cordova-plugin-ssh-connect)

# SSH Connect

SSH Plugin for Cordova to make connections and execute remote commands with the [JSch](http://www.jcraft.com/jsch/) library for Android.

**Contributions are welcome.**

## Supported Platforms

* Android

## Install

```sh
cordova plugin add cordova-plugin-ssh-connect
```

## Methods

* window.cordova.plugins.sshConnect.connect
* window.cordova.plugins.sshConnect.executeCommand
* window.cordova.plugins.sshConnect.disconnect

## Usage

### Connect Method

```typescript
sshConnect.connect('user', 'password', 'host', port, function(success) {...}, function(failure) {...})
```
**Params**

* `user` - Host username.  
* `password` - Host password.  
* `host` - Hostname or IP address.  
* `port` - SSH port number.  

**Success Response**

* Return a `boolean` value.

**Failure Response**

* Return an error message.

### Execute Command Method

```typescript
sshConnect.executeCommand('command', function(success) {...}, function(failure) {...})
```
**Params**

* `command` - The SSH command you want to execute in the remote host.  

**Success Response**

* Return a `string` with the printed text on the remote console.

**Failure Response**

* Return an error message.

### Disconnect Method

```typescript
sshConnect.disconnect(function(success) {...}, function(failure) {...})
```
**Params**

* No params are provided.  

**Success Response**

* Return a `boolean` value.

**Failure Response**

* Return an error message.

## Example Usage

Now here is an example to be able to use the methods:

```javascript
  var success = function (resp) {
    alert(resp);
  }
  
  var failure = function (error) {
    alert(error);
  }

  window.cordova.plugins.sshConnect.connect('MyUser', 'MyPassword', '0.0.0.0', 22,
    function(resp) {
      if (resp) {
        window.cordova.plugins.sshConnect.executeCommand('ls -l', success, failure);
        window.cordova.plugins.sshConnect.disconnect(success, failure);
      }
    }
  , failure);
```

## Ionic 4 Usage

### Install Wrapper

```sh
npm install @ionic-native/ssh-connect
```
### Definitions

Define it at **app.module.ts**

```ts
import { SSHConnect } from '@ionic-native/ssh-connect/ngx';

@NgModule({
    ...
    providers: [
        SSHConnect
    ],
    ...
})
```

Ionic wrapper functions returns promises, use them as follows:
```typescript
import { SSHConnect } from '@ionic-native/ssh-connect/ngx';

constructor(private sshConnect: SSHConnect) { }

...

this.sshConnect.connect('user', 'password', 'host', port)
  .then(resp => console.log(resp))
  .catch(error => console.error(err));
  
this.sshConnect.executeCommand('command')
  .then(resp => console.log(resp))
  .catch(error => console.error(err));

this.sshConnect.disconnect()
  .then(resp => console.log(resp))
  .catch(error => console.error(err));

```
### Example Usage

There is an example to be able to use the methods in Ionic:

```typescript
  const connected = await this.sshConnect.connect('MyUser', 'MyPassword', '0.0.0.0', 22);

  if (connected) {

    this.sshConnect.executeCommand('ls -l')
      .then(resp => {
        console.log(resp);
      })
      .catch(error => {
        console.error(error);
      });

    this.sshConnect.disconnect();

  }
```
## TODO

* Add iOS support.

## Author

* Jose Andrés Pérez Arévalo, (https://github.com/JosePerez27).

## Licence

View the [LICENCE FILE](https://github.com/JosePerez27/cordova-plugin-ssh-connect/blob/master/LICENCE).

## Issues

Report at [GitHub Issues](https://github.com/JosePerez27/cordova-plugin-ssh-connect/issues).
