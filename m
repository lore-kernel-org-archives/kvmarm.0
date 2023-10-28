Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4DF7945F
	for <kvmarm@lists.linux.dev>; Sat, 28 Oct 2023 09:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F6851424;
	Sat, 28 Oct 2023 02:18:02 -0700 (PDT)
Received: from [10.57.70.251] (unknown [10.57.70.251])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C7493F762;
	Sat, 28 Oct 2023 02:17:19 -0700 (PDT)
Message-ID: <418313c5-2094-4aaf-ae43-a1f3bf8e936f@arm.com>
Date: Sat, 28 Oct 2023 10:17:17 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: arm64: Use folio for THP adjustment
Content-Language: en-GB
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org,
 oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, will@kernel.org, willy@infradead.org
References: <20230928173205.2826598-1-vdonnefort@google.com>
 <20230928173205.2826598-3-vdonnefort@google.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20230928173205.2826598-3-vdonnefort@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/09/2023 18:32, Vincent Donnefort wrote:
> Since commit cb196ee1ef39 ("mm/huge_memory: convert
> do_huge_pmd_anonymous_page() to use vma_alloc_folio()"), transparent
> huge pages use folios. It enables us to check efficiently if a page is
> mapped by a block simply looking at the folio size. This is saving a
> page table walk.
> 
> It is safe to read the folio in this path. We've just increased its
> refcount (GUP from __gfn_to_pfn_memslot()). This will prevent attempts
> of splitting the huge page.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index de5e5148ef5d..69fcbcc7aca5 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -791,51 +791,6 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>  	return 0;
>  }
>  
> -static struct kvm_pgtable_mm_ops kvm_user_mm_ops = {
> -	/* We shouldn't need any other callback to walk the PT */
> -	.phys_to_virt		= kvm_host_va,
> -};
> -
> -static int get_user_mapping_size(struct kvm *kvm, u64 addr)
> -{
> -	struct kvm_pgtable pgt = {
> -		.pgd		= (kvm_pteref_t)kvm->mm->pgd,
> -		.ia_bits	= vabits_actual,
> -		.start_level	= (KVM_PGTABLE_MAX_LEVELS -
> -				   CONFIG_PGTABLE_LEVELS),
> -		.mm_ops		= &kvm_user_mm_ops,
> -	};
> -	unsigned long flags;
> -	kvm_pte_t pte = 0;	/* Keep GCC quiet... */
> -	u32 level = ~0;
> -	int ret;
> -
> -	/*
> -	 * Disable IRQs so that we hazard against a concurrent
> -	 * teardown of the userspace page tables (which relies on
> -	 * IPI-ing threads).
> -	 */
> -	local_irq_save(flags);
> -	ret = kvm_pgtable_get_leaf(&pgt, addr, &pte, &level);
> -	local_irq_restore(flags);
> -
> -	if (ret)
> -		return ret;
> -
> -	/*
> -	 * Not seeing an error, but not updating level? Something went
> -	 * deeply wrong...
> -	 */
> -	if (WARN_ON(level >= KVM_PGTABLE_MAX_LEVELS))
> -		return -EFAULT;
> -
> -	/* Oops, the userspace PTs are gone... Replay the fault */
> -	if (!kvm_pte_valid(pte))
> -		return -EAGAIN;
> -
> -	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
> -}
> -
>  static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>  	.zalloc_page		= stage2_memcache_zalloc_page,
>  	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
> @@ -1274,7 +1229,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>   *
>   * Returns the size of the mapping.
>   */
> -static long
> +static unsigned long
>  transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>  			    unsigned long hva, kvm_pfn_t *pfnp,
>  			    phys_addr_t *ipap)
> @@ -1287,10 +1242,7 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>  	 * block map is contained within the memslot.
>  	 */
>  	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
> -		int sz = get_user_mapping_size(kvm, hva);
> -
> -		if (sz < 0)
> -			return sz;
> +		size_t sz = folio_size(pfn_folio(pfn));

Hi,

Sorry this is an extremely late reply - I just noticed this because Marc
mentioned it in another thread.

This doesn't look quite right to me; just because you have a folio of a given
size, that doesn't mean the whole thing is mapped into this particular address
space. For example, you could have a (PMD-sized) THP that gets partially
munmapped - the folio is still PMD-sized but only some of it is mapped and
should be accessible to the process. Or you could have a large file-backed folio
(from a filesystem that supports large folios - e.g. XFS) but the application
only mapped part of the file.

Perhaps I've misunderstood and those edge cases can't happen here for some reason?

Thanks,
Ryan


>  
>  		if (sz < PMD_SIZE)
>  			return PAGE_SIZE;
> @@ -1385,7 +1337,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	kvm_pfn_t pfn;
>  	bool logging_active = memslot_is_logging(memslot);
>  	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
> -	long vma_pagesize, fault_granule;
> +	unsigned long vma_pagesize, fault_granule;
>  	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>  	struct kvm_pgtable *pgt;
>  
> @@ -1530,11 +1482,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
>  								   hva, &pfn,
>  								   &fault_ipa);
> -
> -		if (vma_pagesize < 0) {
> -			ret = vma_pagesize;
> -			goto out_unlock;
> -		}
>  	}
>  
>  	if (fault_status != ESR_ELx_FSC_PERM && !device && kvm_has_mte(kvm)) {

