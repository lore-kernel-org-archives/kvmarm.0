Return-Path: <SRS0=hs0s=PY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C6CC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 05:36:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CD1C361283
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 05:36:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CD1C361283
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50A304086F;
	Fri,  5 Nov 2021 01:36:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7Btu+9H6mUgS; Fri,  5 Nov 2021 01:36:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B0BA4B0F1;
	Fri,  5 Nov 2021 01:36:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 885E04B0F1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 01:36:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nsEYqHJJdbo6 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Nov 2021 01:36:47 -0400 (EDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com
 [209.85.167.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50DA14024F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 01:36:47 -0400 (EDT)
Received: by mail-lf1-f46.google.com with SMTP id x27so16540528lfu.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Nov 2021 22:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=5Le5Akq/lLNHfW+ACWvF/lDzejDp+WOssI/Klk1stMA=;
 b=OgQLhazLrEPYEDYrelueE2X8jJx+zu4fuCkHALRCPejgs1CpaggSdEXEgHypuwb4VV
 IMxR8yZ6H/Mwdd3PLdL+DDU6QCVLAp89GfqMxK3AXc/tCb61yW+Q9JRL+lYTidew4VOV
 uwyEEh4Gwei+J9krQwGqe9hXSamizJG7/34871VA242B1qLqkFCwJTjZOoN5KDv438h1
 63WVF7bqoknA9qybq7EecyKKk7r0OqPN+fxGUNnmLVYwlm+XT98b0I9H2hnQAqzczj0N
 IWfC4INooR51z83b2QmXsdxV/h8tDZNzYA3gPTDfU9YlfVB1raXjuziX8v2m+adlAh/8
 23bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=5Le5Akq/lLNHfW+ACWvF/lDzejDp+WOssI/Klk1stMA=;
 b=Ojyqa++Kug1ulOJbSG4Hq84mtBTA3/I+x+h4cP9isLspDpnA30F9h8o5QRqONVlvBV
 OdevAPVQzWXu85u/0SBduftX+N7fa9H5bq5y+beDtMf500fIBPGYi5nVpee/lX2HmIYf
 LDqXiP32MnJwdg4rmrRFFLU6sCXT3dDGl84eo9NtsxOrF1eMY3MVT8V/nav4HGgfmq08
 ozbYCteFqS5b0D3f/W+fpWZHMtXZLYj/LAqQaBen2D8AfeFakJXlySQLNsbvDT0B8fts
 QeplxpR5iAw1oGsRMgEfeMZKKztfworgQX8u7AL7H8k2jghgIMh5yHmDQt9wwb1GTkt2
 UAyA==
X-Gm-Message-State: AOAM531KZCBKCQE2Zdy3D8Pul1U3izIZ67/pkx0PWJ67bIGd0gR8rb52
 UM0pm/+L8+lgIyNSlwWDR1SQ/BtuNo4HmGP9B25XvA==
X-Google-Smtp-Source: ABdhPJyNUuISSdEPBd3M4w6ZjW+jtk9a314Xeh6niI4f9CO4Jdi23JUL/bOS8pQ1DFehgvxl9D6sizD87Y+0y+M0SYM=
X-Received: by 2002:a05:6512:3d90:: with SMTP id
 k16mr4911113lfv.361.1636090605698; 
 Thu, 04 Nov 2021 22:36:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
 <20211102094651.2071532-5-oupton@google.com>
 <CAAeT=FwKJLaxNU+2BGWZh=HdTY=NWBzGdN=cTDPKv3x6cG2UsA@mail.gmail.com>
In-Reply-To: <CAAeT=FwKJLaxNU+2BGWZh=HdTY=NWBzGdN=cTDPKv3x6cG2UsA@mail.gmail.com>
From: Oliver Upton <oupton@google.com>
Date: Thu, 4 Nov 2021 22:36:34 -0700
Message-ID: <CAOQ_QshXAzRkKXJjp5Q6KEHQ8vFkc1hVnktEj82nBLN8+=_42w@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Emulate the OS Lock
To: Reiji Watanabe <reijiw@google.com>
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

On Thu, Nov 4, 2021 at 8:56 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Oliver,
>
> On Tue, Nov 2, 2021 at 2:47 AM Oliver Upton <oupton@google.com> wrote:
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
> > +#define kvm_vcpu_os_lock_enabled(vcpu)         \
> > +       (__vcpu_sys_reg(vcpu, OSLSR_EL1) & SYS_OSLSR_OSLK)
>
> I would think the name of this macro might sound like it generates
> a code that is evaluated as bool :)

Hey! Nobody ever said this would coerce the returned value into a bool :-P

In all seriousness, good point. I agree that the statement should
obviously evaluate to a bool, given the naming of the macro.

>
> > +
> >  int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
> >                                struct kvm_device_attr *attr);
> >  int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index db9361338b2a..5690a9c99c89 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -95,8 +95,11 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
> >                                 MDCR_EL2_TDRA |
> >                                 MDCR_EL2_TDOSA);
> >
> > -       /* Is the VM being debugged by userspace? */
> > -       if (vcpu->guest_debug)
> > +       /*
> > +        * Check if the VM is being debugged by userspace or the guest has
> > +        * enabled the OS lock.
> > +        */
> > +       if (vcpu->guest_debug || kvm_vcpu_os_lock_enabled(vcpu))
>
> IMHO, it might be nicer to create a macro or function that abstracts the
> condition that needs save_guest_debug_regs/restore_guest_debug_regs.
> (rather than putting those conditions in each part of codes where they
> are needed)
>

I completely agree, and it comes with the added benefit that the
macro/function can be named something informative so as to suggest the
purpose for saving guest registers.

Thanks for the review!

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
