+++
title = 'Introducing &#8216;rhcpdl&#8217; project'
date = 2011-05-17T19:10:06-05:00
tags = [
  'development',
  'python',
  'redhat',
]
+++
I&#8217;ve been a Red Hat customer for over a decade now.  One of the things that has been a common work flow for me is the download of the ISOs from Red Hat&#8217;s web site (Previously through RHN, now Customer Portal). Because I usually store these on a central machine that is not my desktop, I often just copy the download URL, and wget it from my storage server&#8217;s cli. With the changes introduced by the new Customer Portal the URLs have changed in such a way that this process is much more difficult, although still do able. I complained through the support channel, and after >6m of waiting finally got back a response stating that this is not something they are interested in fixing. I have a hard time believing myself and a few others I know are the only ones affected by this so I have begun a protest of the process.  I&#8217;m also pretty sure that the only people this affects are the paying customers.

But in the nature of our community and open source my protest is not just a bunch of whining (although one could consider the explanation of the background for my protest whining, but take it as you will), but an actually attempt to &#8220;fix&#8221; the issue.

Step 1: I wrote and published a utility (<a rel="external" href="http://rhcpdl.googlecode.com/" target="_blank">rhcpdl</a>) that effectively restores this functionality  
Step 2: Attempt to get people to use/back that project so that maybe RH will realize they need to fix the issue

You can get more information from the project page at <a rel="external" href="http://rhcpdl.googlecode.com/" target="_blank">http://rhcpdl.googlecode.com</a>. There is also RPMs for RHEL5 and 6, and a SRPM available for download.

Remember, the goal of this project is obsolescence :)
