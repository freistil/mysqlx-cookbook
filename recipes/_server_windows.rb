require "win32/service"

ENV["PATH"] += ";#{node['mysql']['windows']['bin_dir']}"
package_file = File.join(Chef::Config[:file_cache_path],
                         node["mysql"]["windows"]["package_file"])
install_dir = win_friendly_path(node["mysql"]["windows"]["basedir"])

windows_path node["mysql"]["windows"]["bin_dir"] do
  action :add
end

remote_file package_file do
  source node["mysql"]["windows"]["url"]
  not_if { ::File.exist?(package_file) }
end

windows_package node["mysql"]["windows"]["packages"].first do
  source package_file
  options "INSTALLDIR=\"#{install_dir}\""
  notifies :run, "execute[install mysql service]", :immediately
end

my_ini_path = File.join(node["mysql"]["windows"]["bin_dir"], "my.ini")
service_name = node["mysql"]["server"]["service_name"]
mysqld_exe = File.join(node["mysql"]["windows"]["bin_dir"], "mysqld.exe")

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
  service_name node["mysql"]["server"]["service_name"]
  action       %i[enable start]
end

mysqladmin_bin = node["mysql"]["windows"]["mysqladmin_bin"]
root_password = node["mysql"]["server_root_password"]

execute "assign-root-password" do
  command "\"#{mysqladmin_bin}\" -u root password #{root_password}"
  action :run
  not_if { node["mysql"]["root_password_set"] }
  notifies :run, "ruby_block[root-password-set]", :immediately
end

ruby_block "root-password-set" do
  block do
    node.normal["mysql"]["root_password_set"] = true
  end
  action :nothing
end

template grants_path do
  source "grants.sql.erb"
  action :create
  notifies :run, "execute[mysql-install-privileges]", :immediately
end

mysql_bin = node["mysql"]["windows"]["mysql_bin"]
password_option = root_password.empty? ? "" : "-p#{root_password}"

execute "mysql-install-privileges" do
  command "\"#{mysql_bin}\" -u root \"#{password_option}\" < \"#{grants_path}\""
  action :nothing
end
