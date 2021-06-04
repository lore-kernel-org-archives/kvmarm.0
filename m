Return-Path: <SRS0=VfsR=K6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A53C07E94
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 09:01:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 53E89613C9
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 09:01:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53E89613C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C90394B0E2;
	Fri,  4 Jun 2021 05:01:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JkfnKmnhUPhh; Fri,  4 Jun 2021 05:01:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7180F4B0F4;
	Fri,  4 Jun 2021 05:01:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B79C24B0E2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 05:01:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t6dnHvWNCMNk for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jun 2021 05:01:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9644F4B0D6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 05:01:32 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EA186140F;
 Fri,  4 Jun 2021 09:01:28 +0000 (UTC)
Date: Fri, 4 Jun 2021 10:01:26 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v13 4/8] KVM: arm64: Introduce MTE VM feature
Message-ID: <20210604090125.GA23321@arm.com>
References: <20210524104513.13258-1-steven.price@arm.com>
 <20210524104513.13258-5-steven.price@arm.com>
 <20210603160031.GE20338@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210603160031.GE20338@arm.com>
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

On Thu, Jun 03, 2021 at 05:00:31PM +0100, Catalin Marinas wrote:
> On Mon, May 24, 2021 at 11:45:09AM +0100, Steven Price wrote:
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index c5d1f3c87dbd..226035cf7d6c 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -822,6 +822,42 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
> >  	return PAGE_SIZE;
> >  }
> >  
> > +static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
> > +			     unsigned long size)
> > +{
> > +	if (kvm_has_mte(kvm)) {
> > +		/*
> > +		 * The page will be mapped in stage 2 as Normal Cacheable, so
> > +		 * the VM will be able to see the page's tags and therefore
> > +		 * they must be initialised first. If PG_mte_tagged is set,
> > +		 * tags have already been initialised.
> > +		 * pfn_to_online_page() is used to reject ZONE_DEVICE pages
> > +		 * that may not support tags.
> > +		 */
> > +		unsigned long i, nr_pages = size >> PAGE_SHIFT;
> > +		struct page *page = pfn_to_online_page(pfn);
> > +
> > +		if (!page)
> > +			return -EFAULT;
> > +
> > +		for (i = 0; i < nr_pages; i++, page++) {
> > +			/*
> > +			 * There is a potential (but very unlikely) race
> > +			 * between two VMs which are sharing a physical page
> > +			 * entering this at the same time. However by splitting
> > +			 * the test/set the only risk is tags being overwritten
> > +			 * by the mte_clear_page_tags() call.
> > +			 */
> 
> And I think the real risk here is when the page is writable by at least
> one of the VMs sharing the page. This excludes KSM, so it only leaves
> the MAP_SHARED mappings.
> 
> > +			if (!test_bit(PG_mte_tagged, &page->flags)) {
> > +				mte_clear_page_tags(page_address(page));
> > +				set_bit(PG_mte_tagged, &page->flags);
> > +			}
> > +		}
> 
> If we want to cover this race (I'd say in a separate patch), we can call
> mte_sync_page_tags(page, __pte(0), false, true) directly (hopefully I
> got the arguments right). We can avoid the big lock in most cases if
> kvm_arch_prepare_memory_region() sets a VM_MTE_RESET (tag clear etc.)
> and __alloc_zeroed_user_highpage() clears the tags on allocation (as we
> do for VM_MTE but the new flag would not affect the stage 1 VMM page
> attributes).

Another idea: if VM_SHARED is found for any vma within a region in
kvm_arch_prepare_memory_region(), we either prevent the enabling of MTE
for the guest or reject the memory slot if MTE was already enabled.

An alternative here would be to clear VM_MTE_ALLOWED so that any
subsequent mprotect(PROT_MTE) in the VMM would fail in
arch_validate_flags(). MTE would still be allowed in the guest but in
the VMM for the guest memory regions. We can probably do this
irrespective of VM_SHARED. Of course, the VMM can still mmap() the
memory initially with PROT_MTE but that's not an issue IIRC, only the
concurrent mprotect().

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
