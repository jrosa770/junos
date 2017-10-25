#!/usr/bin/env bash
ansible_junos_home="/usr/local/share/ansible/junos"
# If ansible Vault is used: 
# /usr/local/bin/ansible-playbook -vvvvv $ansible_junos_home/junos-cli-play.yml --vault-password-file $ansible_junos_home/auth/vault/vault_pass.py
#
# For full debug use -d. For normal run use -n
if [ $1 = "-d" ]
then
    /usr/local/bin/ansible-playbook -vvvv $ansible_junos_home/junos-cli-play.yml
elif [ $1 = "-n" ]
then
   /usr/local/bin/ansible-playbook $ansible_junos_home/junos-cli-play.yml
else                                
        echo " Options are -d or -n"
fi                                  