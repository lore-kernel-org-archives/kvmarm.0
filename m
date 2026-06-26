Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC813DF01C
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782458800; cv=none; b=Crx5b0OA7cEwPtuz0TMgjF7cpNFE2z4ZwcvoiT0N9A5ytW5BrMLH7hImwhOB4EtPIl8Aueky0pgXycu7kQDL1OucEj4zutQJppa5VqFeyDaSaP8ybODSjVsK7gZ5HOoVzFMDAysTKI5R6szCOKWzuDDB24TuxcxbUh68DKdZ6q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782458800; c=relaxed/simple;
	bh=wIkxUEgZQxqtWzuqA/giZJIxO+SUHWuQZ2QI6CI75oc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gS6LniOTuG+xlpUko9fl5KYSegiPd80AWq00xqT5y8GfLGHu8DW/7J1Jt6rFll6rN4iaBIuZKVhRWf2Zg9We/bqwI/FFZr3AtqDqsByDlYwOkgQ6YTQM4B12MRNUAatbdCIguh+JHzbTJfW/gjDkoiU/1ELeS26XaFK2QOFcX20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WLoS7ptK; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WLoS7ptK"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49241dbf9c1so5410275e9.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 00:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782458795; x=1783063595; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yb7I5zhAtiTVkfckf6Udr6TiG/DJCJIc8n/hG3KXcNk=;
        b=WLoS7ptK2qiFUOQeyFbD00pS4jmAxH8UX8B0z+0yfR4Qx87IkkVDnB50UcsMmTVxsB
         UbJMmGXMGa+vlJhWUdX0PHOs0f2DZCNoQQPp+k5C9V/dvh4GJ5SZNcsx5Bo9jN51dWWj
         tgDEWkVj6p/RRF8YacP2hkUgCTLXh2bK8EnORwqBv2P8MVGhZowCmYjQBq0s0UpQvXAp
         nxroZLcAdKAU8TSymOmr5PCvIxXiQJRVjrHbCISJj3zBEwCNvrnZN/ObFCk0q7yGISfu
         BVYXdp9OSNGXlbzySfYP/lTYpJlxUgrcWLQEp9i+E+8BUYz3e/g+FdILuWd8lfwtOaPR
         Rv5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782458795; x=1783063595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yb7I5zhAtiTVkfckf6Udr6TiG/DJCJIc8n/hG3KXcNk=;
        b=NY3K18h1OAQ7ZIv9SzqfASYGQlYQMKrRk/VUwIAsSufzorOYWjhGXgXO3EVjX9QHXW
         5QD5feeeCbeZBI6m/LuAgt68L1NxrtH7a+Ss7j0xeKJu1/6bDgHsJM2x+kwlNLtNqu+2
         1OMUNzuKolrUw4XDNk/snXVo3TsBl7OvDbniIW6W0b5az/vPNLewhO7nui1yqSvn7Hs0
         Ysa7uVPX45VWa9ZGkuvBHcrT3eqlkqwN+mK2aiU09x+D3z0uXEnlFT4w5866Ei902oZa
         s/y5pXtjQFI743NiHFmBOusla7/3kB0iD8RGkdIiUyYipINctGtLkk4mglFXazcXERbF
         fWHg==
X-Forwarded-Encrypted: i=1; AFNElJ9g1CSti6WCH7eQ0bujby07I+AVhCu3NvbUqBcG8Vs6/CKIaVQpGBdnjKa2BuqKNriPXgIgAr8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLZ4ZKyYtzeUkilFKm+WyKUarOANozAQ+2+t1RoSizqpfVuc1f
	AI0BVxAchGWBqdrqljbjkmMLHoyoWo7GJbDjWA7AsnZfuLc853572+5bGhRUc4Cx4Q==
