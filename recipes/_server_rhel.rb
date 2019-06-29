node["mysql"]["server"]["packages"].each do |name|
  package name do
    action :install
  end
end

node["mysql"]["server"]["directories"].each do |_key, value|
  directory value do
    owner     "mysql"
    group     "mysql"
    mode      0o0755
    action    :create
    recursive true
  end
end

directory node["mysql"]["data_dir"] do
  owner     "mysql"
  group     "mysql"
  action    :create
  recursive true
end

template "initial-my.cnf" do
  path "/etc/my.cnf"
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode 0o0644
  notifies :start, "service[mysql-start]", :immediately
end

service "mysql-start" do
  service_name node["mysql"]["server"]["service_name"]
  action :nothing
end

execute "/usr/bin/mysql_install_db" do
  action :run
  creates "/var/lib/mysql/user.frm"
  only_if { node["platform_version"].to_i < 6 }
end

cmd = assign_root_password_cmd
execute "assign-root-password" do
  command cmd
  action :run
  only_if "/usr/bin/mysql -u root -e 'show databases;'"
end

template grants_path do
  source "grants.sql.erb"
  owner  "root"
  group  "root"
  mode   "0600"
  action :create
  notifies :run, "execute[install-grants]", :immediately
end

cmd = install_grants_cmd
execute "install-grants" do
  command cmd
  action :nothing
  notifies :restart, "service[mysql]", :immediately
end

template "final-my.cnf" do
  path "/etc/my.cnf"
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode 0o0644
  notifies :restart, "service[mysql]", :immediately
end

service "mysql" do
  service_name node["mysql"]["server"]["service_name"]
  supports     status: true, restart: true, reload: true
  action       %i[enable start]
end
