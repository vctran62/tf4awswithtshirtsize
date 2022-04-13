output "keypair_pem" {
    description = "Private Key PEM"
    value = [tls_private_key.this.private_key_pem]
}