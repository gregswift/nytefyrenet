+++
title = "git reference guide - part one"
date = 2011-09-05T16:29:49-05:00
[taxonomies]
tags = [
  "development",
  "git",
]
+++

I'm still getting used to utilizing git for my version control. The part I like most is the merge handling. So here is another reference post for me, hopefully it will help me remember bits of my git work flow. Mostly basics, and some I do not need to remind myself, but it does not hurt to document.

## Checkout repository - [git clone](http://www.kernel.org/pub/software/scm/git/docs/git-clone.html "git-clone man page")

```bash
# Simple http
git clone https://github.com/user/project.git [directory name]

# or for an authenticated Fedora project repository:
git clone git://user@git.fedoraproject.org/git/project.git [directory name]

# or an authenticated github repository:
git clone git://git@github.com:user/Project.git [directory name]
git clone https://user@github.com/user/Gluster.git [directory name]
```

## Add a file to the index - [git add](http://www.kernel.org/pub/software/scm/git/docs/git-add.html "git add man page")

```bash
git add path/to/file [more files]
```

## See current status - [git status](http://www.kernel.org/pub/software/scm/git/docs/git-status.html "git status")

```bash
git status [path/to/file] [more files]
```

## See differences between current changes and committed changes - [git diff](http://www.kernel.org/pub/software/scm/git/docs/git-diff.html "git diff")

## Stash changes without committing them - [git stash](http://www.kernel.org/pub/software/scm/git/docs/git-stash.html "git stash")

## Update local repository from remote - [git pull](http://www.kernel.org/pub/software/scm/git/docs/git-pull.html "git pullman page")

## Commit changes in index - [git commit](http://www.kernel.org/pub/software/scm/git/docs/git-commit.html "git commit man page")

```bash
#Full set of added changes
git commit -a

# Ignore index and commit specific file(s)
git commit path/to/file [more files]
```

## Generate a patch from local commit [git format-patch](http://www.kernel.org/pub/software/scm/git/docs/git-format-patch.html "git format-patch man page")

```bash
git format-patch {origin, branch}
```

Some useful options

- -find-renames, -M _n_%
- -output-directory, -o _dir_
- -numbered, -n
- -unnumbered, -N
- -signoff, -s

## Directly send locally committed patch via e-mail - [git send-email](http://www.kernel.org/pub/software/scm/git/docs/git-send-email.html "git send-email man page")

> see man page for Gmail config

```bash
git send-email --subject=SUBJECT --to=address [--to=additional] file.patch
```

## Apply a patch set - [git am](http://www.kernel.org/pub/software/scm/git/docs/git-am.html "git am man page")

```bash
git am --signoff file.patch
```

## Push changes to remote - [git push](http://www.kernel.org/pub/software/scm/git/docs/git-push.html "git push man page")

That is it for now, but I know there will be at least one more of this because I have not touched on branching and switching around between repositories.
