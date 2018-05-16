From: Jia He <hejianet@gmail.com>
Subject: Re: [PATCH] KVM: arm/arm64: fix unaligned hva start and end in
 handle_hva_to_gpa
Date: Wed, 16 May 2018 10:47:58 +0800
Message-ID: <8c409754-9067-bc98-d695-9f116f2916c9@gmail.com>
References: <1525244911-5519-1-git-send-email-hejianet@gmail.com>
 <04e6109f-cbbd-24b0-03bb-9247b930d42c@arm.com>
 <85e04362-05dd-c697-e9c4-ad5824e63819@gmail.com>
 <0f134188-12d5-7184-3fbd-0ec8204cf649@arm.com>
 <aa5b37dc-7ac3-2999-fa67-848cd693977f@gmail.com>
 <695beacb-ff51-bb2c-72ef-d268f7d4e59d@arm.com>
 <1e065e9b-4dad-611d-fc5b-26fe6c031507@gmail.com>
 <14954b3a-6a2a-fe05-47b7-1890375ab8a4@arm.com>
 <b9e28c64-78cd-042e-0add-e06b0f57fc36@gmail.com>
 <5efb2da1-fed8-443b-d06b-cc03152b2c2e@gmail.com>
 <09c30e43-7107-395c-bde3-0310bbdbca91@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <09c30e43-7107-395c-bde3-0310bbdbca91@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: linux-kernel@vger.kernel.org, Jia He <jia.he@hxt-semitech.com>, li.zhang@hxt-semitech.com, hughd@google.com, "Andrea Arcangeli <aarcange@redhat.com>; Minchan Kim <minchan@kernel.org>; Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>; Arvind Yadav <arvind.yadav.cs@gmail.com>; Mike Rapoport" <rppt@linux.vnet.ibm.com>, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu



