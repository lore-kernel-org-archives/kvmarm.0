Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C41F3890F7
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 13:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781874783; cv=none; b=Dwei2NW04Xkec93DbHuNzKkgFV+AnWlZQgL/65dan4yHLFAnvefObHIdgWILWjSX7yqQH6AZW4woKt4ZJqsmqo5eKb/+efT0kkKmBdLuPlBPZNpYkNvYVUYn6xANS+df2xUFWWtOs4KgDerc+tPcOQSowAh+01JZgmPMuNpj2WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781874783; c=relaxed/simple;
	bh=gIiJ77rBosF5zzaFy+wK5virv0DWqGpiggVdWsntMKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q0iCM7Z8ig6sgz+8nzJa27zGmsACQPwgtwc4+DRKIHz3duG8undpElCM0yxUqSzfy62IOPZcohf8IX0hroF37kdsLS3LUzuogI1LVg9SjIF86ameA0/MCmnvaNuvv9Mo6EYiUMNgvcj/RLtb6AyLv6Yr66DSW9xkxvOi0Z+Q3x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=diKh60c+; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="diKh60c+"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-492329c5514so8877695e9.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 06:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781874781; x=1782479581; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fKbHPj4zwl3NIknOENY+4gxJ80U+03HOl4ELuQvS/cA=;
        b=diKh60c+FYkcVcgXiNI3tnTozqhcgS89MhNBQZWW16gT71FdSra3fJ4O7ssPZ4ylXe
         //PaQnAAAS3EfKCV1bGhZnH9UBOhOjNohV/8fTMsx1K6UJ8/jx/IT2WhgyNP7LlwLsl4
         8P/ec8fadoEo9cwOJLZp8K8lEDFQ072IFAgszggVIGRc1xDOeTNRoK43ujK8wj8QYuxR
         DfyIgou6NuTQN6WWd64GLHKFhzqCNIulgOwC7id/c4JudoTOCUuoRip6LBzCfI0/IC5y
         WDdexRLpChSfUFYDwqjsHg/Ky+vNteJ47a1VLiXXws779s7NYJrH0lpEhdt8VAB6uE7n
         bZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781874781; x=1782479581;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fKbHPj4zwl3NIknOENY+4gxJ80U+03HOl4ELuQvS/cA=;
        b=N6miudg/rZanX2Kq6A42wsNxyWlr0ATqfUCzJQNfI7CfrL130YF0+y57SP7dGT5o8E
         5X+z+s+tm629SRIdfa4lHCF5ILlfzn4jqr5T1OpVUaFXF/3FvV1UrpR/STXIwiEy0KO/
         scHhLAg3MfhMHziSOCb1bIpGgPJ8FFPHcYnyIryYQAqs2aTzlah9jbm8gkO6dSsJ2Ppc
         rkwzop5a2wr4XXWKMgokpVNoupPckLU/AKm9vPW7fhhATS1nxrvUMwkNZdfIWwLaDF0l
         LQ/zE32R9vcY8DBUoFcGrLBg2ZMIQRAnyxiWolSJCic2Rm2ULCE9Q3v7ZW39V2NVugu1
         BpuQ==
X-Forwarded-Encrypted: i=1; AFNElJ93Z4Q2y9h+mL1TDbULR88XOmV0MovwNFiqi/FxpGCqfsZWRLgBNdyYX/ET+2aFA+nIjxO8+Xc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPrVokLbBWSrKpF0gL2F5RC4JBgL+yxufhzlqfpuHh5aY/havv
	a42C2CEU7Gx5rgkh0nPogXjkM/eEwLAkogbSZK7V1Uf6dtgJZF7LoVkZXpJwiqDIDg==
X-Gm-Gg: AfdE7ckIWBsUYQgTI8lXQc4QzhLt65jYudEzz+8PWlEpFfiTHU1gjHZVpWY/IqNPog5
	x2GQVnMFcqgxg9D5goP7XwfzvlniBYL8BRHBoTFVNULi4jYccKBdhCn4op0ztQxv7zaxV3MRaxq
	yHAcznuwfeBf5qigimKfvJXuNMyKCc9z1TM/2eYAmdvad/vwVCkt5mgxeY4Yp8bXVMBdNSbYBzp
	sXY47IVWeIj3YwP4EzIaJYSSiypCbuqCyvvK9AwIPSVW9WJJs6BH+8xhizOw4pehGhZ/8V/94lJ
	1tnsbXStWDxLkp5ro1RQ+NOROsQafG1StPBsVS15t3v6klDM9Pl1JaM8TXTdftmKr87f+6YVLUs
	j+TskaUlvJBPQEoIPSlGuny6JmyHk5fnffmas6apJgjl0TJJD46kgM5LfC0KlZxCar6SnI/ad5e
	a8LWsOaGOnYYZx+/+WsvIx50cydpgFMbk6u4fCF+uLyGttHIPtGTE2ITO7dhYqUlQe8CY=
