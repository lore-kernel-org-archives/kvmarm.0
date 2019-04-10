From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v8 4/9] KVM: arm/arm64: preserve host HCR_EL2 value
Date: Wed, 10 Apr 2019 12:15:22 +0530
Message-ID: <4d52c05d-500a-9cd0-4621-6979988ba600@arm.com>
References: <1554172037-4516-1-git-send-email-amit.kachhap@arm.com>
 <1554172037-4516-5-git-send-email-amit.kachhap@arm.com>
 <f27a3e70-2099-45a6-48e6-481a67e360eb@arm.com>
 <6131d2cb-1062-6331-c2c3-7026081c458a@arm.com>
 <9a373ede-cdf8-c992-6f4b-352e46e0030a@arm.com>
 <1c4e4f50-8324-ed78-1bfd-aee05b6d4fc5@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78F344A36C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 02:45:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x5bzjs6ZlyLU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Apr 2019 02:45:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B5EE4A36B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Apr 2019 02:45:29 -0400 (EDT)
In-Reply-To: <1c4e4f50-8324-ed78-1bfd-aee05b6d4fc5@arm.com>
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
To: Marc Zyngier <marc.zyngier@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu


Hi Mark,
On 4/9/19 2:08 PM, Marc Zyngier wrote:
> On 08/04/2019 19:39, Kristina Martsenko wrote:
>> On 08/04/2019 14:05, Amit Daniel Kachhap wrote:
>>> Hi James,
>>>
>>> On 4/6/19 4:07 PM, James Morse wrote:
>>>> Hi Amit,
>>>>
>>>> On 02/04/2019 03:27, Amit Daniel Kachhap wrote:
>>>>> From: Mark Rutland <mark.rutland@arm.com>
>>>>>
>>>>> When restoring HCR_EL2 for the host, KVM uses HCR_HOST_VHE_FLAGS, which
>>>>> is a constant value. This works today, as the host HCR_EL2 value is
>>>>> always the same, but this will get in the way of supporting extensions
>>>>> that require HCR_EL2 bits to be set conditionally for the host.
>>>>>
>>>>> To allow such features to work without KVM having to explicitly handle
>>>>> every possible host feature combination, this patch has KVM save/restore
>>>>> for the host HCR when switching to/from a guest HCR. The saving of the
>>>>> register is done once during cpu hypervisor initialization state and is
>>>>> just restored after switch from guest.
>>>>>
>>>>> For fetching HCR_EL2 during kvm initialisation, a hyp call is made using
>>>>> kvm_call_hyp and is helpful in non-VHE case.
>>>>>
>>>>> For the hyp TLB maintenance code, __tlb_switch_to_host_vhe() is updated
>>>>> to toggle the TGE bit with a RMW sequence, as we already do in
>>>>> __tlb_switch_to_guest_vhe().
>>>>>
>>>>> The value of hcr_el2 is now stored in struct kvm_cpu_context as both host
>>>>> and guest can now use this field in a common way.
>>>>
>>>> These HCR_EL2 flags have had me confused for quite a while.
>>>> I thought this was preserving the value that head.S or cpufeature.c had set, and with
>>>> ptrauth we couldn't know what this register should be anymore, the host flags has to vary.
>>>>
>>>> Kristina's explanation of it[0], clarified things, and with a bit more digging it appears
>>>> we always set API/APK, even if the hardware doesn't support the feature (as its harmless).
>>>> So we don't need to vary the host flags...
>>>
>>> API/APK is always set for NVHE host mode.
>>>>
>>>> My question is, what breaks if this patch isn't merged? (the MDCR change is cleanup we can
>>>> do because of this HCR change), is this HCR change just cleanup too? If so, can we merge
>>>> ptrauth without either, so we only make the change when its needed? (it will cause some
>>>> changes in your patch 7, but I can't see where you depend on the host flags).
>>>
>>> Yes you are right that this patch does not directly effect pointer authentication functionality but contains several optimizations and cleanups such as,
>>>
>>> * Removes assigning static flags HCR_HOST_VHE_FLAGS/HCR_HOST_NVHE_FLAGS from switch.c so switching functions now are more generic in nature.
>>> * Currently the variation in hcr_el2 flags is across modes (VHE/NVHE). Any future conditional change within those modes in host HCR_EL2 may not effect code changes in switch.c
>>> * Save of hcr_el2 done at hyp init time so not expensive switching wise.
>>>
>>> I am fine on posting it separately also.
>>
>> FWIW I think it makes sense to post the HCR and MDCR patches separately
>> from this series. That should make it clear that pointer auth does not
>> depend on these changes, and should make it easier to evaluate the
>> changes on their own.
>>
>> Others' opinions are welcome as well.
> 
> Agreed. I'm quite eager to move forward with this series, and the least
> unrelated changes it makes, the better. Cleanups and optimizations can
> always be merged at a later time.
yes sure. I will re-spin the patch series shortly.

Thanks,
Amit D.
> 
> Thanks,
> 
> 	M.
> 
