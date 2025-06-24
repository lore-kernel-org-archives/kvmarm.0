Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB5725DCF6
	for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 11:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750765495; cv=none; b=iNLa95ZFKqGAq59bFZcBq/8llrRMlILq5CrwgMkYbdVEQ2/3oCw//pr5xBeqpFIsTFv/a/lSTgEvIOqqyve6c6iKIpk2tHRLSIwjb/OLJy+r8osUZgHUDSC5ETcp4nGKWfu6z/QQxxUJ1cIX19rEVMKt5Zlp2hsySG9jcCyqMAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750765495; c=relaxed/simple;
	bh=6CKuF626uFYLgWcNP9KjoLzs1sR/Wbd84FOw4nxMsnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IgFrmNGfAuGFaKnZFy2sxZtZZmPpIlsvlWevn2MEHyQgUaWICecWG/D36dmez2SiVW6mzs4Xo6xIGPEdX8cxylhMCN/MAT9EXilOQjJgeOclMSyuHTgV9Lth9xBetg5R/EnMs37AiiYtd0JgB9ZgFjbJ8Rd+pU/yYl/9TZrinQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ya/WHTJ0; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ya/WHTJ0"
Date: Tue, 24 Jun 2025 04:44:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750765489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sb3ycj3Hxv6Sdn6Tn/hoZHD6ncx+auIHtcjleChPO2U=;
	b=Ya/WHTJ00P5Fg+QYKbfdnF9fsYqDF/5QlXDM1p+5NkL1vIJx2ldQP9gsemxPnxm5aDNjM4
	aEBQN9YMz3zGB1bhJkgh0xIJOryMdQczHZh1AzcOP9oaE3IJceZd33BLfyguCfywHMS15K
	OkW4SDuXiDRz3cEPkHMyvN76riVosK0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 06/27] KVM: arm64: nv: Honor SError exception routing
 / masking
Message-ID: <aFqPqBqwUdwBc-Ub@linux.dev>
References: <20250616230308.1192565-1-oliver.upton@linux.dev>
 <20250616230308.1192565-7-oliver.upton@linux.dev>
 <86ecvdcqw4.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ecvdcqw4.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 21, 2025 at 11:47:55AM +0100, Marc Zyngier wrote:
