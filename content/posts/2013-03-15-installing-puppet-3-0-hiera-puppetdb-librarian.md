+++
title = "installing puppet 3.0 + hiera + puppetdb + librarian"
date = 2013-03-15T10:29:14-05:00
tags = [
  "general",
]
+++
## What we are doing

So Puppet 3.0 recently came out. It has Hiera support built in. Along with this PuppetDB 1.0 was released, which is supposed to be a very handy and very fast means of centrally storing catalogs and facts about your Puppet clients. Librarian is a project I recently ran across that helps coordinate the modules in your Puppet environment, unfortunately its not packaged.  I don't usually like using Puppet Lab's softwre repositories directly, but am for this because the software isn't in EPEL yet.

So all I'm really doing is help layout a proof of concept environment using these tools.

## Software

  * [Puppet 3.0](http://projects.puppetlabs.com/ "Puppet project page")
  * [Hiera](https://github.com/rodjek/librarian-puppet "Hiera project page")
  * [PuppetDB](projects.puppetlabs.com/projects/puppetdb "PuppetDB project page")
  * [Librarian](https://github.com/rodjek/librarian-puppet "Librarian project page")

## Prerequisites

  * You have enabled [PuppetLab's repositories](docs.puppetlabs.com/guides/puppetlabs_package_repositories.html "PuppetLabs package repositories documentation").
  * You are **not** going to implement it this way in production.  That would be bad, m'kay?
  * You are going to notice than installing librarian as a gem completely overwrites your package installed version, thus validating why this in production is **bad**.

## Installation

<pre class="lang:default decode:true " >yum install puppet puppetdb puppetdb-terminus
gem install librarian-puppet # don't forget the -puppet... librarian is something different
</pre>

## Configuration

Reference: http://docs.puppetlabs.com/puppetdb/1/connect\_puppet\_master.html

  * Make sure your fqdn is resolveable. Right now we are using a single host, so I'm just using localhost not the fqdn.
  * Populate /etc/puppet/puppetdb.conf with the following <pre class="lang:default decode:true " >[main]
server = localhost
port = 8081</pre>

  * Set the puppetdb server in /etc/puppet/puppet.conf <pre class="lang:default decode:true " >[master]
storeconfigs = true
storeconfigs_backend = puppetdb</pre>

  * If you are using a separate host ensure that /etc/puppetdb/jetty.ini has the servername set to our fqdn. If its unpopulated, check it again after you run puppetdb-ssl-setup below. <pre class="lang:default decode:true " >host = puppetmaster.example.com
ssl-host = puppetmaster.example.com</pre>

## Initialization of Puppet and PuppetDB

So PuppetDB's SSL setup is very strict. For now, just make sure that you are

<pre class="lang:default decode:true " >/etc/init.d/puppet start
/etc/init.d/puppetmaster start
/usr/sbin/puppetdb-ssl-setup
/etc/init.d/puppetdb start</pre>

## Adding modules using Librarian

Reference: https://github.com/rodjek/librarian-puppet/blob/master/README.md

  * First, prepare your puppet install for Librarian to control your modules directory <pre class="lang:default decode:true " >cd /etc/puppet
rm -rf modules
librarian-puppet init</pre>

  * This will have created a PuppetFile in /etc/puppet
  * Add a puppet forge module into PuppetFile <pre class="lang:default decode:true " >mod 'puppetlabs/stdlib'</pre>

  * Add a module from a git repository into PuppetFile <pre class="lang:default decode:true " >mod "augeasproviders",
:git =&gt; "https://github.com/hercules-team/augeasproviders.git"</pre>

  * Tell librarian to build your modules directory <pre class="lang:default decode:true " >librarian-puppet install</pre>

  * Check out your handy work <pre class="lang:default decode:true " >ls /etc/puppet/modules</pre>

## Configuring Hiera and preloading some data

ya.. need to get to this part..
