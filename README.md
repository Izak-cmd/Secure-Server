# Secure-Server
A Shell Script for Securing new Ubuntu 18.04 Servers

### How to Use

Simple execute with sudo permissions ```sudo bash Secure.sh```.

### What does this script do?

This shell script will Secure Shared Memory, enable SSH on specified port which is randomly generated, install UFW and Fail2ban as well as removing other attack vectors.

It is important that you note the Port generated after running this script before rebooting your system.

### Extra Protection

Not included in this script for security reasons, are instructions to create a custom sudoer user group. 

This can be done with the following commands;
-sudo groupadd admin
-sudo usermod -a -G admin YourUsername
-sudo dpkg-statoverride --update --add root admin 4750 /bin/su

This will disable the usage of sudo su for users not in your custom usergroup.

## Authors

* **Isaac Goodrick** - *Initial work* - [Izak](https://github.com/Izak-cmd)

## License

This project is licensed under the CC0 License and is free for distribution, modification and use in commercial applications - see the [LICENSE.md](LICENSE.md) file for details.
