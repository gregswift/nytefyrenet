+++
title = jumping out the window
date = 2011-10-24T11:08:33-05:00
tags:
  "linux",
]
+++
So, its time to feed the troll.  I do try and avoid this usually, but I was [channeling some xkcd](http://xkcd.com/386/ "Duty Calls") when I wrote this.

While my first exposure to computers was on a Commodore 64 then later with SystemV and Red Hat Linux (RHL), I started my professional career as a Windows desktop support lackey.  In that role I learned a bit more about Windows, and began maintaining  an Exchange 5.5 system and then later towards IIS and DNS management (backwards, I know).  Within a a few short years I was ecstatic to return to the world of Linux sans Windows.  One of the big things for me was that things I wanted to do were always a pain to accomplish, whether it was on Windows or Linux, but Linux allowed me to do it faster and easier.

The deepest development I do is python and some other scripting and web languages.  I have never built Linux from scratch.  I installed Gentoo once, but thought it was way to much effort.  Slackware was nice, but I have always been a fan of my first Linux, Red Hat.  My first personal server ran RHL 7.1 and was maintained with updates until they stopped coming.  In fact, said server is sitting under my desk at home powered off, but still functional.  It has not gotten an update in years, but that is because none were available.  I ran RHL 7.2 on my Toshiba Protege for about 4 years.

I concede frustration in the early days of Fedora, because it was a rocky start, very bleeding edge, and not prone to stability.  I even strayed to spend a year or so in the arms of another, ahh Ubuntu.  Such a nice approachable mistress, but high maintenance between releases due to all the non-upstream modifications.  (Not that Fedora was better mind you in upgrades, it didn't support release upgrades till Fedora 9).  I did come back to Fedora around version 9 and have been staying up to date as time allows. I do prefer to stay completely current.. but time is not always in my favor.  My current desktop is Fedora 14, I am waiting for 16's release to introduce the wifey to Gnome 3.

I am Red Hat certified and at work I am a Red Hat Enterprise Linux (RHEL) advocate.  One of the largest reasons is that I feel it is the best way for companies that have zero interest in participating in open source to actually contribute back (by paying Red Hat to do it).  I have been utilizing RHEL since it was released as version 2.1 back in 2002.  I keep my systems updated all the time.  However, I have been singed a few times by updates.  They can be counted on one hand:

  1. Way back in the day the bind-chroot package would blow away your named.conf on an update.  But now that I think about that... it was not even RHEL.  It may have been RHL.
  2. In RHEL5 there was a openssh update that introduced dynamic tcp window scaling.  We have a phantom network issue and thus started having stalled ssh data transfers.  Not really the update's fault.
  3. In RHEL5 they changed the tzdata package from noarch to arch-specific and you could end up with a bad old tzdata package installed.  Did not actually break anything.
  4. At one point kmod-nvidia blew up on a kernel update during the Fedora 13 time frame.  The kmod was from RPMFusion and of nvidia's proprietary binaries... kind of an issue waiting to happen in the first place.  I moved to the akmod (self-rebuilding kernel mod) package and haven't had an issue since.

I do have one habit that is rather mildly irritating to both myself and others, I am a big fan of playing with software that is _supposed_ to do task _X_ or have feature _Y_, but is not quite there yet.  Sometimes this is due to it being bleeding edge, other times its just poorly maintained software, or maybe the vendor was just a liar.  I have never had this habit destroy a system,  usually just project timeline delays or the need to find a better solution.

So what is the point of this?  I was forwarded a link to a rant on ZDnet this last Friday (2011.10.21) entitled  [Why I've finally had it with my Linux server and I'm moving back to Windows](http://www.zdnet.com/blog/diy-it/why-ive-finally-had-it-with-my-linux-server-and-im-moving-back-to-windows/245 "Why I've finally had it with my linux server and I'm moving back to Windows") by [David Gewirtz](http://www.davidgewirtz.com/ "David Gewirtz's site").

I am not going to delve to deep into his background since it is readily available on his site, but based on his _advertised_ background this guy should be beyond my skill set in understanding the how computers work. Sadly, understanding and development skills does not a skilled administrator make. Here is how he describes himself in the afore mentioned article:

"... I’m no tech babe in the woods. I’ve been a UNIX product manager, I’ve written kernel code, and I’ve taught programming at the college level. "

So, my quick synopsis on me.  I am a fairly competent sysadmin with a background of being in the trenches.  I took a C class in high school that used _C/C++ for Dummies_ as the course material, and is practically the last time I touched it. I did list my scripting experience above.  I have never touched kernel code.  I never went to college.

Now that context has been set, here are quotes from his article followed by my responses.  I am trying to consider that his rant was written while he was angry and (hopefully) just being melodramatic, but it is difficult.

 _"I’ve had it with all the patched together pieces and parts that all have to be just the right versions, with just the right dependencies, compiled in just the right way, during just the right phase of the moon, with just the right number of people tilting left at just the right time. "_

And what exactly are you doing? Unless you are grabbing several repositories from random places and enabling them all at the same time, or installing everything from scratch this should not be an issue these days.  3-5 years ago? Maybe. 5-10 years ago? okay ya... probably.

 _"I’ve had it with all the different package managers. With some code distributed with one package manager and other code distributed with other package managers. With modules that can be downloaded on Ubuntu just by typing the sequence in the anemic how-to, but won’t work at all on CentOS or Fedora, because the repositories weren’t specified in just, exactly, EXACTLY, the right frickin’ order on the third Wednesday of the month. "_

Okay... so apt (Debian and Ubuntu) and yum (CentOS, Fedora, RHEL) are not the same software.  So their commands are a touch different.  They are also used in different distributions, so there might be different package names. I can see where that can be annoying, it has annoyed me at times.  But this is complaining that your Windows box and OS X box do not use the same exact programs and syntax. There is software that exists on both of those platforms that require different installation and execution procedures.

_"With builds and distros that won’t even launch into a UI until you’ve established a solid SSH connection, "_

Umm... so I personally prefer my remote access to my servers over an encrypted channel, and SSH is a great medium for that.  You are a security advocate, right? This is a server environment, right?  You need a GUI, why?  I am not against GUIs, they have their place.  However, most server components in Linux do not have a native GUI tool.  It is usually just configuration files, and sometimes a web interface.  Furthermore, if this is the administrative interface of a backup program, why would you run it on lots of machines?  There should be a central administrative interface, and RDP to Windows is a nice feature for that purpose.  Even if it is on a Linux server, if this is a centralized interface, what is wrong with just exporting the GUI over X via your SSH session? Its secure and easy.  It requires almost no setup (install a few programs on your Windows desktop, establish the connection, run the program).  VNC is rather insecure usually...

_"I’ve had it with the fact that this stuff doesn’t work reliably."_

Ahh reliability... such a subjectively quantifiable term.  I like how you do not explain how it is not reliable, you just barges right on to knowledge and understanding.  In fact the closest you come to saying anything about a lack of reliability is the update issue resulting in a crash, but this statement is completely separate from those statements in your rant.

_"Oh, sure, if you work with Linux every hour of every day, if this is all you do, and all you love, if you’ve never had a date since you grew that one facial hair, if you’ve never had any other responsibility in your entire life, then you know every bit of every undocumented piece of folklore. You know which forums and which forum posters have the very long and bizarre command line that only. That. One. Guy. Knows. "_

 _"and THAT command line sequence can be gotten by getting on just the right IRC channel, at just the right time of night, and talking just the right way, to that one incredibly self-absorbed luser who happens to know that you need to put the undocumented"_

Okay.. so it is my day job and thus I do spend a significant part of every day doing the work, I will give you that.  But I have had plenty of dates (and am now happily married with a child on the way), lots of other responsibilities, and do not know lots of undocumented folklore (documented, sure).  I do not frequent forums except as the result of searches, and I do almost all of my help searches strictly at <a href="http://google.com/" target="_blank">google.com</a>.  There are times when I need more help than a search provides, and I use things like the mailing lists or IRC channels for that software.  I do not always get the help I need, but I usually get it figured out.  That being said... I rarely have those types of scenarios even with the bleeding edge things I play with all the time.

 _"Can you imagine my rank naivety here? I actually said Okay to a Linux update. I know I should have known better. ... But I didn’t. I figured that after all these years, Linux was finally robust enough to not rip me a new one because I just wanted to run a server and keep it up to date. Silly me! Silly, silly me!"_

So unless you are pulling in packages from all kinds of non-reliable repositories or letting manually installed software override package installed software this should not be an issue.  I would love to know what the root of this update issue was, because user error is the number one cause of package management updates on any systems in my organization.

 _"Sure, Linux machines can make great servers. But they require a dedicated group of Linux groupies who know all the folklore, all the secret handshakes, and where all the bodies are buried. "_

 _"That’s how you survive with a Linux distro apparently. Once it’s installed and works, never, ever update it."_

I install machines, turn on updating, and walk away.  They run.  I really do not know why you are having such an issue and would actually love to know the truth behind your problems. It boggles my mind to the point where I felt the need to write this blog entry.

Take into consideration that I have a fairly general philosophy about running software on systems am responsible for either installing or administering.

  1. Install software from trusted repositories.  IE: the distribution + one (two is pushing it, but doable) external repository.
  2. Do not configure repositories that have conflicting packages. (Do not turn on DAG and EPEL)
  3. Avoid unpackaged software. Only install packaged software if you can.  If it is not packaged, can you package it? It is not that hard, and other people benefit from your work.

With those 3 things in mind I usually have no issue with my systems.

_**"Oh, and one last point. Don’t go telling me I don’t know what I’m doing, because that proves my case against Linux. I know quite well what I’m doing, but not to the level that is apparently required to keep a simple LAMP machine running.** " (emphasis his)_

What I love about this quote is that he attempts to deflect any possibility that he is at fault by saying the requirement of someone to have entry level junior system administrator skills is to much to ask for from someone that wants to be a system administrator.

Now that all being said.  If you have a bad experience with Linux and are done with it, then fine.  Enjoy Windows, or try to.  Just remember that your experience is not the norm.  Linux has greatly improved over the years, and from what I hear Windows is starting to get to the same point with updates and usability as my experience with Linux's updates has been. Are Windows admins still waiting for SP1 or 2 before applying updates? I wish you luck.

On a final note, it does worry me that this is the type of person advising Washington on technical issues and using such a public forum to spread FUD.  Nothing in his background suggests that he is a competent system administrator.  Product management and development? While development and system administration tend to overlap, in my experience most developers turned system administrators are more likely to have all kinds of funky behavior and configuration patterns on their systems.
