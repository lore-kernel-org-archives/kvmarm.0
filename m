Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4A7568FCD
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 16:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790095082; cv=none; b=cnuq7rffmsZFKYvgU5fKvwZCW6IW1w/b+CUK3WZgV3ZEi7QGZgVGrz8u4iQjKZ13BT6uiFuijUIyWNmQT0zwwXc4gtyj/3krH2K/WVa4kd51NEjWCEbmHg4BTQkaK8CHlEA4MooCSjBYPvGuCYyzGbmAbWHbAC7U9ei7JDz9a5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790095082; c=relaxed/simple;
	bh=oWVWz9/UOGboFOBqCRKNmH51jELuYZDsjrQ9SROQhZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UteqFNxm22zLK/dDlMHKxHG+VxX/WApfMxiHQB4oEOrpUK3cdTqvlRSP9NzwatmN9FW+EeKii0QuBGXrqkPuNT3sta9AJqtOUrGAXTBuJ9nWFW55KlMtdZizCj7UtLYkF1otp7rXhA0TpHzhzco110wcxpVCaex+OJSFX/RmfSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lPws/qsG; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lPws/qsG"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e620fa473so27227955e9.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 09:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790095074; x=1790699874; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NB1J3hVZLGBcKEFzRbrkKSyu3nClV6Zj2pFFC1qb/tE=;
        b=lPws/qsGOoYh4/219DDEA0/vej3iCUQrAfknhREyEBTSh5gN5UpMtfPAxmgu0tQgBY
         RhHRFIZOXWKbc5eW+9QgHLd/1Aj57VheTSGT8CrhGaoby3QcJ2GqrcROVtT+2DOoJonG
         7R+3hWvOXTGOO9Xw0KGUt03mPdPl4S7dNaBgypZKrcoeq1zQqhI01+OY665MJsAgpJs7
         vl694IX6YsupWt6gUuoyiD/C2W2broI5lLIYpKzMvDCswbFb9sveivzHOOwxMwlFkUy6
         Z7nnH1jGlrcvEu9j5nX/rkanS/DJyez1cW1qhqaID4XPqp4ueAiZxXwgFUcIvQbsW0Ta
         1gJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790095074; x=1790699874;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NB1J3hVZLGBcKEFzRbrkKSyu3nClV6Zj2pFFC1qb/tE=;
        b=CoFLOXPFYOTi91Kzrwsf/P8iEk8s5FtqXYHCdjg7r19WFSZl29TqX7Du6oo/wyNOYm
         dxbC1ouhQmUJUqp1KnRIZeiSqklMUzd8qODC+8PikXhvv6s9ATZLbXNPgj+O6GtkOA9L
         JRYbCW5Sq3ApW3YmyXeWazUXpSKbdO6nbSHgMo9SS4nT81bqB9/F9W4sl5IjYgvUizJv
         Cf+4fx9R52kfTtgh8gS5zo6Hs9NNPCMt2PN0Rk0Cvk7KVU0G78c8JbypQhiI7RM43cmZ
         OMqkSzSodFV9B1xxMpHgjhck9eRWMWV9wvvOXjiEjD1pp5G40FfSvQ8kS95Ajn3+CuPt
         oZCw==
X-Forwarded-Encrypted: i=1; AKwUvBwDYfE6Q5ULgsps5RVN1Ge7i8ekQId/ad7wyKOTc6BRV+yR0IBStvfiXh7yAcBDoQa4Ccknjxg=@lists.linux.dev
X-Gm-Message-State: AFuF++nIoxPh7DQGa4tcIMIDZYj2293462tP5ydnbg9akCYhmndGB2s+
	qOTNG9M5IgDX3YtBsZz+XBO1viLCM3uH0/KgR23N28KCCf4QqoPQgIr6A0KVJoNrGg==
