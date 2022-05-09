Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F19C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 10:48:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F26294B20F;
	Mon,  9 May 2022 06:48:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XK-BLpIZjuzY; Mon,  9 May 2022 06:48:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70B6D4B2BE;
	Mon,  9 May 2022 06:48:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A39E64B26E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 06:48:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m0OtcZ2ymngA for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 06:48:22 -0400 (EDT)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com
 [209.85.210.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2759F4B20F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 06:48:22 -0400 (EDT)
Received: by mail-ot1-f44.google.com with SMTP id
 y14-20020a9d460e000000b00605ee347da1so9800787ote.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 03:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=S2bAbrHyjmjiBfFzWmLY0LCF28FTMdqYaoqQLg2w82Y=;
 b=Pyj+SbzsrTZ5PsgzupgAZbrsBBEYcGPUEMPwzpnXDlhhyQWl7QS2NMT/B48oO9ACnf
 stNyytCPdDGhNzFzpXrhvgWv52vN0LmQ5EVqyyHKIsQtoUEkt5k4ji+823q5MqBODSU0
 8+951AEZBZ7fhcX2h/+k8f7paHEY+jGEHrvnDDFDdgCVHVXsdeH56/NUP9StC9CGzu/D
 dnGWODwr7tju0zwxNTGfvsxZboEbbH1gHHCyilzx941sJFwmoItjXvxkoVQWZX9PM7s0
 ldsCEoAOHViXHT+o5AugPpPLUkCy4FkMYEFIWc0+DwwcPQjamYQ5EI81spXwkRVyPgBf
 paUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=S2bAbrHyjmjiBfFzWmLY0LCF28FTMdqYaoqQLg2w82Y=;
 b=BPlZhsK51fBoejUpi3ld+oIxrjz1Me0L/zLbMjlhzy4k3crQxvntek2jX4TyDcnTAn
 +ZxpB0g9cRyMYLYBC5Ts935WTPouQFDqKSM3BflY0OPeOp5r5lqvdwTH3bB7PmKU7R31
 nzfztUTJmoNlT2sEy1JHtsp02qm4ZyT8Zz7kPsd/KnKyoute+9aQ/UVhUgKKAhlTF301
 suDI9LQW7GH5QE7ag8egPtmJ7Q6UtuieCylMVmJyEkiPQmR/Xq6GSOA40HN0nAX1T7Dc
 orXo2DSGS+s7EJjjZwii89dg6Vly+J85G2/24GOSbf9IasvkicIgItON8zn8PyeeSx1A
 3K0w==
X-Gm-Message-State: AOAM532NniXlZ9RNIe3sBLM0remRmJ4Ozt7uq3g8rdutoj1JrKcKzhxc
 vs5qke010lXv3bnkV6XXAoYSBWczaYu6Ahuq1uqIzA==
X-Google-Smtp-Source: ABdhPJyXxI5h4aiKM7mGoLTvNcbhX/Q7f28cTtvEegeSIGf3tMnG+6qlBnRwH8+7N5U56n+XHXqSPO+d9OvxltAUOSY=
X-Received: by 2002:a05:6830:3094:b0:605:f31b:532b with SMTP id
 f20-20020a056830309400b00605f31b532bmr5926845ots.299.1652093301117; Mon, 09
 May 2022 03:48:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220509095500.2408785-1-tabba@google.com>
 <20220509095500.2408785-4-tabba@google.com>
 <87fslj6lql.wl-maz@kernel.org>
In-Reply-To: <87fslj6lql.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 May 2022 11:47:45 +0100
Message-ID: <CA+EHjTxmXjmS3you0Uj6f+2JrmADuYeKouF_FOSA76ZZ_fKr1w@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: arm64: Pass pmu events to hyp via vcpu
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, catalin.marinas@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On Mon, May 9, 2022 at 11:31 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 09 May 2022 10:54:59 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Instead of the host accessing hyp data directly, pass the pmu
> > events of the current cpu to hyp via the vcpu.
> >
> > This adds 64 bits (in two fields) to the vcpu that need to be
> > synced before every vcpu run in nvhe and protected modes.
> > However, it isolates the hypervisor from the host, which allows
> > us to use pmu in protected mode in a subsequent patch.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  8 ++------
> >  arch/arm64/kvm/hyp/nvhe/switch.c  | 20 ++++++--------------
> >  arch/arm64/kvm/pmu-emul.c         |  3 +++
> >  arch/arm64/kvm/pmu.c              | 12 ++++--------
> >  include/kvm/arm_pmu.h             |  6 ++++++
> >  5 files changed, 21 insertions(+), 28 deletions(-)
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
> >  struct kvm_host_data {
> >       struct kvm_cpu_context host_ctxt;
> > -     struct kvm_pmu_events pmu_events;
> >  };
> >
> >  struct kvm_host_psci_config {
> > @@ -763,6 +757,7 @@ void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
> >  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
> >
> >  DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, kvm_host_data);
> > +DECLARE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
> >
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
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index 3dc990ac4f44..08d0551a4e43 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -406,6 +406,9 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
> >       if (!kvm_vcpu_has_pmu(vcpu))
> >               return;
> >
> > +     if (!has_vhe())
> > +             pmu->events = *kvm_get_pmu_events();
>
> A bit of context:
>
>                 preempt_disable();
>
>                 /*
>                  * The VMID allocator only tracks active VMIDs per
>                  * physical CPU, and therefore the VMID allocated may not be
>                  * preserved on VMID roll-over if the task was preempted,
>                  * making a thread's VMID inactive. So we need to call
>                  * kvm_arm_vmid_update() in non-premptible context.
>                  */
>                 kvm_arm_vmid_update(&vcpu->arch.hw_mmu->vmid);
>
>                 kvm_pmu_flush_hwstate(vcpu);
>
>                 local_irq_disable();
>
> You *still* are in a context where an interrupt can fire and mess
> things up behind your back. Not good. Also, this is now synchronised
> *twice* per run (once on flush, once on sync). Do we really need this?

Yes of course, it needs to happen after interrupts have been disabled.
Will fix that.

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
