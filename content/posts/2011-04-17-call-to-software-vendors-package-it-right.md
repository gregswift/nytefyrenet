+++
title = "call to software vendors... package it right"
date = 2011-04-17T16:11:24-05:00
tags = [
  "development",
  "linux",
  "puppet",
  "rpms",
]
+++
One of the tasks that I have been responsible for performing over the last several years is packaging software into RPM Package Manager (RPM) packages.  All of our internal RPMs are fairly simple, the tricky part is the 3rd party software.  There are several problems with the distribution of commercial off the shelf (COTS) software in the Linux ecosystem.

  * They are rarely RPMs
  * Sometimes they use InstallAnywhere installers (more on that later)
  * When they are RPMs they either think they know better than RPM (can be explained as a lack of understanding as well) or they try too hard to make a single RPM that works on all RPM-based distributions.

Before I go further I would like to say, if you are packaging your software as a real RPM (or any other native Linux packaging system), even if it is not perfect, _**THANK YOU**_. We appreciate it.  Please take my commentary as constructive criticism.  I am not angry with you, and will gladly help you with packaging issues if I can.  I am not the best either, but I have a fair bit of practice.  I am sure others would gladly assist as well.

Moving on... So today I got stuck attempting to automate the installation and configuration of some of _unnamed vendor'_s system management RPMs via [puppet](http://projects.puppetlabs.com/projects/puppet "Puppet website").  I made the mistake of looking into the scriptlets and was frustrated by some of their practices.  I started to write a package by package evaluation of the scriptlets, but one package in particular would have taken forever (it attempted to cover every possible RPM-based Linux distribution via the scriptlets).  I recalled a conversation I had a year or two ago with the individual who heads up this company's Linux packaging group, and they had expressed interest in feedback.  At the time I had a few points to provide, but I did not have time for a more in depth analysis.  So I decided to finally write up a general set of bullet points to pass their way, if I am not trying to help then I am part of the problem, right?.  I figured it would not hurt to put it out here as well.  So I am re-wording a touch to make it less specific to just them, and more of a general call to all software vendors.  Also, I would imaging most of what is stated directly translates to Debian, conary, and other native packaging systems; but it is not intended to be a definitive guide.

Things to keep in mind when packaging software for native Linux distribution:

  * It helps to build (compile) your software from source using the packaging tools (RPM), instead of just packaging up the binaries.  You do not have to distribute the source (SRPM, tarball, etc), but the build process can potentially be cleaner and more manageable.  Yes, I know you paid all kinds of money for some fancy handle everything build system.  Are your customers (the system administrators) happy with the output?  I know I am not.
  * With the modern build processes and systems available there really is no good reason to build a mangled cluster of scripts that attempt to make one platform independent RPM instead of building distribution specific RPMs.  They can even still come from the same consolidate spec files, thus allowing you to reduce duplicate work.
  * Scriptlets 
      * Should be short and concise
      * Almost the entire build and installation of the software should occur in the %build and %install sections, respectively.
      * Any setup or file layout should be handled in %build and %install sections, if its host specific it should be a documented post-install exercise for the admin.
      * User/group creation, symlinking files, chkconfig and service commands are all acceptable.
      * Should never touch a file owned by another package.  If it needs a setting or switch flipped, document it for the administrator. At worst, include a "check" or "setup" script that the administrator can run manually if they want you to do the work for them, cause the majority of us don't.
  * Files should only be placed on the system via RPM's built in methods. 
      * <del>Symlinks can be a caveat of this, but should not be abused.</del> **UPDATE 2014.03.19** - Retracting since I just built a package that managed symlinks right. No excuses. :)
      * File ownership and permissions should be set by the RPM, not in the scriptlets.
      * Do not provide library files that the OS already provides.  Get past the "i need this specific version, and no other will do" or "well we used that one but slightly modified" mentality, and when you can't, then require the correct compatible library.  Most distributions do provide them already.  If you needed to modify it, are you properly following the licensing? Wouldn't it be better to just submit a patch and stop having to maintain it and not worry about licensing issues?
  * You should not be adjusting security settings on the system for the administrator, you can provide them (i.e. SELinux policy files, default firewall rules, a file for /etc/sudoers.d/, etc), but implementing them for me is bad security at its worst.
  * If you provide an SELinux policy that does not change any existing policies on the system directly, you can implement that.  But if you change something existing, let us do the work so that we are aware.
  * Do not flip SELinux booleans related to other bits, let the admin or find the right way.
  * Get help... it is out there.  There is selinux mailing lists, and ya know what? Call Red Hat.  They helped get SELinux going, they know what to do.  You are not in charge of my system's security, I am.  If you need a change to an existing policy, talk to that policy's maintainer or implement it in your own policy.
  * Users and groups - for the most part this hasn't looked bad except: 
      * Deleting and re-creating a user is a annoying thing to do.  If the admin changed something about the user and everything still functions, don't touch it.  If I need to fix it I can delete the user myself and then let you create it by re-installing, or just look at your newly clean scriptlets to discover the exact syntax.
      * Technically, you should not be deleting any user you create on the system... another exercise for the admin to avoid stranded files.
  * If your company decides not to supply good RPMs, consider a tarball(s) with an simple install script, we can do the rest.  I was avoiding naming names, and I hate to give this software credit, but IBM's DB2 has got to be the easiest 3rd Party software I have ever packaged and deserves credit for the fact that there was just a bunch of tarballs and a few commands to install.  Setup was another matter. heh.