X-Gm-Gg: AYBFou0rCpyu0negoDp5gfGwpGpMnq9qKtqnuL2tiPXQP6D5U6Xy6v9LJ39EpDokCLC
	NtjwAKpcVTQfqZX0Van2RDMtHxLLR4TlSBdRjVoRArvYqB2L7/O5dOcVdWenghSQXx0xHJXgIpv
	e54iUqTPfdQSpTGEHlGRip+h6YiEXU/oHBVK3UkvOrWdifZM1xpGAClhVKa/oFX1S8oaZZqae+Q
	w99T9QrNz4uSGmKPoIkHLfq8mN2sKzMvpNjABlX9Ip30edxlgaauHyfdJDTssfEl78LPNk9BuLU
	dzpAUwlGvJR11MLzIFLlgUrxut23JJ27MKWdxli91TB80L0nYd3VVbR7lpHo1EaLsBU2hNrjpDY
	iae4EpLrvZiMINBTMZrk0YqFycfH1JQMMrElphlEpKEglMbg5oWN5wZhS51EUXKtbYINxM1u5DL
	QJccjGs0XEeNddIWayhU7omyjLHD0OYNeyVHx1v8THrZ+KiMfbvrJroG9cf7qXKQItmsZRkkKdM
	djwst75/1vEUYdObRM7AI2yFe1eA2eqk2O4wYeAJj0=
X-Received: by 2002:a05:600c:1989:b0:49c:e42b:a4ac with SMTP id 5b1f17b1804b1-49fc5714d14mr215915795e9.11.1790095073306;
        Tue, 22 Sep 2026 09:37:53 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde1ccb90sm2616575e9.6.2026.09.22.09.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 09:37:52 -0700 (PDT)
Date: Tue, 22 Sep 2026 17:37:49 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	mark.rutland@arm.com, steven.price@arm.com, qperret@google.com,
	tabba@google.com
Subject: Re: [PATCH v3 10/18] KVM: arm64: Handle PSCI calls for protected VMs
 at EL2
Message-ID: <arKu3SkgM9kftBEv@google.com>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
 <20260914113338.159227-11-fuad.tabba@linux.dev>
 <arKuPQ-w5EFXo-n8@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arKuPQ-w5EFXo-n8@google.com>

