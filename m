Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4DB98288F
	for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 15:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706713351; cv=none; b=mMgULfbvNvSffuIQfnBx/qf+znNsKeT+jh4Ald/u6ujIdqAHsE3bZQgPv+wXQ8kfWc6qYVei2YBOlydXcvgrc4MP+DxqdGCQoI9NQGl2H3w5AsHD71phH5e9ExVJphQ/sncB8Npsy7DbulpJgcq00PVQbWVgvp+X/l7OH+gFzWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706713351; c=relaxed/simple;
	bh=JTDof3Q4DLXcpnU1xaQtEdZJeC6uKxp6FRdWLQ0kQIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jdWdzHW9dP/i6yzoBhCmbB8GLj0LnxzkH3pJWJ9LoD37CZLOYoqZVntd9Y7AkfGpyzqTAknWk6smWmlYSPWreLqLFT8oT7K4Yfel09zqgM8rtv2dJrGdgTELY33l0VRLIEEjU9S+ifH64PQHHRMYktENXl/iB3U7LQyMxvufuXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 466DFDA7;
	Wed, 31 Jan 2024 07:03:12 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A499E3F762;
	Wed, 31 Jan 2024 07:02:27 -0800 (PST)
Date: Wed, 31 Jan 2024 15:02:25 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 24/25] KVM: arm64: Make FEAT_MOPS UNDEF if not
 advertised to the guest
Message-ID: <20240131150225.GD2284078@e124191.cambridge.arm.com>
References: <20240130204533.693853-1-maz@kernel.org>
 <20240130204533.693853-25-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130204533.693853-25-maz@kernel.org>

On Tue, Jan 30, 2024 at 08:45:31PM +0000, Marc Zyngier wrote:
> We unconditionally enable FEAT_MOPS, which is obviously wrong.
> 
> So let's only do that when it is advertised to the guest.
> Which means we need to rely on a per-vcpu HCRX_EL2 shadow register.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h        | 4 +---
>  arch/arm64/include/asm/kvm_host.h       | 1 +
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
>  arch/arm64/kvm/sys_regs.c               | 7 +++++++
>  4 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 3c6f8ba1e479..a1769e415d72 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -102,9 +102,7 @@
>  #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
>  #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
>  
> -#define HCRX_GUEST_FLAGS \
> -	(HCRX_EL2_SMPME | HCRX_EL2_TCR2En | \
> -	 (cpus_have_final_cap(ARM64_HAS_MOPS) ? (HCRX_EL2_MSCEn | HCRX_EL2_MCE2) : 0))
> +#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME | HCRX_EL2_TCR2En)
>  #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En)
>  
>  /* TCR_EL2 Registers bits */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index eff894d59590..50a122d42587 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -584,6 +584,7 @@ struct kvm_vcpu_arch {
>  
>  	/* Values of trap registers for the guest. */
>  	u64 hcr_el2;
> +	u64 hcrx_el2;
>  	u64 mdcr_el2;
>  	u64 cptr_el2;
>  
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 2d5891518006..e3fcf8c4d5b4 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -236,7 +236,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
>  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>  
>  	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
> -		u64 hcrx = HCRX_GUEST_FLAGS;
> +		u64 hcrx = vcpu->arch.hcrx_el2;
>  		if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
>  			u64 clr = 0, set = 0;
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 38ed47bd29db..2cb69efac1dc 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3956,6 +3956,13 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
>  	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
>  		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
>  
> +	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
> +		vcpu->arch.hcrx_el2 = HCRX_GUEST_FLAGS;
> +
> +		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
> +			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
> +	}
> +
>  	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
>  		goto out;
>  

Removed incorrect kern_hyp_va().

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