To summarize, write the RPMs according to a public packaging guideline, such as the [Fedora Packaging Guidelines](http://fedoraproject.org/wiki/PackagingGuidelines "Fedora Packaging Guidelines").  If Fedora would accept it into the EPEL repositories then you have succeeded.  I realize you want your packages to support other distributions, but odds are that if the spec file for the RPMs are cleaned up to meet Fedora's guidelines, the other distributions should be easy to support, and us administrators would be ecstatic.  Plus the use of tools like [mock](https://fedorahosted.org/mock/ "mock chroot build environment"), [koji](https://fedorahosted.org/koji/ "Koji Build System"), [OpenSuSE Build Service](http://build.opensuse.org/ "OpenSuSE Build Service"), etc can greatly ease build and distribution issues.

Since I already named one name, might as well point out a negative one.  [Flexera's InstallAnywhere](http://www.flexerasoftware.com/products/installanywhere.htm "Flexera's InstallAnywhere")... So InstallAnywhere is a universal installer with an interesting feature.  Their site claims: "[Install native packages, such as RPM, on Linux, Solaris, and HP-UX](http://www.flexerasoftware.com/products/installanywhere/editions.htm "Flexera's InstallAnywhere Editions page")".  This is inaccurate, at least towards RPM.  What they produce is a Java-based installer that injects RPM metadata into your system's RPM database.  This is not an RPM.  We can not distribute this software via Yum or [Spacewalk](http://spacewalk.redhat.com "Spacewalk") or Red Hat Network Satellite.  They should be ashamed. :(

So some useful reading:

  *     [Fedora Packaging Guidelines](http://fedoraproject.org/wiki/PackagingGuidelines "Fedora Packaging Guidelines")
  *     [MaxRPM](http://www.rpm.org/max-rpm/ "MaxRPM guide") - dated, but still extremely valuable
  *     [RPM-ifying Third Party Software](http://www.redhat.com/f/pdf/summit/pwaterman_130_rpm-ifying.pdf "RPM-ifying Third Party Software") - Paul Waterman
  *     [How to Make Good RPM Packages](http://www.redhat.com/promo/summit/2008/downloads/pdf/Wednesday_130pm_Tom_Callaway_OSS.pdf "How to Make Good RPM Packages") - [Tom 'spot' Callaway](http://spot.livejournal.com/ "spot's blog")
  *     [The real problem with Java in Linux distros](http://fnords.wordpress.com/2010/09/24/the-real-problem-with-java-in-linux-distros/trackback/) - [Thierry Carrez](http://fnords.wordpress.com/ "Seeing the fnords blog")
  *     [Getting you Java Application in Linux: Guide for Developers (part 1)](http://inputvalidation.blogspot.com/2011/04/getting-your-java-application-in-linux.html) - [Stanislav Ochotnicky](http://inputvalidation.blogspot.com/ "Ins and Outs of Inputs blog")

**UPDATE:** Some basic grammar fixes. 2011.10.19
