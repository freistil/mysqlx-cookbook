# frozen_string_literal: true

#
# Cookbook Name:: mysql
# Attributes:: client
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

::Chef::Node.send(:include, Freistil::Cookbook::Mysqlx::Helpers)

case node["platform_family"]
when "rhel", "fedora"
  default["mysql"]["client"]["packages"] = %w[mysql mysql-devel]
when "suse"
  default["mysql"]["client"]["packages"] =
    %w[mysql-community-server-client libmysqlclient-devel]
when "debian"
  default["mysql"]["client"]["packages"] = %w[mysql-client libmysqlclient-dev]
when "freebsd"
  default["mysql"]["client"]["packages"] = %w[mysql55-client]
when "windows"
  default["mysql"]["client"]["version"] = "6.0.2"
  default["mysql"]["client"]["arch"] = "win32"
  default["mysql"]["client"]["package_file"] = format(
    "mysql-connector-c-%<version>s-%<arch>s.msi",
    version: node["mysql"]["client"]["version"],
    arch: node["mysql"]["client"]["arch"],
  )
  default["mysql"]["client"]["url"] = <<-URL
    http://www.mysql.com/get/Downloads/Connector-C/#{mysql['client']['package_file']}/from/http://mysql.mirrors.pair.com/
  URL
  default["mysql"]["client"]["packages"] = [
    "MySQL Connector C #{mysql['client']['version']}",
  ]
  program_dir = if node["kernel"]["machine"] == "x86_64"
                  "Program Files"
                else
                  "Program Files (x86)"
                end
  default["mysql"]["client"]["basedir"] = File.join(
    ENV["SYSTEMDRIVE"],
    program_dir,
    "MySQL",
    node["mysql"]["client"]["packages"].first,
  )
  default["mysql"]["client"]["lib_dir"] =
    File.join(node["mysql"]["client"]["basedir"], "lib/opt")
  default["mysql"]["client"]["bin_dir"] =
    File.join(node["mysql"]["client"]["basedir"], "bin")
  default["mysql"]["client"]["ruby_dir"] = RbConfig::CONFIG["bindir"]
when "mac_os_x"
  default["mysql"]["client"]["packages"] = %w[mysql-connector-c]
else
  default["mysql"]["client"]["packages"] = %w[mysql-client libmysqlclient-dev]
end
