Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 806B44AF6E
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 14:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BCE31595;
	Wed, 22 Nov 2023 06:18:31 -0800 (PST)
Received: from [10.57.42.32] (unknown [10.57.42.32])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56BEF3F7A6;
	Wed, 22 Nov 2023 06:17:43 -0800 (PST)
Message-ID: <974e5643-d9f9-4e91-a501-748214a22bd7@arm.com>
Date: Wed, 22 Nov 2023 14:17:41 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/13] arm64: Add override for ID_AA64MMFR4_EL1.E2H0
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231120123721.851738-1-maz@kernel.org>
 <20231120123721.851738-10-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20231120123721.851738-10-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/11/2023 12:37, Marc Zyngier wrote:
> Allow ID_AA64MMFR4_EL1.E2H0 to be overriden from the command-line.
> This will subsequently be of use for non-compliant CPUs.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> ---
>   arch/arm64/include/asm/cpufeature.h |  1 +
>   arch/arm64/kernel/cpufeature.c      |  4 +++-
>   arch/arm64/kernel/idreg-override.c  | 10 ++++++++++
>   3 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 5f3f62efebd5..d465db251939 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -901,6 +901,7 @@ s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new, s64 cur);
>   struct arm64_ftr_reg *get_arm64_ftr_reg(u32 sys_id);
>   
>   extern struct arm64_ftr_override id_aa64mmfr1_override;
> +extern struct arm64_ftr_override id_aa64mmfr4_override;
>   extern struct arm64_ftr_override id_aa64pfr0_override;
>   extern struct arm64_ftr_override id_aa64pfr1_override;
>   extern struct arm64_ftr_override id_aa64zfr0_override;
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 64a026cc5cec..7dcda39537f8 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -691,6 +691,7 @@ static const struct arm64_ftr_bits ftr_raz[] = {
>   	__ARM64_FTR_REG_OVERRIDE(#id, id, table, &no_override)
>   
>   struct arm64_ftr_override __ro_after_init id_aa64mmfr1_override;
> +struct arm64_ftr_override __ro_after_init id_aa64mmfr4_override;
>   struct arm64_ftr_override __ro_after_init id_aa64pfr0_override;
>   struct arm64_ftr_override __ro_after_init id_aa64pfr1_override;
>   struct arm64_ftr_override __ro_after_init id_aa64zfr0_override;
> @@ -759,7 +760,8 @@ static const struct __ftr_reg_entry {
>   			       &id_aa64mmfr1_override),
>   	ARM64_FTR_REG(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2),
>   	ARM64_FTR_REG(SYS_ID_AA64MMFR3_EL1, ftr_id_aa64mmfr3),
> -	ARM64_FTR_REG(SYS_ID_AA64MMFR4_EL1, ftr_id_aa64mmfr4),
> +	ARM64_FTR_REG_OVERRIDE(SYS_ID_AA64MMFR4_EL1, ftr_id_aa64mmfr4,
> +			       &id_aa64mmfr4_override),
>   
>   	/* Op1 = 1, CRn = 0, CRm = 0 */
>   	ARM64_FTR_REG(SYS_GMID_EL1, ftr_gmid),
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> index 3addc09f8746..7b5b9dc20e6b 100644
> --- a/arch/arm64/kernel/idreg-override.c
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -55,6 +55,15 @@ static const struct ftr_set_desc mmfr1 __initconst = {
>   	},
>   };
>   
> +static const struct ftr_set_desc mmfr4 __initconst = {
> +	.name		= "id_aa64mmfr4",
> +	.override	= &id_aa64mmfr4_override,
> +	.fields		= {
> +		FIELD("e2h0", ID_AA64MMFR4_EL1_E2H0_SHIFT, NULL ),
> +		{}
> +	},
> +};
> +
>   static bool __init pfr0_sve_filter(u64 val)
>   {
>   	/*
> @@ -161,6 +170,7 @@ static const struct ftr_set_desc sw_features __initconst = {
>   
>   static const struct ftr_set_desc * const regs[] __initconst = {
>   	&mmfr1,
> +	&mmfr4,
>   	&pfr0,
>   	&pfr1,
>   	&isar1,

