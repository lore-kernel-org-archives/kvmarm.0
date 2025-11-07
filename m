Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34434269B1C
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 12:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762517124; cv=none; b=GsUTbIXCgGveX3IA8nl9XNZtcKQUuZB8u7lOJrdNGfjfwVkhE63CJBPdB3Vh4ZLrZzDTJyzEV8NjCx5vcuC3+d5NMiv3sRVyQbVdydbMwrKtAliOKUIOJrZOyFKLmlS36pqQFvA241gL3+hx+hb0DsSvXxlKP9qcCWTPLI6eo0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762517124; c=relaxed/simple;
	bh=YFC3mVqOFCay/5oIYl8buTymdC3JBQDEHRzU74OzWKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DAjxNZjnQaexZrjqvV7hrDO01vzmkc5XLiqW+jQEjJMS6OzckWOttAM/ek+KPXsdLI58lJHm8/rAMo+skuYrhYCXhJndhhNrmlKiqF5TucofGrc9ag44YPrbwPMrNb45UOXBnj4Vlt+6EdyxvBAXffRKI9gdn/R6XeM5sNRxkz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DB731515;
	Fri,  7 Nov 2025 04:05:13 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F20E3F66E;
	Fri,  7 Nov 2025 04:05:19 -0800 (PST)
Message-ID: <cb087e63-3dae-4d7d-ac8a-a8982e560be6@arm.com>
Date: Fri, 7 Nov 2025 12:05:18 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/7] arm64: Add support for FEAT_{LS64, LS64_V}
To: Zhou Wang <wangzhou1@hisilicon.com>, catalin.marinas@arm.com,
 will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
 yuzenghui@huawei.com, arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 yangyccccc@gmail.com, prime.zeng@hisilicon.com, xuwei5@huawei.com
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
 <20251107072127.448953-6-wangzhou1@hisilicon.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20251107072127.448953-6-wangzhou1@hisilicon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/11/2025 07:21, Zhou Wang wrote:
