# frozen_string_literal: true

if node["platform_family"] == "windows"
  # server attributes
  default["mysql"]["server"]["grants_path"] = File.join(
    node["mysql"]["windows"]["conf_dir"],
    "grants.sql",
  )
  default["mysql"]["server"]["service_name"] = "mysql"
  default["mysql"]["server"]["slow_query_log"] = 1

  # windows attributes
  default["mysql"]["windows"]["version"] = "5.5.34"
  default["mysql"]["windows"]["arch"] =
    node["kernel"]["machine"] == "x86_64" ? "winx64" : "win32"
  package_file = "mysql-%<version>s-%<arch>s.msi".format(
    node["mysql"]["windows"]["version"],
    node["mysql"]["windows"]["arch"],
  )
  default["mysql"]["windows"]["package_file"] = package_file
  default["mysql"]["windows"]["packages"] = ["MySQL Server 5.5"]
  default["mysql"]["windows"]["url"] =
    "http://dev.mysql.com/get/Downloads/MySQL-5.5/#{package_file}"
  program_dir = if node["kernel"]["machine"] == "x86_64"
                  "Program Files"
                else
                  "Program Files (x86)"
                end
  default["mysql"]["windows"]["programdir"] = program_dir
  default["mysql"]["windows"]["basedir"] = File.join(
    ENV["SYSTEMDRIVE"],
    program_dir,
    "MySQL",
    node["mysql"]["windows"]["packages"].first,
  )
  default["mysql"]["windows"]["data_dir"] = File.join(
    ENV["ProgramData"],
    "MySQL",
    node["mysql"]["windows"]["packages"].first,
    "Data",
  )
  default["mysql"]["windows"]["bin_dir"] = File.join(
    node["mysql"]["windows"]["basedir"],
    "bin",
  )
  default["mysql"]["windows"]["mysqladmin_bin"] = File.join(
    node["mysql"]["windows"]["bin_dir"],
    "mysqladmin",
  )
  default["mysql"]["windows"]["mysql_bin"] = File.join(
    node["mysql"]["windows"]["bin_dir"],
    "mysql",
  )
  default["mysql"]["windows"]["conf_dir"] = node["mysql"]["windows"]["basedir"]
  default["mysql"]["windows"]["old_passwords"] = 0
end
