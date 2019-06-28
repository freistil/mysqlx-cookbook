name "mysqlx"
maintainer        "freistil IT Ltd"
maintainer_email  "cookbooks@freistil.it"
license           "Apache-2.0"
description       "Installs and configures MySQL client or server"
long_description  IO.read(File.join(File.dirname(__FILE__), "README.md"))
source_url "https://github.com/freistil/mysqlx-cookbook"
issues_url "https://github.com/freistil/mysqlx-cookbook/issues"

version "5.0.0"

chef_version ">= 13.12"

supports "ubuntu"

depends "openssl",         "~> 1.1"
depends "build-essential", "~> 8.1"
depends "homebrew"
depends "windows"

recipe            "mysqlx", "Includes the client recipe to configure a client"
recipe            "mysqlx::client", "Installs packages required for mysql clients using run_action magic"
recipe            "mysqlx::server", "Installs packages required for mysql servers w/o manual intervention"
recipe            "mysqlx::server_ec2", "Performs EC2-specific mountpoint manipulation"
