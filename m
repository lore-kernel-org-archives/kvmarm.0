Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A568BC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 05:03:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0FE049F5A;
	Thu, 27 Jan 2022 00:03:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id baH82zbZN93y; Thu, 27 Jan 2022 00:03:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC6B749EEF;
	Thu, 27 Jan 2022 00:03:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28D6C49EE2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 00:03:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZllCrjEA6Jzx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 00:03:51 -0500 (EST)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
 [209.85.215.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB62D40453
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 00:03:51 -0500 (EST)
Received: by mail-pg1-f180.google.com with SMTP id q75so1269365pgq.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 21:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=agPawYo4RaAHn59m9QDt6suEoJLBOjPFjwtduhksCZA=;
 b=SHnaCJpS0XGF2gKPdqkxKsiQEN5Pvi0d4uuTXh2KymzYNDiqFtc13ey3Pu+dNkEgbZ
 pk/V6yrlgQge1/tujoYulDwjpCQmWLLJcvfWi7mBzKxIVSCCE8ta7V+Lr91cJvfLziNq
 1uhuc6gxDu5tYnDXQ9IZeL2cvPMXV7AkK6FfjUOn72PfHO55XXe+YnCas50gOtS14/ep
 s5P8DmOcWl0mqJzudyVMXOSVsO4TlTfZ3mcMuJ7eIRGMqv4k6h9ONr8mBjNhNlDM2U+g
 0k2IIfdEN+/P1B2f+UGy92Qj2L4lhmvWNcuhQbbK/iFk/hu8IIA0p10SGvmIfbW2vIZJ
 WkOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=agPawYo4RaAHn59m9QDt6suEoJLBOjPFjwtduhksCZA=;
 b=TcvOAHzwQKIrXspVl6iVLHeUpecS5RAP9penux+yF4092/MUAcwCNfa6s+tpjahz1B
 y6zkJHmH0omsWEUaVQVNg9B5sO7S2XJ89WBKGdw7LPKLo4UKk1bNjfcDtx9/fxaXlt18
 fJbYndEd12Xs/I33zJ4kPJFtEMb8U+AUl8G2d4XNxt1bqJMdxovyNc7IMpYIopTH5pek
 nM4i8d8LW6qr24JUTg5g49PDvCgy1xgMhYQbrtr+g0vaqc8YZIzRNErrEk6sJ6yG6Rqt
 TD1VHCZR8eGLVBQHQj4ODhd4e2VE0vggs3slXVNhi0H/bCEtjHfnfY+ZXveIGIvg87Ag
 xsfQ==
X-Gm-Message-State: AOAM530kRag/HD8Rsp8c5lBWX3gdzAvWNPj98yrToM8bh4OfWvxG4xFl
 5dgVQxd+SNOe52us7CgVCQyAeGCET22es9K16m3cDA==
X-Google-Smtp-Source: ABdhPJyohy4/6u5c4O8NFD2tW970/10L+Klc/wjONOYTfQvmiQ0UEXicdr8tiFzT/PhrjqK7I+uv9Ai47/74v+I+TOk=
X-Received: by 2002:a63:6909:: with SMTP id e9mr1595725pgc.514.1643259830730; 
 Wed, 26 Jan 2022 21:03:50 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-15-reijiw@google.com>
 <CA+EHjTzQK2kswrW3LDf0ybz4estOCdafCvtRZHWwvTv2nH-UVw@mail.gmail.com>
In-Reply-To: <CA+EHjTzQK2kswrW3LDf0ybz4estOCdafCvtRZHWwvTv2nH-UVw@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 26 Jan 2022 21:03:34 -0800
Message-ID: <CAAeT=FzR+=evcsOA9PMtsE=TDJmBq1LJxR5wo1DMgEZ0B=dU9Q@mail.gmail.com>
Subject: Re: [RFC PATCH v4 14/26] KVM: arm64: Add consistency checking for
 frac fields of ID registers
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

On Mon, Jan 24, 2022 at 9:01 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Reiji,
>
> On Thu, Jan 6, 2022 at 4:29 AM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Feature fractional field of an ID register cannot be simply validated
> > at KVM_SET_ONE_REG because its validity depends on its (main) feature
> > field value, which could be in a different ID register (and might be
> > set later).
> > Validate fractional fields at the first KVM_RUN instead.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |   1 +
> >  arch/arm64/kvm/arm.c              |   3 +
> >  arch/arm64/kvm/sys_regs.c         | 116 +++++++++++++++++++++++++++++-
> >  3 files changed, 117 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 4509f9e7472d..7b3f86bd6a6b 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -750,6 +750,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >
> >  void set_default_id_regs(struct kvm *kvm);
> >  int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval);
> > +int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu);
> >
> >  /* Guest/host FPSIMD coordination helpers */
> >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 5f497a0af254..16fc2ce32069 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -596,6 +596,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
> >         if (!kvm_arm_vcpu_is_finalized(vcpu))
> >                 return -EPERM;
> >
> > +       if (!kvm_vm_is_protected(kvm) && kvm_id_regs_consistency_check(vcpu))
> > +               return -EPERM;
> > +
> >         vcpu->arch.has_run_once = true;
> >
> >         kvm_arm_vcpu_init_debug(vcpu);
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index ddbeefc3881c..6adb7b04620c 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -756,9 +756,6 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
> >
> >  static struct id_reg_info id_aa64pfr1_el1_info = {
> >         .sys_reg = SYS_ID_AA64PFR1_EL1,
> > -       .ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_RASFRAC) |
> > -                      ARM64_FEATURE_MASK(ID_AA64PFR1_MPAMFRAC) |
> > -                      ARM64_FEATURE_MASK(ID_AA64PFR1_CSV2FRAC),
> >         .init = init_id_aa64pfr1_el1_info,
> >         .validate = validate_id_aa64pfr1_el1,
> >         .vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
> > @@ -3434,10 +3431,109 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> >         return write_demux_regids(uindices);
> >  }
> >
> > +/* ID register's fractional field information with its feature field. */
> > +struct feature_frac {
> > +       u32     id;
> > +       u32     shift;
> > +       u32     frac_id;
> > +       u32     frac_shift;
> > +       u8      frac_ftr_check;
> > +};
>
> frac_ftr_check doesn't seem to be used. Also, it would be easier to
> read if the ordering of the fields match the ordering you initialize
> them below.

