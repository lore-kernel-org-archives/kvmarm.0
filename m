From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v2 05/17] arm64: Helper for parange to PASize
Date: Fri, 27 Apr 2018 16:18:57 +0100
Message-ID: <b9c37ca6-7a4e-ad64-ba89-a02b3edefbd1@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
 <1522156531-28348-6-git-send-email-suzuki.poulose@arm.com>
 <2910d406-315f-6f0f-7456-df9d80a08087@arm.com>
 <f9d91231-2a8f-ae3e-9600-8087a0b9460c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f9d91231-2a8f-ae3e-9600-8087a0b9460c@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 27/04/18 16:18, Suzuki K Poulose wrote:
> On 26/04/18 11:58, Julien Grall wrote:
>> Hi Suzuki,
>>
>> On 27/03/18 14:15, Suzuki K Poulose wrote:
>>> Add a helper to convert ID_AA64MMFR0_EL1:PARange to they physical
>>> size shift. Limit the size to the maximum supported by the kernel.
>>> We are about to move the user of this code and this helps to
>>> keep the changes cleaner.
>>
>> It is probably worth to mention that you are also adding 52-bit 
>> support in the patch.
> 
> Sure, will do. Can I take that as a Reviewed-by with the fixed
> commit description ?

Yes. Here we go:

Reviewed-by: Julien Grall <julien.grall@arm.com>

Cheers,

> 
> Cheers
> Suzuki
> 
>>
>> Cheers,
>>
>>>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Will Deacon <will.deacon@arm.com>
>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>> Cc: Christoffer Dall <cdall@kernel.org>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> ---
>>>   arch/arm64/include/asm/cpufeature.h | 16 ++++++++++++++++
>>>   arch/arm64/kvm/hyp/s2-setup.c       | 28 +++++-----------------------
>>>   2 files changed, 21 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/cpufeature.h 
>>> b/arch/arm64/include/asm/cpufeature.h
>>> index fbf0aab..1f2a5dd 100644
>>> --- a/arch/arm64/include/asm/cpufeature.h
>>> +++ b/arch/arm64/include/asm/cpufeature.h
>>> @@ -311,6 +311,22 @@ static inline u64 read_zcr_features(void)
>>>       return zcr;
>>>   }
>>> +static inline u32 id_aa64mmfr0_parange_to_phys_shift(int parange)
>>> +{
>>> +    switch (parange) {
>>> +    case 0: return 32;
>>> +    case 1: return 36;
>>> +    case 2: return 40;
>>> +    case 3: return 42;
>>> +    case 4: return 44;
>>> +    /* Report 48 bit if the kernel doesn't support 52bit */
>>> +    default:
>>> +    case 5: return 48;
>>> +#ifdef CONFIG_ARM64_PA_BITS_52
>>> +    case 6: return 52;
>>> +#endif
>>> +    }
>>> +}
>>>   #endif /* __ASSEMBLY__ */
>>>   #endif
>>> diff --git a/arch/arm64/kvm/hyp/s2-setup.c 
>>> b/arch/arm64/kvm/hyp/s2-setup.c
>>> index 603e1ee..b1129c8 100644
>>> --- a/arch/arm64/kvm/hyp/s2-setup.c
>>> +++ b/arch/arm64/kvm/hyp/s2-setup.c
>>> @@ -19,11 +19,13 @@
>>>   #include <asm/kvm_arm.h>
>>>   #include <asm/kvm_asm.h>
>>>   #include <asm/kvm_hyp.h>
>>> +#include <asm/cpufeature.h>
>>>   u32 __hyp_text __init_stage2_translation(void)
>>>   {
>>>       u64 val = VTCR_EL2_FLAGS;
>>>       u64 parange;
>>> +    u32 phys_shift;
>>>       u64 tmp;
>>>       /*
>>> @@ -37,27 +39,7 @@ u32 __hyp_text __init_stage2_translation(void)
>>>       val |= parange << 16;
>>>       /* Compute the actual PARange... */
>>> -    switch (parange) {
>>> -    case 0:
>>> -        parange = 32;
>>> -        break;
>>> -    case 1:
>>> -        parange = 36;
>>> -        break;
>>> -    case 2:
>>> -        parange = 40;
>>> -        break;
>>> -    case 3:
>>> -        parange = 42;
>>> -        break;
>>> -    case 4:
>>> -        parange = 44;
>>> -        break;
>>> -    case 5:
>>> -    default:
>>> -        parange = 48;
>>> -        break;
>>> -    }
>>> +    phys_shift = id_aa64mmfr0_parange_to_phys_shift(parange);
>>>       /*
>>>        * ... and clamp it to 40 bits, unless we have some braindead
>>> @@ -65,7 +47,7 @@ u32 __hyp_text __init_stage2_translation(void)
>>>        * return that value for the rest of the kernel to decide what
>>>        * to do.
>>>        */
>>> -    val |= 64 - (parange > 40 ? 40 : parange);
>>> +    val |= 64 - (phys_shift > 40 ? 40 : phys_shift);
>>>       /*
>>>        * Check the availability of Hardware Access Flag / Dirty Bit
>>> @@ -86,5 +68,5 @@ u32 __hyp_text __init_stage2_translation(void)
>>>       write_sysreg(val, vtcr_el2);
>>> -    return parange;
>>> +    return phys_shift;
>>>   }
>>>
>>
> 

-- 
Julien Grall
