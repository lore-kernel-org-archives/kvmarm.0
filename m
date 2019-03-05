From: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH] KVM: arm64: Force a PTE mapping when logging is
 enabled
Date: Tue, 5 Mar 2019 19:32:35 +0800
Message-ID: <2b60806d-77cd-98a2-e9b7-f2393f2592f7@huawei.com>
References: <1551497728-12576-1-git-send-email-yuzenghui@huawei.com>
 <CAKcZhuWa4UcsoFPRkZg=M3WeUJibX8T0_R+JHS3=cyd51N9cgQ@mail.gmail.com>
 <20190304171320.GA3984@en101> <32f302eb-ef89-7de4-36b4-3c3df907c732@arm.com>
 <865b8b0b-e42e-fe03-e3b4-ae2cc5b1b424@huawei.com>
 <c3d64d23-991e-b199-9168-38f37d533afc@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c3d64d23-991e-b199-9168-38f37d533afc@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, marc.zyngier@arm.com, zenghuiyu96@gmail.com
Cc: christoffer.dall@arm.com, punit.agrawal@arm.com, julien.thierry@arm.com, linux-kernel@vger.kernel.org, james.morse@arm.com, wanghaibin.wang@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2019/3/5 19:13, Suzuki K Poulose wrote:
> Hi Zenghui,
> 
> On 05/03/2019 11:09, Zenghui Yu wrote:
>> Hi Marc, Suzuki,
>>
>> On 2019/3/5 1:34, Marc Zyngier wrote:
>>> Hi Zenghui, Suzuki,
>>>
>>> On 04/03/2019 17:13, Suzuki K Poulose wrote:
>>>> Hi Zenghui,
>>>>
>>>> On Sun, Mar 03, 2019 at 11:14:38PM +0800, Zenghui Yu wrote:
>>>>> I think there're still some problems in this patch... Details below.
>>>>>
>>>>> On Sat, Mar 2, 2019 at 11:39 AM Zenghui Yu <yuzenghui@huawei.com> 
>>>>> wrote:
>>>>>>
>>>>>> The idea behind this is: we don't want to keep tracking of huge 
>>>>>> pages when
>>>>>> logging_active is true, which will result in performance 
>>>>>> degradation.  We
>>>>>> still need to set vma_pagesize to PAGE_SIZE, so that we can make 
>>>>>> use of it
>>>>>> to force a PTE mapping.
>>>>
>>>> Yes, you're right. We are indeed ignoring the force_pte flag.
>>>>
>>>>>>
>>>>>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>>>> Cc: Punit Agrawal <punit.agrawal@arm.com>
>>>>>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>>>>>>
>>>>>> ---
>>>>>> Atfer looking into https://patchwork.codeaurora.org/patch/647985/ 
>>>>>> , the
>>>>>> "vma_pagesize = PAGE_SIZE" logic was not intended to be deleted. 
>>>>>> As far
>>>>>> as I can tell, we used to have "hugetlb" to force the PTE mapping, 
>>>>>> but
>>>>>> we have "vma_pagesize" currently instead. We should set it 
>>>>>> properly for
>>>>>> performance reasons (e.g, in VM migration). Did I miss something 
>>>>>> important?
>>>>>>
>>>>>> ---
>>>>>>    virt/kvm/arm/mmu.c | 7 +++++++
>>>>>>    1 file changed, 7 insertions(+)
>>>>>>
>>>>>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>>>>>> index 30251e2..7d41b16 100644
>>>>>> --- a/virt/kvm/arm/mmu.c
>>>>>> +++ b/virt/kvm/arm/mmu.c
>>>>>> @@ -1705,6 +1705,13 @@ static int user_mem_abort(struct kvm_vcpu 
>>>>>> *vcpu, phys_addr_t fault_ipa,
>>>>>>                (vma_pagesize == PUD_SIZE && 
>>>>>> kvm_stage2_has_pmd(kvm))) &&
>>>>>>               !force_pte) {
>>>>>>                   gfn = (fault_ipa & 
>>>>>> huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
>>>>>> +       } else {
>>>>>> +               /*
>>>>>> +                * Fallback to PTE if it's not one of the stage2
>>>>>> +                * supported hugepage sizes or the corresponding 
>>>>>> level
>>>>>> +                * doesn't exist, or logging is enabled.
>>>>>
>>>>> First, Instead of "logging is enabled", it should be "force_pte is 
>>>>> true",
>>>>> since "force_pte" will be true when:
>>>>>
>>>>>           1) fault_supports_stage2_pmd_mappings() return false; or
>>>>>           2) "logging is enabled" (e.g, in VM migration).
>>>>>
>>>>> Second, fallback some unsupported hugepage sizes (e.g, 64K hugepage 
>>>>> with
>>>>> 4K pages) to PTE is somewhat strange. And it will then _unexpectedly_
>>>>> reach transparent_hugepage_adjust(), though no real adjustment will 
>>>>> happen
>>>>> since commit fd2ef358282c ("KVM: arm/arm64: Ensure only THP is 
>>>>> candidate
>>>>> for adjustment"). Keeping "vma_pagesize" there as it is will be 
>>>>> better,
>>>>> right?
>>>>>
>>>>> So I'd just simplify the logic like:
>>>>
>>>> We could fix this right in the beginning. See patch below:
>>>>
>>>>>
>>>>>           } else if (force_pte) {
>>>>>                   vma_pagesize = PAGE_SIZE;
>>>>>           }
>>>>>
>>>>>
>>>>> Will send a V2 later and waiting for your comments :)
>>>>
>>>>
>>>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>>>> index 30251e2..529331e 100644
>>>> --- a/virt/kvm/arm/mmu.c
>>>> +++ b/virt/kvm/arm/mmu.c
>>>> @@ -1693,7 +1693,9 @@ static int user_mem_abort(struct kvm_vcpu 
>>>> *vcpu, phys_addr_t fault_ipa,
>>>>            return -EFAULT;
>>>>        }
>>>> -    vma_pagesize = vma_kernel_pagesize(vma);
>>>> +    /* If we are forced to map at page granularity, force the 
>>>> pagesize here */
>>>> +    vma_pagesize = force_pte ? PAGE_SIZE : vma_kernel_pagesize(vma);
>>>> +
>>>>        /*
>>>>         * The stage2 has a minimum of 2 level table (For arm64 see
>>>>         * kvm_arm_setup_stage2()). Hence, we are guaranteed that we can
>>>> @@ -1701,11 +1703,10 @@ static int user_mem_abort(struct kvm_vcpu 
>>>> *vcpu, phys_addr_t fault_ipa,
>>>>         * As for PUD huge maps, we must make sure that we have at least
>>>>         * 3 levels, i.e, PMD is not folded.
>>>>         */
>>>> -    if ((vma_pagesize == PMD_SIZE ||
>>>> -         (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm))) &&
>>>> -        !force_pte) {
>>>> +    if (vma_pagesize == PMD_SIZE ||
>>>> +        (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
>>>>            gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> 
>>>> PAGE_SHIFT;
>>>> -    }
>>>> +
>>>>        up_read(&current->mm->mmap_sem);
>>>>        /* We need minimum second+third level pages */
>>
>> A nicer implementation and easier to understand, thanks!
>>
>>> That's pretty interesting, because this is almost what we already have
>>> in the NV code:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/tree/virt/kvm/arm/mmu.c?h=kvm-arm64/nv-wip-v5.0-rc7#n1752 
>>>
>>>
>>> (note that force_pte is gone in that branch).
>>
>> haha :-) sorry about that. I haven't looked into the NV code yet, so ...
>>
>> But I'm still wondering: should we fix this wrong mapping size problem
>> before NV is introduced? Since this problem has not much to do with NV,
>> and 5.0 has already been released with this problem (and 5.1 will
>> without fix ...).
> 
> Yes, we must fix it. I will soon send out a patch copying on it.
> Its just that I find some more issues around forcing the PTE
> mappings with PUD huge pages. I will send something out soon.

Sounds good!


zenghui
