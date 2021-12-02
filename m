Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B99DCC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  2 Dec 2021 04:09:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECF6E4086D;
	Wed,  1 Dec 2021 23:09:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lVFM7yys8fjx; Wed,  1 Dec 2021 23:09:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DC504B191;
	Wed,  1 Dec 2021 23:09:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08A0D4B183
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 23:09:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sS6JGxooSmUt for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 23:09:27 -0500 (EST)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B5044086D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 23:09:27 -0500 (EST)
Received: by mail-pj1-f45.google.com with SMTP id h24so19611133pjq.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 20:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=2N85QHtDMNcBqsgUwNly3z4kS+qEOu6OLU80+PIlv/c=;
 b=Phoo5/g80FaemunXqyG1I+YbjABSqeRplXEqYyMMT7Cvi373UIlpQe61OVvHGotCg+
 16pkBNhUK2s3U08jCwz0+3oNImVKoUFceWbyc6XHIMZ9V7GbGhrHWfgqnDQI3IjvqDPT
 MiiZy7u0ihoL1mw9Q3ajy0QEPGuktRjlbefm9IRX7WEPO7BnxLo4vwgBMyyZp0xBDA8V
 h0f1xpM/8yZ8mtzNmh3kEv9zAmDL4QVH+Gag1BwOEuAWeQmppgHKgtb5CYAp/vBK8duO
 sQR309sohYF2q2FWl14qvATrQuRZ+aOQjzgIQxebFthDCoRTd8pn70E5gch8lx3xLwDG
 Tg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=2N85QHtDMNcBqsgUwNly3z4kS+qEOu6OLU80+PIlv/c=;
 b=NOeeiOkALYlIKSwj+NQljeV2yFJt6Rhx0BoaeEmnMlOigp2ptBm61A/3rH7CiRndxx
 PKi/aO5PAniEHcvue6fUWfi0KE8Qlaqs31DJyBRowNcAlDnmWyekq+N9cl9hqFOdLvif
 DjIRuKz+4FqOaeekwxRbCA0Jhl3Fkm2r7y8uTomTAGa0484qZ8f98loZLyPsRqYAWjLv
 qNhIMxNew1+J4axCcVT1ghHKcgDJFiNN2/fs3VOwMOuezlnkJeGVtc2ODjzrA4KR47sr
 GrUK8zxdpWw11qVmiA7PlTOObUxSg3cIrWMiClFT//DvnQ2e5kjSrQw13iRzxAqtwWQ4
 k1ew==
X-Gm-Message-State: AOAM533hpAkunYd6mTiv+9bN2ZOkKcglZZrClORA4JWlHWYhSMUGAexZ
 MAQzqhsB+cLOHp4MWB9DtyGMgPpuDWwIlLxUqW5xcA==
X-Google-Smtp-Source: ABdhPJxsDlo8TGgs6j5Z1iLI19iMEZz85qkEhEpAtj8o6pHeb9vqLMAXvoMausmI1cxcdMPdMSLuTqlM1DnoGFHZcBA=
X-Received: by 2002:a17:90a:e506:: with SMTP id t6mr3046830pjy.9.1638418166415; 
 Wed, 01 Dec 2021 20:09:26 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-4-reijiw@google.com>
 <YaeTs4rUZ9uNNQU7@monolith.localdoman>
In-Reply-To: <YaeTs4rUZ9uNNQU7@monolith.localdoman>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 1 Dec 2021 20:09:10 -0800
Message-ID: <CAAeT=FwktER+aKh4tCEHWQTOSeUkHJzmtPgYjhE=Vv5YMid8WQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 03/29] KVM: arm64: Introduce struct id_reg_info
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Alex,

