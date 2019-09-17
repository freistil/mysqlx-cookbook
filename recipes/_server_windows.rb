# frozen_string_literal: true

require "win32/service"

ENV["PATH"] += ";#{node['mysqlx']['windows']['bin_dir']}"
package_file = File.join(Chef::Config[:file_cache_path],
                         node["mysqlx"]["windows"]["package_file"])
install_dir = win_friendly_path(node["mysqlx"]["windows"]["basedir"])

windows_path node["mysqlx"]["windows"]["bin_dir"] do
  action :add
end

remote_file package_file do
  source node["mysqlx"]["windows"]["url"]
  not_if { ::File.exist?(package_file) }
end

windows_package node["mysqlx"]["windows"]["packages"].first do
  source package_file
  options "INSTALLDIR=\"#{install_dir}\""
  notifies :run, "execute[install mysql service]", :immediately
end

my_ini_path = File.join(node["mysqlx"]["windows"]["bin_dir"], "my.ini")
service_name = node["mysqlx"]["server"]["service_name"]
mysqld_exe = File.join(node["mysqlx"]["windows"]["bin_dir"], "mysqld.exe")

template "my.ini" do
  path my_ini_path
  source "my.ini.erb"
  notifies :restart, "service[mysql]"
end

execute "install mysql service" do
  command "\"#{mysqld_exe}\" --install \"#{service_name}\" " \
          "--defaults-file=\"#{my_ini_path}\""
  not_if { ::Win32::Service.exists?(service_name) }
end

service "mysql" do
  service_name node["mysqlx"]["server"]["service_name"]
  action       %i[enable start]
end

mysqladmin_bin = node["mysqlx"]["windows"]["mysqladmin_bin"]
root_password = node["mysqlx"]["server_root_password"]

execute "assign-root-password" do
  command "\"#{mysqladmin_bin}\" -u root password #{root_password}"
  action :run
  not_if { node["mysqlx"]["root_password_set"] }
  notifies :run, "ruby_block[root-password-set]", :immediately
end

ruby_block "root-password-set" do
  block do
    node.normal["mysqlx"]["root_password_set"] = true
  end
  action :nothing
end

template grants_path do
  source "grants.sql.erb"
  action :create
  notifies :run, "execute[mysql-install-privileges]", :immediately
end

mysql_bin = node["mysqlx"]["windows"]["mysql_bin"]
password_option = root_password.empty? ? "" : "-p#{root_password}"

execute "mysql-install-privileges" do
  command "\"#{mysql_bin}\" -u root \"#{password_option}\" < \"#{grants_path}\""
  action :nothing
end
