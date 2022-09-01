Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15903ECAAD8
	for <kvmarm@archiver.kernel.org>; Thu,  1 Sep 2022 04:57:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E61F4B882;
	Thu,  1 Sep 2022 00:57:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id auimlZF2vvCj; Thu,  1 Sep 2022 00:57:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 643994B3EF;
	Thu,  1 Sep 2022 00:57:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E80E4B6B7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2022 00:57:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x5udDDPIPi7C for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2022 00:57:51 -0400 (EDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com
 [209.85.217.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 178E14B325
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2022 00:57:50 -0400 (EDT)
Received: by mail-vs1-f54.google.com with SMTP id i12so9841445vsr.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Aug 2022 21:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=B8g7g91aP9xKSAm6D4rDZLFf8Csm7hufubO+9r3JISE=;
 b=lR76BHAsKGqCqMAip83JIRKcbQrOqP4WBI3OO2OIUEhzs6mqBVrr0ya265N0efAC0J
 Tg3Ku1w8X8Q2kxcqD4PjQpW+GehgIpRt4244KMkt+q8ulVShTe12Pq7HfO0WRCQpWd+i
 ml6RZb/mry+f4xONOSFDMJGLCRDpEiiFFXlJZWU2Q3g7VdUpc22vXBaqp/cEmBiSS5LL
 KvXUJ5QbxbU9f4bd7oB+n3R7Vq3pvXnrXCxB7sFIXoBz1jZSTaJkPFZbZwmIG8cQ67Jx
 zSbEJHu39pttOE0iA7SLzuvqkCIS+GcOpKFIfDt2Dmc0jkQwC17aBZdKFECoGt+uAuHx
 x9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=B8g7g91aP9xKSAm6D4rDZLFf8Csm7hufubO+9r3JISE=;
 b=72SKaaRiVl14Xkf1HGaxSixi6HbAwfjUOQmzUilX3F4AVws9GMMftJ6Wt07xVXM1LS
 nwg3v2zU/V5dUhq6ZNOaMhHFBDCtzzClAf03MFqs7jDXgPcaHaui3JSUFeci33bI4QsA
 ZppvVWXHhA5ofrPOAgS2L7iwtDiXMJqvDrmtaeVE5drdqgMreSmSs1uJ1WyODlS0qY8H
 Hgau+NV+q29V43QZ5r+aHFJJVFvsZFYAgmcWsGTjjf9YTpKvmtU4TTbyiWnb9h2DLDkO
 imoR6yTephqucKzfBYTwQUpZZBqjLPj1IoeKGJKU+nT4XYLIE4CoLMX2zRq1RppTQN47
 +C2A==
X-Gm-Message-State: ACgBeo3xV1PtTLgjtzcvi/Bj8kJ/twnXb440/Yq3sf94m4JY5cwisvSH
 g9fw1al3e7+0Wr/XBbJF09RZUBVnGX0ri0qkStTzIQ==
X-Google-Smtp-Source: AA6agR7b1cPfhtU9ZPhbpcg9h3wsuJqViFmM9NHos3Zouc5tJCy7g1KD65lghrbB5BHfCwx7uUFsJigcc9iDRwoW6h8=
X-Received: by 2002:a67:b009:0:b0:38a:e0f2:4108 with SMTP id
 z9-20020a67b009000000b0038ae0f24108mr8091964vse.9.1662008270405; Wed, 31 Aug
 2022 21:57:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220817214818.3243383-1-oliver.upton@linux.dev>
 <20220817214818.3243383-5-oliver.upton@linux.dev>
 <CAAeT=FzQkgf7g3yXP++u_2zio1XL9mRSzPZ6hxmanwVk4QUNbQ@mail.gmail.com>
 <Yw9zQaxuSFlVsf5O@google.com>
In-Reply-To: <Yw9zQaxuSFlVsf5O@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 31 Aug 2022 21:57:34 -0700
Message-ID: <CAAeT=FyjM2n1KL-9JSTfZ=RMDKSfmgN23PCnhBmvVwDz-9ZjXQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] KVM: arm64: Add a visibility bit to ignore user writes
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Wed, Aug 31, 2022 at 7:42 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Tue, Aug 30, 2022 at 08:29:37PM -0700, Reiji Watanabe wrote:
> > Hi Oliver,
> >
> > On Wed, Aug 17, 2022 at 2:48 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > >
> > > We're about to ignore writes to AArch32 ID registers on AArch64-only
> > > systems. Add a bit to indicate a register is handled as write ignore
> > > when accessed from userspace.
> > >
> > > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > > ---
> > >  arch/arm64/kvm/sys_regs.c | 3 +++
> > >  arch/arm64/kvm/sys_regs.h | 7 +++++++
> > >  2 files changed, 10 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 26210f3a0b27..9f06c85f26b8 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -1232,6 +1232,9 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > >  {
> > >         bool raz = sysreg_visible_as_raz(vcpu, rd);
> > >
> > > +       if (sysreg_user_write_ignore(vcpu, rd))
> > > +               return 0;
> >
> > Since the visibility flags are not ID register specific,
> > have you considered checking REG_USER_WI from kvm_sys_reg_set_user()
> > rather than the ID register specific function ?
>
> Yeah, that's definitely a better place to wire it in.
>
> > This patch made me reconsider my comment for the patch-2.
> > Perhaps it might be more appropriate to check RAZ visibility from
> > kvm_sys_reg_get_user() rather than the ID register specific function ?
>
> REG_RAZ hides the register value from the guest as well as userspace, so it
> might be better to leave it in place. REG_RAZ also has implications for
> writing a register from userspace, as we still apply the expectation of
> invariance to ID registers that set this flag.
>
> It all 'just works' right now with the check buried in the ID register
> accessors. Going the other way around would require sprinkling the check
> in several locations.

Ah, I see the handling of REG_RAZ is a bit tricky...
I kind of suspect that REG_RAZ won't probably be used for any registers
other than ID registers even in the future...

Anyway, yes, it might be better to leave it in place at least for now.

Thank you,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
