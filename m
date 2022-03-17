Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16338C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 17:36:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6593D49F59;
	Thu, 17 Mar 2022 13:36:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LaM+Lu620qcM; Thu, 17 Mar 2022 13:36:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0254049EAE;
	Thu, 17 Mar 2022 13:36:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7D8B49EAE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 13:36:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vcCze8iFtSHv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Mar 2022 13:36:42 -0400 (EDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
 [209.85.167.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B62240BF0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 13:36:42 -0400 (EDT)
Received: by mail-lf1-f53.google.com with SMTP id t25so10206119lfg.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 10:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Km1+WLs5rrLSDyROV/f9OUca+QCvw6zcJNZtYw4V1uE=;
 b=VYxZYRTbkjvH6YCOY9RqDDSGEsrPYFLbOgwVeDHpf7nSmhoS7JUVZwUUnNprmnOAuv
 sZuJu0xUMTRAGyKf4uqMfacJQOhRwOXZ3pdrKISoZ/OaiY7yIJNEsZKihCeU9Uxrr0tD
 t5U0mSBDzmncCSY3A2KneHDwYbsUtyEQy74MIOos4bPoRHG4wyB2O83/xuyDn0DYHpqd
 CXCQHx5Tax8GOutoZ3cSZOZUYTK6HtgCXQ6IUzPteKBXOm6Adz2P0zx19gyXka+KkxxX
 53cTJIqjmtHVlDsFrA/TDi9t4ilJmbeEfHzs7HDS6S9fzA/vForzgTEE8KumPpaiEXQb
 EtVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Km1+WLs5rrLSDyROV/f9OUca+QCvw6zcJNZtYw4V1uE=;
 b=chFramu3a9f/w4X5MtDP71tAAbmPssQyqj+H/K9HJYs78ZTaSokZ0P5DyH1vVWvgbQ
 kAInOhOyqTn6GyCCnb3Wy0lic17Bt1wNrjV3vwC8M+BlclUUbuj+PPNqvnE5h5yR9EE1
 cj5F55WGLwdH0J5slqtJzHe51X65KJAZvl5/azW+4YUYZJJ/u3uQQW6yM1rX8qdUdy7r
 5OSmeUcYZ0pVY2+ykxI8vnO+MMD+ReL67rzr0hVDjBOFuZ1SYgZvy165IDgd+z/yJe0X
 6iLEVWqFvGm/9r5VdhE1Z3StE5TT3d3TBDJ0DkJ84k0q5+i+m+cySpSS7FkX9g7vBqt1
 P+2Q==
X-Gm-Message-State: AOAM531Ih9Nu4zmfEVSCaEx5pfN0ciOtmu+V+y8WL0lzMgJkTRXi2NMr
 /oJKsW1+Wht5rcL/hv0B10VXnHC8Nve5hbaTCv5y1Q==
X-Google-Smtp-Source: ABdhPJz083NOCfMPET/Tb2OX48rOXyJYY1kGgZeel9vCZPowq3a6lvhKBkmkJAP25bEbEdNtoQalCDQ0XJyRNZBPXIU=
X-Received: by 2002:a05:6512:3043:b0:447:b909:b868 with SMTP id
 b3-20020a056512304300b00447b909b868mr3677484lfb.286.1647538599092; Thu, 17
 Mar 2022 10:36:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220216031528.92558-1-chao.gao@intel.com>
 <20220216031528.92558-5-chao.gao@intel.com>
In-Reply-To: <20220216031528.92558-5-chao.gao@intel.com>
From: Oliver Upton <oupton@google.com>
Date: Thu, 17 Mar 2022 10:36:27 -0700
Message-ID: <CAOQ_QsgfnUMJD9XVCBbbA-dZryA2a2yBksmM6mGLZE-8ux_Wsg@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] KVM: arm64: Simplify the CPUHP logic
To: Chao Gao <chao.gao@intel.com>
Cc: kevin.tian@intel.com, Daniel Lezcano <daniel.lezcano@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 John Garry <john.garry@huawei.com>, linux-kernel@vger.kernel.org,
 Qi Liu <liuqi115@huawei.com>, Shaokun Zhang <zhangshaokun@hisilicon.com>,
 Will Deacon <will@kernel.org>, Thomas Richter <tmricht@linux.ibm.com>,
 maz@kernel.org, pbonzini@redhat.com, tglx@linutronix.de,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jia He <justin.he@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Feb 15, 2022 at 7:16 PM Chao Gao <chao.gao@intel.com> wrote:
>
> From: Marc Zyngier <maz@kernel.org>
>
> For a number of historical reasons, the KVM/arm64 hotplug setup is pretty
> complicated, and we have two extra CPUHP notifiers for vGIC and timers.
>
> It looks pretty pointless, and gets in the way of further changes.
> So let's just expose some helpers that can be called from the core
> CPUHP callback, and get rid of everything else.
>
> This gives us the opportunity to drop a useless notifier entry,
> as well as tidy-up the timer enable/disable, which was a bit odd.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Chao Gao <chao.gao@intel.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  arch/arm64/kvm/arch_timer.c     | 27 ++++++++++-----------------
>  arch/arm64/kvm/arm.c            |  4 ++++
>  arch/arm64/kvm/vgic/vgic-init.c | 19 ++-----------------
>  include/kvm/arm_arch_timer.h    |  4 ++++
>  include/kvm/arm_vgic.h          |  4 ++++
>  include/linux/cpuhotplug.h      |  3 ---
>  6 files changed, 24 insertions(+), 37 deletions(-)
>
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 6e542e2eae32..f9d14c6dc0b4 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -796,10 +796,18 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>         ptimer->host_timer_irq_flags = host_ptimer_irq_flags;
>  }
>
> -static void kvm_timer_init_interrupt(void *info)
> +void kvm_timer_cpu_up(void)
>  {
>         enable_percpu_irq(host_vtimer_irq, host_vtimer_irq_flags);
> -       enable_percpu_irq(host_ptimer_irq, host_ptimer_irq_flags);
> +       if (host_ptimer_irq)
> +               enable_percpu_irq(host_ptimer_irq, host_ptimer_irq_flags);
> +}
> +
> +void kvm_timer_cpu_down(void)
> +{
> +       disable_percpu_irq(host_vtimer_irq);
> +       if (host_ptimer_irq)
> +               disable_percpu_irq(host_ptimer_irq);
>  }
>
>  int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
> @@ -961,18 +969,6 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
>         preempt_enable();
>  }
>
> -static int kvm_timer_starting_cpu(unsigned int cpu)
> -{
> -       kvm_timer_init_interrupt(NULL);
> -       return 0;
> -}
> -
> -static int kvm_timer_dying_cpu(unsigned int cpu)
> -{
> -       disable_percpu_irq(host_vtimer_irq);
> -       return 0;
> -}
> -
>  static int timer_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
>  {
>         if (vcpu)
> @@ -1170,9 +1166,6 @@ int kvm_timer_hyp_init(bool has_gic)
>                 goto out_free_irq;
>         }
>
> -       cpuhp_setup_state(CPUHP_AP_KVM_ARM_TIMER_STARTING,
> -                         "kvm/arm/timer:starting", kvm_timer_starting_cpu,
> -                         kvm_timer_dying_cpu);
>         return 0;
>  out_free_irq:
>         free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 0165cf3aac3a..31b049e48b19 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1658,6 +1658,8 @@ static void _kvm_arch_hardware_enable(void *discard)
>  {
>         if (!__this_cpu_read(kvm_arm_hardware_enabled)) {
>                 cpu_hyp_reinit();
> +               kvm_vgic_cpu_up();
> +               kvm_timer_cpu_up();
>                 __this_cpu_write(kvm_arm_hardware_enabled, 1);
>         }
>  }
> @@ -1671,6 +1673,8 @@ int kvm_arch_hardware_enable(void)
>  static void _kvm_arch_hardware_disable(void *discard)
>  {
>         if (__this_cpu_read(kvm_arm_hardware_enabled)) {
> +               kvm_timer_cpu_down();
> +               kvm_vgic_cpu_down();
>                 cpu_hyp_reset();
>                 __this_cpu_write(kvm_arm_hardware_enabled, 0);
>         }
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index fc00304fe7d8..60038a8516de 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -460,17 +460,15 @@ int kvm_vgic_map_resources(struct kvm *kvm)
>
>  /* GENERIC PROBE */
>
> -static int vgic_init_cpu_starting(unsigned int cpu)
> +void kvm_vgic_cpu_up(void)
>  {
>         enable_percpu_irq(kvm_vgic_global_state.maint_irq, 0);
> -       return 0;
>  }
>
>
> -static int vgic_init_cpu_dying(unsigned int cpu)
> +void kvm_vgic_cpu_down(void)
>  {
>         disable_percpu_irq(kvm_vgic_global_state.maint_irq);
> -       return 0;
>  }
>
>  static irqreturn_t vgic_maintenance_handler(int irq, void *data)
> @@ -579,19 +577,6 @@ int kvm_vgic_hyp_init(void)
>                 return ret;
>         }
>
> -       ret = cpuhp_setup_state(CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
> -                               "kvm/arm/vgic:starting",
> -                               vgic_init_cpu_starting, vgic_init_cpu_dying);
> -       if (ret) {
> -               kvm_err("Cannot register vgic CPU notifier\n");
> -               goto out_free_irq;
> -       }
> -
>         kvm_info("vgic interrupt IRQ%d\n", kvm_vgic_global_state.maint_irq);
>         return 0;
> -
> -out_free_irq:
> -       free_percpu_irq(kvm_vgic_global_state.maint_irq,
> -                       kvm_get_running_vcpus());
> -       return ret;
>  }
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 51c19381108c..16a2f65fcfb4 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -106,4 +106,8 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
>  u32 timer_get_ctl(struct arch_timer_context *ctxt);
>  u64 timer_get_cval(struct arch_timer_context *ctxt);
>
> +/* CPU HP callbacks */
> +void kvm_timer_cpu_up(void);
> +void kvm_timer_cpu_down(void);
> +
>  #endif
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index bb30a6803d9f..a2a0cca05a73 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -427,4 +427,8 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
>  void vgic_v4_commit(struct kvm_vcpu *vcpu);
>  int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db);
>
> +/* CPU HP callbacks */
> +void kvm_vgic_cpu_up(void);
> +void kvm_vgic_cpu_down(void);
> +
>  #endif /* __KVM_ARM_VGIC_H */
> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> index 411a428ace4d..4345b8eafc03 100644
> --- a/include/linux/cpuhotplug.h
> +++ b/include/linux/cpuhotplug.h
> @@ -183,9 +183,6 @@ enum cpuhp_state {
>         CPUHP_AP_TI_GP_TIMER_STARTING,
>         CPUHP_AP_HYPERV_TIMER_STARTING,
>         CPUHP_AP_KVM_STARTING,
> -       CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
> -       CPUHP_AP_KVM_ARM_VGIC_STARTING,
> -       CPUHP_AP_KVM_ARM_TIMER_STARTING,
>         /* Must be the last timer callback */
>         CPUHP_AP_DUMMY_TIMER_STARTING,
>         CPUHP_AP_ARM_XEN_STARTING,
> --
> 2.25.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
