Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C4658AAA
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 17:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4CA41042;
	Wed, 22 Nov 2023 09:56:28 -0800 (PST)
Received: from [10.57.42.32] (unknown [10.57.42.32])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B502D3F73F;
	Wed, 22 Nov 2023 09:55:40 -0800 (PST)
Message-ID: <42ac0027-42d9-4437-916b-220cd4578835@arm.com>
Date: Wed, 22 Nov 2023 17:55:38 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/13] arm64: Add MIDR-based overrides for
 ID_AA64MMFR4_EL1.E2H0
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231120123721.851738-1-maz@kernel.org>
 <20231120123721.851738-12-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20231120123721.851738-12-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/11/2023 12:37, Marc Zyngier wrote:
> None the Apple M1/M2 CPUs effectively implement E2H=0, and M2
> doesn't correctly implement NV1=1 (the EL2 S1 PTW seems to barf
> on the nVHE format).
> 
> Override ID_AA64MMFR4_EL1.E2H0 for these CPUs to reflect what they
> actually support.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> ---
>   arch/arm64/kernel/idreg-override.c | 36 ++++++++++++++++++++++++++++++
>   1 file changed, 36 insertions(+)
> 
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> index 57c145bf50b7..f7be459e5ff3 100644
> --- a/arch/arm64/kernel/idreg-override.c
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -326,7 +326,43 @@ struct midr_override_data {
>   	const struct midr_range	ranges[];
>   };
>   
> +static const struct midr_override_data e2h0_ni __initconst = {
> +	/*
> +	 * These CPUs predate FEAT_E2H0, but have HCR_EL2.E2H RES1
> +	 * anyway.
> +	 */
> +	.feature	= "id_aa64mmfr4.e2h0=0xf",
> +	.ranges	= {
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_PRO),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_PRO),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_MAX),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_MAX),
> +		{}
> +	},
> +};
> +
> +static const struct midr_override_data e2h0_nv1_ni __initconst = {
> +	/*
> +	 * These CPUs predate FEAT_E2H0, but have both HCR_EL2.E2H
> +	 * RES1 and a non-functional HCR_EL2.NV1.
> +	 */
> +	.feature	= "id_aa64mmfr4.e2h0=0xe",
> +	.ranges	= {
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_PRO),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_PRO),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_MAX),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_MAX),
> +		{}
> +	},
> +};
> +
>   static const struct midr_override_data * const midr_ovr_data[] __initconst = {
> +	&e2h0_ni,
> +	&e2h0_nv1_ni,
>   };
>   
>   static void __init apply_midr_overrides(void)

