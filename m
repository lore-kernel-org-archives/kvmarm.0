Return-Path: <SRS0=YeVi=I2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B4BC433C1
	for <kvmarm@archiver.kernel.org>; Sun, 28 Mar 2021 12:21:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 599EC6196E
	for <kvmarm@archiver.kernel.org>; Sun, 28 Mar 2021 12:21:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 599EC6196E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0DC54B1F5;
	Sun, 28 Mar 2021 08:21:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HwDzoLs+Ijtn; Sun, 28 Mar 2021 08:21:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D98B64B1EB;
	Sun, 28 Mar 2021 08:21:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BF584B1E3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Mar 2021 08:21:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GrIQ1hHhTxcd for <kvmarm@lists.cs.columbia.edu>;
 Sun, 28 Mar 2021 08:21:41 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0629C4B1E1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Mar 2021 08:21:40 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80ACF6196C;
 Sun, 28 Mar 2021 12:21:35 +0000 (UTC)
Date: Sun, 28 Mar 2021 13:21:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v10 2/6] arm64: kvm: Introduce MTE VM feature
Message-ID: <20210328122131.GB17535@arm.com>
References: <20210312151902.17853-1-steven.price@arm.com>
 <20210312151902.17853-3-steven.price@arm.com>
 <20210327152324.GA28167@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210327152324.GA28167@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Sat, Mar 27, 2021 at 03:23:24PM +0000, Catalin Marinas wrote:
> On Fri, Mar 12, 2021 at 03:18:58PM +0000, Steven Price wrote:
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 77cb2d28f2a4..b31b7a821f90 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -879,6 +879,22 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  	if (vma_pagesize == PAGE_SIZE && !force_pte)
> >  		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
> >  							   &pfn, &fault_ipa);
> > +
> > +	if (fault_status != FSC_PERM && kvm_has_mte(kvm) && pfn_valid(pfn)) {
> > +		/*
> > +		 * VM will be able to see the page's tags, so we must ensure
> > +		 * they have been initialised. if PG_mte_tagged is set, tags
> > +		 * have already been initialised.
> > +		 */
> > +		struct page *page = pfn_to_page(pfn);
> > +		unsigned long i, nr_pages = vma_pagesize >> PAGE_SHIFT;
> > +
> > +		for (i = 0; i < nr_pages; i++, page++) {
> > +			if (!test_and_set_bit(PG_mte_tagged, &page->flags))
> > +				mte_clear_page_tags(page_address(page));
> > +		}
> > +	}
> 
> This pfn_valid() check may be problematic. Following commit eeb0753ba27b
> ("arm64/mm: Fix pfn_valid() for ZONE_DEVICE based memory"), it returns
> true for ZONE_DEVICE memory but such memory is allowed not to support
> MTE.

Some more thinking, this should be safe as any ZONE_DEVICE would be
mapped as untagged memory in the kernel linear map. It could be slightly
inefficient if it unnecessarily tries to clear tags in ZONE_DEVICE,
untagged memory. Another overhead is pfn_valid() which will likely end
up calling memblock_is_map_memory().

However, the bigger issue is that Stage 2 cannot disable tagging for
Stage 1 unless the memory is Non-cacheable or Device at S2. Is there a
way to detect what gets mapped in the guest as Normal Cacheable memory
and make sure it's only early memory or hotplug but no ZONE_DEVICE (or
something else like on-chip memory)?  If we can't guarantee that all
Cacheable memory given to a guest supports tags, we should disable the
feature altogether.

> I now wonder if we can get a MAP_ANONYMOUS mapping of ZONE_DEVICE pfn
> even without virtualisation.

I haven't checked all the code paths but I don't think we can get a
MAP_ANONYMOUS mapping of ZONE_DEVICE memory as we normally need a file
descriptor.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
