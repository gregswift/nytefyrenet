+++
title = "All the users gather round"
date = 2011-08-21T17:07:59-05:00
[taxonomies]
tags = [
  "development",
]
+++

Linux has two classification of accounts.  System accounts and User accounts.  System accounts are delineated as any account with a UID lower than the defined UID_MIN value in the /etc/login.defs file, with the UID of 0 being reserved for the root account.  Red Hat based distributions systems set UID_MIN to 500, which is a deviation from the upstream project, shadow-utils, which uses of 1000.  Some of these UIDs are considered to be statically allocated and others for dynamically allocated.  In the upstream distribution Fedora there are currently static UIDs up to 173.  There is no clear definition of where the dynamically allocated UIDs start, but within Fedora as of version 16 and higher there is currently [a plan](http://fedoraproject.org/wiki/Features/1000SystemAccounts "Fedora Features - 1000 System Accounts") to help define this more clearly.  One part of that plan is that Fedora upping their definition of UID_MIN to the upstream 1000.  If the feature makes it in this will still not effect RHEL until version 7 at the earliest.  I'm honestly not sure if any other distribution has a clearer definition of the usage of these, but if not maybe that will change.

The primary use for system accounts is for any application that needs a dedicated user.  Some good examples of this are tomcat, mysql, and httpd. One of the biggest benefits of having a designated space for system accounts is that you can define a specific UID, and have that application user have that same UID on every system.  Take for example a case where a user, such as _myapp_, owns millions of files on a system.  If the _myapp_ user was created without defining that it is a system account, then _myapp_ would get a UID in the 500+ range, we will use 502 for the sake of this example.  Now say I need to keep these files synchronized with a backup system.  However on the backup system there were already several more users than on my production system and so _myapp_ was assigned the UID of 509.  What about 502? That is assigned to _gswift_. Well now if my sync of the files preserves the file ownership, the user _swiftg_ now has ownership of all of those files, because sync is a based on the UID, not the readable mapping.  The same thing could occur if you were migrating from one server to a new one.

So, where am I going with this?  I think it is important for developers to remember that any time you are creating a user on the system for your application, it should be in the system account area.  Luckily most do, especially when they include their software in a public distribution.
