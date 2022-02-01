Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EDE1C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  1 Feb 2022 14:14:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE02749F4E;
	Tue,  1 Feb 2022 09:14:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Kse+v8kUUrhs; Tue,  1 Feb 2022 09:14:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A574449F10;
	Tue,  1 Feb 2022 09:14:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EC2149EFB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 09:14:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9qloXIV-Ce19 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Feb 2022 09:14:29 -0500 (EST)
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com
 [209.85.167.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3226349EC2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 09:14:29 -0500 (EST)
Received: by mail-oi1-f179.google.com with SMTP id x193so33629203oix.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Feb 2022 06:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=1hzC5kA94MkC0GLnHZxQLOF3z9T2okGq6QSaPNCp6Bs=;
 b=L2rrAtc5Bxp1kiX/SmSs9h7mN4kqGARLQxGoLX7jPAkXCmRSfJBQH5H0sBqdQlsgE5
 Og1UXoJb/lM+neYYXkS628jfo8p7TU1oQGNmBzw9MOB1AGiMuTh2Rl7Dmt0eE/WE7fqK
 KHQ1cX/6w79LsiyETQ8xapa+MEdHkJGtRxJISJc53WMvb5ycMhRPfDG2+gQ+Kvny+dP2
 tnal53P+Se0y2F+vdwm3H3S7k3T37KHiD0w4nJfzGZnf2ctfncFrYWFHU17whfIU4FX0
 y2U+Kcs+cRj/cZrZ2PeI35Wamsky4mnF61gWO/zgnjLZ1QggLCtFQ47yZOwBSlxJiEKM
 DKDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=1hzC5kA94MkC0GLnHZxQLOF3z9T2okGq6QSaPNCp6Bs=;
 b=lJzXx2xm+RYfYT5+KVoJQVRTLtIOrCd9mbxXscEPW8WvXXQtsFZ0srUy+5szpBrMSh
 gxrRe0S2weMyZKCT8hkS+WSbomHfaYztfjkuPomOZ6iQNIK2HxtoCkVMpMgdOBaA9Rrz
 CrSfQf4ycCNeyQ11IZeg4CaD8rMrVt7Gkxm/g74PklUMY0V7YfYiFo/yCpKJDOjSrLNI
 d9lyXRuYTewXH3KsYCUdtv0v8/PgtPnn9BSg/NR4DQVini1Z3e5NdN+Ju9WV/7L4uckj
 6Dg/XjQ0ho3BuzWKCDWBDwJ3IfFcUXz1aSyC0C9YeKzDr4nU3bOv0Fv2jSKYV3J1JSEO
 ddjg==
X-Gm-Message-State: AOAM533/l3i2aZQwLR8sUzsfHx1sO4e5EOsOnHANXlq8Jd+IQdYf1WcJ
 G6uMyQaOLlBUkTN/ZySrknJxIfy4qDOzo52x4mJSYg==
X-Google-Smtp-Source: ABdhPJyc+gLrzhK5McV1s3POSFDxJ0vZgQau3r0WA3lSzrJGO3Z4Wz+mvnT9IX4AKiE4COwrk9DKb/JyvxPHTu676A0=
X-Received: by 2002:a05:6808:2394:: with SMTP id
 bp20mr1251698oib.171.1643724868554; 
 Tue, 01 Feb 2022 06:14:28 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-4-reijiw@google.com>
 <CA+EHjTx65scqNVvHci6fge7C5qQ=fiqqHKGwOvOKySQwsCy8Jg@mail.gmail.com>
 <CAAeT=Fzi2JSuVGijM0x7_w8osRWMFUupz3r10NduO6r5hN+HKw@mail.gmail.com>
In-Reply-To: <CAAeT=Fzi2JSuVGijM0x7_w8osRWMFUupz3r10NduO6r5hN+HKw@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 1 Feb 2022 14:13:52 +0000
Message-ID: <CA+EHjTws=ie4XoSBdR3WO4q+A6Q3H1zZ9fq+s90GNbswx+aEaQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 03/26] KVM: arm64: Introduce struct id_reg_info
To: Reiji Watanabe <reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Reiji,

...


> > > @@ -2862,11 +3077,12 @@ void set_default_id_regs(struct kvm *kvm)
> > >         u32 id;
> > >         const struct sys_reg_desc *rd;
> > >         u64 val;
> > > +       struct id_reg_info *idr;
> > >
> > >         for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> > >                 rd = &sys_reg_descs[i];
> > >                 if (rd->access != access_id_reg)
> > > -                       /* Not ID register, or hidden/reserved ID register */
> > > +                       /* Not ID register or hidden/reserved ID register */
> > >                         continue;
> > >
> > >                 id = reg_to_encoding(rd);
> > > @@ -2874,7 +3090,8 @@ void set_default_id_regs(struct kvm *kvm)
> > >                         /* Shouldn't happen */
> > >                         continue;
> > >
> > > -               val = read_sanitised_ftr_reg(id);
> > > -               kvm->arch.id_regs[IDREG_IDX(id)] = val;
> > > +               idr = GET_ID_REG_INFO(id);
> > > +               val = idr ? idr->vcpu_limit_val : read_sanitised_ftr_reg(id);
> > > +               (void)write_kvm_id_reg(kvm, id, val);
> >
> > Rather than ignoring the return value of write_kvm_id_reg(), wouldn't
> > it be better if set_default_id_regs were to propagate it back to
> > kvm_arch_init_vm in case there's a problem?
>
> Since write_kvm_id_reg() should never return an error for this
> case, returning an error to kvm_arch_init_vm() adds a practically
> unnecessary error handling, which I would like to avoid.
> So, how about putting WARN_ON_ONCE on its return value ?

I think this makes sense in this case.

Thanks,
/fuad

> Thanks,
> Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
