From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 2/2] kvm: arm: Unify handling THP backed host memory
Date: Thu, 11 Apr 2019 16:16:48 +0100
Message-ID: <1bac514c-e4f0-a609-96ed-f48ef3461da1@arm.com>
References: <1554909297-6753-1-git-send-email-suzuki.poulose@arm.com>
 <1554909832-7169-1-git-send-email-suzuki.poulose@arm.com>
 <1554909832-7169-3-git-send-email-suzuki.poulose@arm.com>
 <c48b2bd4-68e6-dbc0-b010-78a23a889196@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c48b2bd4-68e6-dbc0-b010-78a23a889196@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, julien.thierry@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com, andrew.murray@arm.com, eric.auger@redhat.com, zhengxiang9@huawei.com, wanghaibin.wang@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Zhengui,

On 11/04/2019 02:59, Zenghui Yu wrote:
> Hi Suzuki,
> 
> On 2019/4/10 23:23, Suzuki K Poulose wrote:
>> We support mapping host memory backed by PMD transparent hugepages
>> at stage2 as huge pages. However the checks are now spread across
>> two different places. Let us unify the handling of the THPs to
>> keep the code cleaner (and future proof for PUD THP support).
>> This patch moves transparent_hugepage_adjust() closer to the caller
>> to avoid a forward declaration for fault_supports_stage2_huge_mappings().
>>
>> Also, since we already handle the case where the host VA and the guest
>> PA may not be aligned, the explicit VM_BUG_ON() is not required.
>>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: Zneghui Yu <yuzenghui@huawei.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>    virt/kvm/arm/mmu.c | 123 +++++++++++++++++++++++++++--------------------------
>>    1 file changed, 62 insertions(+), 61 deletions(-)
>>
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 6d73322..714eec2 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1380,53 +1380,6 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>>    	return ret;
>>    }
>>    
>> -static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
>> -{
>> -	kvm_pfn_t pfn = *pfnp;
>> -	gfn_t gfn = *ipap >> PAGE_SHIFT;
>> -	struct page *page = pfn_to_page(pfn);
>> -
>> -	/*
>> -	 * PageTransCompoundMap() returns true for THP and
>> -	 * hugetlbfs. Make sure the adjustment is done only for THP
>> -	 * pages.
>> -	 */
>> -	if (!PageHuge(page) && PageTransCompoundMap(page)) {
>> -		unsigned long mask;
>> -		/*
>> -		 * The address we faulted on is backed by a transparent huge
>> -		 * page.  However, because we map the compound huge page and
>> -		 * not the individual tail page, we need to transfer the
>> -		 * refcount to the head page.  We have to be careful that the
>> -		 * THP doesn't start to split while we are adjusting the
>> -		 * refcounts.
>> -		 *
>> -		 * We are sure this doesn't happen, because mmu_notifier_retry
>> -		 * was successful and we are holding the mmu_lock, so if this
>> -		 * THP is trying to split, it will be blocked in the mmu
>> -		 * notifier before touching any of the pages, specifically
>> -		 * before being able to call __split_huge_page_refcount().
>> -		 *
>> -		 * We can therefore safely transfer the refcount from PG_tail
>> -		 * to PG_head and switch the pfn from a tail page to the head
>> -		 * page accordingly.
>> -		 */
>> -		mask = PTRS_PER_PMD - 1;
>> -		VM_BUG_ON((gfn & mask) != (pfn & mask));
>> -		if (pfn & mask) {
>> -			*ipap &= PMD_MASK;
>> -			kvm_release_pfn_clean(pfn);
>> -			pfn &= ~mask;
>> -			kvm_get_pfn(pfn);
>> -			*pfnp = pfn;
>> -		}
>> -
>> -		return true;
>> -	}
>> -
>> -	return false;
>> -}
>> -
>>    /**
>>     * stage2_wp_ptes - write protect PMD range
>>     * @pmd:	pointer to pmd entry
>> @@ -1677,6 +1630,61 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>>    	       (hva & ~(map_size - 1)) + map_size <= uaddr_end;
>>    }
>>    
>> +/*
>> + * Check if the given hva is backed by a transparent huge page (THP)
>> + * and whether it can be mapped using block mapping in stage2. If so, adjust
>> + * the stage2 PFN and IPA accordingly. Only PMD_SIZE THPs are currently
>> + * supported. This will need to be updated to support other THP sizes.
>> + *
>> + * Returns the size of the mapping.
>> + */
>> +static unsigned long
>> +transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
>> +			    unsigned long hva, kvm_pfn_t *pfnp,
>> +			    phys_addr_t *ipap)
>> +{
>> +	kvm_pfn_t pfn = *pfnp;
>> +	struct page *page = pfn_to_page(pfn);
>> +
>> +	/*
>> +	 * PageTransCompoundMap() returns true for THP and
>> +	 * hugetlbfs. Make sure the adjustment is done only for THP
>> +	 * pages. Also make sure that the HVA and IPA are sufficiently
>> +	 * aligned and that the  block map is contained within the memslot.
>> +	 */
>> +	if (!PageHuge(page) && PageTransCompoundMap(page) &&
> 
> We managed to get here, ensure that we only play with normal size pages
> and no hugetlbfs pages will be involved.  "!PageHuge(page)" will always
> return true and we can let it go.

I think that is a bit tricky. If someone ever modifies the user_mem_abort()
and we end up in getting called with a HugeTLB backed page things could go
wrong.

I could do remove the check, but would like to add a WARN_ON_ONCE() to make
sure our assumption is held.

i.e,
	WARN_ON_ONCE(PageHuge(page));

	if (PageTransCompoundMap(page) &&>> +	 
fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {

...


Cheers
Suzuki
