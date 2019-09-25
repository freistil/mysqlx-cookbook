# frozen_string_literal: true

node.override["mysqlx"]["server_debian_password"] = "ilikerandompasswords"
node.override["mysqlx"]["server_repl_password"]   = "ilikerandompasswords"
node.override["mysqlx"]["server_root_password"]   = "ilikerandompasswords"

include_recipe "mysqlx::ruby"
include_recipe "mysqlx::server"

mysql_connection = {
  host: "localhost",
  username: "root",
  password: node["mysqlx"]["server_root_password"],
}

mysql_database node["mysql_test"]["database"] do
  connection mysql_connection
  action :create
end

mysql_database_user node["mysql_test"]["username"] do
  connection    mysql_connection
  password      node["mysql_test"]["password"]
  database_name node["mysql_test"]["database"]
  host          "localhost"
  privileges    %i[select update insert delete]
  action        %i[create grant]
end

mysql_conn_args = format(
  "--user=root --password='%<password>s'",
  password: node["mysqlx"]["server_root_password"],
)

execute "create-sample-data" do
  command %(mysql #{mysql_conn_args} #{node['mysql_test']['database']} <<EOF
DROP TABLE IF EXISTS tv_chef;
CREATE TABLE tv_chef (name VARCHAR(32) PRIMARY KEY);
INSERT INTO tv_chef (name) VALUES ("Alison Holst");
INSERT INTO tv_chef (name) VALUES ("Nigella Lawson");
INSERT INTO tv_chef (name) VALUES ("Julia Child");
EOF
  )
end

user "unprivileged" do
  action :create
end