X-Gm-Gg: AfdE7clYkhyQvuvxLUIKJ11Rk/wSFRmeHrTZb7Vp0dDLnY8sUmHmhRU/sB1r2KZClo0
	saesRqc+uSKnjVJok/E6wlg94JHOS4ZTjjFWvLK6m9YafyhJCRf7lvZNzDygd7d5FoueG7YHbtM
	ZXeSGLU/GmJ/5+D32JuLpgg8l2b3MvsVN4G1m8nYmPlhXPqGWJMrsmwQjTgSVxG+hhc6d7M3S4k
	iGvN7BGrMrqb5DVmInz3gJ6drnmPKoN+qQBQVKwgm5p9hAPyLK9cHjtWmQ8x8xdirIrBaKAFhnG
	WNx3DbnbL8Pk13yfaUOeOKqS+n/f/Kl4ddfnqhRrIwTWSHf7omdPpCRzShgdIZ/EtFvtWafhQFO
	l1tMri0ReRarwwvYfnJCgadJbt45TxkrNp/HCw2gezhAAXUH06GthmQvbs53Bfum61OQOgNwU82
	6IC9gVUedqDK75dSqxDwprnhawxKMc5TjZX4fgFrmqtjVoAuJYyEw=
X-Received: by 2002:a05:600c:8b53:b0:490:b294:c652 with SMTP id 5b1f17b1804b1-492668857demr75260145e9.20.1782458794415;
        Fri, 26 Jun 2026 00:26:34 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49269005626sm54095525e9.10.2026.06.26.00.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 00:26:33 -0700 (PDT)
Date: Fri, 26 Jun 2026 08:26:29 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
Message-ID: <aj4ppe5JYTaaB3zh@google.com>
References: <20260626070408.3420953-1-fuad.tabba@linux.dev>
 <20260626070408.3420953-9-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626070408.3420953-9-fuad.tabba@linux.dev>

