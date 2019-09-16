# frozen_string_literal: true

#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Author:: Sean OMeara (<schisamo@opscode.com>)
# Author:: freistil IT Ops (<cookbooks@freistil.it>)
#
# Copyright:: Copyright (c) 2011-2013 Opscode, Inc.
# Copyright:: Copyright (c) 2019 freistil IT Ltd
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

module Freistil
  module Cookbook
    module Mysqlx
      module Helpers
        def assign_root_password_cmd
          "/usr/bin/mysqladmin -u root " \
            "password #{node['mysql']['server_root_password']}"
        end

        def grants_path
          node["mysql"]["server"]["grants_path"]
        end

        def install_grants_cmd
          password_arg = if node["mysql"]["server_root_password"].empty?
                           ""
                         else
                           "-p#{node['mysql']['server_root_password']}"
                         end
          "/usr/bin/mysql -u root #{password_arg} < #{grants_path}"
        end
      end
    end
  end
end
