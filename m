Return-Path: <SRS0=DM5G=KP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E74BC433ED
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 17:50:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7984613E4
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 17:50:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7984613E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 214944B16F;
	Thu, 20 May 2021 13:50:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zYO0lX77UPTQ; Thu, 20 May 2021 13:50:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E644B4B1F6;
	Thu, 20 May 2021 13:50:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57AB24B170
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 13:50:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W7HXZlyzIqXP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 May 2021 13:50:44 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8895F4B16F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 13:50:44 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7A56613E8;
 Thu, 20 May 2021 17:50:40 +0000 (UTC)
Date: Thu, 20 May 2021 18:50:38 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v12 4/8] arm64: kvm: Introduce MTE VM feature
Message-ID: <20210520175037.GG12251@arm.com>
References: <20210517123239.8025-1-steven.price@arm.com>
 <20210517123239.8025-5-steven.price@arm.com>
 <20210520115426.GB12251@arm.com>
 <5f0996d6-0a6e-ebcd-afcd-8290faba6780@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5f0996d6-0a6e-ebcd-afcd-8290faba6780@arm.com>
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

On Thu, May 20, 2021 at 04:05:46PM +0100, Steven Price wrote:
> On 20/05/2021 12:54, Catalin Marinas wrote:
> > On Mon, May 17, 2021 at 01:32:35PM +0100, Steven Price wrote:
> >> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> >> index c5d1f3c87dbd..8660f6a03f51 100644
> >> --- a/arch/arm64/kvm/mmu.c
> >> +++ b/arch/arm64/kvm/mmu.c
> >> @@ -822,6 +822,31 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
> >>  	return PAGE_SIZE;
> >>  }
> >>  
> >> +static int sanitise_mte_tags(struct kvm *kvm, unsigned long size,
> >> +			     kvm_pfn_t pfn)
> >> +{
> >> +	if (kvm_has_mte(kvm)) {
> >> +		/*
> >> +		 * The page will be mapped in stage 2 as Normal Cacheable, so
> >> +		 * the VM will be able to see the page's tags and therefore
> >> +		 * they must be initialised first. If PG_mte_tagged is set,
> >> +		 * tags have already been initialised.
> >> +		 */
> >> +		unsigned long i, nr_pages = size >> PAGE_SHIFT;
> >> +		struct page *page = pfn_to_online_page(pfn);
> >> +
> >> +		if (!page)
> >> +			return -EFAULT;
> > 
> > IIRC we ended up with pfn_to_online_page() to reject ZONE_DEVICE pages
> > that may be mapped into a guest and we have no idea whether they support
> > MTE. It may be worth adding a comment, otherwise, as Marc said, the page
> > wouldn't disappear.
> 
> I'll add a comment.
> 
> >> +
> >> +		for (i = 0; i < nr_pages; i++, page++) {
> >> +			if (!test_and_set_bit(PG_mte_tagged, &page->flags))
> >> +				mte_clear_page_tags(page_address(page));
> > 
> > We started the page->flags thread and ended up fixing it for the host
> > set_pte_at() as per the first patch:
> > 
> > https://lore.kernel.org/r/c3293d47-a5f2-ea4a-6730-f5cae26d8a7e@arm.com
> > 
> > Now, can we have a race between the stage 2 kvm_set_spte_gfn() and a
> > stage 1 set_pte_at()? Only the latter takes a lock. Or between two
> > kvm_set_spte_gfn() in different VMs? I think in the above thread we
> > concluded that there's only a problem if the page is shared between
> > multiple VMMs (MAP_SHARED). How realistic is this and what's the
> > workaround?
> > 
> > Either way, I think it's worth adding a comment here on the race on
> > page->flags as it looks strange that here it's just a test_and_set_bit()
> > while set_pte_at() uses a spinlock.
> > 
> 
> Very good point! I should have thought about that. I think splitting the
> test_and_set_bit() in two (as with the cache flush) is sufficient. While
> there technically still is a race which could lead to user space tags
> being clobbered:
> 
> a) It's very odd for a VMM to be doing an mprotect() after the fact to
> add PROT_MTE, or to be sharing the memory with another process which
> sets PROT_MTE.
> 
> b) The window for the race is incredibly small and the VMM (generally)
> needs to be robust against the guest changing tags anyway.
> 
> But I'll add a comment here as well:
> 
> 	/*
> 	 * There is a potential race between sanitising the
> 	 * flags here and user space using mprotect() to add
> 	 * PROT_MTE to access the tags, however by splitting
> 	 * the test/set the only risk is user space tags
> 	 * being overwritten by the mte_clear_page_tags() call.
> 	 */

I think (well, I haven't re-checked), an mprotect() in the VMM ends up
calling set_pte_at_notify() which would call kvm_set_spte_gfn() and that
will map the page in the guest. So the problem only appears between
different VMMs sharing the same page. In principle they can be
MAP_PRIVATE but they'd be CoW so the race wouldn't matter. So it's left
with MAP_SHARED between multiple VMMs.

I think we should just state that this is unsafe and they can delete
each-others tags. If we are really worried, we can export that lock you
added in mte.c.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
