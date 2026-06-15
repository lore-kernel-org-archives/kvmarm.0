Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0B633F369
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 13:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781531166; cv=pass; b=BM7cGJu7lF9JC+8e+h5wBlG6AgAdbC/DG63SlFM6vB9G45LrWbExu2lLUc8gckvbvf7ismaHxih4p4FEbrH4SEQ3CxWzUWCfrjbvuHt2lBazJYR2bjtYqIueRDLwgHhsXGm7ZRqB1BDws83ZGoMpnUM8zaJk9rvI6DfJc/ZBBg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781531166; c=relaxed/simple;
	bh=ctm4I3xav7WGAfEmkJRhsxZ+FOrzkCfqD0dnRCKDCAY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JBsI1XqeJe4D/DQ/9DkERR8WbHQpdk6FbeAnCMkMRphB7hCy0dgAZofVpUtnuBbYZBQ7sQEahhbIQUtqc1UCKqfQYudcZ6m0w4uU/2GnasKpn9eyQmdMv/JXGGAvS1DDDo0AepTJJURcJbXLkqa+ZZ35qNpwp/Y9Ly3KpA4WrCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a09jWWoc; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a09jWWoc"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5177d1ff061so85581cf.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 06:46:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781531164; cv=none;
        d=google.com; s=arc-20240605;
        b=Tw6oZ+KncVFSuod1DXzxmW81haERZJ2WOm5azkukZ1SUI0c237W1Mvf0J4x+EfIAxQ
         SDJpEqSgt5b/Th8CkEmnW2/6Drom/q265ZWDGL7/OVDJiDZdxwGjI30VZkCh5jNOAQKo
         VNQpRWOklIYNltFEly5bkSmGEdYWnANP/JcZKo2bvM5vkQO/Omd2xwRNBw0rn3e+cdVd
         tzCr+7EgDk2QNVjAyBXN7183FqRYDLucEu9z/hRgd8AHkJV5pLDVTLpOnq7G92rAcRfW
         /v5RkrtC1W68lY5HbeOen/9VSTA775mtd3Z2uD8iy2O3gpzV1vEXOeg2CpRQJsxVVWB8
         UwZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/RKAlB+YaRvxl+nRljsm0vU9jlQ7EuTV00J5KLHppO0=;
        fh=LT4ZQ+i4SRit/jGHYFyXLHzMcLDchXWPHIah4EOOiMs=;
        b=QCkOnW7s6F8dNGpPiOpyTjFXQHpd0KSd0jj98GQGlwIXZId71fH1hBoHrg4CXvnE/Z
         1+T13VVgW90U4DAvDBMJZIffFH6blVWaaLrM0cSozz1oPfRiti0Av6730waCHqwqOSIv
         RJ33ccv/Iccmdd35ZJh6DE+UT+v6eIeQcLFAhsHCfHhKVhszwBkpo0GRfR0awa3lBOVY
         vvuVGV7g+WJaRL4FEBBjXQrFFHBQSeSZjht/zBCJURjcDlsHFJLAW7DTS3Xc+GQy2mOb
         LBFNtr+4ghMfT8WycaeE3IEthHFzpFn8qcREMLDDFjafp13uCQLY4II3xIByrOuWUdMj
         P71g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781531164; x=1782135964; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/RKAlB+YaRvxl+nRljsm0vU9jlQ7EuTV00J5KLHppO0=;
        b=a09jWWoc2vUnQlWiu/tfLtVHu41yupeXzfoBog1rypp4RAdf8Aew1y5tSG+EOu5nT9
         K7JzOKE/TZEXEIPqS44K2FUH9NRRz4lXNHu/rS05C+65GUtGogob6V0m0QxCfABCLqCG
         1d6Dtq//PJljQ0IQBwBRT1Qm+NXQosXWmpZnpFqDV++nf5qfcOJ0bfqJqi01xljSsIDZ
         hbUv8pR7OvCzGilTCLMgEuL/v1CkKPzC8J0Md8vuR4ZAvpU4qHlWAJwY4kohqDhY3R0P
         MbFUm+Ts0dvPiwl5LB/aUyADw/EXMTiAIyp2dJNzfjyJDdGNtEo/flF36AT53AtlxKDU
         uA8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781531164; x=1782135964;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/RKAlB+YaRvxl+nRljsm0vU9jlQ7EuTV00J5KLHppO0=;
        b=Ebl5NMjOlXzpfCbyEpjUp2SkSOoMYCs1O9QrnDQAtFjttCx6NVL2YENGw069emtdZh
         9wepqE+eY0ygcRebkIDRnfcGA9L6F8itVj056h1NCFu/H31lZ2RR85FGYDw6zDCXEoGH
         soi2NR3igsK1dTFLe61e5BwZ/McSdNzY7a2ZewIzuZ6Q498ugQj00BO0rSN00UWk9xyG
         O2r0XkLbkEE6qAvtSknPnXmWFI1kyJKm9G7XC6CThRK6gw7qfAzj1wyXmTo6Y9nirDN3
         jaDUJspmjz2GtimlBmQTEUrK5m7Z5RzxlcRWmC23lwBRaE3QVjBw5PoY0zDI0jirFebV
         oDqA==
