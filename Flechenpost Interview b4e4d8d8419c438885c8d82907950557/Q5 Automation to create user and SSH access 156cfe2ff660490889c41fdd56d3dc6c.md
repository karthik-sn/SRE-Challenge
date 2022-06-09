# Q5: Automation to create user and SSH access

For this automation script Ansible has been used to create user and grant SSH access.

Steps:

- List the servers that are to be targeted under the `Inventory file` in the parent directory
- User’s public SSH key is to be stored under the `{{ playbook_dir }}/keys/rsa_id.pub` directory
- Variable named `proposedAction` is used to either `grant` or `revoke` access to all the servers
- Command to call the playbook
    
    ```bash
    ansible-playbook playbook.yml -e "proposedAction=grant username=snk" -i invnetory
    ```
    
    Link to the Ansible playbook: [https://github.com/karthik-sn/SRE-Challenge/blob/cb8686e6384754357e066295356051d01cbbb76d/Ansible/playbook.yml](https://github.com/karthik-sn/SRE-Challenge/blob/cb8686e6384754357e066295356051d01cbbb76d/Ansible/playbook.yml)