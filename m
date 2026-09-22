Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEDE55C30D
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 16:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790094919; cv=none; b=TIkTZ8GcsMdshrcILatMi6vUklXvHfAObbzpfKPt0BhrFBQruyJ/za/2YUMSGMIOAPD1NaG7vaMoKPvDRAR5WqComn874rTsjckToxDokNV+ukNrQCYt1js7y7tqcUz12l1k/fTP4ZUYMkDRlclEb0DnhE3QnJsz8riI3ql9C5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790094919; c=relaxed/simple;
	bh=c9yzKE7ZGqXcQnqh+NhuAGAZHnXQUR4wRrWVlZsRPuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lEZBwUlXSFChojZ+GiJsAodBKsZClydMup9zEG6p0hBMpl401AXh5b+9OVN75PPpu8neJoGD6uidQ0Rxnancm3CPBnIMhlGoPJGfgSVeLrTu89MCroSZeYfa5iX4/i2YhhS746QTi/wiK+l1t7s8opFNc2Qt0Cgu0y3o7ZxurcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ps4OZvCl; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ps4OZvCl"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d3920so30002215e9.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 09:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790094914; x=1790699714; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oSRA2tiOFkeqVhp/xadUSBnBtNnq4vAB5RnHAgObzUo=;
        b=Ps4OZvClghKQc++ntPKi/RKKtbQnSkIDmlNetrgSPMC9r+2uacS5uJrVnpRBYm5WbA
         oHIiSF6ey00VZhv7hsiX2AKFRAQefi4cgktIGvyOMUXJjZ91HRj38ic1tlS981xihznH
         Ij80KtDFlyN0IxN9bEjyX+XAPLXA8bUe6oDfUBYmrcmnI2dZbGP38VTP+g88rcbj6F/2
         2TOeLCp9OsHg/HNWjict2xIMWN9IfM5vSJxGeQ5Wz+QJZUhPBYaLrujHX4S1esn+8NJI
         Eu78cssRLSKKB4DHnKLS12rDMF5NXj+EGhlil7YIF7Wd/1fGlcl5iNWMLL+DcVxe88DX
         Lo/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790094914; x=1790699714;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oSRA2tiOFkeqVhp/xadUSBnBtNnq4vAB5RnHAgObzUo=;
        b=lGeFAskGqXioYjkrUm/txv1aGtXnoSx5F+0UClLDEoPBI+CrazhYnQOj+y5zou8yO5
         wkBVQzlLq1dKm2vJlyF/Pn3rxwUnSuZdNneB0BntLIxyL/9CdQp731SUNe2toMdludwJ
         DnfCtwtgGvnUWK5KfRMQ2ViSbnACHE4VzPPYd2FSeL4xnSriQDIq2y8drgEj+SEgN1wK
         8dEW7PkQjsKWJnAXdSJ/aUXjdAHBfqEEHF0gzNrprs2l1iUW3+f3XNZrOZEPYwVe0nEf
         MdvQwhggOjO2HFnDNGVs57It9gC7oQUmewZfOlSeWhe/Gn4ZxO/xoIjNHeNoGgN9o0qX
         7x1g==
X-Forwarded-Encrypted: i=1; AKwUvByzBNH/3t5cVvp73ONaMNKXkc93WycpNw2TXVsnyqLNB3+VCdb1YQyYK7qQkk/vl5uqvLxd5xM=@lists.linux.dev
X-Gm-Message-State: AFuF++kMc81t1k2sLETBUE7CQfHYyqUX4Rnx3bH9v5g3m2Ceb8U3d/RB
	KBoc84GPj99WQR62+qtL80VWBdY9con5JNgqoJfBvaIsZLzFo9VaMr5xVQtMshf0D89qR0L1A4+
	G9QAUQA==
