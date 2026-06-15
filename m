Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C74410D09
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 16:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781541935; cv=pass; b=lxIs77GPv1bAGLxQDAcJh8LcJRXwQ7EeFyC4nFKQLx/pxybBrK969re9PwiqW/AbvMkOJo6ohneYD134m2xr+op4+xJykDnOMh5i/L7Vmd7MZNBSkYGcHWkZZA+bSao8T0EKJk1M6wdaIOguLV7Z4UyNn4U+CQli7vld+WZl8GQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781541935; c=relaxed/simple;
	bh=xWUhA/0lq10UvwJRj7MXS8sQzC6/e3eLli+NGwl1vOA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DFd6gDkSsqBwjE0YIQNvsMEw3CZWG6cBK8GuvpzFjlPADoBv1YV7OwsLPkl2Q5INOmHS1TVQqYkm+kKM7dzdVjb6ZeYskrHIKxrOLSCdENoJsD6HF+6Qtshnci5LAhsAEZpqFDCKUDVHVrEUhvKES+84Gn9BDHuqRGtJHNma53E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OYS+hcHU; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OYS+hcHU"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5177d1ff061so2091cf.1
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 09:45:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781541933; cv=none;
        d=google.com; s=arc-20240605;
        b=Cez5//nbj+X5lRBPNvE0TpHyNGhyOndLdtDL8xO/eNMcjcikB+dSjZoLpn3tWSC7nf
         ODRmkkvVJNkqON1WBQDNn1Hk8+oM+sllj28h+cWCZ9iLaNhhTC6Wz03VDnvtXKwq+0IJ
         O43T0n5E+F5Fe8uxz0Qeszd/kRtkkWblz0BI6/+pM1AOtWvlPI/IG//uJcfVp/Hy6VTt
         bhrkqUmrNIjORRykpb/w5tMwH9ZnSRbIGzSgun8lrg7S7XiumASi3KYW1ApMW+tXrOxe
         VxD6CJGf3pigX0Ut65LU2hE/4PPaO3wq1j4OCDIx3+I/2csvVwrbWl8G8Qr4+3ZANXPP
         2B7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=3krBd1Av13C4zrCndwKnVgU8OIvOPDTh7R6zvOPGFpQ=;
        fh=R/66GOxWLd2myjSCu+W4YVVMkDmlPY6QekQnnvUFr0c=;
        b=ZymtBthLw9DcdnbIGKT2CbdmA2Ru2pvGHCilhTB+Zz46NODsPmAcQfJXykLnpelzTs
         x8f9Ol7xog637Lgq3xV5BxJMB+cz4sZBMo9b27wF84u/asktnttZ41CfBgdWZlYj9oUo
         IuZ8/0S1Ct66aq75PoLOLRlpWHnIbei0vGXxjw8lD51WwL3g1ills1lUt72Y9lL3lATq
         SOuwcFc1gxySvKeb2YGt6rYljKVVDNMqZIm+6U/Dhs9AIHJ9M3ER+xgfBmLh1y7S64eA
         YkjYCFD/DFSNInjKnTDe5cBYjV94FIN9BfJSoLQgXyx1733zRzOF2Gc6FuT7KdcmOqiD
         jkMg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781541933; x=1782146733; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3krBd1Av13C4zrCndwKnVgU8OIvOPDTh7R6zvOPGFpQ=;
        b=OYS+hcHUZCLWHM5XjAtvG5WkgwTQugxqZGbdO2mw5yHEZ8GlQve5mkZ//6TeHhUIwH
         vzhQzcrbVs7V9UgVjC614PjZtl2pEEhl4ESZZs+ejlJUkZWCbiTOfCxydUx28GV2AZHr
         KREynB7C0hQkHBUiakmGKTs1R/J8WYiuk2SuQwZ1VY4ESi7znXKFN+gBtxx6UR9Yi0X7
         MRDzdxeOr0W2XTFhmtEiMu+NkxnQM/LdRGNmwwx9CTJDI66rBzPgQEuMZ+UGSh+NXlNF
         pr6DrAcr55XygXO4fZZREwY3yuiaxo8LX8qJhB50Fao6fwMqMOgyaXXy9oM2oHxF2PiG
         WbhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781541933; x=1782146733;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3krBd1Av13C4zrCndwKnVgU8OIvOPDTh7R6zvOPGFpQ=;
        b=IZwM+qMWINhX4OaeaNXi7ZxmLf7DYHrSJEvbNXvUad0HVoSRIeKHOydkZXtP8Av+7l
         XbTHoAt+5YypYOZldE7mPuj8+sPBtJIYVEVGN1Z2Zigb+vLcta+IqYwxtibc1QyeO+Wn
         gtcxYPt2tKXYM2GSrVA/LBIQMYzneNdSOaAz7A7maJAtkDs6cgxikkKgmjSNK/Ms9KdA
         OpiJkzHvCXieTBhYz7RAMYvoectKuzXOXHb3SzJ6nd/StmIgc4DCM59O75VSjWvvcnEG
         J18Jy/XgkFpJxMSBwsQOg5rznOsn5HWM4ciYxQR/4M006ayJdp1r+yp4S63dLvDXQYOj
         Leyg==
