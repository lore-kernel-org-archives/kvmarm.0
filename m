Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D9FC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:44:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73729408D1;
	Tue, 10 May 2022 02:44:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OA3dld69285v; Tue, 10 May 2022 02:44:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2833C49EC3;
	Tue, 10 May 2022 02:44:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53AA4408D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 02:44:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TtU8JoJ5l487 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2022 02:44:22 -0400 (EDT)
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com
 [209.85.161.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD7B149673
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 02:44:22 -0400 (EDT)
Received: by mail-oo1-f49.google.com with SMTP id
 v33-20020a4a9764000000b0035f814bb06eso793059ooi.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 23:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=CW5UZ4AgQB2Ky6IXPjB3ZqVrefl3jQoEFA6bpgufh1I=;
 b=GaVfD/57+jd3+2igovESwyKyWfYy/IWY39JHxKP+hOpbfVQFlax+va1YkVQLCXvTRd
 0DYIsWlK10WLRcNR3aK6jUeyLHf4D4xVa1OM2SUdqaEfYu2mKL6ZU14wdYKnCQMFFXAl
 IrZvRumrZqcAj83Pl6Qe1F9Jx2x4M3JpUbrywH4BCXNaQHZF1p9x/YN0Blg21PXb5j/F
 jpNzG2AlgkqsrWmfKj6wc819r1yAaCoqTKn8vD7M5yYUEzYkvGH1Sgh8KWrIEvCDVrGt
 N078Iej+DoOyD+G+hKTFYQWUQjVcHeqpif8eXwKpKdyRyg03U+FSScqwetXGUEEqcJyY
 9SkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=CW5UZ4AgQB2Ky6IXPjB3ZqVrefl3jQoEFA6bpgufh1I=;
 b=xb1IUpyBUYnfMO5RJTYKW3MZELXcDcs7wkDMy6NryN3PvwD0VllOYX7qFMl0NYEtpx
 bRbgPgBRWH0+nUlkXVR/01jUBTJhtIvVOb3qITbfmdrv+hBYP6JZ6CEn63q8D6vHKBFo
 m/qs6HjPJyouS6x6j1baJOo+bk+WJ1zvzwSHXiDDg7EAzvBpt6/WvugXLcYhfAzrHKiW
 wwezxFzaOo7YvwNTfWFWPgK0narxy/HdFjs1OylejY1jtW1PCXp9DG1p/s7KSPp2etQ/
 LlLvRPFTWs8w9ZyFiDWEz+jDkXdjuhiZRvsU6VK3YCjT3DQZg5BxZbeut0vWZ0/LngTc
 JtGQ==
X-Gm-Message-State: AOAM532HV87uQ2cI1xS66ijvQrEfmZsLI9x5jNZP4N5ACquTtoQ/+xmO
 BHUm4dAIVwnpCwIRIx/ojq+sT/vqof26VnpyIWfb/w==
X-Google-Smtp-Source: ABdhPJzKtxc7WEQpiHH0MrDWI4vkFyWw2Kuu1EMYvHrNU3JBeudnQAGglFmYrX7+zwqyb+M2qvWbhFtOCtWp5B525Pw=
X-Received: by 2002:a4a:4a86:0:b0:35e:a2d3:763b with SMTP id
 k128-20020a4a4a86000000b0035ea2d3763bmr7378324oob.23.1652165061868; Mon, 09
 May 2022 23:44:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220509120330.3043773-1-tabba@google.com>
 <20220509120330.3043773-4-tabba@google.com>
 <Ynl32cU6hkuXRQuZ@google.com>
In-Reply-To: <Ynl32cU6hkuXRQuZ@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 May 2022 07:43:45 +0100
Message-ID: <CA+EHjTyq_T8x35hjWZgvk+Am3em172EeYigAiBfqvL2L7KodBg@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] KVM: arm64: Pass pmu events to hyp via vcpu
To: Oliver Upton <oupton@google.com>
Cc: will@kernel.org, maz@kernel.org, catalin.marinas@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Oliver,


On Mon, May 9, 2022 at 9:21 PM Oliver Upton <oupton@google.com> wrote:
>
> On Mon, May 09, 2022 at 12:03:29PM +0000, Fuad Tabba wrote:
> > Instead of the host accessing hyp data directly, pass the pmu
> > events of the current cpu to hyp via the vcpu.
> >
> > This adds 64 bits (in two fields) to the vcpu that need to be
> > synced before every vcpu run in nvhe and protected modes.
> > However, it isolates the hypervisor from the host, which allows
> > us to use pmu in protected mode in a subsequent patch.
> >
> > No visible side effects in behavior intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  8 ++------
> >  arch/arm64/kvm/arm.c              | 15 +++++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/switch.c  | 20 ++++++--------------
> >  arch/arm64/kvm/pmu.c              | 12 ++++--------
> >  include/kvm/arm_pmu.h             |  6 ++++++
> >  5 files changed, 33 insertions(+), 28 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index dfd360404dd8..90476e713643 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -273,14 +273,8 @@ struct kvm_cpu_context {
> >       struct kvm_vcpu *__hyp_running_vcpu;
> >  };
> >
> > -struct kvm_pmu_events {
> > -     u32 events_host;
> > -     u32 events_guest;
> > -};
> > -
>
> Looks like you're moving this to arm_pmu.h as well. Probably a better
> home for it, but unclear why it is done in this patch.

