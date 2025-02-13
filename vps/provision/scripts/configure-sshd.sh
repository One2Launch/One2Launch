#!/bin/bash

# harden SSH configuration
sed -i -e '/^\(#\)\?Port 22$/s/^#\?Port 22$/Port 2200/' /etc/ssh/sshd_config
sed -i -e '/^\(#\|\)PermitRootLogin/s/^.*$/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i -e '/^\(#\|\)PasswordAuthentication/s/^.*$/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i -e '/^\(#\|\)KbdInteractiveAuthentication/s/^.*$/KbdInteractiveAuthentication no/' /etc/ssh/sshd_config
sed -i -e '/^\(#\|\)ChallengeResponseAuthentication/s/^.*$/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
sed -i -e '/^\(#\|\)PubkeyAuthentication/s/^.*$/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i -e '/^\(#\|\)MaxAuthTries/s/^.*$/MaxAuthTries 4/' /etc/ssh/sshd_config
sed -i -e '/^\(#\|\)AllowTcpForwarding/s/^.*$/AllowTcpForwarding no/' /etc/ssh/sshd_config
sed -i -e '/^\(#\|\)PermitEmptyPasswords/s/^.*$/PermitEmptyPasswords no/' /etc/ssh/sshd_config
sed -i -e '/^\(#\|\)HostbasedAuthentication/s/^.*$/HostbasedAuthentication no/' /etc/ssh/sshd_config
sed -i -e '/^\(#\|\)UsePAM/s/^.*$/UsePAM no/' /etc/ssh/sshd_config
sed -i -e '/^\(#\|\)PermitUserEnvironment/s/^.*$/PermitUserEnvironment no/' /etc/ssh/sshd_config
sed -i -e '/^\(#\|\)X11Forwarding/s/^.*$/X11Forwarding no/' /etc/ssh/sshd_config
sed -i -e '/^\(#\|\)AllowAgentForwarding/s/^.*$/AllowAgentForwarding no/' /etc/ssh/sshd_config
sed -i -e '/^\(#\|\)AuthorizedKeysFile/s/^.*$/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config
sed -i -e '/^\(#\|\)MaxSessions/s/^.*$/MaxSessions 4/' /etc/ssh/sshd_config
sed -i '$a AllowUsers leen' /etc/ssh/sshd_config

# restart SSH service
systemctl restart sshd || systemctl restart ssh
