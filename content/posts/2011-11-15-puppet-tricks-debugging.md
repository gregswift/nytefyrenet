+++
title = "puppet tricks: debugging"
date = 2011-11-15T21:29:57-05:00
tags = [
  "development",
  "linux",
  "puppet",
]
+++
**Update:** (2012/9/30) I came up with this around the time I was using 0.25.  Apparently now you can do similar utilizing the -debug switch on the client along with debug() calls. I thought the function was only part of [PuppetLab](http://puppetlabs.com/ "PuppetLabs")'s [stdlib](http://forge.puppetlabs.com/puppetlabs/stdlib "Puppet Forge page for stdlib"), but apparently its in base, at least in 2.7+. I'll probably do a part 2 to this with more info, although there isn't much more.

**Update:** (2012/12/20) So the debug() function from stdlib is lame. I spent a while troubleshooting my new environment not getting messages and realized that rolling back to notice() worked. Could have sworn I tested it when I posted that. I did also run into an issue that naming the fact _debug_ is actually a bad idea and so have updated this blog accordingly.

**Update:** Found [this bug](http://projects.puppetlabs.com/issues/3704 "Puppet Bug 3708: Facter doesn't return booleans (converts them to strings instead)") that talks about the facts not returning as the appropriate types.

**Disclaimer:** I am not a ruby programmer... so there might be "easier" or "shorter" ways to do some of the things I do with ruby, but my aim is for readability, comprehensibility by non-programmers, and consistency.

In my time playing with puppet I have had to do a few things I was not pleased with.  Mainly I had to write several hundred lines of custom [facts](http://projects.puppetlabs.com/projects/1/wiki/Adding_Facts "Adding facts to facter") and [functions](http://docs.puppetlabs.com/guides/custom_functions.html "Custom functions in puppet").  Debugging was one of the biggest pains, until I found a [wonderful blog post](http://holyhandgrenade.org/blog/2011/03/calling-custom-functions-from-other-custom-functions-in-puppet/ "Calling custom functions from other custom functions in puppet") that helped me out with that.  Actually, when he helped me out with debugging I had already been to the site once because I ran into a bug related to the actual topic of his post, "calling custom functions from inside other custom functions".  Back to the matter at hand... when I first started working on custom functions I would leave exceptions all over my code and use them to step through the functions during debugging sessions.  While the code itself was short, this a tedious process as I would have to comment out each exception to move to the next one and then re-run the test.  It looked like this:

<pre class="lang:ruby decode:true " >checkval = someaction(var)
#raise Puppet::ParseError, &quot;checkval = #{checkval}&quot;
result = anotheraction(checkval)
raise Puppet::ParseError, &quot;result = #{result}&quot;</pre>

Then I found _function_notice_, which got rid of the commenting of exceptions by allowing me to log debug statements.  So I replaced all of my exceptions with _if_ wrapped _function_notice_ calls, resulting with:

<pre class="lang:ruby decode:true " >debug = true
checkval = someaction(var)
if debug
   function_notice(["checkval = #{checkval}"])
end
result = anotheraction(checkval)
if debug
   function_notice(["result = #{result}"])
end</pre>

An important thing to remember about _function_notice_ in a custom function is that the variable you pass to _function_notice_ must be a list.  I have not done anything other than send a single string inside a single list, so I could not speak to its other behaviors.  The length of the code increases greatly, and I do not actually do a debug for everything.  Overall this is a much better place to be.  However, now to enable _debug_ I have to edit the custom functions on the puppet master which requires a restart the service (puppetmasterd, apache, etc), and logs are generated for every client.  That is still a pain.  This is when I had a "supposed to be sleeping" late at night revelation.  You can _lookup_ facts and variables inside your custom functions!  So I created a very simple fact named _debug.rb_ that looks like this:

<pre class="lang:ruby decode:true " >Facter.add('puppet_debug') do
    debug = false
    if File.exists?('/etc/puppet/debug')
        debug = true
    end
    setcode do
        debug
    end
end</pre>

So what that means is that on any of my puppet clients I can enable debugging of my puppet setup by touching the file _/etc/puppet/debug_, and disable it by deleting that file.  To enable this in my custom function I change the definition of _debug_.

<pre class="lang:ruby decode:true " >debug = false
if lookup('puppet_debug') == 'true'
    debug = true
end
checkval = someaction(var)
if debug
    function_notice(["checkval = #{checkval}"])
end
result = anotheraction(checkval)
if debug
   function_notice(["result = #{result}"])
end</pre>

Now, this may seem like a kinda odd way to go about setting the _debug_ value, but while the code in the custom fact is working with the boolean value of **true**/**false**, when called as a fact it returns the string "true" or "false".  Since the string "false" is **true** from a boolean sense you could end up getting flooded with logs if you do a simply **true**/**false** check against the _lookup()_ result.  Thus, we default to **false** as that should be our normal working mode, and if the fact returns the string "true", we set _debug_ to **true**.  Now there is a custom fact providing _debug_, and a custom function utilizing it to log messages on the puppet server. Yay!  But wait, there is more!  Now that you have the custom fact defined, you can utilize it inside your puppet manifests in the same way!  Let take a look:

<pre class="lang:default decode:true " >class resolver {
  $nameservers = $gateway ? {
    /^192.168.1./ = ['192.168.1.25', '192.168.2.25'],
    /^192.168.2./ = ['192.168.2.25', '192.168.1.25'],
  }
  define print() { notify { "The value is: '${name}'": } }
  if ${::puppet_debug} {
    # On the server
    notice("${::hostname} is in ${::gateway} network")
    # On the client
    print { ${nameservers}: }
  }
}
</pre>

Wait, what? Sorry.. threw a few curve balls at you. <span style="color: #00ccff;">The <em>notify</em> call, which is not a local function, logs on the client side.</span> <span style="color: #ff6600;">Then I wrapped it in a <em>define</em> called <em>print</em>, <span style="color: #000000;">because I was going to <span style="color: #993366;">pass an array</span> to it.</span></span> By wrapping it in the _define_ it takes the <span style="color: #800080;">array</span> and performs the <span style="color: #00ccff;"><em>notify</em> call</span> on each object in the <span style="color: #993366;">array</span>. You can read more about this on [this page](http://www.devco.net/archives/2009/08/19/tips_and_tricks_for_puppet_debugging.php "Tips and Tricks for Puppet debugging"), under the sections _What is the value of a variable?_ and _Whats in an array?_.  The article has some nice explanations of a few other things as well.

Also, if you'd rather check for _$::debug_ than _$::puppet_debug_ then add the following to your _site.pp_:

<span class="lang:ruby decode:true crayon-inline " >$::debug = $::puppet_debug</span>