X-Forwarded-Encrypted: i=1; AFNElJ9mJXKm9mqx91pURa8QzjK3qHj20Te4QdcP+QAe0cMg9+upGvrSvi27D5lA9tl6U9vALp9nYi4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzmMCDGxPQf3sYNkTor0o/z1o+L8iMe/bd9tHgbgG91pl94Buxc
	N9pkCNtpBya62dRqTguA4zt18KNt0RoJ2jfI2MhoPWf8U4dxyKA0d1TKC/MVOthAZd6zx75Wmbj
	wZUlbcmOEpZEoVlr9SJfW3a0Uee+/UiM/Mf+vePwG
X-Gm-Gg: Acq92OFuOnycU7o2p0n5Vodbr1MmojK6RzwhuJAZwYdhFyOedub7qQxP/YOcfqJwtaT
	UnnUBYeOkD3e1SMoehVDovJ8FzPzXzy2TFdIM2cIZe6MVXY8XR/uxkKbThauEeXdHGGH05O6smm
	WJPP6Y8nXghsok5DACZZGWegj560xIkGCqYXXICPKyXPVxWafGumvVzSSNmymxgkUYp7ivhbuRW
	0FlNz++10VJ2jaQOOzs+/FQztGqq1FpFTB5nkBUOs/qSdeJzlG/N7kIiZw+wXl9l4IGLGXvq7I4
	sZH9XDXO
X-Received: by 2002:ac8:5f8a:0:b0:516:4f62:85e8 with SMTP id
 d75a77b69052e-5198750abeemr1738961cf.19.1781531162997; Mon, 15 Jun 2026
 06:46:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com> <20260612065925.755562-7-tabba@google.com>
 <ai_7FupwNYrudRZZ@google.com>
In-Reply-To: <ai_7FupwNYrudRZZ@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 15 Jun 2026 14:45:26 +0100
X-Gm-Features: AVVi8CcBOTp5hYc_iBrEzUZ8L0F0F3uPeIwH6JYDOoas1UfKjcpvzwA29hjvFhE
Message-ID: <CA+EHjTxZ6WG3ugDq94q5PBuYXQf9b8tpVPpi1ro+wqPUozYEUA@mail.gmail.com>
Subject: Re: [PATCH v1 06/11] KVM: arm64: Factor out reusable vCPU reset helpers
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Per Larsen <perlarsen@google.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Jonathan Cameron <jonathan.cameron@huawei.com>, 
	Hyunwoo Kim <imv4bel@gmail.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 15 Jun 2026 at 14:16, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Fri, Jun 12, 2026 at 07:59:20AM +0100, tabba@google.com wrote:
