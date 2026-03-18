Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA535289378
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 15:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773848083; cv=none; b=vDSHpB6E8zjYuwAJHFsZieYaJKptyKPST/jPCr6WWyV4TtF37edm66TiERx+bLGEWhJRiXY57yKxGoP3TI8bK+z+nV2CL9daSH40rNk5vFEPMI6MJxu/WEmSx3Kq8wGC4us9AJ9riHLcOaBeKk9wzSvl3DrXW9eJngYPdcgFb7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773848083; c=relaxed/simple;
	bh=zVN6DmfGq2PVx/FN4NmSFbZfsg7n/HbRD8oYuZuGHIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0FqbmQKTSg9NmPwRld5dRemeOn8AXPLiDAJ7fcWjojGxuslVzHavGQD3Qxrd6rmNr1cUTHlCLhcUsheaN1jDQgfIbxHGohAZAOobs/qOmLR6gF3fiBnPioVXECJ/2miKPQPzo0R5E1fqNMkdH/lFXPXYMfvDl7FQLiTE4K79vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 444D71C2B;
	Wed, 18 Mar 2026 08:34:35 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C4D0F3F73B;
	Wed, 18 Mar 2026 08:34:39 -0700 (PDT)
Date: Wed, 18 Mar 2026 15:34:32 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
Subject: Re: [PATCH v6 35/39] KVM: arm64: gic-v5: Probe for GICv5 device
Message-ID: <20260318153432.GA3939846@e124191.cambridge.arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
 <20260317113949.2548118-36-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317113949.2548118-36-sascha.bischoff@arm.com>

On Tue, Mar 17, 2026 at 11:49:02AM +0000, Sascha Bischoff wrote:
> The basic GICv5 PPI support is now complete. Allow probing for a
> native GICv5 rather than just the legacy support.
> 
> The implementation doesn't support protected VMs with GICv5 at this
> time. Therefore, if KVM has protected mode enabled the native GICv5
> init is skipped, but legacy VMs are allowed if the hardware supports
> it.
> 
> At this stage the GICv5 KVM implementation only supports PPIs, and
> doesn't interact with the host IRS at all. This means that there is no
> need to check how many concurrent VMs or vCPUs per VM are supported by
> the IRS - the PPI support only requires the CPUIF. The support is
> artificially limited to VGIC_V5_MAX_CPUS, i.e. 512, vCPUs per VM.
> 
> With this change it becomes possible to run basic GICv5-based VMs,
> provided that they only use PPIs.
> 
> Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> ---
>  arch/arm64/kvm/vgic/vgic-v5.c | 43 ++++++++++++++++++++++++++---------
>  1 file changed, 32 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 32565bfbd1051..e491ae0e4f56e 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -39,24 +39,13 @@ static void vgic_v5_get_implemented_ppis(void)
>  
>  /*
>   * Probe for a vGICv5 compatible interrupt controller, returning 0 on success.
> - * Currently only supports GICv3-based VMs on a GICv5 host, and hence only
> - * registers a VGIC_V3 device.
>   */
>  int vgic_v5_probe(const struct gic_kvm_info *info)
>  {
>  	u64 ich_vtr_el2;
>  	int ret;
>  
> -	vgic_v5_get_implemented_ppis();
> -
> -	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
> -		return -ENODEV;
> -
>  	kvm_vgic_global_state.type = VGIC_V5;
> -	kvm_vgic_global_state.has_gcie_v3_compat = true;
> -
> -	/* We only support v3 compat mode - use vGICv3 limits */
> -	kvm_vgic_global_state.max_gic_vcpus = VGIC_V3_MAX_CPUS;
>  
>  	kvm_vgic_global_state.vcpu_base = 0;
>  	kvm_vgic_global_state.vctrl_base = NULL;
> @@ -64,6 +53,34 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
>  	kvm_vgic_global_state.has_gicv4 = false;
>  	kvm_vgic_global_state.has_gicv4_1 = false;
>  
> +	/*
> +	 * GICv5 is currently not supported in Protected mode. Skip the
> +	 * registration of GICv5 completely to make sure no guests can create a
> +	 * GICv5-based guest.
> +	 */
> +	if (is_protected_kvm_enabled()) {
> +		kvm_info("GICv5-based guests are not supported with pKVM\n");
> +		goto skip_v5;
> +	}
> +
> +	kvm_vgic_global_state.max_gic_vcpus = VGIC_V5_MAX_CPUS;
> +
> +	vgic_v5_get_implemented_ppis();
> +
> +	ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
> +	if (ret) {
> +		kvm_err("Cannot register GICv5 KVM device.\n");
> +		goto skip_v5;
> +	}
> +
> +	kvm_info("GCIE system register CPU interface\n");
> +
> +skip_v5:
> +	/* If we don't support the GICv3 compat mode we're done. */
> +	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))

If we jump to skip_v5 because we're in pKVM, but don't have
ARM64_HAS_GICV5_LEGACY, this returns 0 but should probably be -ENODEV?

Thanks,
Joey

> +		return 0;
> +
> +	kvm_vgic_global_state.has_gcie_v3_compat = true;
>  	ich_vtr_el2 =  kvm_call_hyp_ret(__vgic_v3_get_gic_config);
>  	kvm_vgic_global_state.ich_vtr_el2 = (u32)ich_vtr_el2;
>  
> @@ -79,6 +96,10 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
>  		return ret;
>  	}
>  
> +	/* We potentially limit the max VCPUs further than we need to here */
> +	kvm_vgic_global_state.max_gic_vcpus = min(VGIC_V3_MAX_CPUS,
> +						  VGIC_V5_MAX_CPUS);
> +
>  	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
>  	kvm_info("GCIE legacy system register CPU interface\n");
>  
> -- 
> 2.34.1
