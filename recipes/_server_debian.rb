# frozen_string_literal: true

#
# Preseeding data for Debian packages
#

directory "/var/cache/local/preseeding" do
  owner "root"
  group "root"
  mode 0o0755
  recursive true
end

template "/var/cache/local/preseeding/mysql-server.seed" do
  source "mysql-server.seed.erb"
  owner "root"
  group "root"
  mode 0o0600
  notifies :run, "execute[preseed mysql-server]", :immediately
end

execute "preseed mysql-server" do
  command "/usr/bin/debconf-set-selections " \
    "/var/cache/local/preseeding/mysql-server.seed"
  action  :nothing
end

#
# Installation
#

node["mysqlx"]["server"]["packages"].each do |name|
  package name do
    action :install
  end
end

node["mysqlx"]["server"]["directories"].each do |_key, value|
  directory value do
    owner     "mysql"
    group     "mysql"
    mode      0o0775
    action    :create
    recursive true
  end
end

service "mysql" do
  service_name "mysql"
  supports status: true, restart: true
  action %i[enable start]
end

template grants_path do
  source "grants.sql.erb"
  owner  "root"
  group  "root"
  mode   0o0600
  notifies :run, "execute[install-grants]"
end

cmd = install_grants_cmd
execute "install-grants" do
  command cmd
  action :nothing
end

template "/etc/mysql/debian.cnf" do
  source "debian.cnf.erb"
  owner "root"
  group "root"
  mode 0o0600
  notifies :restart, "service[mysql]"
end

# CAUTION: Setting up data_dir will only work on initial node converge!
# Data can NOT be moved around the filesystem by changing `data_dir`.
directory node["mysqlx"]["data_dir"] do
  owner     "mysql"
  group     "mysql"
  action    :create
  recursive true
end

template "/etc/apparmor.d/usr.sbin.mysqld" do
  source "usr.sbin.mysqld.erb"
  action :create
  notifies :reload, "service[apparmor-mysql]", :immediately
end

service "apparmor-mysql" do
  service_name "apparmor"
  action :nothing
  supports reload: true
end

execute "mysql-reload-systemd" do
  command "systemctl daemon-reload"
  action :nothing
end

directory "/etc/systemd/system/mysql.service.d" do
  action :create
  owner "root"
  group "root"
  mode 0o0755
end

template "/etc/systemd/system/mysql.service.d/chef.conf" do
  source "mysql.service.erb"
  owner "root"
  group "root"
  mode 0o0644
  notifies :run, "execute[mysql-reload-systemd]", :immediately
end

%w[mysql.cnf mysqldump.cnf].each do |conf|
  template "/etc/mysql/conf.d/#{conf}" do
    source "#{conf}.erb"
    owner "root"
    group "root"
    mode 0o644
    notifies :restart, "service[mysql]"
  end
end

%w[mysqld.cnf mysqld_safe_rsyslog.cnf].each do |conf|
  template "/etc/mysql/mysql.conf.d/#{conf}" do
    source "#{conf}.erb"
    owner "root"
    group "root"
    mode 0o644
    notifies :restart, "service[mysql]"
  end
end

template "/etc/mysql/my.cnf" do
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode 0o644
  manage_symlink_source false
  force_unlink true
  notifies :run, "bash[move mysql data to datadir]", :immediately
  notifies :restart, "service[mysql]"
end

bash "move mysql data to datadir" do
  user "root"
  code <<-MOVE_AND_RESTART
  /usr/sbin/service mysql stop &&
  mv /var/lib/mysql/* #{node['mysqlx']['data_dir']} &&
  /usr/sbin/service mysql start
  MOVE_AND_RESTART
  action :nothing
  only_if do
    subdir_count_source = File::Stat.new("/var/lib/mysql").nlink
    subdir_count_destination = File::Stat.new(node["mysqlx"]["data_dir"]).nlink

    node["mysqlx"]["data_dir"] != "/var/lib/mysql" &&
      subdir_count_source != 2 &&
      subdir_count_destination == 2
  end
end
