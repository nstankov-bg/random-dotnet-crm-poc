
resource "newrelic_api_access_key" "key" {
  account_id  = var.account_id
  key_type    = "INGEST"
  ingest_type = "LICENSE"
  name        = "APM Ingest License Key (blue)"
  notes       = "To be used with the APM agent for my test .net app"
  provisioner "local-exec" {
    command = "export NR_LICENSE_KEY=${newrelic_api_access_key.key.key}"
  }
}