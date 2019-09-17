# frozen_string_literal: true

group "mysql" do
  action :create
end

user "mysql" do
  comment "MySQL Server"
  gid     "mysql"
  system  true
  home    node["mysqlx"]["data_dir"]
  shell   "/sbin/nologin"
end

node["mysqlx"]["server"]["packages"].each do |name|
  package name do
    action   :install
    notifies :start, "service[mysql]", :immediately
  end
end

#----

execute "mysql-install-db" do
  command "mysql_install_db --verbose --user=`whoami` " \
    "--basedir=\"$(brew --prefix mysql)\" " \
    "--datadir=#{node['mysqlx']['data_dir']} --tmpdir=/tmp "
  environment("TMPDIR" => nil)
  action      :run
  creates     "#{node['mysqlx']['data_dir']}/mysql"
end

# set the root password for situations that don't support pre-seeding.
# (eg. platforms other than debian/ubuntu & drop-in mysql replacements)
execute "assign-root-password mac_os_x" do
  command %("#{node['mysqlx']['mysqladmin_bin']}" -u root password
            '#{node['mysqlx']['server_root_password']}')
  action :run
  only_if %("#{node['mysqlx']['mysql_bin']}" -u root -e 'show databases;')
end
