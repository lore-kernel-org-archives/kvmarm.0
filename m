Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65AEECAAD8
	for <kvmarm@archiver.kernel.org>; Wed, 14 Sep 2022 06:13:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E9AF4BB31;
	Wed, 14 Sep 2022 02:13:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uTDEAAjcOv1K; Wed, 14 Sep 2022 02:13:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAFF14BBA2;
	Wed, 14 Sep 2022 02:13:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57B634BB3C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 02:13:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0IsGOz5xfFuF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Sep 2022 02:13:20 -0400 (EDT)
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com
 [209.85.217.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E33794BB31
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 02:13:20 -0400 (EDT)
Received: by mail-vs1-f52.google.com with SMTP id 67so14798243vsv.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2022 23:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=3Nj3leCSwB1mG6UETzR179fDDWSWD2vq8HNpdWGZN90=;
 b=ehy0egZci05ylvswS7cjrgJ+nSu4gnTHEY52CE6r0WR26HvYVCShI1KLxYsxcCOvaM
 mQ4Y0FZkqwO/CZd4uOUlj0Uw7kwq8aTs+uBuFlzkT5z+yJRa9AoQ3XsDIY4LU5mlYQCM
 BJfDwTg7LM8gNIF5oKe0+i4yYsLMjQRhohqmpyo3uIMelUdRN3/yjRX9fLhfQcqX9DSa
 Eqi6Te0GXWqE7MWkVFigDDcc7GHxGAv4IwSyMQN0JjsAiUuK0TlJVLDChulWHEiEE+vE
 dpxR3XCiaVe4Uo8DhusWpZRVkPPvDSnzgBfPQ43Pf5nrv8X4CiGyLlAhl+cBw5U0vAGT
 wDjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=3Nj3leCSwB1mG6UETzR179fDDWSWD2vq8HNpdWGZN90=;
 b=q6C9hcaL8ai/UNWy540+8xqamf653T9h3+EvM2b0SRM6bNu1ARsSJFlFFPObvCvK3I
 sNDImEa4LsyxBHhtqbSq1WLcZgp4d4oNBjw03GWaGKGW376qW1OtszULgAuMvn//Qmg6
 C0IraAYYqGFEk69ZQEyccvlJp8W4K60swQJnjreY4GvjXqqN59GYNwwFLNt0kaeEdhNi
 /QLaxCwYEXCjWL1HfejXKvlWRYr4G64XMWqMsMpggXuWg6xBxuUeRz6LV5AOuSGmjbuI
 AYvLLKXszUUDybvrpH4ytJ8sratwg32x7fIHLqC5ZqjqCBXQ2PQX2Q7sxmkHNn1pWTQI
 3mBQ==
X-Gm-Message-State: ACgBeo2CYqfYKe5PUoR7Y4YAGYk0tRLENKXdknftOcBEo0nXMOYmTh5m
 f9DW3S3ta7R/T56qvteLgt7R+X/LzwguCGjgw1HdgA==
X-Google-Smtp-Source: AA6agR4JUNqOVng4uk2DdELeIypGajswDTkl+EO+sfZtKXSS7J9di0ND1TC1heExvdipyjW4oYwqFodRgI+LKKfiEgM=
X-Received: by 2002:a67:fdd0:0:b0:397:c028:db6a with SMTP id
 l16-20020a67fdd0000000b00397c028db6amr11548134vsq.58.1663136000321; Tue, 13
 Sep 2022 23:13:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220909044636.1997755-1-reijiw@google.com>
 <20220909044636.1997755-2-reijiw@google.com>
 <875yhvqzxn.wl-maz@kernel.org>
In-Reply-To: <875yhvqzxn.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 13 Sep 2022 23:13:04 -0700
Message-ID: <CAAeT=Fx5nLCqoNG+gnAZSbWvc9FotWOaQepNLqBZ2Xx_hxcxsw@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Don't set PSTATE.SS when Software Step
 state is Active-pending
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Thank you for the review!

On Sat, Sep 10, 2022 at 3:36 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 09 Sep 2022 05:46:34 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Currently, PSTATE.SS is set on every guest entry if single-step is
> > enabled for the vCPU by userspace.  However, it could cause extra
> > single-step execution without returning to userspace, which shouldn't
> > be performed, if the Software Step state at the last guest exit was
> > Active-pending (i.e. the last exit was not triggered by Software Step
> > exception, but by an asynchronous exception after the single-step
> > execution is performed).
> >
> > Fix this by not setting PSTATE.SS on guest entry if the Software
> > Step state at the last exit was Active-pending.
> >
> > Fixes: 337b99bf7edf ("KVM: arm64: guest debug, add support for single-step")
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
>
> Now that I'm a bit more clued about what the architecture actually
> mandates, I can try and review this patch.
>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  3 +++
> >  arch/arm64/kvm/debug.c            | 19 ++++++++++++++++++-
> >  arch/arm64/kvm/guest.c            |  1 +
> >  arch/arm64/kvm/handle_exit.c      |  2 ++
> >  4 files changed, 24 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index e9c9388ccc02..4cf6eef02565 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -535,6 +535,9 @@ struct kvm_vcpu_arch {
> >  #define IN_WFIT                      __vcpu_single_flag(sflags, BIT(3))
> >  /* vcpu system registers loaded on physical CPU */
> >  #define SYSREGS_ON_CPU               __vcpu_single_flag(sflags, BIT(4))
> > +/* Software step state is Active-pending */
> > +#define DBG_SS_ACTIVE_PENDING        __vcpu_single_flag(sflags, BIT(5))
> > +
> >
> >  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> >  #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +   \
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index 0b28d7db7c76..125cfb94b4ad 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -188,7 +188,16 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> >                * debugging the system.
> >                */
> >               if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
> > -                     *vcpu_cpsr(vcpu) |=  DBG_SPSR_SS;
> > +                     /*
> > +                      * If the software step state at the last guest exit
> > +                      * was Active-pending, we don't set DBG_SPSR_SS so
> > +                      * that the state is maintained (to not run another
> > +                      * single-step until the pending Software Step
> > +                      * exception is taken).
> > +                      */
> > +                     if (!vcpu_get_flag(vcpu, DBG_SS_ACTIVE_PENDING))
> > +                             *vcpu_cpsr(vcpu) |= DBG_SPSR_SS;
> > +
> >                       mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
> >                       mdscr |= DBG_MDSCR_SS;
> >                       vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
> > @@ -279,6 +288,14 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
> >                                               &vcpu->arch.debug_ptr->dbg_wcr[0],
> >                                               &vcpu->arch.debug_ptr->dbg_wvr[0]);
> >               }
> > +
> > +             if ((vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) &&
> > +                 !(*vcpu_cpsr(vcpu) & DBG_SPSR_SS))
> > +                     /*
> > +                      * Mark the vcpu as ACTIVE_PENDING
> > +                      * until Software Step exception is confirmed.
>
> s/confirmed/taken/? This would match the comment in the previous hunk.

Yes, I will fix that.

>
> > +                      */
> > +                     vcpu_set_flag(vcpu, DBG_SS_ACTIVE_PENDING);
> >       }
> >  }
> >
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index f802a3b3f8db..2ff13a3f8479 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -937,6 +937,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> >       } else {
> >               /* If not enabled clear all flags */
> >               vcpu->guest_debug = 0;
> > +             vcpu_clear_flag(vcpu, DBG_SS_ACTIVE_PENDING);
> >       }
> >
> >  out:
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index bbe5b393d689..8e43b2668d67 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -154,6 +154,8 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
> >
> >       if (ESR_ELx_EC(esr) == ESR_ELx_EC_WATCHPT_LOW)
> >               run->debug.arch.far = vcpu->arch.fault.far_el2;
> > +     else if (ESR_ELx_EC(esr) == ESR_ELx_EC_SOFTSTP_LOW)
> > +             vcpu_clear_flag(vcpu, DBG_SS_ACTIVE_PENDING);
>
> Can we write this as a switch/case statement?

