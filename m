Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C98F2E8B81
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 13:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781875767; cv=none; b=HYsJW4DeWsAeXXatrhoTOXfVtT5AqUGpjbaSP56Ebw9Yu42dfeepEsCBwEYKuXKOSVnedEkEkBamC0L1+er8ODpVgwquZz0bTKaPlfL988hdxl8fqk7Ewi48AI/ozxsTUfeYw9fGYdoDIyiR9pKapKJNT15YGY8W88Oqo7vxr48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781875767; c=relaxed/simple;
	bh=qNP/Ei+oEPWRuZHcFwFEMNs87Uh1QhIHpyjK1WqcACM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L3FstefnuP4qrgD+TcEhCCiPIEB7n9JxnxLA50clWW6UNofx8FwtU9p3DyttCjuDlm9dLYqdZohZCJQFgmJp5E4PuzfGcuMG3l416KuJwkfGTY270ltoFn3pxDt4z/0+tvtIhTp8U4m3O3/kh652w0Qxm4vI7IMACte3w6YN3k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PqNvuzJB; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PqNvuzJB"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-491b390f9e9so18691365e9.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 06:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781875764; x=1782480564; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DFtqEUJwr/FxLj+oB4yh/uuwM4uyDihUAVSs/6dx5t0=;
        b=PqNvuzJB+xrivyCVJtYe2G5e7ij6sZ61Gg6CcY/N4j4dzSU9S7FCGNw52k22TrG/Li
         DaY86Oa2yz5QoOdB3WHVSJXRuows+F9PXp27jZm0gO1dJKhZThnAXgAZAJRg93QTrPKg
         T9ofDz3wV/ZTOVhUVkxp5D9IhhYrgrbWv2kegiTvrvJ+tm8L69U3Llzt4HLzlp929V4z
         fGL0ieIuyTALULSpEfh/sfaFug4T4nnjA6ETDt04kx/u9h2qtwTUuqiqtOiyNVfPMd4T
         Zag5BLDoDRlqGrtq+CHkzu1STLCA8PXjOgnrzHsKe7/bLQVOVvD2WN0iR6j1LSw9LeNS
         IaZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781875764; x=1782480564;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DFtqEUJwr/FxLj+oB4yh/uuwM4uyDihUAVSs/6dx5t0=;
        b=QZqrIfJ6bBITn1nObjFR6FJYP5a4XGhbVb/bKwCcYlGe1+C5KIlACf3b4KoxxHWkOb
         Xg9fz+S8Ig4EwcPwj8xndV4vCURmwPZ01FgEe35PZovO692OMQq8NXrWYu0GRG55ZCoq
         Wm7bQQUAGyJKPehRbx9N6oSmMV6oN8xMm6IME2xHmQgBklKv8B6GXGGEdJyUNA3n6tec
         Z8GT/cwaMrHUmR/rkGJ4Zeg2hnntbCLGKlwHxGpv2wdKMINW7aIwP6mEnVopig2eRZr4
         ZeTVJmn3e7iKgq4wMcMlSz0e4ofWVkBMjmB8WLsPBP+eEwlywWVDPOUSUfIe1DfXx6Fz
         8wxA==
X-Forwarded-Encrypted: i=1; AFNElJ+Knu8O2OMKcgvkhvUMbhv/En3dKjQXcoEnPdzzHBs7G5JCWaAz717kLcQj04205jHNo3hvcWw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxuh31BSzZshY+ldQDXp3HPJ/oB53vZHvKyXAJDuTlqt3Ot779K
	ixlxnivOxnHXVQpEzt9XYndHkn/RZ9Fw8Wk5gdcCfT4OJsJpi7AOEiqL5juRCOjB9A==
X-Gm-Gg: AfdE7clEHdC6rdkvoN2HSlf/oU8xQxBdcUpTYVl2U/sXviN321mXvoFXGwR5PxnY4sN
	GF9FQA23Xa/b5o/JsK7caxcBEqu8ec3XhE5B2PrB4WxtUuDUjCNwicYA773GkD9Ukr6nXaayB7n
	TtzYFWHhnWUUrAo1X385S2DpyshL777fMeodqD7ZxuWnH3UM+b7vgHMLOW1CyYVr9O5dWlfgJoY
	0dVyBkPHnLUEIhKedD6wVlMlbEUjG+3HPrG1ngiee3pr51mQTJ+aKgH/H9ht/KVq0TyiV0z9dNq
	BWtuPbFUr9aVcy7f+QJy7LbjjaVYNA3v/l9JGhvN2u9V0t5YJNG6JPqrDP3yj5j5aQmKJzkeX33
	OgFUQWfbdvGuiLrE55W3X3Aj132t6Y2sF7yMN0HfSWa/o6hrFv01PlhN6jJPL1IGKS39x7mxUlZ
	tmdW2UUTtMHZg8OAO+SAiDoUTlNnTDJmWUpOpwEILSQIlQeDMUV1ePoEvV
X-Received: by 2002:a05:600c:203:b0:490:c7dd:7cc2 with SMTP id 5b1f17b1804b1-49240e61101mr42977915e9.24.1781875763891;
        Fri, 19 Jun 2026 06:29:23 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4650c11693dsm8318152f8f.37.2026.06.19.06.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 06:29:22 -0700 (PDT)
Date: Fri, 19 Jun 2026 14:29:18 +0100
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
Subject: Re: [PATCH v2 3/8] KVM: arm64: Factor out reusable vCPU reset helpers
Message-ID: <ajVELlJ4hMnXVFMR@google.com>
References: <20260619070719.812227-1-tabba@google.com>
 <20260619070719.812227-4-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619070719.812227-4-tabba@google.com>

On Fri, Jun 19, 2026 at 08:07:14AM +0100, Fuad Tabba wrote:
> Pull the reusable pieces out of kvm_reset_vcpu(): expose the reset
> PSTATE values in kvm_arm.h, and split the core register reset and the
> PSCI-driven reset into kvm_reset_vcpu_core() and kvm_reset_vcpu_psci().
> A follow-up series reuses these to reset protected vCPUs at EL2.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/include/asm/kvm_arm.h     | 12 ++++++
>  arch/arm64/include/asm/kvm_emulate.h | 57 ++++++++++++++++++++++++++
>  arch/arm64/kvm/reset.c               | 60 ++--------------------------
>  3 files changed, 72 insertions(+), 57 deletions(-)
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
> index 80b30fead3d1..2385d8855fcf 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -704,4 +704,61 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
>  			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
>  	}
>  }
> +
> +/* Reset a vcpu's core registers. */
> +static inline void kvm_reset_vcpu_core(struct kvm_vcpu *vcpu)
> +{
> +	u32 pstate;
> +
> +	if (vcpu_el1_is_32bit(vcpu))
> +		pstate = VCPU_RESET_PSTATE_SVC;
> +	else if (vcpu_has_nv(vcpu))
> +		pstate = VCPU_RESET_PSTATE_EL2;
> +	else
> +		pstate = VCPU_RESET_PSTATE_EL1;
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
> index b963fd975aac..10eb7249aa9e 100644
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
>  	spin_lock(&vcpu->arch.mp_state_lock);
>  	reset_state = vcpu->arch.reset_state;
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
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
> 
