Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7776584F5
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 09:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B93E01595;
	Wed, 22 Nov 2023 01:55:35 -0800 (PST)
Received: from [10.57.42.32] (unknown [10.57.42.32])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 882473F6C4;
	Wed, 22 Nov 2023 01:54:47 -0800 (PST)
Message-ID: <a3f567a6-8fa5-4021-9ed1-9f2afa191045@arm.com>
Date: Wed, 22 Nov 2023 09:54:46 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/13] arm64: cpufeature: Add ID_AA64MMFR4_EL1 handling
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231120123721.851738-1-maz@kernel.org>
 <20231120123721.851738-6-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20231120123721.851738-6-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/11/2023 12:37, Marc Zyngier wrote:
> Add ID_AA64MMFR4_EL1 to the list of idregs the kernel knows about,
> and describe the E2H0 field.
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/cpu.h   | 1 +
>   arch/arm64/kernel/cpufeature.c | 7 +++++++
>   arch/arm64/kernel/cpuinfo.c    | 1 +
>   3 files changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
> index f3034099fd95..d5ba6ec9f711 100644
> --- a/arch/arm64/include/asm/cpu.h
> +++ b/arch/arm64/include/asm/cpu.h
> @@ -57,6 +57,7 @@ struct cpuinfo_arm64 {
>   	u64		reg_id_aa64mmfr1;
>   	u64		reg_id_aa64mmfr2;
>   	u64		reg_id_aa64mmfr3;
> +	u64		reg_id_aa64mmfr4;
>   	u64		reg_id_aa64pfr0;
>   	u64		reg_id_aa64pfr1;
>   	u64		reg_id_aa64zfr0;
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 767a6f288755..41db7f993eef 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -438,6 +438,11 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
>   	ARM64_FTR_END,
>   };
>   
> +static const struct arm64_ftr_bits ftr_id_aa64mmfr4[] = {
> +	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_E2H0_SHIFT, 4, 0),

It does sound a bit confusing, but FTR_LOWER_SAFE is the correct choice 
for the feature.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> +	ARM64_FTR_END,
> +};
> +
>   static const struct arm64_ftr_bits ftr_ctr[] = {
>   	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, 31, 1, 1), /* RES1 */
>   	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_EL0_DIC_SHIFT, 1, 1),
> @@ -755,6 +760,7 @@ static const struct __ftr_reg_entry {
>   			       &id_aa64mmfr1_override),
>   	ARM64_FTR_REG(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2),
>   	ARM64_FTR_REG(SYS_ID_AA64MMFR3_EL1, ftr_id_aa64mmfr3),
> +	ARM64_FTR_REG(SYS_ID_AA64MMFR4_EL1, ftr_id_aa64mmfr4),
>   
>   	/* Op1 = 1, CRn = 0, CRm = 0 */
>   	ARM64_FTR_REG(SYS_GMID_EL1, ftr_gmid),
> @@ -1079,6 +1085,7 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
>   	init_cpu_ftr_reg(SYS_ID_AA64MMFR1_EL1, info->reg_id_aa64mmfr1);
>   	init_cpu_ftr_reg(SYS_ID_AA64MMFR2_EL1, info->reg_id_aa64mmfr2);
>   	init_cpu_ftr_reg(SYS_ID_AA64MMFR3_EL1, info->reg_id_aa64mmfr3);
> +	init_cpu_ftr_reg(SYS_ID_AA64MMFR4_EL1, info->reg_id_aa64mmfr4);
>   	init_cpu_ftr_reg(SYS_ID_AA64PFR0_EL1, info->reg_id_aa64pfr0);
>   	init_cpu_ftr_reg(SYS_ID_AA64PFR1_EL1, info->reg_id_aa64pfr1);
>   	init_cpu_ftr_reg(SYS_ID_AA64ZFR0_EL1, info->reg_id_aa64zfr0);
> diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
> index a257da7b56fe..a4205effca46 100644
> --- a/arch/arm64/kernel/cpuinfo.c
> +++ b/arch/arm64/kernel/cpuinfo.c
> @@ -452,6 +452,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
>   	info->reg_id_aa64mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
>   	info->reg_id_aa64mmfr2 = read_cpuid(ID_AA64MMFR2_EL1);
>   	info->reg_id_aa64mmfr3 = read_cpuid(ID_AA64MMFR3_EL1);
> +	info->reg_id_aa64mmfr4 = read_cpuid(ID_AA64MMFR4_EL1);
>   	info->reg_id_aa64pfr0 = read_cpuid(ID_AA64PFR0_EL1);
>   	info->reg_id_aa64pfr1 = read_cpuid(ID_AA64PFR1_EL1);
>   	info->reg_id_aa64zfr0 = read_cpuid(ID_AA64ZFR0_EL1);

