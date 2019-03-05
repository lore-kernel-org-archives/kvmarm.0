From: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH] KVM: arm64: Force a PTE mapping when logging is
 enabled
Date: Tue, 5 Mar 2019 19:09:45 +0800
Message-ID: <865b8b0b-e42e-fe03-e3b4-ae2cc5b1b424@huawei.com>
References: <1551497728-12576-1-git-send-email-yuzenghui@huawei.com>
 <CAKcZhuWa4UcsoFPRkZg=M3WeUJibX8T0_R+JHS3=cyd51N9cgQ@mail.gmail.com>
 <20190304171320.GA3984@en101> <32f302eb-ef89-7de4-36b4-3c3df907c732@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AC7A4A319
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Mar 2019 06:11:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7U2mjHe88Ax0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Mar 2019 06:11:34 -0500 (EST)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E36149E3E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Mar 2019 06:11:34 -0500 (EST)
In-Reply-To: <32f302eb-ef89-7de4-36b4-3c3df907c732@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Suzuki K Poulose <Suzuki.Poulose@arm.com>, Zenghui Yu <zenghuiyu96@gmail.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>, LKML <linux-kernel@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc, Suzuki,

On 2019/3/5 1:34, Marc Zyngier wrote:
> Hi Zenghui, Suzuki,
> 
> On 04/03/2019 17:13, Suzuki K Poulose wrote:
>> Hi Zenghui,
>>
>> On Sun, Mar 03, 2019 at 11:14:38PM +0800, Zenghui Yu wrote:
>>> I think there're still some problems in this patch... Details below.
>>>
>>> On Sat, Mar 2, 2019 at 11:39 AM Zenghui Yu <yuzenghui@huawei.com> wrote:
>>>>
>>>> The idea behind this is: we don't want to keep tracking of huge pages when
>>>> logging_active is true, which will result in performance degradation.  We
>>>> still need to set vma_pagesize to PAGE_SIZE, so that we can make use of it
>>>> to force a PTE mapping.
>>
>> Yes, you're right. We are indeed ignoring the force_pte flag.
>>
>>>>
>>>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>> Cc: Punit Agrawal <punit.agrawal@arm.com>
>>>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>>>>
>>>> ---
>>>> Atfer looking into https://patchwork.codeaurora.org/patch/647985/ , the
>>>> "vma_pagesize = PAGE_SIZE" logic was not intended to be deleted. As far
>>>> as I can tell, we used to have "hugetlb" to force the PTE mapping, but
>>>> we have "vma_pagesize" currently instead. We should set it properly for
>>>> performance reasons (e.g, in VM migration). Did I miss something important?
>>>>
>>>> ---
>>>>   virt/kvm/arm/mmu.c | 7 +++++++
>>>>   1 file changed, 7 insertions(+)
>>>>
>>>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>>>> index 30251e2..7d41b16 100644
>>>> --- a/virt/kvm/arm/mmu.c
>>>> +++ b/virt/kvm/arm/mmu.c
>>>> @@ -1705,6 +1705,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>>               (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm))) &&
>>>>              !force_pte) {
>>>>                  gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
>>>> +       } else {
>>>> +               /*
>>>> +                * Fallback to PTE if it's not one of the stage2
>>>> +                * supported hugepage sizes or the corresponding level
>>>> +                * doesn't exist, or logging is enabled.
>>>
>>> First, Instead of "logging is enabled", it should be "force_pte is true",
>>> since "force_pte" will be true when:
>>>
>>>          1) fault_supports_stage2_pmd_mappings() return false; or
>>>          2) "logging is enabled" (e.g, in VM migration).
>>>
>>> Second, fallback some unsupported hugepage sizes (e.g, 64K hugepage with
>>> 4K pages) to PTE is somewhat strange. And it will then _unexpectedly_
>>> reach transparent_hugepage_adjust(), though no real adjustment will happen
>>> since commit fd2ef358282c ("KVM: arm/arm64: Ensure only THP is candidate
>>> for adjustment"). Keeping "vma_pagesize" there as it is will be better,
>>> right?
>>>
>>> So I'd just simplify the logic like:
>>
>> We could fix this right in the beginning. See patch below:
>>
>>>
>>>          } else if (force_pte) {
>>>                  vma_pagesize = PAGE_SIZE;
>>>          }
>>>
>>>
>>> Will send a V2 later and waiting for your comments :)
>>
>>
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index 30251e2..529331e 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1693,7 +1693,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   		return -EFAULT;
>>   	}
>>   
>> -	vma_pagesize = vma_kernel_pagesize(vma);
>> +	/* If we are forced to map at page granularity, force the pagesize here */
>> +	vma_pagesize = force_pte ? PAGE_SIZE : vma_kernel_pagesize(vma);
>> +
>>   	/*
>>   	 * The stage2 has a minimum of 2 level table (For arm64 see
>>   	 * kvm_arm_setup_stage2()). Hence, we are guaranteed that we can
>> @@ -1701,11 +1703,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	 * As for PUD huge maps, we must make sure that we have at least
>>   	 * 3 levels, i.e, PMD is not folded.
>>   	 */
>> -	if ((vma_pagesize == PMD_SIZE ||
>> -	     (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm))) &&
>> -	    !force_pte) {
>> +	if (vma_pagesize == PMD_SIZE ||
>> +	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
>>   		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
>> -	}
>> +
>>   	up_read(&current->mm->mmap_sem);
>>   
>>   	/* We need minimum second+third level pages */

A nicer implementation and easier to understand, thanks!

> That's pretty interesting, because this is almost what we already have
> in the NV code:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/tree/virt/kvm/arm/mmu.c?h=kvm-arm64/nv-wip-v5.0-rc7#n1752
> 
> (note that force_pte is gone in that branch).

haha :-) sorry about that. I haven't looked into the NV code yet, so ...

But I'm still wondering: should we fix this wrong mapping size problem 
before NV is introduced? Since this problem has not much to do with NV, 
and 5.0 has already been released with this problem (and 5.1 will 
without fix ...).

Just a personal idea, ignore it if unnecessary.


thanks,

zenghui
