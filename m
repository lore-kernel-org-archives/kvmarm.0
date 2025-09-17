Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40DC1B7F4
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758126520; cv=none; b=Yxi0Tekg78w4yPNbvVo364Z0cDMSzhC0J9JLt0imJUTHcZXOnKWsjenV9T/aJMbM1D4M81kevS8AzOV+cq9sON04+Nba5R6Q90aAbw2KZ/MJQr8AnMnMztISz0Bf49lCcfp6lTtaOa2o6CxCEdr8t2G1lq/Nlscg9vlG0MmbF0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758126520; c=relaxed/simple;
	bh=7l2q1ZoJZnR3mv0shcxOQELBinA3e3J5guNsIQFOEA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bk0JQ0kSmPHPV7AG1Cc2s+EIqjnc/hCIgeHGejMA9JmhV+DDnRre6A4pF12dUu1gz5yNgDcq5KZtrvQGdNHP/mD9/QV238niF9TfTNag5wBq8gQeyD58iQzZitzMZFfU6fgPil9tTQEtC2t7BEm8v4S0PtrrNlTjFnWiR1MOqWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gWaA3rtH; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gWaA3rtH"
Date: Wed, 17 Sep 2025 09:28:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758126514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rkSG5XV0WESq+mtpluxgeM6kPOWB2MiD2S+CfeQLrXQ=;
	b=gWaA3rtHqmDYGaE1ikcrwoL+m0E/78Dn2bDd+cteCe5Z/laqq++zwngguJ8XmMFmY5Ulvc
	Eo1m7vztx9kWL7R8g6ejHbgPUu48W8LzIe6hyimRcYCRLIR4HQLVKIiL9H3z0wnq/oKtzo
	PsU0XBE+fSKknBMIF/dXM5/KYzQiAjg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: Re: [PATCH] KVM: arm64: Don't access ICC_SRE_EL2 if GICv3 doesn't
 support v2 compatibility
Message-ID: <aMrhrU8Khn0rfbMh@linux.dev>
References: <20250917161935.1630908-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917161935.1630908-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 17, 2025 at 05:19:35PM +0100, Marc Zyngier wrote:
> We currently access ICC_SRE_EL2 at each load/put on VHE, and on each
> entry/exit on nVHE. Both are quite onerous on NV, as this register
> always traps.
> 
> We do this to make sure the EL1 guest doesn't flip between v2 and v3
> behind our back. But all modern implementations have dropped v2,
> and this is just overhead.
> 
> At the same time, the GICv5 spec has been fixed to allow access to
> ICC_SRE_EL2 in legacy mode. Use this opportunity to replace the
> GICv5 checks for v2 compat checks, with an ad-hoc static key.
> 
> Co-developed-by: Sascha Bischoff <sascha.bischoff@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver

> ---
>  arch/arm64/kernel/image-vars.h  |  3 +++
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 25 +++++++++----------------
>  arch/arm64/kvm/vgic/vgic-v3.c   |  8 ++++++++
>  include/kvm/arm_vgic.h          |  1 +
>  4 files changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index 714b0b5ec5ac4..5369763606e71 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -105,6 +105,9 @@ KVM_NVHE_ALIAS(__hyp_stub_vectors);
>  KVM_NVHE_ALIAS(vgic_v2_cpuif_trap);
>  KVM_NVHE_ALIAS(vgic_v3_cpuif_trap);
>  
> +/* Static key indicating whether GICv3 has GICv2 compatibility */
> +KVM_NVHE_ALIAS(vgic_v3_has_v2_compat);
> +
>  /* Static key which is set if CNTVOFF_EL2 is unusable */
>  KVM_NVHE_ALIAS(broken_cntvoff_key);
>  
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index d81275790e69b..acd909b7f2257 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -295,12 +295,8 @@ void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if)
>  		}
>  	}
>  
> -	/*
> -	 * GICv5 BET0 FEAT_GCIE_LEGACY doesn't include ICC_SRE_EL2. This is due
> -	 * to be relaxed in a future spec release, at which point this in
> -	 * condition can be dropped.
> -	 */
> -	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
> +	/* Only disable SRE if the host implements the GICv2 interface */
> +	if (static_branch_unlikely(&vgic_v3_has_v2_compat)) {
>  		/*
>  		 * Prevent the guest from touching the ICC_SRE_EL1 system
>  		 * register. Note that this may not have any effect, as
> @@ -329,19 +325,16 @@ void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if)
>  		cpu_if->vgic_vmcr = read_gicreg(ICH_VMCR_EL2);
>  	}
>  
> -	/*
> -	 * Can be dropped in the future when GICv5 spec is relaxed. See comment
> -	 * above.
> -	 */
> -	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
> +	/* Only restore SRE if the host implements the GICv2 interface */
> +	if (static_branch_unlikely(&vgic_v3_has_v2_compat)) {
>  		val = read_gicreg(ICC_SRE_EL2);
>  		write_gicreg(val | ICC_SRE_EL2_ENABLE, ICC_SRE_EL2);
> -	}
>  
> -	if (!cpu_if->vgic_sre) {
> -		/* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
> -		isb();
> -		write_gicreg(1, ICC_SRE_EL1);
> +		if (!cpu_if->vgic_sre) {
> +			/* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
> +			isb();
> +			write_gicreg(1, ICC_SRE_EL1);
> +		}
>  	}
>  
>  	/*
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index b9ad7c42c5b01..f1c153106c563 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -588,6 +588,7 @@ int vgic_v3_map_resources(struct kvm *kvm)
>  }
>  
>  DEFINE_STATIC_KEY_FALSE(vgic_v3_cpuif_trap);
> +DEFINE_STATIC_KEY_FALSE(vgic_v3_has_v2_compat);
>  
>  static int __init early_group0_trap_cfg(char *buf)
>  {
> @@ -697,6 +698,13 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  	if (kvm_vgic_global_state.vcpu_base == 0)
>  		kvm_info("disabling GICv2 emulation\n");
>  
> +	/*
> +	 * Flip the static branch if the HW supports v2, even if we're
> +	 * not using it (such as in protected mode).
> +	 */
> +	if (has_v2)
> +		static_branch_enable(&vgic_v3_has_v2_compat);
> +
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_30115)) {
>  		group0_trap = true;
>  		group1_trap = true;
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 404883c7af6e8..9a6340d9c91e5 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -375,6 +375,7 @@ struct vgic_cpu {
>  
>  extern struct static_key_false vgic_v2_cpuif_trap;
>  extern struct static_key_false vgic_v3_cpuif_trap;
> +extern struct static_key_false vgic_v3_has_v2_compat;
>  
>  int kvm_set_legacy_vgic_v2_addr(struct kvm *kvm, struct kvm_arm_device_addr *dev_addr);
>  void kvm_vgic_early_init(struct kvm *kvm);
> -- 
> 2.39.2
> 