X-Gm-Gg: AYBFou3Yb5Ithq+dVeRb4KxcJ0Q6RIYEOZyKcXA2k7WpHEMYfhTR1P7JEUnW/WDKnlK
	lhDI5+JdZDQ4a21iUMxoBU8k2A/XkN7N4r0wy3iq0AcPzUJxoskJ+ebWDY0cduVeywdM60XoDuX
	1z0H3P8a2EEu5Yfs0Okc9UlH6/MEi863bFDzyi6TI3eWRtuczGUCIoy0lEormjnZbKvbpcfBwpz
	xPzLn6FysYG9JRE1n05vh5L/bTNgF4AEy8/AISNew0Qvp7t90ladQOtZ4ZXvVoKJFa0Mi3q+h+1
	mR/IC87JLDcb1bpmY+LPm1llgG8b9d0+r0JvkyNG41l9OaqgReQF15mm8iveyvpSAvPKEgoSXLF
	DS0h25Z/Ch2etMnoyafsIEPyiJuCNtiKmUAjuRTSq3C2QYqygz1k6N2kImMVjTdNF0z4EzjRW6p
	zf4rK5N0aikdbtlyUT1yIq7D7TA2Cxleo7I++9WEraMmnj45Yl3ILboKd6gUiexTyo5LzMz3/CW
	EnLyiEnxy//ZtMIRmNI7ZswDt77HB+2etjrmxDYOPY=
X-Received: by 2002:a05:600c:3115:b0:499:8ff5:8ecc with SMTP id 5b1f17b1804b1-49fddebbe85mr6137545e9.15.1790094913553;
        Tue, 22 Sep 2026 09:35:13 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde18af34sm2725245e9.6.2026.09.22.09.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 09:35:12 -0700 (PDT)
Date: Tue, 22 Sep 2026 17:35:09 +0100
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
Message-ID: <arKuPQ-w5EFXo-n8@google.com>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
 <20260914113338.159227-11-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914113338.159227-11-fuad.tabba@linux.dev>

