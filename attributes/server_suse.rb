# frozen_string_literal: true

case node["platform_family"]
when "suse"
  default["mysqlx"]["data_dir"] = "/var/lib/mysql"
  default["mysqlx"]["server"]["service_name"] = "mysql"
  default["mysqlx"]["server"]["server"]["packages"] = %w[mysql-community-server]
  default["mysqlx"]["server"]["basedir"] = "/usr"
  default["mysqlx"]["server"]["root_group"] = "root"
  default["mysqlx"]["server"]["mysqladmin_bin"] = "/usr/bin/mysqladmin"
  default["mysqlx"]["server"]["mysql_bin"] = "/usr/bin/mysql"
  default["mysqlx"]["server"]["conf_dir"] = "/etc"
  default["mysqlx"]["server"]["confd_dir"] = "/etc/mysql/conf.d"
  default["mysqlx"]["server"]["socket"] = "/var/run/mysql/mysql.sock"
  default["mysqlx"]["server"]["pid_file"] = "/var/run/mysql/mysqld.pid"
  default["mysqlx"]["server"]["old_passwords"] = 1
  default["mysqlx"]["server"]["grants_path"] = "/etc/mysql/grants.sql"
end
