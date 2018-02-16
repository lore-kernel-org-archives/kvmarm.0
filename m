From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 14/19] KVM: arm/arm64: Move HYP IO VAs to the "idmap"
 range
Date: Fri, 16 Feb 2018 15:20:32 +0000
Message-ID: <63f3e571-9569-22d5-7c7a-1295f6f46624@arm.com>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
 <20180104184334.16571-15-marc.zyngier@arm.com> <20180118143953.GB21802@cbox>
 <1015096b-f9e5-9389-a2d9-1bc511e27f6b@arm.com> <20180216092543.GD10440@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180216092543.GD10440@cbox>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Steve Capper <steve.capper@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/02/18 09:25, Christoffer Dall wrote:
> On Thu, Feb 15, 2018 at 01:52:05PM +0000, Marc Zyngier wrote:
>> On 18/01/18 14:39, Christoffer Dall wrote:
>>> On Thu, Jan 04, 2018 at 06:43:29PM +0000, Marc Zyngier wrote:
>>>> We so far mapped our HYP IO (which is essencially the GICv2 control
>>>> registers) using the same method as for memory. It recently appeared
>>>> that is a bit unsafe:
>>>>
>>>> We compute the HYP VA using the kern_hyp_va helper, but that helper
>>>> is only designed to deal with kernel VAs coming from the linear map,
>>>> and not from the vmalloc region... This could in turn cause some bad
>>>> aliasing between the two, amplified by the upcoming VA randomisation.
>>>>
>>>> A solution is to come up with our very own basic VA allocator for
>>>> MMIO. Since half of the HYP address space only contains a single
>>>> page (the idmap), we have plenty to borrow from. Let's use the idmap
>>>> as a base, and allocate downwards from it. GICv2 now lives on the
>>>> other side of the great VA barrier.
>>>>
>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>> ---
>>>>  virt/kvm/arm/mmu.c | 56 +++++++++++++++++++++++++++++++++++++++++-------------
>>>>  1 file changed, 43 insertions(+), 13 deletions(-)
>>>>
>>>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>>>> index 6192d45d1e1a..14c5e5534f2f 100644
>>>> --- a/virt/kvm/arm/mmu.c
>>>> +++ b/virt/kvm/arm/mmu.c
>>>> @@ -43,6 +43,9 @@ static unsigned long hyp_idmap_start;
>>>>  static unsigned long hyp_idmap_end;
>>>>  static phys_addr_t hyp_idmap_vector;
>>>>  
>>>> +static DEFINE_MUTEX(io_map_lock);
>>>> +static unsigned long io_map_base;
>>>> +
>>>>  #define S2_PGD_SIZE	(PTRS_PER_S2_PGD * sizeof(pgd_t))
>>>>  #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
>>>>  
>>>> @@ -502,27 +505,31 @@ static void unmap_hyp_range(pgd_t *pgdp, phys_addr_t start, u64 size)
>>>>   *
>>>>   * Assumes hyp_pgd is a page table used strictly in Hyp-mode and
>>>>   * therefore contains either mappings in the kernel memory area (above
>>>> - * PAGE_OFFSET), or device mappings in the vmalloc range (from
>>>> - * VMALLOC_START to VMALLOC_END).
>>>> + * PAGE_OFFSET), or device mappings in the idmap range.
>>>>   *
>>>> - * boot_hyp_pgd should only map two pages for the init code.
>>>> + * boot_hyp_pgd should only map the idmap range, and is only used in
>>>> + * the extended idmap case.
>>>>   */
>>>>  void free_hyp_pgds(void)
>>>>  {
>>>> +	pgd_t *id_pgd;
>>>> +
>>>>  	mutex_lock(&kvm_hyp_pgd_mutex);
>>>>  
>>>> +	id_pgd = boot_hyp_pgd ? boot_hyp_pgd : hyp_pgd;
>>>> +
>>>> +	if (id_pgd)
>>>> +		unmap_hyp_range(id_pgd, io_map_base,
>>>> +				hyp_idmap_start + PAGE_SIZE - io_map_base);
>>>> +
>>>>  	if (boot_hyp_pgd) {
>>>> -		unmap_hyp_range(boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
>>>>  		free_pages((unsigned long)boot_hyp_pgd, hyp_pgd_order);
>>>>  		boot_hyp_pgd = NULL;
>>>>  	}
>>>>  
>>>>  	if (hyp_pgd) {
>>>> -		unmap_hyp_range(hyp_pgd, hyp_idmap_start, PAGE_SIZE);
>>>>  		unmap_hyp_range(hyp_pgd, kern_hyp_va(PAGE_OFFSET),
>>>>  				(uintptr_t)high_memory - PAGE_OFFSET);
>>>> -		unmap_hyp_range(hyp_pgd, kern_hyp_va(VMALLOC_START),
>>>> -				VMALLOC_END - VMALLOC_START);
>>>>  
>>>>  		free_pages((unsigned long)hyp_pgd, hyp_pgd_order);
>>>>  		hyp_pgd = NULL;
>>>> @@ -721,7 +728,8 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
>>>>  			   void __iomem **kaddr,
>>>>  			   void __iomem **haddr)
>>>>  {
>>>> -	unsigned long start, end;
>>>> +	pgd_t *pgd = hyp_pgd;
>>>> +	unsigned long base;
>>>>  	int ret;
>>>>  
>>>>  	*kaddr = ioremap(phys_addr, size);
>>>> @@ -733,17 +741,38 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
>>>>  		return 0;
>>>>  	}
>>>>  
>>>> +	mutex_lock(&io_map_lock);
>>>> +
>>>> +	base = io_map_base - size;
>>>
>>> are we guaranteed that hyp_idmap_start (and therefore io_map_base) is
>>> sufficiently greater than 0 ?  I suppose that even if RAM starts at 0,
>>> and the kernel was loaded at 0, the idmap page for Hyp would be at some
>>> reasonable offset from the start of the kernel image?
>>
>> On my kernel image:
>> ffff000008080000 t _head
>> ffff000008cc6000 T __hyp_idmap_text_start
>> ffff000009aaa000 B swapper_pg_end
>>
>> _hyp_idmap_text_start is about 12MB from the beginning of the image, and
>> about 14MB from the end. Yes, it is a big kernel. But we're only mapping
>> a few pages there, even with my upcoming crazy vector remapping crap. So
>> the likeliness of this failing is close to zero.
>>
>> Now, close to zero is not necessarily close enough. What I could do is
>> to switch the allocator around on failure, so that if we can't allocate
>> on one side, we can at least try to allocate on the other side. I'm
>> pretty sure we'll never trigger that code, but I can implement it if you
>> think that's worth it.
>>
> 
> I don't think we should necessarily implement it, my main concern is
> when reading the code, the reader has to concince himself/herself why
> this is always safe (and not just very likely to be safe).  I'm fine
> with adding a comment that explains this instead of implementing
> complicated logic though.  What do you think?

Oh, absolutely. I'll add a blurb about this.

> 
>>>
>>>> +	base &= ~(size - 1);
>>>
>>> I'm not sure I understand this line.  Wouldn't it make more sense to use
>>> PAGE_SIZE here?
>>
>> This is trying to align the base of the allocation to its natural size
>> (8kB aligned on an 8kB boundary, for example), which is what other
>> allocators in the kernel do. I've now added a roundup_pow_of_two(size)
>> so that we're guaranteed to deal with those.
>>
> 
> Ah right, it's just that I wasn't thinking of the size in terms of
> always being page aligned, so couldn't you here attempt two 4K
> allocations on a 64K page system, where one would overwrite the other?

Ah, I see what you mean. Well spotted. I'll turn that into a
max(roundup_pow_of_two(size), PAGE_SIZE).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
