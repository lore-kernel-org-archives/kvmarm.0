Return-Path: <SRS0=KNUW=MM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B68C636C8
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 14:03:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D7746113C
	for <kvmarm@archiver.kernel.org>; Tue, 20 Jul 2021 14:03:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D7746113C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A4034B0DB;
	Tue, 20 Jul 2021 10:03:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IpI6PY2MxYDd; Tue, 20 Jul 2021 10:03:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E20464A534;
	Tue, 20 Jul 2021 10:03:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE9814A126
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 10:03:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2Eq6TgYvRaR4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Jul 2021 10:03:49 -0400 (EDT)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com
 [209.85.167.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC0594A023
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 10:03:49 -0400 (EDT)
Received: by mail-oi1-f176.google.com with SMTP id a132so13771262oib.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Jul 2021 07:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=3pAi2IUwv7EdpJAk0boQH8aQmdEiZAI8a1a0cHarpI4=;
 b=tOwo8JvOI333zTSShr7G1VQA9f36JvMMNfNy1R4+AFu6wyd+zUTDRc3727tpBO3PTO
 CollJtLxZ1ie8UmiMdFJ2EwmFnHL7LVTZ1MwOUnb0/9VJ40wFwvdA4u4VoYw3xKLcRq+
 j3BiNhWmklGXaozYmLVL87ARe8dSQ+G0O6BuuPS+1jkZHknx87nIzCb0U5wh5fb1Pj9k
 z6Rj9DPISr0X2Wc9vqLTM4EmCRb4uz0xKXGaqCwwLg5xN811WE56OjyoHuKePwn7UC+F
 9sCfaWQsLxa5QsFKDhwvoDHoKWtadr3X89+6EWT/j+Lj1Dmv0luQacJyQiqYXxY2Nf23
 FpJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=3pAi2IUwv7EdpJAk0boQH8aQmdEiZAI8a1a0cHarpI4=;
 b=JVKvatVVtStVE1czcmVGKGTyZi4UX3Ffd7vYLVZICp8u5t+LyV49pF95z75ovGvfkI
 Wr+tT4zXDwMk5oYlLD/gDCtR/B1Baedqf63Bv9t32ibOQi0hTBl4IvqCrvWErZGK+ClK
 e45Nn5t83psa9g9Kx4iS9RpY+XHc++8EBq0ZImDLVl0Uruo6v3GmwWEYSiwf1p1Lb5JX
 bq7nqoeV2UJo8JIIVpexLrAdknnfIwV5rMtGXHtHrUPMxeDBJJbfZND4Sa22Ibs7+8sA
 t225LbpCFe/AHzDrui1dcBat5DDRYz2hvP/3PuuvsKsuP7x1VE3YhfBYWivzfzX4SH1b
 g6kw==
X-Gm-Message-State: AOAM530peRaEjsrm8hQ0GArriCmt9eYEj9A6XnZA+bT2S5+q6UfLIqvq
 wyK5Jbuc2YvoqRmBxb7eMwWVxDWBpWQ0TNqcdWKqJg==
X-Google-Smtp-Source: ABdhPJy67+4yt2CQ9gqDe2NPUt44b6Ljx8YHSPr8w0AM4pzGQ7GWeDm6CdAiYnsIJo8vfqE2nz3OKjDc0mNnw3K+NQk=
X-Received: by 2002:a05:6808:5a:: with SMTP id
 v26mr12146167oic.90.1626789829100; 
 Tue, 20 Jul 2021 07:03:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-6-tabba@google.com>
 <20210720133810.7q4k2yde57okgvmm@gator>
In-Reply-To: <20210720133810.7q4k2yde57okgvmm@gator>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 20 Jul 2021 15:03:12 +0100
Message-ID: <CA+EHjTzW=GnG_zE=eregR7+WTLD-ASzajrMkinUMX=+Lfq3RcA@mail.gmail.com>
Subject: Re: [PATCH v3 05/15] KVM: arm64: Refactor sys_regs.h, c for nVHE reuse
To: Andrew Jones <drjones@redhat.com>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi,

On Tue, Jul 20, 2021 at 2:38 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Jul 19, 2021 at 05:03:36PM +0100, Fuad Tabba wrote:
> > Refactor sys_regs.h and sys_regs.c to make it easier to reuse
> > common code. It will be used in nVHE in a later patch.
> >
> > Note that the refactored code uses __inline_bsearch for find_reg
> > instead of bsearch to avoid copying the bsearch code for nVHE.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/sysreg.h |  3 +++
> >  arch/arm64/kvm/sys_regs.c       | 30 +-----------------------------
> >  arch/arm64/kvm/sys_regs.h       | 31 +++++++++++++++++++++++++++++++
> >  3 files changed, 35 insertions(+), 29 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index 7b9c3acba684..326f49e7bd42 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -1153,6 +1153,9 @@
> >  #define ICH_VTR_A3V_SHIFT    21
> >  #define ICH_VTR_A3V_MASK     (1 << ICH_VTR_A3V_SHIFT)
> >
> > +/* Extract the feature specified from the feature id register. */
> > +#define FEATURE(x)   (GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
>
> I think the comment would be better as
>
>  Create a mask for the feature bits of the specified feature.

I agree. I'll use this instead.

> And, I think a more specific name than FEATURE would be better. Maybe
> FEATURE_MASK or even ARM64_FEATURE_MASK ?

I think so too. ARM64_FEATURE_MASK is more descriptive than just FEATURE.

Thanks,
/fuad

> > +
> >  #ifdef __ASSEMBLY__
> >
> >       .irp    num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 80a6e41cadad..1a939c464858 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -44,10 +44,6 @@
> >   * 64bit interface.
> >   */
> >
> > -#define reg_to_encoding(x)                                           \
> > -     sys_reg((u32)(x)->Op0, (u32)(x)->Op1,                           \
> > -             (u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
> > -
> >  static bool read_from_write_only(struct kvm_vcpu *vcpu,
> >                                struct sys_reg_params *params,
> >                                const struct sys_reg_desc *r)
> > @@ -1026,8 +1022,6 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
> >       return true;
> >  }
> >
> > -#define FEATURE(x)   (GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
> > -
> >  /* Read a sanitised cpufeature ID register by sys_reg_desc */
> >  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >               struct sys_reg_desc const *r, bool raz)
> > @@ -2106,23 +2100,6 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
> >       return 0;
> >  }
> >
> > -static int match_sys_reg(const void *key, const void *elt)
> > -{
> > -     const unsigned long pval = (unsigned long)key;
> > -     const struct sys_reg_desc *r = elt;
> > -
> > -     return pval - reg_to_encoding(r);
> > -}
> > -
> > -static const struct sys_reg_desc *find_reg(const struct sys_reg_params *params,
> > -                                      const struct sys_reg_desc table[],
> > -                                      unsigned int num)
> > -{
> > -     unsigned long pval = reg_to_encoding(params);
> > -
> > -     return bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
> > -}
> > -
> >  int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu)
> >  {
> >       kvm_inject_undefined(vcpu);
> > @@ -2365,13 +2342,8 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
> >
> >       trace_kvm_handle_sys_reg(esr);
> >
> > -     params.Op0 = (esr >> 20) & 3;
> > -     params.Op1 = (esr >> 14) & 0x7;
> > -     params.CRn = (esr >> 10) & 0xf;
> > -     params.CRm = (esr >> 1) & 0xf;
> > -     params.Op2 = (esr >> 17) & 0x7;
> > +     params = esr_sys64_to_params(esr);
> >       params.regval = vcpu_get_reg(vcpu, Rt);
> > -     params.is_write = !(esr & 1);
> >
> >       ret = emulate_sys_reg(vcpu, &params);
> >
> > diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> > index 9d0621417c2a..cc0cc95a0280 100644
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
> > +                               .is_write = !((esr) & 1) })
> > +
> >  struct sys_reg_desc {
> >       /* Sysreg string for debug */
> >       const char *name;
> > @@ -152,6 +166,23 @@ static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
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
> > +     return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
> > +}
> > +
> >  const struct sys_reg_desc *find_reg_by_id(u64 id,
> >                                         struct sys_reg_params *params,
> >                                         const struct sys_reg_desc table[],
> > --
> > 2.32.0.402.g57bb445576-goog
> >
>
> Otherwise
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
