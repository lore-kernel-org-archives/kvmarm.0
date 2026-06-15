Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB53B29A9E9
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 16:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781540728; cv=none; b=Zmr8GZGXVLMXSgwkMPtYtI0LNDxEkRQitrtC2iXL6mT9PDerid7oA8PwjU34ed0YiIH/4JlFPx6esaJkAQ3Q2WBa9ur7WCpTmT32AsHZqnhA68O+WSDdvE//vz4KHGKsUHkVVbBMrio+uT6M7e2T5Jn6e8Ws3Hl6u0SRQo3wfWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781540728; c=relaxed/simple;
	bh=L9Z4wU6h0DLGk7Icahn6XdXKEzGYw11kKPOoCxgp7bM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKD4UuAKDFkkw1KA/4UPa6mvLAyWvoMznJKVg8QSfeIrvzfEz2SgMZwUjsZP0dTnOQ90QYnmA1AcDFhrwemXNLqq8nfircs+n30TubomKvUn8Htn27Jn6fMDg9dKTJW97klIe5RYqV+thTPYZ5kw2swtqWCRCPeQt6AnhuDBnpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o1Favsu0; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o1Favsu0"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490b613a17bso32474335e9.3
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 09:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781540725; x=1782145525; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+hEU/mEFDrh3dSsoqaYUHBuwISR49/xEjyPfvReMD4U=;
        b=o1Favsu0jps6JCcqHMopMTNXYZ3SdUj0t/QiVf0K3cGSUw4AE1BAivCn8rRppqkFvG
         ATOo4D3PP0j2FPDXI3gxWQI5ehGJzVVs7RxblFo+llgOZgF44uYZU7z7VNCmBgdvC5Xo
         9c0TQ+ckcIVzTlOkY1N/FZ8AOqBf6iGWcv3X8Y2DIY5f2l4oGNjFAMJft5JSDe4PL2kx
         NNIDUAe5PvxftzpVhpOm9rb4n+pilTFOsdYQmrb//5ox/sQykSYODByy+bFtJ6D7fDpy
         vdQ+aeys5PfOA0NsrzlWFUeM+6f9b4JmqJDynUjPP9+QJb7ydFQbSRk5lnL1BZ3N8EfO
         8qqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781540725; x=1782145525;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+hEU/mEFDrh3dSsoqaYUHBuwISR49/xEjyPfvReMD4U=;
        b=IcAuyGl3eVQo/dDETiDqbNG+G3b/dQn8zuDkwlznMQ8B93EnNbATP1Y0EiaEeYun6l
         O3zG5+eHcASzERhHs6f7coKIVEaaIssHJ7urEjkkOD+NlMcxGuj0ldmSs3ONrx5Q3NYX
         D01r4rCScEis/FIsrWQIX8dW8tcVsp98C1klLGftkg2ulnqhVi5LD9ugVhGhs0qZmjYm
         5DvORNUEYDIzJUCds6PnKQPADA2IhMqSniNPMrnjiaFJKrhDlCBUWpfwjy1riUX2IpDV
         5vs90PD8s+J3PDelNj0SaCM79QGIKzEaAb4gzsdE5WwUqNeNABbNnXBxKzooluPN5JVb
         Gj+A==
X-Forwarded-Encrypted: i=1; AFNElJ+h2SUW5puzACOIWNnEaMOBAt6N5E6l0SMIs+5KjXlhN3jjVKk4Q6VRXR49Q2kywlAxlywtKjo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxOOWugfnl5gGBJXYl5IGmlNZzbI/anu99PMfMzz86BNjoEY5yr
	ENAsU2fI8Jjz2aF++g4bsJADdjax64S0PSd5WMJbi9ohB7PRMtP6RWRECSgC/x5UOA==
