# Getting Started With Hashicorp Vault

Welcome to my github repo for getting started with Hashicorp Vault. 

Here you can find all of the necessary templates and step by step instructions in order ot set up Hashicorp Vault if you are learning or wanting to try it out. 

Feel free to check out the following sections. They'll be updated as I add more content to my video tutorials.

## Tutorials

1. [Setting up Consul & Hashicorp Vault](getting-started/)
    
    We'll walk through the basic set-up of your Vault Server. In this tutorial, we use an Ubuntu 20.04 T.2 Micro instance on AWS.
    
    - [Youtube Tutorial Pt. 1](https://www.youtube.com/watch?v=b_2lo30g0RU)
    - [Sys File Templates](getting-started/sys_file_templates)
        + [Consul Service File](getting-started/sys_file_templates/consul.service)
        + [Consul UI JSON](getting-started/sys_file_templates/ui.json)
        + [Vault Config File](getting-started/sys_file_templates/config.hcl)
        + [Vault Service File](getting-started/sys_file_templates/vault.service)

2. [Creating & Accessing Secrets](creating-and-accessing-secrets)
    
    In this section, we'll go over creation of secrets and accessing them via CLI, Web Interface, or API. 
    
    - [Youtube Tutorial Pt. 2](https://www.youtube.com/watch?v=LEpk376fc-U)
    - [Payload Template](creating-and-accessing-secrets/template/payload.json)

3. [Creating PKI & Enabling Cert Auth](creating-pki-and-enabling-cert-auth/README.md)
    
    We'll introduce you to making Vault a certificate authority, creating certificates, importing certificates, and enabling cert auth. We also touch on policies a bit to show how to restrict access or allow access to secrets.
    
    - [Youtube Tutorial Pt. 3](https://youtu.be/_Nqx0guy5RY)
    - [Vault Cert Policy Template](creating-pki-and-enabling-cert-auth/template/vault-cert.hcl)
