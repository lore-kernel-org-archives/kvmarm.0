Return-Path: <SRS0=PgOR=PF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C1BC433FE
	for <kvmarm@archiver.kernel.org>; Sun, 17 Oct 2021 04:44:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BD51E610E8
	for <kvmarm@archiver.kernel.org>; Sun, 17 Oct 2021 04:44:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BD51E610E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 351144B119;
	Sun, 17 Oct 2021 00:44:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xe+g7jM-Y7Zk; Sun, 17 Oct 2021 00:44:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F37A84B0F7;
	Sun, 17 Oct 2021 00:44:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB3DD4B0E1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Oct 2021 00:44:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CL7295yQjm1u for <kvmarm@lists.cs.columbia.edu>;
 Sun, 17 Oct 2021 00:44:09 -0400 (EDT)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A00C24B0DF
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Oct 2021 00:44:09 -0400 (EDT)
Received: by mail-pl1-f182.google.com with SMTP id 21so8994828plo.13
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Oct 2021 21:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Y8hxkkjC59Lk20UqzTDUhRF4a3QLCPerXoGaMuMIfbA=;
 b=T+yExjczlNVce32AnKsOADeGvIvc9/hmv9tJkGiZ38+EWDlFw7dH0wi3W76abD1qyo
 0kK2PgXS2Xxrlf4mC8oqUQNcm5dP5/Iq115Yus8QGdF+vhFKhVAFMffRLbv25M4OkojR
 QQfbYmm86orFpJ5wuDeeOqL9fhlXeXzK89Ijh2BW2FmI1a7X4LE1Wd8/XVSlQkDtXrhB
 /BWkmbswgoRE7nvPdb4MT129rJo0JtNFdJFEX40I2JxfBD5lPbWusu3UbbZGTRuyl1sD
 Mcl+oaeIjpHFsSe75mZFb12Gh8kP6yV+xCQxQVU3+LwC655JurIhP8Ygg8T+qGAkT9Kd
 akIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Y8hxkkjC59Lk20UqzTDUhRF4a3QLCPerXoGaMuMIfbA=;
 b=dqFJk/KYO8o5bkGTd0H+ZZaRMhNa3kz+H0qRppWs5051AnU2WdiAhLnJwX2wffcLAr
 K053v5VIaFAz9D9Pw2iGTUFESqXqm8LhObcZ3KqjYpMGlmRst/A53jpsxP0YHFJQAY1r
 DgHBWm6eZ/kVKElx4Swhn7ZY8b4xszCAIc6TwU29R1vBhMuhWBWVHW9494pa+0YmH08j
 KIpPX4wgvRpPMbmzsXxKDayD2GAWo3M+wCIdArXcwKx99AhX3n+qtOvbwyi/mSTEvLtp
 tY/6P5id1VIedn89jIFMeZiiRCY2vNDQ6kkrMFuDc1zLGqJzAtWf99GfWwzvWt6I5bBV
 ucSA==
X-Gm-Message-State: AOAM533Z8R5PmtUdADyNs4NcIsia9X+tIEua6XArpJLKenCnWaiq76+b
 hkWHXcwnBytipDzODXootK+g4H1wsQNZG7rYf7hYzA==
X-Google-Smtp-Source: ABdhPJyKMiTmY39aaGR53moXzMQSfsCG990gr+68UwPJI39g1bF/oHnDrzgDbR9D57bdYzAnc0v/bWSYRHrmATRzOTM=
X-Received: by 2002:a17:90b:38c3:: with SMTP id
 nn3mr25207656pjb.110.1634445848472; 
 Sat, 16 Oct 2021 21:44:08 -0700 (PDT)
MIME-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
 <20211012043535.500493-5-reijiw@google.com>
 <20211015134741.b7jahdmypu6tqkt2@gator>
In-Reply-To: <20211015134741.b7jahdmypu6tqkt2@gator>
From: Reiji Watanabe <reijiw@google.com>
Date: Sat, 16 Oct 2021 21:43:52 -0700
Message-ID: <CAAeT=Fw-ECM0n1C1HvtiiNEm-xhcK2-R0fWbA7hd38BJge+2RQ@mail.gmail.com>
Subject: Re: [RFC PATCH 04/25] KVM: arm64: Introduce struct id_reg_info
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -263,6 +263,76 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
> >               return read_zero(vcpu, p);
> >  }
> >
> > +struct id_reg_info {
> > +     u32     sys_reg;        /* Register ID */
> > +     u64     sys_val;        /* Sanitized system value */
> > +
> > +     /*
> > +      * Limit value of the register for a vcpu. The value is sys_val
> > +      * with bits cleared for unsupported features for the guest.
> > +      */
> > +     u64     vcpu_limit_val;
>
> Maybe I'll see a need for both later, but at the moment I'd think we only
> need sys_val with the bits cleared for disabled features.

Uh, yes, sys_val is used in patch-15 and I should have introduced
the field in the patch.  I will fix it in v2.


> > -static int __set_id_reg(const struct kvm_vcpu *vcpu,
> > +static int __set_id_reg(struct kvm_vcpu *vcpu,
> >                       const struct sys_reg_desc *rd, void __user *uaddr,
> >                       bool raz)
> >  {
> >       const u64 id = sys_reg_to_index(rd);
> > +     u32 encoding = reg_to_encoding(rd);
> >       int err;
> >       u64 val;
> >
> > @@ -1252,10 +1327,18 @@ static int __set_id_reg(const struct kvm_vcpu *vcpu,
> >       if (err)
> >               return err;
> >
> > -     /* This is what we mean by invariant: you can't change it. */
> > -     if (val != read_id_reg(vcpu, rd, raz))
> > +     /* Don't allow to change the reg unless the reg has id_reg_info */
> > +     if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
> >               return -EINVAL;
> >
> > +     if (raz)
> > +             return (val == 0) ? 0 : -EINVAL;
>
> This is already covered by the val != read_id_reg(vcpu, rd, raz) check.

Yes, it can simply return 0 for raz case in this patch.
I will fix this in v2.


> > +     err = validate_id_reg(vcpu, rd, val);
> > +     if (err)
> > +             return err;
> > +
> > +     __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(encoding)) = val;
> >       return 0;
> >  }
> >
> > @@ -2818,6 +2901,23 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> >       return write_demux_regids(uindices);
> >  }
> >
> > +static void id_reg_info_init_all(void)
> > +{
> > +     int i;
> > +     struct id_reg_info *id_reg;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++) {
> > +             id_reg = (struct id_reg_info *)id_reg_info_table[i];
> > +             if (!id_reg)
> > +                     continue;
> > +
> > +             if (id_reg->init)
> > +                     id_reg->init(id_reg);
> > +             else
> > +                     id_reg_info_init(id_reg);
>
> Maybe call id_reg->init(id_reg) from within id_reg_info_init() in case we
> wanted to apply some common id register initialization at some point?

Thank you for the nice suggestion.
That sounds like a better idea. I'll look into fixing it in v2.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
