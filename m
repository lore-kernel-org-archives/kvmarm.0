Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29EBAC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 28 Jan 2022 05:43:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7FD049F0E;
	Fri, 28 Jan 2022 00:43:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S9Ebkr+XWDTg; Fri, 28 Jan 2022 00:43:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62B5E49EFD;
	Fri, 28 Jan 2022 00:43:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C314849EF4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jan 2022 00:43:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GPSo2WzjPLEL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jan 2022 00:43:38 -0500 (EST)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 571BC49E17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jan 2022 00:43:38 -0500 (EST)
Received: by mail-pl1-f170.google.com with SMTP id i1so4887529pla.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 21:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=jdA8rdbgjgagcqv9xj/rVbPr7arzqXD97cl/2fIMdB8=;
 b=erv5Hgh9aPL15tqkMtnrjHVHwYx6LsZrowtgtX4GchvrzU9QCOe0moTftisr8Ze88t
 KJcJtB1McQbY3AbUaxFwYDbOc1vnQZyX9TSO7g1JfsyPhXSTXuRNaGfvm/K7yqVN64p1
 MeO4i/gJWF/UbWFnbNywHySk+KGZE8IPMwzBKy5+uYeNP8R9BLn25srcvzIZYl41gaQh
 YdfVa3KbpFP2PXjGROWmlCNU8ebMSAJLhCU0Eq3cnoHoD9usC6d06l3VPfqGDq5FnugO
 xqarXVz6QgQzUSVH4Nz5v8+s/GLjD8kzaq7BeQpOa2NNEilI88OAOzKruCbtpTdGpCQd
 2OZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=jdA8rdbgjgagcqv9xj/rVbPr7arzqXD97cl/2fIMdB8=;
 b=xFlnQugmq86pWtxsxCPRuQenuxBQRINTJwWa67Izsl8IFnU/nkCQ7sdNp8WUlHKaAe
 iWe/HTMXT2cqY+95OVvqAnFcaduEtmxhTCLgf/GznGLHtnMQMPgYdySBMABzlX631f+f
 067IawaHnL0lGoj0HNVVrztcVe4Qv0lW45q5r8L/bzqBfeeQQDCI/AUYP8Lh2h5Dt+yV
 Fph7Xm424DlIY8rDMtDEtaKC2f2utReBzBHw1+c7lqwGcnFpU5rx0QzB7NjXM6xPhljx
 zGqUk+kBM/dUrUCTzphV6VCsjFVZmvyUMVbVYii8YyZNgPgw9UPsGu0/NCVSGsw5E3sw
 Lf2g==
X-Gm-Message-State: AOAM532ddb/CfyAAc7f57S3wWZZvPaV9zBFN2hIm5iB8rlkiSTzajxxH
 WPN1pgZif6AFCaS7M0qLZm6Q/OqMDfMmWQEDl8O9xw==
X-Google-Smtp-Source: ABdhPJzIV4lrshDHGy5fwEKZK6TGf/saaUmUPosi2mDNh8ZNRvN99uxARFZnf8hP8TgF21iU/hor5Ww4CAklD6l1ni0=
X-Received: by 2002:a17:902:bc83:: with SMTP id
 bb3mr7299988plb.172.1643348617165; 
 Thu, 27 Jan 2022 21:43:37 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-24-reijiw@google.com>
 <CA+EHjTxYqPvyUz96hoJWe43raST1X7oKhdR7PeZDuwuuD9QcYQ@mail.gmail.com>
In-Reply-To: <CA+EHjTxYqPvyUz96hoJWe43raST1X7oKhdR7PeZDuwuuD9QcYQ@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 27 Jan 2022 21:43:21 -0800
Message-ID: <CAAeT=FxKgH_a7vthT3ai_TiCu9UCj+PNJ6SarHDF+R5tcR--Dg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 23/26] KVM: arm64: Trap disabled features of
 ID_AA64MMFR1_EL1
To: Fuad Tabba <tabba@google.com>
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

Hi Fuad,

On Mon, Jan 24, 2022 at 9:38 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Reiji,
>
> The series might be missing an entry for ID_AA64MMFR0_EL1, Debug
> Communications Channel registers, ID_AA64MMFR0_FGT -> MDCR_EL2_TDCC.

I will add them in v5 series.
Thank you so much for all the review comments!

Thanks,
Reiji


>
> Cheers,
> /fuad
>
>
> On Thu, Jan 6, 2022 at 4:29 AM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Add feature_config_ctrl for LORegions, which is indicated in
> > ID_AA64MMFR1_EL1, to program configuration register to trap
> > guest's using the feature when it is not exposed to the guest.
> >
> > Change trap_loregion() to use vcpu_feature_is_available()
> > to simplify checking of the feature's availability.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 26 ++++++++++++++++++++++++--
> >  1 file changed, 24 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 229671ec3abd..f8a5ee927ecf 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -365,6 +365,11 @@ static void feature_tracefilt_trap_activate(struct kvm_vcpu *vcpu)
> >         feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TTRF, 0);
> >  }
> >
> > +static void feature_lor_trap_activate(struct kvm_vcpu *vcpu)
> > +{
> > +       feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TLOR, 0);
> > +}
> > +
> >  /* For ID_AA64PFR0_EL1 */
> >  static struct feature_config_ctrl ftr_ctrl_ras = {
> >         .ftr_reg = SYS_ID_AA64PFR0_EL1,
> > @@ -416,6 +421,15 @@ static struct feature_config_ctrl ftr_ctrl_tracefilt = {
> >         .trap_activate = feature_tracefilt_trap_activate,
> >  };
> >
> > +/* For ID_AA64MMFR1_EL1 */
> > +static struct feature_config_ctrl ftr_ctrl_lor = {
> > +       .ftr_reg = SYS_ID_AA64MMFR1_EL1,
> > +       .ftr_shift = ID_AA64MMFR1_LOR_SHIFT,
> > +       .ftr_min = 1,
> > +       .ftr_signed = FTR_UNSIGNED,
> > +       .trap_activate = feature_lor_trap_activate,
> > +};
> > +
> >  struct id_reg_info {
> >         u32     sys_reg;        /* Register ID */
> >         u64     sys_val;        /* Sanitized system value */
> > @@ -947,6 +961,14 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
> >         },
> >  };
> >
> > +static struct id_reg_info id_aa64mmfr1_el1_info = {
> > +       .sys_reg = SYS_ID_AA64MMFR1_EL1,
> > +       .trap_features = &(const struct feature_config_ctrl *[]) {
> > +               &ftr_ctrl_lor,
> > +               NULL,
> > +       },
> > +};
> > +
> >  static struct id_reg_info id_dfr0_el1_info = {
> >         .sys_reg = SYS_ID_DFR0_EL1,
> >         .init = init_id_dfr0_el1_info,
> > @@ -976,6 +998,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
> >         [IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
> >         [IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
> >         [IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
> > +       [IDREG_IDX(SYS_ID_AA64MMFR1_EL1)] = &id_aa64mmfr1_el1_info,
> >  };
> >
> >  static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
> > @@ -1050,10 +1073,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> >                           struct sys_reg_params *p,
> >                           const struct sys_reg_desc *r)
> >  {
> > -       u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
> >         u32 sr = reg_to_encoding(r);
> >
> > -       if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> > +       if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_lor)) {
> >                 kvm_inject_undefined(vcpu);
> >                 return false;
> >         }
> > --
> > 2.34.1.448.ga2b2bfdf31-goog
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
