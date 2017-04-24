From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Mon, 24 Apr 2017 17:53:37 +0100 (BST)
Message-ID: <alpine.LFD.2.20.1704241249350.32200@eddie.linux-mips.org>
References: <20161216105634.235457-1-arnd@arndb.de> <3302470.IDcDrWa0u6@wuerfel> <CAGXu5jLPRYi+HK=07Zndc8szEKD4mZCqaHJFnHmmoYr7tA1xPw@mail.gmail.com> <CAK8P3a2C2WhWjzF=HrzU15Ncg0juR+nstZukBEpqCrVNW5pnDA@mail.gmail.com> <CAGXu5jLTR+dY_Ayyix5Tg0Yn9LBFAt=j56MQVdJVGue-R-CizA@mail.gmail.com>
 <CAK8P3a114EVbnhbObfq-4pZp8XCT4fWzMXD+WkRi7iPXs1vFMA@mail.gmail.com> <CAGXu5jJpofLF0qAf0-2iNTesZt-X704Q7L=DpQYdtHY5n2HD0w@mail.gmail.com> <alpine.LFD.2.20.1704220400380.32200@eddie.linux-mips.org> <CAK8P3a28fi0GRcz1yLq+wRkaBBO_w74NnBCY7f3myg78JpaCCQ@mail.gmail.com>
 <CAMuHMdWTiurUSacddYXgW69=QwOrZDV3Zt2DezJauPy8j-GMHw@mail.gmail.com> <CAK8P3a32Y0AiKyVaotYb14uZZ1jM=nwhFD1vyP56epW1Y9KqSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a32Y0AiKyVaotYb14uZZ1jM=nwhFD1vyP56epW1Y9KqSw@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Kees Cook <keescook@chromium.org>, linux-arch <linux-arch@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 24 Apr 2017, Arnd Bergmann wrote:

> > If there's no real good reason (brokenness) to deprecate gcc-4.1, I would not
> > do it.I guess most people using old compilers know what they're doing.
> 
> What I'm trying to find out first is whether "people regularly using 10+
> year old compilers for the latest kernels" is a strict subset of "people in
> Geert's household".

 Well I do not live with Geert TBH.

> Given that none of the three architectures I looked at (arm, mips, x86)
> has successfully built any defconfig for a few years, it's quite possible
> that it's just you ;-) The other architectures that were around 10 years
> ago (so they might have someone who still has old toolchain binaries)
> and that still exist today are alpha, cris, frv, ia64, m32r, parisc, powerpc,
> s390, sh, sparc and xtensa. The first six are similar to m68k in that the
> hardware is mostly obsolete and the ports are kept around to support
> those old systems that might also use ancient toolchains, or new
> toolchains may be unmaintained or buggy, which could be a reason
> to keep 4.1 supported or at least try to find out if 4.1 (or even any other
> version) still works at all.

 Huh?

$ git log -1
commit 5a7ad1146caa895ad718a534399e38bd2ba721b7
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Apr 23 16:53:00 2017 -0700

    Linux 4.11-rc8
$ /usr/bin/time make ARCH=mips CROSS_COMPILE=mipsel-linux- decstation_defconfig vmlinux >/dev/null 2>&1
1014.19user 71.47system 19:33.24elapsed 92%CPU (0avgtext+0avgdata 
0maxresident)k18764inputs+242504outputs (704major+9549837minor)pagefaults 0swaps
$ mipsel-linux-gcc --version
gcc (GCC) 4.1.2
Copyright (C) 2006 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
$ 

Methinks it builds just fine.

  Maciej
