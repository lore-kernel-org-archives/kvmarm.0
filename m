Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001DA4E610
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 14:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 090631595;
	Wed, 22 Nov 2023 06:05:36 -0800 (PST)
Received: from [10.57.42.32] (unknown [10.57.42.32])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C89933F7A6;
	Wed, 22 Nov 2023 06:04:47 -0800 (PST)
Message-ID: <b9398f7a-1291-4d25-8ae6-01a389352be0@arm.com>
Date: Wed, 22 Nov 2023 14:04:46 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/13] arm64: cpufeature: Detect E2H0 not being
 implemented
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231120123721.851738-1-maz@kernel.org>
 <20231120123721.851738-7-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20231120123721.851738-7-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/11/2023 12:37, Marc Zyngier wrote:
> FEAT_E2H0 is a new feature that indicates whether or not HCR_EL2.E2H
> can be set to 0. Amusingly, this feature is set to 0 when implemented,
> and otherwise negative.
> 
> Add a new capability and detection infrastructure to detect the
> absence of FEAT_E2H0.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> ---
>   arch/arm64/kernel/cpufeature.c | 7 +++++++
>   arch/arm64/tools/cpucaps       | 1 +
>   2 files changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 41db7f993eef..e0d64e8b4851 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2787,6 +2787,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>   		.matches = has_cpuid_feature,
>   		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, EVT, IMP)
>   	},
> +	{
> +		.desc = "FEAT_E2H0 not implemented",
> +		.capability = ARM64_HCR_E2H_RES1,
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches = has_cpuid_feature,
> +		ARM64_CPUID_FIELDS_NEG(ID_AA64MMFR4_EL1, E2H0, NI)
> +	},
>   	{},
>   };
>   
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index b98c38288a9d..8866ea9bf995 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -52,6 +52,7 @@ HAS_TIDCP1
>   HAS_TLB_RANGE
>   HAS_VIRT_HOST_EXTN
>   HAS_WFXT
> +HCR_E2H_RES1
>   HW_DBM
>   KVM_HVHE
>   KVM_PROTECTED_MODE