X-Gm-Gg: Acq92OGtQdvrxISiDK7oxOSpHIZYBeNb4IFjObRnJx6W6nLq9ZTuDdo+We9OoZ4JwJc
	zEP/5ZYVq09W8inZHKdGIe6pES1skU9EblpqPyD+MoGJo8Y9SDG/wOCzavPnHDznEVXsUGNOJnq
	WU90RGEaFC2s9xV4vL5LaDU3dgv7vmRoOZ0B8KNNEnNRyXdI+uwUQXxhIRfPdbYtMyMPnL/BwXJ
	TX4iIUJdzdakptMRe/h67wn5qcjuW+HtKhpTPM0YR+Zj+SQfs8jac8W5hdTxsMoCkuHrvXNJTYj
	G3ry+HBiAJiuKkyqLh25dm30i2Vuv6brR3R6DunX2zWthdcgvhNAAN6bKfaiFUY7gitw7v5usM0
	UwPLqjBe59lN+VO7o7s5qDm+/c1TCDlWfPup0v6nwRG+dV2V+H+FtPFW8HRqc9+WA5ffaqHwmlT
	jguyLgWEBiidBt7TspPmIKE1xOBjfx4ReyWgSSyuYeZtS1LE+mvupYZzVGgaQcpgK4u0kLlKcz3
	JRd8g==
X-Received: by 2002:a05:600d:8492:b0:490:4973:91a0 with SMTP id 5b1f17b1804b1-490ec4d728dmr134122765e9.10.1781540724614;
        Mon, 15 Jun 2026 09:25:24 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa891acsm3867895e9.9.2026.06.15.09.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 09:25:23 -0700 (PDT)
Date: Mon, 15 Jun 2026 17:25:20 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: tabba@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Per Larsen <perlarsen@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 11/11] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
Message-ID: <ajAncPp3nOGcWD1U@google.com>
References: <20260612065925.755562-1-tabba@google.com>
 <20260612065925.755562-12-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612065925.755562-12-tabba@google.com>