> > Pull the reusable pieces out of kvm_reset_vcpu(): expose the reset
> > PSTATE values in kvm_arm.h, and split the core register reset and the
> > PSCI-driven reset into kvm_reset_vcpu_core() and kvm_reset_vcpu_psci().
> > A follow-up series reuses these to reset protected vCPUs at EL2.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_arm.h     | 12 ++++++
> >  arch/arm64/include/asm/kvm_emulate.h | 58 +++++++++++++++++++++++++++
> >  arch/arm64/kvm/reset.c               | 60 ++--------------------------
> >  3 files changed, 73 insertions(+), 57 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index 3f9233b5a130..aba4ec09acd2 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -348,4 +348,16 @@
> >       { PSR_AA32_MODE_UND,    "32-bit UND" }, \
> >       { PSR_AA32_MODE_SYS,    "32-bit SYS" }
> >
> > +/*
> > + * ARMv8 Reset Values
> > + */
> > +#define VCPU_RESET_PSTATE_EL1        (PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
> > +                              PSR_F_BIT | PSR_D_BIT)
> > +
> > +#define VCPU_RESET_PSTATE_EL2        (PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
> > +                              PSR_F_BIT | PSR_D_BIT)
> > +
> > +#define VCPU_RESET_PSTATE_SVC        (PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
> > +                              PSR_AA32_I_BIT | PSR_AA32_F_BIT)
> > +
> >  #endif /* __ARM64_KVM_ARM_H__ */
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > index aed9fc0b717b..8436e71c402d 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -704,4 +704,62 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
> >                       vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
> >       }
> >  }
> > +
> > +/* Reset a vcpu's core registers. */
> > +static inline void kvm_reset_vcpu_core(struct kvm_vcpu *vcpu)
> > +{
> > +     u32 pstate;
> > +
> > +     if (vcpu_el1_is_32bit(vcpu)) {
> > +             pstate = VCPU_RESET_PSTATE_SVC;
> > +     } else if (vcpu_has_nv(vcpu)) {
> > +             pstate = VCPU_RESET_PSTATE_EL2;
> > +     } else {
> > +             pstate = VCPU_RESET_PSTATE_EL1;
> > +     }
>
> nit: no brackes here, actually there were none before.

Ack.
/fuad

>
> > +
> > +     /* Reset core registers */
> > +     memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
> > +     memset(&vcpu->arch.ctxt.fp_regs, 0, sizeof(vcpu->arch.ctxt.fp_regs));
> > +     vcpu->arch.ctxt.spsr_abt = 0;
> > +     vcpu->arch.ctxt.spsr_und = 0;
> > +     vcpu->arch.ctxt.spsr_irq = 0;
> > +     vcpu->arch.ctxt.spsr_fiq = 0;
> > +     vcpu_gp_regs(vcpu)->pstate = pstate;
> > +}
> > +
> > +/* PSCI reset handling for a vcpu. */
> > +static inline void kvm_reset_vcpu_psci(struct kvm_vcpu *vcpu,
> > +                                    struct vcpu_reset_state *reset_state)
> > +{
> > +     unsigned long target_pc = reset_state->pc;
> > +
> > +     /* Gracefully handle Thumb2 entry point */
> > +     if (vcpu_mode_is_32bit(vcpu) && (target_pc & 1)) {
> > +             target_pc &= ~1UL;
> > +             vcpu_set_thumb(vcpu);
> > +     }
> > +
> > +     /* Propagate caller endianness */
> > +     if (reset_state->be)
> > +             kvm_vcpu_set_be(vcpu);
> > +
> > +     *vcpu_pc(vcpu) = target_pc;
> > +
> > +     /*
> > +      * We may come from a state where either a PC update was
> > +      * pending (SMC call resulting in PC being increpented to
> > +      * skip the SMC) or a pending exception. Make sure we get
> > +      * rid of all that, as this cannot be valid out of reset.
> > +      *
> > +      * Note that clearing the exception mask also clears PC
> > +      * updates, but that's an implementation detail, and we
> > +      * really want to make it explicit.
> > +      */
> > +     vcpu_clear_flag(vcpu, PENDING_EXCEPTION);
> > +     vcpu_clear_flag(vcpu, EXCEPT_MASK);
> > +     vcpu_clear_flag(vcpu, INCREMENT_PC);
> > +     vcpu_set_reg(vcpu, 0, reset_state->r0);
> > +}
> > +
> >  #endif /* __ARM64_KVM_EMULATE_H__ */
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index 60969d90bdd3..e22d0be9e57c 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -34,18 +34,6 @@
> >  static u32 __ro_after_init kvm_ipa_limit;
> >  unsigned int __ro_after_init kvm_host_sve_max_vl;
> >
> > -/*
> > - * ARMv8 Reset Values
> > - */
> > -#define VCPU_RESET_PSTATE_EL1        (PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
> > -                              PSR_F_BIT | PSR_D_BIT)
> > -
> > -#define VCPU_RESET_PSTATE_EL2        (PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
> > -                              PSR_F_BIT | PSR_D_BIT)
> > -
> > -#define VCPU_RESET_PSTATE_SVC        (PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
> > -                              PSR_AA32_I_BIT | PSR_AA32_F_BIT)
> > -
> >  unsigned int __ro_after_init kvm_sve_max_vl;
> >
> >  int __init kvm_arm_init_sve(void)
> > @@ -191,7 +179,6 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >  {
> >       struct vcpu_reset_state reset_state;
> >       bool loaded;
> > -     u32 pstate;
> >
> >       scoped_guard(spinlock, &vcpu->arch.mp_state_lock) {
> >               reset_state = vcpu->arch.reset_state;
> > @@ -210,21 +197,8 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >               kvm_vcpu_reset_sve(vcpu);
> >       }
> >
> > -     if (vcpu_el1_is_32bit(vcpu))
> > -             pstate = VCPU_RESET_PSTATE_SVC;
> > -     else if (vcpu_has_nv(vcpu))
> > -             pstate = VCPU_RESET_PSTATE_EL2;
> > -     else
> > -             pstate = VCPU_RESET_PSTATE_EL1;
> > -
> >       /* Reset core registers */
> > -     memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
> > -     memset(&vcpu->arch.ctxt.fp_regs, 0, sizeof(vcpu->arch.ctxt.fp_regs));
> > -     vcpu->arch.ctxt.spsr_abt = 0;
> > -     vcpu->arch.ctxt.spsr_und = 0;
> > -     vcpu->arch.ctxt.spsr_irq = 0;
> > -     vcpu->arch.ctxt.spsr_fiq = 0;
> > -     vcpu_gp_regs(vcpu)->pstate = pstate;
> > +     kvm_reset_vcpu_core(vcpu);
> >
> >       /* Reset system registers */
> >       kvm_reset_sys_regs(vcpu);
> > @@ -233,36 +207,8 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >        * Additional reset state handling that PSCI may have imposed on us.
> >        * Must be done after all the sys_reg reset.
> >        */
> > -     if (reset_state.reset) {
> > -             unsigned long target_pc = reset_state.pc;
> > -
> > -             /* Gracefully handle Thumb2 entry point */
> > -             if (vcpu_mode_is_32bit(vcpu) && (target_pc & 1)) {
> > -                     target_pc &= ~1UL;
> > -                     vcpu_set_thumb(vcpu);
> > -             }
> > -
> > -             /* Propagate caller endianness */
> > -             if (reset_state.be)
> > -                     kvm_vcpu_set_be(vcpu);
> > -
> > -             *vcpu_pc(vcpu) = target_pc;
> > -
> > -             /*
> > -              * We may come from a state where either a PC update was
> > -              * pending (SMC call resulting in PC being increpented to
> > -              * skip the SMC) or a pending exception. Make sure we get
> > -              * rid of all that, as this cannot be valid out of reset.
> > -              *
> > -              * Note that clearing the exception mask also clears PC
> > -              * updates, but that's an implementation detail, and we
> > -              * really want to make it explicit.
> > -              */
> > -             vcpu_clear_flag(vcpu, PENDING_EXCEPTION);
> > -             vcpu_clear_flag(vcpu, EXCEPT_MASK);
> > -             vcpu_clear_flag(vcpu, INCREMENT_PC);
> > -             vcpu_set_reg(vcpu, 0, reset_state.r0);
> > -     }
> > +     if (reset_state.reset)
> > +             kvm_reset_vcpu_psci(vcpu, &reset_state);
> >
> >       /* Reset timer */
> >       kvm_timer_vcpu_reset(vcpu);
> > --
> > 2.54.0.1136.gdb2ca164c4-goog
> >
