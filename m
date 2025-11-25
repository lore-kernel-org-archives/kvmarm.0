Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB91726C39E
	for <kvmarm@lists.linux.dev>; Tue, 25 Nov 2025 11:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764069975; cv=none; b=Kl+LSQQkMmz4pcquQ7yy/JuCs8lo6w3ok9J2e55O2EVUXOWY0qAcTWFGZF3K923DIa7Hf02VfvPNAV0A4CFI5ZupV5zw0DjvhCq8NTAypjtXNbjI/pYJiYdb0+ASPbJWdrbwPB7TnNPicFPMZnYOg+bL+g9cqg4TYZiBWtOXEcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764069975; c=relaxed/simple;
	bh=xAUKBqaEigAmMTjdPx8ZU5kXaumG6AEkkV5SBBq1l/g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KKn9EHpJM/B0JG18LgfDDhQfcDiRFmrycJYbyUD/MOpDl0ot78fX/vZeqHCJU2LJU6U8J1+E/wHCH6B3h8xfmC1ZOuSs/EAtwBKXPSDuY4qMp+DjM2akZdnPoy0YBkT1pMgHgLQin6wglpgU9sbjbm9Iy442fctfnEhjIYghFj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBE7714BF;
	Tue, 25 Nov 2025 03:26:05 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ED6153F73B;
	Tue, 25 Nov 2025 03:26:11 -0800 (PST)
Message-ID: <5df713d4-8b79-4456-8fd1-707ca89a61b6@arm.com>
Date: Tue, 25 Nov 2025 11:26:10 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/49] KVM: arm64: GICv3: Detect and work around the
 lack of ICV_DIR_EL1 trapping
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 Mark Brown <broonie@kernel.org>
References: <20251120172540.2267180-1-maz@kernel.org>
 <20251120172540.2267180-7-maz@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20251120172540.2267180-7-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/11/2025 17:24, Marc Zyngier wrote:
> A long time ago, an unsuspecting architect forgot to add a trap
> bit for ICV_DIR_EL1 in ICH_HCR_EL2. Which was unfortunate, but
> what's a bit of spec between friends? Thankfully, this was fixed
> in a later revision, and ARM "deprecates" the lack of trapping
> ability.
> 
> Unfortuantely, a few (billion) CPUs went out with that defect,
> anything ARMv8.0 from ARM, give or take. And on these CPUs,
> you can't trap DIR on its own, full stop.
> 
> As the next best thing, we can trap everything in the common group,
> which is a tad expensive, but hey ho, that's what you get. You can
> otherwise recycle the HW in the neaby bin.
> 
> Tested-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/virt.h  |  7 ++++-
>   arch/arm64/kernel/cpufeature.c | 52 ++++++++++++++++++++++++++++++++++
>   arch/arm64/kernel/hyp-stub.S   |  5 ++++
>   arch/arm64/kvm/vgic/vgic-v3.c  |  3 ++
>   arch/arm64/tools/cpucaps       |  1 +
>   5 files changed, 67 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index aa280f356b96a..8eb63d3294974 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -40,8 +40,13 @@
>    */
>   #define HVC_FINALISE_EL2	3
>   
> +/*
> + * HVC_GET_ICH_VTR_EL2 - Retrieve the ICH_VTR_EL2 value
> + */
> +#define HVC_GET_ICH_VTR_EL2	4
> +
>   /* Max number of HYP stub hypercalls */
> -#define HVC_STUB_HCALL_NR 4
> +#define HVC_STUB_HCALL_NR 5
>   
>   /* Error returned when an invalid stub number is passed into x0 */
>   #define HVC_STUB_ERR	0xbadca11
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 5ed401ff79e3e..5de51cb1b8fe2 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2303,6 +2303,49 @@ static bool has_gic_prio_relaxed_sync(const struct arm64_cpu_capabilities *entry
>   }
>   #endif
>   
> +static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
> +				 int scope)
> +{
> +	static const struct midr_range has_vgic_v3[] = {
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_PRO),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_PRO),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_MAX),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_MAX),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_PRO),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_PRO),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_MAX),
> +		MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_MAX),
> +		{},
> +	};
> +	struct arm_smccc_res res = {};
> +
> +	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDIR <= ARM64_HAS_GICV3_CPUIF);
> +	BUILD_BUG_ON(ARM64_HAS_ICH_HCR_EL2_TDIR <= ARM64_HAS_GICV5_LEGACY);
> +	if (!cpus_have_cap(ARM64_HAS_GICV3_CPUIF) &&
> +	    !is_midr_in_range_list(has_vgic_v3))
> +		return false;
> +
> +	if (!is_hyp_mode_available())
> +		return false;
> +
> +	if (cpus_have_cap(ARM64_HAS_GICV5_LEGACY))
> +		return true;
> +
> +	if (is_kernel_in_hyp_mode())
> +		res.a1 = read_sysreg_s(SYS_ICH_VTR_EL2);
> +	else
> +		arm_smccc_1_1_hvc(HVC_GET_ICH_VTR_EL2, &res);

We are reading the register on the current CPU and this capability,
being a SYSTEM_FEATURE, relies on the "probing CPU". If there CPUs
with differing values (which I don't think is practical, but hey,
never say..). This is would better be a 
ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE, which would run through all
boot CPUs and would set the capability when it matches.

That means, you may need to replace cpus_have_cap() with
this_cpu_has_cap() for both GICV3_CPUIF and GICV5_LEGACY.



> +
> +	if (res.a0 == HVC_STUB_ERR)
> +		return false;
> +
> +	return res.a1 & ICH_VTR_EL2_TDS;
> +}
> +
>   #ifdef CONFIG_ARM64_BTI
>   static void bti_enable(const struct arm64_cpu_capabilities *__unused)
>   {
> @@ -2814,6 +2857,15 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>   		.matches = has_gic_prio_relaxed_sync,
>   	},
>   #endif
> +	{
> +		/*
> +		 * Depends on having GICv3
> +		 */
> +		.desc = "ICV_DIR_EL1 trapping",
> +		.capability = ARM64_HAS_ICH_HCR_EL2_TDIR,
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,

As mentioned above, this needs to be a 
ARM64_CPUCAP_EARLY_LOCAL_CPU_FEATURE.

Suzuki


