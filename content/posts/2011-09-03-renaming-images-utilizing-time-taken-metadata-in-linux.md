+++
title = "Renaming images utilizing time taken metadata in linux"
date = 2011-09-03T17:48:48-05:00
tags = [
  "development",
]
+++
This is more of a reminder for myself, but i figured I'd put it here.  The wifey wanted me to fix the naming on some pictures so that they were named based on their date.  Instead of manually doing so a quick search on Google showed me that the identify program that comes with the ImageMagick package in Linux will give me access to the data on the command line.  Taking the data and some awk-fu I threw together this quick one liner:

> <pre>for x in IMG*; do newname=`identify -verbose ${x} | awk '/date:modify/ {sub(/T/,"_"); gsub(/:/,"-"); split($2,stamp,"-"); print stamp[1]stamp[2]stamp[3]stamp[4]stamp[5] }'`; echo mv ${x} ${newname}.jpg; done</pre>

Since I am actually pretty prone to trial and error as I make my one-liners, I prefer for the command to print my commands out instead of executing them.  Makes it easier to spot errors before execution, and is just a simple copy-paste away from execution.

I'd break this out into a moreable block, but the awk section kinda goes on and on,  but here goes a breakdown

<pre>#The source images all start with IMG, so IMG* tells for to loop through all of them
for x in IMG*
do
    # I am going to create a new variable containing the output of my identify+awk
    # So first I have identify give me the verbose metadata about the image,
    # ${x}, piping the output to awk. For readability here I'm breaking this
    # into two lines with the \
    newname=`identify -verbose ${x} | \
            # Now we want awk to <span style="color: #00ccff;">only grab the line with the date:modify value</span>.
            # You'd think it would be date:create, but its not for some reason.
            # <span style="color: #00ff00;">Then we want to replace the T with an underscore.</span>  The T tells you
            # the rest of the line is the time and then to simplify our later
            # printing we <span style="color: #ffcc00;">make the colons in the time hyphens.</span>  We can't sub
            # them into nothing, which is annoying. Next <span style="color: #ff0000;">split on the hyphens</span>
            # <span style="color: #ff0000;">into a variable called stamp</span>. Then <span style="color: #993366;">print out only the YYYYMMDD_HHMMSS</span>.
            awk '<span style="color: #00ccff;">/date:modify/</span> {<span style="color: #00ff00;"> sub(/T/,"_")</span>;
                                 <span style="color: #ffcc00;">gsub(/:/,"-")</span>;
                                 <span style="color: #ff0000;">split($2,stamp,"-")</span>;
                                 <span style="color: #993366;">print stamp[1]stamp[2]stamp[3]stamp[4]stamp[5]</span> }'`
    # Now we want to print out the move commands from the original name to the
    #  newname, which will also end in a .jpg.
    echo mv ${x} ${newname}.jpg
done</pre>

So given a set of files named IMG\_2204.JPG, IMG\_2840.JPG, IMG_3204.JPG as a source into this we pull the following date:modify results (in order):

<pre>date:modify: 2011-03-30T20:22:46-05:00
date:modify: 2011-06-18T08:49:22-05:00
date:modify: 2011-07-02T09:28:39-05:00</pre>

And the final output from the script is:

<pre>mv IMG_2204.JPG 20110330_202246.jpg
mv IMG_2804.JPG 20110618_084922.jpg
mv IMG_3204.JPG 20110702_092839.jpg</pre>
