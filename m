From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Sat, 17 Dec 2016 12:29:50 +0100
Message-ID: <20161217112949.pghxlhdlxjzdumuo@mikejones.breakpoint.cc>
References: <20161216105634.235457-1-arnd@arndb.de>
 <20161216170043.taaanbg5objnxjlh@breakpoint.cc>
 <2778134.jZdhGefl4B@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kbuild-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2778134.jZdhGefl4B@wuerfel>
Sender: linux-kbuild-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 2016-12-16 23:00:27 [+0100], Arnd Bergmann wrote:
> On Friday, December 16, 2016 6:00:43 PM CET Sebastian Andrzej Siewior wrote:
> > On 2016-12-16 11:56:21 [+0100], Arnd Bergmann wrote:
> > > The original gcc-4.3 release was in early 2008. If we decide to still
> > > support that, we probably want the first 10 quirks in this series,
> > > while gcc-4.6 (released in 2011) requires none of them.
> > 
> > It this min gcc thingy ARM only?
> 
> This is part of the question that I'm trying to figure out myself.
> 
> Clearly having the same minimum version across all architectures simplifies
> things a lot, because many of the bugs in old versions are architecture
> independent. 

agreed.

> Then again, some architectures implicitly require a new version
> because an old one never existed (e.g. arm64 or risc-v), while some other
> architectures may require an old version.

A new version is understandable. But why is an old version required?
One thing is an enterprise distro that is "current" or "supported" and still
stuck with gcc 4.1 because that is the version they decided to include in
their release. This is sad. But you might want to ask yourself why you want
the latest kernel but an old gcc / binutils.

If you have an architecture that compiles with gcc v4.1 and not with gcc
latest stable / trunk then it is a sign that this port is not supported
properly / not heatly. One thing is something like avr32 which is not part of
upstream gcc due to some legal reason (that was my understanding a few years
ago). It might get to a problem for them once large parts of userland switch
to a later C++ standard which is gcc-5+.

> 	Arnd

Sebastian
