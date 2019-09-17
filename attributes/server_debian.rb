# frozen_string_literal: true

case node["platform_family"]
when "debian"

  # Probably driven from wrapper cookbooks, environments, or roles.
  # Keep in this namespace for backwards compat
  default["mysqlx"]["data_dir"] = "/var/lib/mysql"

  default["mysqlx"]["server"]["packages"] = %w[mysql-server apparmor-utils]
  default["mysqlx"]["server"]["slow_query_log"] = 1
  default["mysqlx"]["server"]["slow_query_log_file"] =
    "/var/log/mysql/slow.log"

  # Platformisms.. filesystem locations and such.
  default["mysqlx"]["server"]["basedir"] = "/usr"
  default["mysqlx"]["server"]["tmpdir"] = ["/tmp"]

  default["mysqlx"]["server"]["directories"]["run_dir"] = "/var/run/mysqld"
  default["mysqlx"]["server"]["directories"]["log_dir"] = "/var/lib/mysql"
  default["mysqlx"]["server"]["directories"]["slow_log_dir"] = "/var/log/mysql"
  default["mysqlx"]["server"]["directories"]["confd_dir"] = "/etc/mysql/conf.d"
  default["mysqlx"]["server"]["directories"]["mysql_confd_dir"] =
    "/etc/mysql/mysql.conf.d"

  default["mysqlx"]["server"]["mysqladmin_bin"] = "/usr/bin/mysqladmin"
  default["mysqlx"]["server"]["mysql_bin"] = "/usr/bin/mysql"

  default["mysqlx"]["server"]["pid_file"] = "/var/run/mysqld/mysqld.pid"
  default["mysqlx"]["server"]["socket"] = "/var/run/mysqld/mysqld.sock"
  default["mysqlx"]["server"]["grants_path"] = "/etc/mysql/grants.sql"
  default["mysqlx"]["server"]["old_passwords"] = 1

  # wat
  default["mysqlx"]["tunable"]["innodb_adaptive_flushing"] = false
  default["mysqlx"]["server"]["skip_federated"] = false
end
