# frozen_string_literal: true

include_recipe "yum::epel" if platform_family?("rhel")

include_recipe "mysqlx::client"
