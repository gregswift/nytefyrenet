+++
title = "Kickstarting Fedora 21 Workstation with Cobbler"
date = 2015-02-25T12:35:09-05:00
tags: [
  "general",
]
+++
> Quick warning. I'm writing this as more of a post-mortum. I didn't get all the errors recorded, and I realize that will make this hard for some people to find. I am also simplifyingthe process a bit more than what I actually went through, so some of it might not be perfect. I'll try to make that better, but don't hold your breath on me re-creating all the things that failed just to update this.

Odds are that if you've randomly stumbled upon this post you are suffering.  Its that pain that can only be understood by someone who questions why something that has worked for decades suddenly breaks. 

Now lets be clear on something, I'm not against the Fedora.next concept.  I think there is a lot of merit to the concept, and more power to those implementing it for having the drive and vision to do so.  However, it is not fun spending several nights on a low and capped bandwidth network trying to figure out why something I've been doing for years doesn't work.

So lets step back a few weeks.  My wife is opening an optometry practice, which is exciting and stressful.  It is also not cheap. Bearing in mind that I have over 15 years of sysadmin/network/security/blah/blah/blah experience I'm trying to save her a bit of money by handling her IT.  As part of that I'm bringing a few basic concepts to the environment.

  * Disposal and Repeatability - I want to be able to rebuild any of the desktops or the server at the drop of a hat.  There are several tools that facilitate this like The Foreman and Cobbler.  I settled on the latter.  I'll talk about that elsewhere.
  * Linux - I know that the medical industrial complex is not necessarily Linux friendly, but I bet I can do at least the desktops this way.  This is going to have some fun problems.
  * Security - Small offices are notorious for their lack of security.  Going to conver user management, shared secrets, and good password policies.

But you want to know how to kickstart Fedora 21.  Lets move that direction...

One of the first things I established was a Cobbler instance and downloaded the Fedora 21 Workstation media. Let's import it.

<pre class="lang:default decode:true " ># mount -o loop Fedora-Live-Workstation-x86_64-21-5.iso /mnt
mount: /dev/loop0 is write-protected, mounting read-only
# cobbler import --path=/mnt --name=f21 --kickstart=/var/lib/cobbler/kickstarts/default.ks
task started: 2015-02-25_004424_import
task started (id=Media import, time=Wed Feb 25 00:44:24 2015)
No signature matched in /var/www/cobbler/ks_mirror/f21
!!! TASK FAILED !!!</pre>

If you dig into this a bit you will find that the Live Workstation doesn't have the bits necessary to match any of the signatures, and updating the signatures isn't the solution.  A cursory google search shows that the recommended path for kickstarting Fedora 21 is to use the Server media with the Fedora 21 Everything repository. So we go download the Server DVD (or netinstall) and start syncing the Everything repository.

> Quick aside. What really happened in my late nights of making this happen was that I found the above information, but confused the Everything repository with the Server Everything iso. So I started with just the Everything ISO, which isn't an actual bootable iso with a installer. This led to weeping and gnashing of teeth. After a while of poking and prodding at this and reading poor documentation I realized there was a base Everything repository too. Then, because of my bandwidth limitations, I had to go sync the repository elsewhere, and manually import it into the environment.

<pre class="lang:default decode:true " ># mount -o loop Fedora-Server-DVD-x86_64-21/Fedora-Server-DVD-x86_64-21.iso /mnt
mount: /dev/loop0 is write-protected, mounting read-only
# cobbler import --path=/mnt --name=f21 --kickstart=/var/lib/cobbler/kickstarts/default.ks
task started: 2015-02-25_004627_import
task started (id=Media import, time=Wed Feb 25 00:46:27 2015)
Found a candidate signature: breed=redhat, version=rhel6
Found a candidate signature: breed=redhat, version=rhel7
Found a candidate signature: breed=redhat, version=fedora21
Found a matching signature: breed=redhat, version=fedora21
Adding distros from path /var/www/cobbler/ks_mirror/f21:
creating new distro: f21-x86_64
trying symlink: /var/www/cobbler/ks_mirror/f21 -&gt; /var/www/cobbler/links/f21-x86_64
creating new profile: f21-x86_64
associating repos
checking for rsync repo(s)
checking for rhn repo(s)
checking for yum repo(s)
starting descent into /var/www/cobbler/ks_mirror/f21 for f21-x86_64
processing repo at : /var/www/cobbler/ks_mirror/f21
need to process repo/comps: /var/www/cobbler/ks_mirror/f21
looking for /var/www/cobbler/ks_mirror/f21/repodata/*comps*.xml
Keeping repodata as-is :/var/www/cobbler/ks_mirror/f21/repodata
*** TASK COMPLETE ***
# cobbler repo add --name=f21-everything-64 --mirror=http://mirror.rackspace.com/fedora/releases/21/Everything/x86_64/os/ --arch-x86_64 --breed-yum
# cobbler reposync --only=f21-everything-64
task started: 2015-02-24_220105_reposync
task started (id=Reposync, time=Tue Feb 24 22:01:05 2015)
hello, reposync
run, reposync, run!
creating: /var/www/cobbler/repo_mirror/f21-everything-64/config.repo
creating: /var/www/cobbler/repo_mirror/f21-everything-64/.origin/f21-everything-64.repo
running: /usr/bin/reposync -n -n -d -m --config=/var/www/cobbler/repo_mirror/f21-everything-64/.origin/fedora-21-everything-64.repo --repoid=f21-everything-64 --download_path=/var/www/cobbler/repo_mirror -a x86_64
... something i didn't copy to finish off the statement.</pre>

Awesomeness. That's done. I then added this repo to my f21 profile, and tried to kickstart. Using the simple default kickstart from cobbler, the kicking succeeded. However I only had a server instance due to not defining custom package sets.

I have a Fedora 21 workstation so I looked at the available groups and started with the simple "@^Fedora Workstation". Restarted the process, and fail. No such group. Turns out cobbler's reposync doesn't grab comps.xml with its default settings. Go edit /etc/cobbler/settings and add '-m' to the reposync_flags setting. Then re-run the cobbler sync. 

> I haven't tested it with the re-run. Due to my constant back and forth I ended up doing a full re-sync at one point after adding the -m.

At this point it should be working. Let me know what doesn't work and I'll update.
