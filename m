Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD9B7CF18
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 17:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706116584; cv=none; b=ChZCDzKeKxm9+jrnemBjsV9ImcSVaj8XiQ7d9U9vrjjmvgoDqxi8zCydu2uUAfUyU7J3HMrEYg8zvppT7KRtshECDHOwD5PSXxXQFhGpoolWMNSCQew6E9Z0ojqsUYCED8CGOonkkf1vj0LRBTIiH4NP/Fyibt+uKOPrVralBrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706116584; c=relaxed/simple;
	bh=rCzzbUU4xb5U9AQowstMR5B/WmYSvDbx2sV1q5EZVWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OOKxT0nWWX1/UMGNwcPM7czdmtEyujwv1g4s/ZjtQh5Uu2Jcdl0M+aCmiaUZGKNLCfhuXx/3HDo20zbqFidkxUVd3gVfmPhbJK1/7q6i9oKKmegtA3Bdp3lqDM6vKY4Y653O+9OHuYPMtWPxnwg9/kSFsOE24TZtYnDzBxO4Je8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 071591FB;
	Wed, 24 Jan 2024 09:17:07 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC27D3F762;
	Wed, 24 Jan 2024 09:16:20 -0800 (PST)
Date: Wed, 24 Jan 2024 17:16:18 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 19/25] KVM: arm64: Move existing feature disabling over
 to FGU infrastructure
Message-ID: <20240124171618.GB1535978@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-20-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-20-maz@kernel.org>

Greetings,

On Mon, Jan 22, 2024 at 08:18:46PM +0000, Marc Zyngier wrote:
> We already trap a bunch of existing features for the purpose of
> disabling them (MAIR2, POR, ACCDATA, SME...).
> 
> Let's move them over to our brand new FGU infrastructure.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h       |  4 ++++
>  arch/arm64/kvm/arm.c                    |  6 ++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 17 +++--------------
>  arch/arm64/kvm/sys_regs.c               | 23 +++++++++++++++++++++++
>  4 files changed, 36 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 4e0ac507ca01..fe5ed4bcded0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -297,6 +297,8 @@ struct kvm_arch {
>  #define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		6
>  	/* Initial ID reg values loaded */
>  #define KVM_ARCH_FLAG_ID_REGS_INITIALIZED		7
> +	/* Fine-Grained UNDEF initialised */
> +#define KVM_ARCH_FLAG_FGU_INITIALIZED			8
>  	unsigned long flags;
>  
>  	/* VM-wide vCPU feature set */
> @@ -1112,6 +1114,8 @@ int __init populate_nv_trap_config(void);
>  bool lock_all_vcpus(struct kvm *kvm);
>  void unlock_all_vcpus(struct kvm *kvm);
>  
> +void kvm_init_sysreg(struct kvm_vcpu *);
> +
>  /* MMIO helpers */
>  void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
>  unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c063e84fc72c..9f806c9b7d5d 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -675,6 +675,12 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  			return ret;
>  	}
>  
> +	/*
> +	 * This needs to happen after NV has imposed its own restrictions on
> +	 * the feature set
> +	 */
> +	kvm_init_sysreg(vcpu);
> +
>  	ret = kvm_timer_enable(vcpu);
>  	if (ret)
>  		return ret;
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index a09149fd91ed..245f9c1ca666 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -157,7 +157,7 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
>  	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
> -	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
> +	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0;
>  	u64 r_val, w_val;
>  
>  	CHECK_FGT_MASKS(HFGRTR_EL2);
> @@ -174,13 +174,6 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  	ctxt_sys_reg(hctxt, HFGRTR_EL2) = read_sysreg_s(SYS_HFGRTR_EL2);
>  	ctxt_sys_reg(hctxt, HFGWTR_EL2) = read_sysreg_s(SYS_HFGWTR_EL2);
>  
> -	if (cpus_have_final_cap(ARM64_SME)) {
> -		tmp = HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_EL0_MASK;
> -
> -		r_clr |= tmp;
> -		w_clr |= tmp;
> -	}
> -
>  	/*
>  	 * Trap guest writes to TCR_EL1 to prevent it from enabling HA or HD.
>  	 */
> @@ -195,15 +188,11 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  	compute_undef_clr_set(vcpu, kvm, HFGRTR_EL2, r_clr, r_set);
>  	compute_undef_clr_set(vcpu, kvm, HFGWTR_EL2, w_clr, w_set);
>  
> -	/* The default to trap everything not handled or supported in KVM. */
> -	tmp = HFGxTR_EL2_nAMAIR2_EL1 | HFGxTR_EL2_nMAIR2_EL1 | HFGxTR_EL2_nS2POR_EL1 |
> -	      HFGxTR_EL2_nPOR_EL1 | HFGxTR_EL2_nPOR_EL0 | HFGxTR_EL2_nACCDATA_EL1;
> -
> -	r_val = __HFGRTR_EL2_nMASK & ~tmp;
> +	r_val = __HFGRTR_EL2_nMASK;
>  	r_val |= r_set;
>  	r_val &= ~r_clr;
>  
> -	w_val = __HFGWTR_EL2_nMASK & ~tmp;
> +	w_val = __HFGWTR_EL2_nMASK;
>  	w_val |= w_set;
>  	w_val &= ~w_clr;
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c48bc2577162..a62efd8a2959 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3943,6 +3943,29 @@ int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm, struct reg_mask_range *
>  	return 0;
>  }
>  
> +void kvm_init_sysreg(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	mutex_lock(&kvm->arch.config_lock);
> +
> +	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
> +		goto out;
> +
> +	kvm->arch.fgu[HFGxTR_GROUP] = (HFGxTR_EL2_nAMAIR2_EL1		|
> +				       HFGxTR_EL2_nMAIR2_EL1		|
> +				       HFGxTR_EL2_nS2POR_EL1		|
> +				       HFGxTR_EL2_nPOR_EL1		|
> +				       HFGxTR_EL2_nPOR_EL0		|
> +				       HFGxTR_EL2_nACCDATA_EL1		|
> +				       HFGxTR_EL2_nSMPRI_EL1_MASK	|
> +				       HFGxTR_EL2_nTPIDR2_EL0_MASK);
> +
> +	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
> +out:
> +	mutex_unlock(&kvm->arch.config_lock);
> +}
> +
>  int __init kvm_sys_reg_table_init(void)
>  {
>  	struct sys_reg_params params;

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
