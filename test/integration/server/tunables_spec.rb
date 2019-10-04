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

def check_mysql_conf(setting, config)
  describe file(MYSQL_CONF_FILE) do
    if config
      its("content") { should match setting }
    else
      its("content") { should_not match setting }
    end
  end
end

TUNABLES = {
  "character_set_server" => "utf8",
  "collation_server" => "utf8_general_ci",
  "lower_case_table_names" => 1,
  "back_log" => "128",
  "key_buffer_size" => "256M",
  "myisam_sort_buffer_size" => "8M",
  "myisam_repair_threads" => "1",
  "myisam_recover_options" => "OFF",
  "max_allowed_packet" => "16M",
  "max_connections" => "800",
  "max_connect_errors" => "10",
  "concurrent_insert" => "ALWAYS",
  "connect_timeout" => "10",
  "tmp_table_size" => "32M",
  "max_heap_table_size" => "32M",
  "bulk_insert_buffer_size" => "32M",
  "net_read_timeout" => "30",
  "net_write_timeout" => "30",
  "table_open_cache" => 128,
  "thread_cache_size" => 8,
  "thread_stack" => "256K",
  "sort_buffer_size" => "2M",
  "read_buffer_size" => "128K",
  "read_rnd_buffer_size" => "256K",
  "join_buffer_size" => "128K",
  "wait_timeout" => "180",
  "open_files_limit" => "102400",
  "sql_mode" => nil,
  "slave_compressed_protocol" => "OFF",
  "server_id" => 0,
  "log_bin" => "ON",
  "log_bin_trust_function_creators" => "",
  "relay_log" => nil,
  "relay_log_index" => nil,
  "log_slave_updates" => "",
  "sync_binlog" => 0,
  "read_only" => "",
  "log_error" => nil,
  "log_warnings" => "",
  "slow_query_log" => "ON",
  "log_queries_not_using_indexes" => "ON",
  "innodb_log_file_size" => "5M",
  "innodb_buffer_pool_size" => "128M",
  "innodb_buffer_pool_instances" => "1",
  "innodb_data_file_path" => "ibdata1:10M:autoextend",
  "innodb_flush_method" => "",
  "innodb_log_buffer_size" => "8M",
  "innodb_write_io_threads" => "4",
  "innodb_io_capacity" => "200",
  "innodb_file_per_table" => "ON",
  "innodb_lock_wait_timeout" => "60",
  "innodb_rollback_on_timeout" => "OFF",
  "innodb_thread_concurrency" => 4,
  "innodb_commit_concurrency" => 4,
  "innodb_read_io_threads" => 4,
  "innodb_flush_log_at_trx_commit" => "1",
  "innodb_support_xa" => "ON",
  "innodb_table_locks" => "ON",
  "innodb_doublewrite" => "ON",
  "transaction_isolation" => nil,
  "query_cache_limit" => "1M",
  "query_cache_size" => "16M",
  "long_query_time" => 2,
  "expire_logs_days" => 10,
  "max_binlog_size" => "100M",
  "binlog_cache_size" => "32K",
  "innodb_file_format" => "Barracuda",
  "innodb_large_prefix" => "ON",
}.freeze

TUNABLES.each_pair do |variable, value|
  check_mysql_variable(variable, value)
end

CONFIG_SETTINGS = {
  "skip_slave_start" => true,
  "skip-name-resolve" => false,
  "skip-character-set-client-handshake" => false,
}.freeze

CONFIG_SETTINGS.each do |setting, config|
  check_mysql_conf(setting, config)
end
