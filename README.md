# Junos Playbook for CLI


### Purpose

* Run multiple tasks out of one playbook
* Control of playbook functions via one common vars file
* Quick runs of routine tasks on Junos based devices
* Control of task via variable ```task:``` in ```play.vars.yml```. Example: ```task: banner``` will activate ```junos_config-banner.yml```.

## Folder Structure

```tree
├── archive
├── auth
│   ├── README.md
│   ├── secrets.yml
│   └── vault
│       └── vault_pass.py
├── backup
├── bin
│   └── run_junos-play.bash
├── config_partial
│   ├── basic_ebgp
│   ├── basic_ibgp
│   └── motd_banner.cfg
├── diffs
├── junos-cli-play.yml
├── junos-get_facts.yml
├── play_results
├── README.md
├── tasks
│   ├── junos_config-banner.yml
│   ├── junos_config-basic_ebgp.yml
│   ├── junos_config-basic_ibgp.yml
│   ├── junos_config-config_backup.yml
│   ├── junos_config-interface.yml
│   ├── junos_config-l3_interface.yml
│   ├── junos_config-static_rt.yml
│   ├── junos_config-system.yml
│   └── junos_config-vlan.yml
├── templates
│   ├── basic_ebgp.j2
│   └── basic_ibgp.j2
└── vars
    ├── play_vars.yml
    └── task_vars
        ├── banner.yml
        ├── basic_ebgp.yml
        ├── basic_ibgp.yml
        ├── interface.yml
        ├── jun_int_aggregate.yml
        ├── jun_l3_int_aggregate.yml
        ├── jun_static_aggregate.yml
        ├── l3_interface.yml
        ├── static_rt.yml
        ├── system.yml
        └── vlan.yml

```
### Dependencies

* Ansible (Of course...)
* Ansible Vault
* ansible-napalm (Provides better set based configuration file merge support than the native Ansible vyos_config module)

### Main Playbook

```yml
---
- hosts: junos
  gather_facts: yes
  connection: local
  ignore_errors: yes

  tasks:
  - name: obtain login credentials
    include_vars: ../auth/secrets.yml

  - name: define provider
    set_fact:
      provider:
        host: "{{ inventory_hostname }}"
        username: "{{ creds['username'] }}"
        password: "{{ creds['password'] }}"
        transport: netconf

  - name: obtain playbook variables
    include_vars: vars/play_vars.yml

  - name: Running task {{ task1 }}
    include: tasks/junos_config-{{ task1 }}.yml
    when: task1 is defined

  - name: Running task {{ task2 }}
    include: tasks/junos_config-{{ task2 }}.yml
    when: task2 is defined
```

### Variable Task Control

The task is controlled by the ```task[#]:``` variable in ```vars/play_vars.yml```. When ```vars/play_vars.yml``` is called by the variable ```task[#]:``` affects ```include: tasks/vyos_config-{{ task[#] }}.yml```, thus running the needed task.