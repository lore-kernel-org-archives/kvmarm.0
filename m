Return-Path: <SRS0=/4wP=NK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E967BC4338F
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 08:16:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A0556112E
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 08:16:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5A0556112E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D564B4B10B;
	Thu, 19 Aug 2021 04:16:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id USoIIizxN1yH; Thu, 19 Aug 2021 04:16:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E02FE4B10E;
	Thu, 19 Aug 2021 04:16:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C59F74B10C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 04:16:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oez1VtKgBHvb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Aug 2021 04:16:32 -0400 (EDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com
 [209.85.167.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 769354B10B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 04:16:32 -0400 (EDT)
Received: by mail-lf1-f49.google.com with SMTP id y34so10999121lfa.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 01:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=yIjfNruIRqoaZMP1dFgzuYg2bekGFWIjBtMbeKsjOv4=;
 b=Uh1Rb4Tubmyt9cse91ISt5kDTlQA5cOUNtpTo3ndsgr8Ck+k+NFexFFUz7dyuM2H3t
 m3kAPtmzO3DBlZuQbQOS1BGJjUv9r6yFgy0WnVgPSxucBCkqke5QvTkuTCy+8oy0eOTb
 JkmkswyVt1D3ZoaYkI5dov/HLiOeTx2Mr0bQ2TJFhtusQPTrCpPomFM4IItSUMn8JFmy
 Q9HWWiKPZA6ri/QVNnb34rhV/YDwcBDhhZlbiewsQu0Tsb8x3P4CosXJJGeXo3yOBl4Y
 D8HnhI1tOhAnkfLZwT3K4kw7633qGlsmUBv1GFT8pq0ffBfsjvKvZ0yKkegYDWU7Uxxr
 5cGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=yIjfNruIRqoaZMP1dFgzuYg2bekGFWIjBtMbeKsjOv4=;
 b=caIKGmr689Be1Hw/B5Z0kQC036RSyBIM8l2cwfRPv7DD48L5S6RsqLpHy0hGo9Pttr
 Ys4inqkHenpmpwvk+3jEjG6c3e/6jh22f/fFs3aB26baDgjiDURb5M662CO+5PLHDFMF
 pjwzXoCFs0o3kwEplHmFkMrEuPUM5MCV32DwtWiLYuN2xcKRsx1vIR7OCXY6HGTYmY9H
 4BUCVjRRBnjnNn2fCajEC4DqUuoxO9qKW1BFc3L2gpo1mhI2QuV+f/Mb/7imfmmkwNX6
 9pHb3mo2Bi2NcuUNP3qciQXtWyNXKUK6QszhNmSpvDvkJ2j/Vj2Bfb3kaxJ8A/mw/nbn
 oAiw==
X-Gm-Message-State: AOAM5334r2myjsVH3aosdRBRFarlb0pAKHHF+Ujf3yqyNpozmn6GqPxl
 fez+KwfK5dz9FkUlw8zZhWyGiMZ9VWtT0DAQodJSqA==
X-Google-Smtp-Source: ABdhPJwrWW9U4piKXkDbBKX+qAG8nI3LRbhJGUFw/CctYUBkZ/9YzEYznpDVd1/rjsXd1dFJ2yjXMXs2F+/onMOvPlM=
X-Received: by 2002:a05:6512:4025:: with SMTP id
 br37mr9473510lfb.23.1629360990837; 
 Thu, 19 Aug 2021 01:16:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210818213205.598471-1-ricarkol@google.com>
 <CAOQ_QshVenuri8WdZdEis4szCv03U0KRNt4CqDNtvUBsqBqUoA@mail.gmail.com>
 <YR1/YEY8DX+r05nt@google.com>
 <CAOQ_Qsgy7d7pWc=0AHpR2LHO67Z=gCa-TV46NxXMsFP8yqOzTw@mail.gmail.com>
 <877dghsvvt.wl-maz@kernel.org>
In-Reply-To: <877dghsvvt.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Thu, 19 Aug 2021 01:16:19 -0700
Message-ID: <CAOQ_QsiwWHWM_p8KOdehtCFP_yUzsCp7uF0ePXn9EGmvfYD7Aw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: vgic: drop WARN from vgic_get_irq
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, pshier@google.com,
 rananta@google.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Aug 19, 2021 at 1:04 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 19 Aug 2021 08:41:19 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > On Wed, Aug 18, 2021 at 2:45 PM Ricardo Koller <ricarkol@google.com> wrote:
> > >
> > > On Wed, Aug 18, 2021 at 02:34:03PM -0700, Oliver Upton wrote:
> > > > Hi Ricardo,
> > > >
> > > > On Wed, Aug 18, 2021 at 2:32 PM Ricardo Koller <ricarkol@google.com> wrote:
> > > > >
> > > > > vgic_get_irq(intid) is used all over the vgic code in order to get a
> > > > > reference to a struct irq. It warns whenever intid is not a valid number
> > > > > (like when it's a reserved IRQ number). The issue is that this warning
> > > > > can be triggered from userspace (e.g., KVM_IRQ_LINE for intid 1020).
> > > > >
> > > > > Drop the WARN call from vgic_get_irq.
> > > > >
> > > > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > > > ---
> > > > >  arch/arm64/kvm/vgic/vgic.c | 1 -
> > > > >  1 file changed, 1 deletion(-)
> > > > >
> > > > > diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> > > > > index 111bff47e471..81cec508d413 100644
> > > > > --- a/arch/arm64/kvm/vgic/vgic.c
> > > > > +++ b/arch/arm64/kvm/vgic/vgic.c
> > > > > @@ -106,7 +106,6 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
> > > > >         if (intid >= VGIC_MIN_LPI)
> > > > >                 return vgic_get_lpi(kvm, intid);
> > > > >
> > > > > -       WARN(1, "Looking up struct vgic_irq for reserved INTID");
> > > >
> > > > Could we maybe downgrade the message to WARN_ONCE() (to get a stack)
> > > > or pr_warn_ratelimited()? I agree it is problematic that userspace can
> > > > cause this WARN to fire, but it'd be helpful for debugging too.
> > > >
> > >
> > > Was thinking about that, until I found this in bug.h:
> > >
> > >         /*
> > >          * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
> > >          * significant kernel issues that need prompt attention if they should ever
> > >          * appear at runtime.
> > >          *
> > >          * Do not use these macros when checking for invalid external inputs
> > >          * (e.g. invalid system call arguments, or invalid data coming from
> > >          * network/devices),
> > >
> > > Just in case, KVM_IRQ_LINE returns -EINVAL for an invalid intid (like
> > > 1020). I think it's more appropriate for the vmm to log it. What do you
> > > think?
> >
> > vgic_get_irq() is called in a bunch of other places though, right?
> > IOW, intid doesn't necessarily come from userspace. In fact, I believe
> > KVM_IRQ_LINE is the only place we pass a value from userspace to
> > vgic_get_irq() (don't quote me on that).
> >
> > Perhaps instead the fix could be to explicitly check that the intid
> > from userspace is valid and exit early rather than count on
> > vgic_get_irq() to do the right thing.
>
> vgic_get_irq() is designed to do the right thing. Returning NULL is
> the way it reports an error, and this NULL value is already checked at
> when directly provided either by the VMM or the guest. If we missed
> any of those, that would be what needs addressing.  Obtaining a NULL
> pointer is a good way to catch those.
>
> In general, the kernel log is not how we report userspace errors (we
> have been there before...). It is slow, noisy, unclear and ultimately
> leaks information.

Absolutely. My comments were aimed at calls to vgic_get_irq() where
intid is coming from the kernel, not userspace. That being said,
probably no good reason to buy a full fat WARN() in a function such as
this one.  I'm done waffling on this one liner now :)

Reviewed-by: Oliver Upton <oupton@google.com>

> If you really want something, then a pr_debug is a
> potential tool as it can be dynamically enabled with the right
> configuration.
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
