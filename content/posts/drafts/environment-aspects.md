+++
title = "6 Key Aspects of Architecting Your Environments for Sprawl"
date = 2023-05-31T10:49:27-05:00
+++

Naming is hard, but often times when it comes to environments [read: 1 or more systems deployed together] Naming is Hard because there is so much to cover and sooo many constraints.

It's common become common to prefer to just name things based on randomly generated strings, sensical or not. Because Cattle not Pets.

If absolutely everything you use relies on metadata as the primary presentation layer, that can be amazing.  Sadly, its rarely pragmatic because
almost nothing is implemented in an ideal way with universal models.  For my general thoughts on naming I've got a whole other blog post I'm working on but
I wanted to address naming environments. Or more specifically the

6 Key Aspects of [naming] to Architect Your Environments for Sprawl.

6? that seems like a lot, or maybe not enough? Let's see what we've got:

workload
stack
instance
region
tier
generation

NONE of them should tie to your business organizational structure.

Order in the hierarchy may vary between companies, but variance inside a company is a risk to the future maintainers (who will likely curse you).
