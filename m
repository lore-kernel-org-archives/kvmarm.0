From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v2 10/28] arm64/sve: Low-level CPU setup
Date: Thu, 5 Oct 2017 12:04:12 +0100
Message-ID: <76020d51-a971-e73e-9fba-1e2ec97985dc@arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-11-git-send-email-Dave.Martin@arm.com>
 <20170913133206.rwobtu7ft5nrsh4p@localhost>
 <20170913192110.GE23415@e103592.cambridge.arm.com>
 <20171005104716.GV3611@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20171005104716.GV3611@e103592.cambridge.arm.com>
Content-Language: en-US
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Will Deacon <will.deacon@arm.com>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/10/17 11:47, Dave Martin wrote:
> On Wed, Sep 13, 2017 at 08:21:11PM +0100, Dave Martin wrote:
>> On Wed, Sep 13, 2017 at 06:32:06AM -0700, Catalin Marinas wrote:
>>> On Thu, Aug 31, 2017 at 06:00:42PM +0100, Dave P Martin wrote:
>>>> diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
>>>> index 877d42f..dd22ef2 100644
>>>> --- a/arch/arm64/mm/proc.S
>>>> +++ b/arch/arm64/mm/proc.S
>>>> @@ -27,6 +27,7 @@
>>>>   #include <asm/pgtable-hwdef.h>
>>>>   #include <asm/cpufeature.h>
>>>>   #include <asm/alternative.h>
>>>> +#include <asm/sysreg.h>
>>>>   
>>>>   #ifdef CONFIG_ARM64_64K_PAGES
>>>>   #define TCR_TG_FLAGS	TCR_TG0_64K | TCR_TG1_64K
>>>> @@ -186,8 +187,17 @@ ENTRY(__cpu_setup)
>>>>   	tlbi	vmalle1				// Invalidate local TLB
>>>>   	dsb	nsh
>>>>   
>>>> -	mov	x0, #3 << 20
>>>> -	msr	cpacr_el1, x0			// Enable FP/ASIMD
>>>> +	mov	x0, #3 << 20			// FEN
>>>> +
>>>> +	/* SVE */
>>>> +	mrs	x5, id_aa64pfr0_el1
>>>> +	ubfx	x5, x5, #ID_AA64PFR0_SVE_SHIFT, #4
>>>> +	cbz	x5, 1f
>>>> +
>>>> +	bic	x0, x0, #CPACR_EL1_ZEN
>>>> +	orr	x0, x0, #CPACR_EL1_ZEN_EL1EN	// SVE: trap for EL0, not EL1
>>>> +1:	msr	cpacr_el1, x0			// Enable FP/ASIMD
>>>
>>> For EL1, I wonder whether we could move this later to cpufeature.c. IIRC
>>> I tried to do the same with FPSIMD but hit an issue with EFI run-time
>>> services (I may be wrong though).
>>
>> I'll take a look at this -- I believe it should be safe to disable this
>> trap for EL1 relatively late.  This is needed before probing for
>> available vector lengths, but apart from that the kernel shouldn't touch
>> SVE until/unless some user task uses SVE.
>>
>> This would change if we eventually enable kernel-mode SVE, but I wouldn't
>> expect that to get used in early boot before the cpufeatures code runs.
>>
>> Ard may have a view on this.
> 
> I've had a go at this, but there's a lot of splatter.
> 
> I can add a helper el1_enable_sve() say, and call it before probing
> ZCR_EL1 in the cpufeatures code.
> 
> This makes enabling SVE a side-effect of the cpufeatures code, which
> I'm not that comfortable with -- it feels like something that later
> refactoring could easily break.
> 
> I can also add an explicit call to el1_enable_sve() in sve_setup(),
> but this only works on the boot cpu.
> 
> For secondaries, I could add something in secondary_start_kernel(),
> but this looks incongruous since there's no other call to do something
> similar yet.
> 
> 
> ** Suzuki, do we have any other case where the trap for a CPU feature is
> turned off by the cpufeatures code?  If there's already a template for
> this then I'm happy to follow it.

The closest thing you have is an "enable" callback for each "available"
capability, which gets invoked on all CPUs (boot time active CPUs and the
ones which are brought up later). This is used by things like, PAN to
do some CPU specific setups.

See  :
    enable_cpu_capabilities()  // For all boot time active CPUs
    and
    verify_local_cpu_features()  // For CPUs brought up later

Cheers
Suzuki
