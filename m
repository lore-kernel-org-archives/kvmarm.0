Return-Path: <SRS0=f3Zk=JZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CCAC433B4
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 17:07:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5217B61440
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 17:07:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5217B61440
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C24F14B275;
	Wed, 28 Apr 2021 13:07:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rimpZQTK35wL; Wed, 28 Apr 2021 13:07:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A392D4B277;
	Wed, 28 Apr 2021 13:07:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D51B14B272
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 13:07:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tY3p6T5ZWXG5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Apr 2021 13:07:15 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 71F4D4B271
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 13:07:15 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0C11613B4;
 Wed, 28 Apr 2021 17:07:10 +0000 (UTC)
Date: Wed, 28 Apr 2021 18:07:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v11 2/6] arm64: kvm: Introduce MTE VM feature
Message-ID: <20210428170705.GB4022@arm.com>
References: <20210416154309.22129-1-steven.price@arm.com>
 <20210416154309.22129-3-steven.price@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210416154309.22129-3-steven.price@arm.com>
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

On Fri, Apr 16, 2021 at 04:43:05PM +0100, Steven Price wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 77cb2d28f2a4..5f8e165ea053 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -879,6 +879,26 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (vma_pagesize == PAGE_SIZE && !force_pte)
>  		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
>  							   &pfn, &fault_ipa);
> +
> +	if (fault_status != FSC_PERM && kvm_has_mte(kvm) && !device &&
> +	    pfn_valid(pfn)) {

In the current implementation, device == !pfn_valid(), so we could skip
the latter check.

> +		/*
> +		 * VM will be able to see the page's tags, so we must ensure
> +		 * they have been initialised. if PG_mte_tagged is set, tags
> +		 * have already been initialised.
> +		 */
> +		unsigned long i, nr_pages = vma_pagesize >> PAGE_SHIFT;
> +		struct page *page = pfn_to_online_page(pfn);
> +
> +		if (!page)
> +			return -EFAULT;

I think that's fine, though maybe adding a comment that otherwise it
would be mapped at stage 2 as Normal Cacheable and we cannot guarantee
that the memory supports MTE tags.

> +
> +		for (i = 0; i < nr_pages; i++, page++) {
> +			if (!test_and_set_bit(PG_mte_tagged, &page->flags))
> +				mte_clear_page_tags(page_address(page));
> +		}
> +	}
> +
>  	if (writable)
>  		prot |= KVM_PGTABLE_PROT_W;

I probably asked already but is the only way to map a standard RAM page
(not device) in stage 2 via the fault handler? One case I had in mind
was something like get_user_pages() but it looks like that one doesn't
call set_pte_at_notify(). There are a few other places where
set_pte_at_notify() is called and these may happen before we got a
chance to fault on stage 2, effectively populating the entry (IIUC). If
that's an issue, we could move the above loop and check closer to the
actual pte setting like kvm_pgtable_stage2_map().

While the set_pte_at() race on the page flags is somewhat clearer, we
may still have a race here with the VMM's set_pte_at() if the page is
mapped as tagged. KVM has its own mmu_lock but it wouldn't be held when
handling the VMM page tables (well, not always, see below).

gfn_to_pfn_prot() ends up calling get_user_pages*(). At least the slow
path (hva_to_pfn_slow()) ends up with FOLL_TOUCH in gup and the VMM pte
would be set, tags cleared (if PROT_MTE) before the stage 2 pte. I'm not
sure whether get_user_page_fast_only() does the same.

The race with an mprotect(PROT_MTE) in the VMM is fine I think as the
KVM mmu notifier is invoked before set_pte_at() and racing with another
user_mem_abort() is serialised by the KVM mmu_lock. The subsequent
set_pte_at() would see the PG_mte_tagged set either by the current CPU
or by the one it was racing with.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
