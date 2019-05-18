#----
# Set up preseeding data for debian packages
#---
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

#----
# Install software
#----
node["mysql"]["server"]["packages"].each do |name|
  package name do
    action :install
  end
end

node["mysql"]["server"]["directories"].each do |_key, value|
  directory value do
    owner     "mysql"
    group     "mysql"
    mode      0o0775
    action    :create
    recursive true
  end
end

#----
# Grants
#----
template grants_file do
  source "grants.sql.erb"
  owner  "root"
  group  "root"
  mode   0o0600
  notifies :run, "execute[install-grants]", :immediately
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

#----
# data_dir
#----

# DRAGONS!
# Setting up data_dir will only work on initial node converge...
# Data will NOT be moved around the filesystem when you change data_dir
# To do that, we'll need to stash the data_dir of the last chef-client
# run somewhere and read it. Implementing that will come in "The Future"

directory node["mysql"]["data_dir"] do
  owner     "mysql"
  group     "mysql"
  action    :create
  recursive true
end

template "/etc/init/mysql.conf" do
  source "init-mysql.conf.erb"
  only_if { node["platform"] == "ubuntu" }
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
  notifies :run, "bash[move mysql data to datadir]", :immediately
  notifies :restart, "service[mysql]"
end

# don't try this at home
# http://ubuntuforums.org/showthread.php?t=804126
bash "move mysql data to datadir" do
  user "root"
  code <<-MOVE_AND_RESTART
  /usr/sbin/service mysql stop &&
  mv /var/lib/mysql/* #{node['mysql']['data_dir']} &&
  /usr/sbin/service mysql start
  MOVE_AND_RESTART
  action :nothing
  only_if { node["mysql"]["data_dir"] != "/var/lib/mysql" }
  only_if "[ `stat -c %h #{node['mysql']['data_dir']}` -eq 2 ]"
  not_if "[ `stat -c %h /var/lib/mysql/` -eq 2 ]"
end

service "mysql" do
  service_name "mysql"
  supports status: true, restart: true
  action %i[enable start]
end