On 5/16/2018 12:21 AM, Suzuki K Poulose Wrote:
> Hi Jia,
> 
> On 15/05/18 14:15, Jia He wrote:
>>
>>
>> On 5/15/2018 8:38 PM, Jia He Wrote:
>>> Hi Suzuki
>>>
>>> On 5/15/2018 4:36 PM, Suzuki K Poulose Wrote:
>>>>
>>>> Hi Jia
>>>>
>>>> On 05/15/2018 03:03 AM, Jia He wrote:
>>>>> Hi Suzuki
>>>>>
>>>>> I will merge the other thread into this, and add the necessary CC list
>>>>>
>>>>> That WARN_ON call trace is very easy to reproduce in my armv8a server after I
>>>>> start 20 guests
>>>>>
>>>>> and run memhog in the host. Of course, ksm should be enabled
>>>>>
>>>>> For you question about my inject fault debug patch:
>>>>
>>>>
>>>> Thanks for the patch, comments below.
>>>>
>>>>>
>>>>
>>>> ...
>>>>
>>>>> index 7f6a944..ab8545e 100644
>>>>> --- a/virt/kvm/arm/mmu.c
>>>>> +++ b/virt/kvm/arm/mmu.c
>>>>> @@ -290,12 +290,17 @@ static void unmap_stage2_puds(struct kvm *kvm, pgd_t
>>>>> *pgd,
>>>>>     * destroying the VM), otherwise another faulting VCPU may come in and mess
>>>>>     * with things behind our backs.
>>>>>     */
>>>>> +extern int trigger_by_ksm;
>>>>>    static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64
>>>>> size)
>>>>>    {
>>>>>           pgd_t *pgd;
>>>>>           phys_addr_t addr = start, end = start + size;
>>>>>           phys_addr_t next;
>>>>>
>>>>> +       if(trigger_by_ksm) {
>>>>> +               end -= 0x200;
>>>>> +       }
>>>>> +
>>>>>           assert_spin_locked(&kvm->mmu_lock);
>>>>>           pgd = kvm->arch.pgd + stage2_pgd_index(addr);
>>>>>           do {
>>>>>
>>>>> I need to point out that I never reproduced it without this debugging patch.
>>>>
>>>> That could trigger the panic iff your "size" <= 0x200, leading to the
>>>> condition (end < start), which can make the loop go forever, as we
>>>> do while(addr < end) and end up accessing something which may not be PGD entry
>>>> and thus get a bad page with bad numbers all around. This case could be hit
>>>> only
>>>> with your change and the bug in the KSM which gives us an address near the page
>>>> boundary.
>>> No, I injected the fault on purpose to simulate the case when size is less than
>>> PAGE_SIZE(eg. PAGE_SIZE-0x200=65024)
>>> I ever got the panic info [1] *without* the debugging patch only once
>>>
>>> [1] https://lkml.org/lkml/2018/5/9/992
>>>>
>>>> So, I think we can safely ignore the PANIC().
>>>> More below.
> 
> I am a bit confused now. Do you mean, the panic was triggered *without* the
> debugging
> patch ? If that is the case, it is really worrying.
> 
Hi Suzuki, sorry for my unclear decription before.
Without ksm fixing patch and injecting fault debugging patch, I ever met WARN_ON
storm(easily reproduced) and panic on unmap_stage2_range(only once).
After the injecting fault debugging patch, the panic can be easily reproduced,
hence I thought the panic was also caused by the same root cause.

After ksm fixing patch, the WARN_ON and panic are both disappearred.

What I mean is:
1. if PAGE_SIZE alignment *should* be guaranteed in handle_hva_to_gpa, it would
be better to add a WARN_ON or WARN_ON_ONCE in unmap_stage2_range()

2. if PAGE_SIZE alignment is *not* guaranteed, handle_hva_to_gpa needs to handle
the unalignment cases, I will propose to change the codes in handle_hva_to_gpa.
eg. use (gpa_end-gpa) instead of (hva_end - hva_start)

Cheers,
Jia
>>>>
>>>>
>>>>>>> Suzuki, thanks for the comments.
>>>>>>>
>>>>>>> I proposed another ksm patch https://lkml.org/lkml/2018/5/3/1042
>>>>>>> The root cause is ksm will add some extra flags to indicate that the page
>>>>>>> is in/not_in the stable tree. This makes address not be aligned with
>>>>>>> PAGE_SIZE.
>>>>>> Thanks for the pointer. In the future, please Cc the people relevant to the
>>>>>> discussion in the patches.
>>>>>>
>>>>>>>    From arm kvm mmu point of view, do you think handle_hva_to_gpa still need
>>>>>>> to handle
>>>>>>> the unalignment case?
>>>>>> I don't think we should do that. Had we done this, we would never have caught
>>>>>> this bug
>>>>>> in KSM. Eventually if some other new implementation comes up with the a new
>>>>>> notifier
>>>>>> consumer which doesn't check alignment and doesn't WARN, it could simply do
>>>>>> the wrong
>>>>>> thing. So I believe what we have is a good measure to make sure that
>>>>>> things are
>>>>>> in the right order.
>>>>>>
>>>>>>> IMO, the PAGE_SIZE alignment is still needed because we should not let the
>>>>>>> bottom function
>>>>>>> kvm_age_hva_handler to handle the exception. Please refer to the
>>>>>>> implementation in X86 and
>>>>>>> powerpc kvm_handle_hva_range(). They both aligned the hva with
>>>>>>> hva_to_gfn_memslot.
>>>>>>>
>>>>>>    From an API perspective, you are passed on a "start" and "end" address.
>>>>>> So,
>>>>>> you could potentially
>>>>>> do the wrong thing if you align the "start" and "end". May be those handlers
>>>>>> should also do the
>>>>>> same thing as we do.
>>>>
>>>>> But handle_hva_to_gpa has partially adjusted the alignment possibly:
>>>>>      1750         kvm_for_each_memslot(memslot, slots) {
>>>>>      1751                 unsigned long hva_start, hva_end;
>>>>>      1752                 gfn_t gpa;
>>>>>      1753
>>>>>      1754                 hva_start = max(start, memslot->userspace_addr);
>>>>>      1755                 hva_end = min(end, memslot->userspace_addr +
>>>>>      1756                             (memslot->npages << PAGE_SHIFT));
>>>>>
>>>>> at line 1755, let us assume that end=0x12340200 and
>>>>> memslot->userspace_addr + (memslot->npages << PAGE_SHIFT)=0x12340000
>>>>> Then, hva_start is not page_size aligned and hva_end is aligned, and the size
>>>>> will be PAGE_SIZE-0x200,
>>>>> just as what I had done in the inject fault debugging patch.
>>>>
>>>> Thats because we want to limit the handling of the hva/gpa range by memslot.
>>>> So,
>>>> we make sure we pass on the range within the given memslot
>>>> to hva_to_gfn_memslot(). But we do iterate over the next memslot if the
>>>> original range falls in to the next slot. So, in practice, there is no
>>>> alignment/trimming of the range. Its just that we pass on the appropriate range
>>>> for each slot.
>>>>
>>> Yes, I understand what the codes did in hva_to_gfn_memslot(). What I mean is
>>> hva_end may be changed and (hva_end - hva_start) will not be same as the
>>> parameter _size_ ?
>>>
>>>> ret |= handler(kvm, gpa, (u64)(hva_end - hva_start), data);
>>>
>>> Anyway, I have to admit that all the exceptions are originally caused by the
>>> STABLE_FLAG in ksm code. What I want to discuss here is how to make arm kvm
>>> handle the exception more gracefully.
> 
> Thats my point. We need the fix in ksm. Once we have the fix in place, do
> we hit the WARN_ON() any more ?
> 
>>>
>> Hi Suzuki
>> How about this patch (balance of avoiding the WARN_ON storm and debugging
>> convenience):
> 
> The problem with WARN_ON_ONCE() is, it could potentially suppress the different
> call paths that could lead to the triggers. e.g, unmap_stage2_range() could be
> called from different paths and having a WARN_ON_ONCE() could potentially
> hide the other call paths.
> 
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 7f6a944..4033946 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -297,6 +297,8 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t
>> start, u64 size)
>>       phys_addr_t next;
>>
>>       assert_spin_locked(&kvm->mmu_lock);
>> +
>> +    WARN_ON_ONCE(size & ~PAGE_MASK);
>>       pgd = kvm->arch.pgd + stage2_pgd_index(addr);
>>       do {
>>           /*
>> @@ -1792,7 +1794,7 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t
>> gpa, u64 size, void *data
>>   {
>>       pte_t *pte = (pte_t *)data;
>>
>> -    WARN_ON(size != PAGE_SIZE);
>> +    WARN_ON_ONCE(size != PAGE_SIZE);
>>       /*
>>        * We can always call stage2_set_pte with KVM_S2PTE_FLAG_LOGGING_ACTIVE
>>        * flag clear because MMU notifiers will have unmapped a huge PMD before
>> @@ -1823,7 +1825,7 @@ static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa,
>> u64 size, void *data)
>>       pmd_t *pmd;
>>       pte_t *pte;
>>
>> -    WARN_ON(size != PAGE_SIZE && size != PMD_SIZE);
>> +    WARN_ON_ONCE(size != PAGE_SIZE && size != PMD_SIZE);
>>       pmd = stage2_get_pmd(kvm, NULL, gpa);
>>       if (!pmd || pmd_none(*pmd))    /* Nothing there */
>>           return 0;
>> @@ -1843,7 +1845,7 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t
>> gpa, u64 size, void *
>>       pmd_t *pmd;
>>       pte_t *pte;
>>
>> -    WARN_ON(size != PAGE_SIZE && size != PMD_SIZE);
>> +    WARN_ON_ONCE(size != PAGE_SIZE && size != PMD_SIZE);
>>       pmd = stage2_get_pmd(kvm, NULL, gpa);
>>       if (!pmd || pmd_none(*pmd))    /* Nothing there */
>>           return 0;
>>
> 
> 
> Cheers
> Suzuki
> 
