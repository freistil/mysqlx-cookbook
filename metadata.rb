# frozen_string_literal: true

name "mysqlx"
maintainer        "freistil IT Ltd"
maintainer_email  "cookbooks@freistil.it"
license           "Apache-2.0"
description       "Installs and configures MySQL client or server"
long_description  IO.read(File.join(File.dirname(__FILE__), "README.md"))
source_url "https://github.com/freistil/mysqlx-cookbook"
issues_url "https://github.com/freistil/mysqlx-cookbook/issues"

version "6.2.0"

chef_version ">= 13.12"

supports "ubuntu", "= 16.04"

depends "openssl", "~> 1.1"
depends "build-essential", "~> 8.1"
depends "homebrew", "~> 5.0"
depends "windows"
