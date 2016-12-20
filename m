From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Tue, 20 Dec 2016 10:59:20 +0100
Message-ID: <20161220095920.GD4893@osiris>
References: <20161216105634.235457-1-arnd@arndb.de>
 <20161216170043.taaanbg5objnxjlh@breakpoint.cc>
 <2778134.jZdhGefl4B@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2778134.jZdhGefl4B@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>, linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 16, 2016 at 11:00:27PM +0100, Arnd Bergmann wrote:
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
> independent. Then again, some architectures implicitly require a new version
> because an old one never existed (e.g. arm64 or risc-v), while some other
> architectures may require an old version.

FWIW, s390 requires gcc 4.3 or newer since two years already. For older
compilers we enforce a compile error (see arch/s390/kernel/asm-offsets.c).