Sure, I will change this to switch/case statement.


>
> >
> >       return 0;
> >  }
>
> I think we also need to do something if userspace decides to write to
> PSTATE as a result of a non-debug exit (such as a signal) when this
> DBG_SS_ACTIVE_PENDING is set. I came up with the following
> complicated, but not impossible scenario:
>
> - guest single step, PSTATE.SS=0
> - exit due to interrupt
> - DBG_SS_ACTIVE_PENDING set
> - reenter guest
> - exit again due to another interrupt
> - exit to userspace due to signal pending
> - userspace writes PSTATE.SS=1 for no good reason
> - we now have an inconsistent state between PSTATE.SS and the vcpu flags
>
> My gut feeling is that we need something like the vcpu flag being set
> to !PSTATE.SS if written while debug is enabled.
>
> Thoughts?

Ah, that's a good point.
Values that KVM is going to set in debug registers (e.g. MDSCR_EL1,
dbg_bcr, etc) at guest-entry cannot be changed by userspace via
SET_ONE_REG when debug is enabled.  I'm inclined to apply the same
for PSTATE.SS (clear PSTATE.SS if the vcpu flag is set on guest entry,
and set PSTATE.SS to 1 otherwise). Since  MDSCR_EL1 value that KVM is
going to set is not visible from userspace, changing Software-step
state when userspace updates PSTATE.SS might be a bit odd IMHO
(something odd anyway though).

Related to the above scenario, I found another bug (I think).
After guest exits with Active-not-pending (PSTATE.SS==1) due to an
interrupt, and then KVM exits to userspace due to signal pending,
if userspace disables single-step, PSTATE.SS will remain 1 on
subsequent guest entries (or it might have been originally 1, and
KVM might clear it.  Most of the time it doesn't matter, and when the
guest is also using single-step, things will go wrong anyway though).

Considering those, I am thinking of changing the patch as follows,
 - Change kvm_arm_setup_debug() to clear PSTATE.SS if the vcpu flag
   (DBG_SS_ACTIVE_PENDING) is set, and set PSTATE.SS to 1 otherwise.
 - Change save_guest_debug_regs()/restore_guest_debug_regs() to
   save/restore the guest value of PSTATE.SS
   (Add a new field in kvm_vcpu_arch.guest_debug_preserved to save
    the guest value of PSTATE.SS)
keeping the other changes in the patch below.
 - Clear DBG_SS_ACTIVE_PENDING in kvm_handle_guest_debug()
 - Clear DBG_SS_ACTIVE_PENDING when userspace disables single-step

With this, PSTATE.SS value that KVM is going to set on guest-entry
won't be exposed to userspace, and PSTATE.SS value that is set by
userspace will not be used for the guest until single-step is
disabled (similar to MDSCR_EL1).

What do you think ?

Thank you,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
