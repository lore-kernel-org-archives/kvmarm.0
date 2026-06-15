Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EE935C183
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 13:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529375; cv=none; b=Z1guX/q0Ou+LVTujrj40uMgj+LMs1l8Knh7lerizkzW7In8nOQetGZWBPcP4yGudEyK65bu+ONnR2Fqza7WK6zs/qg95rrrewwFXW1lJ2KTk0u2K8BkatJ6AK135muQuyi5nfw4ZRS9HbPnZr8lvpczKWE0HrIvISxX9g2kszfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529375; c=relaxed/simple;
	bh=A8Ep0Wmc4kUGmP4mTO/iA/kq9uGntVmfn1rumhtOBeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uwrb7t3VX5uCOOZD3F1EUAxXOUJyLoGrDYiJxbD7x6qUz0EPK3Yvj2abxzEDCVbF+kigT00ZO4z+TNPOIiNdFqyb5OpoNdjz9WjKSZz6UBhbsigZh3RrLAcwNpCh0EGXnO6ktDvZViibVban+r/CEdGgd178tM7RmmYj1XJ8Lqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lQ1NkXIi; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lQ1NkXIi"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490afc47455so14473685e9.2
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 06:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781529373; x=1782134173; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TQ58z3upk1eY3VciKlccEDc0f38MFbh+NQoVw05fFOc=;
        b=lQ1NkXIi6Afgp2e7P7c6sWW6O4ONbPSKikOGclBq5AD6OrFTzRn/BXnNo7rnGsJ7pQ
         AeX4TtzSSxxHcNT9WbBMOvzibPPfiBADZ4jNdap+re5Kle6sVjxWdtf8bM+TC+USbh/R
         pjJLuJvV9TzqJrDeCHCT6q0rEXOf5snpzOw4RT8mXMxUqwX/USE87sre5es0O+i9SCgA
         Vuo1Yk2DmrW3ACfLaU2Qf9FxChSYQlch9JsDAcqZeo0q5guZUxicis1QRkp6grSUZehM
         VMpYz62uiK8pA4A/6PBODHGEf078pXxlPuxJyWnZAfh52nxslNwpV63x5ce2oQf0o4Fw
         NpGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781529373; x=1782134173;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TQ58z3upk1eY3VciKlccEDc0f38MFbh+NQoVw05fFOc=;
        b=Y2UyjJt2CM6Uqgrsun1lLIy/YHILqgMuifKMnahEMWXJDn9muD2DfT2eh/8Y2nduUc
         KeUOjAAgnTL2GrdMfZtiy9XNaJtR9O6x2fagQWkjiKlbAIFbMjZoD8ei9bx+opuYiwoy
         ZHa5Urvdvu7opQrZtF7XwX6spWEmhDDy/8+ETm0S5QuViyH2Cnz8ASqnRZbtk9Q2qFSt
         yxd/fzyyZK+iRS0yQkXEOKncOIvESLd8pZislzPn63mDiC0QXTc/9iIvj9vgndZ3W06q
         yuGflYOC4RAp6rTwXuIGGkLdLwZgboReaBGOMoKSFa+jnPfDYPIgMNyfmarJ4GvKuFfV
         NUew==
X-Forwarded-Encrypted: i=1; AFNElJ/mPqVlusH528i6WweGoJ67muxwwD+wLNMhkzBl83s4Z7tBOy0dwnNE5W02t8rLm+WN7mDnVOI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxBz6agacrPeH1sTfMGtG9a2ISNa/z3KLANdSv5IvyOgVR8Dh5W
	wAGfwNWm0FC575diKNzxOGV6/wpdW+pLJ/KR5LRdKII2XeaKpWN8nfL071hEFOlp5A==
X-Gm-Gg: Acq92OHRAZ4MIymlyt/IFGYstp7oTT0J/4FZnKJZDMbgaoyBgPXlCyJXDam1YeAi78Z
	/cxHACWE3xI/pqVtYdgGISq2HdcH94C3TJ244qFowQvqyCjnTNAo/4AayzyPdmjAuDib4SI4REI
	OojNX+HM8mIhaBM45WwzKawp/DzCzDPPdCvECRDXO8zEk8uCYLeHD0NA2KBTWXQ0ElNOjblBTlN
	3aIaIBXODb3oBDAjxlcdTWKzgYRgMKQY7cmeGGQWxJp8Fp4fmRhrE2DO/oDbNAmWueq2wNQsaeT
	vHqPdLJDhN5oMF0avKPyjlvFP9Dul+owW+ESJYtWT/0lYOcCv5jxB8J0rGWAQjc+JomebyuUTRK
	d2XX4F9Hp5M+dKmiWi7m4xoM4vF1xpKZ4eCPE7Lq+Ry0qNrKj8Zy0nW6jC57pX4lZl+fD95vJXX
	anlDigfHFxgiDHFeFqXqtsqV9e3362K3WoFU6kfRX3hv804aUgg59QRDt9FBhF14zvHog=
