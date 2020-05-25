+++
title = "puppet tricks: staging puppet"
date = 2011-11-11T23:03:30-05:00
sort_by = date
tags = [
  "development",
  "linux",
  "puppet",
]
+++
As I have been learning [puppet](http://puppetlabs.com/puppet/how-puppet-works/ "How Puppet Works") @dayjob one of the things I have been striving to deal with is [order of operations](http://docs.puppetlabs.com/learning/ordering.html "Ordering with Puppet").  Puppet supports a few resource references, such as _before, after, notify,_ and _subscribe._ But my classes were quickly becoming slightly painful to define all these in, when the reality was there was not always hard dependencies so much as a preferred order.  After having issues with this for a while and researching other parts of puppet I stumbled across some mention of run stages, which were added in the 2.6.0 release of puppet.  If you read through the [language guide](https://www.puppetlabs.com/guides/language_guide.html "Puppet Language Guide") they are mentioned.  There has always been a single default stage, _main_.  But now you add as many as you want.  To define a stage you have to go into a manifest such as your **site.pp** and define the stages, like so:

```ruby
stage { [pre, post]: }
```

That defines the existence of two stages, a _pre_ stage for before _main_ and a _post_ for after _main_.  But I have not defined any ordering.  To do that we can do the following, still in **site.pp**:

```ruby
Stage[pre] -> Stage[main] -> Stage[post]
```

Thus telling puppet how to order these stages.  An alternate way would be:

```ruby
stage { 'pre': before => Stage['main'] }
stage { 'post': require => Stage['main'] }
```

It all depends on your style. So now that we have created the alternate stages, and told puppet what the ordering of these stages is, how do we associate our classes inside them?  It is fairly simple, when you are including a class or module you pass it in as a _class parameter._  To do this they introduced an alternate method of "including" a class.  Before you would use one of these two methods:

```ruby
class base {
    require users
    include packages
}
```

In this the base class requires that the users class is done before it, and then includes the packages class. Its fairly basic. Transitioning this to stages comes out like this:

```ruby
class base {
    class { users: stage => pre }
    include packages
}
```

It is very similar to calling a _define_.  In production I ended up where adding my base class in the _pre_ stage of a lot of classes, and which became kinda burdensome. I knew that there were universal bits that belonged in the _pre_ stage, and universal bits that did not. To simplify I settled on the following:

```ruby
class pre-base {
    include users
}

class base {
    class { pre-base: stage => pre }
    include packages
}
```

With this setup I do not have to worry about defining the stages multiple times. I even took it further by doing the same concept for the different groups that are also applied to systems, so the universal base and the group base are both configured as in the last example. I have not tried it with the _post_ stage, as I do not use one yet, but I would imagine it would work just as above. Here is an untested example:

```ruby
class pre-base {
    include users
}

class post-base {
    include monitoring
}

class base {
    class { pre-base: stage => pre }
    class { post-base: stage => post }
    include packages
}
```

Maybe this seems fairly obvious to people already using stages, but it took me a bit to arrive here, so hopefully it helps you out.

**UPDATE:** PuppetLabs' [stdlib module](http://forge.puppetlabs.com/puppetlabs/stdlib "PuppetLabs' stdlib module") provides a 'deeper' staging setup.  Here is the [manifest](https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/manifests/stages.pp "Puppetlabs stdlib stages.pp") in github.
