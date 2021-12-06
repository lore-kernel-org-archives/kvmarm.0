Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBF9C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  6 Dec 2021 17:35:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0AC74A1B0;
	Mon,  6 Dec 2021 12:35:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PpeOqXF-M68Y; Mon,  6 Dec 2021 12:35:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6663D4B091;
	Mon,  6 Dec 2021 12:35:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 381064A1B0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Dec 2021 12:35:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YhZ6bxxBP-Vf for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Dec 2021 12:35:10 -0500 (EST)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com
 [209.85.208.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20C9B4A19A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Dec 2021 12:35:10 -0500 (EST)
Received: by mail-lj1-f174.google.com with SMTP id z8so22362826ljz.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Dec 2021 09:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ObijjNNRXE6itlkJdDnoMy05ulET3J5ksrjco4dQA1c=;
 b=CLjXdyfnqAQMK6ExVkjomUn/HBbVGyHOP3vEp5iYRyMOQE3H1wp+Naco6XQH67BV3I
 WCZYxzsm0yUrrV+ml2Y2tSNPl+uss3Vj4fFX4i13TJ+6UM5EO3AePqtXU2/1zUE8Knxi
 XRd8m8wmdPGj5v7lXsHfWbstSAK91GbAG1hG8OXJtjJsZAV112nQWlAKw65wMQhE4fir
 nb5dkjEivBjsv7LgtcBq0kSvEWdVnvQxCEKAx3nBB+ByM9ZUUtJyt6ML6yOhoSGYBhDH
 zfCcD28QoD18jggyXJFcdUrVdbUdjFbdprl/yV5UOHGjNQNxfjRGSYoS32QmtvnFxXH5
 osRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ObijjNNRXE6itlkJdDnoMy05ulET3J5ksrjco4dQA1c=;
 b=Q3CZ7SY3UORFx4NIXp48wAWNUp/zfjdrVTsYVNDn0Skcg2cXScf3wMirYbv75Fh3aW
 wnR+af2mfuJD5Voc5SyvROVElcMhAOhYHuo9BUelEWqXoSroiLYzPV7SweztQY7Qk8c8
 6oES7l+vfwKNwtHttqkgA7Jj3mDJit8KXOJF00YGPn7lkNj+mbJ1PB3PlTY5XtSRe0Ln
 2mrujPT9lic0jX6BsdVTRpmj6TqLj+YqtmrxxMPV2TOTpMXgvyffZiltNFp2LVs9UlRb
 dpxVnhg1hLjEtAMTmtuVHdBDg0lwmHugwoqAqiXW0Uu7uBdq0jqA3wG5l/Ls3h89ebAV
 QHJg==
X-Gm-Message-State: AOAM531xICXwRMgEWvgWL4gzONGy696X+fLtpEyCNU/MGegb9y6LgZK6
 bnMKYz28yG+mGo4Xmb/q56PEHZyysYW1DmFBzgfvZA==
X-Google-Smtp-Source: ABdhPJyhT32Rl+FOG0Vq4c2ude2auGlMTF31Nm+vwlDbCHQKWKZwUHRiHKNcqkJrleiFZPHODWHThMKl7Q7TNAB9Bmc=
X-Received: by 2002:a05:651c:a12:: with SMTP id
 k18mr38470379ljq.251.1638812108454; 
 Mon, 06 Dec 2021 09:35:08 -0800 (PST)
MIME-Version: 1.0
References: <20211123210109.1605642-1-oupton@google.com>
 <20211123210109.1605642-5-oupton@google.com>
 <87r1azm4j1.wl-maz@kernel.org>
In-Reply-To: <87r1azm4j1.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Mon, 6 Dec 2021 11:34:57 -0600
Message-ID: <CAOQ_QsgUoA88GmWx4j3EWoELyEtWSgUw6tBB8BHivzBTaVon0g@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64: Emulate the OS Lock
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
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

Hey Marc,

Apologies for my delay in getting back to you, I was OOO for a while.

On Mon, Nov 29, 2021 at 8:16 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 23 Nov 2021 21:01:07 +0000,
> Oliver Upton <oupton@google.com> wrote:
> >
> > The OS lock blocks all debug exceptions at every EL. To date, KVM has
> > not implemented the OS lock for its guests, despite the fact that it is
> > mandatory per the architecture. Simple context switching between the
> > guest and host is not appropriate, as its effects are not constrained to
> > the guest context.
> >
> > Emulate the OS Lock by clearing MDE and SS in MDSCR_EL1, thereby
> > blocking all but software breakpoint instructions. To handle breakpoint
> > instructions, trap debug exceptions to EL2 and skip the instruction.
>
> Skipping breakpoint instructions? I don't think you can do that, as
> the guest does rely on BRK always being effective. I also don't see
> where you do that...

Right, this comment in the commit message is stale. In the previous
iteration I had done this, but removed it per your suggestion. I'll
fix the msg in the next round.

> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  4 ++++
> >  arch/arm64/kvm/debug.c            | 27 +++++++++++++++++++++++----
> >  arch/arm64/kvm/sys_regs.c         |  6 +++---
> >  3 files changed, 30 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 53fc8a6eaf1c..e5a06ff1cba6 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -726,6 +726,10 @@ void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
> >  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
> >  void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
> >  void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
> > +
> > +#define kvm_vcpu_os_lock_enabled(vcpu)               \
> > +     (!!(__vcpu_sys_reg(vcpu, OSLSR_EL1) & SYS_OSLSR_OSLK))
> > +
> >  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
> >                              struct kvm_device_attr *attr);
> >  int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index db9361338b2a..7835c76347ce 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -53,6 +53,14 @@ static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
> >                               vcpu_read_sys_reg(vcpu, MDSCR_EL1));
> >  }
> >
> > +/*
> > + * Returns true if the host needs to use the debug registers.
> > + */
> > +static inline bool host_using_debug_regs(struct kvm_vcpu *vcpu)
> > +{
> > +     return vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu);
>
> Just the name of the function has sent my head spinning. Even if the
> *effects* of the host debug and the OS Lock are vaguely similar from
> the guest PoV, they really are different things, and I'd rather not
> lob them together.
>
> > +}
> > +
> >  /**
> >   * kvm_arm_init_debug - grab what we need for debug
> >   *
> > @@ -105,9 +113,11 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
> >        *  - Userspace is using the hardware to debug the guest
> >        *  (KVM_GUESTDBG_USE_HW is set).
> >        *  - The guest is not using debug (KVM_ARM64_DEBUG_DIRTY is clear).
> > +      *  - The guest has enabled the OS Lock (debug exceptions are blocked).
> >        */
> >       if ((vcpu->guest_debug & KVM_GUESTDBG_USE_HW) ||
> > -         !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
> > +         !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY) ||
> > +         kvm_vcpu_os_lock_enabled(vcpu))
> >               vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
> >
> >       trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
> > @@ -160,8 +170,10 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> >
> >       kvm_arm_setup_mdcr_el2(vcpu);
> >
> > -     /* Is Guest debugging in effect? */
> > -     if (vcpu->guest_debug) {
> > +     /*
> > +      * Check if we need to use the debug registers.
> > +      */
> > +     if (host_using_debug_regs(vcpu)) {
>
> I'd rather you expand the helper here and add the comment you have in
> the commit message explaining the machine-wide effect of the OS Lock.

Ack to here and the above comment. Thanks for the review!

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