On Fri, Jun 12, 2026 at 07:59:25AM +0100, tabba@google.com wrote:
> pKVM copies a non-protected guest's register context between the host
> and the hypervisor on every world switch, even when the host never
> inspects it. Defer the copy: on entry, flush the host context into the
> hyp vCPU only when the host marked it dirty (PKVM_HOST_STATE_DIRTY); on
> exit, leave it in the hyp vCPU and copy it back only when the host needs
> it, via a __pkvm_vcpu_sync_state hypercall on trap handling or at vcpu
> put. A protected guest's context is copied as before, since lazy sync
> only helps where the host is trusted to see the guest's registers.
> 
> The PC is the exception: it is copied back on every exit so the
> kvm_exit tracepoint reports the guest's real exit PC rather than the
> value left by the previous sync.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h   |  1 +
>  arch/arm64/include/asm/kvm_host.h  |  2 +
>  arch/arm64/kvm/arm.c               |  7 +++
>  arch/arm64/kvm/handle_exit.c       | 22 ++++++++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 88 ++++++++++++++++++++++++++++--
>  5 files changed, 115 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 043495f7fc78..6e1135b3ded4 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -113,6 +113,7 @@ enum __kvm_host_smccc_func {
>  	__KVM_HOST_SMCCC_FUNC___pkvm_finalize_teardown_vm,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
> +	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_sync_state,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
>  
>  	MARKER(__KVM_HOST_SMCCC_FUNC_MAX)
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a49042bfa801..1ef660774adc 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1113,6 +1113,8 @@ struct kvm_vcpu_arch {
>  /* SError pending for nested guest */
>  #define NESTED_SERROR_PENDING	__vcpu_single_flag(sflags, BIT(8))
>  
> +/* pKVM host vcpu state is dirty, needs resync (nVHE-only) */

nit: with hVHE, I guess we can just drop that nVHE-only? 

> +#define PKVM_HOST_STATE_DIRTY	__vcpu_single_flag(iflags, BIT(4))
>  
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>  #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c9f36932c980..a5c54e37778b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -734,6 +734,10 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	if (is_protected_kvm_enabled()) {
>  		kvm_call_hyp(__vgic_v3_save_aprs, &vcpu->arch.vgic_cpu.vgic_v3);
>  		kvm_call_hyp_nvhe(__pkvm_vcpu_put);
> +
> +		/* __pkvm_vcpu_put implies a sync of the state */
> +		if (!kvm_vm_is_protected(vcpu->kvm))
> +			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
>  	}
>  
>  	kvm_vcpu_put_debug(vcpu);
> @@ -961,6 +965,9 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  		return ret;
>  
>  	if (is_protected_kvm_enabled()) {
> +		/* Start with the vcpu in a dirty state */
> +		if (!kvm_vm_is_protected(vcpu->kvm))
> +			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
>  		ret = pkvm_create_hyp_vm(kvm);
>  		if (ret)
>  			return ret;
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 54aedf93c78b..dccc3786548b 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -422,6 +422,21 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu)
>  {
>  	int handled;
>  
> +	/*
> +	 * If we run a non-protected VM when protection is enabled
> +	 * system-wide, resync the state from the hypervisor and mark
> +	 * it as dirty on the host side if it wasn't dirty already
> +	 * (which could happen if preemption has taken place).
> +	 */
> +	if (is_protected_kvm_enabled() && !kvm_vm_is_protected(vcpu->kvm)) {
> +		preempt_disable();

nit: since we are introducing guard() with that series, this one could be
guard(preempt)().

> +		if (!(vcpu_get_flag(vcpu, PKVM_HOST_STATE_DIRTY))) {
> +			kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> +			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> +		}
> +		preempt_enable();
> +	}
> +
>  	/*
>  	 * See ARM ARM B1.14.1: "Hyp traps on instructions
>  	 * that fail their condition code check"
> @@ -489,6 +504,13 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
>  /* For exit types that need handling before we can be preempted */
>  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
>  {
> +	/*
> +	 * We just exited, so the state is clean from a hypervisor
> +	 * perspective.
> +	 */
> +	if (is_protected_kvm_enabled())
> +		vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> +
>  	if (ARM_SERROR_PENDING(exception_index)) {
>  		if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
>  			u64 disr = kvm_vcpu_get_disr(vcpu);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 23e644c24a03..02383b372258 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -139,6 +139,49 @@ static void sync_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
>  		host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
>  }
>  
> +
> +static void __copy_vcpu_state(const struct kvm_vcpu *from_vcpu,
> +			      struct kvm_vcpu *to_vcpu)
> +{
> +	int i;
> +
> +	to_vcpu->arch.ctxt.regs		= from_vcpu->arch.ctxt.regs;
> +	to_vcpu->arch.ctxt.spsr_abt	= from_vcpu->arch.ctxt.spsr_abt;
> +	to_vcpu->arch.ctxt.spsr_und	= from_vcpu->arch.ctxt.spsr_und;
> +	to_vcpu->arch.ctxt.spsr_irq	= from_vcpu->arch.ctxt.spsr_irq;
> +	to_vcpu->arch.ctxt.spsr_fiq	= from_vcpu->arch.ctxt.spsr_fiq;
> +	to_vcpu->arch.ctxt.fp_regs	= from_vcpu->arch.ctxt.fp_regs;
> +
> +	/*
> +	 * Copy the sysregs, but don't mess with the timer state which
> +	 * is directly handled by EL1 and is expected to be preserved.
> +	 * enum vcpu_sysreg is sparse: VNCR-mapped registers take values
> +	 * derived from their VNCR page offset, so the timer registers do
> +	 * not form a contiguous numeric range and must be skipped by name.
> +	 */
> +	for (i = 1; i < NR_SYS_REGS; i++) {
> +		switch (i) {
> +		case CNTVOFF_EL2:
> +		case CNTV_CVAL_EL0:
> +		case CNTV_CTL_EL0:
> +		case CNTP_CVAL_EL0:
> +		case CNTP_CTL_EL0:
> +			continue;
> +		}
> +		to_vcpu->arch.ctxt.sys_regs[i] = from_vcpu->arch.ctxt.sys_regs[i];
> +	}
> +}
> +
> +static void __sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	__copy_vcpu_state(&hyp_vcpu->vcpu, hyp_vcpu->host_vcpu);
> +}
> +
> +static void __flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	__copy_vcpu_state(hyp_vcpu->host_vcpu, &hyp_vcpu->vcpu);
> +}

nit: Could that be flush/sync_hyp_vcpu_state? as everything this is called
"state" and we already have flush_debug_state() below ?

> +
>  static void flush_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
>  {
>  	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> @@ -168,7 +211,17 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>  	fpsimd_sve_flush();
>  	flush_debug_state(hyp_vcpu);
>  
> -	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
> +	/*
> +	 * If we deal with a non-protected guest and the state is potentially
> +	 * dirty (from a host perspective), copy the state back into the hyp
> +	 * vcpu.
> +	 */
> +	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> +		if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
> +			__flush_hyp_vcpu(hyp_vcpu);
> +	} else {
> +		hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;
> +	}
>  
>  	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
>  	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
> @@ -191,9 +244,11 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>  	fpsimd_sve_sync(&hyp_vcpu->vcpu);
>  	sync_debug_state(hyp_vcpu);
>  
> -	host_vcpu->arch.ctxt		= hyp_vcpu->vcpu.arch.ctxt;
> -
> -	host_vcpu->arch.hcr_el2		= hyp_vcpu->vcpu.arch.hcr_el2;
> +	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> +		host_vcpu->arch.ctxt = hyp_vcpu->vcpu.arch.ctxt;
> +	else
> +		/* Keep the PC current for the kvm_exit tracepoint (lazy ctxt sync). */
> +		host_vcpu->arch.ctxt.regs.pc = hyp_vcpu->vcpu.arch.ctxt.regs.pc;
>  
>  	host_vcpu->arch.fault		= hyp_vcpu->vcpu.arch.fault;
>  
> @@ -227,8 +282,30 @@ static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
>  {
>  	struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
>  
> -	if (hyp_vcpu)
> +	if (hyp_vcpu) {
> +		struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> +
> +		if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu) &&
> +		    !vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY)) {
> +			__sync_hyp_vcpu(hyp_vcpu);
> +		}
> +
>  		pkvm_put_hyp_vcpu(hyp_vcpu);
> +	}
> +}
> +
> +static void handle___pkvm_vcpu_sync_state(struct kvm_cpu_context *host_ctxt)
> +{
> +	struct pkvm_hyp_vcpu *hyp_vcpu;
> +
> +	if (!is_protected_kvm_enabled())
> +		return;

Since "KVM: arm64: Remove is_protected_kvm_enabled() checks from hypercalls" we
got rid of those is_protected_kvm_enabled() for pKVM-only HVCs. (also, it is
declared in the pKVM-only section of the HVCs)

> +
> +	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
> +	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> +		return;
> +
> +	__sync_hyp_vcpu(hyp_vcpu);
>  }
>  
>  static struct kvm_vcpu *__get_host_hyp_vcpus(struct kvm_vcpu *arg,
> @@ -859,6 +936,7 @@ static const hcall_t host_hcall[] = {
>  	HANDLE_FUNC(__pkvm_finalize_teardown_vm),
>  	HANDLE_FUNC(__pkvm_vcpu_load),
>  	HANDLE_FUNC(__pkvm_vcpu_put),
> +	HANDLE_FUNC(__pkvm_vcpu_sync_state),
>  	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
>  };
>  
> -- 
> 2.54.0.1136.gdb2ca164c4-goog
> 