X-Forwarded-Encrypted: i=1; AFNElJ/J2+IyrddOdaRQ0YS8+28BAfskNjQqaeqUi9TmS3qLIsDQ06k+mZzm3WBARz7aShA/3w8/yhY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxo2nmWU3esPZH0QzVzyFQYWgup3pguPb2vscixNlFcHepN/fkw
	7TI6WKs8vk09YZudzsLLDv46Ean5fp6cFD/eV+GOwjW0xjEK4I1oTJTdJmT+T71K54FCr3Cru7l
	HxjT+xZPpfv68o7RB6+bmVUPZL8e0EdVwdW8defBY
X-Gm-Gg: Acq92OExzln+a+1ups+Tv1JV6f7g5Sb+s00dQsQF+LU7mi4p2UIK7YpEjJCIOSbNMSi
	fUPLrfgkAq1YGllsoixzVvz3y0/zAZQvTXkBt5PdCg//68pRWJXrSLnr4VeNmiYt7iEwsCo5d06
	Mry+nU8JLeg/xAI1wyJpbeSNN6p5kI4LpDNFgFPZl0AhdzWDX5mieGfyLyVmWbQkRUE6Kq6L2yD
	ABXhfuIFpf/Awnr4rtzvXdzJzxdBQs8JYJP7yWvXt26uubbJEKaO9vzJXzP5H7no3U61Y4XlxBd
	w9BSeg0T
X-Received: by 2002:a05:622a:4a8e:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-5198e56ccdemr563981cf.5.1781541932277; Mon, 15 Jun 2026
 09:45:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com> <20260612065925.755562-12-tabba@google.com>
 <ajAncPp3nOGcWD1U@google.com>
In-Reply-To: <ajAncPp3nOGcWD1U@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 15 Jun 2026 17:44:55 +0100
X-Gm-Features: AVVi8CfTSYIzqCKnssnDztP6oKs3xPOt3CjdkdvwnsXEforHJwvYbHgF5IGB21A
Message-ID: <CA+EHjTy=U4Nv1e3iS_39+yWsaRs+7nw+R9JLGZ+E9maqmiJfPw@mail.gmail.com>
Subject: Re: [PATCH v1 11/11] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
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

