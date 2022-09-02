Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6188ECAAD5
	for <kvmarm@archiver.kernel.org>; Fri,  2 Sep 2022 14:47:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 847E949B0A;
	Fri,  2 Sep 2022 10:47:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Yj0rjkt5bhxb; Fri,  2 Sep 2022 10:47:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E43DF411BD;
	Fri,  2 Sep 2022 10:47:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CB82410F7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 10:47:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id na28dWu48oQW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Sep 2022 10:47:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A057B41174
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 10:47:37 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D47E1516;
 Fri,  2 Sep 2022 07:47:43 -0700 (PDT)
Received: from [10.57.45.3] (unknown [10.57.45.3])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 162FC3F766;
 Fri,  2 Sep 2022 07:47:34 -0700 (PDT)
Message-ID: <e72fee25-5ece-76f5-db53-dafa1fef6054@arm.com>
Date: Fri, 2 Sep 2022 15:47:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 4/7] arm64: mte: Lock a page for MTE tag initialisation
Content-Language: en-GB
To: Peter Collingbourne <pcc@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-5-pcc@google.com>
From: Steven Price <steven.price@arm.com>
In-Reply-To: <20220810193033.1090251-5-pcc@google.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Cornelia Huck <cohuck@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 Evgenii Stepanov <eugenis@google.com>
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

