#!bin/bash
Fstab() {
echo "tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0"  | sudo tee -a /etc/fstab
}
Banner() {
echo "Secure Server! Authorized Access Only!"  | sudo tee -a /etc/issue.net
echo "Banner /etc/issue.net"  | sudo tee -a /etc/ssh/sshd_config
}
ChangePortInSSH() {
sudo sed "s/Port 22/Port ${PORT}/g" /etc/ssh/sshd_config
}
CreateJail() {
echo '[sshd]
enabled = true
port = '${PORT}'
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 30d'  | sudo tee -a /etc/fail2ban/jail.local
}
RemoveMOTD() {
sed -i -e 's/\(session optional pam_motd.so motd=/run/motd.dynamic\|session optional pam_motd.so noupdate\)//g' /etc/pam.d/sshd
}
CheckSudo() {
#sudo is root, root is EUID 0, if not 0 then not sudo
	if (( $EUID != 0 )); then {
#Show the Warning
	clear
	echo -e "${bold}This script must be run with sudo!${normal}\n"
	echo "Press enter to quit.."
#Get Response and don't show the input as indicated by -s
	read -s Response
#If there is or isn't any input, exit
		if [[ ! -z $Response ]] || [[ -z $Response ]]; then {
		exit 1
		}
		fi
	}
	fi
}
FLOOR=1000;
CEILING=9999;
RANGE=$(($CEILING-$FLOOR+1));
RESULT=$RANDOM;
let "RESULT %= $RANGE";
RESULT=$(($RESULT+$FLOOR));
PORT=$RESULT
CheckSudo
Fstab
Banner
RemoveMOTD
sudo systemctl restart sshd
sudo apt-get install ufw -y
sudo ufw allow $PORT
sudo ufw allow $PORT/tcp
sudo ufw enable
sudo apt-get install fail2ban -y
CreateJail
sudo systemctl restart fail2ban -y
ChangePortInSSH
clear
echo -e "Please reboot your system now to secure it!\n\nYou must now log in through Port "${PORT}"!\n"
echo "Please run sudo nano /etc/ssh/sshd_config and append AllowUsers YourUsername to the file."
