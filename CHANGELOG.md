# Changelog

This file is used to list changes made in each version of the mysqlx Chef cookbook.

## HEAD

* [NEW] Create /root/.my.cnf containing usable settings for admin tasks.

## v6.2.0

* [NEW] Configuration changes now don't trigger a service restart directly
  but run a config change handler script that can be replaced with any
  functionality required. For example, instead of restarting an active
  database, you could simply notify the ops team that a restart is required.

## v6.1.1

* [FIXED] Set configuration values required for setting up binlog writing.

## v6.1.0

* [CHANGED] Extend and test configuration settings

## v6.0.0

* [CHANGED] Switch attribute namespace to `mysqlx`.

## v5.0.1

* [CHANGED] Cleaned out unnecessary stuff

## v5.0.0

* Fork of the `mysql` community Chef cookbook v4.1.2
* Dropped support for outdated Chef versions and operating systems,
* Updated for Ubuntu 16.04 and Chef 13
