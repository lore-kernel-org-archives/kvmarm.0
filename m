Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0985F10A2D
	for <kvmarm@lists.linux.dev>; Mon, 30 Oct 2023 11:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93F24FEC;
	Mon, 30 Oct 2023 03:58:31 -0700 (PDT)
Received: from [10.57.71.117] (unknown [10.57.71.117])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C3B953F67D;
	Mon, 30 Oct 2023 03:57:48 -0700 (PDT)
Message-ID: <62c2b53d-5754-4eb3-832a-ab18534764f2@arm.com>
Date: Mon, 30 Oct 2023 10:57:47 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: arm64: Use folio for THP adjustment
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, oliver.upton@linux.dev,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, will@kernel.org, willy@infradead.org
References: <20230928173205.2826598-1-vdonnefort@google.com>
 <20230928173205.2826598-3-vdonnefort@google.com>
 <418313c5-2094-4aaf-ae43-a1f3bf8e936f@arm.com> <86o7gg1jhf.wl-maz@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <86o7gg1jhf.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/10/2023 10:40, Marc Zyngier wrote:
> On Sat, 28 Oct 2023 10:17:17 +0100,
> Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>> On 28/09/2023 18:32, Vincent Donnefort wrote:
>>> Since commit cb196ee1ef39 ("mm/huge_memory: convert
>>> do_huge_pmd_anonymous_page() to use vma_alloc_folio()"), transparent
>>> huge pages use folios. It enables us to check efficiently if a page is
>>> mapped by a block simply looking at the folio size. This is saving a
>>> page table walk.
>>>
>>> It is safe to read the folio in this path. We've just increased its
>>> refcount (GUP from __gfn_to_pfn_memslot()). This will prevent attempts
>>> of splitting the huge page.
>>>
>>> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>>>
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index de5e5148ef5d..69fcbcc7aca5 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -791,51 +791,6 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>>>  	return 0;
>>>  }
>>>  
>>> -static struct kvm_pgtable_mm_ops kvm_user_mm_ops = {
>>> -	/* We shouldn't need any other callback to walk the PT */
>>> -	.phys_to_virt		= kvm_host_va,
>>> -};
>>> -
>>> -static int get_user_mapping_size(struct kvm *kvm, u64 addr)
>>> -{
>>> -	struct kvm_pgtable pgt = {
>>> -		.pgd		= (kvm_pteref_t)kvm->mm->pgd,
>>> -		.ia_bits	= vabits_actual,
>>> -		.start_level	= (KVM_PGTABLE_MAX_LEVELS -
>>> -				   CONFIG_PGTABLE_LEVELS),
>>> -		.mm_ops		= &kvm_user_mm_ops,
>>> -	};
>>> -	unsigned long flags;
>>> -	kvm_pte_t pte = 0;	/* Keep GCC quiet... */
>>> -	u32 level = ~0;
>>> -	int ret;
>>> -
>>> -	/*
>>> -	 * Disable IRQs so that we hazard against a concurrent
>>> -	 * teardown of the userspace page tables (which relies on
>>> -	 * IPI-ing threads).
>>> -	 */
>>> -	local_irq_save(flags);
>>> -	ret = kvm_pgtable_get_leaf(&pgt, addr, &pte, &level);
>>> -	local_irq_restore(flags);
>>> -
>>> -	if (ret)
>>> -		return ret;
>>> -
>>> -	/*
>>> -	 * Not seeing an error, but not updating level? Something went
>>> -	 * deeply wrong...
>>> -	 */
>>> -	if (WARN_ON(level >= KVM_PGTABLE_MAX_LEVELS))
>>> -		return -EFAULT;
>>> -
>>> -	/* Oops, the userspace PTs are gone... Replay the fault */
>>> -	if (!kvm_pte_valid(pte))
>>> -		return -EAGAIN;
>>> -
>>> -	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
>>> -}
>>> -
>>>  static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>>>  	.zalloc_page		= stage2_memcache_zalloc_page,
>>>  	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
>>> @@ -1274,7 +1229,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>>>   *
>>>   * Returns the size of the mapping.
>>>   */
>>> -static long
>>> +static unsigned long
>>>  transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>>>  			    unsigned long hva, kvm_pfn_t *pfnp,
>>>  			    phys_addr_t *ipap)
>>> @@ -1287,10 +1242,7 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>>>  	 * block map is contained within the memslot.
>>>  	 */
>>>  	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
>>> -		int sz = get_user_mapping_size(kvm, hva);
>>> -
>>> -		if (sz < 0)
>>> -			return sz;
>>> +		size_t sz = folio_size(pfn_folio(pfn));
>>
>> Hi,
>>
>> Sorry this is an extremely late reply - I just noticed this because Marc
>> mentioned it in another thread.
>>
>> This doesn't look quite right to me; just because you have a folio of a given
>> size, that doesn't mean the whole thing is mapped into this particular address
>> space. For example, you could have a (PMD-sized) THP that gets partially
>> munmapped - the folio is still PMD-sized but only some of it is mapped and
>> should be accessible to the process. Or you could have a large file-backed folio
>> (from a filesystem that supports large folios - e.g. XFS) but the application
>> only mapped part of the file.
>>
>> Perhaps I've misunderstood and those edge cases can't happen here for some reason?
> 
> I went ahead and applied the following hack to the *current* tree,
> with this patch:
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 482280fe22d7..de365489a62f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1291,6 +1291,10 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>  	 */
>  	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
>  		int sz = get_user_mapping_size(kvm, hva);
> +		size_t fsz = folio_size(pfn_folio(pfn));
> +
> +		if (sz != fsz)
> +			pr_err("sz = %d fsz = %ld\n", sz,  fsz);
>  
>  		if (sz < 0)
>  			return sz;
> 
> and sure enough, I see the check firing under *a lot* of memory
> pressure:
> 
> 	[84567.458803] sz = 4096 fsz = 2097152
> 	[84620.166018] sz = 4096 fsz = 2097152
> 
> So indeed, folio_size() doesn't provide what we need. We absolutely
> need to match what is actually mapped in userspace or things may turn
> out to be rather ugly should the other pages that are part of the same
> folio be allocated somewhere else. Is that even possible?

Yes, I think so.

One such possibility is:

  1. user space maps a PMD-sized THP
  2. user space does a partial munmap
     - some of the PMD-sized folio is now PTE-mapped
     - folio is on the deferred split list
  3. user space creates a VM covering this memory
     - new faultly logic incorrectly determines its a PMD mapping, so PMD maps
       the whole folio
  4. memory pressure causes folios on the deferred split queue to be split
     - Unless you take an _entire_mapcount ref when you map. But even then, I
       doubt the deferred split queue will check that because once unamapped it
       should be impossible to remap that piece of the folio.
  5. The "unampped" pages of the folio we just split gets given back to the
     buddy
     - I guess if KVM took a ref then the page might not be given back to the
       buddy which would at least prevent this becoming a security issue
  6. Something else allocates that page...


A less severe scenario might involve mremap, where part of the THP is mremapped
in user space so its not all contiguous, but with your logic, the VM will see it
as contiguous.


> 
> 	M.
> 

