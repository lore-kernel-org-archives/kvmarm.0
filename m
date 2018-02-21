From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Re: [PATCH v3] arm64: Add support for new control bits CTR_EL0.DIC
 and CTR_EL0.IDC
Date: Wed, 21 Feb 2018 10:14:28 -0600
Message-ID: <5be4684b-e2d8-1b3b-4c96-03c7dae0b619@codeaurora.org>
References: <1519220946-13901-1-git-send-email-shankerd@codeaurora.org>
 <20180221150929.hkvtwu4fgfeis5cy@salmiak>
Reply-To: shankerd@codeaurora.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B53349D2B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Feb 2018 11:08:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cn5ZLpwFKewA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Feb 2018 11:07:56 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2B294070F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Feb 2018 11:07:55 -0500 (EST)
In-Reply-To: <20180221150929.hkvtwu4fgfeis5cy@salmiak>
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
To: Mark Rutland <mark.rutland@arm.com>
Cc: Philip Elcan <pelcan@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mark,

On 02/21/2018 09:09 AM, Mark Rutland wrote:
> On Wed, Feb 21, 2018 at 07:49:06AM -0600, Shanker Donthineni wrote:
>> The DCache clean & ICache invalidation requirements for instructions
>> to be data coherence are discoverable through new fields in CTR_EL0.
>> The following two control bits DIC and IDC were defined for this
>> purpose. No need to perform point of unification cache maintenance
>> operations from software on systems where CPU caches are transparent.
>>
>> This patch optimize the three functions __flush_cache_user_range(),
>> clean_dcache_area_pou() and invalidate_icache_range() if the hardware
>> reports CTR_EL0.IDC and/or CTR_EL0.IDC. Basically it skips the two
>> instructions 'DC CVAU' and 'IC IVAU', and the associated loop logic
>> in order to avoid the unnecessary overhead.
>>
>> CTR_EL0.DIC: Instruction cache invalidation requirements for
>>  instruction to data coherence. The meaning of this bit[29].
>>   0: Instruction cache invalidation to the point of unification
>>      is required for instruction to data coherence.
>>   1: Instruction cache cleaning to the point of unification is
>>       not required for instruction to data coherence.
>>
>> CTR_EL0.IDC: Data cache clean requirements for instruction to data
>>  coherence. The meaning of this bit[28].
>>   0: Data cache clean to the point of unification is required for
>>      instruction to data coherence, unless CLIDR_EL1.LoC == 0b000
>>      or (CLIDR_EL1.LoUIS == 0b000 && CLIDR_EL1.LoUU == 0b000).
>>   1: Data cache clean to the point of unification is not required
>>      for instruction to data coherence.
>>
>> Signed-off-by: Philip Elcan <pelcan@codeaurora.org>
>> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
>> ---
>> Changes since v2:
>>   -Included barriers, DSB/ISB with DIC set, and DSB with IDC set.
>>   -Single Kconfig option.
>>
>> Changes since v1:
>>   -Reworded commit text.
>>   -Used the alternatives framework as Catalin suggested.
>>   -Rebased on top of https://patchwork.kernel.org/patch/10227927/
>>
>>  arch/arm64/Kconfig               | 12 ++++++++++++
>>  arch/arm64/include/asm/cache.h   |  5 +++++
>>  arch/arm64/include/asm/cpucaps.h |  4 +++-
>>  arch/arm64/kernel/cpufeature.c   | 40 ++++++++++++++++++++++++++++++++++------
>>  arch/arm64/mm/cache.S            | 21 +++++++++++++++++++--
>>  5 files changed, 73 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index f55fe5b..82b8053 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -1095,6 +1095,18 @@ config ARM64_RAS_EXTN
>>  	  and access the new registers if the system supports the extension.
>>  	  Platform RAS features may additionally depend on firmware support.
>>  
>> +config ARM64_SKIP_CACHE_POU
>> +	bool "Enable support to skip cache POU operations"
>> +	default y
>> +	help
>> +	  Explicit point of unification cache operations can be eliminated
>> +	  in software if the hardware handles transparently. The new bits in
>> +	  CTR_EL0, CTR_EL0.DIC and CTR_EL0.IDC indicates the hardware
>> +	  capabilities of ICache and DCache POU requirements.
>> +
>> +	  Selecting this feature will allow the kernel to optimize the POU
>> +	  cache maintaince operations where it requires 'D{I}C C{I}VAU'
>> +
>>  endmenu
> 
> Is it worth having a config option for this at all? The savings from turning
> this off seem trivial.
> 
>>  
>>  config ARM64_SVE
>> diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
>> index ea9bb4e..e22178b 100644
>> --- a/arch/arm64/include/asm/cache.h
>> +++ b/arch/arm64/include/asm/cache.h
>> @@ -20,8 +20,13 @@
>>  
>>  #define CTR_L1IP_SHIFT		14
>>  #define CTR_L1IP_MASK		3
>> +#define CTR_DMLINE_SHIFT	16
>> +#define CTR_ERG_SHIFT		20
>>  #define CTR_CWG_SHIFT		24
>>  #define CTR_CWG_MASK		15
>> +#define CTR_IDC_SHIFT		28
>> +#define CTR_DIC_SHIFT		29
>> +#define CTR_B31_SHIFT		31
>>  
>>  #define CTR_L1IP(ctr)		(((ctr) >> CTR_L1IP_SHIFT) & CTR_L1IP_MASK)
>>  
>> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
>> index bb26382..8dd42ae 100644
>> --- a/arch/arm64/include/asm/cpucaps.h
>> +++ b/arch/arm64/include/asm/cpucaps.h
>> @@ -45,7 +45,9 @@
>>  #define ARM64_HARDEN_BRANCH_PREDICTOR		24
>>  #define ARM64_HARDEN_BP_POST_GUEST_EXIT		25
>>  #define ARM64_HAS_RAS_EXTN			26
>> +#define ARM64_HAS_CACHE_IDC			27
>> +#define ARM64_HAS_CACHE_DIC			28
>>  
>> -#define ARM64_NCAPS				27
>> +#define ARM64_NCAPS				29
>>  
>>  #endif /* __ASM_CPUCAPS_H */
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index ff8a6e9..12e100a 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -199,12 +199,12 @@ static int __init register_cpu_hwcaps_dumper(void)
>>  };
>>  
>>  static const struct arm64_ftr_bits ftr_ctr[] = {
>> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, 31, 1, 1),		/* RES1 */
>> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 29, 1, 1),	/* DIC */
>> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 28, 1, 1),	/* IDC */
>> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, 24, 4, 0),	/* CWG */
>> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, 20, 4, 0),	/* ERG */
>> -	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 16, 4, 1),	/* DminLine */
>> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, CTR_B31_SHIFT, 1, 1),         /* RES1 */
>> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_DIC_SHIFT, 1, 1),    /* DIC */
>> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_IDC_SHIFT, 1, 1),    /* IDC */
>> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, CTR_CWG_SHIFT, 4, 0),   /* CWG */
>> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, CTR_ERG_SHIFT, 4, 0),   /* ERG */
>> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_DMLINE_SHIFT, 4, 1), /* DminLine */
>>  	/*
>>  	 * Linux can handle differing I-cache policies. Userspace JITs will
>>  	 * make use of *minLine.
>> @@ -864,6 +864,20 @@ static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unus
>>  					ID_AA64PFR0_FP_SHIFT) < 0;
>>  }
>>  
>> +#ifdef CONFIG_ARM64_SKIP_CACHE_POU
>> +static bool has_cache_idc(const struct arm64_cpu_capabilities *entry,
>> +			  int __unused)
>> +{
>> +	return (read_sanitised_ftr_reg(SYS_CTR_EL0) & (1UL << CTR_IDC_SHIFT));
>> +}
>> +
>> +static bool has_cache_dic(const struct arm64_cpu_capabilities *entry,
>> +			  int __unused)
>> +{
>> +	return (read_sanitised_ftr_reg(SYS_CTR_EL0) & (1UL << CTR_DIC_SHIFT));
>> +}
>> +#endif
>> +
>>  #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
>>  static int __kpti_forced; /* 0: not forced, >0: forced on, <0: forced off */
>>  
>> @@ -1100,6 +1114,20 @@ static int cpu_copy_el2regs(void *__unused)
>>  		.enable = cpu_clear_disr,
>>  	},
>>  #endif /* CONFIG_ARM64_RAS_EXTN */
>> +#ifdef CONFIG_ARM64_SKIP_CACHE_POU
>> +	{
>> +		.desc = "DCache clean to POU",
> 
> This description is confusing, and sounds like it's describing DC CVAU, rather
> than the ability to ellide it. How about:
> 

Sure, I'll take your suggestion.

> 		.desc = "D-cache maintenance ellision (IDC)"
> 
>> +		.capability = ARM64_HAS_CACHE_IDC,
>> +		.def_scope = SCOPE_SYSTEM,
>> +		.matches = has_cache_idc,
>> +	},
>> +	{
>> +		.desc = "ICache invalidation to POU",
> 
> ... and correspondingly:
> 
> 		.desc = "I-cache maintenance ellision (DIC)"
> 
>> +		.capability = ARM64_HAS_CACHE_DIC,
>> +		.def_scope = SCOPE_SYSTEM,
>> +		.matches = has_cache_dic,
>> +	},
>> +#endif /* CONFIG_ARM64_CACHE_DIC */
>>  	{},
>>  };
>>  
>> diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
>> index 758bde7..76c55ef 100644
>> --- a/arch/arm64/mm/cache.S
>> +++ b/arch/arm64/mm/cache.S
>> @@ -50,6 +50,9 @@ ENTRY(flush_icache_range)
>>   */
>>  ENTRY(__flush_cache_user_range)
>>  	uaccess_ttbr0_enable x2, x3, x4
>> +alternative_if ARM64_HAS_CACHE_IDC
>> +	b	7f
>> +alternative_else_nop_endif
> 
> As there's no ifdef here, this will always result in an alternative entry, no?
> 

