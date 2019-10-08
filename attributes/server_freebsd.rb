# frozen_string_literal: true

if node["platform_family"] == "freebsd"
  default["mysqlx"]["data_dir"] = "/var/db/mysql"
  default["mysqlx"]["server"]["packages"] = %w[mysql55-server]
  default["mysqlx"]["server"]["service_name"] = "mysql-server"
  default["mysqlx"]["server"]["basedir"] = "/usr/local"
  default["mysqlx"]["server"]["root_group"] = "wheel"
  default["mysqlx"]["server"]["mysqladmin_bin"] = "/usr/local/bin/mysqladmin"
  default["mysqlx"]["server"]["mysql_bin"] = "/usr/local/bin/mysql"
  default["mysqlx"]["server"]["conf_dir"] = "/usr/local/etc"
  default["mysqlx"]["server"]["confd_dir"] = "/usr/local/etc/mysql/conf.d"
  default["mysqlx"]["server"]["socket"] = "/tmp/mysqld.sock"
  default["mysqlx"]["server"]["pid_file"] = "/var/run/mysqld/mysqld.pid"
  default["mysqlx"]["server"]["old_passwords"] = 0
  default["mysqlx"]["server"]["grants_path"] = "/var/db/mysql/grants.sql"
  default["mysqlx"]["server"]["config_change_handler_source"] =
    "config_change_handler.erb"
  default["mysqlx"]["server"]["config_change_handler_cookbook"] = "mysqlx"
end
