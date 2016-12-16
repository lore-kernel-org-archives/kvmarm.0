From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Fri, 16 Dec 2016 23:00:27 +0100
Message-ID: <2778134.jZdhGefl4B@wuerfel>
References: <20161216105634.235457-1-arnd@arndb.de>
 <20161216170043.taaanbg5objnxjlh@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2EBB40457
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 16:59:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IzXbIbplNNKC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Dec 2016 16:59:26 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79AC5403F5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 16:59:25 -0500 (EST)
In-Reply-To: <20161216170043.taaanbg5objnxjlh@breakpoint.cc>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org, kernel-build-reports@lists.linaro.org, linux-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Geert Uytterhoeven <geert@linux-m68k.org>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Friday, December 16, 2016 6:00:43 PM CET Sebastian Andrzej Siewior wrote:
> On 2016-12-16 11:56:21 [+0100], Arnd Bergmann wrote:
> > The original gcc-4.3 release was in early 2008. If we decide to still
> > support that, we probably want the first 10 quirks in this series,
> > while gcc-4.6 (released in 2011) requires none of them.
> 
> It this min gcc thingy ARM only?

This is part of the question that I'm trying to figure out myself.

Clearly having the same minimum version across all architectures simplifies
things a lot, because many of the bugs in old versions are architecture
independent. Then again, some architectures implicitly require a new version
because an old one never existed (e.g. arm64 or risc-v), while some other
architectures may require an old version.

	Arnd
