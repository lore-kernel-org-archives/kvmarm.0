Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA557C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 00:35:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C19460F02
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 00:35:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5C19460F02
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB2BA4B16C;
	Tue,  2 Nov 2021 20:35:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BtQUGmZtBKdf; Tue,  2 Nov 2021 20:35:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAF6C4B11E;
	Tue,  2 Nov 2021 20:35:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B8EC4B11E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 20:35:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HXplrNwlu+pq for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Nov 2021 20:35:25 -0400 (EDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com
 [209.85.167.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36B444B086
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 20:35:25 -0400 (EDT)
Received: by mail-lf1-f41.google.com with SMTP id d21so1810427lfg.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 17:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=V94qvjxMLufwlhWujeoVBKTAsogN9P3sQB42Th9nIWw=;
 b=CZfEvO0B7n1QJHbZO1N/yIm8HTZyZASgIYUj8XqtTJouwI9fN0nhARowUNimsNo2xZ
 tcCQoqCB0FXSkmST3P436+huOXyTcSytKAYgy/VID+rZjd0fAF/Q8VRv84Pw7rRiUq4r
 FR5NtRFVqcUn4P1cp53ZuBLqLFDmQSdrsbWwaCn2C63cy8Vg70p5JB4UXhmRWyT0kJMl
 HQyyqH6wHNHwAJLJVhSoeGcB7zi7E09e51dPaeXnus7BOE/pUY4MSEbrfNLdkrbRzcwk
 Kda0jJnMQmuLGTDHilkBHuilWEzJoCWHap1UlmyBaGo4s25vAS42+Imlv0DieJ1f2dHp
 aTVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=V94qvjxMLufwlhWujeoVBKTAsogN9P3sQB42Th9nIWw=;
 b=QDNO4FSEtpIS4FZ74Wfe6HBAlaW7BIMOAavPLvo5+VOsmdmmWVS0H0XYlhakSbpmbo
 9e8d1sE+i3Nm8OeScceGtuEf6iqcIOymuUAEyRPT5u3JdCd18duY1EW57rz2LyxTX3he
 PJoJMuJfI3QPICgpUbz3Ls/pu1yMhzeBWtySazKsCD/XuuX+YM323nTh9lyuQw4rj/Jn
 2/woaYctKs1ths5PERKPiJMvXZ/VwnyszAu2hSBIY3QphEvYejhaqQ1tioJB4f5HCnM0
 3/bTsLvTOWtvzMDfJYfBkPS25Fh9FegnLrfM3JL3HsAQrD89y+PCwauqHujkayJ0eQ0K
 0tiQ==
X-Gm-Message-State: AOAM532PWSb7SLvQrdE0Eq8zp3DEUWWm7Lw0I2sJLncMQ5+0zkvbjxo5
 4nlXALZX0oM/BH9TvuDmkej8NdglmxYsV3QH/fDonA==
X-Google-Smtp-Source: ABdhPJzqc1hfgB/5HL3f/KE77uRD6B0N539NFPzfBc8qpON8SsYig+1gw0DaeYdAdLsbr2YnbrTxzXGinF0tNweibms=
X-Received: by 2002:a05:6512:96f:: with SMTP id
 v15mr24529197lft.669.1635899723752; 
 Tue, 02 Nov 2021 17:35:23 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
 <20211102094651.2071532-5-oupton@google.com>
 <YYHNLt1rlwuXkk7e@google.com>
In-Reply-To: <YYHNLt1rlwuXkk7e@google.com>
From: Oliver Upton <oupton@google.com>
Date: Tue, 2 Nov 2021 17:35:12 -0700
Message-ID: <CAOQ_Qsgq9YjX0gosaAMfgX5oQxatVhNK=gfN2BfjQ=ps7T4=mQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Emulate the OS Lock
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Ricardo,

On Tue, Nov 2, 2021 at 4:45 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Tue, Nov 02, 2021 at 09:46:49AM +0000, Oliver Upton wrote:
> > The OS lock blocks all debug exceptions at every EL. To date, KVM has
> > not implemented the OS lock for its guests, despite the fact that it is
> > mandatory per the architecture. Simple context switching between the
> > guest and host is not appropriate, as its effects are not constrained to
> > the guest context.
> >
> > Emulate the OS Lock by clearing MDE and SS in MDSCR_EL1, thereby
> > blocking all but software breakpoint instructions. To handle breakpoint
> > instructions, trap debug exceptions to EL2 and skip the instruction.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  4 ++++
> >  arch/arm64/kvm/debug.c            | 20 +++++++++++++++-----
> >  arch/arm64/kvm/handle_exit.c      |  8 ++++++++
> >  arch/arm64/kvm/sys_regs.c         |  6 +++---
> >  4 files changed, 30 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index c98f65c4a1f7..f13b8b79b06d 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -724,6 +724,10 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
> >  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
> >  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
> >  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
> > +
> > +#define kvm_vcpu_os_lock_enabled(vcpu)               \
> > +     (__vcpu_sys_reg(vcpu, OSLSR_EL1) & SYS_OSLSR_OSLK)
> > +
> >  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
> >                              struct kvm_device_attr *attr);
> >  int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index db9361338b2a..5690a9c99c89 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -95,8 +95,11 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
> >                               MDCR_EL2_TDRA |
> >                               MDCR_EL2_TDOSA);
> >
> > -     /* Is the VM being debugged by userspace? */
> > -     if (vcpu->guest_debug)
> > +     /*
> > +      * Check if the VM is being debugged by userspace or the guest has
> > +      * enabled the OS lock.
> > +      */
> > +     if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu))
> >               /* Route all software debug exceptions to EL2 */
> >               vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
> >
> > @@ -160,8 +163,11 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> >
> >       kvm_arm_setup_mdcr_el2(vcpu);
> >
> > -     /* Is Guest debugging in effect? */
> > -     if (vcpu->guest_debug) {
> > +     /*
> > +      * Check if the guest is being debugged or if the guest has enabled the
> > +      * OS lock.
> > +      */
> > +     if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu)) {
> >               /* Save guest debug state */
> >               save_guest_debug_regs(vcpu);
> >
> > @@ -223,6 +229,10 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> >                       trace_kvm_arm_set_regset("WAPTS", get_num_wrps(),
> >                                               &vcpu->arch.debug_ptr->dbg_wcr[0],
> >                                               &vcpu->arch.debug_ptr->dbg_wvr[0]);
> > +             } else if (kvm_vcpu_os_lock_enabled(vcpu)) {
> > +                     mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
> > +                     mdscr &= ~DBG_MDSCR_MDE;
> > +                     vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
>
> I think this is missing the case where the guest is being debugged by
> userspace _and_ from inside (the guest) at the same time. In this
> situation, the vmm gets a KVM_EXIT_DEBUG and if it doesn't know what to
> do with it, it injects the exception into the guest (1). With this "else
> if", the guest would still get the debug exception when the os lock is
> enabled.
>
> (1) kvm_arm_handle_debug() is the one doing this in QEMU source code.

I wonder if this is a problem that KVM should even handle. KVM doesn't
do anything to help userspace inject the debug exception into the
guest, and from reading kvm_arm_handle_debug() it would seem that QEMU
is manually injecting the exception to EL1 and setting the PC to the
appropriate vector.

There is an issue, though, with migration: older KVM will not show
OSLSR_EL1 on KVM_GET_REG_LIST. However, in order to provide an
architectural OS Lock, its reset value must be 1 (enabled). This would
all have the effect of discarding the guest's OS lock value and
blocking all debug exceptions intended for the guest until the next
reboot.

So it would seem that userspace needs to know about the OSLK bit to
correctly inject debug exceptions and migrate guests. If opt-in is
heavyweight, we could cure the migration issue by explicitly
documenting the OS lock being disabled out of reset as an erratum of
KVM. Doing so would be consistent with all prior versions of KVM. Of
course, adopting nonarchitected behavior in perpetuity seems a bit
unsavory :-)

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
