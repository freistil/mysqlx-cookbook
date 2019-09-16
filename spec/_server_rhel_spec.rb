# frozen_string_literal: true

require "spec_helper"

describe "mysqlx::_server_rhel.rb" do
  let(:centos5_run) do
    ChefSpec::Runner.new(
      platform: "centos",
      version: "5.9",
    ).converge(described_recipe)
  end
  let(:centos6_run) do
    ChefSpec::Runner.new(
      platform: "centos",
      version: "6.4",
    ).converge(described_recipe)
  end
  let(:ubuntu_1004_run) do
    ChefSpec::Runner.new(
      platform: "ubuntu",
      version: "10.04",
    ).converge(described_recipe)
  end
  let(:ubuntu_1204_run) do
    ChefSpec::Runner.new(
      platform: "ubuntu",
      version: "12.04",
    ).converge(described_recipe)
  end
end
