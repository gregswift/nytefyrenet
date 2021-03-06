+++
title = "puppet via apache using passenger from epel"
date = 2012-10-04T09:51:36-05:00
[taxonomies]
tags = [
  "linux",
  "puppet",
]
+++

I put together this serious of steps a few years ago long before Passenger made its way into Fedora/EPEL, when it was required putting together write ups from all over the place. Its easier now, but I've updated it and am publishing it to my blog because someone had expressed interest, and for my own use.

The goal of this set of steps is to enable the serving of Puppet through Apache using the Passenger module. mod_passenger to ruby what mod_cgi is to perl and mod_wsgi is to python. You would want to use this because Puppetmaster itself does not scale as well to large numbers of puppets. There are other options, but the whole thing is discussed more [here](http://projects.puppetlabs.com/projects/puppet/wiki/Puppet_Scalability).

## Pre-requisites

- RHEL 6 or clone installed
- EPEL enabled on server (preferably with epel-release RPM)
- The knowledge to do the above without my help

## Installing a Puppetmaster

- Install puppet and other packages:

```bash
yum install --enablerepo=epel-testing httpd mod_ssl puppet-server mod_passenger
```

- Populate /etc/httpd/conf.d/puppetmaster.conf with the following block. There is a sample 'apache2.conf' file that comes with the puppet package, but its never worked for me:

```bash
# you probably want to tune these settings
PassengerHighPerformance on
PassengerMaxPoolSize 12
PassengerPoolIdleTime 1500
# PassengerMaxRequests 1000
PassengerStatThrottleRate 120
RackAutoDetect Off
RailsAutoDetect Off

Listen 8140
<VirtualHost *:8140>
    SSLEngine on
    SSLCipherSuite SSLv2:-LOW:-EXPORT:RC4+RSA
    SSLCertificateFile /var/lib/puppet/ssl/certs/puppet.pem
    SSLCertificateKeyFile /var/lib/puppet/ssl/private_keys/puppet.pem
    SSLCertificateChainFile /var/lib/puppet/ssl/ca/ca_crt.pem
    SSLCACertificateFile /var/lib/puppet/ssl/ca/ca_crt.pem
    # CRL checking should be enabled;
    # if you have problems with Apache complaining about the CRL, disable it
    SSLCARevocationFile /var/lib/puppet/ssl/ca/ca_crl.pem
    SSLVerifyDepth 1
    SSLOptions +StdEnvVars
    RequestHeader set X-SSL-Subject %{SSL_CLIENT_S_DN}e
    RequestHeader set X-Client-DN %{SSL_CLIENT_S_DN}e
    RequestHeader set X-Client-Verify %{SSL_CLIENT_VERIFY}e
    RackAutoDetect On
    DocumentRoot /usr/share/puppet/rack/puppetmasterd/public/
    <Directory /usr/share/puppet/rack/puppetmasterd/>
        Options None
        AllowOverride None
        Order allow,deny
        allow from all
    </Directory>
    <Directory /etc/puppet/modules/>
        Options None
        AllowOverride None
        Order allow,deny
        allow from all
    </Directory>
    LogLevel warn
    ErrorLog /var/log/httpd/puppetmaster_error_log
    CustomLog /var/log/httpd/puppetmaster_access_log combined
</VirtualHost>
```

- Optional
- Set ServerName value in the VirtualHost block
- Change the ssl cert file names from 'puppet.pem' to match your local environment
- Set the correct puppet paths for ssl certificates in your environment
- Create rack directory structure

```bash
mkdir -p /usr/share/puppet/rack/puppetmasterd/{public,tmp}
```

- Copy config.ru fromthe puppet source dir

```bash
cp /usr/share/puppet/ext/rack/files/config.ru /usr/share/puppet/rack/puppetmasterd/
```

- Set permissions on the previous items

```bash
chown -R puppet: /usr/share/puppet/rack/puppetmasterd/
```

- Configure /etc/puppet/puppet.conf to include the following, taking into consideration your local environment:

```config
[master]
certname=puppet
ssl_client_header=SSL_CLIENT_S_DN
ssl_client_verify_header=SSL_CLIENT_VERIFY
```

- Configuring SSL the lazy way :)
- Run puppetmasterd to build ssldirectory structure and keys

```bash
/usr/sbin/puppetmasterd
```

- Stop puppetmasterd

```bash
killall -9 puppetmasterd
```

- Add firewall rules before the reject and commit rules in your firewall definition:

```bash
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8140 -j ACCEPT
```

- Restart firewall

```bash
/etc/init.d/iptables restart
```

- Restart apache

```bash
/etc/init.d/httpd restart
```

- Verifying that the system is working by browsing to admin page: <https://puppetmaster:8140>, and if its working you should see:

```bash
The environment must be purely alphanumeric, not ''
```