Like you said, I thought it was a better home, and it's not needed
here anymore. I could maybe move it to the repacking patch and make it
as a general "cleanup" patch, if you think that would be clearer.
>
> >  struct kvm_host_data {
> >       struct kvm_cpu_context host_ctxt;
> > -     struct kvm_pmu_events pmu_events;
> >  };
> >
>
> Are we going to need this struct any more since it now has a single
> member?

I thought about removing it, but it would cause a bit of code churn.
That said, I could remove it in a new patch that I have as the last
one, and leave it to the maintainer to decide whether to take it.

>
> >  struct kvm_host_psci_config {
> > @@ -763,6 +757,7 @@ void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
> >  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
> >
> >  DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, kvm_host_data);
> > +DECLARE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
>
> Why do you need this declaration? I don't see the percpu data being
> accessed outside of pmu.c.

You're right. At one previous iteration I did need it, which is why
it's here, but not anymore. Will remove it.

> >  static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
> >  {
> > @@ -821,6 +816,7 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
> >  void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
> >  void kvm_clr_pmu_events(u32 clr);
> >
> > +struct kvm_pmu_events *kvm_get_pmu_events(void);
> >  void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
> >  void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
> >  #else
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 2adb5832a756..86bcdb2a23a8 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -817,6 +817,19 @@ static int noinstr kvm_arm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
> >       return ret;
> >  }
> >
> > +/*
> > + * Updates the vcpu's view of the pmu events for this cpu.
> > + * Must be called before every vcpu run after disabling interrupts, to ensure
> > + * that an interrupt cannot fire and update the structure.
> > + */
> > +static void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu)
> > +{
> > +     if (has_vhe() || !kvm_vcpu_has_pmu(vcpu))
> > +             return;
> > +
> > +     vcpu->arch.pmu.events = *kvm_get_pmu_events();
> > +}
> > +
> >  /**
> >   * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
> >   * @vcpu:    The VCPU pointer
> > @@ -882,6 +895,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >
> >               kvm_vgic_flush_hwstate(vcpu);
> >
> > +             kvm_pmu_update_vcpu_events(vcpu);
> > +
> >               /*
> >                * Ensure we set mode to IN_GUEST_MODE after we disable
> >                * interrupts and before the final VCPU requests check.
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index 0716163313d6..c61120ec8d1a 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -153,13 +153,9 @@ static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
> >  /*
> >   * Disable host events, enable guest events
> >   */
> > -static bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
> > +static bool __pmu_switch_to_guest(struct kvm_vcpu *vcpu)
> >  {
> > -     struct kvm_host_data *host;
> > -     struct kvm_pmu_events *pmu;
> > -
> > -     host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> > -     pmu = &host->pmu_events;
> > +     struct kvm_pmu_events *pmu = &vcpu->arch.pmu.events;
> >
> >       if (pmu->events_host)
> >               write_sysreg(pmu->events_host, pmcntenclr_el0);
> > @@ -173,13 +169,9 @@ static bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
> >  /*
> >   * Disable guest events, enable host events
> >   */
> > -static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
> > +static void __pmu_switch_to_host(struct kvm_vcpu *vcpu)
> >  {
> > -     struct kvm_host_data *host;
> > -     struct kvm_pmu_events *pmu;
> > -
> > -     host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> > -     pmu = &host->pmu_events;
> > +     struct kvm_pmu_events *pmu = &vcpu->arch.pmu.events;
> >
> >       if (pmu->events_guest)
> >               write_sysreg(pmu->events_guest, pmcntenclr_el0);
> > @@ -304,7 +296,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >       host_ctxt->__hyp_running_vcpu = vcpu;
> >       guest_ctxt = &vcpu->arch.ctxt;
> >
> > -     pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
> > +     pmu_switch_needed = __pmu_switch_to_guest(vcpu);
> >
> >       __sysreg_save_state_nvhe(host_ctxt);
> >       /*
> > @@ -366,7 +358,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >       __debug_restore_host_buffers_nvhe(vcpu);
> >
> >       if (pmu_switch_needed)
> > -             __pmu_switch_to_host(host_ctxt);
> > +             __pmu_switch_to_host(vcpu);
> >
> >       /* Returning to host will clear PSR.I, remask PMR if needed */
> >       if (system_uses_irq_prio_masking())
> > diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> > index 4bd38ff34221..c19bf6e4969e 100644
> > --- a/arch/arm64/kvm/pmu.c
> > +++ b/arch/arm64/kvm/pmu.c
> > @@ -5,7 +5,8 @@
> >   */
> >  #include <linux/kvm_host.h>
> >  #include <linux/perf_event.h>
> > -#include <asm/kvm_hyp.h>
> > +
> > +DEFINE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
> >
> >  /*
> >   * Given the perf event attributes and system type, determine
> > @@ -25,14 +26,9 @@ static bool kvm_pmu_switch_needed(struct perf_event_attr *attr)
> >       return (attr->exclude_host != attr->exclude_guest);
> >  }
> >
> > -static struct kvm_pmu_events *kvm_get_pmu_events(void)
> > +struct kvm_pmu_events *kvm_get_pmu_events(void)
>
> Why not make this function visible in patch 1? It seems benign even
> though there are no other users at that moment outside of the
> compilation unit.

Because I wanted every patch to be self-standing, but no preference
really. I can change that to reduce code churn.

Cheers,
/fuad

>
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
