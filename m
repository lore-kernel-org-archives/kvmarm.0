Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF12CC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 29 Jan 2022 05:52:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 371E4411BA;
	Sat, 29 Jan 2022 00:52:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5LbLwuZNOy7I; Sat, 29 Jan 2022 00:52:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F145849DED;
	Sat, 29 Jan 2022 00:52:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D123C4126B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 29 Jan 2022 00:52:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2XWAoIxEl28c for <kvmarm@lists.cs.columbia.edu>;
 Sat, 29 Jan 2022 00:52:38 -0500 (EST)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8EB6D411BA
 for <kvmarm@lists.cs.columbia.edu>; Sat, 29 Jan 2022 00:52:38 -0500 (EST)
Received: by mail-pg1-f181.google.com with SMTP id j10so7144664pgc.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jan 2022 21:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=l6hkYLQY0UCA5be7Mdwd+JiBebqPxJBCfUkmLUP1xhY=;
 b=L6UsPboR4n47sCBNGg/CpG3bNJHiQ1+mWJ3JNZZp3A86D9DwCFD2eJbDGtnJHHAVYY
 TGWz7PTtCxd23ANfsshxJYtcN99/rBMjPgNET8VcAimKP6hOPdMU6bsjx0WyyeRF46+2
 ph0rvOwNxbTE6BE/umr7YKENHEmlsBuq96/DurhHt3D1LS0OMET7/k3LVsUil4Yj5kPT
 aHm/OJI+M+MluufgBAg3SXlJKr0rgeSH/7PfqbTFu9rtI2IUNq7QgUorm6a1yd9Bl+m1
 Y+YI7NIvwdfAozaXGCLquTLLZbxvE84WcP4O1ygSgndmd1sUxcfvUowbuvZ9PQcTvdzg
 Wh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=l6hkYLQY0UCA5be7Mdwd+JiBebqPxJBCfUkmLUP1xhY=;
 b=dx8McfHz34TUnZvxeZkkFDNINX/03nAUP687AlSH0Uzfhliql2zClx3c8MSZsMaOG3
 l3YhuW3HaA7RXAfGnpblBxhFJxPOmcVSDkiBQX/coRZwZ91JSpYniPEMquuvR8QYbwMP
 ebx1wy0iSgNlU3518kppJdKZF+9dcRqOi+sIJBTTIEuDxXbG36121bJ32izr4Oj20+Mk
 gBjZGi/jde2Tsad6LgxEpdUIB0FZsdKC0Levzp8fJNFO1jAhX6HNb9MRLw70iD76kT8e
 FXXcB60rIkv3n9ox7zetQqwt8wUmp7A0akTI1B0vhfJZsFG0EhW5zZ7AJSgOgX03Cw9z
 DbSA==
X-Gm-Message-State: AOAM533kXItfkdfPMWqhtGMwtJrsxG7xgXr1vAJqGkt/pDIeQvgo7oFg
 S8UdasHBCe5asijedKTE+n5Ex63nq3/EzvYBimKDhg==
X-Google-Smtp-Source: ABdhPJxhT2S1yun+rYZwdqcoyg3XJchS0/6aFbHnaj6sCBRUYYYt5fH3tZD/5jSKbjVwrJZXzYV51QvKN5olPkqQ1wI=
X-Received: by 2002:a05:6a00:98e:: with SMTP id
 u14mr11484137pfg.12.1643435557410; 
 Fri, 28 Jan 2022 21:52:37 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-3-reijiw@google.com>
 <YfDaiUbSkpi9/5YY@google.com>
 <CAAeT=FzNSvzz-Ok0Ka95=kkdDGsAMmzf9xiRfD5gYCdvmEfifg@mail.gmail.com>
 <CAOHnOrwBoQncTPngxqWgD_mEDWT6AwcmB_QC=j-eUPY2fwHa2Q@mail.gmail.com>
In-Reply-To: <CAOHnOrwBoQncTPngxqWgD_mEDWT6AwcmB_QC=j-eUPY2fwHa2Q@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 28 Jan 2022 21:52:21 -0800
Message-ID: <CAAeT=FyqPX_XQ+LDuRBZhApeiWD4s81bTMe=qiKDOZkBWm5ARg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 02/26] KVM: arm64: Save ID registers' sanitized
 value per guest
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Ricardo,

> > > > +
> > > > +/*
> > > > + * Set the guest's ID registers that are defined in sys_reg_descs[]
> > > > + * with ID_SANITISED() to the host's sanitized value.
> > > > + */
> > > > +void set_default_id_regs(struct kvm *kvm)
> > > > +{
> > > > +     int i;
> > > > +     u32 id;
> > > > +     const struct sys_reg_desc *rd;
> > > > +     u64 val;
> > > > +
> > > > +     for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> > > > +             rd = &sys_reg_descs[i];
> > > > +             if (rd->access != access_id_reg)
> > > > +                     /* Not ID register, or hidden/reserved ID register */
> > > > +                     continue;
> > > > +
> > > > +             id = reg_to_encoding(rd);
> > > > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > > > +                     /* Shouldn't happen */
> > > > +                     continue;
> > > > +
> > > > +             val = read_sanitised_ftr_reg(id);
> > >
> > > I'm a bit confused. Shouldn't the default+sanitized values already use
> > > arm64_ftr_bits_kvm (instead of arm64_ftr_regs)?
> >
> > I'm not sure if I understand your question.
> > arm64_ftr_bits_kvm is used for feature support checkings when
> > userspace tries to modify a value of ID registers.
> > With this patch, KVM just saves the sanitized values in the kvm's
> > buffer, but userspace is still not allowed to modify values of ID
> > registers yet.
> > I hope it answers your question.
>
> Based on the previous commit I was assuming that some registers, like
> id_aa64dfr0,
> would default to the overwritten values as the sanitized values. More
> specifically: if
> userspace doesn't modify any ID reg, shouldn't the defaults have the
> KVM overwritten
> values (arm64_ftr_bits_kvm)?

arm64_ftr_bits_kvm doesn't have arm64_ftr_reg but arm64_ftr_bits,
and arm64_ftr_bits_kvm doesn't have the sanitized values.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
