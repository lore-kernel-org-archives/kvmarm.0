From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v1 05/16] arm64: Helper for parange to PASize
Date: Thu, 8 Feb 2018 11:08:18 +0000
Message-ID: <040b00f2-3e83-a475-ae20-5e9358fc580a@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-6-suzuki.poulose@arm.com> <20180208110042.GH29286@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180208110042.GH29286@cbox>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 08/02/18 11:00, Christoffer Dall wrote:
> On Tue, Jan 09, 2018 at 07:04:00PM +0000, Suzuki K Poulose wrote:
>> Add a helper to convert ID_AA64MMFR0_EL1:PARange to they physical
>                                                        *the*
>> size shift. Limit the size to the maximum supported by the kernel.
> 
> Is this just a cleanup or are we actually going to need this feature in
> the subsequent patches?  That would be nice to motivate in the commit
> letter.

It is a cleanup, plus we are going to move the user of the code around from
one place to the other. So this makes it a bit easier and cleaner.


>>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arch/arm64/include/asm/cpufeature.h | 16 ++++++++++++++++
>>   arch/arm64/kvm/hyp/s2-setup.c       | 28 +++++-----------------------
>>   2 files changed, 21 insertions(+), 23 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>> index ac67cfc2585a..0564e14616eb 100644
>> --- a/arch/arm64/include/asm/cpufeature.h
>> +++ b/arch/arm64/include/asm/cpufeature.h
>> @@ -304,6 +304,22 @@ static inline u64 read_zcr_features(void)
>>   	return zcr;
>>   }
>>   
>> +static inline u32 id_aa64mmfr0_parange_to_phys_shift(int parange)
>> +{
>> +	switch (parange) {
>> +	case 0: return 32;
>> +	case 1: return 36;
>> +	case 2: return 40;
>> +	case 3: return 42;
>> +	case 4: return 44;
>> +
>> +	default:
> 
> What is the case we want to cater for with making parange == 5 the
> default for unrecognized values?
> 
> (I have a feeling that default label comes from making the compiler
> happy about potentially uninitialized values once upon a time before a
> lot of refactoring happened here.)

That is there to make sure we return 48 iff 52bit support (for that matter,
if there is a new limit in the future) is not enabled.

> 
>> +	case 5: return 48;
>> +#ifdef CONFIG_ARM64_PA_BITS_52
>> +	case 6: return 52;
>> +#endif
>> +	}
>> +}
>>   #endif /* __ASSEMBLY__ */
>>   


>>
> 
> Could you fold this change into the commit as well:
> 
> diff --git a/arch/arm64/kvm/hyp/s2-setup.c b/arch/arm64/kvm/hyp/s2-setup.c
> index 603e1ee83e89..eea2fbd68b8a 100644
> --- a/arch/arm64/kvm/hyp/s2-setup.c
> +++ b/arch/arm64/kvm/hyp/s2-setup.c
> @@ -29,7 +29,8 @@ u32 __hyp_text __init_stage2_translation(void)
>   	/*
>   	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the PS
>   	 * bits in VTCR_EL2. Amusingly, the PARange is 4 bits, while
> -	 * PS is only 3. Fortunately, bit 19 is RES0 in VTCR_EL2...
> +	 * PS is only 3. Fortunately, only three bits is actually used to
> +	 * enode the supported PARange values.
>   	 */
>   	parange = read_sysreg(id_aa64mmfr0_el1) & 7;
>   	if (parange > ID_AA64MMFR0_PARANGE_MAX)

Sure.

Thanks for the review.

Suzuki
