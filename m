Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54C8C4E615
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 17:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5451EFEC;
	Wed, 22 Nov 2023 09:54:31 -0800 (PST)
Received: from [10.57.42.32] (unknown [10.57.42.32])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 262623F73F;
	Wed, 22 Nov 2023 09:53:43 -0800 (PST)
Message-ID: <b22c7a30-f5b9-45d1-8fc0-6dbf3c87ff68@arm.com>
Date: Wed, 22 Nov 2023 17:53:41 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/13] arm64: Add MIDR-based override infrastructure
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231120123721.851738-1-maz@kernel.org>
 <20231120123721.851738-11-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20231120123721.851738-11-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/11/2023 12:37, Marc Zyngier wrote:
> In order to be able to use the override infrastructure to "fix"
> CPUs that have deviated from teh architecture spec, add a new
> pile of hacks on top of the existing one, allowing a feature
> to be overriden based on matching a MIDR list.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Nice idea!

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> ---
>   arch/arm64/kernel/idreg-override.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
> 
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> index 7b5b9dc20e6b..57c145bf50b7 100644
> --- a/arch/arm64/kernel/idreg-override.c
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -321,6 +321,23 @@ static __init void parse_cmdline(void)
>   		__parse_cmdline(prop, true);
>   }
>   
> +struct midr_override_data {
> +	const char		feature[FTR_ALIAS_OPTION_LEN];
> +	const struct midr_range	ranges[];
> +};
> +
> +static const struct midr_override_data * const midr_ovr_data[] __initconst = {
> +};
> +
> +static void __init apply_midr_overrides(void)
> +{
> +	const u64 midr = read_cpuid_id();
> +
> +	for (int i = 0; i < ARRAY_SIZE(midr_ovr_data); i++)
> +		if (is_midr_in_range_list(midr, midr_ovr_data[i]->ranges))
> +			__parse_cmdline(midr_ovr_data[i]->feature, false);
> +}
> +
>   /* Keep checkers quiet */
>   void init_feature_override(u64 boot_status);
>   
> @@ -337,6 +354,8 @@ asmlinkage void __init init_feature_override(u64 boot_status)
>   
>   	__boot_status = boot_status;
>   
> +	apply_midr_overrides();
> +
>   	parse_cmdline();
>   
>   	for (i = 0; i < ARRAY_SIZE(regs); i++) {

