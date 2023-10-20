Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E837199BE
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 14:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B68F143D;
	Fri, 20 Oct 2023 07:56:40 -0700 (PDT)
Received: from [10.1.30.154] (XHFQ2J9959.cambridge.arm.com [10.1.30.154])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF08E3F762;
	Fri, 20 Oct 2023 07:55:57 -0700 (PDT)
Message-ID: <4ec4e1f4-4391-4571-ae17-f2a82b3711e5@arm.com>
Date: Fri, 20 Oct 2023 15:55:56 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] arm64/mm: Update range-based tlb invalidation
 routines for FEAT_LPA2
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse
 <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20231009185008.3803879-1-ryan.roberts@arm.com>
 <20231009185008.3803879-3-ryan.roberts@arm.com>
 <87y1fy5nls.wl-maz@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <87y1fy5nls.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/10/2023 22:06, Marc Zyngier wrote:
> On Mon, 09 Oct 2023 19:49:58 +0100,
> Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>> The BADDR field of the range-based tlbi instructions is specified in
>> 64KB units when LPA2 is in use (TCR.DS=1), whereas it is in page units
>> otherwise.
>>
>> When LPA2 is enabled, use the non-range tlbi instructions to forward
>> align to a 64KB boundary first, then use range-based tlbi from there on,
>> until we have either invalidated all pages or we have a single page
>> remaining. If the latter, that is done with non-range tlbi. (Previously
>> we invalidated a single odd page first, but we can no longer do this
>> because it could wreck our 64KB alignment). When LPA2 is not in use, we
>> don't need the initial alignemnt step. However, the bigger impact is
>> that we can no longer use the previous method of iterating from smallest
>> to largest 'scale', since this would likely unalign the boundary again
>> for the LPA2 case. So instead we iterate from highest to lowest scale,
>> which guarrantees that we remain 64KB aligned until the last op (at
>> scale=0).
>>
>> The original commit (d1d3aa98 "arm64: tlb: Use the TLBI RANGE feature in
>> arm64") stated this as the reason for incrementing scale:
>>
>>   However, in most scenarios, the pages = 1 when flush_tlb_range() is
>>   called. Start from scale = 3 or other proper value (such as scale
>>   =ilog2(pages)), will incur extra overhead. So increase 'scale' from 0
>>   to maximum, the flush order is exactly opposite to the example.
>>
>> But pages=1 is already special cased by the non-range invalidation path,
>> which will take care of it the first time through the loop (both in the
>> original commit and in my change), so I don't think switching to
>> decrement scale should have any extra performance impact after all.
> 
> Surely this can be benchmarked. After all, HW supporting range
> invalidation is common enough these days.

Ahh, I think I see now what you were suggesting on the other thread; make the
change from incrementing scale to decrementing scale its own patch - and exclude
the LPA2 alignment stuff from it too. Then add all the other LPA2 specific stuff
in a separate patch.

Yes I can do that, and benchmark it. Kernel compilation is pretty TLBI
intensive; Sufficient to use that as the benchmark and run in VM on M2?

> 
>>
>> Note: This patch uses LPA2 range-based tlbi based on the new lpa2 param
>> passed to __flush_tlb_range_op(). This allows both KVM and the kernel to
>> opt-in/out of LPA2 usage independently. But once both are converted over
>> (and keyed off the same static key), the parameter could be dropped and
>> replaced by the static key directly in the macro.
> 
> Why can't this be done right away? Have a patch common to the two
> series that exposes the static key, and use that from the start. This
> would avoid the current (and rather ugly) extra parameter that I find
> unnecessarily hard to parse.
> 
> And if the 64kB alignment above is cheap enough, maybe this could
> become the one true way?

Yes, I can benchmark that too. Let's see what the data tells us then decide.

> 
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> ---
>>  arch/arm64/include/asm/tlb.h      |  6 +++-
>>  arch/arm64/include/asm/tlbflush.h | 46 ++++++++++++++++++++-----------
>>  arch/arm64/kvm/hyp/nvhe/tlb.c     |  2 +-
>>  arch/arm64/kvm/hyp/vhe/tlb.c      |  2 +-
>>  4 files changed, 37 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
>> index 93c537635dbb..396ba9b4872c 100644
>> --- a/arch/arm64/include/asm/tlb.h
>> +++ b/arch/arm64/include/asm/tlb.h
>> @@ -25,7 +25,6 @@ static void tlb_flush(struct mmu_gather *tlb);
>>   * get the tlbi levels in arm64.  Default value is TLBI_TTL_UNKNOWN if more than
>>   * one of cleared_* is set or neither is set - this elides the level hinting to
>>   * the hardware.
>> - * Arm64 doesn't support p4ds now.
>>   */
>>  static inline int tlb_get_level(struct mmu_gather *tlb)
>>  {
>> @@ -48,6 +47,11 @@ static inline int tlb_get_level(struct mmu_gather *tlb)
>>  				   tlb->cleared_p4ds))
>>  		return 1;
>>  
>> +	if (tlb->cleared_p4ds && !(tlb->cleared_ptes ||
>> +				   tlb->cleared_pmds ||
>> +				   tlb->cleared_puds))
>> +		return 0;
>> +
>>  	return TLBI_TTL_UNKNOWN;
>>  }
>>  
>> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
>> index e688246b3b13..4d34035fe7d6 100644
>> --- a/arch/arm64/include/asm/tlbflush.h
>> +++ b/arch/arm64/include/asm/tlbflush.h
>> @@ -136,10 +136,14 @@ static inline unsigned long get_trans_granule(void)
>>   * The address range is determined by below formula:
>>   * [BADDR, BADDR + (NUM + 1) * 2^(5*SCALE + 1) * PAGESIZE)
>>   *
>> + * If LPA2 is in use, BADDR holds addr[52:16]. Else BADDR holds page number.
>> + * See ARM DDI 0487I.a C5.5.21.
> 
> Please update this to the latest published ARM ARM. I know it will be
> obsolete quickly enough, but still. Also, "page number" is rather
> imprecise, and doesn't match the language of the architecture.

