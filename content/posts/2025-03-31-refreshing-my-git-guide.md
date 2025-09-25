+++
title = "Refreshing my git reference guide"
date = 2025-03-31T10:49:27-05:00
[taxonomies]
tags = [
  'cli',
  'development',
  'git',
]
+++

Its been over 15 years since I started using git, and almost 14 since I wrote a [set](@/posts/git-reference-guide-part-one.md) of [short](@/posts/git-reference-guide-part-two) [posts](@/posts/git-reference-guide-e28093-part-three/) about the references I use.  Since then I've come to a few preferences and setups that really simplify my workflow.

I'm gonna start with a a few mildly controversal opinions, but they are a core part to how I manage my workflow particularly with GitHub.

1. Always keep your branch current with rebase.
2. Always cleanup your commit history before having your proposed changes reviewed/merged.
3. When merging a change (PR, MR, whatever): Rebase > Merge Commit > Squash (so much so that I recommend disabling the last 2 explicitly).

Despite all of those, I will say that you should ultimately follow the practice of the repository you are commiting to.  But if you are the one setting the practices? Do these :D

These all tie hand in hand together in my opinion, and stem from the desire for a clean, understandable, and helpful git history in the project you are commiting to.  I'm not going to go into the why's myself because several people have already done some amazing write ups on it! Check them out.

* [Mastering Git — Why Rebase is amazing](https://hackernoon.com/mastering-git-why-rebase-is-amazing-a954485b128a)
* [What's the difference between the 3 GitHub Merge Types?](https://rietta.com/blog/github-merge-types)
* [Git Rebase VS Merge VS Squash: How to choose the right one?](https://dev.to/devsatasurion/git-rebase-vs-merge-vs-squash-how-to-choose-the-right-one-3a33)

Okay, so spicy-ness aside lets talk other helpful things.

## Multiple GitHub Accounts

I'm not a big fan of having multiple GitHub accounts, but there are several reasons you might end up here.  The main reason is that its not uncommon to have public GitHub for some projects and a private internal GitHub for your main work projects. Or you work on some open-source on GitHub but your company uses GitLab. Or any number of reasons.

The main path I use here I pulled from [this](https://blog.gitguardian.com/8-easy-steps-to-set-up-multiple-git-accounts/) article, steps 6-8. 

* `~/.gitconfig` - The vast majority of my gitconfig
* `~/.gitconfig.work` - The settings for my work's github account
* `~/.gitconfig.me` - The settings for my personal github account



So I've ended up using git commit --amend --no-edit && git push -f a lot here and a [friend of mine made a linkedin post recently with 2 recommendations](https://www.linkedin.com/feed/update/urn:li:activity:7297910317274050560) that tie in nicely..

setup these aliases in ~/.gitconfig:
```
commend = commit --amend --no-edit
please = push --force-with-lease
```

And these shell aliases
```
alias git-rebase='git-refresh && git rebase -i $(git merge-base origin/main $(git branch --show-current))'
alias git-refresh='git fetch --all -p && git rebase origin/main'
```




```
[init]
  defaultBranch = main

[branch]
  # autosetuprebase controls whether new branches should be set up to be rebased upon git pull,
  # i.e. your setting of always will result in branches being set up such that git pull always
  # performs a rebase, not a merge.
  # (Be aware that existing branches retain their configuration when you change this option.)
  autosetuprebase = always

[core]
  excludesfile = ~/.gitignore.default

[fetch]
  # Forces prune on branches on fetch/pull https://stackoverflow.com/a/18718936
  prune = true
  # Prunes tags
  pruneTags = true
  output = full

[help]
  autocorrect = prompt

[log]
  date = local

[rebase]
  autoStash = true

[pull]
  rebase = true
  recurseSubmodules = on-demand

[push]
  autoSetupRemote = true

[status]
  color = true
  submodulesummary = true
```



Associating ticket id in your commit message

So before conventional commit really took off, it was common with Jira Smart Commits to put the ticket at the front of the message.
This means when you are looking through subject line only views of commits (most views in GitHub or if you are using git log --oneline ) you will always get to see the ticket id, and in the GitHub UI it will also be linked (at least on our repos)
Your idea about putting it at the end of the summary line is a good suggestion, and maybe thats where we end up.  However the reason why I lean towards front still is because of how it facilitates accessible output, having it at the front aligns things visually which makes it "easier" to see them and reference them.
What I ultimately absolute hate is that the official "conventional commit" concept that gets leveraged is putting the ticket id in the footer using the ref: prefix for the line.
Cause that just hides it. (still works for smart commits, cause Jira leans towards flexibility

One frustrating aspect of putting it at the front is that anything (like argo workflows) that doesn't use the ticket id, then makes the output not consistent :disappointed:. Just like having a variable amount of characters cause multiple projects use the same repo.
Like this
```
b3f1524 IT-2938 feat(well.panasonic.com): Add Apple validation for domain
8f1267e chore(joinumi.com): Reformat the file and remove defaults
d6059a1 ENCH-1404 feat(joinumi.com): Add in the link.joinumi.com entries
de5e7ac ENGOPS-469 feat(joinumi.com): Add postmark DNS
```

Whereas in something that is just engops it might look more like this:
```
4bfd059f ENGOPS-259 feat(aws-eks): Support configuring argocd IRSA for centralized argocd control of the clusters
b1c835aa ENGOPS-270 fix(aws-secretsmanager-secret): Using random_id doesnt work greate for regenerate, just taint it
f77266b3 ENGOPS-177 feat(vault-group-policy): Enable group alias for association with oidc
5523bd1f ENGOPS-177 feat(vault-group-policy): Add building block module for Group based Vault policy management
f43a2d4a ENGOPS-176 chore(composition-aws-environment): Update dependency to address issue
5e599cf9 ENGOPS-176 fix(aws-eks): how did this make it through? misaligned variable names
fc9260e1 ENGOPS-176 fix(composition-aws-environment): for_each = toset() doesnt work well with generated values
de65c417 ENGOPS-176 !fix(aws-eks): for_each = toset() doesnt work well with generated values
f16790e4 ENGOPS-177 fix(vault-mount): dont do okta and policy stuff by default
55edb75b ENGOPS-177 feat(vault-mount): Add new module for defining a vault mount
```

My mind is also a little boggled by this pattern some devs are doing with feat(ENCH-XXXX):  o_O

```
37ce1e3 feat(ENCH-7898): update composition-auth0-tenant
6cce1e9b feat(ENCH-7898): setup user metadata for google oauth2 connections
be0e3e86 feat(ENCH-7898): update auth0-auth-flow-pwell-customer
53cb850e fix(ENCH-7898): parse given name from event.user.[given_name,name]
5a8e0278 feat(ENCH-7487): enable auth0 breach protection for reset pw & new users
63f6a8f9 chore(ENCH-7214): Bump tenant to include fixed reset password email template
128f0642 chore(ENCH-7214): Fix typo in password reset email template
f6d4b941 feat(ENCH-7214): Bump composition tenant to include new email templates
```
