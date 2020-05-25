+++
title = "Editing image metadata with exiv2"
date = 2011-11-04T22:27:17-05:00
tags = [
  "images",
  "linux",
]
+++
My wife just had some maternity photos taken, and they came out wonderfully. I went to import them into [Shotwell](http://yorba.org/shotwell/ "Shotwell Open Source Photo manager") so we could upload them to her [Picasa](http://picasaweb.google.com "Picasa Web Albums") web albums (sorry, no link to her pictures)  and all the images imported in the year 2001 folder. I looked at the data and while their time stamps seemed reasonably correct, their date stamp was well over 10 years off.

I use Linux for my operating system, and a few quick good searches turned up the [man page for the program exiv2](http://linux.die.net/man/1/exiv2 "man exiv2"). And while a man page got me there, I figured it would not hurt to provide an example (both for myself and any of you lucky people who stumble upon it).

So, first lets look at the metadata of the image.jpg:

<pre>[xaeth@nytefyre Maternity]$ exiv2 image.jpg
 File name       : image.jpg
 File size       : 1454212 Bytes
 MIME type       : image/jpeg
 Image size      : 1672 x 2264
 Camera make     : Canon
 Camera model    : Canon EOS-1Ds Mark II
 <strong>Image timestamp : 2001:03:10 03:13:05</strong>
 Image number    :
 Exposure time   : 1/125 s
 Aperture        : F10
 Exposure bias   : 0 EV
 Flash           : No, compulsory
 Flash bias      :
 Focal length    : 59.0 mm
 Subject distance: Unknown
 ISO speed       : 100
 Exposure mode   : Manual
 Metering mode   : Multi-segment
 Macro mode      :
 Image quality   :
 Exif Resolution : 4992 x 3328
 White balance   : Auto
 Thumbnail       : image/jpeg, 6822 Bytes
 Copyright       :
 Exif comment    :</pre>

So it says in bold up there that this image was taken on March 10th, 2001 at 03:13:05 am (it is a 24h clock).  I am not specifically worried about the time, but the date will be nice several years from now.  So we need to adjust several things, which I am going to follow in parenthesis with the cli switch the man page says we need.  What needs to adjust is the <span style="color: #00ccff;">year (-Y)</span>, <span style="color: #00ff00;">month (-O)</span>, <span style="color: #ff00ff;">day (-D)</span>, AND <span style="color: #ff0000;">time (-a)</span>.  The trick with the adjustment you have to make is that it is a time shift, not a direct set.  You can not tell it the specific day, just to move the setting back or forwards, kinda like using the buttons on an alarm clock.  For all of the fields you can provide a negative or positive number, but the time field is a HH:MM:SS format with the minute and seconds being optional (but if you want to change seconds you need all 3). We want to move from March 10th, 2011 at 03:13:05am to October 15th, 2011 at about 3pmish. To do this we are going to have to adjust forward <span style="color: #00ccff;">10 years</span>, <span style="color: #00ff00;">7 months</span>, <span style="color: #ff00ff;">5 days</span>, and <span style="color: #ff0000;">12 hours</span>.  So this is how the command should look:

<pre>[xaeth@nytefyre Maternity]$ exiv2 <span style="color: #00ccff;">-Y 10</span> <span style="color: #00ff00;">-O 7</span> <span style="color: #ff00ff;">-D 5</span> <span style="color: #ff0000;">-a 12:00:00</span> <span style="color: #ff6600;">ad</span> image.jpg</pre>

The command does not return a visible success, which is very common for *nix applications.  But before we verify it you might be asking youself, "self, what the heck is that <span style="color: #ff6600;">ad</span> in the middle of his command?".  Well self, that is an _action_, telling exiv2 that it has to do something.  This is optional if the switches you are providing imply it.  All the switches I am using do, so my use was just overly explicit.  Anyway, as I was saying, there are other ways to verify if the command ran successfully that I won't go into here, but what better way than to check the metadata again!

<pre>[xaeth@nytefyre Maternity]$ exiv2 image.jpg
 File name       : image.jpg
 File size       : 1454152 Bytes
 MIME type       : image/jpeg
 Image size      : 1672 x 2264
 Camera make     : Canon
 Camera model    : Canon EOS-1Ds Mark II
 Image timestamp : <strong>2011:10:15 15:13:05</strong>
 Image number    :
 Exposure time   : 1/125 s
 Aperture        : F10
 Exposure bias   : 0 EV
 Flash           : No, compulsory
 Flash bias      :
 Focal length    : 59.0 mm
 Subject distance: Unknown
 ISO speed       : 100
 Exposure mode   : Manual
 Metering mode   : Multi-segment
 Macro mode      :
 Image quality   :
 Exif Resolution : 4992 x 3328
 White balance   : Auto
 Thumbnail       : image/jpeg, 6822 Bytes
 Copyright       :
 Exif comment    :</pre>

Yay!  Now I just do a quick loop through all the pictures in the directory and I have an updated set.

<pre>[xaeth@nytefyre Maternity]$ for image in *; do exiv2 <span style="color: #00ccff;">-Y 10</span> <span style="color: #00ff00;">-O 7</span> <span style="color: #ff00ff;">-D 5</span> <span style="color: #ff0000;">-a 12</span> ${image}; done</pre>

and voila... several dozen reasonably corrected dates in the metadata of those images.  If you noticed the command was slightly different, good for you.  For the actual loop I used the shortened time adjustment I mentioned earlier and left off the <span style="color: #ff6600;">ad</span>.
