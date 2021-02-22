storage "consul" {
  address = "0.0.0.0:8300"
  path = "vault/"
}
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 0
  tls_cert_file = "/etc/letsencrypt/live/{{subdomain.example.com}}/fullchain.pem"
  tls_key_file = "/etc/letsencrypt/live/{{subdomain.example.com}}/privkey.pem"
}
ui = true
