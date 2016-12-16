From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Fri, 16 Dec 2016 18:00:43 +0100
Message-ID: <20161216170043.taaanbg5objnxjlh@breakpoint.cc>
References: <20161216105634.235457-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161216105634.235457-1-arnd@arndb.de>
Sender: linux-arch-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 2016-12-16 11:56:21 [+0100], Arnd Bergmann wrote:
> The original gcc-4.3 release was in early 2008. If we decide to still
> support that, we probably want the first 10 quirks in this series,
> while gcc-4.6 (released in 2011) requires none of them.

It this min gcc thingy ARM only?
The current minimium (documented) is gcc v3.2. With the -fno-PIE patches
I was going to raise the bar to at least v3.4 but did not get around to
it yet. hpa said that everything < 3.4 is broken on x86 [0].
Gert is getting code compiled on gcc v4.1 not sure if it is some kind of
gcc limitation or just for fun.
Unless people are stuck with some enterprise distro I don't see a reason
why one should not try a gcc-4.6 which is 5 years old. I had problems to
verify that the current kernel compiles with gcc v3.2 on x86 (it did
with a bunch of warnings with gcc 3.4 and booted).

[0] https://lkml.kernel.org/r/63c356a8-58a3-bc7e-88db-5c8071db15e1@zytor.com
> 	Arnd

Sebastian
