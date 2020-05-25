+++
title = "Some RPM packaging thoughts and resources"
date = 2014-02-26T12:26:26-05:00
tags = [
  "development",
  "linux",
  "rpms",
]
+++

Hopefully in the next two days my topic of 'Using system level packaging' will get picked up at our internal unconference. In preparation for that I figured I would compile a little bit of my data into a post so that I point people to it as a reference.

First off, try reading this [old blog post](http://nytefyre.net/2011/04/call-to-software-vendors-package-it-right/ "call to software vendors… package it right") by myself.

Now that that diatribe is out of the way, on to some advice for developers.

## Intended Audience

Did you start your project by defining the problem? As part of that definition did you consider who your target audience is?  In my opinion this is a very important part of the process related to system packaging.

Let's say that I'm working on a project that will be useful to run on OpenStack servers.  If you utilize the latest python libraries installed via pip and virtualenv, many systems that OpenStack runs on will not support those versions.  However, if you follow the [global requirements](https://github.com/openstack/requirements "OpenStack Global Requirements") that OpenStack projects follow, it is easier for your project to fit into that environment.

What if have brilliant idea to create a [next generation orchestration tool](http://ansible.com "Ansible")? Knowing that this would be an awesome tool for enterprises, who typically are willing to buy support even for your free open-source project, it [makes sense to consider that from day one](http://docs.ansible.com/faq.html#how-do-i-handle-python-pathing-not-having-a-python-2-x-in-usr-bin-python-on-a-remote-machine "Ansible FAQ - python 2.x").  As of 2013, many enterprise shops are running a mixture of RHEL5 and RHEL6.  That means that python 2.3 and 2.4, respectively, are the default python version available to you. In some cases there are additional version available, but we'll get to that next.

## 3rd Party Repositories for EL distributions

Now maybe you have decided that Red Hat Enterprise Linux and it's derivatives are your target and have started gnashing your teeth.  "_I don't want to have to package all these dependencies!_"  Luckily, some wonderful communities have popped up to help.  The tried and true repository, [Extra Packages for Enterprise Linux (EPEL)](http://fedoraproject.org/wiki/EPEL "Extra Packages for Enterprise Linux (EPEL)") has been around for a while, and provides a nice stable extension to the base EL distribution.  Both fortunately and unfortunately, it has similar stability and version [restrictions](http://fedoraproject.org/wiki/EPEL/GuidelinesAndPolicies "EPEL Guidelines and Policies") to base EL.

If you are using CentOS there are several [additional repositories](http://wiki.centos.org/AdditionalResources/Repositories "CentOS Additional Repositories") available for you.

Going back to the OpenStack example above there is a fairly recent repository set that can be extremely help as well.  [Red Hat Deployed OpenStack](http://openstack.redhat.com/ "Red Hat Deployed OpenStack (RDO)") provides the OpenStack global requirements, all nice and packaged up for public consumption. Here is some [information about these repositories](http://openstack.redhat.com/Repositories "RDO Repositories").

## Software Collections

Software Collections is an extremely interesting new concept with lots of potential stemming from the [Fedora community](https://fedorahosted.org/SoftwareCollections/ "Fedora Software Collections") and embraced by [Red Hat](https://access.redhat.com/site/documentation/en-US/Red_Hat_Developer_Toolset/1/html/Software_Collections_Guide/ "Red Hat Software Collection Guide"). Generically speaking the goal is to provide a consistent framework for parallel installation of different versions of software.  It supports anything from newer versions of Python and Ruby to new versions of databases like PostgreSQL and MySQL. By providing a framework it becomes very possible for you to readily package your entire dependency stack in a way that can be installed in a standard RPMish way, but still isolated from the rest of the system!

That's it for now.