> From: Yicong Yang <yangyicong@hisilicon.com>
> 
> Armv8.7 introduces single-copy atomic 64-byte loads and stores
> instructions and its variants named under FEAT_{LS64, LS64_V}.
> These features are identified by ID_AA64ISAR1_EL1.LS64 and the
> use of such instructions in userspace (EL0) can be trapped. In
> order to support the use of corresponding instructions in userspace:
> - Make ID_AA64ISAR1_EL1.LS64 visbile to userspace
> - Add identifying and enabling in the cpufeature list
> - Expose these support of these features to userspace through HWCAP3
>    and cpuinfo
> 
> ld64b/st64b (FEAT_LS64) and st64bv (FEAT_LS64_V) is intended for
> special memory (device memory) so requires support by the CPU, system
> and target memory location (device that support these instructions).
> The HWCAP3_{LS64, LS64_V} implies the support of CPU and system (since
> no identification method from system, so SoC vendors should advertise
> support in the CPU if system also support them).
> 
> Otherwise for ld64b/st64b the atomicity may not be guaranteed or a
> DABT will be generated, so users (probably userspace driver developer)
> should make sure the target memory (device) also have the support.
> For st64bv 0xffffffffffffffff will be returned as status result for
> unsupported memory so user should check it.
> 
> Document the restrictions along with HWCAP3_{LS64, LS64_V}.
> 
> Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> ---
>   Documentation/arch/arm64/booting.rst    | 12 ++++++
>   Documentation/arch/arm64/elf_hwcaps.rst | 14 +++++++
>   arch/arm64/include/asm/hwcap.h          |  2 +
>   arch/arm64/include/uapi/asm/hwcap.h     |  2 +
>   arch/arm64/kernel/cpufeature.c          | 51 +++++++++++++++++++++++++
>   arch/arm64/kernel/cpuinfo.c             |  2 +
>   arch/arm64/tools/cpucaps                |  2 +
>   7 files changed, 85 insertions(+)
> 
> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
> index e4f953839f71..2c56d76ecafb 100644
> --- a/Documentation/arch/arm64/booting.rst
> +++ b/Documentation/arch/arm64/booting.rst
> @@ -556,6 +556,18 @@ Before jumping into the kernel, the following conditions must be met:
>   
>      - MDCR_EL3.TPM (bit 6) must be initialized to 0b0
>   
> +  For CPUs with support for 64-byte loads and stores without status (FEAT_LS64):
> +
> +  - If the kernel is entered at EL1 and EL2 is present:
> +
> +    - HCRX_EL2.EnALS (bit 1) must be initialised to 0b1.
> +
> +  For CPUs with support for 64-byte stores with status (FEAT_LS64_V):
> +
> +  - If the kernel is entered at EL1 and EL2 is present:
> +
> +    - HCRX_EL2.EnASR (bit 2) must be initialised to 0b1.
> +
>   The requirements described above for CPU mode, caches, MMUs, architected
>   timers, coherency and system registers apply to all CPUs.  All CPUs must
>   enter the kernel in the same exception level.  Where the values documented
> diff --git a/Documentation/arch/arm64/elf_hwcaps.rst b/Documentation/arch/arm64/elf_hwcaps.rst
> index a15df4956849..b86059bc288b 100644
> --- a/Documentation/arch/arm64/elf_hwcaps.rst
> +++ b/Documentation/arch/arm64/elf_hwcaps.rst
> @@ -444,6 +444,20 @@ HWCAP3_MTE_STORE_ONLY
>   HWCAP3_LSFE
>       Functionality implied by ID_AA64ISAR3_EL1.LSFE == 0b0001
>   
> +HWCAP3_LS64
> +    Functionality implied by ID_AA64ISAR1_EL1.LS64 == 0b0001. Note that
> +    the function of instruction ld64b/st64b requires support by CPU, system
> +    and target (device) memory location and HWCAP3_LS64 implies the support
> +    of CPU. User should only use ld64b/st64b on supported target (device)
> +    memory location, otherwise fallback to the non-atomic alternatives.
> +
> +HWCAP3_LS64_V
> +    Functionality implied by ID_AA64ISAR1_EL1.LS64 == 0b0010. Same to
> +    HWCAP3_LS64 that HWCAP3_LS64_V implies CPU's support of instruction
> +    st64bv but also requires the support from the system and target (device)
> +    memory location. st64bv supports return status result and 0xFFFFFFFFFFFFFFFF
> +    will be returned for unsupported memory location.
> +
>   
>   4. Unused AT_HWCAP bits
>   -----------------------
> diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
> index 6d567265467c..3c0804fb3435 100644
> --- a/arch/arm64/include/asm/hwcap.h
> +++ b/arch/arm64/include/asm/hwcap.h
> @@ -179,6 +179,8 @@
>   #define KERNEL_HWCAP_MTE_FAR		__khwcap3_feature(MTE_FAR)
>   #define KERNEL_HWCAP_MTE_STORE_ONLY	__khwcap3_feature(MTE_STORE_ONLY)
>   #define KERNEL_HWCAP_LSFE		__khwcap3_feature(LSFE)
> +#define KERNEL_HWCAP_LS64		__khwcap3_feature(LS64)
> +#define KERNEL_HWCAP_LS64_V		__khwcap3_feature(LS64_V)
>   
>   /*
>    * This yields a mask that user programs can use to figure out what
> diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
> index 575564ecdb0b..79bc77425b82 100644
> --- a/arch/arm64/include/uapi/asm/hwcap.h
> +++ b/arch/arm64/include/uapi/asm/hwcap.h
> @@ -146,5 +146,7 @@
>   #define HWCAP3_MTE_FAR		(1UL << 0)
>   #define HWCAP3_MTE_STORE_ONLY		(1UL << 1)
>   #define HWCAP3_LSFE		(1UL << 2)
> +#define HWCAP3_LS64		(1UL << 3)
> +#define HWCAP3_LS64_V		(1UL << 4)
>   
>   #endif /* _UAPI__ASM_HWCAP_H */
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 5ed401ff79e3..dcc5ba620a7e 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -239,6 +239,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
>   };
>   
>   static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_LS64_SHIFT, 4, 0),
>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_XS_SHIFT, 4, 0),
>   	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_I8MM_SHIFT, 4, 0),
>   	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_DGH_SHIFT, 4, 0),
> @@ -2259,6 +2260,38 @@ static void cpu_enable_e0pd(struct arm64_cpu_capabilities const *cap)
>   }
>   #endif /* CONFIG_ARM64_E0PD */
>   
> +static bool has_ls64(const struct arm64_cpu_capabilities *entry, int __unused)
> +{
> +	u64 ls64;
> +
> +	ls64 = cpuid_feature_extract_field(__read_sysreg_by_encoding(entry->sys_reg),
> +					   entry->field_pos, entry->sign);

Why are we always reading from the "local" CPU ? Shouldn't this be based 
on the SCOPE ?

i.e., read from the sanitised feature state for SCOPE_SYSTEM (given that 
is the SCOPE for the capability)

and read from the local CPU for SCOPE_LOCAL (for checks in late CPUs).


> +
> +	if (ls64 == ID_AA64ISAR1_EL1_LS64_NI ||
> +	    ls64 > ID_AA64ISAR1_EL1_LS64_LS64_ACCDATA)

Given this is FTR_LOWER_SAFE, why do we skip anything that is HIGHER 
than a particular value ? You must be able to fall back to the 
has_cpuid_feature() check for both these CAPs.


> +		return false;
> +



---8>---

> +	if (entry->capability == ARM64_HAS_LS64 &&
> +	    ls64 >= ID_AA64ISAR1_EL1_LS64_LS64)
> +		return true;
> +
> +	if (entry->capability == ARM64_HAS_LS64_V &&
> +	    ls64 >= ID_AA64ISAR1_EL1_LS64_LS64_V)
> +		return true;
> +
> +	return false;

--<8---


minor nit: You could simplify this to:

	return (ls64 >= entry->min_field_value)


Suzuki