On Wed, Dec 1, 2021 at 7:24 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi Reiji,
>
> On Tue, Nov 16, 2021 at 10:43:33PM -0800, Reiji Watanabe wrote:
> > This patch lays the groundwork to make ID registers writable.
> >
> > Introduce struct id_reg_info for an ID register to manage the
> > register specific control of its value for the guest, and provide set
> > of functions commonly used for ID registers to make them writable.
> >
> > The id_reg_info is used to do register specific initialization,
> > validation of the ID register and etc.  Not all ID registers must
> > have the id_reg_info. ID registers that don't have the id_reg_info
> > are handled in a common way that is applied to all ID registers.
> >
> > At present, changing an ID register from userspace is allowed only
> > if the ID register has the id_reg_info, but that will be changed
> > by the following patches.
> >
> > No ID register has the structure yet and the following patches
> > will add the id_reg_info for some ID registers.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/sysreg.h |   1 +
> >  arch/arm64/kvm/sys_regs.c       | 226 ++++++++++++++++++++++++++++++--
> >  2 files changed, 218 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index 16b3f1a1d468..597609f26331 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -1197,6 +1197,7 @@
> >  #define ICH_VTR_TDS_MASK     (1 << ICH_VTR_TDS_SHIFT)
> >
> >  #define ARM64_FEATURE_FIELD_BITS     4
> > +#define ARM64_FEATURE_FIELD_MASK     ((1ull << ARM64_FEATURE_FIELD_BITS) - 1)
> >
> >  /* Create a mask for the feature bits of the specified feature. */
> >  #define ARM64_FEATURE_MASK(x)        (GENMASK_ULL(x##_SHIFT + ARM64_FEATURE_FIELD_BITS - 1, x##_SHIFT))
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 5608d3410660..1552cd5581b7 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -265,6 +265,181 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
> >               return read_zero(vcpu, p);
> >  }
> >
> > +/*
> > + * A value for FCT_LOWER_SAFE must be zero and changing that will affect
> > + * ftr_check_types of id_reg_info.
> > + */
> > +enum feature_check_type {
> > +     FCT_LOWER_SAFE = 0,
> > +     FCT_HIGHER_SAFE,
> > +     FCT_HIGHER_OR_ZERO_SAFE,
> > +     FCT_EXACT,
> > +     FCT_EXACT_OR_ZERO_SAFE,
> > +     FCT_IGNORE,     /* Don't check (any value is fine) */
> > +};
> > +
> > +static int arm64_check_feature_one(enum feature_check_type type, int val,
> > +                                int limit)
> > +{
> > +     bool is_safe = false;
> > +
> > +     if (val == limit)
> > +             return 0;
> > +
> > +     switch (type) {
> > +     case FCT_LOWER_SAFE:
> > +             is_safe = (val <= limit);
> > +             break;
> > +     case FCT_HIGHER_OR_ZERO_SAFE:
> > +             if (val == 0) {
> > +                     is_safe = true;
> > +                     break;
> > +             }
> > +             fallthrough;
> > +     case FCT_HIGHER_SAFE:
> > +             is_safe = (val >= limit);
> > +             break;
> > +     case FCT_EXACT:
> > +             break;
> > +     case FCT_EXACT_OR_ZERO_SAFE:
> > +             is_safe = (val == 0);
> > +             break;
> > +     case FCT_IGNORE:
>
> What happens if the a new feature is added and the field has a particular
> meaning? How are you going to deal with old userspace implementations that
> use a value here which now is not allowed or it affects the guest?

With this v3 series, unless KVM is changed for the new field,
a new feature will be treated as lower safe (that's the default).
If the field won't fit any of those cases, FCT_IGNORE needs to be
used for the field, and the ID register specific validation function,
which will be registered in id_reg_info, needs to validate the field.

Old userspace implementation shouldn't be affected because the default
values (the values right after the first KVM_ARM_VCPU_INIT) for
ID registers won't be changed by this series (patch-9 changes
AA64DFR0.PMUVER/DFR0.PERFMON but it is due to a bug fix), and the
default value, which is basically same as @limit (or indicates
less or smaller level of features than @limit for features that
can be configured by KVM_ARM_VCPU_INIT, etc), is always allowed
by arm64_check_feature_one().

Having said that, arm64_check_feature_one() will be gone from the next
version, and the similar checking will be done by a new function in
arch/arm64/kernel/cpufeature.c that will use arm64_ftr_bits instead.

  https://lore.kernel.org/all/CAAeT=FxwzRF0YZmmoEmq3xRHnhun-BCx_FeEQrOVLgzwseSy4w@mail.gmail.com/

Unless KVM is changed for the new field, it will be validated based
on arm64_ftr_bits for the field.  If KVM needs to handle the field
differently, then we will have the new function ignore the field,
and will have the ID register specific validation function handle
the field.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
