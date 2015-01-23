# wirbelsturm-rpm-jq

Builds an RPM based on an official [jq](http://stedolan.github.io/jq/) binary release, using
[fpm](https://github.com/jordansissel/fpm).

Unfortunately the official jq project does not release ready-to-use RPM packages.  The RPM
script in this repository closes that gap.

The RPM created with this code is used by [Wirbelsturm](https://github.com/miguno/wirbelsturm).

---

Table of Contents

* <a href="#bootstrap">Bootstrapping</a>
* <a href="#supported-os">Supported target operating systems</a>
* <a href="#usage">Usage</a>
    * <a href="#build">Building the RPM</a>
    * <a href="#verify">Verifying the RPM</a>
    * <a href="#configuration">Custom configuration</a>
* <a href="#contributing">Contributing</a>
* <a href="#license">License</a>

---

<a name="bootstrap"></a>

# Bootstrapping

After a fresh checkout of this git repo you should first bootstrap the code.

    $ ./bootstrap

Basically, the bootstrapping will ensure that you have a suitable [fpm](https://github.com/jordansissel/fpm) setup.
If you already have `fpm` installed and configured you may try skipping the bootstrapping step.


<a name="supported-os"></a>

# Supported operating systems

## OS of the build server

It is recommended to run the RPM script [jq-rpm.sh](jq-rpm.sh) on a RHEL OS family machine.


## Target operating systems

The RPM files are built for the following operating system and architecture:

* RHEL 6 OS family (e.g. RHEL 6, CentOS 6, Amazon Linux), 64 bit


<a name="usage"></a>

# Usage


<a name="build"></a>

## Building the RPM

Syntax:

    $ ./jq-rpm.sh <jq-download-url-or-local-path>

To find a direct download URL visit the [jq downloads](http://stedolan.github.io/jq/download/) page.

Example:

    $ ./jq-rpm.sh http://stedolan.github.io/jq/download/linux64/jq

    >>> Will create jq-1.4.1_incubating.el6.x86_64.rpm

This will create an RPM that will install `jq` to `/usr/local/bin/jq`.


<a name="verify"></a>

## Verify the RPM

You can verify the proper creation of the RPM file with:

    $ rpm -qpi jq-*.rpm    # show package info
    $ rpm -qpR jq-*.rpm    # show package dependencies
    $ rpm -qpl jq-*.rpm    # show contents of package


<a name="configuration"></a>

## Custom configuration

You can modify [jq-rpm.sh](jq-rpm.sh) directly to modify the way the RPM is packaged.  For instance, you can
change the root level directory to something other than `/usr/local/bin/`, or modify the name of the package maintainer.


<a name="contributing"></a>

# Contributing to wirbelsturm-rpm-jq

Code contributions, bug reports, feature requests etc. are all welcome.

If you are new to GitHub please read [Contributing to a project](https://help.github.com/articles/fork-a-repo) for how
to send patches and pull requests to wirbelsturm-rpm-jq.


<a name="license"></a>

# License

Copyright © 2015 Michael G. Noll

See [LICENSE](LICENSE) for licensing information.
