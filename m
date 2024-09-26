Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A910E18D656
	for <kvmarm@lists.linux.dev>; Thu, 26 Sep 2024 07:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727335421; cv=none; b=BoiQs9TNJ1bUrecuJ1AlS6rLk+TCTr7jjq76fvHO9ORriPW4TE8S2f+O7v929tMYO3ci4mpxLtcnjHxZQSqDraU4i9rjZv7Ghs8M1/8t+e+LFygz8APQd4DI6CiFXK4Z3zmenNjzLAm7rft58P+Ub/QHHd3m45+VVPe4M8R0Uwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727335421; c=relaxed/simple;
	bh=2ioXvhnYQmBXk12dSBLdQoAJznJnVZ4GhTtw8CVkreA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HDHcFYLI+nmZTBXfBnFC5bcC2y58zDkYaflCpeLeiSKjD0me5H2fez6T4bz0y2rVA4/L7PDCqD/dNuKjhOXwWvzA7iz2qI35PP2vvroRFfR4wf+uSgLy0BJbyZ98qy1kiBvbwbXMU1ubDsRiwPPeOOrHCZAa+21Pjt9iLVBaFTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LK+9hoAF; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LK+9hoAF"
Date: Thu, 26 Sep 2024 09:23:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727335417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M74QGAwrZ1qMfz1BFpXYDpWU8+8YmkAu637hCGvBle4=;
	b=LK+9hoAFd4m/K1ZOZML//fwnZLwPZLLrjFSfwYCU+EZEhXJI4akJZyd4He3SFuzAQg0SaF
	/v1oPBieCSTaZ8r4j5KphkM7JlW+/taETVooh0+ECPFnS0yD31NemiDIZe1Gw3RNK43m2V
	rtdc7pn3k/BCUybEnYN+v4aDw8M/RWo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Eric Auger <eauger@redhat.com>, Sebastian Ott <sebott@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/2] KVM: arm64: Use kvm_has_feat() to check if
 FEAT_RAS is advertised to the guest
Message-ID: <ZvUL9SrVo4hn3aR0@linux.dev>
References: <20240926032244.3666579-1-shahuang@redhat.com>
 <20240926032244.3666579-2-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240926032244.3666579-2-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 25, 2024 at 11:22:39PM -0400, Shaoqin Huang wrote:
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index d7c2990e7c9e..99f256629ead 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -405,7 +405,7 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
>  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
>  {
>  	if (ARM_SERROR_PENDING(exception_index)) {
> -		if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
> +		if (kvm_has_feat(vcpu->kvm, ID_AA64PFR0_EL1, RAS, IMP)) {
>  			u64 disr = kvm_vcpu_get_disr(vcpu);
>  
>  			kvm_handle_guest_serror(vcpu, disr_to_esr(disr));

This is wrong; this is about handling *physical* SErrors, not virtual
ones.

So it really ought to be keyed off of the host cpucap.

> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 37ff87d782b6..bf176a3cc594 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -272,7 +272,7 @@ static inline void ___activate_traps(struct kvm_vcpu *vcpu, u64 hcr)
>  
>  	write_sysreg(hcr, hcr_el2);
>  
> -	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
> +	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR0_EL1, RAS, IMP) && (hcr & HCR_VSE))
>  		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
>  }

I don't think this should be conditioned on guest visibility either. If
FEAT_RAS is implemented in hardware, ESR_EL1 is set to the value of
VSESR_EL2 when the vSError is taken, no matter what.

> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index 4c0fdabaf8ae..98526556d4e5 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -105,6 +105,8 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  
>  static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
>  {
> +	struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
> +
>  	ctxt->regs.pc			= read_sysreg_el2(SYS_ELR);
>  	/*
>  	 * Guest PSTATE gets saved at guest fixup time in all
> @@ -113,7 +115,7 @@ static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
>  	if (!has_vhe() && ctxt->__hyp_running_vcpu)
>  		ctxt->regs.pstate	= read_sysreg_el2(SYS_SPSR);
>  
> -	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
> +	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR0_EL1, RAS, IMP))
>  		ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
>  }
>  
> @@ -220,6 +222,7 @@ static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctx
>  {
>  	u64 pstate = to_hw_pstate(ctxt);
>  	u64 mode = pstate & PSR_AA32_MODE_MASK;
> +	struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
>  
>  	/*
>  	 * Safety check to ensure we're setting the CPU up to enter the guest
> @@ -238,7 +241,7 @@ static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctx
>  	write_sysreg_el2(ctxt->regs.pc,			SYS_ELR);
>  	write_sysreg_el2(pstate,			SYS_SPSR);
>  
> -	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
> +	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR0_EL1, RAS, IMP))
>  		write_sysreg_s(ctxt_sys_reg(ctxt, DISR_EL1), SYS_VDISR_EL2);
>  }

These registers are still stateful no matter what, we cannot prevent an
ESB instruction inside the VM from consuming a pending vSError.

Keep in mind the ESB instruction is a NOP without FEAT_RAS, so it is
still a legal instruction for a VM w/o FEAT_RAS.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 31e49da867ff..b09f8ba3525b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -4513,7 +4513,7 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
>  
>  	if (has_vhe() || has_hvhe())
>  		vcpu->arch.hcr_el2 |= HCR_E2H;
> -	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
> +	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP)) {
>  		/* route synchronous external abort exceptions to EL2 */
>  		vcpu->arch.hcr_el2 |= HCR_TEA;
>  		/* trap error record accesses */

No, we want external aborts to be taken to EL2. Wouldn't this also have
the interesting property of allowing a VM w/o FEAT_RAS to access the
error record registers?

-- 
Thanks,
Oliver
