# frozen_string_literal: true

#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2008-2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
::Chef::Recipe.send(:include, Freistil::Cookbook::Mysqlx::Helpers)

if Chef::Config[:solo]
  missing_attrs = %w[
    server_debian_password
    server_root_password
    server_repl_password
  ].reject { |attr| node["mysqlx"].key?(attr) }

  unless missing_attrs.empty?
    Chef::Application.fatal! "You must set #{missing_attrs.join(', ')} " \
    "in chef-solo mode. For more information, see " \
    "https://github.com/opscode-cookbooks/mysql#chef-solo-note"
  end
else
  node.normal_unless["mysqlx"]["server_debian_password"] = secure_password
  node.normal_unless["mysqlx"]["server_root_password"]   = secure_password
  node.normal_unless["mysqlx"]["server_repl_password"]   = secure_password
end

case node["platform_family"]
when "rhel"
  include_recipe "mysqlx::_server_rhel"
when "debian"
  include_recipe "mysqlx::_server_debian"
when "mac_os_x"
  include_recipe "mysqlx::_server_mac_os_x"
when "windows"
  include_recipe "mysqlx::_server_windows"
end
