Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82D634E612
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 14:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8C7F1595;
	Wed, 22 Nov 2023 06:08:30 -0800 (PST)
Received: from [10.57.42.32] (unknown [10.57.42.32])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7695D3F7A6;
	Wed, 22 Nov 2023 06:07:42 -0800 (PST)
Message-ID: <36eec1b8-5d04-4cbf-8d18-3273e4e3f0f6@arm.com>
Date: Wed, 22 Nov 2023 14:07:41 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/13] arm64: cpufeature: Detect HCR_EL2.NV1 being RES0
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231120123721.851738-1-maz@kernel.org>
 <20231120123721.851738-8-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20231120123721.851738-8-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/11/2023 12:37, Marc Zyngier wrote:
> A variant of FEAT_E2H0 not being implemented exists in the form of
> HCR_EL2.E2H being RES1 *and* HCR_EL2.NV1 being RES0 (indicating that
> only VHE is supported on the host and nested guests).
> 
> Add the necessary infrastructure for this new CPU capability.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> ---
>   arch/arm64/kernel/cpufeature.c | 7 +++++++
>   arch/arm64/tools/cpucaps       | 1 +
>   2 files changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index e0d64e8b4851..a733c9a83f83 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2794,6 +2794,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>   		.matches = has_cpuid_feature,
>   		ARM64_CPUID_FIELDS_NEG(ID_AA64MMFR4_EL1, E2H0, NI)
>   	},
> +	{
> +		.desc = "FEAT_E2H0 not implemented (NV1 RES0)",
> +		.capability = ARM64_HCR_NV1_RES0,
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches = has_cpuid_feature,
> +		ARM64_CPUID_FIELDS_NEG(ID_AA64MMFR4_EL1, E2H0, NI_NV1)
> +	},
>   	{},
>   };
>   
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 8866ea9bf995..fea24bcd6252 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -53,6 +53,7 @@ HAS_TLB_RANGE
>   HAS_VIRT_HOST_EXTN
>   HAS_WFXT
>   HCR_E2H_RES1
> +HCR_NV1_RES0
>   HW_DBM
>   KVM_HVHE
>   KVM_PROTECTED_MODE

