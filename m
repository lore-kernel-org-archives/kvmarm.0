Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA56C43334
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 04:47:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CEA54B315;
	Tue,  7 Jun 2022 00:47:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2znn2Y2KxKFH; Tue,  7 Jun 2022 00:47:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E154B4B2AE;
	Tue,  7 Jun 2022 00:47:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B2434B226
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 00:47:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nK8y7TQ31Gnj for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2022 00:47:33 -0400 (EDT)
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com
 [209.85.167.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 687704B214
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 00:47:33 -0400 (EDT)
Received: by mail-oi1-f180.google.com with SMTP id k11so22422889oia.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jun 2022 21:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=T1Oeoa7n5QDG+gTsiG56VGoP7hbCIGDGBtXMObcL+RI=;
 b=SIZk76Vz626zA8ncZ4xYPOa5eJlc0AzzPErAw21oJSIIGA1id6K3+ztfhxwwms5Fhq
 F+u1W8bakEjgZREX6uhVJ/YMt/diOemeBi0N9+uSsgQKFBYSP7PJn2P6Yonxk0Y1+c/6
 HNPpzV4asEPt9lUEKvFPZMqtO6DXBg4YluZ3qEbn3iG6Al6K7j+vvswIhCSRUuKpGbcv
 J/ko2uVFP8u0cVr0lusbBUmkrq9j0BvAg3JsPZ2UsF3RzhS0/OqOn5Wo/zyf/jGlWnfK
 1quBbjq2H7+B58i3cSCtYHpHhURdZViDZnuqbdp7E9WJh5e1sWJBIMSq+yxlsyfdGo8e
 CeCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=T1Oeoa7n5QDG+gTsiG56VGoP7hbCIGDGBtXMObcL+RI=;
 b=FZrKJrDBSktUsVpmva5DSgo58BZIh9JL+2CJyRaZ+dr1tUIk8KNJTA1EQW6Hy3kO9P
 SZPlc//AFCRPsTudBHhScTlkzOmL0j2vUnW5JHFuYBr0Em6Uk96hAxbGWj4gy/mMGxYb
 rfW+ubgEZPgMhldFMldGpGHG8cuJHiu5pgUgQ0Ls9fIdJ+lw36qpHpCYrARIFjB1H44m
 5szyQ2uJ4WIJxfvSGxkyoFutxEgcdo+viupuhodb0gHdaxo5i2UizPoxymPU6MxtIbqg
 bbzQ6uXUVZn1LKxUYa6+1fs1UKQsTJnq3P/XPTbnVwBw2X60cYJ6Tn2gW8ib9Kv6icS5
 M2GA==
X-Gm-Message-State: AOAM532jaHRCEzLf19/mRWRmquQmQ6wQKzRAma+6f0ZGCI6fT82x9adk
 yBmzeGIRdpuZxlMvJP4eZ7uMeQUuMcVkFoP+DDsYHg==
X-Google-Smtp-Source: ABdhPJzM/y1Bdi+IWw5eq1YlfditPyyuVf2cLfzRK+X6/I314sxKlnjQR10W7nJpF/C+Qr5u4SPzl6E/ps4EXbjxwIk=
X-Received: by 2002:a05:6808:3198:b0:32b:a54:1238 with SMTP id
 cd24-20020a056808319800b0032b0a541238mr31223949oib.16.1654577252563; Mon, 06
 Jun 2022 21:47:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-4-maz@kernel.org>
 <CAAeT=FxmD4Nsrodr-FCjpNghAormCg4P+R7hF3+g_wfQ5T12Rg@mail.gmail.com>
 <87wndwluhy.wl-maz@kernel.org>
In-Reply-To: <87wndwluhy.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 6 Jun 2022 21:47:16 -0700
Message-ID: <CAAeT=FxcUF-nNhzwSTQm_oueF4Cu_8nDdFfoCi33HOpOZaBjXg@mail.gmail.com>
Subject: Re: [PATCH 03/18] KVM: arm64: Drop FP_FOREIGN_STATE from the
 hypervisor code
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
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

On Sat, Jun 4, 2022 at 1:10 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 03 Jun 2022 06:23:25 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Sat, May 28, 2022 at 4:38 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > The vcpu KVM_ARM64_FP_FOREIGN_FPSTATE flag tracks the thread's own
> > > TIF_FOREIGN_FPSTATE so that we can evaluate just before running
> > > the vcpu whether it the FP regs contain something that is owned
> > > by the vcpu or not by updating the rest of the FP flags.
> > >
> > > We do this in the hypervisor code in order to make sure we're
> > > in a context where we are not interruptible. But we already
> > > have a hook in the run loop to generate this flag. We may as
> > > well update the FP flags directly and save the pointless flag
> > > tracking.
> > >
> > > Whilst we're at it, rename update_fp_enabled() to guest_owns_fp_regs()
> > > to indicate what the leftover of this helper actually do.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> >
> > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> >
> >
> > > --- a/arch/arm64/kvm/fpsimd.c
> > > +++ b/arch/arm64/kvm/fpsimd.c
> > > @@ -107,16 +107,19 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
> > >  }
> > >
> > >  /*
> > > - * Called just before entering the guest once we are no longer
> > > - * preemptable. Syncs the host's TIF_FOREIGN_FPSTATE with the KVM
> > > - * mirror of the flag used by the hypervisor.
> > > + * Called just before entering the guest once we are no longer preemptable
> > > + * and interrupts are disabled. If we have managed to run anything using
> > > + * FP while we were preemptible (such as off the back of an interrupt),
> > > + * then neither the host nor the guest own the FP hardware (and it was the
> > > + * responsibility of the code that used FP to save the existing state).
> > > + *
> > > + * Note that not supporting FP is basically the same thing as far as the
> > > + * hypervisor is concerned (nothing to save).
> > >   */
> > >  void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu)
> > >  {
> > > -       if (test_thread_flag(TIF_FOREIGN_FPSTATE))
> > > -               vcpu->arch.flags |= KVM_ARM64_FP_FOREIGN_FPSTATE;
> > > -       else
> > > -               vcpu->arch.flags &= ~KVM_ARM64_FP_FOREIGN_FPSTATE;
> > > +       if (!system_supports_fpsimd() || test_thread_flag(TIF_FOREIGN_FPSTATE))
> > > +               vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED | KVM_ARM64_FP_HOST);
> > >  }
> >
> > Although kvm_arch_vcpu_load_fp() unconditionally sets KVM_ARM64_FP_HOST,
> > perhaps having kvm_arch_vcpu_load_fp() set KVM_ARM64_FP_HOST only when
> > FP is supported might be more consistent?
> > Then, checking system_supports_fpsimd() is unnecessary here.
> > (KVM_ARM64_FP_ENABLED is not set when FP is not supported)
>
> That's indeed a possibility. But I'm trying not to change the logic
> here, only to move it to a place that provides the same semantic
> without the need for an extra flag.
>
> I'm happy to stack an extra patch on top of this series though.

Thank you for your reply. I would prefer that.

Thanks,
Reiji



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
