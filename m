Return-Path: <SRS0=HDjL=MW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB54CC4320A
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 14:07:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46C4260F94
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 14:07:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 46C4260F94
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C467B4B0B3;
	Fri, 30 Jul 2021 10:07:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4bONFFGiLw8N; Fri, 30 Jul 2021 10:07:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C705C4B0B7;
	Fri, 30 Jul 2021 10:07:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E4544A193
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 10:07:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S1imYL797VTp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jul 2021 10:07:16 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E088B4B0B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 10:07:15 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id A18AA60F94;
 Fri, 30 Jul 2021 14:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1627654034;
 bh=k4XJ9zveStKiRpAKx9X6DNnQlXVfFjJr2h2Z96smXy0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=YeHtVKPNwCWijDOU6aea/M2v3YF8KZIQOXmAKvam2VZEpbf1Pwi32kNcfd1h2Atn1
 LDptbBukrpbQ2AZ1gKOnMmMgKyR2l8rrdqxLBaKh8pKICexW1+9on67ZuzrPdFu2o5
 ii7zlMRyKeWjDD9ZELv0L1SC+cNVvfRgMWhRPo3lH7xVKNG3pqaJLShu9M0yLpmO4I
 WjbiwdVLBL1b7aM72plnjgyB/lcQex4SDwHHi6f6aXrfQHnSVxGiG4g4+R2zXPWrxq
 qGjMQBStMzISZ4OBdZzIiYpfSv6c1fCiAJ1j6TgJ5hSfkZsCoG0gpBa73i+TCXwPsY
 duxAv61sqtRMA==
Date: Fri, 30 Jul 2021 15:07:09 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 12/16] mm/ioremap: Add arch-specific callbacks on
 ioremap/iounmap calls
Message-ID: <20210730140709.GE23756@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-13-maz@kernel.org>
 <20210727181203.GG19173@willie-the-truck>
 <87tuked7mm.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87tuked7mm.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Srivatsa Vaddagiri <vatsa@codeaurora.org>, linux-kernel@vger.kernel.org,
 Shanker R Donthineni <sdonthineni@nvidia.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Jul 28, 2021 at 12:01:53PM +0100, Marc Zyngier wrote:
> On Tue, 27 Jul 2021 19:12:04 +0100,
> Will Deacon <will@kernel.org> wrote:
> > 
> > On Thu, Jul 15, 2021 at 05:31:55PM +0100, Marc Zyngier wrote:
> > > Add a pair of hooks (ioremap_page_range_hook/iounmap_page_range_hook)
> > > that can be implemented by an architecture.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  include/linux/io.h |  3 +++
> > >  mm/ioremap.c       | 13 ++++++++++++-
> > >  mm/vmalloc.c       |  8 ++++++++
> > >  3 files changed, 23 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/include/linux/io.h b/include/linux/io.h
> > > index 9595151d800d..0ffc265f114c 100644
> > > --- a/include/linux/io.h
> > > +++ b/include/linux/io.h
> > > @@ -21,6 +21,9 @@ void __ioread32_copy(void *to, const void __iomem *from, size_t count);
> > >  void __iowrite64_copy(void __iomem *to, const void *from, size_t count);
> > >  
> > >  #ifdef CONFIG_MMU
> > > +void ioremap_page_range_hook(unsigned long addr, unsigned long end,
> > > +			     phys_addr_t phys_addr, pgprot_t prot);
> > > +void iounmap_page_range_hook(phys_addr_t phys_addr, size_t size);
> > >  int ioremap_page_range(unsigned long addr, unsigned long end,
> > >  		       phys_addr_t phys_addr, pgprot_t prot);
> > >  #else
> > 
> > Can we avoid these hooks by instead not registering the regions proactively
> > in the guest and moving that logic to a fault handler which runs off the
> > back of the injected data abort? From there, we could check if the faulting
> > IPA is a memory address and register it as MMIO if not.
> > 
> > Dunno, you've spent more time than me thinking about this, but just
> > wondering if you'd had a crack at doing it that way, as it _seems_ simpler
> > to my naive brain.
> 
> I thought about it, but couldn't work out whether it was always
> possible for the guest to handle these faults (first access in an
> interrupt context, for example?).

If the check is a simple pfn_valid() I think it should be ok, but yes, we'd
definitely not want to do anything more involved given that this could run
in all sorts of horrible contexts.

> Also, this changes the semantics of the protection this is supposed to
> offer: any access out of the RAM space will generate an abort, and the
> fault handler will grant MMIO forwarding for this page. Stray accesses
> that would normally be properly handled as fatal would now succeed and
> be forwarded to userspace, even if there was no emulated devices
> there.

That's true, it would offer much weaker guarantees to the guest. It's more
like a guarantee that memory never traps to the VMM. It also then wouldn't
help with the write-combine fun. It would be simpler though, but with less
functionality.

> For this to work, we'd need to work out whether there is any existing
> device mapping that actually points to this page. And whether it
> actually is supposed to be forwarded to userspace. Do we have a rmap
> for device mappings?

I don't think this would be possible given your comments above.

So let's stick with the approach you've taken. It just feels like there
should be a way to do this without introducing new hooks into the core
code. If it wasn't for pci_remap_iospace(), we could simply hook our
definition of __ioremap_caller(). Another avenue to explore would be
looking at the IO resource instead; I see x86 already uses
IORES_MAP_ENCRYPTED and IORES_MAP_SYSTEM_RAM to drive pgprot...

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