Yes it always enable alternative entry, If you want I can put ifdef guard.

> ... and likewise for hte other asm.
> 
>>  	dcache_line_size x2, x3
>>  	sub	x3, x2, #1
>>  	bic	x4, x0, x3
>> @@ -58,10 +61,14 @@ user_alt 9f, "dc cvau, x4",  "dc civac, x4",  ARM64_WORKAROUND_CLEAN_CACHE
>>  	add	x4, x4, x2
>>  	cmp	x4, x1
>>  	b.lo	1b
>> -	dsb	ish
>> +7:	dsb	ish
> 
> I *think* that with IDC set, we can make this a DSB ISHST. We're trying to
> ensure that prior stores are visible, and ISHST is sufficient for that.
> 

The reason I used ISH instead of ISHST to simplify the code changes. I don't see
any correctness issue using ISH...
 
>> +alternative_if ARM64_HAS_CACHE_DIC
>> +	isb
> 
> Why have we gained an ISB here if DIC is set?
> 

I believe synchronization barrier (ISB) is required here to support self-modifying/jump-labels
code. 
  
> This is for a user address, and I can't see why DIC would imply we need an
> extra ISB kernel-side.
> 

This is for user and kernel addresses, alternatives and jumplabel patching logic
calls flush_icache_range().

