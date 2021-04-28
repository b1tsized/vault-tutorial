# Alternate Auth Methods And SSH Secrets

### _Work in progress_

## Enabling GitHub As An Auth Method

1. Login to vault server

2. Enable github as an auth method

    `vault auth enable github`

3. Connect your ogranization to vault

    `vault write auth/github/config organization={{organization-name}}`

4. Create the policy file

    `sudo vim github-eng.hcl`

5. Import the policy into Vault

    `vault policy write github-eng github-eng.hcl`

6. Map your teams to a policy 

    `vault write auth/github/map/teams/{{team-name}} value={{policy}}`

7. Go to [github.com](https://github.com)

8. In the upper-right corner of any page, click your profile photo, then click *Settings*

9. In the left sidebar, click *Developer Settings*

10. In the left sidebar, click *Personal Access Tokens*

11. Click *Generate new Token*

12. Give your token a descriptive name

13. Select the scopes, or permissions, you'd like to grant this token. This token should have `read:org`

    > _*IMPORTANT NOTE:*_ Vault does not support an OAuth workflow to generate GitHub tokens, so does not act as a GitHub application. As a result, this method uses personal access tokens. An important consequence is that any valid GitHub access token with the read:org scope can be used for authentication. If such a token is stolen from a third party service, and the attacker is able to make network calls to Vault, they will be able to log in as the user that generated the access token. When using this method it is a good idea to ensure that access to Vault is restricted at a network level rather than public. If these risks are unacceptable to you, you should use a different method.
  
14. Click *Generate Token*

15. Copy that token and keep it in a secured place

16. Login to vault using github crednetials using the token you just created

    `vault login -method=github`

17. If you'd like to disable github as an auth method, then run the following commands

    `vault token revoke -mode path auth/github`

    `vault auth disable github`


## Enabling Username & Password For Auth Method

1. Enable user and password logins

    `vault auth enable userpass`

2. Create a new user policy

    `sudo vim admins.hcl`

3. Import that new admin policy

    `vault policy write admins admins.hcl`

4. Create a new user using the following method

    `vault write auth/userpass/users/{{username}} \`

    `password={{password}} \`

    `policies=admins`

5. Login to vault using the username and password we just created

    `vault login -method=userpass \`

    `username={{username}} \`

    `password={{password}}`

6. Log back into the admin account

7. Delete the new user using the following command

    `vault delete auth/userpass/users/{{username}}`

## Adding SSH As A Secret

1. Enable SSH as a Secret

    `vault secrets enable ssh`

2. Enable the role for SSH using OTP

    `vault write ssh/roles/otp_role key_type=otp \`
    `default_user=ubuntu \`
    `cidr_list=0.0.0.0/0`

3. Create a otp-policy.hcl file using the template provided

    `sudo vim otp-policy.hcl`

4. Write the policy into Vault

    `vault policy write otp-policy ./otp-policy.hcl`

5. Create a user to be able to login using the otp policy

    `vault write auth/userpass/users/{{username}} password="{{password}}" policies="otp-policy"`

6. SSH into your server you'd like to add

7. Download the Vault SSH Helper

    `wget https://releases.hashicorp.com/vault-ssh-helper/0.2.1/vault-ssh-helper_0.2.1_linux_amd64.zip`

8. Unzip the helper

    `sudo unzip -q vault-ssh-helper_0.2.1_linux_amd64.zip -d /usr/local/bin`

9. Change permissions of the helper

    `sudo chmod 0755 /usr/local/bin/vault-ssh-helper`

10. Change ownership of the helper

    `sudo chown root:root /usr/local/bin/vault-ssh-helper`

11. Make a dir for the helper service

    `sudo mkdir /etc/vault-ssh-helper.d/`

12. Make a new config file inside of that folder using the template supplied

    `sudo vim /etc/vault-ssh-helper.d/config.hcl`

13. Open the PAM Config to edit it

    `sudo vim /etc/pam.d/sshd`

14. Edit the standard Unix Authentication section to look like the following

    ># Standard Un*x authentication.
    # @include common-auth
    auth requisite pam_exec.so quiet expose_authtok log=/var/log/vault-ssh.log /usr/
    local/bin/vault-ssh-helper -config=/etc/vault-ssh-helper.d/config.hcl
    auth optional pam_unix.so not_set_pass use_first_pass nodelay

15. Save the file

16. Open your sshd_config

    `sudo vim /etc/ssh/sshd_config`

17. Restart the sshd service

    `sudo systemctl restart sshd`

18. On the Vault server login using that username and password previously set

    `vault login -method=userpass username={{username}} password={{password}}`

19. We're going to now get our token for that server

    `vault write ssh/creds/otp_role ip={{ip-address}}`

20. Copy the key displayed in the output

21. From the Vault server try and ssh to the server

    `ssh ubuntu@{{ip-address}}`

22. When it asks for password enter the key given to you in the previous step

23. You've now successfully used Vault to login to a server
