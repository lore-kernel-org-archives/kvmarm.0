From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v6 18/18] kvm: arm64: Allow tuning the physical address
 size for VM
Date: Thu, 1 Nov 2018 09:32:40 +0000
Message-ID: <6d251664-7331-bc24-2dd9-14a663d65bc2@arm.com>
References: <20180926163258.20218-1-suzuki.poulose@arm.com>
 <20180926163258.20218-19-suzuki.poulose@arm.com>
 <20181031142216.GD12057@e113682-lin.lund.arm.com>
 <ebfbc17a-5954-7a67-0ae4-b911ba5f8b9e@arm.com>
 <20181101083622.GH12057@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181101083622.GH12057@e113682-lin.lund.arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, Punit Agrawal <punit.agrawal@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu



On 01/11/18 08:36, Christoffer Dall wrote:
> On Wed, Oct 31, 2018 at 05:55:13PM +0000, Suzuki K Poulose wrote:
>> Hi Christoffer,
>>
>> On 31/10/18 14:22, Christoffer Dall wrote:
>>> On Wed, Sep 26, 2018 at 05:32:54PM +0100, Suzuki K Poulose wrote:
>>>> Allow specifying the physical address size limit for a new
>>>> VM via the kvm_type argument for the KVM_CREATE_VM ioctl. This
>>>> allows us to finalise the stage2 page table as early as possible
>>>> and hence perform the right checks on the memory slots
>>>> without complication. The size is encoded as Log2(PA_Size) in
>>>> bits[7:0] of the type field. For backward compatibility the
>>>> value 0 is reserved and implies 40bits. Also, lift the limit
>>>> of the IPA to host limit and allow lower IPA sizes (e.g, 32).
>>>>
>>>> The userspace could check the extension KVM_CAP_ARM_VM_IPA_SIZE
>>>> for the availability of this feature. The cap check returns the
>>>> maximum limit for the physical address shift supported by the host.
>>>>
>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>> Cc: Christoffer Dall <cdall@kernel.org>
>>>> Cc: Peter Maydell <peter.maydell@linaro.org>
>>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>>> Cc: Radim Krčmář <rkrcmar@redhat.com>
>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>> ---
>>
>>>> @@ -192,17 +195,23 @@ int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
>>>>   	u32 parange, phys_shift;
>>>>   	u8 lvls;
>>>> -	if (type)
>>>> +	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
>>>>   		return -EINVAL;
>>>> +	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
>>>> +	if (phys_shift) {
>>>> +		if (phys_shift > kvm_ipa_limit ||
>>>> +		    phys_shift < 32)
>>>> +			return -EINVAL;
>>>
>>> I am concerned here that if we allow the user to set the phys_size to 32
>>> bits, then we end up with 2 levels of stage2 page tables, which means
>>> that the size of a stage2 pmd mapping becomes the size of a stage2 pgd
>>> mapping, yet we can still decide in user_mem_abort() that a stage2 fault
>>> is backed by PMD size mappings on the host, and attempt a huge mapping
>>> at stage2, which then becomes a PGD level block map, I think.
>>
>> Yes, you're right. We will have a pgd-level block map in that case.
>> This should work transparently as PMD at stage2 is folded into PGD and
>> we endup marking the PGD entry as huge and the stage2 accessors deal
>> with it appropriately. This is similar to having a PMD huge page with
>> 64K + 42bit VA (2 level page table) on stage1.
>>
>>>
>>> Is this handled somehow?  If so, how?
>>
>> We don't prevent this. We have a guaranteed minimum number of levels
>> at 2, which implies you can map a stage1 PMD huge page at stage2.
>> I acknowledge that the Linux naming convention does cause some confusion
>> for a "level" at stage1 and stage2 levels. But if you think of it
>> from the hardware level (and like the ARM ARM defines it , Level 0-3),
>> it is much simpler. i.e, you can map a huge page at level N in stage1
>> into stage2 if you have that level N. It doesn't matter if stage2 has
>> more or less number of levels than stage1, as long as stage2 table can
>> deal with it.
>>
> 
> That is indeed a good way to reason about it.
> 
>>>
>>> I can't see user_mem_abort() being modified to explicitly handle this
>>> in your code, but perhaps the stage2_set_pmd_huge() call ends up
>>> actually mapping at the stage2 pte level, but I can't tell that it does.
>>
>> The stage2_set_pmd_huge() installs it at the PGD (level 2, which would
>> have been PMD if we had levels > 2) slot.
>>
>> pmd = stage2_get_pmd(addr)
>>         \-> pud = stage2_get_pud(addr)
>>               \-> pgd = kvm->arch.pgd + stage2_pgd_index(addr);
>>               \-> (we have stage2_pgd_none(x) = 0 and
>>               \-> stage2_pud_offset(pgd, addr) = pgd
>>               \->returns (kvm->arch.pgd + stage2_pgd_index(addr);
>>         \->  stage_pud_none(x) = 0 & stage2_pmd_offset(pud, addr) = pud
>>         \->  returns pud (kvm->arch.pgd + stage2_pgd_index(addr))
>>
>> and we install the PMD huge mapping at the location.
>>
>>> In any case, I think user_mem_abort() should give up on pmd/pud huge
>>> mappings if the size mapped by the stage2/stage1 pmd/pud levels don't
>>> line up.  What do you think?
>>
>> Does it matter ? Personally I don't think it matters much as long as we
>> are able to map the "huge" page at stage1 in the stage2 as huge, even if
>> the stage2 has lesser levels and manage it well. Given that PMD huge
>> pages are quite common, it would be good to exploit it when we can.
> 
> What I couldn't convince myself of was whether having 2 levels at stage2
> implied the entry level block mapping being of the same size as the

The point worth noting is, PMD (in ARM ARM terms) is always Level 2, 
irrespective of whether it is also PGD(the entry level). So as long as
we deal with PMD or PUD (and not PGD which varies) and make sure you
have sufficient number of levels we are fine.

For PMD it is guaranteed on all architectures and we do that explicitly
for stage2 in arm64 KVM. Similarly for PUD we need to make sure we have
3 levels to use a huge page or else fallback to splitting the pages.

> stage1 block mapping, but given your explanation above, I think that's
> fine.
> 
>>
>> On the other hand, for stage2 PUD we are checking if the stage2 has a
>> PUD level (kvm_has_stage2_pud()). May be we should relax it just like
>> we do for PMD to check (kvm_stage2_levels > 2).
>>
> 
> Depends on how the code ends up looking like I suppose, but the more
> symmetry we can have between the approach for host PMD and host PUD and
> host PTE mappings, the better.

Sure. It is quite easy to confuse ourselves even later when we look at
it. We could put in a big fat comment explaining this to avoid
scratching our heads later.

Cheers
Suzuki
