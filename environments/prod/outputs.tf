output "flask_db_public_ip" {
  value = module.flask_db.this_public_ip
}

output "flask_app_public_ip" {
  value = module.flask_app.this_public_ip
}