X-Received: by 2002:a05:600c:a06:b0:492:2c87:3d4b with SMTP id 5b1f17b1804b1-4922c87404amr32991675e9.12.1781529371744;
        Mon, 15 Jun 2026 06:16:11 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492203d2449sm238175265e9.14.2026.06.15.06.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 06:16:10 -0700 (PDT)
Date: Mon, 15 Jun 2026 14:16:06 +0100
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
Subject: Re: [PATCH v1 06/11] KVM: arm64: Factor out reusable vCPU reset
 helpers
Message-ID: <ai_7FupwNYrudRZZ@google.com>
References: <20260612065925.755562-1-tabba@google.com>
 <20260612065925.755562-7-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612065925.755562-7-tabba@google.com>

On Fri, Jun 12, 2026 at 07:59:20AM +0100, tabba@google.com wrote:
> Pull the reusable pieces out of kvm_reset_vcpu(): expose the reset
> PSTATE values in kvm_arm.h, and split the core register reset and the
> PSCI-driven reset into kvm_reset_vcpu_core() and kvm_reset_vcpu_psci().
> A follow-up series reuses these to reset protected vCPUs at EL2.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h     | 12 ++++++
>  arch/arm64/include/asm/kvm_emulate.h | 58 +++++++++++++++++++++++++++
>  arch/arm64/kvm/reset.c               | 60 ++--------------------------
>  3 files changed, 73 insertions(+), 57 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 3f9233b5a130..aba4ec09acd2 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -348,4 +348,16 @@
>  	{ PSR_AA32_MODE_UND,	"32-bit UND" },	\
>  	{ PSR_AA32_MODE_SYS,	"32-bit SYS" }
>  
> +/*
> + * ARMv8 Reset Values
> + */
> +#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
> +				 PSR_F_BIT | PSR_D_BIT)
> +
> +#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
> +				 PSR_F_BIT | PSR_D_BIT)
> +
> +#define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
> +				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
> +
>  #endif /* __ARM64_KVM_ARM_H__ */
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index aed9fc0b717b..8436e71c402d 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -704,4 +704,62 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
>  			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
>  	}
>  }
> +
> +/* Reset a vcpu's core registers. */
> +static inline void kvm_reset_vcpu_core(struct kvm_vcpu *vcpu)
> +{
> +	u32 pstate;
> +
> +	if (vcpu_el1_is_32bit(vcpu)) {
> +		pstate = VCPU_RESET_PSTATE_SVC;
> +	} else if (vcpu_has_nv(vcpu)) {
> +		pstate = VCPU_RESET_PSTATE_EL2;
> +	} else {
> +		pstate = VCPU_RESET_PSTATE_EL1;
> +	}

nit: no brackes here, actually there were none before.

> +
> +	/* Reset core registers */
> +	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
> +	memset(&vcpu->arch.ctxt.fp_regs, 0, sizeof(vcpu->arch.ctxt.fp_regs));
> +	vcpu->arch.ctxt.spsr_abt = 0;
> +	vcpu->arch.ctxt.spsr_und = 0;
> +	vcpu->arch.ctxt.spsr_irq = 0;
> +	vcpu->arch.ctxt.spsr_fiq = 0;
> +	vcpu_gp_regs(vcpu)->pstate = pstate;
> +}
> +
> +/* PSCI reset handling for a vcpu. */
> +static inline void kvm_reset_vcpu_psci(struct kvm_vcpu *vcpu,
> +				       struct vcpu_reset_state *reset_state)
> +{
> +	unsigned long target_pc = reset_state->pc;
> +
> +	/* Gracefully handle Thumb2 entry point */
> +	if (vcpu_mode_is_32bit(vcpu) && (target_pc & 1)) {
> +		target_pc &= ~1UL;
> +		vcpu_set_thumb(vcpu);
> +	}
> +
> +	/* Propagate caller endianness */
> +	if (reset_state->be)
> +		kvm_vcpu_set_be(vcpu);
> +
> +	*vcpu_pc(vcpu) = target_pc;
> +
> +	/*
> +	 * We may come from a state where either a PC update was
> +	 * pending (SMC call resulting in PC being increpented to
> +	 * skip the SMC) or a pending exception. Make sure we get
> +	 * rid of all that, as this cannot be valid out of reset.
> +	 *
> +	 * Note that clearing the exception mask also clears PC
> +	 * updates, but that's an implementation detail, and we
> +	 * really want to make it explicit.
> +	 */
> +	vcpu_clear_flag(vcpu, PENDING_EXCEPTION);
> +	vcpu_clear_flag(vcpu, EXCEPT_MASK);
> +	vcpu_clear_flag(vcpu, INCREMENT_PC);
> +	vcpu_set_reg(vcpu, 0, reset_state->r0);
> +}
> +
>  #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 60969d90bdd3..e22d0be9e57c 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -34,18 +34,6 @@
>  static u32 __ro_after_init kvm_ipa_limit;
>  unsigned int __ro_after_init kvm_host_sve_max_vl;
>  
> -/*
> - * ARMv8 Reset Values
> - */
> -#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
> -				 PSR_F_BIT | PSR_D_BIT)
> -
> -#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
> -				 PSR_F_BIT | PSR_D_BIT)
> -
> -#define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
> -				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
> -
>  unsigned int __ro_after_init kvm_sve_max_vl;
>  
>  int __init kvm_arm_init_sve(void)
> @@ -191,7 +179,6 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_reset_state reset_state;
>  	bool loaded;
> -	u32 pstate;
>  
>  	scoped_guard(spinlock, &vcpu->arch.mp_state_lock) {
>  		reset_state = vcpu->arch.reset_state;
> @@ -210,21 +197,8 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  		kvm_vcpu_reset_sve(vcpu);
>  	}
>  
> -	if (vcpu_el1_is_32bit(vcpu))
> -		pstate = VCPU_RESET_PSTATE_SVC;
> -	else if (vcpu_has_nv(vcpu))
> -		pstate = VCPU_RESET_PSTATE_EL2;
> -	else
> -		pstate = VCPU_RESET_PSTATE_EL1;
> -
>  	/* Reset core registers */
> -	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
> -	memset(&vcpu->arch.ctxt.fp_regs, 0, sizeof(vcpu->arch.ctxt.fp_regs));
> -	vcpu->arch.ctxt.spsr_abt = 0;
> -	vcpu->arch.ctxt.spsr_und = 0;
> -	vcpu->arch.ctxt.spsr_irq = 0;
> -	vcpu->arch.ctxt.spsr_fiq = 0;
> -	vcpu_gp_regs(vcpu)->pstate = pstate;
> +	kvm_reset_vcpu_core(vcpu);
>  
>  	/* Reset system registers */
>  	kvm_reset_sys_regs(vcpu);
> @@ -233,36 +207,8 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	 * Additional reset state handling that PSCI may have imposed on us.
>  	 * Must be done after all the sys_reg reset.
>  	 */
> -	if (reset_state.reset) {
> -		unsigned long target_pc = reset_state.pc;
> -
> -		/* Gracefully handle Thumb2 entry point */
> -		if (vcpu_mode_is_32bit(vcpu) && (target_pc & 1)) {
> -			target_pc &= ~1UL;
> -			vcpu_set_thumb(vcpu);
> -		}
> -
> -		/* Propagate caller endianness */
> -		if (reset_state.be)
> -			kvm_vcpu_set_be(vcpu);
> -
> -		*vcpu_pc(vcpu) = target_pc;
> -
> -		/*
> -		 * We may come from a state where either a PC update was
> -		 * pending (SMC call resulting in PC being increpented to
> -		 * skip the SMC) or a pending exception. Make sure we get
> -		 * rid of all that, as this cannot be valid out of reset.
> -		 *
> -		 * Note that clearing the exception mask also clears PC
> -		 * updates, but that's an implementation detail, and we
> -		 * really want to make it explicit.
> -		 */
> -		vcpu_clear_flag(vcpu, PENDING_EXCEPTION);
> -		vcpu_clear_flag(vcpu, EXCEPT_MASK);
> -		vcpu_clear_flag(vcpu, INCREMENT_PC);
> -		vcpu_set_reg(vcpu, 0, reset_state.r0);
> -	}
> +	if (reset_state.reset)
> +		kvm_reset_vcpu_psci(vcpu, &reset_state);
>  
>  	/* Reset timer */
>  	kvm_timer_vcpu_reset(vcpu);
> -- 
> 2.54.0.1136.gdb2ca164c4-goog
> 
