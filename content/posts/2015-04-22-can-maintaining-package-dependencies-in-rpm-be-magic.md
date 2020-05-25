+++
title = "Can maintaining package dependencies in RPM be magic?"
date = 2015-04-22T15:39:22-05:00
[taxonomies]
tags = [
  "development",
  "fedora",
  "rpms",
]
+++

One of the biggest complaints I hear about packaging software is packaging up all the dependencies, and then being responsible for keeping them current. Obviously, this is not the only complaint.. but i'm not talking about the others at the moment.

A long time ago i had the idea for a website where you could aggregate status updates for software projects you care about, thus allowing you to go get all your updates without having to subscribe to billions of lists. I had this idea back when still installing things manually, because the package ecosystem was nowhere near as complete as it is today (in debian or fedora). Sometime after that i registered myswuf.com (my software update feed) with the intention of one day writing such a tool.

That was a long time ago, and obviously this kind of thing is an issue. So some really clever people (okay, at the very least more motivated) in Fedora came up with [Anitya](https://github.com/fedora-infra/anitya/ "Anitya"), a tool for monitoring releases. They even provide a [public and freely consumable installation](https://release-monitoring.org/ "release-monitoring.org").

Anitya publishes events to [fedmsg](http://www.fedmsg.com/ "fedmsg.com") (fedora infratructure message bus), which can be listened to as an unauthenticated feed.

[Stanislav Ochotnický](http://blog.ochotnicky.com) created a small proof of concept project called [fedwatch](https://github.com/sochotnicky/fedwatch) which listens to fedmsg and will pass data from it to scripts in its run directory. My idea was to take release information and pass it to jobs in jenkins that are setup to bump the relevant information in a spec file with rpmdev-bumpspec (>=1.8.5) and build the new version. In theory this would cover lots of releases with minimal overhead, allowing the outlying changes to require hands on. I've put some [completely unfinished code here](https://github.com/gregswift/fedwatch-trigger-jenkins).
