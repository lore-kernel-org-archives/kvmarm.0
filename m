Return-Path: <SRS0=/4wP=NK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E920C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 07:41:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D684261131
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 07:41:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D684261131
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 512104B0F0;
	Thu, 19 Aug 2021 03:41:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lb3Q-E1erpL4; Thu, 19 Aug 2021 03:41:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61DC14B0BF;
	Thu, 19 Aug 2021 03:41:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00A2D4B0BF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 03:41:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JiL4BeWj8eqg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Aug 2021 03:41:32 -0400 (EDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com
 [209.85.208.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2FB64B0BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 03:41:31 -0400 (EDT)
Received: by mail-lj1-f178.google.com with SMTP id i28so9928232ljm.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 00:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=tsSNbeEBNZSbQ4voZetX+01VzHddj7y0XxzZ0nw5plA=;
 b=UCPTM5pjh10EmmOOZD+LSwf70oIaUZEdd1Tk1Rt3fTZiGFM484FgkC68jJsHZRO0Fi
 jcsfJe3ddGYzaDwPLaasj7kp7b+8ClmMD0NgRNtAOpILPyah+mcSq1LDuXXbxf2yyjmu
 QVOLTI4HPYq6OPd2edlHh8MuMBYT6dE0EMHLruk7gYFHAXEmkipyx4hkzU2bNBZxB1eh
 sP5oHtNqH4OttIEmHbvPREPnYyROFFH7rNiyOBdWAZgFi3z0ZKUQKIKLOmt4QzWd5w+c
 QQmX4ubZUTe/KIcaHfhyOE4RORu1pG1A6L9pkeSr7070hgBTJLC7jNHN4qUdp9h1I0Qk
 bJxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=tsSNbeEBNZSbQ4voZetX+01VzHddj7y0XxzZ0nw5plA=;
 b=H8kAlVMvBm77sni5gNMtpvSdPHZ8dw3DKMk7IPajIZ5YULDg/0yAI0A62MAEHAXtmR
 u7U8VPnC95pxTGhP3WS9FdJ+EXNuabCHu5X+88h3zJok56ulhT46nZDF489y7zTsSVEM
 wnVlJwTWCpCdYSM5Ll7PsTZN8CWvVER6o+mgcNwylRpn/17XyjZSdEh7QX2UwRDqq1ao
 UdDobcvUpSSFzh3HCZJ3pv02PhyiH2s1q94wnAWqmGAVGteMeIjI9A6RRbqD/MHNZr1w
 WY+XrR9Mg8+v0GoGrdEdQk9ZARal6gCdi1Vx1wpKk1pSs1WD+vMop4Orp7PARFYgukIf
 sVxQ==
X-Gm-Message-State: AOAM5322W9nv6HMSXNAWY5Pf6RVSm64o3mYP+ctbo0TZifEDOOyNFloq
 yI3Ljqhse5ox3s2ScLESkOa3RnCvSm4QFz2icKZG5Q==
X-Google-Smtp-Source: ABdhPJznhi5l6W4aAokZEBPq3d/0zfR9rl3JaVxso8Q5Na5AMA8G8yWoZ++IGCK2T9z/3+3PJsjU9nTjVMBSL2fZxHY=
X-Received: by 2002:a05:651c:33b:: with SMTP id
 b27mr11512410ljp.314.1629358890171; 
 Thu, 19 Aug 2021 00:41:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210818213205.598471-1-ricarkol@google.com>
 <CAOQ_QshVenuri8WdZdEis4szCv03U0KRNt4CqDNtvUBsqBqUoA@mail.gmail.com>
 <YR1/YEY8DX+r05nt@google.com>
In-Reply-To: <YR1/YEY8DX+r05nt@google.com>
From: Oliver Upton <oupton@google.com>
Date: Thu, 19 Aug 2021 00:41:19 -0700
Message-ID: <CAOQ_Qsgy7d7pWc=0AHpR2LHO67Z=gCa-TV46NxXMsFP8yqOzTw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: vgic: drop WARN from vgic_get_irq
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, rananta@google.com, pshier@google.com,
 catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Aug 18, 2021 at 2:45 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Wed, Aug 18, 2021 at 02:34:03PM -0700, Oliver Upton wrote:
> > Hi Ricardo,
> >
> > On Wed, Aug 18, 2021 at 2:32 PM Ricardo Koller <ricarkol@google.com> wrote:
> > >
> > > vgic_get_irq(intid) is used all over the vgic code in order to get a
> > > reference to a struct irq. It warns whenever intid is not a valid number
> > > (like when it's a reserved IRQ number). The issue is that this warning
> > > can be triggered from userspace (e.g., KVM_IRQ_LINE for intid 1020).
> > >
> > > Drop the WARN call from vgic_get_irq.
> > >
> > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > ---
> > >  arch/arm64/kvm/vgic/vgic.c | 1 -
> > >  1 file changed, 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> > > index 111bff47e471..81cec508d413 100644
> > > --- a/arch/arm64/kvm/vgic/vgic.c
> > > +++ b/arch/arm64/kvm/vgic/vgic.c
> > > @@ -106,7 +106,6 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
> > >         if (intid >= VGIC_MIN_LPI)
> > >                 return vgic_get_lpi(kvm, intid);
> > >
> > > -       WARN(1, "Looking up struct vgic_irq for reserved INTID");
> >
> > Could we maybe downgrade the message to WARN_ONCE() (to get a stack)
> > or pr_warn_ratelimited()? I agree it is problematic that userspace can
> > cause this WARN to fire, but it'd be helpful for debugging too.
> >
>
> Was thinking about that, until I found this in bug.h:
>
>         /*
>          * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
>          * significant kernel issues that need prompt attention if they should ever
>          * appear at runtime.
>          *
>          * Do not use these macros when checking for invalid external inputs
>          * (e.g. invalid system call arguments, or invalid data coming from
>          * network/devices),
>
> Just in case, KVM_IRQ_LINE returns -EINVAL for an invalid intid (like
> 1020). I think it's more appropriate for the vmm to log it. What do you
> think?

vgic_get_irq() is called in a bunch of other places though, right?
IOW, intid doesn't necessarily come from userspace. In fact, I believe
KVM_IRQ_LINE is the only place we pass a value from userspace to
vgic_get_irq() (don't quote me on that).

Perhaps instead the fix could be to explicitly check that the intid
from userspace is valid and exit early rather than count on
vgic_get_irq() to do the right thing.

--
Thanks,
Oliver

> > >         return NULL;
> > >  }
> > >
> > > --
> > > 2.33.0.rc2.250.ged5fa647cd-goog
> > >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
