From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v2 08/17] kvm: arm/arm64: Prepare for VM specific stage2
 translations
Date: Fri, 27 Apr 2018 17:04:42 +0100
Message-ID: <9fd71f6a-9b87-3357-ed5d-1e29402f8e96@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
 <1522156531-28348-9-git-send-email-suzuki.poulose@arm.com>
 <7f67fca2-b936-25d9-0fe8-aece1fadafdc@arm.com>
 <59fc0fe3-2c7e-b5ae-702b-0c21f0051c6b@arm.com>
 <c12f7bb9-2a9f-ae30-4d69-f3e229e04f7c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c12f7bb9-2a9f-ae30-4d69-f3e229e04f7c@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On 27/04/18 16:58, Suzuki K Poulose wrote:
> On 27/04/18 16:22, Suzuki K Poulose wrote:
>> On 26/04/18 14:35, Julien Grall wrote:
>>> Hi Suzuki,
>>>
>>> On 27/03/18 14:15, Suzuki K Poulose wrote:
>>>> Right now the stage2 page table for a VM is hard coded, assuming
>>>> an IPA of 40bits. As we are about to add support for per VM IPA,
>>>> prepare the stage2 page table helpers to accept the kvm instance
>>>> to make the right decision for the VM. No functional changes.
>>
>>
>>>> diff --git a/arch/arm/include/asm/kvm_arm.h 
>>>> b/arch/arm/include/asm/kvm_arm.h
>>>> index 3ab8b37..c3f1f9b 100644
>>>> --- a/arch/arm/include/asm/kvm_arm.h
>>>> +++ b/arch/arm/include/asm/kvm_arm.h
>>>> @@ -133,8 +133,7 @@
>>>>    * space.
>>>>    */
>>>>   #define KVM_PHYS_SHIFT    (40)
>>>> -#define KVM_PHYS_SIZE    (_AC(1, ULL) << KVM_PHYS_SHIFT)
>>>> -#define KVM_PHYS_MASK    (KVM_PHYS_SIZE - _AC(1, ULL))
>>>
>>> I assume you are moving them to kvm_mmu.h in order to match the arm64 
>>> side, right? If so, would not it make sense to make KVM_PHYS_SHIFT 
>>> with it?
>>>
>>> [...]
>>
>> I am moving all the macros that depend on the "kvm" instance to 
>> kvm_mmu.h.
>> I will see if I can move the KVM_PHYS_SHIFT without much trouble.
> 
> It looks like we can't do that easily. KVM_PHYS_SHIFT is used for KVM_T0SZ
> on arm, even though that can be simply hard coded to avoid the 
> dependency on
> KVM_PHYS_SHIFT (like we did for arm64, T0SZ is defined to 24). I would 
> leave it
> as it is to avoid the noise.

Fine. That was only a suggestion :).

Cheers,

-- 
Julien Grall
