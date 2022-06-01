Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652EAC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jun 2022 06:16:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDA224B41F;
	Wed,  1 Jun 2022 02:16:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aU2S9MZqiZiS; Wed,  1 Jun 2022 02:16:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 775964B413;
	Wed,  1 Jun 2022 02:16:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 227C24B410
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jun 2022 02:16:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ecd1W4djNCtH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jun 2022 02:16:41 -0400 (EDT)
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com
 [209.85.160.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A13824B408
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jun 2022 02:16:41 -0400 (EDT)
Received: by mail-oa1-f43.google.com with SMTP id
 586e51a60fabf-f2e0a41009so1424172fac.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2022 23:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=XQa+I47QKtVC2t95K19zDLcE2+R8SF0+XxRRkfkGlW0=;
 b=sc7cOnqpupy6XzI3Ysi9jsQVva3nLesW7cJqEc4n+FHGn9823/WQDEs7wJJNKvTfZq
 wjvGcdKxx72VxAsUCmDgA32niB+pWdq8Uu6w+G4laere2CrNZVwHrOEFSgiKmNyBV+rR
 sOd1WbpOSK0fQh8sIG5cOIclRR7ocACYt/7tOoshnrYHFX7imOQzK8QkcMYANnTsNnmI
 tIPQRkVtv2mWxgdEJVWmOcoHsAigPqiY9ynphJJt8eYVfVrgnAik1UYSrMJkoXztMX6y
 AjBSL0vGpocczhb9CRUtZOgMfHvKhTiHhZ7Af2dHeCuO/AACz9vzyJjfHaTkrfsm9KHY
 Qvag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=XQa+I47QKtVC2t95K19zDLcE2+R8SF0+XxRRkfkGlW0=;
 b=8PR/vgMQJeb2O7PwJjTFgUjWvluHd+pw/UaNhxcH482Of83qKdanxU2IGU1adf7Clu
 rnIMxmfZq+tLlAXNzPbX74w8Wim2EtgLkbvKU31thaPYRE0vuPTRUT50kKpwG+3r1Ldx
 tJLMqJ2TNuLGCta4IhCfPysgLlj+/PIA7eQZLDIA8/J9DC/IjeUvGY5REOGQkiXYJ8OS
 donHVK7/p8pTHA8dA32bP9dGKD9hJY8Cn3JNmqmk8fn2mM83h6mNIgv7fMWXzp4GMfq4
 DIT+m5qLuuY1k8n/Vn7Ma6fPD1zJ4kV1+JFxH7WL5gymKMNbnlH6iiWV/xXNq8698RX1
 kiUQ==
X-Gm-Message-State: AOAM5313msBVyfcQlpzRnFERj59zh5hkdzo1CGvzsx6KOUWpB5ZQYjy3
 v4kiMD2MfwYgvFceVUb1/E8u3IYzcY3kEDzp1VhqFA==
X-Google-Smtp-Source: ABdhPJwDCSFT0xcho5IN+WsjKm40fHibRehTnYPPoMiBbBRL/6vg5o7no/GjVMEHaPx4YsTuPXgDqZiej8j9NaCwK6A=
X-Received: by 2002:a05:6870:304b:b0:f2:d164:5c85 with SMTP id
 u11-20020a056870304b00b000f2d1645c85mr15509285oau.107.1654064200350; Tue, 31
 May 2022 23:16:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
 <20220419065544.3616948-2-reijiw@google.com>
 <YnIesawWNhBwZydM@google.com>
In-Reply-To: <YnIesawWNhBwZydM@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 31 May 2022 23:16:24 -0700
Message-ID: <CAAeT=FwesxjpfxTo4J8nYf3o5zcO_PivV_fak5V0tLrZ5+pknw@mail.gmail.com>
Subject: Re: [PATCH v7 01/38] KVM: arm64: Introduce a validation function for
 an ID register
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Peng Liang <liangpeng10@huawei.com>,
 Will Deacon <will@kernel.org>, h@google.com,
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

Hi Oliver,

On Tue, May 3, 2022 at 11:35 PM Oliver Upton <oupton@google.com> wrote:
>
> On Mon, Apr 18, 2022 at 11:55:07PM -0700, Reiji Watanabe wrote:
> > Introduce arm64_check_features(), which does a basic validity checking
> > of an ID register value against the register's limit value, which is
> > generally the host's sanitized value.
> >
> > This function will be used by the following patches to check if an ID
> > register value that userspace tries to set for a guest can be supported
> > on the host.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/cpufeature.h |  1 +
> >  arch/arm64/kernel/cpufeature.c      | 52 +++++++++++++++++++++++++++++
> >  2 files changed, 53 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> > index c62e7e5e2f0c..7a009d4e18a6 100644
> > --- a/arch/arm64/include/asm/cpufeature.h
> > +++ b/arch/arm64/include/asm/cpufeature.h
> > @@ -634,6 +634,7 @@ void check_local_cpu_capabilities(void);
> >
> >  u64 read_sanitised_ftr_reg(u32 id);
> >  u64 __read_sysreg_by_encoding(u32 sys_id);
> > +int arm64_check_features(const struct arm64_ftr_bits *ftrp, u64 val, u64 limit);
> >
> >  static inline bool cpu_supports_mixed_endian_el0(void)
> >  {
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > index d72c4b4d389c..dbbc69745f22 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -3239,3 +3239,55 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
> >               return sprintf(buf, "Vulnerable\n");
> >       }
> >  }
> > +
> > +/**
> > + * arm64_check_features() - Check if a feature register value constitutes
> > + * a subset of features indicated by @limit.
> > + *
> > + * @ftrp: Pointer to an array of arm64_ftr_bits. It must be terminated by
> > + * an item whose width field is zero.
> > + * @val: The feature register value to check
> > + * @limit: The limit value of the feature register
> > + *
> > + * This function will check if each feature field of @val is the "safe" value
> > + * against @limit based on @ftrp[], each of which specifies the target field
> > + * (shift, width), whether or not the field is for a signed value (sign),
> > + * how the field is determined to be "safe" (type), and the safe value
> > + * (safe_val) when type == FTR_EXACT (safe_val won't be used by this
> > + * function when type != FTR_EXACT). Any other fields in arm64_ftr_bits
> > + * won't be used by this function. If a field value in @val is the same
> > + * as the one in @limit, it is always considered the safe value regardless
> > + * of the type. For register fields that are not in @ftrp[], only the value
> > + * in @limit is considered the safe value.
> > + *
> > + * Return: 0 if all the fields are safe. Otherwise, return negative errno.
> > + */
> > +int arm64_check_features(const struct arm64_ftr_bits *ftrp, u64 val, u64 limit)
> > +{
> > +     u64 mask = 0;
> > +
> > +     for (; ftrp->width; ftrp++) {
> > +             s64 f_val, f_lim, safe_val;
> > +
> > +             f_val = arm64_ftr_value(ftrp, val);
> > +             f_lim = arm64_ftr_value(ftrp, limit);
> > +             mask |= arm64_ftr_mask(ftrp);
> > +
> > +             if (f_val == f_lim)
> > +                     safe_val = f_val;
> > +             else
> > +                     safe_val = arm64_ftr_safe_value(ftrp, f_val, f_lim);
> > +
> > +             if (safe_val != f_val)
> > +                     return -E2BIG;
> > +     }
> > +
> > +     /*
> > +      * For fields that are not indicated in ftrp, values in limit are the
> > +      * safe values.
> > +      */
> > +     if ((val & ~mask) != (limit & ~mask))
> > +             return -E2BIG;
>
> This bit is interesting. Apologies if I paged out relevant context. What
> features are we trying to limit that exist outside of an arm64_ftr_bits
> definition? I'll follow the series and see if I figure out later :-P
>
> Generally speaking, though, it seems to me that we'd prefer to have an
> arm64_ftr_bits struct plumbed up for whatever hits this case.

I'm sorry that I completely overlooked this until now...

This code is not currently used by this series since KVM will fill
any statically undefined fields as a lower safe unsigned field.

But, considering that arm64_ftr_bits that are defined in cpufeature.c
doesn't have all bits definitions, I wanted to have the function
handle such arm64_ftr_bits as well (the code is basically to make
sure that undefined fields are 0).

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