Thank you for catching this.
I will remove frac_ftr_check and change the ordering.

>
> > +
> > +static struct feature_frac feature_frac_table[] = {
> > +       {
> > +               .frac_id = SYS_ID_AA64PFR1_EL1,
> > +               .frac_shift = ID_AA64PFR1_RASFRAC_SHIFT,
> > +               .id = SYS_ID_AA64PFR0_EL1,
> > +               .shift = ID_AA64PFR0_RAS_SHIFT,
> > +       },
> > +       {
> > +               .frac_id = SYS_ID_AA64PFR1_EL1,
> > +               .frac_shift = ID_AA64PFR1_MPAMFRAC_SHIFT,
> > +               .id = SYS_ID_AA64PFR0_EL1,
> > +               .shift = ID_AA64PFR0_MPAM_SHIFT,
> > +       },
> > +       {
> > +               .frac_id = SYS_ID_AA64PFR1_EL1,
> > +               .frac_shift = ID_AA64PFR1_CSV2FRAC_SHIFT,
> > +               .id = SYS_ID_AA64PFR0_EL1,
> > +               .shift = ID_AA64PFR0_CSV2_SHIFT,
> > +       },
> > +};
> > +
> > +/*
> > + * Return non-zero if the feature/fractional fields pair are not
> > + * supported. Return zero otherwise.
> > + * This function validates only the fractional feature field,
> > + * and relies on the fact the feature field is validated before
> > + * through arm64_check_features.
> > + */
> > +static int vcpu_id_reg_feature_frac_check(const struct kvm_vcpu *vcpu,
> > +                                         const struct feature_frac *ftr_frac)
> > +{
> > +       const struct id_reg_info *id_reg;
> > +       u32 id;
> > +       u64 val, lim, mask;
> > +
> > +       /* Check if the feature field value is same as the limit */
> > +       id = ftr_frac->id;
> > +       id_reg = GET_ID_REG_INFO(id);
> > +
> > +       mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->shift;
> > +       val = __read_id_reg(vcpu, id) & mask;
> > +       lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
> > +       lim &= mask;
> > +
> > +       if (val != lim)
> > +               /*
> > +                * The feature level is lower than the limit.
> > +                * Any fractional version should be fine.
> > +                */
> > +               return 0;
> > +
> > +       /* Check the fractional feature field */
> > +       id = ftr_frac->frac_id;
> > +       id_reg = GET_ID_REG_INFO(id);
> > +
> > +       mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->frac_shift;
> > +       val = __read_id_reg(vcpu, id) & mask;
> > +       lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
> > +       lim &= mask;
> > +
> > +       if (val == lim)
> > +               /*
> > +                * Both the feature and fractional fields are the same
> > +                * as limit.
> > +                */
> > +               return 0;
> > +
> > +       return arm64_check_features(id, val, lim);
> > +}
> > +
> > +int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
>
> Nit: considering that this is only checking the fractional fields,
> should the function name reflect that?

Thank you for the suggestion.
I will change the function name to reflect that.
(There were more checks in older version and I forgot to
change the name...)

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
