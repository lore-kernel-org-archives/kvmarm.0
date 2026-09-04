Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC6E5470115;
	Fri,  4 Sep 2026 10:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518492; cv=none; b=mA2hNOYG8KQrkbNCOSFnJqWpnKtsD4D2xKoktxnp9C1fUDbfNiS9oIK/+NZKRcapB9wqh5bzUC1YhpvauPaw/4uK2dWDDAzAFvITzLHRboqbvsAJyi7RO+f4Sn8C7U7sQOs8JqiFclPsZswprOc/ib778vuC2a2EcDYojZcyBwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518492; c=relaxed/simple;
	bh=/agTbhJqKJoeVpsxtBUywSGRTbSYkb+ofav24E897pc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gYxSgbZxRhru+CApcLSeqqljv3bWi11ylgoP5XaQgSk5mpY4poQgHmu77AEtJMGIbwjzELlFNTC88Nr/PdeZdlMQXswqnkXc39wrRduxj+3WC1rid9JzgB4aQ8vKgVGP1Htp5TvvV8+1nFXIVLwcCZIXT1cdlo4vDIIorUvMOK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=t8Ft236k; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="t8Ft236k"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 12CA5153B;
	Fri,  4 Sep 2026 03:41:25 -0700 (PDT)
Received: from e140010.arm.com (unknown [10.1.34.66])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5BB913F673;
	Fri,  4 Sep 2026 03:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788518488; bh=/agTbhJqKJoeVpsxtBUywSGRTbSYkb+ofav24E897pc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t8Ft236k8GicWv9qebL9dcEP/9N315sB6d5KdkQIzTm3qI1thhLD8II5iGmwC+5gm
	 xxZvj/3zLeUrMc8xdW0lrMsWCcN1NmF5zfp6dfDWRHf4k2w/dGxMLKlK5kCA9Zpm52
	 x5j/JlbqTbHmxMj1sgbDxHflASQfFwwtamyp5Kxw=
Date: Fri, 4 Sep 2026 11:41:24 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org
Subject: Re: [RFC PATCH v7 17/28] KVM: arm64: Apply a RES0 mask to
 PMBLIMITR_EL1 writes
Message-ID: <apqgVBwelJtyuwBq@e140010.arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-18-alexandru.elisei@arm.com>
 <20260903163758.22D8D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260903163758.22D8D1F000E9@smtp.kernel.org>

Hi Sashiko,

