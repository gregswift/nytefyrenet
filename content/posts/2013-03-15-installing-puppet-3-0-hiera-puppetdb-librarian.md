+++
title = "installing puppet 3.0 + hiera + puppetdb + librarian"
date = 2013-03-15T10:29:14-05:00
[taxonomies]
tags = [
  "general",
]
+++

## What we are doing

So Puppet 3.0 recently came out. It has Hiera support built in. Along with this PuppetDB 1.0 was released, which is supposed to be a very handy and very fast means of centrally storing catalogs and facts about your Puppet clients. Librarian is a project I recently ran across that helps coordinate the modules in your Puppet environment, unfortunately its not packaged.  I don't usually like using Puppet Lab's softwre repositories directly, but am for this because the software isn't in EPEL yet.

So all I'm really doing is help layout a proof of concept environment using these tools.

## Software

- [Puppet 3.0](http://projects.puppetlabs.com/ "Puppet project page")
- [Hiera](https://github.com/rodjek/librarian-puppet "Hiera project page")
- [PuppetDB](projects.puppetlabs.com/projects/puppetdb "PuppetDB project page")
- [Librarian](https://github.com/rodjek/librarian-puppet "Librarian project page")

## Prerequisites

- You have enabled [PuppetLab's repositories](docs.puppetlabs.com/guides/puppetlabs_package_repositories.html) "PuppetLabs package repositories documentation".
- You are **not** going to implement it this way in production.  That would be bad, m'kay?
- You are going to notice than installing librarian as a gem completely overwrites your package installed version, thus validating why this in production is **bad**.

## Installation

```bash
yum install puppet puppetdb puppetdb-terminus
gem install librarian-puppet # don't forget the -puppet... librarian is something different
```

## Configuration

Reference: <http://docs.puppetlabs.com/puppetdb/1/connect\_puppet\_master.html>

- Make sure your fqdn is resolveable. Right now we are using a single host, so I'm just using localhost not the fqdn.
- Populate /etc/puppet/puppetdb.conf with the following

```config
[main]
server = localhost
port = 8081
```

- Set the puppetdb server in /etc/puppet/puppet.conf

```config
[master]
storeconfigs = true
storeconfigs_backend = puppetdb
```

- If you are using a separate host ensure that /etc/puppetdb/jetty.ini has the servername set to our fqdn. If its unpopulated, check it again after you run puppetdb-ssl-setup below.

```ini
host = puppetmaster.example.com
ssl-host = puppetmaster.example.com
```

## Initialization of Puppet and PuppetDB

So PuppetDB's SSL setup is very strict. For now, just make sure that you are

```bash
/etc/init.d/puppet start
/etc/init.d/puppetmaster start
/usr/sbin/puppetdb-ssl-setup
/etc/init.d/puppetdb start
```

## Adding modules using Librarian

Reference: <https://github.com/rodjek/librarian-puppet/blob/master/README.md>

- First, prepare your puppet install for Librarian to control your modules directory

```bash
cd /etc/puppet
rm -rf modules
librarian-puppet init
```

- This will have created a PuppetFile in /etc/puppet
- Add a puppet forge module into PuppetFile

```config
mod 'puppetlabs/stdlib'
```

- Add a module from a git repository into PuppetFile

```ruby
mod "augeasproviders",
:git => "https://github.com/hercules-team/augeasproviders.git"
```

- Tell librarian to build your modules directory

```bash
librarian-puppet install
```

- Check out your handy work

```bash
ls /etc/puppet/modules
```

## Configuring Hiera and preloading some data

ya.. need to get to this part..
