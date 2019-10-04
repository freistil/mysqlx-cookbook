# frozen_string_literal: true

#
# Cookbook Name:: mysql
# Attributes:: server
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

# Probably driven from wrapper cookbooks, environments, or roles.
# Keep in this namespace for backwards compat
default["mysqlx"]["bind_address"] =
  if node.attribute?("cloud") && !node["cloud"].nil? &&
      node["cloud"]["local_ipv4"]
    node["cloud"]["local_ipv4"]
  else
    node["ipaddress"]
  end
default["mysqlx"]["port"]                       = 3306
default["mysqlx"]["nice"]                       = 0

# eventually remove?  where is this used?
if attribute?("ec2")
  default["mysqlx"]["ec2_path"]    = "/mnt/mysql"
  default["mysqlx"]["ebs_vol_dev"] = "/dev/sdi"
  default["mysqlx"]["ebs_vol_size"] = 50
end

# actual configs start here
default["mysqlx"]["auto-increment-increment"]        = 1
default["mysqlx"]["auto-increment-offset"]           = 1

default["mysqlx"]["allow_remote_root"]               = false
default["mysqlx"]["remove_anonymous_users"]          = false
default["mysqlx"]["remove_test_database"]            = false
default["mysqlx"]["root_network_acl"]                = nil
default["mysqlx"]["tunable"]["character_set_server"] = "utf8"
default["mysqlx"]["tunable"]["collation_server"]     = "utf8_general_ci"
default["mysqlx"]["tunable"]["lower_case_table_names"] = 1
default["mysqlx"]["tunable"]["back_log"] = "128"
default["mysqlx"]["tunable"]["key_buffer_size"]           = "256M"
default["mysqlx"]["tunable"]["myisam_sort_buffer_size"]   = "8M"
default["mysqlx"]["tunable"]["myisam_max_sort_file_size"] =
  "9223372036854775807"
default["mysqlx"]["tunable"]["myisam_repair_threads"]     = "1"
default["mysqlx"]["tunable"]["myisam_recover_options"] = "OFF"
default["mysqlx"]["tunable"]["max_allowed_packet"]   = "16M"
default["mysqlx"]["tunable"]["max_connections"]      = "800"
default["mysqlx"]["tunable"]["max_connect_errors"]   = "10"
default["mysqlx"]["tunable"]["concurrent_insert"]    = "ALWAYS"
default["mysqlx"]["tunable"]["connect_timeout"]      = "10"
default["mysqlx"]["tunable"]["tmp_table_size"]       = "32M"
default["mysqlx"]["tunable"]["max_heap_table_size"] =
  node["mysqlx"]["tunable"]["tmp_table_size"]
default["mysqlx"]["tunable"]["bulk_insert_buffer_size"] =
  node["mysqlx"]["tunable"]["tmp_table_size"]
default["mysqlx"]["tunable"]["net_read_timeout"]     = "30"
default["mysqlx"]["tunable"]["net_write_timeout"]    = "30"
default["mysqlx"]["tunable"]["table_cache"]          = "128" # deprecated
default["mysqlx"]["tunable"]["table_open_cache"] =
  node["mysqlx"]["tunable"]["table_cache"]
default["mysqlx"]["tunable"]["thread_cache_size"]    = 8
default["mysqlx"]["tunable"]["thread_stack"]         = "256K"
default["mysqlx"]["tunable"]["sort_buffer_size"]     = "2M"
default["mysqlx"]["tunable"]["read_buffer_size"]     = "128K"
default["mysqlx"]["tunable"]["read_rnd_buffer_size"] = "256K"
default["mysqlx"]["tunable"]["join_buffer_size"]     = "128K"
default["mysqlx"]["tunable"]["wait_timeout"]         = "180"
default["mysqlx"]["tunable"]["open_files_limit"]     = "4096"

default["mysqlx"]["tunable"]["sql_mode"] = nil

default["mysqlx"]["tunable"]["skip-character-set-client-handshake"] = false
default["mysqlx"]["tunable"]["skip-name-resolve"]                   = false

default["mysqlx"]["tunable"]["slave_compressed_protocol"] = 0

default["mysqlx"]["tunable"]["server_id"] = 0
default["mysqlx"]["tunable"]["log_bin"] = false
default["mysqlx"]["tunable"]["log_bin_trust_function_creators"] = false

default["mysqlx"]["tunable"]["relay_log"]                       = nil
default["mysqlx"]["tunable"]["relay_log_index"]                 = nil
default["mysqlx"]["tunable"]["log_slave_updates"]               = false

default["mysqlx"]["tunable"]["replicate_do_db"]             = nil
default["mysqlx"]["tunable"]["replicate_do_table"]          = nil
default["mysqlx"]["tunable"]["replicate_ignore_db"]         = nil
default["mysqlx"]["tunable"]["replicate_ignore_table"]      = nil
default["mysqlx"]["tunable"]["replicate_wild_do_table"]     = nil
default["mysqlx"]["tunable"]["replicate_wild_ignore_table"] = nil

