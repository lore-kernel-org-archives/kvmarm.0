Received: from out-5.mta1.migadu.com (out-5.mta1.migadu.com [95.215.58.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA64D33F7
	for <kvmarm@lists.linux.dev>; Sun, 16 Jul 2023 14:44:35 +0000 (UTC)
Message-ID: <d5d26d8e-e1ba-b6a2-0643-f3a6c2c667d4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689518673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=crG3C0qDP4G0RM14+DeSOt3TxPK55HPw9gV0Ao4/ndI=;
	b=UxLY1ZxIoEFZQlzQfhe2mdVKhyhF0P/D3GhgN1ZkGc0skNvLz7UPSNLslXkBHzyrlyC9/t
	HDX5RKunTlAoD4dHzsekxNSzrYdohDRr28FPfXJgdSecYQ5wtliFMieRtvsJKlOEMDo/Sn
	MHCN8bl+wxIxQBqevLPVAD13X3dQW+w=
Date: Sun, 16 Jul 2023 22:44:01 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH v5 1/2] arm64: Add feature detection for fine grained
 traps
To: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
References: <20230712-kvm-arm64-fgt-v5-0-dae3ec236288@kernel.org>
 <20230712-kvm-arm64-fgt-v5-1-dae3ec236288@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20230712-kvm-arm64-fgt-v5-1-dae3ec236288@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2023/7/12 20:50, Mark Brown wrote:
> In order to allow us to have shared code for managing fine grained traps
> for KVM guests add it as a detected feature rather than relying on it
> being a dependency of other features.
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kernel/cpufeature.c | 11 +++++++++++
>  arch/arm64/tools/cpucaps       |  1 +
>  2 files changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index f9d456fe132d..0768f98c49cc 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2627,6 +2627,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.matches = has_cpuid_feature,
>  		ARM64_CPUID_FIELDS(ID_AA64ISAR1_EL1, LRCPC, IMP)
>  	},
> +	{
> +		.desc = "Fine Grained Traps",
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.capability = ARM64_HAS_FGT,
> +		.sys_reg = SYS_ID_AA64MMFR0_EL1,
> +		.sign = FTR_UNSIGNED,
> +		.field_pos = ID_AA64MMFR0_EL1_FGT_SHIFT,
> +		.field_width = 4,
> +		.min_field_value = 1,
> +		.matches = has_cpuid_feature,
> +	},

Any reason not to use the ARM64_CPUID_FIELDS() helper?

Zenghui
