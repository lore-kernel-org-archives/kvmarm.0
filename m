Return-Path: <SRS0=CMxQ=CU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F0CC43461
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 10:15:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 56E1B221EE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 10:15:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="eXhPl7rU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56E1B221EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D07A4B2CF;
	Fri, 11 Sep 2020 06:15:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yKYB-YqfH5UW; Fri, 11 Sep 2020 06:15:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66EA94B325;
	Fri, 11 Sep 2020 06:15:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B6EF4B31B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 06:15:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GJ8Kbur+ChJQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2020 06:15:11 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 150024B2C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 06:15:10 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D175D221EB;
 Fri, 11 Sep 2020 10:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599819309;
 bh=+CzF0mF+YSOYJSZqS25ga9AfZgrIRm01TNXQLXzoo78=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=eXhPl7rU037cAowgBTcAEXbqr0AdnUNdXrbtdQHybfdnoixpzWd/jpcRldJBnMMgI
 JdUleUeGifBs98HC+ccAEQGHZ/2CzgzGOPPty/wqqI8ADkD6sY4K4AnQrIMRRE7eJ0
 iON9hp2Qi0i5Gb0VNmUGtxVxvjXTlFt2PUCeEDLg=
Date: Fri, 11 Sep 2020 11:15:04 +0100
From: Will Deacon <will@kernel.org>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH v4 02/21] KVM: arm64: Add stand-alone page-table walker
 infrastructure
Message-ID: <20200911101504.GA19326@willie-the-truck>
References: <20200907152344.12978-1-will@kernel.org>
 <20200907152344.12978-3-will@kernel.org>
 <4ef01cff-71ac-7f3c-2404-af184f5a5cb4@arm.com>
 <20200910123712.GB18100@willie-the-truck>
 <20200910142159.GF93664@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200910142159.GF93664@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Sep 10, 2020 at 03:21:59PM +0100, Andrew Scull wrote:
> On Thu, Sep 10, 2020 at 01:37:13PM +0100, Will Deacon wrote:
> > On Wed, Sep 09, 2020 at 04:29:26PM +0100, Alexandru Elisei wrote:
> > > On 9/7/20 4:23 PM, Will Deacon wrote:
> > > > [..]
> > > > +
> > > > +int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > > > +		     struct kvm_pgtable_walker *walker)
> > > > +{
> > > > +	struct kvm_pgtable_walk_data walk_data = {
> > > > +		.pgt	= pgt,
> > > > +		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
> > > > +		.end	= PAGE_ALIGN(walk_data.addr + size),
> > > > +		.walker	= walker,
> > > > +	};
> > > 
> > > If the caller wants to walk [0x500, 0x1500), for PAGE_SIZE = 0x1000 (4K), the
> > > function walks the range [0x0, 0x1000). Is that intentional?
> > 
> > Yes, although the caller specifies a base and a *size*, rather than an end
> > address. As a concrete example, much of the hypervisor stage-1 mapping
> > is created using PAGE_SIZE mappings of random ELF symbols, which correspond
> > to arbitrary addresses. In these cases, we really do want to round-down the
> > address and perform a PAGE_SIZE mapping.
> 
> I think Alexandru has a point here. Turning his example into something
> equivalent that maps a random ELF symbol:
> 
>     struct some_hyp_state s = { ... };
>     // &s == 0x500
>     // sizeof(s) == PAGE_SIZE
>     kvm_pgtable_walk(&s, sizeof(s), walker);
> 
> Given `s` straddles the two pages, the part in the second page won't be
> mapped.
> 
> Should the end address instead be calculated as:
> 
>    .end = PAGE_ALIGN(addr + size),

Cheers for the example, and I see what you mean about structures that
straddle a page boundary. However, I think it's important here that the size
parameter accurately reflects the number of pages mapped: if the caller
passes PAGE_SIZE, we better not map more than a page, since the mmu cache
might not have enough pre-allocated pages for that.

So the API is just that the virtual address bits corresponding to the offset
within a page are ignored. Looking back at the code, that works out for the
hyp mappings (it's actually the _physical_ address that is unaligned there,
and we can just round that down), but I think I have a potential bug in the
ioremap code if you place the GIC (v2) somewhere funky on a machine using
64k pages. In this case, the ioctl() handler only enforces 4k alignment,
and so we could end up truncating the mapping in a similar case to what you
describe above. For example, trying to place it from 60k - 68k would result
in only the first page getting mapped.

I've fixed that in the ioremap code (diff below), and I'll update the
kerneldoc to say that the bottom bits of the VA are ignored.

Cheers,

Will

--->8

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1041be1fafe4..21b70abf65a7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -505,6 +505,9 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
                                     KVM_PGTABLE_PROT_R |
                                     (writable ? KVM_PGTABLE_PROT_W : 0);
 
+       size += offset_in_page(guest_ipa);
+       guest_ipa &= PAGE_MASK;
+
        for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
                ret = kvm_mmu_topup_memory_cache(&cache,
                                                 kvm_mmu_cache_min_pages(kvm));

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
