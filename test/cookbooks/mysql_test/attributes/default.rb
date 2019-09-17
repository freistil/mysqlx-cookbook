# frozen_string_literal: true

# Must be specified for chef-solo for successful re-converge
override["mysqlx"]["server_root_password"] = "ilikerandompasswords"

override["mysql_test"]["database"] = "mysql_test"
override["mysql_test"]["username"] = "test_user"
override["mysql_test"]["password"] = "neshFiapog"

override["mysqlx"]["bind_address"] = "localhost"
