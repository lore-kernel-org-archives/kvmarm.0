From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH v8 1/9] KVM: arm/arm64: Ensure only THP is candidate for adjustment
Date: Wed, 31 Oct 2018 14:52:20 +0000
Message-ID: <87h8h2rwwr.fsf@e105922-lin.cambridge.arm.com>
References: <20181001155443.23032-1-punit.agrawal@arm.com>
        <20181001155443.23032-2-punit.agrawal@arm.com>
        <20181031143646.GE12057@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181031143646.GE12057@e113682-lin.lund.arm.com> (Christoffer
        Dall's message of "Wed, 31 Oct 2018 15:36:46 +0100")
Sender: stable-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, suzuki.poulose@arm.com, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Christoffer Dall <christoffer.dall@arm.com> writes:

> On Mon, Oct 01, 2018 at 04:54:35PM +0100, Punit Agrawal wrote:
>> PageTransCompoundMap() returns true for hugetlbfs and THP
>> hugepages. This behaviour incorrectly leads to stage 2 faults for
>> unsupported hugepage sizes (e.g., 64K hugepage with 4K pages) to be
>> treated as THP faults.
>> 
>> Tighten the check to filter out hugetlbfs pages. This also leads to
>> consistently mapping all unsupported hugepage sizes as PTE level
>> entries at stage 2.
>> 
>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>> Reviewed-by: Suzuki Poulose <suzuki.poulose@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: stable@vger.kernel.org # v4.13+
>
>
> Hmm, this function is only actually called from user_mem_abort() if we
> have (!hugetlb), so I'm not sure the cc stable here was actually
> warranted, nor that this patch is strictly necessary.
>
> It doesn't hurt, and makes the code potentially more robust for the
> future though.
>
> Am I missing something?

!hugetlb is only true for hugepage sizes supported at stage 2. The
function also got called for unsupported hugepage size at stage 2, e.g.,
64k hugepage with 4k page size, which then ended up doing the wrong
thing.

Hope that adds some context. I should've added this to the commit log.

>
> Thanks,
>
>     Christoffer
>
>> ---
>>  virt/kvm/arm/mmu.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>> 
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 7e477b3cae5b..c23a1b323aad 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1231,8 +1231,14 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
>>  {
>>  	kvm_pfn_t pfn = *pfnp;
>>  	gfn_t gfn = *ipap >> PAGE_SHIFT;
>> +	struct page *page = pfn_to_page(pfn);
>>  
>> -	if (PageTransCompoundMap(pfn_to_page(pfn))) {
>> +	/*
>> +	 * PageTransCompoungMap() returns true for THP and
>> +	 * hugetlbfs. Make sure the adjustment is done only for THP
>> +	 * pages.
>> +	 */
>> +	if (!PageHuge(page) && PageTransCompoundMap(page)) {
>>  		unsigned long mask;
>>  		/*
>>  		 * The address we faulted on is backed by a transparent huge
>> -- 
>> 2.18.0
>> 
