require "spec_helper"

describe "mysqlx::server" do
  let(:ubuntu_1604_run) do
    ChefSpec::Runner.new(
      platform: "ubuntu",
      version: "16.04",
    ).converge(described_recipe)
  end

  it "includes _server_debian on Ubuntu 16.04" do
    expect(ubuntu_1604_run).to include_recipe("mysqlx::_server_debian")
  end
end