On Fri, Jun 26, 2026 at 08:04:08AM +0100, Fuad Tabba wrote:
> pKVM copies a non-protected guest's register context between the host
> and the hypervisor on every world switch, even when the host never
> inspects it. Defer the copy: on entry, flush the host context into the
> hyp vCPU only when the host marked it dirty (PKVM_HOST_STATE_DIRTY); on
> exit, leave it in the hyp vCPU and copy it back only when the host needs
> it, via a __pkvm_vcpu_sync_state hypercall or at vcpu put. A protected
> guest's context is copied as before, since lazy sync only helps where
> the host is trusted to see the guest's registers.
> 
> PC and PSTATE are the exception: they are copied back on every exit so
> the kvm_exit tracepoint reports the guest's real exit PC, and the run
> loop's vcpu_mode_is_bad_32bit() and SError-masking checks evaluate the
> guest's current PSTATE rather than the value left by the previous sync.
> 
> The host needs the full context when it is about to read it (trap
> handling) or write it (the SError injection that writes ESR_EL1). Sync
> both from handle_exit_early(), which runs non-preemptible so the loaded
> hyp vCPU is stable without a preempt guard.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/include/asm/kvm_asm.h   |  1 +
>  arch/arm64/include/asm/kvm_host.h  |  2 +
>  arch/arm64/kvm/arm.c               |  7 +++
>  arch/arm64/kvm/handle_exit.c       | 23 ++++++++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 86 ++++++++++++++++++++++++++++--
>  5 files changed, 114 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 043495f7fc78b..6e1135b3ded44 100644
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
> index 2faa60df847d2..caa39ee5125f2 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1068,6 +1068,8 @@ struct kvm_vcpu_arch {
>  #define INCREMENT_PC		__vcpu_single_flag(iflags, BIT(1))
>  /* Target EL/MODE (not a single flag, but let's abuse the macro) */
>  #define EXCEPT_MASK		__vcpu_single_flag(iflags, GENMASK(3, 1))
> +/* Host-set: the hyp flushes the non-protected vCPU state in on entry */
> +#define PKVM_HOST_STATE_DIRTY	__vcpu_single_flag(iflags, BIT(4))
>  
>  /* Helpers to encode exceptions with minimum fuss */
>  #define __EXCEPT_MASK_VAL	unpack_vcpu_flag(EXCEPT_MASK)
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3732ee9eb0d4e..4e89558d80278 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -733,6 +733,10 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
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
> @@ -964,6 +968,9 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
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
> index 54aedf93c78b6..29108e5c0206e 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -486,9 +486,32 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
>  	}
>  }
>  
> +static void handle_exit_pkvm_state(struct kvm_vcpu *vcpu, int exception_index)
> +{
> +	int exception_code = ARM_EXCEPTION_CODE(exception_index);
> +
> +	if (!is_protected_kvm_enabled() || kvm_vm_is_protected(vcpu->kvm))
> +		return;
> +
> +	/*
> +	 * Sync the context back when the host will read (trap) or write
> +	 * (SError) it. Preempt-off here, so the loaded hyp vCPU is stable.
> +	 */
> +	if (exception_code == ARM_EXCEPTION_TRAP ||
> +	    exception_code == ARM_EXCEPTION_EL1_SERROR ||
> +	    ARM_SERROR_PENDING(exception_index)) {
> +		kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> +		vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> +	} else {
> +		vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> +	}
> +}
> +
>  /* For exit types that need handling before we can be preempted */
>  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
>  {
> +	handle_exit_pkvm_state(vcpu, exception_index);
> +
>  	if (ARM_SERROR_PENDING(exception_index)) {
>  		if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
>  			u64 disr = kvm_vcpu_get_disr(vcpu);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 0194965930e61..acf53aae4fe43 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -141,6 +141,48 @@ static void sync_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
>  		host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
>  }
>  
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
> +static void sync_hyp_vcpu_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	__copy_vcpu_state(&hyp_vcpu->vcpu, hyp_vcpu->host_vcpu);
> +}
> +
> +static void flush_hyp_vcpu_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	__copy_vcpu_state(hyp_vcpu->host_vcpu, &hyp_vcpu->vcpu);
> +}
> +
>  static void flush_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
>  {
>  	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> @@ -170,7 +212,17 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
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
> +			flush_hyp_vcpu_state(hyp_vcpu);
> +	} else {
> +		hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;
> +	}
>  
>  	/* __hyp_running_vcpu must be NULL in a guest context. */
>  	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
> @@ -201,9 +253,13 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>  	fpsimd_sve_sync(&hyp_vcpu->vcpu);
>  	sync_debug_state(hyp_vcpu);
>  
> -	host_vcpu->arch.ctxt		= hyp_vcpu->vcpu.arch.ctxt;
> -
> -	host_vcpu->arch.hcr_el2		= hyp_vcpu->vcpu.arch.hcr_el2;
> +	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> +		host_vcpu->arch.ctxt = hyp_vcpu->vcpu.arch.ctxt;
> +	} else {
> +		/* Keep PC (tracepoint) and PSTATE (vcpu_mode_is_bad_32bit) current. */
> +		host_vcpu->arch.ctxt.regs.pc = hyp_vcpu->vcpu.arch.ctxt.regs.pc;
> +		host_vcpu->arch.ctxt.regs.pstate = hyp_vcpu->vcpu.arch.ctxt.regs.pstate;
> +	}
>  
>  	host_vcpu->arch.fault		= hyp_vcpu->vcpu.arch.fault;
>  
> @@ -237,8 +293,27 @@ static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
>  {
>  	struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
>  
> -	if (hyp_vcpu)
> +	if (hyp_vcpu) {
> +		struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> +
> +		if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu) &&
> +		    !vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY)) {
> +			sync_hyp_vcpu_state(hyp_vcpu);
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
> +	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
> +	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> +		return;
> +
> +	sync_hyp_vcpu_state(hyp_vcpu);
>  }
>  
>  static struct kvm_vcpu *__get_host_hyp_vcpus(struct kvm_vcpu *arg,
> @@ -869,6 +944,7 @@ static const hcall_t host_hcall[] = {
>  	HANDLE_FUNC(__pkvm_finalize_teardown_vm),
>  	HANDLE_FUNC(__pkvm_vcpu_load),
>  	HANDLE_FUNC(__pkvm_vcpu_put),
> +	HANDLE_FUNC(__pkvm_vcpu_sync_state),
>  	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
>  };
>  
> -- 
> 2.39.5
> 
