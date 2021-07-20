Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1290CC12002
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 12:20:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 75FAD6121F
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 12:20:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75FAD6121F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF2C04B10C;
	Wed, 21 Jul 2021 08:20:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cjs0BHNeHK2i; Wed, 21 Jul 2021 08:20:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6AEC4B121;
	Wed, 21 Jul 2021 08:20:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D22C84A4E1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 14:45:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7sNi6SyYlkfM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 14:45:05 -0400 (EDT)
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com
 [209.85.222.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 901344A4A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 14:45:05 -0400 (EDT)
Received: by mail-qk1-f179.google.com with SMTP id j184so21002082qkd.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 11:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=h+5lhU7M8IjaNDliv1AGOCjbrZiTwbIiNZC3cRm5Ft4=;
 b=kBNqGrqVO0AGRsiaL21hT9uj8jYrP1RH/zUuBTrpbBUb8A42hHHzVHzCvjT3dJ+Ty9
 yVNDKRMFvYehXW+I9SqWnToG1znHK9qyAECiy7F0h2h5UkSiMrAyD1iqLfcHmIRzqBa3
 3gLxomE2ztzKfdxeg1Dh4QidNGCiIfjBswBQkZ+D/owBOrYD/eqpSPrICPG/l2YXwhbz
 5Isa8wx3gsFgKoqDQmVfhIzKAQrNd0RLyOctfy3RpnRQJNWfmIzPwCt+VZOzjvbzpTqB
 PBkyGWSERoggfMqSRyQ2NYYmATiMWki7J0f+6OrXNWlGNm/0LPY1LZPNdt730Ui4K1R5
 7yeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=h+5lhU7M8IjaNDliv1AGOCjbrZiTwbIiNZC3cRm5Ft4=;
 b=XoVbvd6jrDJAtEDZK5YRbcxMkeNtax1JQcA+0FPuL59cTU/chZiNqg7A0jZ5WFcQ77
 96btLTUQOvZ4wh9l1BeQqWB6ToLPDOhzGS8IRrZuBcyxtTZFw24gmeKEGJEvAeF12yKr
 0OjxQDAcHKt6NzvhjY7vd1zRu2JWJ/3PUSN63hT2K5Ds9aTqR9DEtGso9maM56Wlvm9f
 P0oYfW8/mnfWiVduGo91eLtdpGO0/atLNw6++BAg8Ut8Twl87efV8uTwvn0cSMFYllKZ
 s5RYkD7QZ524ffGuTpxy4obPpmEXaAR72Qeff3TKEdXIiJ300S7VujPZL8pWpP0ZhF+u
 YKSA==
X-Gm-Message-State: AOAM531Rc0FfBSi/lxpTAXwjc5Dxbe/jbzcCZxPZFAKOXngcaQVI8wAS
 dczHYbjNTz5ehOMU9q+ngKU/eZyHj+h9kgrzzflx5w==
X-Google-Smtp-Source: ABdhPJz99PqGqDiAUjrgTCjXK83j0Ii/6/WjrhhzASEWUjObSqCXnA+g3kTJMOWUTIM3pS0bEje2lpMgJ/Z6UUAhjFU=
X-Received: by 2002:a37:8f44:: with SMTP id r65mr31378302qkd.20.1626806704872; 
 Tue, 20 Jul 2021 11:45:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210709043713.887098-1-senozhatsky@chromium.org>
 <20210709043713.887098-5-senozhatsky@chromium.org>
 <874kcz33g5.wl-maz@kernel.org>
In-Reply-To: <874kcz33g5.wl-maz@kernel.org>
From: Joel Fernandes <joelaf@google.com>
Date: Tue, 20 Jul 2021 14:44:53 -0400
Message-ID: <CAJWu+oqCyj3H0=1KNo3c+crdcktYinFoTQJ5jHgU8gjeF4d2yA@mail.gmail.com>
Subject: Re: [PATCHv2 4/4] arm64: add host pv-vcpu-state support
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Wed, 21 Jul 2021 08:20:04 -0400
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Suleiman Souhlal <suleiman@google.com>, Will Deacon <will@kernel.org>,
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

On Mon, Jul 12, 2021 at 12:24 PM Marc Zyngier <maz@kernel.org> wrote:
>
[...]
> > +}
> > +
> > +static inline bool
> > +kvm_arm_is_vcpu_state_enabled(struct kvm_vcpu_arch *vcpu_arch)
> > +{
> > +     return (vcpu_arch->vcpu_state.base != GPA_INVALID);
> > +}
> > +
> > +void kvm_update_vcpu_preempted(struct kvm_vcpu *vcpu, bool preempted);
> > +
> >  void kvm_set_sei_esr(struct kvm_vcpu *vcpu, u64 syndrome);
> >
> >  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
> > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > index 989bb5dad2c8..2a3ee82c6d90 100644
> > --- a/arch/arm64/kvm/Makefile
> > +++ b/arch/arm64/kvm/Makefile
> > @@ -12,7 +12,8 @@ obj-$(CONFIG_KVM) += hyp/
> >
> >  kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
> >        $(KVM)/vfio.o $(KVM)/irqchip.o $(KVM)/binary_stats.o \
> > -      arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
> > +      arm.o mmu.o mmio.o psci.o perf.o hypercalls.o \
> > +      pvtime.o pv-vcpu-state.o \
> >        inject_fault.o va_layout.o handle_exit.o \
> >        guest.o debug.o reset.o sys_regs.o \
> >        vgic-sys-reg-v3.o fpsimd.o pmu.o \
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index e9a2b8f27792..43e995c9fddb 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -332,6 +332,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >       kvm_arm_reset_debug_ptr(vcpu);
> >
> >       kvm_arm_pvtime_vcpu_init(&vcpu->arch);
> > +     kvm_arm_vcpu_state_init(&vcpu->arch);
> >
> >       vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
> >
> > @@ -429,10 +430,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >       if (vcpu_has_ptrauth(vcpu))
> >               vcpu_ptrauth_disable(vcpu);
> >       kvm_arch_vcpu_load_debug_state_flags(vcpu);
> > +     kvm_update_vcpu_preempted(vcpu, false);
> >  }
> >
> >  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >  {
> > +     kvm_update_vcpu_preempted(vcpu, true);
>
> This doesn't look right. With this, you are now telling the guest that
> a vcpu that is blocked on WFI is preempted. This really isn't the
> case, as it has voluntarily entered a low-power mode while waiting for
> an interrupt. Indeed, the vcpu isn't running. A physical CPU wouldn't
> be running either.

Can that be cured by just checking vcpu->preempted before calling
kvm_update_vcpu_preempted() ?

- Joel
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
