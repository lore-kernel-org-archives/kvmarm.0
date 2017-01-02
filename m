From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Mon, 2 Jan 2017 12:23:47 +0000
Message-ID: <20170102122347.GB14217@n2100.armlinux.org.uk>
References: <20161216105634.235457-1-arnd@arndb.de>
 <20161216170043.taaanbg5objnxjlh@breakpoint.cc>
 <2778134.jZdhGefl4B@wuerfel>
 <20161217112949.pghxlhdlxjzdumuo@mikejones.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kbuild-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161217112949.pghxlhdlxjzdumuo@mikejones.breakpoint.cc>
Sender: linux-kbuild-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org, kernel-build-reports@lists.linaro.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Dec 17, 2016 at 12:29:50PM +0100, Sebastian Andrzej Siewior wrote:
> A new version is understandable. But why is an old version required?
> One thing is an enterprise distro that is "current" or "supported" and still
> stuck with gcc 4.1 because that is the version they decided to include in
> their release. This is sad. But you might want to ask yourself why you want
> the latest kernel but an old gcc / binutils.

To help isolate changes.

If you constantly upgrade everything, how do you bug hunt for a breakage?
How do you know whether it's created by the kernel, or by (eg) a later
version of gcc miscompiling the kernel.  You have a large amount of code
to start bug hunting through.

Sticking with particular tool versions long-term means that you build up
confidence in it - yes, sure, latent bugs exist, but it's easier to
bug hunt if you aren't constantly suspecting that your tools might be
broken.

For example, I build kernels with:

		gcc		binutils		built on
32-bit ARM	4.7.4		2.25			April/May 2015
64-bit ARM	4.9.2		2.25.51.20150219	Feb/April 2015

I'm not anticipating upgrading them for some time yet - the only one
which may get upgraded is the 64-bit binutils since later kernels now
complain about a missing errata workaround in that toolchain version.

I do still have some older toolchains around on some of my ARM boxes
though, even a GCC 3 version with ARM TLS support for faster builds!

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
