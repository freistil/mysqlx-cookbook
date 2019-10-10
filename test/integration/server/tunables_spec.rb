# frozen_string_literal: true

MYSQL_ROOT_PASSWORD = "ilikerandompasswords"
MYSQL_CONF_FILE = "/etc/mysql/mysql.conf.d/mysqld.cnf"

def mysql_config_value(value)
  case value
  when /K$/
    value.chop.to_i * 1024
  when /M$/
    value.chop.to_i * 1024 * 1024
  else
    value
  end
end

def check_mysql_variable(variable, value)
  setting = mysql_config_value(value)
  describe mysql_session("root", MYSQL_ROOT_PASSWORD).
    query("show variables like '#{variable}'") do
    its("stdout") { should match("#{variable}\t#{setting}") }
  end
end

def check_mysql_conf(setting, value)
  describe file(MYSQL_CONF_FILE) do
    its("content") { should match "#{setting} = #{value}" }
  end
end

SYSTEM_VARIABLES = {
  "auto_increment_increment" => "1",
  "auto_increment_offset" => "1",
  "back_log" => "128",
  "binlog_cache_size" => "32K",
  "bulk_insert_buffer_size" => "32M",
  "character_set_server" => "utf8",
  "collation_server" => "utf8_general_ci",
  "concurrent_insert" => "ALWAYS",
  "connect_timeout" => "10",
  "expire_logs_days" => 10,
  "innodb_buffer_pool_instances" => "1",
  "innodb_buffer_pool_size" => "128M",
  "innodb_commit_concurrency" => 4,
  "innodb_data_file_path" => "ibdata1:10M:autoextend",
  "innodb_doublewrite" => "ON",
  "innodb_file_format" => "Barracuda",
  "innodb_file_per_table" => "ON",
  "innodb_flush_log_at_trx_commit" => "1",
  "innodb_flush_method" => "",
  "innodb_io_capacity" => "200",
  "innodb_large_prefix" => "ON",
  "innodb_lock_wait_timeout" => "60",
  "innodb_log_buffer_size" => "8M",
  "innodb_log_file_size" => "5M",
  "innodb_read_io_threads" => 4,
  "innodb_rollback_on_timeout" => "OFF",
  "innodb_support_xa" => "ON",
  "innodb_table_locks" => "ON",
  "innodb_thread_concurrency" => 4,
  "innodb_write_io_threads" => "4",
  "join_buffer_size" => "128K",
  "key_buffer_size" => "256M",
  "log_bin_trust_function_creators" => "",
  "log_bin" => "ON",
  "log_bin_basename" => "/var/lib/mysql/mysql-bin",
  "log_error" => nil,
  "log_queries_not_using_indexes" => "ON",
  "log_slave_updates" => "",
  "log_warnings" => "",
  "long_query_time" => 2,
  "lower_case_table_names" => 1,
  "max_allowed_packet" => "16M",
  "max_binlog_size" => "100M",
  "max_connect_errors" => "10",
  "max_connections" => "800",
  "max_heap_table_size" => "32M",
  "myisam_recover_options" => "OFF",
  "myisam_repair_threads" => "1",
  "myisam_sort_buffer_size" => "8M",
  "net_read_timeout" => "30",
  "net_write_timeout" => "30",
  "open_files_limit" => "102400",
  "query_cache_limit" => "1M",
  "query_cache_size" => "16M",
  "read_buffer_size" => "128K",
  "read_only" => "",
  "read_rnd_buffer_size" => "256K",
  "relay_log_index" => nil,
  "relay_log" => nil,
  "server_id" => 0,
  "slave_compressed_protocol" => "OFF",
  "slow_query_log" => "ON",
  "sort_buffer_size" => "2M",
  "sql_mode" => nil,
  "sync_binlog" => 0,
  "table_open_cache" => 128,
  "thread_cache_size" => 8,
  "thread_stack" => "256K",
  "tmp_table_size" => "32M",
  "transaction_isolation" => nil,
  "wait_timeout" => "180",
}.freeze

SYSTEM_VARIABLES.each_pair do |variable, value|
  check_mysql_variable(variable, value)
end

CONFIG_SETTINGS = {
  "skip_slave_start" => "OFF",
  "skip-name-resolve" => "OFF",
  "skip-character-set-client-handshake" => "OFF",
  "replicate_wild_ignore_table" => "tv_chef.test%",
}.freeze

CONFIG_SETTINGS.each do |setting, config|
  check_mysql_conf(setting, config)
end
