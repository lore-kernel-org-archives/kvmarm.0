Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15979C433E2
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 16:22:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 651822072A
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 16:22:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 651822072A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF5D04B1AF;
	Wed,  2 Sep 2020 12:22:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kYa6Adnsjvi1; Wed,  2 Sep 2020 12:22:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F11FB4B16F;
	Wed,  2 Sep 2020 12:22:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E904C4B16F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 12:22:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gOB8iW52Apnj for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 12:22:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 675A94B164
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 12:22:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0BD3F101E;
 Wed,  2 Sep 2020 09:22:16 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A16E3F66F;
 Wed,  2 Sep 2020 09:22:15 -0700 (PDT)
Subject: Re: [PATCH v3 09/21] KVM: arm64: Convert unmap_stage2_range() to
 generic page-table API
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-10-will@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <1f2e88b7-0265-195f-3bd8-4e1d5b8694e3@arm.com>
Date: Wed, 2 Sep 2020 17:23:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-10-will@kernel.org>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>
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

Hello,

On 8/25/20 10:39 AM, Will Deacon wrote:
> Convert unmap_stage2_range() to use kvm_pgtable_stage2_unmap() instead
> of walking the page-table directly.
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c | 57 +++++++++++++++++++++++++-------------------
>  1 file changed, 32 insertions(+), 25 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 704b471a48ce..751ce2462765 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -39,6 +39,33 @@ static bool is_iomap(unsigned long flags)
>  	return flags & KVM_S2PTE_FLAG_IS_IOMAP;
>  }
>  
> +/*
> + * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
> + * we may see kernel panics with CONFIG_DETECT_HUNG_TASK,
> + * CONFIG_LOCKUP_DETECTOR, CONFIG_LOCKDEP. Additionally, holding the lock too
> + * long will also starve other vCPUs. We have to also make sure that the page
> + * tables are not freed while we released the lock.
> + */
> +#define stage2_apply_range(kvm, addr, end, fn, resched)			\
> +({									\
> +	int ret;							\
> +	struct kvm *__kvm = (kvm);					\
> +	bool __resched = (resched);					\
> +	u64 next, __addr = (addr), __end = (end);			\
> +	do {								\
> +		struct kvm_pgtable *pgt = __kvm->arch.mmu.pgt;		\
> +		if (!pgt)						\
> +			break;						\

I'm 100% sure there's a reason why we've dropped the READ_ONCE, but it still looks
to me like the compiler might decide to optimize by reading pgt once at the start
of the loop and stashing it in a register. Would you mind explaining what I am
missing?

> +		next = stage2_pgd_addr_end(__kvm, __addr, __end);	\
> +		ret = fn(pgt, __addr, next - __addr);			\
> +		if (ret)						\
> +			break;						\
> +		if (__resched && next != __end)				\
> +			cond_resched_lock(&__kvm->mmu_lock);		\
> +	} while (__addr = next, __addr != __end);			\
> +	ret;								\
> +})

This seems unusual to me. We have a non-trivial, multiline macro which calls
cond_resched(), has 6 local variables, and is called from exactly one place.I am
curious why we are not open coding the loop in __unmap_stage2_range() or using a
function.

> +
>  static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>  {
>  	return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
> @@ -220,8 +247,8 @@ static inline void kvm_pgd_populate(pgd_t *pgdp, p4d_t *p4dp)
>   * end up writing old data to disk.
>   *
>   * This is why right after unmapping a page/section and invalidating
> - * the corresponding TLBs, we call kvm_flush_dcache_p*() to make sure
> - * the IO subsystem will never hit in the cache.
> + * the corresponding TLBs, we flush to make sure the IO subsystem will
> + * never hit in the cache.
>   *
>   * This is all avoided on systems that have ARM64_HAS_STAGE2_FWB, as
>   * we then fully enforce cacheability of RAM, no matter what the guest
> @@ -344,32 +371,12 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>  				 bool may_block)
>  {
>  	struct kvm *kvm = mmu->kvm;
> -	pgd_t *pgd;
> -	phys_addr_t addr = start, end = start + size;
> -	phys_addr_t next;
> +	phys_addr_t end = start + size;
>  
>  	assert_spin_locked(&kvm->mmu_lock);
>  	WARN_ON(size & ~PAGE_MASK);
> -
> -	pgd = mmu->pgd + stage2_pgd_index(kvm, addr);
> -	do {
> -		/*
> -		 * Make sure the page table is still active, as another thread
> -		 * could have possibly freed the page table, while we released
> -		 * the lock.
> -		 */
> -		if (!READ_ONCE(mmu->pgd))
> -			break;
> -		next = stage2_pgd_addr_end(kvm, addr, end);
> -		if (!stage2_pgd_none(kvm, *pgd))
> -			unmap_stage2_p4ds(mmu, pgd, addr, next);
> -		/*
> -		 * If the range is too large, release the kvm->mmu_lock
> -		 * to prevent starvation and lockup detector warnings.
> -		 */
> -		if (may_block && next != end)
> -			cond_resched_lock(&kvm->mmu_lock);
> -	} while (pgd++, addr = next, addr != end);
> +	WARN_ON(stage2_apply_range(kvm, start, end, kvm_pgtable_stage2_unmap,
> +				   may_block));
>  }
>  
>  static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