On Mon, 15 Jun 2026 at 17:25, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Fri, Jun 12, 2026 at 07:59:25AM +0100, tabba@google.com wrote:
> > pKVM copies a non-protected guest's register context between the host
> > and the hypervisor on every world switch, even when the host never
> > inspects it. Defer the copy: on entry, flush the host context into the
> > hyp vCPU only when the host marked it dirty (PKVM_HOST_STATE_DIRTY); on
> > exit, leave it in the hyp vCPU and copy it back only when the host needs
> > it, via a __pkvm_vcpu_sync_state hypercall on trap handling or at vcpu
> > put. A protected guest's context is copied as before, since lazy sync
> > only helps where the host is trusted to see the guest's registers.
> >
> > The PC is the exception: it is copied back on every exit so the
> > kvm_exit tracepoint reports the guest's real exit PC rather than the
> > value left by the previous sync.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h   |  1 +
> >  arch/arm64/include/asm/kvm_host.h  |  2 +
> >  arch/arm64/kvm/arm.c               |  7 +++
> >  arch/arm64/kvm/handle_exit.c       | 22 ++++++++
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 88 ++++++++++++++++++++++++++++--
> >  5 files changed, 115 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 043495f7fc78..6e1135b3ded4 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -113,6 +113,7 @@ enum __kvm_host_smccc_func {
> >       __KVM_HOST_SMCCC_FUNC___pkvm_finalize_teardown_vm,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
> > +     __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_sync_state,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
> >
> >       MARKER(__KVM_HOST_SMCCC_FUNC_MAX)
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index a49042bfa801..1ef660774adc 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1113,6 +1113,8 @@ struct kvm_vcpu_arch {
> >  /* SError pending for nested guest */
> >  #define NESTED_SERROR_PENDING        __vcpu_single_flag(sflags, BIT(8))
> >
> > +/* pKVM host vcpu state is dirty, needs resync (nVHE-only) */
>
> nit: with hVHE, I guess we can just drop that nVHE-only?

Ack.


>
> > +#define PKVM_HOST_STATE_DIRTY        __vcpu_single_flag(iflags, BIT(4))
> >
> >  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> >  #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +   \
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index c9f36932c980..a5c54e37778b 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -734,6 +734,10 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >       if (is_protected_kvm_enabled()) {
> >               kvm_call_hyp(__vgic_v3_save_aprs, &vcpu->arch.vgic_cpu.vgic_v3);
> >               kvm_call_hyp_nvhe(__pkvm_vcpu_put);
> > +
> > +             /* __pkvm_vcpu_put implies a sync of the state */
> > +             if (!kvm_vm_is_protected(vcpu->kvm))
> > +                     vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> >       }
> >
> >       kvm_vcpu_put_debug(vcpu);
> > @@ -961,6 +965,9 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
> >               return ret;
> >
> >       if (is_protected_kvm_enabled()) {
> > +             /* Start with the vcpu in a dirty state */
> > +             if (!kvm_vm_is_protected(vcpu->kvm))
> > +                     vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> >               ret = pkvm_create_hyp_vm(kvm);
> >               if (ret)
> >                       return ret;
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index 54aedf93c78b..dccc3786548b 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -422,6 +422,21 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu)
> >  {
> >       int handled;
> >
> > +     /*
> > +      * If we run a non-protected VM when protection is enabled
> > +      * system-wide, resync the state from the hypervisor and mark
> > +      * it as dirty on the host side if it wasn't dirty already
> > +      * (which could happen if preemption has taken place).
> > +      */
> > +     if (is_protected_kvm_enabled() && !kvm_vm_is_protected(vcpu->kvm)) {
> > +             preempt_disable();
>
> nit: since we are introducing guard() with that series, this one could be
> guard(preempt)().

Nice one :) Done.


>
> > +             if (!(vcpu_get_flag(vcpu, PKVM_HOST_STATE_DIRTY))) {
> > +                     kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> > +                     vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> > +             }
> > +             preempt_enable();
> > +     }
> > +
> >       /*
> >        * See ARM ARM B1.14.1: "Hyp traps on instructions
> >        * that fail their condition code check"
> > @@ -489,6 +504,13 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
> >  /* For exit types that need handling before we can be preempted */
> >  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
> >  {
> > +     /*
> > +      * We just exited, so the state is clean from a hypervisor
> > +      * perspective.
> > +      */
> > +     if (is_protected_kvm_enabled())
> > +             vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> > +
> >       if (ARM_SERROR_PENDING(exception_index)) {
> >               if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
> >                       u64 disr = kvm_vcpu_get_disr(vcpu);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index 23e644c24a03..02383b372258 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -139,6 +139,49 @@ static void sync_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> >               host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
> >  }
> >
> > +
> > +static void __copy_vcpu_state(const struct kvm_vcpu *from_vcpu,
> > +                           struct kvm_vcpu *to_vcpu)
> > +{
> > +     int i;
> > +
> > +     to_vcpu->arch.ctxt.regs         = from_vcpu->arch.ctxt.regs;
> > +     to_vcpu->arch.ctxt.spsr_abt     = from_vcpu->arch.ctxt.spsr_abt;
> > +     to_vcpu->arch.ctxt.spsr_und     = from_vcpu->arch.ctxt.spsr_und;
> > +     to_vcpu->arch.ctxt.spsr_irq     = from_vcpu->arch.ctxt.spsr_irq;
> > +     to_vcpu->arch.ctxt.spsr_fiq     = from_vcpu->arch.ctxt.spsr_fiq;
> > +     to_vcpu->arch.ctxt.fp_regs      = from_vcpu->arch.ctxt.fp_regs;
> > +
> > +     /*
> > +      * Copy the sysregs, but don't mess with the timer state which
> > +      * is directly handled by EL1 and is expected to be preserved.
> > +      * enum vcpu_sysreg is sparse: VNCR-mapped registers take values
> > +      * derived from their VNCR page offset, so the timer registers do
> > +      * not form a contiguous numeric range and must be skipped by name.
> > +      */
> > +     for (i = 1; i < NR_SYS_REGS; i++) {
> > +             switch (i) {
> > +             case CNTVOFF_EL2:
> > +             case CNTV_CVAL_EL0:
> > +             case CNTV_CTL_EL0:
> > +             case CNTP_CVAL_EL0:
> > +             case CNTP_CTL_EL0:
> > +                     continue;
> > +             }
> > +             to_vcpu->arch.ctxt.sys_regs[i] = from_vcpu->arch.ctxt.sys_regs[i];
> > +     }
> > +}
> > +
> > +static void __sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +     __copy_vcpu_state(&hyp_vcpu->vcpu, hyp_vcpu->host_vcpu);
> > +}
> > +
> > +static void __flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +     __copy_vcpu_state(hyp_vcpu->host_vcpu, &hyp_vcpu->vcpu);
> > +}
>
> nit: Could that be flush/sync_hyp_vcpu_state? as everything this is called
> "state" and we already have flush_debug_state() below ?

Good point, renamed to flush_hyp_vcpu_state()/sync_hyp_vcpu_state().

>
> > +
> >  static void flush_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> >  {
> >       struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> > @@ -168,7 +211,17 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> >       fpsimd_sve_flush();
> >       flush_debug_state(hyp_vcpu);
> >
> > -     hyp_vcpu->vcpu.arch.ctxt        = host_vcpu->arch.ctxt;
> > +     /*
> > +      * If we deal with a non-protected guest and the state is potentially
> > +      * dirty (from a host perspective), copy the state back into the hyp
> > +      * vcpu.
> > +      */
> > +     if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> > +             if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
> > +                     __flush_hyp_vcpu(hyp_vcpu);
> > +     } else {
> > +             hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;
> > +     }
> >
> >       hyp_vcpu->vcpu.arch.mdcr_el2    = host_vcpu->arch.mdcr_el2;
> >       hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
> > @@ -191,9 +244,11 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> >       fpsimd_sve_sync(&hyp_vcpu->vcpu);
> >       sync_debug_state(hyp_vcpu);
> >
> > -     host_vcpu->arch.ctxt            = hyp_vcpu->vcpu.arch.ctxt;
> > -
> > -     host_vcpu->arch.hcr_el2         = hyp_vcpu->vcpu.arch.hcr_el2;
> > +     if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> > +             host_vcpu->arch.ctxt = hyp_vcpu->vcpu.arch.ctxt;
> > +     else
> > +             /* Keep the PC current for the kvm_exit tracepoint (lazy ctxt sync). */
> > +             host_vcpu->arch.ctxt.regs.pc = hyp_vcpu->vcpu.arch.ctxt.regs.pc;
> >
> >       host_vcpu->arch.fault           = hyp_vcpu->vcpu.arch.fault;
> >
> > @@ -227,8 +282,30 @@ static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
> >  {
> >       struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
> >
> > -     if (hyp_vcpu)
> > +     if (hyp_vcpu) {
> > +             struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> > +
> > +             if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu) &&
> > +                 !vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY)) {
> > +                     __sync_hyp_vcpu(hyp_vcpu);
> > +             }
> > +
> >               pkvm_put_hyp_vcpu(hyp_vcpu);
> > +     }
> > +}
> > +
> > +static void handle___pkvm_vcpu_sync_state(struct kvm_cpu_context *host_ctxt)
> > +{
> > +     struct pkvm_hyp_vcpu *hyp_vcpu;
> > +
> > +     if (!is_protected_kvm_enabled())
> > +             return;
>
> Since "KVM: arm64: Remove is_protected_kvm_enabled() checks from hypercalls" we
> got rid of those is_protected_kvm_enabled() for pKVM-only HVCs. (also, it is
> declared in the pKVM-only section of the HVCs)

Dropped.

Thanks a lot for the reviews!
/fuad
>
> > +
> > +     hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
> > +     if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> > +             return;
> > +
> > +     __sync_hyp_vcpu(hyp_vcpu);
> >  }
> >
> >  static struct kvm_vcpu *__get_host_hyp_vcpus(struct kvm_vcpu *arg,
> > @@ -859,6 +936,7 @@ static const hcall_t host_hcall[] = {
> >       HANDLE_FUNC(__pkvm_finalize_teardown_vm),
> >       HANDLE_FUNC(__pkvm_vcpu_load),
> >       HANDLE_FUNC(__pkvm_vcpu_put),
> > +     HANDLE_FUNC(__pkvm_vcpu_sync_state),
> >       HANDLE_FUNC(__pkvm_tlb_flush_vmid),
> >  };
> >
> > --
> > 2.54.0.1136.gdb2ca164c4-goog
> >
