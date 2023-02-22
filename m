Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6521C17
	for <kvmarm@lists.linux.dev>; Wed, 22 Feb 2023 06:16:13 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id a26so3926160pfo.9
        for <kvmarm@lists.linux.dev>; Tue, 21 Feb 2023 22:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OOHE5bcvbJglO2qMLDF+0er9kK9T4WlxH8MzRHgoGOM=;
        b=o1c/luXxc96CEo8vXtQ85teB9ljRqnp0LHxojIZozunRAfndyMcUaaUA9zAD9HiBaJ
         vwrX36tNQg3ulWtJ1soq4vuSeMwRIIovKHjbOyS5AXFxzP6/L30f/7Bfi1wnrx24r/6h
         lV3e73ggcYCGvm20g3LQ3BbPojjaM0vVF0jOlq5wHsTdaoX/YvK+bvow7hEouyBGTK0+
         l5uAyV9vPkrlLiKxudKMnPqQADyAoXEeI70B0lMX4x+l2YbtiDI5/6aEGTxse0x5DTLV
         HDmUBAClHCyi/Tz5z/OO1a+XGsN0Xtq758PZyHPJV0M+5KrqBRQTR9yUz9ZOdoYh+KgI
         JLbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OOHE5bcvbJglO2qMLDF+0er9kK9T4WlxH8MzRHgoGOM=;
        b=VWjy2lArpTrpq0tqgxI8Pjg1Hl3WaF9h3lVIU7ZV60wgbez5q0ImO9aNSRqp1vPQi5
         Si0FzU+SNf8prhns0ord4ISmz63oR8aZz9EjwG5JTRug7T9QB3HVLXKl2i4LUYLRu2OM
         MGOP7wkJ3sEUia7earF2WJ8asypywEqGx14onQ0m+WkeUnNpmVb1gt4jb349AiZcuD+o
         3lw0QuqBtTUu59+FqQJ8/GZoMNgD/2ipDW/9JBlx5PYfu6SVMx7KGbFUxF6klEwTuMj/
         JnyfGoVDZkYbPbSYzvXXAuhwqMI+ELP4Db+dXYnY/upyusvQ5MIsZdTjR9A8dnK5wh+D
         hEww==
X-Gm-Message-State: AO0yUKVRwjJ4JT+hq1v8duEFjuenz98CaS85ewrvcDtdSVCvPRL3/kv9
	oLWONL6O5IqYTelDWfRl+fzJlO8/qdc0xM4fHhTgnw==
X-Google-Smtp-Source: AK7set9I1lCeE4XFXXSIIlNrSyHrg/+7kPuxlKajTfoRYBvLIlhTbhHDE5BqEg7jHuTqFmHoFMAGxQJ+tn0dztcjPp8=
X-Received: by 2002:a62:8450:0:b0:5a8:b948:6ae8 with SMTP id
 k77-20020a628450000000b005a8b9486ae8mr971128pfd.29.1677046572803; Tue, 21 Feb
 2023 22:16:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230216142123.2638675-1-maz@kernel.org> <20230216142123.2638675-6-maz@kernel.org>
In-Reply-To: <20230216142123.2638675-6-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 21 Feb 2023 22:15:56 -0800
Message-ID: <CAAeT=FymvmeQepDBp_r1XVg4-jGT-KejPDbrbf2yV=FtPFYWbg@mail.gmail.com>
Subject: Re: [PATCH 05/16] KVM: arm64: timers: Convert per-vcpu virtual offset
 to a global value
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, 
	Simon Veith <sveith@amazon.de>, dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Thu, Feb 16, 2023 at 6:21 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Having a per-vcpu virtual offset is a pain. It needs to be synchronized
> on each update, and expands badly to a setup where different timers can
> have different offsets, or have composite offsets (as with NV).
>
> So let's start by replacing the use of the CNTVOFF_EL2 shadow register
> (which we want to reclaim for NV anyway), and make the virtual timer
> carry a pointer to a VM-wide offset.

That's nice!

