Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6FAC6FA82
	for <kvmarm@archiver.kernel.org>; Sat, 10 Sep 2022 04:13:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06AC34C1E8;
	Sat, 10 Sep 2022 00:13:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yf0mKyPJiptR; Sat, 10 Sep 2022 00:13:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F0594BF54;
	Sat, 10 Sep 2022 00:13:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0E1D4BF14
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Sep 2022 00:13:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uQkkBOSn2fFA for <kvmarm@lists.cs.columbia.edu>;
 Sat, 10 Sep 2022 00:13:14 -0400 (EDT)
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com
 [209.85.217.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C2214BF0E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Sep 2022 00:13:14 -0400 (EDT)
Received: by mail-vs1-f47.google.com with SMTP id 190so3648042vsz.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Sep 2022 21:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=bT+lvXkm6Qe6+nTGGZtBv81BtvgBawrDwZvucM+h94M=;
 b=Yys0KwKHTO+vzTZHw3AkKTcwnUZvMyJM+/WUxQmJjsT87vwqfEWFuN3IyPDJ8gPx3a
 NqQi0USCw1ZfeJkzhhFJqaxYFKW8KP5mvIMwBxp3xs0Ax/mlVLTnW74LrtYjlISyP6Nu
 Qmdv71WFERQ9fnzJbq4556HnCJkVvBESHXxXk9W7J+iVMSukzqttWwGjnwoEpQ8ThYAt
 WGwU0sCuMBPWjPYQ8EL8Ldn12lXjDxgA7dQ4g8pmMM8zi8rBiCk5PAS/RnTseO3ggzMD
 ICjcHCnGCHRLdFBfhynEOmkL76h+RA0CoSV3nSLQ88rdhD6P/GMybofb2ADNE6Ehkpmz
 V/GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=bT+lvXkm6Qe6+nTGGZtBv81BtvgBawrDwZvucM+h94M=;
 b=GuRDkupUuRTDE+mHSZ/FVrryfxnyJs2TYXsNDbAkF0s0fMwJ9JXhsyJJuzrvrM49Jg
 CnaLkbk63mAmVPAR9sXWybdcuXxMeJKHj654SCnkbEHISiHj2uv81HPftYZQ3yI7ZK6f
 XrIPRZBiMeTDiG8zf+MHH+jYw3lGvlwfhtKvc8dQ/hjjESKlTfufHZ3Vp2+FG+eMG/aO
 B9cOgVYqtKdWRAWn0Fn8kf0P8iCGIWel237aOCoH+8ABGfxSsIAd8pnODVfJyUpw21Bg
 G+Pnz/krjeNl4MJXUCMg38PwU8ugGUBgU0XZ8yOvrrLtGlug45JkIaitgiJr5fEhQz41
 xevw==
X-Gm-Message-State: ACgBeo1r+lD2rvkn8w5YUDRGRaocqL+oNR6Qzr7b0XaF/ULw2YCXA66R
 Nbj3Na2aJcscg8D3kLS0a9PQgNcoCizQ8YGBUJIVxA==
X-Google-Smtp-Source: AA6agR5RrXixyzKCzUB/EJrVm8Zhg8tpR3LDBgWYAO15rG9c2TCzDy3dx942O9xqMNTbp/kZRLU6ckHffxtUmgIfS6w=
X-Received: by 2002:a67:c00b:0:b0:390:8e1f:594a with SMTP id
 v11-20020a67c00b000000b003908e1f594amr6206352vsi.80.1662783193547; Fri, 09
 Sep 2022 21:13:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220909044636.1997755-1-reijiw@google.com>
 <20220909044636.1997755-2-reijiw@google.com>
 <87bkrora8b.wl-maz@kernel.org>
In-Reply-To: <87bkrora8b.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 9 Sep 2022 21:12:57 -0700
Message-ID: <CAAeT=Fz2hU8V8kYZsirjxr01ZH-Q2abkFOHteOac1LfRWus6Rg@mail.gmail.com>
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

On Fri, Sep 9, 2022 at 5:41 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Reiji,
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
>
> For my own enlightenment, could you describe a sequence of events that
> leads to this issue?

Here is an example of the sequences.

 [Usersace]
  | - ioctl(SET_GUEST_DEBUG)
  | - ioctl(KVM_RUN) (vCPU PC==X)
  v
 [KVM]
  | - *vcpu_cpsr(vcpu) |= SPSR_SS;
  | - mdscr |= DBG_MDSCR_SS;
  | - VM Entry
  v
 [Guest] vCPU PC==X
  | - Execute an instruction at PC==X.
  |   PC is updated with X+4, and PSTATE.SS is cleared.
  |
  | !! Asynchronous exception !!
  v
 [KVM] vCPU PC==X+4
  | - The kernel processes the async exception.
  | - handle_exit() returns 1 (don't return to userspace)
  | - *vcpu_cpsr(vcpu) |= SPSR_SS;
  | - mdscr |= DBG_MDSCR_SS;
  | - VM Entry
  v
 [Guest] vCPU PC==X+4
  | - Execute an instruction at PC==X+4.
  |   PC is updated with X+8, PSTATE.SS is cleared.
  |
  | !! Software Step Exception !!
  v
 [KVM] vCPU PC==X+8
  | - run->exit_reason = KVM_EXIT_DEBUG;
  | - Return to userspace
  v
 [Userspace]
    - Userspace sees PC==X+8 (Userspace didn't see PC==X+4).


> > Fix this by not setting PSTATE.SS on guest entry if the Software
> > Step state at the last exit was Active-pending.
> >
> > Fixes: 337b99bf7edf ("KVM: arm64: guest debug, add support for single-step")
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
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
>
> I guess my confusion stems from my (probably wrong) interpretation if
> the SS state is A+P, there is no harm in making it pending again
> (setting the SS bit in PSTATE).

Setting the SS bit in PSTATE (with MDSCR_EL1.SS=1) makes the state
Active-not-pending (not Active-pending) if my interpretation of
the spec is correct.

> > +
> >                       mdscr = vcpu_read_sys_reg(vcpu, MDSCR_EL1);
> >                       mdscr |= DBG_MDSCR_SS;
>
> But it looks like the *pending* state is actually stored in MDSCR
> instead? The spec only mentions this for the A+P state, so this is
> quite likely a bug indeed.

MDSCR_EL1.SS is set even in Active-not-pending state (not just
Active-pending state).  (Or do you mean the state is stored in
some other field in MDSCR ??)


> Now, where does the asynchronous exception comes into play? I found
> this intriguing remark in the ARM ARM:
>
> <quote>
> The Software Step exception has higher priority than all other types
> of synchronous exception. However, the prioritization of this
> exception with respect to any unmasked pending asynchronous exception
> is not defined by the architecture.
> </quote>
>
> Is this what you were referring to in the commit message? I think you
> need to spell it out for us, as I don't fully understand what you are
> fixing nor do I understand the gory details of single-stepping...

Yes, that is what I was referring to.
In "Figure D2-3 Software step state machine" in Arm ARM (DDI 0487I.a),
since KVM currently sets PSTATE.SS to 1 on every Guest Entry (when
single-step is enabled by userspace), KVM always has the CPU in
"Inactive" (the second inactive state from the top) transition to
"Active-not-pending" on the Guest Entry.  With this patch, KVM
have the CPU transitions to "Active-pending" if the state before
"Inactive" was "Active-pending", which indicates the step completed
but Software Step exception is not taken yet, so that Software
Step exception is taken before further single-step is executed.

I'm sorry for the unclear explanation, and
I hope my comments clarify the problem I'm trying to fix.

Thank you,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
