Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BE0E129A63
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 16:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706199944; cv=none; b=FoSeTAe172TeZXxgU0JaMq+LafjbfHIVSOQwzggqSpvpMrAdqYm/IFzcUIqtuRZX767Awc15jGAMvCJMd6DKGWZuH3sW86g6qcb9M5ubLAsdtqc6kStpIp45hu7MJlkmFQoz4UPqj61fN/89bKuFe242n0ZpYr9Zy4vGcEtwIDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706199944; c=relaxed/simple;
	bh=Jk3jdZSXOYRt6ICcI14Aeks4t/q4tlvRRtj8Uy2Bzqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LlIciB8r3V6TdSe6QvFIFuvj5BPk2/x+dP6RyAabyXSS+bw4p0elxc0x0vgW9hW+9LE2eh2fQrP3fbhXspw9tmUxd4uUtQJeykU3LZlfXlHiKgixGm0b0ElRmtkJfw3VLoGRAFzMc4rVHFs/U0THcN5FQ5FOW8Acu1cwTqi8YIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C31A1FB;
	Thu, 25 Jan 2024 08:26:26 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5238D3F5A1;
	Thu, 25 Jan 2024 08:25:40 -0800 (PST)
Date: Thu, 25 Jan 2024 16:25:38 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 24/25] KVM: arm64: Make FEAT_MOPS UNDEF if not advertised
 to the guest
Message-ID: <20240125162538.GF1535978@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-25-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-25-maz@kernel.org>

On Mon, Jan 22, 2024 at 08:18:51PM +0000, Marc Zyngier wrote:
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
>  arch/arm64/kvm/sys_regs.c               | 8 ++++++++
>  4 files changed, 11 insertions(+), 4 deletions(-)
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
> index fe5ed4bcded0..22343354db3e 100644
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
> index afe6975fcf5c..b7977e08e4ef 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3952,6 +3952,14 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
>  	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
>  		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
>  
> +	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
> +		vcpu->arch.hcrx_el2 = HCRX_GUEST_FLAGS;
> +
> +		if (kvm_has_feat(kern_hyp_va(vcpu->kvm),

Not sure if the use of kern_hyp_va is intentional, seems out of place since we
use the bare `kvm` variable everyone else.

> +				 ID_AA64ISAR2_EL1, MOPS, IMP))
> +			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
> +	}
> +
>  	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
>  		goto out;
>  

Thanks,
Joey