>
> This simplifies the code significantly.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  arch/arm64/kvm/arch_timer.c       | 45 +++++++------------------------
>  arch/arm64/kvm/hypercalls.c       |  2 +-
>  include/kvm/arm_arch_timer.h      | 15 +++++++++++
>  4 files changed, 29 insertions(+), 36 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2a8175f38439..3adac0c5e175 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -193,6 +193,9 @@ struct kvm_arch {
>         /* Interrupt controller */
>         struct vgic_dist        vgic;
>
> +       /* Timers */
> +       struct arch_timer_vm_offsets offsets;

Nit: Perhaps using a more explicit name for the 'offsets' field might
be better than simply 'offsets', since it is a field of kvm_arch (not
a field of arch timer related struct).
(e.g. timer_offsets ?)

> +
>         /* Mandated version of PSCI */
>         u32 psci_version;
>
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 329a8444724f..1bb44f668608 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -84,14 +84,10 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
>
>  static u64 timer_get_offset(struct arch_timer_context *ctxt)
>  {
> -       struct kvm_vcpu *vcpu = ctxt->vcpu;
> +       if (ctxt->offset.vm_offset)
> +               return *ctxt->offset.vm_offset;
>
> -       switch(arch_timer_ctx_index(ctxt)) {
> -       case TIMER_VTIMER:
> -               return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
> -       default:
> -               return 0;
> -       }
> +       return 0;
>  }
>
>  static void timer_set_ctl(struct arch_timer_context *ctxt, u32 ctl)
> @@ -128,15 +124,12 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
>
>  static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>  {
> -       struct kvm_vcpu *vcpu = ctxt->vcpu;
> -
> -       switch(arch_timer_ctx_index(ctxt)) {
> -       case TIMER_VTIMER:
> -               __vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
> -               break;
> -       default:
> +       if (!ctxt->offset.vm_offset) {
>                 WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
> +               return;
>         }
> +
> +       WRITE_ONCE(*ctxt->offset.vm_offset, offset);
>  }
>
>  u64 kvm_phys_timer_read(void)
> @@ -765,25 +758,6 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
>         return 0;
>  }
>
> -/* Make the updates of cntvoff for all vtimer contexts atomic */
> -static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
> -{
> -       unsigned long i;
> -       struct kvm *kvm = vcpu->kvm;
> -       struct kvm_vcpu *tmp;
> -
> -       mutex_lock(&kvm->lock);
> -       kvm_for_each_vcpu(i, tmp, kvm)
> -               timer_set_offset(vcpu_vtimer(tmp), cntvoff);
> -
> -       /*
> -        * When called from the vcpu create path, the CPU being created is not
> -        * included in the loop above, so we just set it here as well.
> -        */
> -       timer_set_offset(vcpu_vtimer(vcpu), cntvoff);
> -       mutex_unlock(&kvm->lock);
> -}
> -
>  void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>  {
>         struct arch_timer_cpu *timer = vcpu_timer(vcpu);
> @@ -791,10 +765,11 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>         struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>
>         vtimer->vcpu = vcpu;
> +       vtimer->offset.vm_offset = &vcpu->kvm->arch.offsets.voffset;
>         ptimer->vcpu = vcpu;
>
>         /* Synchronize cntvoff across all vtimers of a VM. */
> -       update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
> +       timer_set_offset(vtimer, kvm_phys_timer_read());
>         timer_set_offset(ptimer, 0);
>
>         hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
> @@ -840,7 +815,7 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
>                 break;
>         case KVM_REG_ARM_TIMER_CNT:
>                 timer = vcpu_vtimer(vcpu);
> -               update_vtimer_cntvoff(vcpu, kvm_phys_timer_read() - value);
> +               timer_set_offset(timer, kvm_phys_timer_read() - value);
>                 break;
>         case KVM_REG_ARM_TIMER_CVAL:
>                 timer = vcpu_vtimer(vcpu);
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 64c086c02c60..169d629f97cb 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -44,7 +44,7 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
>         feature = smccc_get_arg1(vcpu);
>         switch (feature) {
>         case KVM_PTP_VIRT_COUNTER:
> -               cycles = systime_snapshot.cycles - vcpu_read_sys_reg(vcpu, CNTVOFF_EL2);
> +               cycles = systime_snapshot.cycles - vcpu->kvm->arch.offsets.voffset;
>                 break;
>         case KVM_PTP_PHYS_COUNTER:
>                 cycles = systime_snapshot.cycles;
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 76174f4fb646..41fda6255174 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -23,6 +23,19 @@ enum kvm_arch_timer_regs {
>         TIMER_REG_CTL,
>  };
>
> +struct arch_timer_offset {
> +       /*
> +        * If set, pointer to one of the offsets in the kvm's offset
> +        * structure. If NULL, assume a zero offset.
> +        */
> +       u64     *vm_offset;
> +};
> +
> +struct arch_timer_vm_offsets {
> +       /* Offset applied to the virtual timer/counter */
> +       u64     voffset;
> +};
> +
>  struct arch_timer_context {
>         struct kvm_vcpu                 *vcpu;
>
> @@ -33,6 +46,8 @@ struct arch_timer_context {
>         struct hrtimer                  hrtimer;
>         u64                             ns_frac;
>
> +       /* Offset for this counter/timer */
> +       struct arch_timer_offset        offset;
>         /*
>          * We have multiple paths which can save/restore the timer state onto
>          * the hardware, so we need some way of keeping track of where the
> --
> 2.34.1
>
>

It appears that we can remove CNTVOFF_EL2 from the sysreg file.
Having said that, I don't think it matters anyway since the
following patch appears to use that again.

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji
