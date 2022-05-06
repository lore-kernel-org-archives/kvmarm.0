Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 266DBC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  6 May 2022 13:58:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 658844B0AC;
	Fri,  6 May 2022 09:58:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pp9XCEMDMcPy; Fri,  6 May 2022 09:58:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E65934B120;
	Fri,  6 May 2022 09:58:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B6E84B120
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 09:58:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p28r7pcF73gv for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2022 09:58:29 -0400 (EDT)
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com
 [209.85.167.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B950A4B0AC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 09:58:29 -0400 (EDT)
Received: by mail-oi1-f182.google.com with SMTP id e189so7536621oia.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 May 2022 06:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=FS1qHYqHwcapPhmEzUPW5s7DX+os73KLHL+kvMHHA8A=;
 b=AfHe+hqUiSPkVgmhGh7Sn1NxJ4E4KCO5iga4GGOe+FsmsxXdcl9/UCwSolsab88hg9
 vwHabX5Yc/kU3WpvSSDQeGFI2Fq1iS1xZwkebx9gc3zRIwYAFP9G4OQa/o/RkPvyddkh
 enh9cQhbL9MtdWcmZJRL7BFALVz/j6IGQb3gn3vRmdydER5/tJ5hJA032xmlB8sS/aAQ
 mzFNrhtDGlVpQk8mdewZkjR51JJEYkfspiTDydU1B+4U8PZo8C25XcWFG5OvqPE74/xR
 0rbo8KBRSDWu/Df6r2Pj1n/MHJMFskPjvq7BxQaZVKWvwKzuptrFQbHIvQy29900X4QX
 +I+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=FS1qHYqHwcapPhmEzUPW5s7DX+os73KLHL+kvMHHA8A=;
 b=haxodKUlOsSB6cSlX+/cEyHfOMkdwcU2GYNcFPkotP9nvI7rbf2isOGnYeEkm4yoQY
 ou+xqxWlddG1LR3uCGK5fd2gbUG+M3DUM+MaTjDqNU2C664/lt6FYNyTyFdDh9l14mzX
 aYgtC70s7eSfWaWosH3FW3Ure+I8j7payk9TjZGhMvnZlrFKR8doqVAfO5PvK7ARfxhW
 ASqEFnS4gARnd3YVefBLPXUW+aUubAP0bVKrUUejZp4qEZuZz51PY8HrkKDPQEnODg1j
 Pfvj/vKB/KVd4NmE3gI5ngC/yBaGyjRgkZEz3mvxdI6cC5T4CKJEJTEX9l1RWUTxp7Uy
 nZtg==
X-Gm-Message-State: AOAM530D1T0Sfyq1fhtBfGu2gP7On/ejFW2/VCjlKoh5guJgnxOn4SML
 lkSq7UOrydCwnuhxRtChEwNRuto5sALka8jlRG6KtQ==
X-Google-Smtp-Source: ABdhPJw3GwXK4srkkzInfFQznsGA8JjIxqcKX4XtfK4NGleTHNi/o1kDNs4580ZIP3cuKmNH3ixB8uwQskRCNfxS+AQ=
X-Received: by 2002:a05:6808:1598:b0:326:6e46:7c0e with SMTP id
 t24-20020a056808159800b003266e467c0emr1526994oiw.294.1651845508804; Fri, 06
 May 2022 06:58:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220408084052.3310931-1-tabba@google.com>
 <20220408084052.3310931-3-tabba@google.com>
 <871qx88ibn.wl-maz@kernel.org>
In-Reply-To: <871qx88ibn.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 6 May 2022 14:57:52 +0100
Message-ID: <CA+EHjTz3XuKAnnd7+0L=m7dNL0hboHYUOk_DyZ0ZBQn5MBjevQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] KVM: arm64: Pass pmu events to hyp via vcpu
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

On Thu, May 5, 2022 at 10:00 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 08 Apr 2022 09:40:51 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Instead of accessing hyp data, pass the pmu events of the current
> > cpu to hyp via the loaded vcpu.
>
> This really deserves a more thorough explanation. What this is doing
> is moving the part of the shared memory between EL1 and EL2 into each
> vcpu, effectively multiplying the memory usage by the number of vcpus
> in the system.
>
> It isn't a big deal (what are 64 bits between friends?), but this is
> definitely worth calling out.

I will explain it and motivate it better in the next respin. The
reasoning behind this is to better isolate hyp (EL2) from the host
(EL1), and not allow the host to simply peek into hyp.

>
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  8 ++------
> >  arch/arm64/kvm/arm.c              |  2 +-
> >  arch/arm64/kvm/hyp/nvhe/switch.c  | 20 ++++++--------------
> >  arch/arm64/kvm/pmu.c              | 22 +++++++++++++---------
> >  include/kvm/arm_pmu.h             |  6 ++++++
> >  5 files changed, 28 insertions(+), 30 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 0e96087885fe..b5cdfb6cb9c7 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -244,14 +244,8 @@ struct kvm_cpu_context {
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
> > @@ -728,6 +722,7 @@ void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
> >  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
> >
> >  DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, kvm_host_data);
> > +DECLARE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
> >
> >  static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
> >  {
> > @@ -781,6 +776,7 @@ void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
> >  void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
> >  void kvm_clr_pmu_events(u32 clr);
> >
> > +void kvm_vcpu_pmu_load(struct kvm_vcpu *vcpu);
> >  void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
> >  void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
> >  #else
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index ba9165e84396..e6f76d843558 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -400,7 +400,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >       if (has_vhe())
> >               kvm_vcpu_load_sysregs_vhe(vcpu);
> >       kvm_arch_vcpu_load_fp(vcpu);
> > -     kvm_vcpu_pmu_restore_guest(vcpu);
> > +     kvm_vcpu_pmu_load(vcpu);
> >       if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
> >               kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index 6410d21d8695..ff7b29fb9787 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -123,13 +123,9 @@ static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
> >  /**
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
> > @@ -143,13 +139,9 @@ static bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
> >  /**
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
> > @@ -274,7 +266,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >       host_ctxt->__hyp_running_vcpu = vcpu;
> >       guest_ctxt = &vcpu->arch.ctxt;
> >
> > -     pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
> > +     pmu_switch_needed = __pmu_switch_to_guest(vcpu);
> >
> >       __sysreg_save_state_nvhe(host_ctxt);
> >       /*
> > @@ -336,7 +328,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >       __debug_restore_host_buffers_nvhe(vcpu);
> >
> >       if (pmu_switch_needed)
> > -             __pmu_switch_to_host(host_ctxt);
> > +             __pmu_switch_to_host(vcpu);
> >
> >       /* Returning to host will clear PSR.I, remask PMR if needed */
> >       if (system_uses_irq_prio_masking())
> > diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> > index 310d47c9990f..8f722692fb58 100644
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
> > @@ -27,12 +28,7 @@ static bool kvm_pmu_switch_needed(struct perf_event_attr *attr)
> >
> >  static struct kvm_pmu_events *get_kvm_pmu_events(void)
> >  {
> > -     struct kvm_host_data *ctx = this_cpu_ptr_hyp_sym(kvm_host_data);
> > -
> > -     if (!ctx)
> > -             return NULL;
> > -
> > -     return &ctx->pmu_events;
> > +     return this_cpu_ptr(&kvm_pmu_events);
> >  }
> >
> >  /*
> > @@ -43,7 +39,7 @@ void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
> >  {
> >       struct kvm_pmu_events *pmu = get_kvm_pmu_events();
> >
> > -     if (!kvm_arm_support_pmu_v3() || !pmu || !kvm_pmu_switch_needed(attr))
> > +     if (!kvm_arm_support_pmu_v3() || !kvm_pmu_switch_needed(attr))
> >               return;
> >
> >       if (!attr->exclude_host)
> > @@ -59,7 +55,7 @@ void kvm_clr_pmu_events(u32 clr)
> >  {
> >       struct kvm_pmu_events *pmu = get_kvm_pmu_events();
> >
> > -     if (!kvm_arm_support_pmu_v3() || !pmu)
> > +     if (!kvm_arm_support_pmu_v3())
> >               return;
> >
> >       pmu->events_host &= ~clr;
> > @@ -213,3 +209,11 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
> >       kvm_vcpu_pmu_enable_el0(events_host);
> >       kvm_vcpu_pmu_disable_el0(events_guest);
> >  }
> > +
> > +void kvm_vcpu_pmu_load(struct kvm_vcpu *vcpu)
> > +{
> > +     kvm_vcpu_pmu_restore_guest(vcpu);
> > +
> > +     if (kvm_arm_support_pmu_v3() && !has_vhe())
> > +             vcpu->arch.pmu.events = *get_kvm_pmu_events();
>
> What guarantees do you have that the structure isn't updated between
> load() and the point where the data is used? For example, can an
> interrupt enable or disable a counter behind our back? I have the
> feeling it can happen.

You're right. It can happen -- I just missed it. I think that the
solution would be to do it at vcpu_run() rather than at vcpu_load().
It would incur more copying, but as someone said, "what are 64 bits
between friends?" :)

> > +}
> > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > index 20193416d214..0b3898e0313f 100644
> > --- a/include/kvm/arm_pmu.h
> > +++ b/include/kvm/arm_pmu.h
> > @@ -20,6 +20,11 @@ struct kvm_pmc {
> >       struct perf_event *perf_event;
> >  };
> >
> > +struct kvm_pmu_events {
> > +     u32 events_host;
> > +     u32 events_guest;
> > +};
> > +
> >  struct kvm_pmu {
> >       int irq_num;
> >       struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
> > @@ -27,6 +32,7 @@ struct kvm_pmu {
> >       bool created;
> >       bool irq_level;
> >       struct irq_work overflow_work;
> > +     struct kvm_pmu_events events;
>
> This makes be realise that the packing of this structure is absolutely
> awful, and that has ripple effects in the vcpu struct.
>
> Can you please reorganise the struct so that irq_num, created and
> irq_level are at the end?

Will do.

Cheers,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
