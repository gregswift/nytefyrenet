+++
title = "Creating signed debian apt repository"
date = 2013-03-18T22:25:18-05:00
[taxonomies]
tags = [
  "general",
  "linux",
]
+++

**Update:** 2014.03.19 Use [freight](https://github.com/rcrowley/freight "freight - apt repositories made simple")

Recently had the pleasure(?) of having to resetup an apt repository. It had been managed by reprepro, but there apparently the underlying concept of [a single version per repository that is central to the implementation](http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=570623 "Debian bugzilla 570623 reprepro: please add multiple version management"). Seems kinda weird to me, as was it to some of the users of the repository. In an effort to resolve this and simplify our repository management I did some research and came up with a very simple solution.

Using the following references:

- [dpkg-scanpackages](http://wiki.debian.org/HowToSetupADebianRepository#dpkg-scanpackages_and_dpkg-scansources "Debian wiki dpkg-scanpackages") (which points to)
- [Debian Repository How-To](http://www.debian.org/doc/manuals/repository-howto/repository-howto.en.html "Debian Repository How To") which says obsolete.. but IMO it works and is simpler than the other options
- [apt-ftparchive](wiki.debian.org/HowToSetupADebianRepository#apt-ftparchive "Debian wiki apt-ftparchive") which points to
- [Automatic Debian Package Repository HOWTO](http://people.connexer.com/~roberto/howtos/debrepository "Automatic Debian Package Repository HOWTO") which is also _obsolete_ and recommends reprepro, which I already said doesn't meet the requirements.
- [Securing Apt](http://wiki.debian.org/SecureApt "Securing Apt")
- [How to use GnuPG in an automated environment](http://www.gnupg.org/faq/GnuPG-FAQ.html#how-can-i-use-gnupg-in-an-automated-environment "How to use GnuPG in an automated environment")
- [Initializing tasks based on filesystem events](http://www.howtoforge.com/triggering-commands-on-file-or-directory-changes-with-incron "Incron")

We already had a GPG key, so I didn't have to create a key, i just followed the instructions in [How to use GnuPG in an automated environment](http://www.gnupg.org/faq/GnuPG-FAQ.html#how-can-i-use-gnupg-in-an-automated-environment "How to use GnuPG in an automated environment") to generate a passwordless signing subkey using the existing gpg key. If you don't have a key already there are lots of resources available if you just search around a bit. Here is [one](http://www.gnupg.org/gph/en/manual.html#AEN26 "GPG Manual - Generating a keypair").

Once the private key was created I removed the original gpg keypair for that user off the system, storing it some place safe, and replaced it with the subkey's files I just created. This allows us to revoke the subkey if it or the server is compromised. Then we can generate a new subkey using the original key and the consumers of the repository won't need to change their installed key.

Next, we need to lay down a two things. A directory and a config file. In my example the directory will be the root of your domain on a web server. I'm not going to go into how to setup a web server here.

```bash
mkdir -p /srv/repo.example.com/debian
```

The config file is for apt-ftparchive to generate the Releases file. Following the instructions from [Automatic Debian Package Repository HOWTO](http://people.connexer.com/~roberto/howtos/debrepository "Automatic Debian Package Repository HOWTO") we generate _/srv/repo.com/debian/Releases.conf_

```bash
APT::FTPArchive::Release::Origin "Your name or organization";
APT::FTPArchive::Release::Label "Descriptive label";
APT::FTPArchive::Release::Suite "stable";
APT::FTPArchive::Release::Codename "debian";
APT::FTPArchive::Release::Architectures "noarch";
APT::FTPArchive::Release::Components "main";
APT::FTPArchive::Release::Description "More detailed description";

```

In my repository we only have noarch packages. No source packages, no architecture specific. Adjust that field as is necessary for your repository. We also only have one component section. I don't even think it ends up being relevant to this simple of a repository, the same as Suite. What matters is that the codename matches your directory. I used _debian_ for both, because ours is not specific to a Debian release such as "squeeze" or "wheezy".

With these files in place I created the following script to build the repository, and saved it as _/usr/local/bin/buildrepo.sh_:

```bash
#!/bin/sh
## Assign basic configuration
USER=bob
SOURCE=/home/${USER}/RELEASES
TARGET=/srv/repo.example.com/debian
GPGDIR=/home/${USER}/.gnupg
GPGKEY=<insert id of the subkey here just to be specific>
## Do the actual work
rm -f ${TARGET}/Release.gpg
rsync -a ${SOURCE}/*.deb ${TARGET}/
dpkg-scanpackages --multiversion ${TARGET} /dev/null > ${TARGET}/Packages
gzip -9c ${TARGET}/Packages > ${TARGET}/Packages.gz
apt-ftparchive -c=${TARGET}/Release.conf release ${TARGET} > ${TARGET}/Release
gpg -a --homedir ${GPGDIR} --default-key ${GPGKEY} -o ${TARGET}/Release.gpg ${TARGET}/Release
```

This script assumes that the packages are being uploaded to the _RELEASES_ directory of the user _bob_.

I create both Packages and Packages.gz because i didn't like seeing the Ign message when I did an apt-get update. You could consolidate it down to the one line and have just a single file.

Now for the fun part. With Incron you can configure the execution of a command/script based on filesystem events. Since packages are being pushed into /home/bob/RELEASES we want to monitor that directory. We have a large number of file event types we could trigger from, as can be seen under [inotify events of this man page.](http://linux.die.net/man/7/inotify "inotify man page") For our purposes **IN_CREATE** was what I used. I need to verify as **IN_CLOSE_WRITE** might be better for larger files. To configure this I run:

```bash
incrontab -e
```

Then added the following entry:

```bash
/home/bob/RELEASES IN_CREATE /usr/local/bin/buildrepo.sh
```

That's it! Now if you push a deb package into /home/bob/RELEASES the repository will get generated. The resulting repository can be accessed by configuring the following source on a client system.

```bash
deb http://repo.example.com/ debian/
```

Extra credit: add your public key to the /srv/repo.example.com/ directory so that users can add it to their local apt-key ring, which will otherwise complain.

```bash
wget -O - http://repo.example.com/pubkey.gpg | sudo apt-key add -
```
