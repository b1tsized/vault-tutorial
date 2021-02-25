# Enabling your first secret and accessing it remotely


## Enabling your secret store using CLI

1. Log onto your vault server

2. Login to vault

	`vault login`

3. If vault is sealed run through your vault unseal process

	`vault operator unseal`

4. Let's enable kv secrets

	`vault secrets enable kv`

5. Let's create our first secret

	`vault kv put kv/secret foo=bar`

6. Let's add another secret

	`vault kv put kv/secret hello=world`

7. Now let's list out secrets

	`vault kv list kv/`

8. Let's get a value out of kv/secret

	`vault kv get kv/secret/`

10. We're going to retrieve in a json format

	`vault kv get -format=json kv/secret/ | jq`

11. Now let's decommision our secret

	`vault kv delete kv/secret`

12. Verify that it has been deleted

	`vault kv get kv/secret/`

13. We'll disable out kv secrets

	`vault secret disable kv/`

## Enabling secrets via the UI

1. Login to your vault server 

	**Example:** _https://vault.bitsized.tech:8200/ui_

2. Login using your token

3. Navigate to the Secrets Menu

4. Click 'Enable new engine'

5. Select 'KV' and press next

6. Choose a path name in this example I'm going to use bst/v2/ and leave version as 2

7. Click 'Create secret'

8. Add a path and enter a a secret and value

	_In this tutorial I'm going to use path secret wtih whatisit and thisisav2secret for my kv pair_

9. Let's go back to 'Secrets'

10. Click on 'Enable new engine' again

11. Select 'KV' and press next

12. Choose a path name in this example I'm going to use bstv1/ and change version to 1

13. Click 'Create secret'

14. Add a path and enter a a secret and value

	_In this tutorial I'm going to use path secret wtih whatisit and thisisav1secret for my kv pair_

## Accessing secrets from a remote machine

1. Open a new terminal on your local machine

2. Create a curl request to access your v1 secret

	**Example:** `curl -H 'X-Vault-Token: {token}' -X GET https://vault.bitsized.tech:8200/v1/bstv1/secret | jq`

3. Create a curl request to access your v2 secret

	**Example:** `curl -H 'X-Vault-Token: {token}' -X GET https://vault.bitsized.tech:8200/v1/bstv1/secret | jq`

4. Let's try with a different auth header

	**Example:** `curl -H 'Authorization:Bearer {token}' -X GET https://vault.bitsized.tech:8200/v1/bstv1/secret | jq`

5. Let's create new data with [payload.json](template/payload.json)

	`sudo nano payload.json`

6. Update the secret using that payload

	**Example:** `curl -H 'X-Vault-Token: {token}' -X POST https://vault.bitsized.tech:8200/v1/bstv1/secret --data @payload.json | jq`

7. Deleting our v1 secret and path

	**Example:** `curl -H 'X-Vault-Token: {token}' -X DELETE https://vault.bitsized.tech:8200/v1/bstv1/`

8. Refresh your browser and check to verify our v1 secret is gone