> On Tue, 17 Jun 2025 00:02:47 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > To date KVM has used HCR_EL2.VSE to track the state of a pending SError
> > for the guest. With this bit set, hardware respects the EL1 exception
> > routing / masking rules and injects the vSError when appropriate.
> > 
> > This isn't correct for NV guests as hardware is oblivious to vEL2's
> > intentions for SErrors. Better yet, with FEAT_NV2 the guest can change
> > the routing behind our back as HCR_EL2 is redirected to memory. Cope
> > with this mess by:
> > 
> >  - Using a flag (instead of HCR_EL2.VSE) to track the pending SError
> >    state when SErrors are unconditionally masked for the current context
> > 
> >  - Resampling the routing / masking of a pending SError on every guest
> >    entry/exit
> > 
> >  - Emulating exception entry when SError routing implies a translation
> >    regime change
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/include/asm/kvm_emulate.h | 20 +++++++++++++-
> >  arch/arm64/include/asm/kvm_host.h    | 20 +++++++++++---
> >  arch/arm64/include/asm/kvm_nested.h  |  2 ++
> >  arch/arm64/kvm/arm.c                 |  4 +++
> >  arch/arm64/kvm/emulate-nested.c      |  8 ++++++
> >  arch/arm64/kvm/guest.c               | 32 +++++++++++++----------
> >  arch/arm64/kvm/handle_exit.c         |  4 +--
> >  arch/arm64/kvm/hyp/exception.c       |  6 ++++-
> >  arch/arm64/kvm/inject_fault.c        | 39 ++++++++++++++++------------
> >  arch/arm64/kvm/mmu.c                 |  2 +-
> >  arch/arm64/kvm/nested.c              | 36 +++++++++++++++++++++++++
> >  11 files changed, 134 insertions(+), 39 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > index 1a0d51c74b42..45029dd5e9c7 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -45,7 +45,7 @@ bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
> >  void kvm_skip_instr32(struct kvm_vcpu *vcpu);
> >  
> >  void kvm_inject_undefined(struct kvm_vcpu *vcpu);
> > -void kvm_inject_vabt(struct kvm_vcpu *vcpu);
> > +int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr);
> >  int kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
> >  void kvm_inject_size_fault(struct kvm_vcpu *vcpu);
> >  
> > @@ -59,12 +59,25 @@ static inline int kvm_inject_sea_iabt(struct kvm_vcpu *vcpu, u64 addr)
> >  	return kvm_inject_sea(vcpu, true, addr);
> >  }
> >  
> > +static inline int kvm_inject_serror(struct kvm_vcpu *vcpu)
> > +{
> > +	/*
> > +	 * ESR_ELx.ISV (later renamed to IDS) indicates whether or not
> > +	 * ESR_ELx.ISS contains IMPLEMENTATION DEFINED syndrome information.
> > +	 *
> > +	 * Set the bit when injecting an SError w/o an ESR to indicate ISS
> > +	 * does not follow the architected format.
> > +	 */
> > +	return kvm_inject_serror_esr(vcpu, ESR_ELx_ISV);
> > +}
> > +
> >  void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
> >  
> >  void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu);
> >  int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2);
> >  int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
> >  int kvm_inject_nested_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
> > +int kvm_inject_nested_serror(struct kvm_vcpu *vcpu, u64 esr);
> >  
> >  static inline void kvm_inject_nested_sve_trap(struct kvm_vcpu *vcpu)
> >  {
> > @@ -205,6 +218,11 @@ static inline bool vcpu_el2_tge_is_set(const struct kvm_vcpu *vcpu)
> >  	return ctxt_sys_reg(&vcpu->arch.ctxt, HCR_EL2) & HCR_TGE;
> >  }
> >  
> > +static inline bool vcpu_el2_amo_is_set(const struct kvm_vcpu *vcpu)
> > +{
> > +	return ctxt_sys_reg(&vcpu->arch.ctxt, HCR_EL2) & HCR_AMO;
> > +}
> > +
> >  static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
> >  {
> >  	bool e2h, tge;
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 5ccca509dff1..dd7405d676b3 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -817,7 +817,7 @@ struct kvm_vcpu_arch {
> >  	u8 iflags;
> >  
> >  	/* State flags for kernel bookkeeping, unused by the hypervisor code */
> > -	u8 sflags;
> > +	u16 sflags;
> >  
> >  	/*
> >  	 * Don't run the guest (internal implementation need).
> > @@ -953,9 +953,23 @@ struct kvm_vcpu_arch {
> >  		__vcpu_flags_preempt_enable();			\
> >  	} while (0)
> >  
> > +#define __vcpu_test_and_clear_flag(v, flagset, f, m)		\
> > +	({							\
> > +		typeof(v->arch.flagset) set;			\
> > +								\
> > +		__vcpu_flags_preempt_disable();			\
> > +		set = __vcpu_get_flag(v, flagset, f, m);	\
> > +		__vcpu_clear_flag(v, flagset, f, m);		\
> > +		__vcpu_flags_preempt_enable();			\
> 
> I have the feeling that you can drop the preemption manipulation
> here. as __vcpu_clear_flags() already does it.

Agreed, this was previously open-coded which is where I picked up the
explicit preemption guard.

[...]

> > +	if (!serror_pending)
> > +		return 0;
> > +
> > +	if (!cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && has_esr)
> > +		return -EINVAL;
> > +
> > +	if (has_esr && (esr & ~ESR_ELx_ISS_MASK))
> > +		return -EINVAL;
> > +
> > +	if (has_esr)
> 
> We should probably consider whether the VM itself has RAS before
> populating an ESR, and return an error to userspace otherwise. Unless
> that's yet another can of worm that we'd rather stay closed?
> 
> I have the ugly feeling that it might be the latter...

Yeah, I'm rather hesitant to change things around here because we've
made it ABI at this point. This was an oversight when we added support
for writable ID registers.

The hardware sucks here because VSESR propagation happens unconditionally
when FEAT_RAS exists...

> > +void kvm_nested_sync_hwstate(struct kvm_vcpu *vcpu)
> > +{
> > +	unsigned long *hcr = vcpu_hcr(vcpu);
> > +
> > +	if (!vcpu_has_nv(vcpu))
> > +		return;
> > +
> > +	/*
> > +	 * We previously decided that an SError was deliverable to the guest.
> > +	 * Reap the pending state from HCR_EL2 and...
> > +	 */
> > +	if (unlikely(__test_and_clear_bit(__ffs(HCR_VSE), hcr)))
> > +		vcpu_set_flag(vcpu, NESTED_SERROR_PENDING);
> > +
> > +	/* Re-attempt SError injection in case the deliverability has changed */
> > +	if (unlikely(vcpu_test_and_clear_flag(vcpu, NESTED_SERROR_PENDING)))
> > +		kvm_inject_serror_esr(vcpu, vcpu_get_vsesr(vcpu));
> 
> Why do we need to re-attempt the injection, given that we already do
> it on flush?

This bit needs a clarifying comment, because it is actually
load-bearing. We need to make sure a pending SError (unmasked by AMO) is
treated as a wakeup condition for WFI emulation. e.g. we may block
indefinitely in the case of:

	sysreg_clear_set(hcr_el2, HCR_EL2_AMO, 0);
	isb();
	local_daif_mask();
	assert(read_sysreg(isr_el1) & ISR_EL1_A); /* Pending SError */
	sysreg_clear_set(hcr_el2, 0, HCR_EL2_AMO);
	isb();
	wfi();
	local_daif_restore();

For that to work we need to set the VSE line and can't check the vCPU
flag itself (SErrors masked by AMO are *not* wakeup conditions).

> Another thing that might be worth considering is how this pending
> state is preserved across save/restore. The GIC provides this state
> implicitly for IRQ/FIQ, but we don't have an external component
> driving SError. Do we need to do anything about this here?

I think that's working as intended, I updated KVM_GET_VCPU_EVENTS to
test the flag in addition to VSE. I'll stick a mention in the changelog
to make that a bit more obvious.

Thanks,
Oliver
