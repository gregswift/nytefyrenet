+++
title = "git reference guide - part one"
date = 2011-09-05T16:29:49-05:00
sort_by = date
tags = [
  "development",
  "git",
]
+++
I'm still getting used to utilizing git for my version control. The part I like most is the merge handling. So here is another reference post for me, hopefully it will help me remember bits of my git work flow. Mostly basics, and some I do not need to remind myself, but it does not hurt to document.

# Checkout repository - <a title="git-clone man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-clone.html">git clone</a>
```bash
# Simple http
git clone https://github.com/user/project.git [directory name]

# or for an authenticated Fedora project repository:
git clone git://user@git.fedoraproject.org/git/project.git [directory name]

# or an authenticated github repository:
git clone git://git@github.com:user/Project.git [directory name]
git clone https://user@github.com/user/Gluster.git [directory name]
```

# Add a file to the index - <a title="git add man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-add.html">git add</a>
```bash
git add path/to/file [more files]
```

# See current status - <a title="git status man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-status.html">git status</a>
```bash
git status [path/to/file] [more files]
```

# See differences between current changes and committed changes - <a title="git diff man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-diff.html">git diff</a>

# Stash changes without committing them - <a title="git stash man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-stash.html">git stash</a>

# Update local repository from remote - <a title="git pull man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-pull.html">git pull</a>

# Commit changes in index - <a title="git commit man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-commit.html">git commit</a>
```bash
#Full set of added changes
git commit -a

#Ignore index and commit specific file(s)
git commit path/to/file [more files]
```

# Generate a patch from local commit <a title="git format-patch man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-format-patch.html">git format-patch</a>
```bash
git format-patch {origin, branch}
```
Some useful options
  * -find-renames, -M _n_%
  * -output-directory, -o _dir_
  * -numbered, -n
  * -unnumbered, -N
  * -signoff, -s

# Directly send locally committed patch via e-mail - <a title="git send-email man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-send-email.html">git send-email</a>
> see man page for Gmail config
```bash
git send-email --subject=SUBJECT --to=address [--to=additional] file.patch
```

# Apply a patch set - <a title="git am man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-am.html">git am</a>
```bash
git am --signoff file.patch
```

# Push changes to remote - <a title="git push man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-push.html">git push</a>

That is it for now, but I know there will be at least one more of this because I have not touched on branching and switching around between repositories.
