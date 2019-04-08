From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: Re: [PATCH v8 4/9] KVM: arm/arm64: preserve host HCR_EL2 value
Date: Mon, 8 Apr 2019 19:39:19 +0100
Message-ID: <9a373ede-cdf8-c992-6f4b-352e46e0030a@arm.com>
References: <1554172037-4516-1-git-send-email-amit.kachhap@arm.com>
 <1554172037-4516-5-git-send-email-amit.kachhap@arm.com>
 <f27a3e70-2099-45a6-48e6-481a67e360eb@arm.com>
 <6131d2cb-1062-6331-c2c3-7026081c458a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6131d2cb-1062-6331-c2c3-7026081c458a@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>, James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/04/2019 14:05, Amit Daniel Kachhap wrote:
> Hi James,
> 
> On 4/6/19 4:07 PM, James Morse wrote:
>> Hi Amit,
>>
>> On 02/04/2019 03:27, Amit Daniel Kachhap wrote:
>>> From: Mark Rutland <mark.rutland@arm.com>
>>>
>>> When restoring HCR_EL2 for the host, KVM uses HCR_HOST_VHE_FLAGS, which
>>> is a constant value. This works today, as the host HCR_EL2 value is
>>> always the same, but this will get in the way of supporting extensions
>>> that require HCR_EL2 bits to be set conditionally for the host.
>>>
>>> To allow such features to work without KVM having to explicitly handle
>>> every possible host feature combination, this patch has KVM save/restore
>>> for the host HCR when switching to/from a guest HCR. The saving of the
>>> register is done once during cpu hypervisor initialization state and is
>>> just restored after switch from guest.
>>>
>>> For fetching HCR_EL2 during kvm initialisation, a hyp call is made using
>>> kvm_call_hyp and is helpful in non-VHE case.
>>>
>>> For the hyp TLB maintenance code, __tlb_switch_to_host_vhe() is updated
>>> to toggle the TGE bit with a RMW sequence, as we already do in
>>> __tlb_switch_to_guest_vhe().
>>>
>>> The value of hcr_el2 is now stored in struct kvm_cpu_context as both host
>>> and guest can now use this field in a common way.
>>
>> These HCR_EL2 flags have had me confused for quite a while.
>> I thought this was preserving the value that head.S or cpufeature.c had set, and with
>> ptrauth we couldn't know what this register should be anymore, the host flags has to vary.
>>
>> Kristina's explanation of it[0], clarified things, and with a bit more digging it appears
>> we always set API/APK, even if the hardware doesn't support the feature (as its harmless).
>> So we don't need to vary the host flags...
> 
> API/APK is always set for NVHE host mode.
>>
>> My question is, what breaks if this patch isn't merged? (the MDCR change is cleanup we can
>> do because of this HCR change), is this HCR change just cleanup too? If so, can we merge
>> ptrauth without either, so we only make the change when its needed? (it will cause some
>> changes in your patch 7, but I can't see where you depend on the host flags).
> 
> Yes you are right that this patch does not directly effect pointer authentication functionality but contains several optimizations and cleanups such as,
> 
> * Removes assigning static flags HCR_HOST_VHE_FLAGS/HCR_HOST_NVHE_FLAGS from switch.c so switching functions now are more generic in nature.
> * Currently the variation in hcr_el2 flags is across modes (VHE/NVHE). Any future conditional change within those modes in host HCR_EL2 may not effect code changes in switch.c
> * Save of hcr_el2 done at hyp init time so not expensive switching wise.
> 
> I am fine on posting it separately also.

FWIW I think it makes sense to post the HCR and MDCR patches separately
from this series. That should make it clear that pointer auth does not
depend on these changes, and should make it easier to evaluate the
changes on their own.

Others' opinions are welcome as well.

>> I recall Christoffer wanting to keep the restored DAIF register value on guest-exit static
>> to avoid extra loads/stores when we know what the value would be. I think the same logic
>> applies here.
> Yes the saving of host registers once was suggested by Christoffer.

I'm not familiar with this, but James may be referring to
kvm_arm_vhe_guest_exit, which restores DAIF to a constant value. It
seems like originally the patch saved/restored DAIF [1], but it was
decided that a constant value was better.

Thanks,
Kristina

[1] https://www.spinics.net/lists/arm-kernel/msg599798.html

>> You mentioned in the cover letter the series has some history to it!
>>
>>
>> Thanks,
>>
>> James
>>
>> [0] http://lore.kernel.org/r/7ec2f950-7587-5ecd-6caa-c2fd091ad22c@arm.com
>>
