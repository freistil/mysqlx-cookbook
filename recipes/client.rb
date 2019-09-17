# frozen_string_literal: true

#
# Cookbook Name:: mysql
# Recipe:: client
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

::Chef::Recipe.send(:include, Freistil::Cookbook::Mysqlx::Helpers)

case node["platform"]
when "windows"
  package_file = node["mysqlx"]["client"]["package_file"]
  remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
    source node["mysqlx"]["client"]["url"]
    not_if { File.exist? "#{Chef::Config[:file_cache_path]}/#{package_file}" }
  end

  windows_package node["mysqlx"]["client"]["packages"].first do
    source "#{Chef::Config[:file_cache_path]}/#{package_file}"
  end
  ENV["PATH"] += ";#{node['mysqlx']['client']['bin_dir']}"
  windows_path node["mysqlx"]["client"]["bin_dir"] do
    action :add
  end
  def package(*args, &blk)
    windows_package(*args, &blk)
  end
when "mac_os_x"
  include_recipe "homebrew::default"
end

node["mysqlx"]["client"]["packages"].each do |name|
  package name
end

if platform_family?("windows")
  ruby_block "copy libmysql.dll into ruby path" do
    block do
      require "fileutils"
      libmysql_dll = File.join(
        node["mysqlx"]["client"]["lib_dir"],
        "libmysql.dll",
      )
      FileUtils.cp libmysql_dll, node["mysqlx"]["client"]["ruby_dir"]
    end
    not_if do
      File.exist?(
        File.join(node["mysqlx"]["client"]["ruby_dir"], "libmysql.dll"),
      )
    end
  end
end
