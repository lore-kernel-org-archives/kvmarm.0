Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E348E48791
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 09:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 083361595;
	Wed, 22 Nov 2023 01:30:40 -0800 (PST)
Received: from [10.57.42.32] (unknown [10.57.42.32])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C95F03F73F;
	Wed, 22 Nov 2023 01:29:51 -0800 (PST)
Message-ID: <2fb7398f-b865-44a7-8ee0-4a32ae40afa8@arm.com>
Date: Wed, 22 Nov 2023 09:29:50 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/13] arm64: cpufeatures: Correctly handle signed
 values
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231120123721.851738-1-maz@kernel.org>
 <20231120123721.851738-3-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20231120123721.851738-3-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/11/2023 12:37, Marc Zyngier wrote:
> Although we've had signed values for some features such as PMUv3
> and FP, the code that handles the comparaison with some limit
> has a couple of annoying issues:
> 
> - the min_field_value is always unsigned, meaning that we cannot
>    easily compare it with a negative value
> 
> - it is not possible to have a range of values, let alone a range
>    of negative values
> 
> Fix this by:
> 
> - adding an upper limit to the comparison, defaulting to all bits
>    being set to the maximum positive value
> 
> - ensuring that the signess of the min and max values are taken into
>    account
> 
> A ARM64_CPUID_FIELDS_NEG() macro is provided for signed features, but
> nothing is using it yet.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/cpufeature.h |  1 +
>   arch/arm64/kernel/cpufeature.c      | 66 +++++++++++++++++++++++++----
>   2 files changed, 58 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index f6d416fe49b0..5f3f62efebd5 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -363,6 +363,7 @@ struct arm64_cpu_capabilities {
>   			u8 field_pos;
>   			u8 field_width;
>   			u8 min_field_value;
> +			u8 max_field_value;
>   			u8 hwcap_type;
>   			bool sign;
>   			unsigned long hwcap;
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 646591c67e7a..e52d2c2b757f 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -140,12 +140,43 @@ void dump_cpu_features(void)
>   	pr_emerg("0x%*pb\n", ARM64_NCAPS, &system_cpucaps);
>   }
>   
> +#define __ARM64_EXPAND_RFV(reg, field, val)	reg##_##field##_##val

We have defined SYS_FIELD_VALUE to be the exact same thing in Patch 1 
and we later remove this and switch to using the same in Patch 8.
Could we not do this straight away here ? i.e. use the SYS_FIELD_VALUE
instead of adding this ?

Rest looks good to me.

Suzuki


> +#define __ARM64_MAX_POSITIVE(reg, field)				\
> +		((reg##_##field##_SIGNED ?				\
> +		  BIT(reg##_##field##_WIDTH - 1) :			\
> +		  BIT(reg##_##field##_WIDTH)) - 1)
> +
> +#define __ARM64_MIN_NEGATIVE(reg, field)  BIT(reg##_##field##_WIDTH - 1)
> +
> +#define __ARM64_CPUID_FIELDS(reg, field, min_value, max_value)		\
> +		.sys_reg = SYS_##reg,					\
> +		.field_pos = reg##_##field##_SHIFT,			\
> +		.field_width = reg##_##field##_WIDTH,			\
> +		.sign = reg##_##field##_SIGNED,				\
> +		.min_field_value = min_value,				\
> +		.max_field_value = max_value,
> +
> +/*
> + * ARM64_CPUID_FIELDS() encodes a field with a range from min_value to
> + * an implicit maximum that depends on the sign-ess of the field.
> + *
> + * An unsigned field will be capped at all ones, while a signed field
> + * will be limited to the positive half only.
> + */
>   #define ARM64_CPUID_FIELDS(reg, field, min_value)			\
> -		.sys_reg = SYS_##reg,							\
> -		.field_pos = reg##_##field##_SHIFT,						\
> -		.field_width = reg##_##field##_WIDTH,						\
> -		.sign = reg##_##field##_SIGNED,							\
> -		.min_field_value = reg##_##field##_##min_value,
> +	__ARM64_CPUID_FIELDS(reg, field,				\
> +			     __ARM64_EXPAND_RFV(reg, field, min_value),	\
> +			     __ARM64_MAX_POSITIVE(reg, field))
> +
> +/*
> + * ARM64_CPUID_FIELDS_NEG() encodes a field with a range from an
> + * implicit minimal value to max_value. This should be used when
> + * matching a non-implemented property.
> + */
> +#define ARM64_CPUID_FIELDS_NEG(reg, field, max_value)			\
> +	__ARM64_CPUID_FIELDS(reg, field,				\
> +			     __ARM64_MIN_NEGATIVE(reg, field),		\
> +			     __ARM64_EXPAND_RFV(reg, field, max_value))
>   
>   #define __ARM64_FTR_BITS(SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
>   	{						\
> @@ -1470,11 +1501,28 @@ has_always(const struct arm64_cpu_capabilities *entry, int scope)
>   static bool
>   feature_matches(u64 reg, const struct arm64_cpu_capabilities *entry)
>   {
> -	int val = cpuid_feature_extract_field_width(reg, entry->field_pos,
> -						    entry->field_width,
> -						    entry->sign);
> +	int val, min, max;
> +	u64 tmp;
> +
> +	val = cpuid_feature_extract_field_width(reg, entry->field_pos,
> +						entry->field_width,
> +						entry->sign);
> +
> +	tmp = entry->min_field_value;
> +	tmp <<= entry->field_pos;
> +
> +	min = cpuid_feature_extract_field_width(tmp, entry->field_pos,
> +						entry->field_width,
> +						entry->sign);
> +
> +	tmp = entry->max_field_value;
> +	tmp <<= entry->field_pos;
> +
> +	max = cpuid_feature_extract_field_width(tmp, entry->field_pos,
> +						entry->field_width,
> +						entry->sign);
>   
> -	return val >= entry->min_field_value;
> +	return val >= min && val <= max;
>   }
>   
>   static u64

