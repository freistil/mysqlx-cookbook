# frozen_string_literal: true

case node["platform_family"]
when "mac_os_x"
  default["mysqlx"]["server"]["packages"]      = %w[mysql]
  default["mysqlx"]["basedir"]                 = "/usr/local/Cellar"
  default["mysqlx"]["data_dir"]                = "/usr/local/var/mysql"
  default["mysqlx"]["root_group"]              = "admin"
  default["mysqlx"]["mysqladmin_bin"]          = "/usr/local/bin/mysqladmin"
  default["mysqlx"]["mysql_bin"]               = "/usr/local/bin/mysql"
end
