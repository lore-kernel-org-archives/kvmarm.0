Return-Path: <SRS0=HDjL=MW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60376C432BE
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 14:33:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CF0A26108C
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 14:33:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CF0A26108C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3464C49FB0;
	Fri, 30 Jul 2021 10:33:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aAixVM+m65XF; Fri, 30 Jul 2021 10:33:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B2B249F6C;
	Fri, 30 Jul 2021 10:33:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29B1D49F6C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 10:33:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xMrA2YfGXj4c for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jul 2021 10:33:35 -0400 (EDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com
 [209.85.208.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DFC3449E93
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 10:33:34 -0400 (EDT)
Received: by mail-lj1-f178.google.com with SMTP id l4so12678608ljq.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jul 2021 07:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=dQGtz4NxA/KCcb2UkEKczuSorFz82jXK+AMOuFhIpSY=;
 b=RDXh6xhSHzVcHoLlZtkJY8rwf+9yeKe0yYYIuU3JvH6YO4ghrz6ojczlapHQhwLmCd
 Fe+TAjzwdXYjAv06/eyWHH3Q10DkSfI9d/AfMDP7wA867e2ePSETc1r6V984B2jOSxuf
 amMOK/ZmyhihhEhZ8f/Sa3NU/ODRr5XPRXRIR9lvPBR3s9csTgQ1WHhVYHwGmlpeK9IT
 dDVZYTaWI9Vc59rDlXVpmgnW6t6/qB7KFS8XKcZdocIlK2yLURmYOJJfjNhhBnZ5DHFd
 FjPTbYr5RJa7XU4gvoi6v4QJy5l1V9kf7uESMvX+FkIFC6dNkaxHkyQDRuwJkGyuXETd
 ziGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=dQGtz4NxA/KCcb2UkEKczuSorFz82jXK+AMOuFhIpSY=;
 b=f7xxkjBmBDVdmt3Q23gTwkPNUw9hNcXcxPUDEBA25AVkXmh2naHLxNScr7HIS9ShuY
 oHm0b0Gp26C2fqtFn1tzgd86cLUnGZbxQwEwT+zPpMEb3sEkKAHFmzOEiQ9xKmEr7rC2
 ahucRaa/s1gvzDWwKo3W56xCf8luuyuudibt+YtelS0HwTUivjAO+6bzmUu/Qa3nabBr
 L+UCimRwfAsmuKHugY4+J31E1Su00X/UNEP1/wiEa/76vc3JKvMutlBDTsxezYJq1psc
 uu77/fXAhzlvEZ6CmmkxQWQD3W0Jld0uEqZBZYvc2m7kkYBnwj0zfmRl5gX6YF/7zJFF
 E2ZQ==
X-Gm-Message-State: AOAM533X2QqqxMQjcOu12//M+flHMFdhYrbZAGWEdjYNwR7+7oOmy/5G
 pKpU4hhXiLKhDLgXT2W7QPDpP/ic2n5dFLDw09Vcdw==
X-Google-Smtp-Source: ABdhPJzgGnVq10vXKLaHBZpfgLUJ0afJNvNbZo+mH2b7grVgG96TtjH9fn8FrBCfPY3RGRFW6+8Q94qxjfL1Nl+Zq/g=
X-Received: by 2002:a2e:a68f:: with SMTP id q15mr1890524lje.314.1627655612988; 
 Fri, 30 Jul 2021 07:33:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210729220916.1672875-1-oupton@google.com>
 <20210729220916.1672875-4-oupton@google.com>
 <878s1o2l6j.wl-maz@kernel.org>
In-Reply-To: <878s1o2l6j.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Fri, 30 Jul 2021 07:33:21 -0700
Message-ID: <CAOQ_QsjFzdjYgYSxNLH=8O84FJB+O8KtH0VnzdQ9HnLZwxwpNQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: arm64: Use generic KVM xfer to guest work
 function
To: Marc Zyngier <maz@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Guangyu Shi <guangyus@google.com>,
 Will Deacon <will@kernel.org>, Andy Lutomirski <luto@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
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

Marc,

On Fri, Jul 30, 2021 at 2:41 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Oliver,
>
> On Thu, 29 Jul 2021 23:09:16 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > Clean up handling of checks for pending work by switching to the generic
> > infrastructure to do so.
> >
> > We pick up handling for TIF_NOTIFY_RESUME from this switch, meaning that
> > task work will be correctly handled.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/kvm/Kconfig |  1 +
> >  arch/arm64/kvm/arm.c   | 27 ++++++++++++++-------------
> >  2 files changed, 15 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index a4eba0908bfa..8bc1fac5fa26 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -26,6 +26,7 @@ menuconfig KVM
> >       select HAVE_KVM_ARCH_TLB_FLUSH_ALL
> >       select KVM_MMIO
> >       select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> > +     select KVM_XFER_TO_GUEST_WORK
> >       select SRCU
> >       select KVM_VFIO
> >       select HAVE_KVM_EVENTFD
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 60d0a546d7fd..9762e2129813 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -6,6 +6,7 @@
> >
> >  #include <linux/bug.h>
> >  #include <linux/cpu_pm.h>
> > +#include <linux/entry-kvm.h>
> >  #include <linux/errno.h>
> >  #include <linux/err.h>
> >  #include <linux/kvm_host.h>
> > @@ -714,6 +715,13 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
> >               static_branch_unlikely(&arm64_mismatched_32bit_el0);
> >  }
> >
> > +static bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
> > +{
> > +     return kvm_request_pending(vcpu) ||
> > +                     need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
> > +                     xfer_to_guest_mode_work_pending();
>
> Here's what xfer_to_guest_mode_work_pending() says:
>
> <quote>
>  * Has to be invoked with interrupts disabled before the transition to
>  * guest mode.
> </quote>
>
> At the point where you call this, we already are in guest mode, at
> least in the KVM sense.

I believe the comment is suggestive of guest mode in the hardware
sense, not KVM's vcpu->mode designation. I got this from
arch/x86/kvm/x86.c:vcpu_enter_guest() to infer the author's
intentions.

>
> > +}
> > +
> >  /**
> >   * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
> >   * @vcpu:    The VCPU pointer
> > @@ -757,7 +765,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >               /*
> >                * Check conditions before entering the guest
> >                */
> > -             cond_resched();
> > +             if (__xfer_to_guest_mode_work_pending()) {
> > +                     ret = xfer_to_guest_mode_handle_work(vcpu);
>
> xfer_to_guest_mode_handle_work() already does the exact equivalent of
> __xfer_to_guest_mode_work_pending(). Why do we need to do it twice?

Right, there's no need to do the check twice.

>
> > +                     if (!ret)
> > +                             ret = 1;
> > +             }
> >
> >               update_vmid(&vcpu->arch.hw_mmu->vmid);
> >
> > @@ -776,16 +788,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >
> >               kvm_vgic_flush_hwstate(vcpu);
> >
> > -             /*
> > -              * Exit if we have a signal pending so that we can deliver the
> > -              * signal to user space.
> > -              */
> > -             if (signal_pending(current)) {
> > -                     ret = -EINTR;
> > -                     run->exit_reason = KVM_EXIT_INTR;
> > -                     ++vcpu->stat.signal_exits;
> > -             }
> > -
> >               /*
> >                * If we're using a userspace irqchip, then check if we need
> >                * to tell a userspace irqchip about timer or PMU level
> > @@ -809,8 +811,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >                */
> >               smp_store_mb(vcpu->mode, IN_GUEST_MODE);
> >
> > -             if (ret <= 0 || need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
> > -                 kvm_request_pending(vcpu)) {
> > +             if (ret <= 0 || kvm_vcpu_exit_request(vcpu)) {
>
> If you are doing this, please move the userspace irqchip handling into
> the helper as well, so that we have a single function dealing with
> collecting exit reasons.

Sure thing.

Thanks for the quick review, Marc!

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