>> +	b	8f
>> +alternative_else_nop_endif
>>  	invalidate_icache_by_line x0, x1, x2, x3, 9f
>> -	mov	x0, #0
>> +8:	mov	x0, #0
>>  1:
>>  	uaccess_ttbr0_disable x1, x2
>>  	ret
>> @@ -80,6 +87,12 @@ ENDPROC(__flush_cache_user_range)
>>   *	- end     - virtual end address of region
>>   */
>>  ENTRY(invalidate_icache_range)
>> +alternative_if ARM64_HAS_CACHE_DIC
>> +	mov	x0, xzr
>> +	dsb	ish
> 
> Do we actually need a DSB in this case?
> 

I'll remove if everyone agree.

Will, Can you comment on this?

> As-is, this function *only* invalidates the I-cache, so we already assume that
> the data is visible at the PoU at this point. I don't see what extra gaurantee
> we'd need the DSB for.
> 
>> +	isb
> 
> We could theoretically need this (though AFAICT, KVM is the only user of this,
> and doesn't).
> 
>> +	ret
>> +alternative_else_nop_endif
>>  	uaccess_ttbr0_enable x2, x3, x4
>>  
>>  	invalidate_icache_by_line x0, x1, x2, x3, 2f
>> @@ -116,6 +129,10 @@ ENDPIPROC(__flush_dcache_area)
>>   *	- size    - size in question
>>   */
>>  ENTRY(__clean_dcache_area_pou)
>> +alternative_if ARM64_HAS_CACHE_IDC
>> +	dsb	ish
> 
> As above, I think this can be DSB ISHST.
> 

I'll change to DSB ISHST in v4 patch.

> Thanks,
> Mark.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