On Thu, Sep 03, 2026 at 04:37:57PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Critical] get_user_spe_sysreg() and set_user_spe_sysreg() return -EBUSY before SPE initialization, violating the KVM_GET_REG_LIST contract.
> - [High] Userspace can bypass the PMBLIMITR_EL1 RES0 mask by writing to the register before the first KVM_RUN.
> - [Low] Missing READ_ONCE() when accessing pmblimitr_el1_res0_mask causes a data race.
> --
> 
> commit 1270412c2611a30b1f16a0aa9858eb290c7f9768
> Author: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> KVM: arm64: Apply a RES0 mask to PMBLIMITR_EL1 writes
> 
> This commit introduces a RES0 mask for PMBLIMITR_EL1 to hide unsupported
> granule sizes from the guest. It computes this mask during the vCPU's
> first run and applies it when userspace or the guest writes to the register.
> 
> > diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> > index 6a00a44c73edf..8c173a1f48bd4 100644
> > --- a/arch/arm64/kvm/spe.c
> > +++ b/arch/arm64/kvm/spe.c
> [ ... ]
> > @@ -60,13 +60,43 @@ bool kvm_supports_spe(void)
> [ ... ]
> >  int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
> >  {
> > +	struct kvm *kvm = vcpu->kvm;
> > +	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
> >  
> > -	if (!vcpu_spe->initialized)
> > +	if (!kvm_vcpu_spe_initialized(vcpu))
> >  		return -EINVAL;
> >  
> > +	if (!kvm_spe->pmblimitr_el1_res0_mask)
> 
> [Severity: Low]
> Does this plain read of pmblimitr_el1_res0_mask need a READ_ONCE() to
> prevent compiler-induced load tearing?
> 
> The mask is updated locklessly using WRITE_ONCE() inside
> kvm_spe_compute_pmblimitr_el1_res0_mask(). Without a READ_ONCE() here,
> concurrent vCPU executions could trigger a data race.

Ok.

> 
> > +		kvm_spe_compute_pmblimitr_el1_res0_mask(kvm);
> >  
> >  	return 0;
> >  }
> > @@ -85,8 +115,12 @@ void kvm_spe_destroy_vm(struct kvm *kvm)
> >  
> >  bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
> >  {
> > +	struct kvm_spe *kvm_spe = &vcpu->kvm->arch.kvm_spe;
> > +
> >  	switch (reg) {
> >  	case PMBLIMITR_EL1:
> > +		val &= ~kvm_spe->pmblimitr_el1_res0_mask;
> 
> [Severity: High]
> Can userspace bypass this RES0 sanitization?
> 
> If the VMM calls KVM_SET_ONE_REG for PMBLIMITR_EL1 before running the vCPU
> for the first time, pmblimitr_el1_res0_mask will still be 0.
> 
> Because the mask isn't computed until the first run, the bitwise NOT evaluates
> to all 1s (val &= ~0), which leaves the user-provided value unmodified and
> potentially exposes the host hardware to unsupported granule configurations.

That's correct, I assumed here that userspace will be aware of the
constraints on PMBLIMITR_EL1 due to missing architectural features and write the
correct value.

Is that placing a too high a burden on userspace? If it is, I can recompute
PMBLIMITR_EL1 when the VCPU is first run.

> 
> [Severity: Low]
> Does this mask read also need a READ_ONCE() to safely pair with the
> WRITE_ONCE() update, similar to the check in kvm_spe_vcpu_first_run_init()?

Ok.

> 
> > +		fallthrough;
> >  	case PMBSR_EL1:
> >  	case PMBPTR_EL1:
> >  		__vcpu_assign_sys_reg(vcpu, reg, val);
> 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 89b01b6ac7830..4c4bf88c9aa53 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> [ ... ]
> > @@ -1563,6 +1563,38 @@ static unsigned int spe_visibility(const struct kvm_vcpu *vcpu,
> >  	return REG_HIDDEN;
> >  }
> >  
> > +static int set_user_spe_sysreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> > +			       u64 val)
> > +{
> > +	int reg = r->reg;
> > +
> > +	if (!kvm_vcpu_spe_initialized(vcpu))
> > +		return -EBUSY;
> 
> [Severity: Critical]
> Does returning -EBUSY here break the KVM_GET_REG_LIST ABI contract?
> 
> spe_visibility() currently exposes SPE registers based purely on
> vcpu_has_spe(). Because of this, KVM_GET_REG_LIST will advertise the SPE
> registers immediately after a vCPU is created with the SPE feature.
> 
> If a VMM queries the register list and then calls KVM_GET_ONE_REG or
> KVM_SET_ONE_REG before KVM_ARM_VCPU_SPE_INIT is called, it will unexpectedly
> hit this -EBUSY path and fail. The KVM API requires that any register
> returned by KVM_GET_REG_LIST must be successfully readable via
> KVM_GET_ONE_REG.

I can't help but notice an inconsistency: here you say that any register
returned by KVM_GET_REG_LIST must be successfully *readable*, yet above you're
saying that a it is a *write* that breaks the KVM_GET_REG_LIST ABI contract.

Regardless, I think you're right. I only put the check there so I can update the
interrupt level on a PMBSR_EL1 write (implemented later in the series). What I
can do is try to update the interrupt level when the VCPU is first run,
alongside applying the res0 mask to PMBLIMITR_EL1.

Thanks,
Alex

> 
> > +
> > +	if (reg == PMBLIMITR_EL1 || reg == PMBPTR_EL1 || reg == PMBSR_EL1)
> > +		kvm_spe_write_sysreg(vcpu, reg, val);
> > +	else
> > +		__vcpu_assign_sys_reg(vcpu, reg, val);
> > +
> > +	return 0;
> > +}
> > +
> > +static int get_user_spe_sysreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> > +			       u64 *val)
> > +{
> > +	int reg = r->reg;
> > +
> > +	if (!kvm_vcpu_spe_initialized(vcpu))
> > +		return -EBUSY;
> > +
> > +	if (reg == PMBLIMITR_EL1 || reg == PMBPTR_EL1 || reg == PMBSR_EL1)
> > +		*val = kvm_spe_read_sysreg(vcpu, reg);
> > +	else
> > +		*val = __vcpu_sys_reg(vcpu, reg);
> > +
> > +	return 0;
> > +}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260903160623.315525-1-alexandru.elisei@arm.com?part=17
