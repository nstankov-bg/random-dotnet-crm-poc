output "id" {
  value = newrelic_api_access_key.key.id
}

output "key" {
  value     = newrelic_api_access_key.key.key
  sensitive = true
}