default["mysqlx"]["tunable"]["sync_binlog"]                     = 0
default["mysqlx"]["tunable"]["skip_slave_start"]                = false
default["mysqlx"]["tunable"]["read_only"]                       = false

default["mysqlx"]["tunable"]["log_error"]                       = nil
default["mysqlx"]["tunable"]["log_warnings"]                    = false
default["mysqlx"]["tunable"]["slow_query_log"]                  = true
default["mysqlx"]["tunable"]["log_queries_not_using_indexes"]   = true
default["mysqlx"]["tunable"]["log_bin_trust_function_creators"] = false

default["mysqlx"]["tunable"]["innodb_file_format"] = "Barracuda"
default["mysqlx"]["tunable"]["innodb_log_file_size"]            = "5M"
default["mysqlx"]["tunable"]["innodb_buffer_pool_size"]         = "128M"
default["mysqlx"]["tunable"]["innodb_buffer_pool_instances"]    = "4"
default["mysqlx"]["tunable"]["innodb_data_file_path"] = "ibdata1:10M:autoextend"
default["mysqlx"]["tunable"]["innodb_flush_method"]             = false
default["mysqlx"]["tunable"]["innodb_log_buffer_size"]          = "8M"
default["mysqlx"]["tunable"]["innodb_write_io_threads"]         = "4"
default["mysqlx"]["tunable"]["innodb_io_capacity"]              = "200"
default["mysqlx"]["tunable"]["innodb_file_per_table"]           = true
default["mysqlx"]["tunable"]["innodb_lock_wait_timeout"]        = "60"
default["mysqlx"]["tunable"]["innodb_rollback_on_timeout"]      = false
default["mysqlx"]["tunable"]["innodb_large_prefix"] = "ON"
if node["cpu"].nil? || node["cpu"]["total"].nil?
  default["mysqlx"]["tunable"]["innodb_thread_concurrency"]       = "8"
  default["mysqlx"]["tunable"]["innodb_commit_concurrency"]       = "8"
  default["mysqlx"]["tunable"]["innodb_read_io_threads"]          = "8"
else
  default["mysqlx"]["tunable"]["innodb_thread_concurrency"] =
    (node["cpu"]["total"].to_i * 2).to_s
  default["mysqlx"]["tunable"]["innodb_commit_concurrency"] =
    (node["cpu"]["total"].to_i * 2).to_s
  default["mysqlx"]["tunable"]["innodb_read_io_threads"] =
    (node["cpu"]["total"].to_i * 2).to_s
end
default["mysqlx"]["tunable"]["innodb_flush_log_at_trx_commit"] = "1"
default["mysqlx"]["tunable"]["innodb_support_xa"] = "ON"
default["mysqlx"]["tunable"]["innodb_table_locks"] = "ON"
default["mysqlx"]["tunable"]["skip-innodb-doublewrite"] = false

default["mysqlx"]["tunable"]["transaction-isolation"] = nil

default["mysqlx"]["tunable"]["query_cache_limit"]    = "1M"
default["mysqlx"]["tunable"]["query_cache_size"]     = "16M"

default["mysqlx"]["tunable"]["long_query_time"]      = 2
default["mysqlx"]["tunable"]["expire_logs_days"]     = 10
default["mysqlx"]["tunable"]["max_binlog_size"]      = "100M"
default["mysqlx"]["tunable"]["binlog_cache_size"]    = "32K"

default["mysqlx"]["tmpdir"] = ["/tmp"]

default["mysqlx"]["log_files_in_group"] = false
default["mysqlx"]["innodb_status_file"] = false

unless node["platform_family"] == "rhel" && node["platform_version"].to_i < 6
  # older RHEL platforms don't support these options
  default["mysqlx"]["tunable"]["event_scheduler"] = 0
  if node["mysqlx"]["tunable"]["log_bin"]
    default["mysqlx"]["tunable"]["binlog_format"] = "STATEMENT"
  end
end

# security options
# @see http://www.symantec.com/connect/articles/securing-mysql-step-step
# @see http://dev.mysql.com/doc/refman/5.7/en/server-options.html#option_mysqld_chroot
default["mysqlx"]["security"]["chroot"]                  = nil
# @see http://dev.mysql.com/doc/refman/5.7/en/server-options.html#option_mysqld_safe-user-create
default["mysqlx"]["security"]["safe_user_create"]        = nil
# @see http://dev.mysql.com/doc/refman/5.7/en/server-options.html#option_mysqld_secure-auth
default["mysqlx"]["security"]["secure_auth"]             = nil
# @see http://dev.mysql.com/doc/refman/5.7/en/server-options.html#option_mysqld_symbolic-links
default["mysqlx"]["security"]["skip_symbolic_links"]     = nil
# @see http://dev.mysql.com/doc/refman/5.7/en/server-options.html#option_mysqld_secure-file-priv
default["mysqlx"]["security"]["secure_file_priv"]        = nil
# @see http://dev.mysql.com/doc/refman/5.7/en/server-options.html#option_mysqld_skip-show-database
default["mysqlx"]["security"]["skip_show_database"]      = nil
# @see http://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_local_infile
default["mysqlx"]["security"]["local_infile"]            = nil
