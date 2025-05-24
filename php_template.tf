data "template_file" "index_php" {
  template = file("${path.module}/website/index.php.tpl")

  vars = {
    rds_endpoint = aws_db_instance.terracloud-rds-db.endpoint
    db_name      = aws_db_instance.terracloud-rds-db.db_name
    db_user      = aws_db_instance.terracloud-rds-db.username
    db_password  = aws_db_instance.terracloud-rds-db.password
  }
}

resource "local_file" "rendered_index_php" {
  content  = data.template_file.index_php.rendered
  filename = "${path.module}/website/rendered_index.php"
}