On Tue, Sep 22, 2026 at 05:35:09PM +0100, Vincent Donnefort wrote:
> On Mon, Sep 14, 2026 at 12:33:30PM +0100, Fuad Tabba wrote:
> > EL2 implements PSCI 1.1 for protected VMs: CPU_ON, CPU_OFF,
> > PSCI_VERSION and PSCI_FEATURES are decided at EL2 (CPU_ON and CPU_OFF
> > still exit to the host, which only schedules or parks the target),
> > AFFINITY_INFO, CPU_SUSPEND and the platform power operations are
> > forwarded to the host, and anything else returns NOT_SUPPORTED,
> > including the TRNG calls and the functions above 1.1, SYSTEM_OFF2
> > among them, that the host handled for a protected guest until now.
> > TRNG for protected guests is a follow-up. AFFINITY_INFO stays
> > with the host, which returns OFF only once it has parked the target:
> > the host is what a guest polls to see a CPU_OFF complete before it
> > issues the next CPU_ON, as Linux does on hotplug.
> > 
> > Three consequences follow:
> > 
> >   - A protected VM has one primary vCPU, the first whose hyp vCPU is
> >     created with mp_state RUNNABLE. A second one, or an mp_state other
> >     than RUNNABLE or STOPPED, fails that vCPU's first KVM_RUN with
> >     -EINVAL.
> > 
> >   - CPU_ON finds its target among the hyp vCPUs, which exist from the
> >     target's first KVM_RUN; before that the guest gets
> >     INVALID_PARAMETERS.
> > 
> >   - A vCPU EL2 holds powered off doesn't run: handle___kvm_vcpu_run()
> >     returns ARM_EXCEPTION_IL, reported as KVM_EXIT_FAIL_ENTRY. Its
> >     existing bail-outs return the same code instead of an -EINVAL that
> >     handle_exit() didn't recognise, for every hyp vCPU.
> > 
> > Non-protected VMs keep power_state ON and accept any mp_state.
> > 
> > Each protected vCPU is OFF, ON_PENDING or ON. CPU_ON moves the target
> > to ON_PENDING, and the target's next run resets it and moves it to ON.
> > The racing transitions are cmpxchg, and the reset state is published
> > with a release/acquire pair, documented at each site. CPU_OFF publishes
> > OFF with a release, so the target's clear of reset_state.reset is
> > ordered before it and a CPU_ON that then wins on OFF republishes after
> > the clear. Rolling a CPU_ON the host failed back to OFF needs the
> > host's return value, which the per-EC marshalling patch delivers along
> > with the rollback. Until then such a target stays ON_PENDING, and the
> > reset has no observable effect: flush_hyp_vcpu() copies the host's
> > context in on every entry until that patch removes the copy, so the
> > target enters on the host's values rather than the ones EL2 reset.
> > 
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  14 ++
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  25 ++-
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 283 ++++++++++++++++++++++++-
> >  3 files changed, 311 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > index a04b7c04d5135..63b368baf0e72 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > @@ -29,6 +29,12 @@ struct pkvm_hyp_vcpu {
> >  
> >  	/* The previous exit's ARM_EXCEPTION_* code. */
> >  	u32 exit_code;
> > +
> > +	/*
> > +	 * PSCI_0_2_AFFINITY_LEVEL_{OFF, ON_PENDING, ON}. A non-protected
> > +	 * vCPU is always ON.
> > +	 */
> > +	int power_state;
> >  };
> >  
> >  /*
> > @@ -46,6 +52,12 @@ struct pkvm_hyp_vm {
> >  	struct hyp_pool pool;
> >  	hyp_spinlock_t lock;
> >  
> > +	/*
> > +	 * The vCPU initialised RUNNABLE: claimed under vm_table_lock,
> > +	 * released only if its own init fails.
> > +	 */
> > +	struct pkvm_hyp_vcpu *primary_vcpu;
> > +
> >  	/* Array of the hyp vCPU structures for this VM. */
> >  	struct pkvm_hyp_vcpu *vcpus[];
> >  };
> > @@ -98,4 +110,6 @@ void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
> >  void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu);
> >  int kvm_check_pvm_sysreg_table(void);
> >  
> > +int pkvm_reset_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
> > +struct pkvm_hyp_vcpu *pkvm_mpidr_to_hyp_vcpu(struct pkvm_hyp_vm *vm, u64 mpidr);
> >  #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index 9cc8ef16897c1..da8ab636063cf 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -8,6 +8,7 @@
> >  #include <hyp/switch.h>
> >  
> >  #include <linux/irqchip/arm-gic-v3.h>
> > +#include <uapi/linux/psci.h>
> >  
> >  #include <asm/pgtable-types.h>
> >  #include <asm/kvm_asm.h>
> > @@ -456,14 +457,12 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
> >  {
> >  	struct pkvm_hyp_vcpu *hyp_vcpu;
> >  	struct kvm_vcpu *host_vcpu;
> > -	int ret;
> > +	int ret = ARM_EXCEPTION_IL;
> >  
> >  	host_vcpu = get_host_hyp_vcpus(host_ctxt, 1, &hyp_vcpu);
> >  
> > -	if (!host_vcpu) {
> > -		ret = -EINVAL;
> > +	if (!host_vcpu)
> >  		goto out;
> > -	}
> >  
> >  	if (unlikely(hyp_vcpu)) {
> >  		/*
> > @@ -472,8 +471,22 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
> >  		 * loading a vcpu. Therefore, if SME features enabled the host
> >  		 * is misbehaving.
> >  		 */
> > -		if (unlikely(system_supports_sme() && read_sysreg_s(SYS_SVCR))) {
> > -			ret = -EINVAL;
> > +		if (unlikely(system_supports_sme() && read_sysreg_s(SYS_SVCR)))
> > +			goto out;
> > +
> > +		/*
> > +		 * ON has a single writer, pkvm_reset_vcpu() on this CPU, so
> > +		 * READ_ONCE suffices. ON_PENDING takes the reset; -ECANCELED
> > +		 * is a rollback that raced it.
> > +		 */
> > +		switch (READ_ONCE(hyp_vcpu->power_state)) {
> > +		case PSCI_0_2_AFFINITY_LEVEL_ON:
> > +			break;
> > +		case PSCI_0_2_AFFINITY_LEVEL_ON_PENDING:
> > +			if (pkvm_reset_vcpu(hyp_vcpu))
> > +				goto out;
> > +			break;
> > +		default:
> >  			goto out;
> >  		}
> >  
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index 855cb77c8bba1..d970cba12ca47 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -5,6 +5,7 @@
> >   */
> >  
> >  #include <kvm/arm_hypercalls.h>
> > +#include <kvm/arm_psci.h>
> >  
> >  #include <linux/kvm_host.h>
> >  #include <linux/mm.h>
> > @@ -433,6 +434,40 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
> >  		   allowed_features, KVM_VCPU_MAX_FEATURES);
> >  }
> >  
> > +static int pkvm_vcpu_init_psci(struct pkvm_hyp_vcpu *hyp_vcpu, u32 mp_state)
> > +{
> > +	struct vcpu_reset_state *reset_state = &hyp_vcpu->vcpu.arch.reset_state;
> > +	struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
> > +	struct kvm_vcpu *host_vcpu;
> > +
> > +	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> > +		/* The host manages a non-protected vCPU: always ON at EL2. */
> > +		hyp_vcpu->power_state = PSCI_0_2_AFFINITY_LEVEL_ON;
> > +		return 0;
> > +	}
> > +
> > +	if (mp_state != KVM_MP_STATE_RUNNABLE && mp_state != KVM_MP_STATE_STOPPED)
> > +		return -EINVAL;
> > +
> > +	if (mp_state == KVM_MP_STATE_STOPPED) {
> > +		reset_state->reset = false;
> > +		hyp_vcpu->power_state = PSCI_0_2_AFFINITY_LEVEL_OFF;
> > +		return 0;
> > +	}
> > +
> > +	hyp_assert_lock_held(&vm_table_lock);
> > +	if (hyp_vm->primary_vcpu)
> > +		return -EINVAL;
> > +	hyp_vm->primary_vcpu = hyp_vcpu;
> > +
> > +	host_vcpu = hyp_vcpu->host_vcpu;
> > +	reset_state->pc = READ_ONCE(host_vcpu->arch.ctxt.regs.pc);
> > +	reset_state->r0 = READ_ONCE(host_vcpu->arch.ctxt.regs.regs[0]);
> > +	reset_state->reset = true;
> > +	hyp_vcpu->power_state = PSCI_0_2_AFFINITY_LEVEL_ON_PENDING;
> > +	return 0;
> > +}
> > +
> >  static void unpin_host_vcpu(struct kvm_vcpu *host_vcpu)
> >  {
> >  	if (host_vcpu)
> > @@ -447,6 +482,9 @@ static void unpin_host_sve_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> >  		return;
> >  
> >  	sve_state = hyp_vcpu->vcpu.arch.sve_state;
> > +	if (!sve_state)
> > +		return;
> > +
> >  	hyp_unpin_shared_mem(sve_state,
> >  			     sve_state + vcpu_sve_state_size(&hyp_vcpu->vcpu));
> >  }
> > @@ -559,10 +597,12 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
> >  			      struct kvm_vcpu *host_vcpu)
> >  {
> >  	int ret = 0;
> > +	u32 mp_state;
> >  
> >  	if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
> >  		return -EBUSY;
> >  
> > +	mp_state = READ_ONCE(host_vcpu->arch.mp_state.mp_state);
> >  	hyp_vcpu->host_vcpu = host_vcpu;
> >  
> >  	hyp_vcpu->vcpu.kvm = &hyp_vm->kvm;
> > @@ -571,7 +611,6 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
> >  
> >  	hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
> >  	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
> > -	hyp_vcpu->vcpu.arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
> >  
> >  	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> >  		/*
> > @@ -601,9 +640,12 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
> >  
> >  	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> >  		kvm_reset_pvm_sys_regs(&hyp_vcpu->vcpu);
> > +	ret = pkvm_vcpu_init_psci(hyp_vcpu, mp_state);
> >  done:
> > -	if (ret)
> > +	if (ret) {
> >  		unpin_host_vcpu(host_vcpu);
> > +		unpin_host_sve_state(hyp_vcpu);
> > +	}
> 
> Was it planned for a different commit of the series?

Ha no it wasn't, you're calling unpin_host_sve_state() unconditionally. 

> 
> >  	return ret;
> >  }
> >

[...]
