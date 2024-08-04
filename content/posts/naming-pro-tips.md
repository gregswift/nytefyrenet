+++
title = "Naming Pro Tips"
date = 2023-05-31T10:49:27-05:00
draft = true
+++
So, naming is hard. We've all agreed with this for a long while now.

But here are some protips from someone who has helped establish naming
standards at ever place i've ever worked (up until current gig.. nmfp)

naming pro-tip #1:

always identify where the names will be used. the weakest link typically
defines your criteria.

what do I mean? if you are using DNS, then periods can only be delimiters
between components, which are restricted to this basic regex:

```regexp
^[a-z][a-z0-9\-]
```

naming pro-tip #2:

[Consider the growth path of your architecture.](@/posts/drafts/environment-aspects.md "Environment Aspects")

naming pro-tip #3:

Never make a portion of the name implicit.

example: leaving `prod` off prod names, like databases, A records, account
names.

This will hurt at some point because it makes exploring data, automation,
reporting, etc a giant set of "AND NOT" rules

naming pro-tip #4

Consistency matters.

Going back and renaming everything will likely never happen, but having
defined the patterns and followed them helps reduce complication over
time.

If you don't like the standard your team/workplace defines after its
agreed on. too bad.

naming pro-tip #5

generation matters
