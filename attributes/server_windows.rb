# frozen_string_literal: true

if node["platform_family"] == "windows"
  # server attributes
  default["mysqlx"]["server"]["grants_path"] = File.join(
    node["mysqlx"]["windows"]["conf_dir"],
    "grants.sql",
  )
  default["mysqlx"]["server"]["service_name"] = "mysql"
  default["mysqlx"]["server"]["slow_query_log"] = 1

  # windows attributes
  default["mysqlx"]["windows"]["version"] = "5.5.34"
  default["mysqlx"]["windows"]["arch"] =
    node["kernel"]["machine"] == "x86_64" ? "winx64" : "win32"
  package_file = "mysql-%<version>s-%<arch>s.msi".format(
    node["mysqlx"]["windows"]["version"],
    node["mysqlx"]["windows"]["arch"],
  )
  default["mysqlx"]["windows"]["package_file"] = package_file
  default["mysqlx"]["windows"]["packages"] = ["MySQL Server 5.5"]
  default["mysqlx"]["windows"]["url"] =
    "http://dev.mysql.com/get/Downloads/MySQL-5.5/#{package_file}"
  program_dir = if node["kernel"]["machine"] == "x86_64"
                  "Program Files"
                else
                  "Program Files (x86)"
                end
  default["mysqlx"]["windows"]["programdir"] = program_dir
  default["mysqlx"]["windows"]["basedir"] = File.join(
    ENV["SYSTEMDRIVE"],
    program_dir,
    "MySQL",
    node["mysqlx"]["windows"]["packages"].first,
  )
  default["mysqlx"]["windows"]["data_dir"] = File.join(
    ENV["ProgramData"],
    "MySQL",
    node["mysqlx"]["windows"]["packages"].first,
    "Data",
  )
  default["mysqlx"]["windows"]["bin_dir"] = File.join(
    node["mysqlx"]["windows"]["basedir"],
    "bin",
  )
  default["mysqlx"]["windows"]["mysqladmin_bin"] = File.join(
    node["mysqlx"]["windows"]["bin_dir"],
    "mysqladmin",
  )
  default["mysqlx"]["windows"]["mysql_bin"] = File.join(
    node["mysqlx"]["windows"]["bin_dir"],
    "mysql",
  )
  default["mysqlx"]["windows"]["conf_dir"] =
    node["mysqlx"]["windows"]["basedir"]
  default["mysqlx"]["windows"]["old_passwords"] = 0
end
