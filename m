Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98DEC11F64
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 14:05:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 39404613E6
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 14:05:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39404613E6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 844B64A1A7;
	Thu,  1 Jul 2021 10:05:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y9g8Jph56gob; Thu,  1 Jul 2021 10:05:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6150B4A4A0;
	Thu,  1 Jul 2021 10:05:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A64B4A198
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 10:05:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eAwP0hS6Mmhi for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 10:05:02 -0400 (EDT)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com
 [209.85.167.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F51B49E57
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 10:05:02 -0400 (EDT)
Received: by mail-oi1-f176.google.com with SMTP id u11so7424557oiv.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Jul 2021 07:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=B7IUnh0oWyjBb2xRncqIUXvQS59ay97jYCOfPEteAjc=;
 b=lIs2zjPlxTetwv2YHF0hWz6sbsM3W7g5WxyfvhsBCUbb6bDyxfthudpXaz9sn6UBkr
 Lvlrq5FhKeg9/3Uc5Wjqe5FoAvl2X9E7+yPn6LW8oDULu98kMUx/eba6pOvqiJ3GTIsv
 Sh7ikCMS2cTDm573VNQ8q8z3ABMq3o6/8MRwsGKL+FFpz1+ePXfqfxcCaP6/vjCgPLgn
 6eeQ1j9MQ0MTHVXMoIMhIt+N/sS760pVRr2+nchlN1YXtCuYBgv8dkSBDHgDzY7ZTYYz
 LsLoRPOkYCU7y00dNWwTmdT3lVVF4hGwtw9YcdqXZPrV95RZotSN3dMzEu2IbVhcRcJz
 qHpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=B7IUnh0oWyjBb2xRncqIUXvQS59ay97jYCOfPEteAjc=;
 b=W5xxrtx2csH23F7ijBhSuVRKx71EPfTMQp8j1S8iTgPC32pqddhsr/nvdWvSpPEQKD
 uRG9pB9Zld1HLzuVY+0xUCmvUVy6VmvpOlv4z9xkKaWvLPUm+ZZe9uf1mUT75HHKP9WN
 8yKzTbH0ztaDRfTZz3xbCjimSPOFnEOyyo/CJrxq+Giklt8n/Xrm12f7N2S3MYy8P0wA
 eF3C8Rqahon6r3uoCjO5qb7srJmPoTuoFxoFbUhBbvt8kLAJObZt0Y0EPNi5L/BkxECF
 DoDBrgNnITVsymzoeoeOMtm5PsVzS60tnwyysMP2i8nxuUFCi+bOYOa/yv3RWfI1Yb1u
 EIoQ==
X-Gm-Message-State: AOAM530XXgduGcxJsi0J3uQP8ma8GouBeXa+nr6pkUUfoaIIRk6veyHl
 Mqxp4LeRCoFhFjShd/w4oIgiA+gmISsl8cfqduBiow==
X-Google-Smtp-Source: ABdhPJxh97XTaujhPyDDSWa0CFYxsqv8rXYuxB3HmSkbRQ+/EPSoQuBQ8hjPuKO7p8D6Vm4dD7Kzh7JgjeGzDP6OVFM=
X-Received: by 2002:a05:6808:158b:: with SMTP id
 t11mr1057180oiw.8.1625148301795; 
 Thu, 01 Jul 2021 07:05:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-5-tabba@google.com>
 <20210701130917.GD9757@willie-the-truck>
In-Reply-To: <20210701130917.GD9757@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 1 Jul 2021 15:04:25 +0100
Message-ID: <CA+EHjTyi8++9r1i4oY7HjjPQMSTz5G5H5CQ_dDtsG7X5LuZr1Q@mail.gmail.com>
Subject: Re: [PATCH v2 04/13] KVM: arm64: Refactor sys_regs.h, c for nVHE reuse
To: Will Deacon <will@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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

Hi Will,

On Thu, Jul 1, 2021 at 2:09 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jun 15, 2021 at 02:39:41PM +0100, Fuad Tabba wrote:
> > Refactor sys_regs.h and sys_regs.c to make it easier to reuse
> > common code. It will be used in nVHE in a later patch.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 30 +-----------------------------
> >  arch/arm64/kvm/sys_regs.h | 35 +++++++++++++++++++++++++++++++++++
> >  2 files changed, 36 insertions(+), 29 deletions(-)
>
> [...]
>
> > diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> > index 9d0621417c2a..b8e2a4dd830f 100644
> > --- a/arch/arm64/kvm/sys_regs.h
> > +++ b/arch/arm64/kvm/sys_regs.h
> > @@ -11,6 +11,12 @@
> >  #ifndef __ARM64_KVM_SYS_REGS_LOCAL_H__
> >  #define __ARM64_KVM_SYS_REGS_LOCAL_H__
> >
> > +#include <linux/bsearch.h>
> > +
> > +#define reg_to_encoding(x)                                           \
> > +     sys_reg((u32)(x)->Op0, (u32)(x)->Op1,                           \
> > +             (u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
> > +
> >  struct sys_reg_params {
> >       u8      Op0;
> >       u8      Op1;
> > @@ -21,6 +27,14 @@ struct sys_reg_params {
> >       bool    is_write;
> >  };
> >
> > +#define esr_sys64_to_params(esr)                                               \
> > +     ((struct sys_reg_params){ .Op0 = ((esr) >> 20) & 3,                    \
> > +                               .Op1 = ((esr) >> 14) & 0x7,                  \
> > +                               .CRn = ((esr) >> 10) & 0xf,                  \
> > +                               .CRm = ((esr) >> 1) & 0xf,                   \
> > +                               .Op2 = ((esr) >> 17) & 0x7,                  \
> > +                               .is_write = !((esr)&1) })
>
> Formatting has gone funny here (need spaces around the '&' in that last
> entry).

Will fix this.

> > +
> >  struct sys_reg_desc {
> >       /* Sysreg string for debug */
> >       const char *name;
> > @@ -152,6 +166,24 @@ static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
> >       return i1->Op2 - i2->Op2;
> >  }
> >
> > +static inline int match_sys_reg(const void *key, const void *elt)
> > +{
> > +     const unsigned long pval = (unsigned long)key;
> > +     const struct sys_reg_desc *r = elt;
> > +
> > +     return pval - reg_to_encoding(r);
> > +}
> > +
> > +static inline const struct sys_reg_desc *
> > +find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
> > +      unsigned int num)
> > +{
> > +     unsigned long pval = reg_to_encoding(params);
> > +
> > +     return __inline_bsearch((void *)pval, table, num, sizeof(table[0]),
> > +                             match_sys_reg);
>
> You don't mention why you change bsearch() to __inline_bsearch().

It's because of linking with nvhe. Rather than copy the bsearch code
for nvhe, I thought I'd use the inline version of bsearch. I'll update
the comment to explain that.

Thanks,
/fuad

> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