On 10/08/2022 20:30, Peter Collingbourne wrote:
> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> Initialising the tags and setting PG_mte_tagged flag for a page can race
> between multiple set_pte_at() on shared pages or setting the stage 2 pte
> via user_mem_abort(). Introduce a new PG_mte_lock flag as PG_arch_3 and
> set it before attempting page initialisation. Given that PG_mte_tagged
> is never cleared for a page, consider setting this flag to mean page
> unlocked and wait on this bit with acquire semantics if the page is
> locked:
> 
> - try_page_mte_tagging() - lock the page for tagging, return true if it
>   can be tagged, false if already tagged. No acquire semantics if it
>   returns true (PG_mte_tagged not set) as there is no serialisation with
>   a previous set_page_mte_tagged().
> 
> - set_page_mte_tagged() - set PG_mte_tagged with release semantics.
> 
> The two-bit locking is based on Peter Collingbourne's idea.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Peter Collingbourne <pcc@google.com>
> ---
>  arch/arm64/include/asm/mte.h     | 32 ++++++++++++++++++++++++++++++++
>  arch/arm64/include/asm/pgtable.h |  1 +
>  arch/arm64/kernel/cpufeature.c   |  2 +-
>  arch/arm64/kernel/mte.c          |  7 +++++--
>  arch/arm64/kvm/guest.c           | 16 ++++++++++------
>  arch/arm64/kvm/mmu.c             |  2 +-
>  arch/arm64/mm/copypage.c         |  2 ++
>  arch/arm64/mm/fault.c            |  2 ++
>  arch/arm64/mm/mteswap.c          |  3 +++
>  9 files changed, 57 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
> index 46618c575eac..ea5158f6f6cb 100644
> --- a/arch/arm64/include/asm/mte.h
> +++ b/arch/arm64/include/asm/mte.h
> @@ -36,6 +36,8 @@ void mte_free_tag_storage(char *storage);
>  
>  /* track which pages have valid allocation tags */
>  #define PG_mte_tagged	PG_arch_2
> +/* simple lock to avoid multiple threads tagging the same page */
> +#define PG_mte_lock	PG_arch_3
>  
>  static inline void set_page_mte_tagged(struct page *page)
>  {
> @@ -60,6 +62,32 @@ static inline bool page_mte_tagged(struct page *page)
>  	return ret;
>  }
>  
> +/*
> + * Lock the page for tagging and return 'true' if the page can be tagged,
> + * 'false' if already tagged. PG_mte_tagged is never cleared and therefore the
> + * locking only happens once for page initialisation.
> + *
> + * The page MTE lock state:
> + *
> + *   Locked:	PG_mte_lock && !PG_mte_tagged
> + *   Unlocked:	!PG_mte_lock || PG_mte_tagged
> + *
> + * Acquire semantics only if the page is tagged (returning 'false').
> + */
> +static inline bool try_page_mte_tagging(struct page *page)
> +{
> +	if (!test_and_set_bit(PG_mte_lock, &page->flags))
> +		return true;
> +
> +	/*
> +	 * The tags are either being initialised or have already been initialised,
> +	 * wait for the PG_mte_tagged flag to be set.
> +	 */
> +	smp_cond_load_acquire(&page->flags, VAL & (1UL << PG_mte_tagged));
> +
> +	return false;
> +}
> +
>  void mte_zero_clear_page_tags(void *addr);
>  void mte_sync_tags(pte_t old_pte, pte_t pte);
>  void mte_copy_page_tags(void *kto, const void *kfrom);
> @@ -84,6 +112,10 @@ static inline bool page_mte_tagged(struct page *page)
>  {
>  	return false;
>  }
> +static inline bool try_page_mte_tagging(struct page *page)
> +{
> +	return false;
> +}
>  static inline void mte_zero_clear_page_tags(void *addr)
>  {
>  }
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 82719fa42c0e..e6b82ad1e9e6 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1049,6 +1049,7 @@ static inline void arch_swap_invalidate_area(int type)
>  #define __HAVE_ARCH_SWAP_RESTORE
>  static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
>  {
> +	/* mte_restore_tags() takes the PG_mte_lock */
>  	if (system_supports_mte() && mte_restore_tags(entry, &folio->page))
>  		set_page_mte_tagged(&folio->page);
>  }
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 562c301bbf15..33d342ddef87 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2037,7 +2037,7 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
>  	 * Clear the tags in the zero page. This needs to be done via the
>  	 * linear map which has the Tagged attribute.
>  	 */
> -	if (!page_mte_tagged(ZERO_PAGE(0))) {
> +	if (try_page_mte_tagging(ZERO_PAGE(0))) {
>  		mte_clear_page_tags(lm_alias(empty_zero_page));
>  		set_page_mte_tagged(ZERO_PAGE(0));
>  	}
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index 2287316639f3..634e089b5933 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -41,6 +41,7 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
>  	if (check_swap && is_swap_pte(old_pte)) {
>  		swp_entry_t entry = pte_to_swp_entry(old_pte);
>  
> +		/* mte_restore_tags() takes the PG_mte_lock */
>  		if (!non_swap_entry(entry) && mte_restore_tags(entry, page)) {
>  			set_page_mte_tagged(page);
>  			return;
> @@ -50,8 +51,10 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
>  	if (!pte_is_tagged)
>  		return;
>  
> -	mte_clear_page_tags(page_address(page));
> -	set_page_mte_tagged(page);
> +	if (try_page_mte_tagging(page)) {
> +		mte_clear_page_tags(page_address(page));
> +		set_page_mte_tagged(page);
> +	}
>  }
>  
>  void mte_sync_tags(pte_t old_pte, pte_t pte)
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 3b04e69006b4..059b38e7a9e8 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -1067,15 +1067,19 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  					clear_user(tags, MTE_GRANULES_PER_PAGE);
>  			kvm_release_pfn_clean(pfn);
>  		} else {
> +			/*
> +			 * Only locking to serialise with a concurrent
> +			 * set_pte_at() in the VMM but still overriding the
> +			 * tags, hence ignoring the return value.
> +			 */
> +			try_page_mte_tagging(page);
>  			num_tags = mte_copy_tags_from_user(maddr, tags,
>  							MTE_GRANULES_PER_PAGE);
>  
> -			/*
> -			 * Set the flag after checking the write
> -			 * completed fully
> -			 */
> -			if (num_tags == MTE_GRANULES_PER_PAGE)
> -				set_page_mte_tagged(page);
> +			/* uaccess failed, don't leave stale tags */
> +			if (num_tags != MTE_GRANULES_PER_PAGE)
> +				mte_clear_page_tags(page);
> +			set_page_mte_tagged(page);
>  
>  			kvm_release_pfn_dirty(pfn);
>  		}
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1a3707aeb41f..750a69a97994 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1066,7 +1066,7 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
>  		return;
>  
>  	for (i = 0; i < nr_pages; i++, page++) {
> -		if (!page_mte_tagged(page)) {
> +		if (try_page_mte_tagging(page)) {
>  			mte_clear_page_tags(page_address(page));
>  			set_page_mte_tagged(page);
>  		}
> diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
> index 4223389b6180..a3fa650ceca4 100644
> --- a/arch/arm64/mm/copypage.c
> +++ b/arch/arm64/mm/copypage.c
> @@ -22,6 +22,8 @@ void copy_highpage(struct page *to, struct page *from)
>  	copy_page(kto, kfrom);
>  
>  	if (system_supports_mte() && page_mte_tagged(from)) {
> +		/* It's a new page, shouldn't have been tagged yet */
> +		WARN_ON_ONCE(!try_page_mte_tagging(to));
>  		mte_copy_page_tags(kto, kfrom);
>  		set_page_mte_tagged(to);
>  	}
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index d095bfa16771..6407a29cab0d 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -930,6 +930,8 @@ struct page *alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
>  
>  void tag_clear_highpage(struct page *page)
>  {
> +	/* Newly allocated page, shouldn't have been tagged yet */
> +	WARN_ON_ONCE(!try_page_mte_tagging(page));
>  	mte_zero_clear_page_tags(page_address(page));
>  	set_page_mte_tagged(page);
>  }
> diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
> index a78c1db23c68..cd5ad0936e16 100644
> --- a/arch/arm64/mm/mteswap.c
> +++ b/arch/arm64/mm/mteswap.c
> @@ -53,6 +53,9 @@ bool mte_restore_tags(swp_entry_t entry, struct page *page)
>  	if (!tags)
>  		return false;
>  
> +	/* racing tag restoring? */
> +	if (!try_page_mte_tagging(page))
> +		return false;
>  	mte_restore_page_tags(page_address(page), tags);

I feel like adding a "set_page_mte_tagged(page);" in here would avoid
the need for the comments about mte_restore_tags() taking the lock.

>  	return true;

Other than that nit, looks good.

Reviewed-by: Steven Price <steven.price@arm.com>

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
