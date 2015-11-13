From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] ARM64: use linux/types.h in kvm.h
Date: Fri, 13 Nov 2015 12:46:09 +0100
Message-ID: <8866273.XDAptVUNIk@wuerfel>
References: <9679324.UdV9GV0mFA@wuerfel> <20151113113843.GG12968@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DA7F48529
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2015 06:46:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FazJLANa+NDt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Nov 2015 06:46:00 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ECC5941280
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Nov 2015 06:45:59 -0500 (EST)
In-Reply-To: <20151113113843.GG12968@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Friday 13 November 2015 12:38:43 Christoffer Dall wrote:
> On Thu, Nov 12, 2015 at 03:41:08PM +0100, Arnd Bergmann wrote:
> > We should always use linux/types.h instead of asm/types.h for
> > consistency, and Kbuild actually warns about it:
> > 
> > ./usr/include/asm/kvm.h:35: include of <linux/types.h> is preferred over <asm/types.h>
> > 
> > This patch does as Kbuild asks us.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> I don't see this error when building the kernel, does it require a
> special option to check for these things?

CONFIG_HEADERS_CHECK should be included in 'allmodconfig', which is the
configuration I used. I think at the moment, allmodconfig  builds fail,
so you don't get to this point unless you also apply my other fixes. 
 
> In any case, thanks for the patch, I have applied it.

Thanks!

	Arnd
