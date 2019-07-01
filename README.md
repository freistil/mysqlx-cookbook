# mysqlx Cookbook

**Installs and configures MySQL client and server.**

mysqlx is a Chef cookbook for setting up MySQL. It started as a fork of the
`mysql` community cookbook ([sous-chefs/mysql](https://github.com/chef-cookbooks/mysql)) version 4.1.2. This was the
last version before its maintainers switched to a library cookbook approach.
This new approach using Chef resources introduced a lot of complexity and
its multi-instance setup is more or less obsolete given that there are
VMs and containers. That's why we decided to go back to the original
classic Chef code and bring it up to modern standards.

## Requirements

Chef 13.12+

## Platforms

- Ubuntu 16.04

Other platforms coming (back) soon.

## Usage

On client nodes, use the client (or default) recipe:

```javascript
{ "run_list": ["recipe[mysqlx::client]"] }
```

This will install the MySQL client libraries and development headers on the system.

On nodes which may use the `database` cookbook's mysql resources, also use the `ruby` recipe. This installs the mysql2 RubyGem in Chef's Ruby environment.

```javascript
{ "run_list": ["recipe[mysqlx::client]", "recipe[mysqlx::ruby]"] }
```

If you need to install the mysql Ruby library as a package for your system, override the client packages attribute in your node or role. For example, on an Ubuntu system:

```javascript
{
  "mysql": {
    "client": {
      "packages": ["mysql-client", "libmysqlclient-dev","ruby-mysql"]
    }
  }
}
```

This creates a resource object for the package and does the installation before other recipes are parsed. You'll need to have the C compiler and such (ie, build-essential on Ubuntu) before running the recipes, but we already do that when installing Chef :-).

On server nodes, use the server recipe:

```javascript
{ "run_list": ["recipe[mysqlx::server]"] }
```

On Debian and Ubuntu, this will preseed the `mysql-server` package with the randomly generated root password in the recipe file. On other platforms, it simply installs the required packages. It will also create an SQL file, `/etc/mysql/grants.sql`, that will be used to set up grants for the `root`, `repl` and `debian-sys-maint` users.

On EC2 nodes, use the `server_ec2` recipe and the MySQL data dir will be set up in the ephmeral storage.

```javascript
{ "run_list": ["recipe[mysqlx::server_ec2]"] }
```

When the `ec2_path` doesn't exist we look for a mounted filesystem (eg, EBS) and move the `data_dir` there.

The client recipe is already included by the `server` and `default` recipes.

## License & Authors

- Author:: Joshua Timberman (<joshua@opscode.com>)
- Author:: AJ Christensen (<aj@opscode.com>)
- Author:: Seth Chisamore (<schisamo@opscode.com>)
- Author:: Brian Bianco (<brian.bianco@gmail.com>)
- Author:: Jesse Howarth (<him@jessehowarth.com>)
- Author:: Andrew Crump (<andrew@kotirisoftware.com>)
- Author:: Christoph Hartmann (<chris@lollyrock.com>)
- Author:: Sean OMeara (<someara@opscode.com>)
- Author:: Jochen Lillich (<jochen@freistil.it>)

```text
Copyright:: 2009-2013 Opscode, Inc
Copyright:: 2019 freistil IT Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
