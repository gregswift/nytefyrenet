+++
title = 'git reference guide - part one'
date = 2011-09-05T16:29:49-05:00
tags:
  "development",
  "git",
]
+++
I'm still getting used to utilizing git for my version control. The part I like most is the merge handling. So here is another reference post for me, hopefully it will help me remember bits of my git work flow. Mostly basics, and some I do not need to remind myself, but it does not hurt to document.

  * Checkout repository <pre class="lang:sh decode:true " >#Standard methods
<a title="git-clone man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-clone.html">git clone</a> git://<em>URL</em> <em>[directory name]</em>
git clone http://<em>URL</em> <em>[directory name]</em>

# or for an authenticated Fedora project repository:
git clone git://<em>user</em>@git.fedoraproject.org/git/<em>project</em>.git <em>[directory name]</em>

# or an authenticated github repository:
git clone git://git@github.com:<em>user</em>/<em>Project</em>.git <em>[directory name]</em>
git clone https://<em>user</em>@github.com/<em>user</em>/<em>Gluster</em>.git <em>[directory name]</em></pre>

  * Add a file to the index <pre class="lang:sh decode:true " ><a title="git add man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-add.html">git add</a> <em>path/to/file</em> <em>[more files]</em></pre>

  * See current status <pre class="lang:sh decode:true " ><a title="git status man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-status.html">git status</a> <em>path/to/file</em> <em>[more files]</em></pre>

  * See differences between current changes and committed changes <pre class="lang:sh decode:true " ><a title="git diff man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-diff.html">git diff</a> <em>path/to/file</em> <em>[more files]</em></pre>

  * Stash changes without committing them <pre class="lang:sh decode:true " ><a title="git stash man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-stash.html">git stash</a></pre>

  * Update local repository from remote <pre class="lang:sh decode:true " ><a title="git pull man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-pull.html">git pull</a></pre>

  * Commit changes in index <pre class="lang:sh decode:true " >#Full set of added changes
<a title="git commit man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-commit.html">git commit</a> -a

#Ignore index and commit specific file(s)
git commit <em>path/to/file</em> <em>[more files]</em></pre>

  * Generate a patch from local commit <pre class="lang:sh decode:true " ><a title="git format-patch man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-format-patch.html">git format-patch</a> <em>{origin, branch}</em></pre>
    
    Some useful options
    
      * -find-renames, -M _n_%
      * -output-directory, -o _dir_
      * -numbered, -n
      * -unnumbered, -N
      * -signoff, -s
  * Directly send locally committed patch via e-mail (see man page for Gmail config) <pre class="lang:sh decode:true " ><a title="git send-email man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-send-email.html">git send-email</a> --subject=<em>SUBJECT</em> --to=<em>address</em> <em>[--to=additional]</em> <em>file.patch</em></pre>

  * Apply a patch set <pre class="lang:sh decode:true " ><a title="git am man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-am.html">git am</a> --signoff <em>file.patch</em></pre>

  * Push changes to remote <pre class="lang:sh decode:true " ><a title="git push man page" href="http://www.kernel.org/pub/software/scm/git/docs/git-push.html">git push</a></pre>

That is it for now, but I know there will be at least one more of this because I have not touched on branching and switching around between repositories.