X-Received: by 2002:a05:600c:46ce:b0:492:3767:6973 with SMTP id 5b1f17b1804b1-49240a34552mr41494475e9.9.1781874780106;
        Fri, 19 Jun 2026 06:13:00 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49240efc160sm55381415e9.2.2026.06.19.06.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 06:12:59 -0700 (PDT)
Date: Fri, 19 Jun 2026 14:12:55 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <tabba@google.com>
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
	Hyunwoo Kim <imv4bel@gmail.com>
Subject: Re: [PATCH v2 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
Message-ID: <ajVAV5ct0xdLn1KX@google.com>
References: <20260619070719.812227-1-tabba@google.com>
 <20260619070719.812227-9-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619070719.812227-9-tabba@google.com>

On Fri, Jun 19, 2026 at 08:07:19AM +0100, Fuad Tabba wrote:
> pKVM copies a non-protected guest's register context between the host
> and the hypervisor on every world switch, even when the host never
> inspects it. Defer the copy: on entry, flush the host context into the
> hyp vCPU only when the host marked it dirty (PKVM_HOST_STATE_DIRTY); on
> exit, leave it in the hyp vCPU and copy it back only when the host needs
> it, via a __pkvm_vcpu_sync_state hypercall on trap handling or at vcpu
> put. A protected guest's context is copied as before, since lazy sync
> only helps where the host is trusted to see the guest's registers.
> 
> PC and PSTATE are the exception: they are copied back on every exit so
> the kvm_exit tracepoint reports the guest's real exit PC, and the run
> loop's vcpu_mode_is_bad_32bit() and SError-masking checks evaluate the
> guest's current PSTATE rather than the value left by the previous sync.
> 
> handle_exit_early() can also inject an SError, which writes the guest
> context (ESR_EL1) outside the trap-handling path. For a non-protected
> guest it therefore syncs the context from the hyp vCPU and marks it
> dirty, as handle_trap_exceptions() does, so the injection reaches the
> hyp vCPU on re-entry rather than being dropped.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h   |  1 +
>  arch/arm64/include/asm/kvm_host.h  |  2 +
>  arch/arm64/kvm/arm.c               |  7 +++
>  arch/arm64/kvm/handle_exit.c       | 30 +++++++++++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 86 ++++++++++++++++++++++++++++--
>  5 files changed, 121 insertions(+), 5 deletions(-)
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
> index 2faa60df847d..caa39ee5125f 100644
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
> index 3732ee9eb0d4..4e89558d8027 100644
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
> index 54aedf93c78b..8963621bcdd1 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -422,6 +422,20 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu)
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
> +		guard(preempt)();
> +		if (!(vcpu_get_flag(vcpu, PKVM_HOST_STATE_DIRTY))) {
> +			kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> +			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> +		}
> +	}
> +

Could we remove this update here and let handle_exit_early() do the sync
regardless of the SError injection? One of the main point of handle_exit_early()
is to do things under !prempt().


>  	/*
>  	 * See ARM ARM B1.14.1: "Hyp traps on instructions
>  	 * that fail their condition code check"
> @@ -489,6 +503,22 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
>  /* For exit types that need handling before we can be preempted */
>  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
>  {
> +	bool inject_serror = ARM_SERROR_PENDING(exception_index) ||
> +		ARM_EXCEPTION_CODE(exception_index) == ARM_EXCEPTION_EL1_SERROR;
> +
> +	/*
> +	 * An SError injected below writes the host ctxt; for a non-protected
> +	 * guest, sync from the hyp vCPU and keep it dirty so it isn't dropped.
> +	 */
> +	if (is_protected_kvm_enabled()) {

Should we test !kvm_vm_is_protected(vcpu->kvm) here, as the
PKVM_HOST_STATE_DIRTY is only updated for p-guests everywhere else?

> +		vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> +
> +		if (inject_serror && !kvm_vm_is_protected(vcpu->kvm)) {
> +			kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> +			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> +		}
> +	}
> +
>  	if (ARM_SERROR_PENDING(exception_index)) {
>  		if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
>  			u64 disr = kvm_vcpu_get_disr(vcpu);

[...]
