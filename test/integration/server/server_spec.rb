# frozen_string_literal: true

describe service("mysql") do
  it { should be_running }
end

describe port(3306) do
  it { should be_listening }
end

SHOW_DATABASES_CMD = <<-COMMAND
  mysql --protocol socket -uroot -pilikerandompasswords -e 'show databases;'
COMMAND

describe command(SHOW_DATABASES_CMD) do
  its("exit_status") { should eq 0 }
  its("stdout") { should include "mysql_test" }
end

describe file("/root/.my.cnf") do
  it { should exist }
  its("owner") { should eq "root" }
  its("group") { should eq "root" }
  its("mode") { should eq 0o600 }
  its("content") { should match("password=\"ilikerandompasswords\"") }
end
