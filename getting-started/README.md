# Getting started and installing Vault

**Pre-reqs**

- ***Domain*** 
- ***Ubuntu 20.04 Server***

- ***Packages***
  - ***unzip***
  - ***jq***

## Installing Consul Backend

  1. Download Consul
      `wget https://releases.hashicorp.com/consul/1.9.1/consul_1.9.1_linux_amd64.zip`
  2. Unzip Consul
      `unzip consul_1.9.1_linux_amd64.zip`
  3. Move Consul to User Bin
      `sudo mv consul /usr/bin/`
  4. Verify Consul is usable
      `consul --version`
  5. Create Systemd Service for Consul
      `sudo nano /etc/systemd/system/consul.service`
  6. Copy in Contents of consul.service
  7. Save and exit file
  8. Create /etc directory for Consul
      `sudo mkdir /etc/consul.d`
  9. Make UI config file
      `sudo nano /etc/consul.d/ui.json`
  10. Copy contents of ui.json
  11. Save and exit file
  12. Reload the daemon
        `sudo systemctl daemon-reload`
  13. Start the consul Service
        `sudo systemctl start consul`
  14. Check status of the Service
        `sudo systemctl status consul`
  15. Enable Consul as a service upon reboot
        `sudo systemctl enable consul`

## Creating a cert for the server

  1. Installing Certbot
      `sudo apt install certbot`
  2. Get cert for subdomain of server
      `sudo certbot certonly --standalone -d {{subdomain.example.com}}`
  3. Make note of folder locations listen in results
      Example: `/etc/letsencrypt/live/{{subdomain.example.com}}/fullchain.pem`
               `/etc/letsencrypt/live/{{subdomain.example.com}}/privkey.pem`


## Install Hashicorp Vault

  1. Download Hashicorp Vault
      `wget https://releases.hashicorp.com/vault/1.6.1/vault_1.6.1_linux_amd64.zip`
  2. Unzip Vault
      `unzip vault_1.6.1_linux_amd64.zip`
  3. Move Vault to User Bin
      `sudo mv vault /usr/bin/`
  4. Verify Vault is usable
      `vault --version`
  5. Make Vault directory
      `sudo mkdir /etc/vault`
  6. Create the config file for Vault
      `sudo nano /etc/vault/config.hcl`
  7. Copy contents of config.hcl and replace pathways for certs and add server IP
      *Note: This config uses port 8200 for all communication with vault to change it change the port specified in the config*
  8. Create the Vault service
      `sudo nano /etc/systemd/system/vault.service`
  9. Copy contents of the vault.service file
  10. Reload the daemon
        `sudo systemctl daemon-reload`
  11. Export the Vault Address value
        `export VAULT_ADDR=*"https://{{subdomain.example.com}}*:8200"`
  12. Set value in bashrc to reload on reboot
        `echo "export VAULT_ADDR=*https://{{subdomain.example.com}}*:8200" >> ~/.bashrc`
  13. Enable vault autocomplete
        `vault -autocomplete-install`
        `complete -C /usr/bin/vault vault`
  14. Start Vault
        `sudo systemctl start vault`
  15. Verify status of Vault
        `sudo systemctl status vault`
  16. Enable Vault upon restart
        `sudo systemctl enable vault`
  17. Initialize the Vault
        `vault operator init`
  18. Save the unseal keys and token. **These are only generated once and should be saved in a secure location.**
  19. Unlock the vault by entering in 3 keys you'll need to use the following command 3 times
        `vault operator unseal`
  20. Check to see the vaults sealed status sealed = false means that the vault is unsealed
        `vault status`
  21. Login via auth Token
        `vault login`
  22. You've successfully logged in for the first time. Join me in other tutorials for more information on Vault.