Will do.

> 
>> + *
>>   */
>> -#define __TLBI_VADDR_RANGE(addr, asid, scale, num, ttl)				\
>> +#define __TLBI_VADDR_RANGE(addr, asid, scale, num, ttl, lpa2)			\
>>  	({									\
>> -		unsigned long __ta = (addr) >> PAGE_SHIFT;			\
>> +		unsigned long __addr_shift = lpa2 ? 16 : PAGE_SHIFT;		\
>> +		unsigned long __ta = (addr) >> __addr_shift;			\
>>  		unsigned long __ttl = (ttl >= 1 && ttl <= 3) ? ttl : 0;		\
>>  		__ta &= GENMASK_ULL(36, 0);					\
>>  		__ta |= __ttl << 37;						\
>> @@ -354,34 +358,44 @@ static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
>>   * @tlb_level:	Translation Table level hint, if known
>>   * @tlbi_user:	If 'true', call an additional __tlbi_user()
>>   *              (typically for user ASIDs). 'flase' for IPA instructions
>> + * @lpa2:	If 'true', the lpa2 scheme is used as set out below
>>   *
>>   * When the CPU does not support TLB range operations, flush the TLB
>>   * entries one by one at the granularity of 'stride'. If the TLB
>>   * range ops are supported, then:
>>   *
>> - * 1. If 'pages' is odd, flush the first page through non-range
>> - *    operations;
>> + * 1. If FEAT_LPA2 is in use, the start address of a range operation
>> + *    must be 64KB aligned, so flush pages one by one until the
>> + *    alignment is reached using the non-range operations. This step is
>> + *    skipped if LPA2 is not in use.
>>   *
>>   * 2. For remaining pages: the minimum range granularity is decided
>>   *    by 'scale', so multiple range TLBI operations may be required.
>> - *    Start from scale = 0, flush the corresponding number of pages
>> - *    ((num+1)*2^(5*scale+1) starting from 'addr'), then increase it
>> - *    until no pages left.
>> + *    Start from scale = 3, flush the corresponding number of pages
>> + *    ((num+1)*2^(5*scale+1) starting from 'addr'), then descrease it
>> + *    until one or zero pages are left. We must start from highest scale
>> + *    to ensure 64KB start alignment is maintained in the LPA2 case.
> 
> Surely the algorithm is a bit more subtle than this, because always
> starting with scale==3 means that you're invalidating at least 64k
> *pages*, which is an awful lot (a minimum of 256MB?).

__TLBI_RANGE_NUM() returns -1 if scale produces a range that is bigger than the
number of remaining pages, so we won't over-invalidate. I guess you are asking
for this detail to be added to the comment (it wasn't there before and this
aspect hasn't changed).

> 
>> + *
>> + * 3. If there is 1 page remaining, flush it through non-range
>> + *    operations. Range operations can only span an even number of
>> + *    pages. We save this for last to ensure 64KB start alignment is
>> + *    maintained for the LPA2 case.
>>   *
>>   * Note that certain ranges can be represented by either num = 31 and
>>   * scale or num = 0 and scale + 1. The loop below favours the latter
>>   * since num is limited to 30 by the __TLBI_RANGE_NUM() macro.
>>   */
>>  #define __flush_tlb_range_op(op, start, pages, stride,			\
>> -				asid, tlb_level, tlbi_user)		\
>> +				asid, tlb_level, tlbi_user, lpa2)	\
>>  do {									\
>>  	int num = 0;							\
>> -	int scale = 0;							\
>> +	int scale = 3;							\
>>  	unsigned long addr;						\
>>  									\
>>  	while (pages > 0) {						\
> 
> Not an issue with your patch, but we could be more robust here. If
> 'pages' is an unsigned quantity and what we have a bug in converging
> to 0 below, we'll be looping for a long time. Not to mention the side
> effects on pages and start.

Good point; pages is always unsigned long in all the callers of this macro, so
the problem definitely exists. I guess the easiest thing would be to convert to
a signed variable, given we know the passed in value must always fit in a signed
long?

> 
>>  		if (!system_supports_tlb_range() ||			\
>> -		    pages % 2 == 1) {					\
>> +		    pages == 1 ||					\
>> +		    (lpa2 && start != ALIGN(start, SZ_64K))) {		\
>>  			addr = __TLBI_VADDR(start, asid);		\
>>  			__tlbi_level(op, addr, tlb_level);		\
>>  			if (tlbi_user)					\
>> @@ -394,19 +408,19 @@ do {									\
>>  		num = __TLBI_RANGE_NUM(pages, scale);			\
>>  		if (num >= 0) {						\
>>  			addr = __TLBI_VADDR_RANGE(start, asid, scale,	\
>> -						  num, tlb_level);	\
>> +						num, tlb_level, lpa2);	\
>>  			__tlbi(r##op, addr);				\
>>  			if (tlbi_user)					\
>>  				__tlbi_user(r##op, addr);		\
>>  			start += __TLBI_RANGE_PAGES(num, scale) << PAGE_SHIFT; \
>>  			pages -= __TLBI_RANGE_PAGES(num, scale);	\
>>  		}							\
>> -		scale++;						\
>> +		scale--;						\
>>  	}								\
>>  } while (0)
>>  
>> -#define __flush_s2_tlb_range_op(op, start, pages, stride, tlb_level) \
>> -	__flush_tlb_range_op(op, start, pages, stride, 0, tlb_level, false)
>> +#define __flush_s2_tlb_range_op(op, start, pages, stride, tlb_level, lpa2) \
>> +	__flush_tlb_range_op(op, start, pages, stride, 0, tlb_level, false, lpa2)
>>  
>>  static inline void __flush_tlb_range(struct vm_area_struct *vma,
>>  				     unsigned long start, unsigned long end,
>> @@ -436,9 +450,9 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
>>  	asid = ASID(vma->vm_mm);
>>  
>>  	if (last_level)
>> -		__flush_tlb_range_op(vale1is, start, pages, stride, asid, tlb_level, true);
>> +		__flush_tlb_range_op(vale1is, start, pages, stride, asid, tlb_level, true, false);
>>  	else
>> -		__flush_tlb_range_op(vae1is, start, pages, stride, asid, tlb_level, true);
>> +		__flush_tlb_range_op(vae1is, start, pages, stride, asid, tlb_level, true, false);
>>  
>>  	dsb(ish);
>>  	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, start, end);
>> diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
>> index 1b265713d6be..d42b72f78a9b 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
>> @@ -198,7 +198,7 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>>  	/* Switch to requested VMID */
>>  	__tlb_switch_to_guest(mmu, &cxt, false);
>>  
>> -	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0);
>> +	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0, false);
>>  
>>  	dsb(ish);
>>  	__tlbi(vmalle1is);
>> diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
>> index 46bd43f61d76..6041c6c78984 100644
>> --- a/arch/arm64/kvm/hyp/vhe/tlb.c
>> +++ b/arch/arm64/kvm/hyp/vhe/tlb.c
>> @@ -161,7 +161,7 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>>  	/* Switch to requested VMID */
>>  	__tlb_switch_to_guest(mmu, &cxt);
>>  
>> -	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0);
>> +	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0, false);
>>  
>>  	dsb(ish);
>>  	__tlbi(vmalle1is);
> 
> Thanks,
> 
> 	M.
> 

