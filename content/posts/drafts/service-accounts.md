Tell me if this sounds familar.  You start a new job and notice that there are still a bunch of changes happening on all these different applications that your team or the company use.  You ask for information on it and find out that they are having to re-authenticate a bunch of systems because the original setup was done by the employee they just hired you to replace.  It probably comes as no suprise, and its good they are getting it cleaned up.

But what path did they use to fix it?  Hopefully, a service account, but not always.

Its 2023, and I hope that if you remember that situation, it was a while ago.  Sadly, not everyone has a solution for this.  Sometimes its the software's fault.  Lordy, the number of them that still make this difficult is ridiculous, but it has been getting better.

I've taken many approaches to this over the years, and I have to say I'm excited by all of the better solutions coming out now. For instance, GitHub Apps are async key authenticated. No direct tie to a single user, works for the life of the key, although rotation is still fun.[1]

When I first had to start dealing with service accounts the main pattern we landed on ended up rather cumbersome, a service account per source+destination system.  With this model you quickly creep beyond a reasonable amount of accounts that you are managing, and the name of the accounts is also cumbersome.  You can do something like "sa-${source}-${destination}" but its just weird looking keys that end up being called things like `sa-myteamsci-blahgithuborg` along side `sa-myteamsci-mehgithuborg` and `sa-myteamsci-myteamsartifactrepo` because teh reality if more than 1 team is involved and needs keys, you need to differentiate keys.

After dealing with that for a while I had one of those "duh" moments. With just that limited example the `myteamsci` system has at least 3 service accounts configured so it can connect where it needs to.  But what did that give me?  If a bad actor gets 1 of the service accounts, they can't access the others, but what are your leak paths? For us it was:

* The identity system: if they are getting your secret here, thats the least of your worries.
* Our credential store (think vault or 1password): Whether stored in the same bucket or different, if they are getting it here, bigger worries.
* Our orchestration/config management platform: Typically configured with a single cred that could access all the necessary bits from the credential store, is this the worst or just still a very scary access point?
* The source system, the most likely to get breached, but again, all the secrets in 1 place.
* The target system, if you are unlucky enough to have to manually configure credentials/keys.

So what did that _really_ give me?  Long user names, more users to manage, and [in]security through complexity.

So, following this duh moment I realized that lower complexity path of 'one service account per source system' had the exact same effective configuration. Rather than n+1 service accounts for that `myteamsci`, we now have 1 service account.









[1] Let's be honest, most people will never rotate it anyway.  Something to be said for setting it up, and having the configured copy be the only existing copy.  Recreate to fix if it ever breaks. Minimal leakage potential.

