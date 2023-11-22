Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A3D4E630
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 14:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DC9F1595;
	Wed, 22 Nov 2023 06:12:07 -0800 (PST)
Received: from [10.57.42.32] (unknown [10.57.42.32])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3707B3F7A6;
	Wed, 22 Nov 2023 06:11:19 -0800 (PST)
Message-ID: <5c1bd81f-a4fe-4d5d-9bc0-2ec85b203969@arm.com>
Date: Wed, 22 Nov 2023 14:11:17 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/13] arm64: Treat HCR_EL2.E2H as RES1 when
 ID_AA64MMFR4_EL1.E2H0 is negative
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231120123721.851738-1-maz@kernel.org>
 <20231120123721.851738-9-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20231120123721.851738-9-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/11/2023 12:37, Marc Zyngier wrote:
> For CPUs that have ID_AA64MMFR4_EL1.E2H0 as negative, it is important
> to avoid the boot path that sets HCR_EL2.E2H=0. Fortunately, we
> already have this path to cope with fruity CPUs.
> 
> Tweak init_el2 to look at ID_AA64MMFR4_EL1.E2H0 first.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kernel/cpufeature.c |  5 ++---
>   arch/arm64/kernel/head.S       | 23 +++++++++++++++--------
>   2 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index a733c9a83f83..64a026cc5cec 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -140,7 +140,6 @@ void dump_cpu_features(void)
>   	pr_emerg("0x%*pb\n", ARM64_NCAPS, &system_cpucaps);
>   }
>   
> -#define __ARM64_EXPAND_RFV(reg, field, val)	reg##_##field##_##val
>   #define __ARM64_MAX_POSITIVE(reg, field)				\
>   		((reg##_##field##_SIGNED ?				\
>   		  BIT(reg##_##field##_WIDTH - 1) :			\
> @@ -165,7 +164,7 @@ void dump_cpu_features(void)
>    */
>   #define ARM64_CPUID_FIELDS(reg, field, min_value)			\
>   	__ARM64_CPUID_FIELDS(reg, field,				\
> -			     __ARM64_EXPAND_RFV(reg, field, min_value),	\
> +			     SYS_FIELD_VALUE(reg, field, min_value),	\
>   			     __ARM64_MAX_POSITIVE(reg, field))
>   
>   /*
> @@ -176,7 +175,7 @@ void dump_cpu_features(void)
>   #define ARM64_CPUID_FIELDS_NEG(reg, field, max_value)			\
>   	__ARM64_CPUID_FIELDS(reg, field,				\
>   			     __ARM64_MIN_NEGATIVE(reg, field),		\
> -			     __ARM64_EXPAND_RFV(reg, field, max_value))
> +			     SYS_FIELD_VALUE(reg, field, max_value))
>   
>   #define __ARM64_FTR_BITS(SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
>   	{						\

As agreed on patch 2, With the above removed, rest looks good.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 7b236994f0e1..57e39bc3b2b5 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -584,25 +584,32 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
>   	mov_q	x1, INIT_SCTLR_EL1_MMU_OFF
>   
>   	/*
> -	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1,
> -	 * making it impossible to start in nVHE mode. Is that
> -	 * compliant with the architecture? Absolutely not!
> +	 * Compliant CPUs advertise their VHE-onlyness with
> +	 * ID_AA64MMFR4_EL1.E2H0 < 0. HCR_EL2.E2H can be
> +	 * RES1 in that case.
> +	 *
> +	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1, but
> +	 * don't advertise it (they predate this relaxation).
>   	 */
> +	mrs_s	x0, SYS_ID_AA64MMFR4_EL1
> +	ubfx	x0, x0, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
> +	tbnz	x0, #(ID_AA64MMFR4_EL1_E2H0_SHIFT + ID_AA64MMFR4_EL1_E2H0_WIDTH - 1), 1f
> +
>   	mrs	x0, hcr_el2
>   	and	x0, x0, #HCR_E2H
> -	cbz	x0, 1f
> -
> +	cbz	x0, 2f
> +1:
>   	/* Set a sane SCTLR_EL1, the VHE way */
>   	pre_disable_mmu_workaround
>   	msr_s	SYS_SCTLR_EL12, x1
>   	mov	x2, #BOOT_CPU_FLAG_E2H
> -	b	2f
> +	b	3f
>   
> -1:
> +2:
>   	pre_disable_mmu_workaround
>   	msr	sctlr_el1, x1
>   	mov	x2, xzr
> -2:
> +3:
>   	__init_el2_nvhe_prepare_eret
>   
>   	mov	w0, #BOOT_CPU_MODE_EL2