On Mon, Sep 14, 2026 at 12:33:30PM +0100, Fuad Tabba wrote:
> EL2 implements PSCI 1.1 for protected VMs: CPU_ON, CPU_OFF,
> PSCI_VERSION and PSCI_FEATURES are decided at EL2 (CPU_ON and CPU_OFF
> still exit to the host, which only schedules or parks the target),
> AFFINITY_INFO, CPU_SUSPEND and the platform power operations are
> forwarded to the host, and anything else returns NOT_SUPPORTED,
> including the TRNG calls and the functions above 1.1, SYSTEM_OFF2
> among them, that the host handled for a protected guest until now.
> TRNG for protected guests is a follow-up. AFFINITY_INFO stays
> with the host, which returns OFF only once it has parked the target:
> the host is what a guest polls to see a CPU_OFF complete before it
> issues the next CPU_ON, as Linux does on hotplug.
> 
> Three consequences follow:
> 
>   - A protected VM has one primary vCPU, the first whose hyp vCPU is
>     created with mp_state RUNNABLE. A second one, or an mp_state other
>     than RUNNABLE or STOPPED, fails that vCPU's first KVM_RUN with
>     -EINVAL.
> 
>   - CPU_ON finds its target among the hyp vCPUs, which exist from the
>     target's first KVM_RUN; before that the guest gets
>     INVALID_PARAMETERS.
> 
>   - A vCPU EL2 holds powered off doesn't run: handle___kvm_vcpu_run()
>     returns ARM_EXCEPTION_IL, reported as KVM_EXIT_FAIL_ENTRY. Its
>     existing bail-outs return the same code instead of an -EINVAL that
>     handle_exit() didn't recognise, for every hyp vCPU.
> 
> Non-protected VMs keep power_state ON and accept any mp_state.
> 
> Each protected vCPU is OFF, ON_PENDING or ON. CPU_ON moves the target
> to ON_PENDING, and the target's next run resets it and moves it to ON.
> The racing transitions are cmpxchg, and the reset state is published
> with a release/acquire pair, documented at each site. CPU_OFF publishes
> OFF with a release, so the target's clear of reset_state.reset is
> ordered before it and a CPU_ON that then wins on OFF republishes after
> the clear. Rolling a CPU_ON the host failed back to OFF needs the
> host's return value, which the per-EC marshalling patch delivers along
> with the rollback. Until then such a target stays ON_PENDING, and the
> reset has no observable effect: flush_hyp_vcpu() copies the host's
> context in on every entry until that patch removes the copy, so the
> target enters on the host's values rather than the ones EL2 reset.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  14 ++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  25 ++-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 283 ++++++++++++++++++++++++-
>  3 files changed, 311 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index a04b7c04d5135..63b368baf0e72 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -29,6 +29,12 @@ struct pkvm_hyp_vcpu {
>  
>  	/* The previous exit's ARM_EXCEPTION_* code. */
>  	u32 exit_code;
> +
> +	/*
> +	 * PSCI_0_2_AFFINITY_LEVEL_{OFF, ON_PENDING, ON}. A non-protected
> +	 * vCPU is always ON.
> +	 */
> +	int power_state;
>  };
>  
>  /*
> @@ -46,6 +52,12 @@ struct pkvm_hyp_vm {
>  	struct hyp_pool pool;
>  	hyp_spinlock_t lock;
>  
> +	/*
> +	 * The vCPU initialised RUNNABLE: claimed under vm_table_lock,
> +	 * released only if its own init fails.
> +	 */
> +	struct pkvm_hyp_vcpu *primary_vcpu;
> +
>  	/* Array of the hyp vCPU structures for this VM. */
>  	struct pkvm_hyp_vcpu *vcpus[];
>  };
> @@ -98,4 +110,6 @@ void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
>  void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu);
>  int kvm_check_pvm_sysreg_table(void);
>  
> +int pkvm_reset_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
> +struct pkvm_hyp_vcpu *pkvm_mpidr_to_hyp_vcpu(struct pkvm_hyp_vm *vm, u64 mpidr);
>  #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 9cc8ef16897c1..da8ab636063cf 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -8,6 +8,7 @@
>  #include <hyp/switch.h>
>  
>  #include <linux/irqchip/arm-gic-v3.h>
> +#include <uapi/linux/psci.h>
>  
>  #include <asm/pgtable-types.h>
>  #include <asm/kvm_asm.h>
> @@ -456,14 +457,12 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
>  {
>  	struct pkvm_hyp_vcpu *hyp_vcpu;
>  	struct kvm_vcpu *host_vcpu;
> -	int ret;
> +	int ret = ARM_EXCEPTION_IL;
>  
>  	host_vcpu = get_host_hyp_vcpus(host_ctxt, 1, &hyp_vcpu);
>  
> -	if (!host_vcpu) {
> -		ret = -EINVAL;
> +	if (!host_vcpu)
>  		goto out;
> -	}
>  
>  	if (unlikely(hyp_vcpu)) {
>  		/*
> @@ -472,8 +471,22 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
>  		 * loading a vcpu. Therefore, if SME features enabled the host
>  		 * is misbehaving.
>  		 */
> -		if (unlikely(system_supports_sme() && read_sysreg_s(SYS_SVCR))) {
> -			ret = -EINVAL;
> +		if (unlikely(system_supports_sme() && read_sysreg_s(SYS_SVCR)))
> +			goto out;
> +
> +		/*
> +		 * ON has a single writer, pkvm_reset_vcpu() on this CPU, so
> +		 * READ_ONCE suffices. ON_PENDING takes the reset; -ECANCELED
> +		 * is a rollback that raced it.
> +		 */
> +		switch (READ_ONCE(hyp_vcpu->power_state)) {
> +		case PSCI_0_2_AFFINITY_LEVEL_ON:
> +			break;
> +		case PSCI_0_2_AFFINITY_LEVEL_ON_PENDING:
> +			if (pkvm_reset_vcpu(hyp_vcpu))
> +				goto out;
> +			break;
> +		default:
>  			goto out;
>  		}
>  
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 855cb77c8bba1..d970cba12ca47 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -5,6 +5,7 @@
>   */
>  
>  #include <kvm/arm_hypercalls.h>
> +#include <kvm/arm_psci.h>
>  
>  #include <linux/kvm_host.h>
>  #include <linux/mm.h>
> @@ -433,6 +434,40 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
>  		   allowed_features, KVM_VCPU_MAX_FEATURES);
>  }
>  
> +static int pkvm_vcpu_init_psci(struct pkvm_hyp_vcpu *hyp_vcpu, u32 mp_state)
> +{
> +	struct vcpu_reset_state *reset_state = &hyp_vcpu->vcpu.arch.reset_state;
> +	struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
> +	struct kvm_vcpu *host_vcpu;
> +
> +	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> +		/* The host manages a non-protected vCPU: always ON at EL2. */
> +		hyp_vcpu->power_state = PSCI_0_2_AFFINITY_LEVEL_ON;
> +		return 0;
> +	}
> +
> +	if (mp_state != KVM_MP_STATE_RUNNABLE && mp_state != KVM_MP_STATE_STOPPED)
> +		return -EINVAL;
> +
> +	if (mp_state == KVM_MP_STATE_STOPPED) {
> +		reset_state->reset = false;
> +		hyp_vcpu->power_state = PSCI_0_2_AFFINITY_LEVEL_OFF;
> +		return 0;
> +	}
> +
> +	hyp_assert_lock_held(&vm_table_lock);
> +	if (hyp_vm->primary_vcpu)
> +		return -EINVAL;
> +	hyp_vm->primary_vcpu = hyp_vcpu;
> +
> +	host_vcpu = hyp_vcpu->host_vcpu;
> +	reset_state->pc = READ_ONCE(host_vcpu->arch.ctxt.regs.pc);
> +	reset_state->r0 = READ_ONCE(host_vcpu->arch.ctxt.regs.regs[0]);
> +	reset_state->reset = true;
> +	hyp_vcpu->power_state = PSCI_0_2_AFFINITY_LEVEL_ON_PENDING;
> +	return 0;
> +}
> +
>  static void unpin_host_vcpu(struct kvm_vcpu *host_vcpu)
>  {
>  	if (host_vcpu)
> @@ -447,6 +482,9 @@ static void unpin_host_sve_state(struct pkvm_hyp_vcpu *hyp_vcpu)
>  		return;
>  
>  	sve_state = hyp_vcpu->vcpu.arch.sve_state;
> +	if (!sve_state)
> +		return;
> +
>  	hyp_unpin_shared_mem(sve_state,
>  			     sve_state + vcpu_sve_state_size(&hyp_vcpu->vcpu));
>  }
> @@ -559,10 +597,12 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
>  			      struct kvm_vcpu *host_vcpu)
>  {
>  	int ret = 0;
> +	u32 mp_state;
>  
>  	if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
>  		return -EBUSY;
>  
> +	mp_state = READ_ONCE(host_vcpu->arch.mp_state.mp_state);
>  	hyp_vcpu->host_vcpu = host_vcpu;
>  
>  	hyp_vcpu->vcpu.kvm = &hyp_vm->kvm;
> @@ -571,7 +611,6 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
>  
>  	hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
>  	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
> -	hyp_vcpu->vcpu.arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
>  
>  	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
>  		/*
> @@ -601,9 +640,12 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
>  
>  	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
>  		kvm_reset_pvm_sys_regs(&hyp_vcpu->vcpu);
> +	ret = pkvm_vcpu_init_psci(hyp_vcpu, mp_state);
>  done:
> -	if (ret)
> +	if (ret) {
>  		unpin_host_vcpu(host_vcpu);
> +		unpin_host_sve_state(hyp_vcpu);
> +	}

Was it planned for a different commit of the series?

>  	return ret;
>  }
>  
> @@ -980,13 +1022,22 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
>  
>  	ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu);
>  	if (ret)
> -		goto unlock;
> +		goto unclaim;
>  
>  	ret = register_hyp_vcpu(hyp_vm, hyp_vcpu);
>  	if (ret) {
>  		unpin_host_vcpu(host_vcpu);
>  		unpin_host_sve_state(hyp_vcpu);
> +		goto unclaim;
>  	}
> +	goto unlock;
> +unclaim:
> +	/*
> +	 * Under vm_table_lock, so no other claim can have landed: undo
> +	 * this one.
> +	 */
> +	if (hyp_vm->primary_vcpu == hyp_vcpu)
> +		hyp_vm->primary_vcpu = NULL;
>  unlock:
>  	hyp_spin_unlock(&vm_table_lock);
>  
> @@ -1178,6 +1229,228 @@ static void pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu)
>  		ret[0] = SMCCC_RET_SUCCESS;
>  }
>  
> +/*
> + * Reset the vCPU to its power-on state and commit ON_PENDING -> ON, on the
> + * target's own CPU. Returns -ECANCELED, with no side effects, if a rollback
> + * raced the reset.
> + */
> +int pkvm_reset_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	struct vcpu_reset_state *reset_state = &hyp_vcpu->vcpu.arch.reset_state;
> +	int prev;
> +
> +	/*
> +	 * Pairs with smp_store_release(&reset_state->reset, true) in
> +	 * pvm_psci_vcpu_on(). The acquire must precede the cmpxchg: reversed, a
> +	 * winning cmpxchg with a false acquire would leave power_state == ON
> +	 * with the reset skipped.
> +	 */
> +	if (!smp_load_acquire(&reset_state->reset))
> +		return -ECANCELED;
> +
> +	prev = cmpxchg_relaxed(&hyp_vcpu->power_state,
> +			       PSCI_0_2_AFFINITY_LEVEL_ON_PENDING,
> +			       PSCI_0_2_AFFINITY_LEVEL_ON);
> +	if (prev != PSCI_0_2_AFFINITY_LEVEL_ON_PENDING) {
> +		/* The only other writer of ON_PENDING is the rollback. */
> +		WARN_ON(prev != PSCI_0_2_AFFINITY_LEVEL_OFF);
> +		return -ECANCELED;
> +	}
> +
> +	kvm_reset_vcpu_core(&hyp_vcpu->vcpu);
> +	kvm_reset_pvm_sys_regs(&hyp_vcpu->vcpu);
> +
> +	/* Must be done after resetting sys registers. */
> +	kvm_reset_vcpu_psci(&hyp_vcpu->vcpu, reset_state);
> +
> +	hyp_vcpu->exit_code = 0;
> +	/*
> +	 * A source that raced a rollback can publish after this clear, and
> +	 * the next cycle then passes the acquire on a stale flag: the pc,
> +	 * r0 and be it reads are still the guest's own.
> +	 */
> +	reset_state->reset = false;
> +	return 0;
> +}
> +
> +struct pkvm_hyp_vcpu *pkvm_mpidr_to_hyp_vcpu(struct pkvm_hyp_vm *hyp_vm,
> +					     u64 mpidr)
> +{
> +	struct pkvm_hyp_vcpu *hyp_vcpu;
> +	int i;
> +
> +	mpidr &= MPIDR_HWID_BITMASK;
> +
> +	for (i = 0; i < hyp_vm->kvm.created_vcpus; i++) {
> +		/* Pairs with smp_store_release() in register_hyp_vcpu(). */
> +		hyp_vcpu = smp_load_acquire(&hyp_vm->vcpus[i]);
> +
> +		if (!hyp_vcpu)
> +			continue;
> +
> +		if (mpidr == kvm_vcpu_get_mpidr_aff(&hyp_vcpu->vcpu))
> +			return hyp_vcpu;
> +	}
> +
> +	return NULL;
> +}
> +
> +/*
> + * Returns true when handled at EL2, false when the host must wake the target
> + * vCPU.
> + */
> +static bool pvm_psci_vcpu_on(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
> +	struct vcpu_reset_state *reset_state;
> +	struct pkvm_hyp_vcpu *target;
> +	unsigned long cpu_id, ret;
> +	int power_state;
> +
> +	cpu_id = smccc_get_arg1(&hyp_vcpu->vcpu);
> +	if (!kvm_psci_valid_affinity(&hyp_vcpu->vcpu, cpu_id)) {
> +		ret = PSCI_RET_INVALID_PARAMS;
> +		goto error;
> +	}
> +
> +	target = pkvm_mpidr_to_hyp_vcpu(hyp_vm, cpu_id);
> +	if (!target) {
> +		ret = PSCI_RET_INVALID_PARAMS;
> +		goto error;
> +	}
> +
> +	/*
> +	 * vCPUs race to power on the same target. Relaxed: reset_state
> +	 * is published by the release on reset_state.reset below.
> +	 */
> +	power_state = cmpxchg_relaxed(&target->power_state,
> +				      PSCI_0_2_AFFINITY_LEVEL_OFF,
> +				      PSCI_0_2_AFFINITY_LEVEL_ON_PENDING);
> +	switch (power_state) {
> +	case PSCI_0_2_AFFINITY_LEVEL_ON_PENDING:
> +		ret = PSCI_RET_ON_PENDING;
> +		goto error;
> +	case PSCI_0_2_AFFINITY_LEVEL_ON:
> +		ret = PSCI_RET_ALREADY_ON;
> +		goto error;
> +	case PSCI_0_2_AFFINITY_LEVEL_OFF:
> +		break;
> +	default:
> +		ret = PSCI_RET_INTERNAL_FAILURE;
> +		goto error;
> +	}
> +
> +	reset_state = &target->vcpu.arch.reset_state;
> +	reset_state->pc = smccc_get_arg2(&hyp_vcpu->vcpu);
> +	reset_state->r0 = smccc_get_arg3(&hyp_vcpu->vcpu);
> +	reset_state->be = kvm_vcpu_is_be(&hyp_vcpu->vcpu);
> +	/*
> +	 * Publish reset_state.{pc, r0, be} to the target vCPU. Pairs with
> +	 * smp_load_acquire(&reset_state->reset) in pkvm_reset_vcpu().
> +	 */
> +	smp_store_release(&reset_state->reset, true);
> +
> +	/* The host requests KVM_REQ_VCPU_RESET and wakes the target. */
> +	return false;
> +
> +error:
> +	smccc_set_retval(&hyp_vcpu->vcpu, ret, 0, 0, 0);
> +	return true;
> +}
> +
> +/*
> + * Returns true when handled at EL2, false when the host must stop scheduling
> + * the vCPU.
> + */
> +static bool pvm_psci_vcpu_off(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	/* No other writer runs while this vCPU is ON and executing. */
> +	WARN_ON(READ_ONCE(hyp_vcpu->power_state) != PSCI_0_2_AFFINITY_LEVEL_ON);
> +
> +	/*
> +	 * Orders pkvm_reset_vcpu()'s clear of reset_state.reset before OFF, so
> +	 * a CPU_ON that wins on OFF republishes after it. Pairs with the
> +	 * cmpxchg in pvm_psci_vcpu_on().
> +	 */
> +	smp_store_release(&hyp_vcpu->power_state, PSCI_0_2_AFFINITY_LEVEL_OFF);
> +
> +	/* Return to the host so that it can finish powering off the vcpu. */
> +	return false;
> +}
> +
> +static bool pvm_psci_version(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	/* Nothing to be handled by the host. Go back to the guest. */
> +	smccc_set_retval(&hyp_vcpu->vcpu, KVM_ARM_PSCI_1_1, 0, 0, 0);
> +	return true;
> +}
> +
> +static bool pvm_psci_features(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
> +	u32 feature = smccc_get_arg1(vcpu);
> +	unsigned long val;
> +
> +	switch (feature) {
> +	case PSCI_0_2_FN_PSCI_VERSION:
> +	case PSCI_0_2_FN_CPU_SUSPEND:
> +	case PSCI_0_2_FN64_CPU_SUSPEND:
> +	case PSCI_0_2_FN_CPU_OFF:
> +	case PSCI_0_2_FN_CPU_ON:
> +	case PSCI_0_2_FN64_CPU_ON:
> +	case PSCI_0_2_FN_AFFINITY_INFO:
> +	case PSCI_0_2_FN64_AFFINITY_INFO:
> +	case PSCI_0_2_FN_SYSTEM_OFF:
> +	case PSCI_0_2_FN_SYSTEM_RESET:
> +	case PSCI_1_0_FN_PSCI_FEATURES:
> +	case PSCI_1_1_FN_SYSTEM_RESET2:
> +	case PSCI_1_1_FN64_SYSTEM_RESET2:
> +	case ARM_SMCCC_VERSION_FUNC_ID:
> +		val = PSCI_RET_SUCCESS;
> +		break;
> +	default:
> +		val = PSCI_RET_NOT_SUPPORTED;
> +		break;
> +	}
> +
> +	/* Nothing to be handled by the host. Go back to the guest. */
> +	smccc_set_retval(vcpu, val, 0, 0, 0);
> +	return true;
> +}
> +
> +static bool pkvm_handle_psci(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
> +	u32 psci_fn = smccc_get_function(vcpu);
> +
> +	switch (psci_fn) {
> +	case PSCI_0_2_FN_CPU_ON:
> +		kvm_psci_narrow_to_32bit(vcpu);
> +		fallthrough;
> +	case PSCI_0_2_FN64_CPU_ON:
> +		return pvm_psci_vcpu_on(hyp_vcpu);
> +	case PSCI_0_2_FN_CPU_OFF:
> +		return pvm_psci_vcpu_off(hyp_vcpu);
> +	case PSCI_0_2_FN_PSCI_VERSION:
> +		return pvm_psci_version(hyp_vcpu);
> +	case PSCI_1_0_FN_PSCI_FEATURES:
> +		return pvm_psci_features(hyp_vcpu);
> +	case PSCI_0_2_FN_AFFINITY_INFO:
> +	case PSCI_0_2_FN64_AFFINITY_INFO:
> +	case PSCI_0_2_FN_SYSTEM_RESET:
> +	case PSCI_0_2_FN_CPU_SUSPEND:
> +	case PSCI_0_2_FN64_CPU_SUSPEND:
> +	case PSCI_0_2_FN_SYSTEM_OFF:
> +	case PSCI_1_1_FN_SYSTEM_RESET2:
> +	case PSCI_1_1_FN64_SYSTEM_RESET2:
> +		return false; /* Handled by the host. */
> +	default:
> +		/* Unknown PSCI calls are answered here, not forwarded. */
> +		smccc_set_retval(vcpu, PSCI_RET_NOT_SUPPORTED, 0, 0, 0);
> +		return true;
> +	}
> +}
> +
>  /*
>   * Handler for protected VM HVC calls.
>   *
> @@ -1187,6 +1460,7 @@ static void pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu)
>   */
>  bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
> +	struct pkvm_hyp_vcpu *hyp_vcpu = container_of(vcpu, struct pkvm_hyp_vcpu, vcpu);
>  	u64 val[4] = { SMCCC_RET_INVALID_PARAMETER };
>  	bool handled = true;
>  	u32 feature;
> @@ -1285,8 +1559,7 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
>  		pkvm_memunshare_call(val, vcpu);
>  		break;
>  	default:
> -		/* Punt everything else back to the host, for now. */
> -		handled = false;
> +		return pkvm_handle_psci(hyp_vcpu);
>  	}
>  
>  	if (handled)
> -- 
> 2.39.5
> 

-- 
Vincent
