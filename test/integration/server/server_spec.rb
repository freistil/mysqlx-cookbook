describe service("mysql") do
  it { should be_running }
end

describe port(3306) do
  it { should be_listening }
end

SHOW_DATABASES_CMD = <<-COMMAND.freeze
  mysql --protocol socket -uroot -pilikerandompasswords -e 'show databases;'
COMMAND

describe command(SHOW_DATABASES_CMD) do
  its("exit_status") { should eq 0 }
  its("stdout") { should include "mysql_test" }
end
