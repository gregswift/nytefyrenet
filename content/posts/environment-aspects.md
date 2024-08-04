+++
title = "6 Key Aspects of Architecting Your Environments for Sprawl"
date = 2023-05-31T10:49:27-05:00
draft = true
+++

Naming is Hard, but often times when it comes to environments [read: 1 or more systems deployed together] Naming is Hard because there is so much to cover and sooo many constraints.

As the cloud grew in popularity it became common to name things based on randomly generated strings, sensical or not. Because we were supposed to treat systems as Cattle not Pets, and its easier to slaughter U12399918 than good ol' Bessie.

If absolutely every tool and service and more you use relies on metadata as the primary presentation layer, that can be amazing.  Sadly, that is rare.  Realistically, as there is no universal model, that just doesn't work.  You will be staring at something and have to go look up additional information to know what it is.

I'm writing another post on my general thoughts on naming but I wanted to address naming environments here, or more specifically the...

6 Key Aspects of [Naming] to Architect Your Environments for Sprawl.

workload
stack
instance
region
tier
generation

6? That seems like a lot, or maybe not enough? You don't think you need all of this? I mean, fair. I didn't used to either.  Its important to note that Order in the hierarchy may vary between companies, but variance inside a company is a risk to the future maintainers, who will likely curse you.


Before we start its important to call out [Greg's Pro-Tip #1 - NONE of these aspects should tie to your business organizational structure.]

## Workload

Each Application may have multiple components such as an api, web, database, cache layer, or any dozens+ of other types.  These are all different Workload types, you may have more, you may have less.  You may not even run them on separate servers when you are first starting off, which is not a great idea, but used to be super common.

### Examples
* api
* web
* db
* cache

These all make up your…

## [Application] Stack

The second attribute on our list. This is where we're showing our first "bucket" of tightly coordinated pieces in our Environment.

Stack is just a short way of saying Application (or App) Stack, which is the series of applications that go work together to make that specific part of the overall Environment function. A simple Stack may just be a stateless web app.  A complex Stack may be a largely interconnected and interdependent microservice-based stack with no real subdivision.

In a small company you might not feel the need to do this. You might only have one application so you only have one stack.

That's okay. And from that standpoint, I could see why you would leave it off. So, that's reasonable and you'll probably have several iterations of your systems before you definitely need this. But once you start growing, if you've got teams and applications separated out that only communicate via an API, event stream, or may not even communicate at all then there is value to this.

In larger environments you have large separate Stacks such as Identity, Sign up, Customer Demographics, etc.

### Examples (building upon previous components)

* api.frontend
* db.platform
* web.identity
* api.auth
* api.signup

## Instance

Another one that will feel unnecessary until it suddenly is. This is to help identify multiple iterations of the same Stack side-by-side, such as in the same region, cloud, etc where it would be very easy to confuse Instances. You might be asking, why would you do that?

I've had instances where we had applications running Kubernetes and we wanted them to be fully zone aware and we want to be able to upgrade everything in one zone without touching other zones. One way to accomplish this was running a separate deployment per-availability zone.

To present this in metadata, you might do `instance: one`. But in, DNS, you might make it a a qualifier on appended to Stack, like so: `frontend-01`. [Greg's Pro-Trip #4 - always delineate]

There may be a need to tag this on multiple parts of the metadata.  I'll show you in the examples.

### Examples (continuing to build)

* api.frontend-01
* db-01.platform
* web-01.identity-03
* api.auth.internal
* api.signup.i01

## [Environment] Tier

I've been pushing this term for a while now.  An Environment Tier is a development, test, qa, staging, pre-prod, production, whatever you call your "environments" most traditionally.  I hate naming overlaps and try to avoid it as much as possible.  You will _always_ want to include this in your naming, because if you label dev but not prod, it becomes hard to run reports or large actions because now its an inverse match (everything BUT dev).  Personally, I like to stick to: test, staging, prod (and yes i hate staging being 7 characters, but stg and stag are very meh).

### Examples (continuing to build)

* api.frontend-01.dev
* db-01.platform.staging
* web-01.identity-03.prod
* api.auth.internal.pre-prod
* api.signup.i01.prod

## Generation

The most recent addition to my list, and to be honest thats because we had finally worked all of this out enough that our naming was fairly good, and then we needed to deploy the next generation and didn't have a need to change the naming. I was like "well, shit".  So we changed it by adding a Generation.  Again, lots of ways to do this one but with DNS I lean towards this being the least specific part of the name.

### Examples (continuing to build)

* api.frontend-01.dev.g01
* db-01.platform.staging.g01
* web-01.identity-03.prod-g02 # if you remove the `g` then its easy to mix instance with generation - [Greg's Pro-Tip #48 - Disambiguate]
* api.auth.internal.pre-prod.g02
* api.signup.i01.g03

## Region

This will likely be the most obvious, but I've a few thoughts here.  First, [Greg's Pro-Tip #8 - don't re-name things].  If you are using a cloud provider and they have a name for the region, USE IT.  Second, even if you aren't currently planning, or even planning to move to multi-region anytime soon, use it.  It will help onboarding a bit, and definitely simplify when suddenly you need to support a 2nd region.

### Examples (continuing to build)

* api.frontend-01.us-east-1.dev.g01
* db-01.platform.staging.g01.us-west-2
* web-01.identity-03.eu-frankfurt.prod-02
* api.auth.internal.pre-prod.g02.australiasoutheast
* api.signup.i01.g03.us-central1-a
