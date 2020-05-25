+++
title = getting func-y
date = 2011-04-07T21:55:54-05:00
tags:
  "certmaster",
  "development",
  "func",
]
+++
So it happened.  What you ask?  A very long anticipated release.  <a title="Gnome 3 Release Announcement" href="http://www.gnome.org/" target="_blank">Gnome 3</a>! Wait, no... well, yes, Gnome 3 was released, and is kinda kewl and you can <a title="Gnome 3 Try It Live Download" href="http://www.gnome3.org/tryit.html" target="_blank">try it</a>.  I'm not totally sold on it yet though, maybe I'll review it sometime or another. Oh wait, what was I talking about? Yes! The much anticipated release! It was not Gnome 3... it was <a title="Func Homepage" href="http://fedoraproject.org/func" target="_blank">Func</a> and <a title="Certmaster homepage" href="http://fedoraprooject.org/certmaster" target="_blank">Certmaster</a>!  They have <a title="Func 0.28 Release Announce" href="https://www.redhat.com/archives/func-list/2011-April/msg00010.html" target="_blank">officially reached 0.28</a>.  Ya.. not as fancy of a version number as 3, but.. hey it gives us something to aspire to.  The releases will be making their way into EPEL-testing soon, but can currently be downloaded in tarball form or from koji.[1]

What are Func and Certmaster? Hrm.. well... so basically they are a set of programs that work together to let a administrator tell _N_ number of servers what to do at the same time, and it will give back a report of what happened.  That is the 30,000 ft view.  Up close and personal, well... its a programmatic systems management tool that allows you to perform actions across large numbers of systems in an orderly fashion that allows great extensibility and control; which also exposes the basic functionality via a cli so that you can run quick one liners without to much effort.  Loose anyone there?  Don't worry, I loose my self trying to follow the code in these programs some times, that's all part of the learning process.

Why do I suddenly care?  Well, its not suddenly really.  I've been following func for a very long time.  I'm not sure if I heard about it before the 2008 Red Hat Summit or not, but it was sometime around there.  Its a very useful and wonderful tool, and due to my semi-regular use of it I had started sending bug <del>requests</del> reports and patches to the mailing list.  Recently, I was asked if I was willing to channel some of that energy into helping develop func and certmaster directly.  I was very happy to accept, if a bit trepidatious.  After several weeks of learning git and my way around some of the code, I was happy to help <a title="Seth Vidal's blog" href="http://skvidal.wordpress.com/" target="_blank">Seth Vidal</a> (the primary maintainer) get func and certmaster ready for a new release.

We've still got lots of work on our plate, but its been a very useful experience for me, and i'm glad to contribute back to an open source project so directly for once.

[1] Certmaster on RHEL 5 does require a patched, non-supported pyOpenSSL package until RHEL 5.7 is released.  See the release announce thread for more information.
