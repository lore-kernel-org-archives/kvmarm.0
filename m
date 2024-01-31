Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D066376E9
	for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 14:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706712414; cv=none; b=pqTZIFBmmzN/mUypcwgAfTYnojRgtOWIGzqfd2oBa6BDA5AyHA4xTnHKepTTnhYseFaz6J+mobN1C3yU3QNtvIlp2EGf5nX4ACp4bAv9hInupIhSIu3C+dI7wGzq4BurHCnUlfhK/rO8B/OQgbjeDMN6Or0DLHlWgK9hYhR1Ic4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706712414; c=relaxed/simple;
	bh=tAvbaXTA57WElsRbWFTVA7Z8M3D9YpCoYbQ0Jl9g5p4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSdSq6Fxfr20nAg4tCKb5c/IFN5HpFnwwnS5b8LNwgikAwAFh4LwoK0K6hk4Q+ub81yCj0RlxKQXhXLxm7r62GKohA+FVIL4mseJrgIwUxMxx7CWu7gU4HlO5rucxYXI54KKp/E3qCsHxdmE59fUm9LwTnNBWwN8CtIT6ZyP+Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE59EDA7;
	Wed, 31 Jan 2024 06:47:34 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5502E3F738;
	Wed, 31 Jan 2024 06:46:50 -0800 (PST)
Date: Wed, 31 Jan 2024 14:46:45 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 22/25] KVM: arm64: Make PIR{,E0}_EL1 UNDEF if S1PIE is
 not advertised to the guest
Message-ID: <20240131144645.GA2284078@e124191.cambridge.arm.com>
References: <20240130204533.693853-1-maz@kernel.org>
 <20240130204533.693853-23-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130204533.693853-23-maz@kernel.org>

Afternoon,

On Tue, Jan 30, 2024 at 08:45:29PM +0000, Marc Zyngier wrote:
> As part of the ongoing effort to honor the guest configuration,
> add the necessary checks to make PIR_EL1 and co UNDEF if not
> advertised to the guest, and avoid context switching them.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 24 +++++++++++++++++++---
>  arch/arm64/kvm/sys_regs.c                  |  4 ++++
>  2 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index bb6b571ec627..4be6a7fa0070 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -27,16 +27,34 @@ static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
>  	ctxt_sys_reg(ctxt, TPIDRRO_EL0)	= read_sysreg(tpidrro_el0);
>  }
>  
> -static inline bool ctxt_has_mte(struct kvm_cpu_context *ctxt)
> +static inline struct kvm_vcpu *ctxt_to_vcpu(struct kvm_cpu_context *ctxt)
>  {
>  	struct kvm_vcpu *vcpu = ctxt->__hyp_running_vcpu;
>  
>  	if (!vcpu)
>  		vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);
>  
> +	return vcpu;
> +}
> +
> +static inline bool ctxt_has_mte(struct kvm_cpu_context *ctxt)
> +{
> +	struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
> +
>  	return kvm_has_mte(kern_hyp_va(vcpu->kvm));
>  }
>  
> +static inline bool ctxt_has_s1pie(struct kvm_cpu_context *ctxt)
> +{
> +	struct kvm_vcpu *vcpu;
> +
> +	if (!cpus_have_final_cap(ARM64_HAS_S1PIE))
> +		return false;
> +
> +	vcpu = ctxt_to_vcpu(ctxt);
> +	return kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64MMFR3_EL1, S1PIE, IMP);
> +}
> +
>  static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  {
>  	ctxt_sys_reg(ctxt, SCTLR_EL1)	= read_sysreg_el1(SYS_SCTLR);
> @@ -55,7 +73,7 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  	ctxt_sys_reg(ctxt, CONTEXTIDR_EL1) = read_sysreg_el1(SYS_CONTEXTIDR);
>  	ctxt_sys_reg(ctxt, AMAIR_EL1)	= read_sysreg_el1(SYS_AMAIR);
>  	ctxt_sys_reg(ctxt, CNTKCTL_EL1)	= read_sysreg_el1(SYS_CNTKCTL);
> -	if (cpus_have_final_cap(ARM64_HAS_S1PIE)) {
> +	if (ctxt_has_s1pie(ctxt)) {
>  		ctxt_sys_reg(ctxt, PIR_EL1)	= read_sysreg_el1(SYS_PIR);
>  		ctxt_sys_reg(ctxt, PIRE0_EL1)	= read_sysreg_el1(SYS_PIRE0);
>  	}
> @@ -131,7 +149,7 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
>  	write_sysreg_el1(ctxt_sys_reg(ctxt, CONTEXTIDR_EL1), SYS_CONTEXTIDR);
>  	write_sysreg_el1(ctxt_sys_reg(ctxt, AMAIR_EL1),	SYS_AMAIR);
>  	write_sysreg_el1(ctxt_sys_reg(ctxt, CNTKCTL_EL1), SYS_CNTKCTL);
> -	if (cpus_have_final_cap(ARM64_HAS_S1PIE)) {
> +	if (ctxt_has_s1pie(ctxt)) {
>  		write_sysreg_el1(ctxt_sys_reg(ctxt, PIR_EL1),	SYS_PIR);
>  		write_sysreg_el1(ctxt_sys_reg(ctxt, PIRE0_EL1),	SYS_PIRE0);
>  	}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f07ee7c89822..da9db99c77e7 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3994,6 +3994,10 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
>  						HFGITR_EL2_TLBIRVAAE1OS	|
>  						HFGITR_EL2_TLBIRVAE1OS);
>  
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
> +		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
> +						HFGxTR_EL2_nPIR_EL1);
> +
>  	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
>  out:
>  	mutex_unlock(&kvm->arch.config_lock);

Fixed lopsided-ness between save/restore from v1, also added a helper for getting the vcpu.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
