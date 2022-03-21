Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EEBAC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 21 Mar 2022 19:33:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F2A349EEA;
	Mon, 21 Mar 2022 15:33:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cchz5wWC2-UK; Mon, 21 Mar 2022 15:33:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8230749ECB;
	Mon, 21 Mar 2022 15:33:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2FBD49E38
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 13:15:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zDu1C3xeayCi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Mar 2022 13:15:20 -0400 (EDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com
 [209.85.208.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B3E840C2B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 13:15:20 -0400 (EDT)
Received: by mail-lj1-f180.google.com with SMTP id q5so20769377ljb.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 10:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ASR2Tp21xFTBKs2aldi8ocrtwajoK0X33Y9PeeH/QZU=;
 b=DQasT1Sp9Zq9weVTaBBAUkSy7Jl9Mc3HJtFf945qq9AXunEtCTOG164JbIacqmXf6W
 iAaaVHB5+Q1ipwaMayQ7FTjZckUeLBC+3tfERVEEsSuZqRlZNTX1xBHQgOCrEDI2++mu
 VAKVIQPk2Key3jbGlD4PZn3xca+ObSYOwbJ1M4xLrTKN9gWDrVVHqCtSFopJXSWJd/Bu
 TCxHuQ38Ofn5voBFf8/MbG04rmjJ9I5r0LuIMwH34mNc6hxNdh7wrebR+613nFqdCfb3
 qmYY8SHkGtwgFQZdVHhjF99R14lt1xFgtWaifbKQxQTzC9j6UZpA58notU4rLq2RTDy0
 EK7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ASR2Tp21xFTBKs2aldi8ocrtwajoK0X33Y9PeeH/QZU=;
 b=7TcienqPKnjIs4a3NWyDGgnb/AgjBZ/G9/tCFRC4Rcw/8wWSjikWQW10tbUdS03klg
 nOPevPamvtwLRiMTQCPHRYLY9fmnLIK/LG/D1GbIS3P4YiRhppBYrszUmbyitjadCDWn
 zx0QO8cGUCJLUsVTNmmM2BDphnSCFawZxKbW56R0MECbCVY9TEnoZ7DmxtiRGOcSiuXi
 xVwLZrigU88HthmBOT7zPOJcovrlsPFauEGbD5mts3GdzbmXSEKWL5i6aZPE7ijDzKIg
 7inW7YiLHSRq746ubmtysxRHGMVqu8rBHOHMV0KZBw1mqDSeDn2BEJ15sG+rIqAjZNIx
 xTtg==
X-Gm-Message-State: AOAM531SLLy77vBsieYrzO8DcMFEPAbABMN7d/BlX/bPPCdmRh1ece0K
 FDtVS/z2gtPWTskAvsD6cZb7od64gXv/6G9ic61FRA==
X-Google-Smtp-Source: ABdhPJy/ZfSIQDd1JA4aixgH4poyogQFYXTkSKoAkSkbJFmGoOIHzrbSC2uss7OMkvJYkXva6SeI2I7+zD9/CK9PxYM=
X-Received: by 2002:a05:651c:553:b0:247:df66:8698 with SMTP id
 q19-20020a05651c055300b00247df668698mr16133887ljp.331.1647882918885; Mon, 21
 Mar 2022 10:15:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220317005630.3666572-1-jingzhangos@google.com>
 <20220317005630.3666572-3-jingzhangos@google.com>
 <YjLJHDV58GRMxF2P@google.com>
In-Reply-To: <YjLJHDV58GRMxF2P@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 21 Mar 2022 10:14:52 -0700
Message-ID: <CALzav=fnkU3s+RXGO-LVJCj75FsxvR13n-y1nV1ksp=aLF-etA@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] KVM: arm64: Add debug tracepoint for vcpu exits
To: Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Mon, 21 Mar 2022 15:33:40 -0400
Cc: KVM <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>
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

On Wed, Mar 16, 2022 at 10:37 PM Oliver Upton <oupton@google.com> wrote:
>
> Hi Jing,
>
> On Thu, Mar 17, 2022 at 12:56:30AM +0000, Jing Zhang wrote:
> > This tracepoint only provides a hook for poking vcpu exits information,
> > not exported to tracefs.
> > A timestamp is added for the last vcpu exit, which would be useful for
> > analysis for vcpu exits.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 3 +++
> >  arch/arm64/kvm/arm.c              | 2 ++
> >  arch/arm64/kvm/trace_arm.h        | 8 ++++++++
> >  3 files changed, 13 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index daa68b053bdc..576f2c18d008 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -415,6 +415,9 @@ struct kvm_vcpu_arch {
> >
> >       /* Arch specific exit reason */
> >       enum arm_exit_reason exit_reason;
> > +
> > +     /* Timestamp for the last vcpu exit */
> > +     u64 last_exit_time;
> >  };
> >
> >  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index f49ebdd9c990..98631f79c182 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -783,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >       ret = 1;
> >       run->exit_reason = KVM_EXIT_UNKNOWN;
> >       while (ret > 0) {
> > +             trace_kvm_vcpu_exits(vcpu);
> >               /*
> >                * Check conditions before entering the guest
> >                */
> > @@ -898,6 +899,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >               local_irq_enable();
> >
> >               trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> > +             vcpu->arch.last_exit_time = ktime_to_ns(ktime_get());
> >
> >               /* Exit types that need handling before we can be preempted */
> >               handle_exit_early(vcpu, ret);
> > diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
> > index 33e4e7dd2719..3e7dfd640e23 100644
> > --- a/arch/arm64/kvm/trace_arm.h
> > +++ b/arch/arm64/kvm/trace_arm.h
> > @@ -301,6 +301,14 @@ TRACE_EVENT(kvm_timer_emulate,
> >                 __entry->timer_idx, __entry->should_fire)
> >  );
> >
> > +/*
> > + * Following tracepoints are not exported in tracefs and provide hooking
> > + * mechanisms only for testing and debugging purposes.
> > + */
> > +DECLARE_TRACE(kvm_vcpu_exits,
> > +     TP_PROTO(struct kvm_vcpu *vcpu),
> > +     TP_ARGS(vcpu));
> > +
>
> When we were discussing this earlier, I wasn't aware of the kvm_exit
> tracepoint which I think encapsulates what you're looking for.
> ESR_EL2.EC is the critical piece to determine what caused the exit.
>
> It is probably also important to call out that this trace point only
> will fire for a 'full' KVM exit (i.e. out of hyp and back to the
> kernel). There are several instances where the exit is handled in hyp
> and we immediately resume the guest.
>
> Now -- I am bordering on clueless with tracepoints, but it isn't
> immediately obvious how the attached program can determine the vCPU that
> triggered the TP. If we are going to propose modularizing certain KVM
> metrics with tracepoints then that would be a rather critical piece of
> information.
>
> Apologies for any confusion I added to the whole situation, but
> hopefully we can still engage in a broader conversation regarding
> how to package up optional KVM metrics.

These are all good questions.

For context to non-Google folks on the mailing list, we are interested
in exploring Marc's idea of using tracepoint hooking as a way for e.g.
cloud providers to implement proprietary stats without having to
modify KVM.

Adding specific tracepoints (like this series does) is probably
premature until we have figured out the broader design for how
out-of-module stats will work end-to-end and get that infrastructure
merged upstream.

>
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
