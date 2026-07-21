Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E6246EF71
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 17:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656646; cv=none; b=qvWiCwBh9QaxuaTquhmtpKuy1njdqbjfr4he10WpWamA5Sx8d4ni+t8FgF3q/XF+toCvC5J5/947qk8NCDSN6Hvluh3nNkqAqgEQW61+hphjjZzZprqevxTfwjxNh0eS9Zm2h+4XpdMOemUTZFn9faWeZQ9ylTMiEwSKfvHgol0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656646; c=relaxed/simple;
	bh=415dWW+RZm7vl8+OqiISY0Eg4SIAayCPueSVot0frD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwjIiHfkh4oWIRflzFioztyYPHHegLNmiQSegfGqrr1iNv6F/hiMUuWui04hTFqYUOHJaE2x1mPy0OIgfensN1Uu+xoNuuBBKfH/RkWf3bKkLNwhh4pIRMKfkZWMXLzrwjKe26s/sIkYcgv8X3NGWOudtnGMCDHFfwBEDlqUsZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=chWCBKrQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="chWCBKrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FCE1F00A3A;
	Tue, 21 Jul 2026 17:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784656645;
	bh=K5uC9oI/VleO8NbHPDWusOgHQnvCCK3+fYhVhwqoJrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=chWCBKrQWf9YHfntmVLzJiBqBx5SeU8tFQYQvogsDjhNntiXlWUcN2YAzjQU4rmTb
	 uMzjP4KKh1pom2iQMdmKoJt4sLJo4//xct1DOP2eW+hudYmlQApdf8f7DMLDqGSXBy
	 +g1k4Kei50dkdTtFBph6rGTRAlajgpB1a2Pg9KuHt/PWenLlpXuZmvmlRtbOPtEKuq
	 deyGkSfCzh3Xq5z9RCrOtrs3mRu4Z7zqUT/P+RgajQUgLxI6PsDqWDI2u9wQIQa8sw
	 NCt4PjnIPv40A8YR6zHLv+xasesJMOnPf8j6oGWa09dlWb/N+dKTjJcVm3n6ibiPMP
	 EmI4/8sB9jODA==
Date: Tue, 21 Jul 2026 10:57:23 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 2/6] KVM: arm64: Move GICv3 broken SEIS implementation
 detection to a CPU errrata
Message-ID: <al-zA7eek869owmN@kernel.org>
References: <20260721170754.3150521-1-maz@kernel.org>
 <20260721170754.3150521-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721170754.3150521-3-maz@kernel.org>

Hey,

On Tue, Jul 21, 2026 at 06:07:50PM +0100, Marc Zyngier wrote:
> Using is_midr_in_range_list() in a noinstr function isn't a good idea.
> And yet kvm_compute_ich_hcr_trap_bits() is doing that by calling
> vgic_v3_broken_seis().
> 
> Move all the broken SEIS detection logic to the errata detection
> framework, and use a new ARM64_WORKAROUND_GICv3_BROKEN_SEIS cap
> to indicate that we're running on broken CPUs.
> 
> This reuses the MIDR list used for IMPDEF PMU detection, which
> has a 100% overlap with the SEIS stuff...

Hopefully this remains the case! Oh well, that's the next person's
problem to sort out anyway.

Thanks,
Oliver

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kernel/cpu_errata.c | 17 +++++++++++++++--
>  arch/arm64/kvm/vgic/vgic-v3.c  | 26 +++-----------------------
>  arch/arm64/tools/cpucaps       |  1 +
>  3 files changed, 19 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index 1995e1198648e..78e4e105f6ab5 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -272,7 +272,7 @@ has_neoverse_n1_erratum_1542419(const struct arm64_cpu_capabilities *entry,
>  	return is_midr_in_range(&range) && has_dic;
>  }
>  
> -static const struct midr_range impdef_pmuv3_cpus[] = {
> +static const struct midr_range apple_cpus[] = {
>  	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM),
>  	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM),
>  	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_PRO),
> @@ -301,7 +301,14 @@ static bool has_impdef_pmuv3(const struct arm64_cpu_capabilities *entry, int sco
>  	if (pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
>  		return false;
>  
> -	return is_midr_in_range_list(impdef_pmuv3_cpus);
> +	return is_midr_in_range_list(apple_cpus);
> +}
> +
> +static bool has_broken_gic_v3_seis(const struct arm64_cpu_capabilities *entry, int scope)
> +{
> +	return (is_kernel_in_hyp_mode() &&
> +		is_midr_in_range_list(apple_cpus) &&
> +		(read_sysreg_s(SYS_ICH_VTR_EL2) & ICH_VTR_EL2_SEIS));
>  }
>  
>  static void cpu_enable_impdef_pmuv3_traps(const struct arm64_cpu_capabilities *__unused)
> @@ -1009,6 +1016,12 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>  		.matches = has_impdef_pmuv3,
>  		.cpu_enable = cpu_enable_impdef_pmuv3_traps,
>  	},
> +	{
> +		.desc = "Known broken GICv3 SEIS implementation",
> +		.capability = ARM64_WORKAROUND_GICv3_BROKEN_SEIS,
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches = has_broken_gic_v3_seis,
> +	},
>  	{
>  	}
>  };
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 9e841e7afd4a7..0991a649a5d1e 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -809,27 +809,9 @@ static int __init early_gicv4_enable(char *buf)
>  }
>  early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
>  
> -static const struct midr_range broken_seis[] = {
> -	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM),
> -	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM),
> -	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_PRO),
> -	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_PRO),
> -	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_MAX),
> -	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_MAX),
> -	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD),
> -	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE),
> -	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_PRO),
> -	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_PRO),
> -	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_MAX),
> -	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_MAX),
> -	{},
> -};
> -
> -static bool vgic_v3_broken_seis(void)
> +static __always_inline bool vgic_v3_broken_seis(void)
>  {
> -	return (is_kernel_in_hyp_mode() &&
> -		is_midr_in_range_list(broken_seis) &&
> -		(read_sysreg_s(SYS_ICH_VTR_EL2) & ICH_VTR_EL2_SEIS));
> +	return cpus_have_cap(ARM64_WORKAROUND_GICv3_BROKEN_SEIS);
>  }
>  
>  void noinstr kvm_compute_ich_hcr_trap_bits(struct alt_instr *alt,
> @@ -959,10 +941,8 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  	if (has_v2)
>  		static_branch_enable(&vgic_v3_has_v2_compat);
>  
> -	if (vgic_v3_broken_seis()) {
> -		kvm_info("GICv3 with broken locally generated SEI\n");
> +	if (vgic_v3_broken_seis())
>  		kvm_vgic_global_state.ich_vtr_el2 &= ~ICH_VTR_EL2_SEIS;
> -	}
>  
>  	vgic_v3_enable_cpuif_traps();
>  
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 9b85a84f6fd49..50373264ecde8 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -121,6 +121,7 @@ WORKAROUND_CAVIUM_TX2_219_TVM
>  WORKAROUND_CLEAN_CACHE
>  WORKAROUND_DEVICE_LOAD_ACQUIRE
>  WORKAROUND_DISABLE_CNP
> +WORKAROUND_GICv3_BROKEN_SEIS
>  WORKAROUND_PMUV3_IMPDEF_TRAPS
>  WORKAROUND_QCOM_FALKOR_E1003
>  WORKAROUND_QCOM_ORYON_CNTVOFF
> -- 
> 2.47.3
> 
