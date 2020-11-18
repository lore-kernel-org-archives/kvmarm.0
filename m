Return-Path: <SRS0=VMV7=EY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D04C6369E
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 16:50:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 04B8524858
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 16:50:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04B8524858
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 574FD4BA15;
	Wed, 18 Nov 2020 11:50:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jscVdGy24EVQ; Wed, 18 Nov 2020 11:50:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FE164B9F0;
	Wed, 18 Nov 2020 11:50:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8201A4B9F0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 11:50:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iVDxfNrQQVKf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Nov 2020 11:50:12 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 626C34B9EA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 11:50:12 -0500 (EST)
Received: from trantor (unknown [2.26.170.190])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B47CF2483F;
 Wed, 18 Nov 2020 16:50:04 +0000 (UTC)
Date: Wed, 18 Nov 2020 16:50:01 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v4 2/2] arm64: kvm: Introduce MTE VCPU feature
Message-ID: <X7VQua7YO4isMFPU@trantor>
References: <20201026155727.36685-1-steven.price@arm.com>
 <20201026155727.36685-3-steven.price@arm.com>
 <X7P1VLZhBh045tsr@trantor>
 <f34b3d16-8bc7-af9d-c0e0-fb114d2465aa@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f34b3d16-8bc7-af9d-c0e0-fb114d2465aa@arm.com>
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

On Wed, Nov 18, 2020 at 04:01:20PM +0000, Steven Price wrote:
> On 17/11/2020 16:07, Catalin Marinas wrote:
> > On Mon, Oct 26, 2020 at 03:57:27PM +0000, Steven Price wrote:
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index 19aacc7d64de..38fe25310ca1 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -862,6 +862,26 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > >   	if (vma_pagesize == PAGE_SIZE && !force_pte)
> > >   		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
> > >   							   &pfn, &fault_ipa);
> > > +
> > > +	/*
> > > +	 * The otherwise redundant test for system_supports_mte() allows the
> > > +	 * code to be compiled out when CONFIG_ARM64_MTE is not present.
> > > +	 */
> > > +	if (system_supports_mte() && kvm->arch.mte_enabled && pfn_valid(pfn)) {
> > > +		/*
> > > +		 * VM will be able to see the page's tags, so we must ensure
> > > +		 * they have been initialised.
> > > +		 */
> > > +		struct page *page = pfn_to_page(pfn);
> > > +		long i, nr_pages = compound_nr(page);
> > > +
> > > +		/* if PG_mte_tagged is set, tags have already been initialised */
> > > +		for (i = 0; i < nr_pages; i++, page++) {
> > > +			if (!test_and_set_bit(PG_mte_tagged, &page->flags))
> > > +				mte_clear_page_tags(page_address(page));
> > > +		}
> > > +	}
> > 
> > If this page was swapped out and mapped back in, where does the
> > restoring from swap happen?
> 
> Restoring from swap happens above this in the call to gfn_to_pfn_prot()

Looking at the call chain, gfn_to_pfn_prot() ends up with
get_user_pages() using the current->mm (the VMM) and that does a
set_pte_at(), presumably restoring the tags. Does this mean that all
memory mapped by the VMM in user space should have PROT_MTE set?
Otherwise we don't take the mte_sync_tags() path in set_pte_at() and no
tags restored from swap (we do save them since when they were mapped,
PG_mte_tagged was set).

So I think the code above should be similar to mte_sync_tags(), even
calling a common function, but I'm not sure where to get the swap pte
from.

An alternative is to only enable HCR_EL2.ATA and MTE in guest if the vmm
mapped the memory with PROT_MTE.

Yet another option is to always call mte_sync_tags() from set_pte_at()
and defer the pte_tagged() or is_swap_pte() checks to the MTE code.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
