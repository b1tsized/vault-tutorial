# Creating PKI & Enabling Cert Auth

- [Youtube Tutorial Pt. 3](https://youtu.be/_Nqx0guy5RY)

## Creating New Secrets

1. Login to your vault server 

	**Example:** _https://vault.bitsized.tech:8200/ui_

2. Login using your token

3. Navigate to the Secrets Menu

4. Click 'Enable new engine'

5. Select 'KV' and press next

6. Choose a path name 

	**Example:** _bstv2/ and leave version as 2_

7. Click 'Create secret'

8. Add a path and enter a a secret and value

	_In this tutorial I'm going to use path secret with canweaccess and yeswecan for my kv pair_

9. Let's go back to 'Secrets'

10. Click on 'Enable new engine' again

11. Select 'KV' and press next

12. Choose a path name 

	**Example:** _bstv1/ and change version to 1_

13. Click 'Create secret'

14. Add a path and enter a a secret and value

	_In this tutorial I'm going to use path secret with canweaccess and yeswecan for my kv pair_

15. Once last time go back to 'Secrets'

16. Click on 'Enable new engine' again

17. Select 'KV' and press next

12. Choose a path name 

	**Example:** _outside_cert/ and change version to 1_

13. Click 'Create secret'

14. Add a path and enter a a secret and value

	_In this tutorial I'm going to use path secret with canweaccess and nowecant for my kv pair_

## Enabling PKI, Generating Certs, And Signing Them Through The CLI

1. Enable pki secrets engine

	`vault secrets enable pki`

2. Set maximum TTL to 87600 hours

	`vault secrets tune --max-lease-ttl=87600h pki`

3. Generate a root certificate and save it

	_Note: Replace {{vault_address}} with your subdomain_

	`vault write -field=certificate pki/root/generate/internal \`

	`issuing_certificates="http://{{vault_address}}:8200/v1/pki/ca" \`

	`crl_distribution_points="https://{{vault_address}}:8200/v1/pki/crl"`

4. Enable pki_int path in pki

	`vault secrets enable -path=pki_int pki`

5. Set TTL of 43800h in the new path

	`vault secrets tune -max-lease-ttl=43800h pki_int`

6. Generate an intermediate cert and save to CSR

	`vault write -format=json pki_int/intermediate/generate/internal \`

	`common_name="{{vault_domain}} Intermediate Authority" \`

	`| jq -r '.data.csr' > pki_intermediate.csr `

7. Sign the intermediate cert with the root certificate

	`vault write -format=json pki/root/sign-intermediate \`

	`csr=@pki_intermediate.csr \`

	`format=pem_bundle ttl="43800h" \`

	`| jq -r '.data.certificate' > intermediate.cert.pem`

8. Once signed and generated import back into Vault

	`vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem`

9. Create a role for the domain in Vault that allows subdomains with a max TTL of 30 days

	_Note: Replace {{domain}} with the domain you are using_

	`vault write pki_int/roles/{{domain}}-dot-com \`

	`allowed_domains="{{domain}}" \`

	`allow_subdomains=true \`

	`max_ttl="720h"`

10. Generate certificates using the role created

	_Note: Replace {{domain}} with your domain name and {{vault.domain.com}} with your full subdomain_

	`vault write pki_int/issue/{{domain}}-dot-com common_name="{{vault.domain.com}}"`

11. Copy paste the resulting files into .pem formates. For this tutorial, I used vault_ca.pem, vault_issuing_ca.pem, vault_privkey.pem, and vault_ca_chain.pem.

## Enable Cert Auth And Attaching A Policy

1. Create a role for the cert auth and a place to store them

	`vault write pki_int/roles/vault-cert allow_any_name=true max_ttl="720h" generate_lease=true`

	_Note: You'll need to update the path of what secrets you want this certificate to be able to access_

	_Examples are at the bottom of the template_

2. Create an [hcl file](template/vault-cert.hcl) to use for your policy

	`sudo nano vault-cert.hcl`

3. Next write the policy for the vault cert

	`vault policy write vault-cert vault-cert.hcl`

4. Write and sign the current certs to be usable for authentication with Vault

	`vault write -format=json pki_int/issue/vault-cert common_name="vault-cert" | tee \`

	`>(jq -r .data.certificate > vault_ca.pem) \`

	`>(jq -r .data.issuing_ca > vault_issuing_ca.pem) \`

	`>(jq -r .data.private_key > vault_privkey.pem)`

5. Enable cert as an authentication method

	`vault auth enable cert`

6. Write the certificate to vault as a cert you can use for auth

	`vault write auth/cert/certs/vault-cert display_name=vault_cert policies=vault-cert certificate=@vault_ca.pem`

7. Test login using those certs with the following command

	`vault login -method=cert -client-cert=vault_ca.pem -client-key=vault_privkey.pem name=vault-cert`

8. We're going to retrieve our v2 secret in a json format

	`vault kv get -format=json bstv2/data/secret/ | jq`

10. We're going to retrieve our v1 in a json format

	`vault kv get -format=json bstv1/secret/ | jq`

11. Finally confirm the secret we didn't set in the vault-cert policy is unreachable

	`vault kv get -format=json outside_cert/secret/ | jq`