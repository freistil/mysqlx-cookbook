# frozen_string_literal: true

describe command("mysql --version") do
  its("exit_status") { should eq 0 }
end
