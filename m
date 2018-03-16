From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 12/26] KVM: arm/arm64: Move HYP IO VAs to the "idmap"
 range
Date: Fri, 16 Mar 2018 08:44:40 +0000
Message-ID: <c08d1000-51ff-62e0-40f6-b7ef16342250@arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180314165049.30105-13-marc.zyngier@arm.com> <5AAAC4F8.9050608@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <5AAAC4F8.9050608@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 15/03/18 19:09, James Morse wrote:
> Hi Marc,
> 
> On 14/03/18 16:50, Marc Zyngier wrote:
>> We so far mapped our HYP IO (which is essentially the GICv2 control
>> registers) using the same method as for memory. It recently appeared
>> that is a bit unsafe:
>>
>> We compute the HYP VA using the kern_hyp_va helper, but that helper
>> is only designed to deal with kernel VAs coming from the linear map,
>> and not from the vmalloc region... This could in turn cause some bad
>> aliasing between the two, amplified by the upcoming VA randomisation.
>>
>> A solution is to come up with our very own basic VA allocator for
>> MMIO. Since half of the HYP address space only contains a single
>> page (the idmap), we have plenty to borrow from. Let's use the idmap
>> as a base, and allocate downwards from it. GICv2 now lives on the
>> other side of the great VA barrier.
> 
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 9946f8a38b26..a9577ecc3e6a 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -43,6 +43,9 @@ static unsigned long hyp_idmap_start;
>>  static unsigned long hyp_idmap_end;
>>  static phys_addr_t hyp_idmap_vector;
>>  
>> +static DEFINE_MUTEX(io_map_lock);
>> +static unsigned long io_map_base;
>> +
>>  #define S2_PGD_SIZE	(PTRS_PER_S2_PGD * sizeof(pgd_t))
>>  #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
>>  
>> @@ -518,27 +521,37 @@ static void unmap_hyp_idmap_range(pgd_t *pgdp, phys_addr_t start, u64 size)
>>   *
>>   * Assumes hyp_pgd is a page table used strictly in Hyp-mode and
>>   * therefore contains either mappings in the kernel memory area (above
>> - * PAGE_OFFSET), or device mappings in the vmalloc range (from
>> - * VMALLOC_START to VMALLOC_END).
>> + * PAGE_OFFSET), or device mappings in the idmap range.
>>   *
>> - * boot_hyp_pgd should only map two pages for the init code.
>> + * boot_hyp_pgd should only map the idmap range, and is only used in
>> + * the extended idmap case.
>>   */
>>  void free_hyp_pgds(void)
>>  {
>> +	pgd_t *id_pgd;
>> +
>>  	mutex_lock(&kvm_hyp_pgd_mutex);
>>  
>> +	id_pgd = boot_hyp_pgd ? boot_hyp_pgd : hyp_pgd;
>> +
>> +	if (id_pgd) {
>> +		mutex_lock(&io_map_lock);
> 
> This takes kvm_hyp_pgd_mutex then io_map_lock ...
> 
> 
>> +		/* In case we never called hyp_mmu_init() */
>> +		if (!io_map_base)
>> +			io_map_base = hyp_idmap_start;
>> +		unmap_hyp_idmap_range(id_pgd, io_map_base,
>> +				      hyp_idmap_start + PAGE_SIZE - io_map_base);
>> +		mutex_unlock(&io_map_lock);
>> +	}
>> +
>>  	if (boot_hyp_pgd) {
>> -		unmap_hyp_idmap_range(boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
>>  		free_pages((unsigned long)boot_hyp_pgd, hyp_pgd_order);
>>  		boot_hyp_pgd = NULL;
>>  	}
>>  
>>  	if (hyp_pgd) {
>> -		unmap_hyp_idmap_range(hyp_pgd, hyp_idmap_start, PAGE_SIZE);
>>  		unmap_hyp_range(hyp_pgd, kern_hyp_va(PAGE_OFFSET),
>>  				(uintptr_t)high_memory - PAGE_OFFSET);
>> -		unmap_hyp_range(hyp_pgd, kern_hyp_va(VMALLOC_START),
>> -				VMALLOC_END - VMALLOC_START);
>>  
>>  		free_pages((unsigned long)hyp_pgd, hyp_pgd_order);
>>  		hyp_pgd = NULL;
> 
>> @@ -747,11 +761,43 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
>>  		return 0;
>>  	}
> 
>> +	mutex_lock(&io_map_lock);
> 
>> -	start = kern_hyp_va((unsigned long)*kaddr);
>> -	end = kern_hyp_va((unsigned long)*kaddr + size);
>> -	ret = __create_hyp_mappings(hyp_pgd, PTRS_PER_PGD, start, end,
>> -				     __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
>> +	/*
>> +	 * This assumes that we we have enough space below the idmap
>> +	 * page to allocate our VAs. If not, the check below will
>> +	 * kick. A potential alternative would be to detect that
>> +	 * overflow and switch to an allocation above the idmap.
>> +	 *
>> +	 * The allocated size is always a multiple of PAGE_SIZE.
>> +	 */
>> +	size = PAGE_ALIGN(size + offset_in_page(phys_addr));
>> +	base = io_map_base - size;
>> +
>> +	/*
>> +	 * Verify that BIT(VA_BITS - 1) hasn't been flipped by
>> +	 * allocating the new area, as it would indicate we've
>> +	 * overflowed the idmap/IO address range.
>> +	 */
>> +	if ((base ^ io_map_base) & BIT(VA_BITS - 1)) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	if (__kvm_cpu_uses_extended_idmap())
>> +		pgd = boot_hyp_pgd;
>> +
>> +	ret = __create_hyp_mappings(pgd, __kvm_idmap_ptrs_per_pgd(),
>> +				    base, base + size,
>> +				    __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
> 
> And here we have io_map_lock, but __create_hyp_mappings takes kvm_hyp_pgd_mutex.
> 
> There is another example of this in create_hyp_exec_mappings, I think making
> this the required order makes sense: if you are mapping to the KVM-IO region,
> you take the io_map_lock before taking the pgd lock to write in your allocated
> location. (free_hyp_pgds() is always going to need to take both).
> 
> Never going to happen, but it generates a lockdep splat[1].
> Fixup diff[0] below fixes it for me.

Thanks for noticing this.

In the end, I wonder if there is an actual need for this io_map_lock at
all. We can perfectly take the the pgd lock to allocate the IOVA area,
commit the allocation, drop the lock and call __create_hyp_mapping,
which is going to take it again.

What if the mapping fails? We end-up having committed the IOVA
allocation, and having dropped the lock makes it nigh impossibly to roll
it back. But failing a HYP mapping that early is pretty fatal anyway,
and we're going to tear down the whole of HYP, never mind the IOVA
allocator. So I'm more than tempted to do away with that extra lock, and
rely on the existing one. This isn't exactly a fast path anyway...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
