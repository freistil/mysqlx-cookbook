# frozen_string_literal: true

if node["platform_family"] == "rhel"
  # Probably driven from wrapper cookbooks, environments, or roles.
  # Keep in this namespace for backwards compat
  default["mysqlx"]["data_dir"] = "/var/lib/mysql"

  # switching logic to account for differences in platform native
  # package versions
  case node["platform_version"].to_i
  when 5
    default["mysqlx"]["server"]["packages"] = ["mysql-server"]
    default["mysqlx"]["server"]["log_slow_queries"] = "/var/log/mysql/slow.log"
  when 6
    default["mysqlx"]["server"]["packages"] = ["mysql-server"]
    default["mysqlx"]["server"]["slow_query_log"] = 1
    default["mysqlx"]["server"]["slow_query_log_file"] =
      "/var/log/mysql/slow.log"
  when 2013 # amazon linux
    default["mysqlx"]["server"]["packages"] = ["mysql-server"]
    default["mysqlx"]["server"]["slow_query_log"] = 1
    default["mysqlx"]["server"]["slow_query_log_file"] =
      "/var/log/mysql/slow.log"
  end

  # Platformisms.. filesystem locations and such.
  default["mysqlx"]["server"]["basedir"] = "/usr"
  default["mysqlx"]["server"]["tmpdir"] = ["/tmp"]

  default["mysqlx"]["server"]["directories"]["run_dir"] = "/var/run/mysqld"
  default["mysqlx"]["server"]["directories"]["log_dir"] = "/var/lib/mysql"
  default["mysqlx"]["server"]["directories"]["slow_log_dir"] = "/var/log/mysql"
  default["mysqlx"]["server"]["directories"]["confd_dir"] = "/etc/mysql/conf.d"

  default["mysqlx"]["server"]["mysqladmin_bin"] = "/usr/bin/mysqladmin"
  default["mysqlx"]["server"]["mysql_bin"] = "/usr/bin/mysql"

  default["mysqlx"]["server"]["pid_file"] = "/var/run/mysqld/mysqld.pid"
  default["mysqlx"]["server"]["socket"] = "/var/lib/mysql/mysql.sock"
  default["mysqlx"]["server"]["grants_path"] = "/etc/mysql/grants.sql"
  default["mysqlx"]["server"]["old_passwords"] = 1
  default["mysqlx"]["server"]["service_name"] = "mysqld"

  # RHEL/CentOS mysql package does not support this option.
  default["mysqlx"]["tunable"]["innodb_adaptive_flushing"] = false
  default["mysqlx"]["server"]["skip_federated"] = false
end
