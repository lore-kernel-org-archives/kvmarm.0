Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79FBC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 28 Jan 2022 05:40:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A16D49E17;
	Fri, 28 Jan 2022 00:40:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3GCi6CxgrYtz; Fri, 28 Jan 2022 00:40:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8E8849E34;
	Fri, 28 Jan 2022 00:40:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAF4C49E17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jan 2022 00:40:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RxGFvkTylKya for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jan 2022 00:40:32 -0500 (EST)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CF8349E10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jan 2022 00:40:32 -0500 (EST)
Received: by mail-pj1-f50.google.com with SMTP id
 o16-20020a17090aac1000b001b62f629953so2557983pjq.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 21:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=kQgaN91aBojrZB98q50IoV/CyP18WN7SkHg7seKU5xM=;
 b=EfTcJpL2x2G+dT8lRtAOauEbP/eW8+MqMsieb6Ut4RCRsYhJmat4RREDbZ33oNm6IO
 HKsd32id5H2KfCMOsm3MMgrWFzClW5lB6+wE6U7N33IKzkksl+ZZDuVNfCxCJJWDtNJt
 S058unC4LH+8U2HBt4Mtnj9qxD5PJOwMwpSm5enImFwCgg0SY+7Y0W25Pl2q6MKYzMv2
 tpnWRdowQoKyeyKaXKSbA893V0hAp8TQdaSJG5cRvPOX/d1EKqkf6/vqvC+IAFORcdgL
 WwZLN33GewPKgfj6UZQf16RgtsUxr9Ma4P6ZdC28j3LQaQvrj0R0tyVr0tQ/c+enMMle
 UzsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=kQgaN91aBojrZB98q50IoV/CyP18WN7SkHg7seKU5xM=;
 b=HFlab6/cwkwLq5V7hVCzjcmuJdnf43BCkeTWnTfSfdWxFiNPVwGQhnDVWb9fYFy7Ty
 28xn2SQLlB33gyxbLhfiw/u8QPRBPUvNzlsKDr+q2vgrwp62pnhBjoWtwv9gaz3ohT0H
 mFDs4q53A/eDMoCxGuMd/5GaguZ0LhiKMex8E5fMmB6z8xlJNLIdXfmSBkbUJMH6/leD
 GYR+hviDdaF74wTC3uAtJiyAFgLLAeTxqxvhsy/CjymqI6BBaG8Vyu3jH6blkcKmIDet
 BQ0pSccZj0CMhaBSKBDorzO/O9FFI5hcrPFXiE7SbMo+5iGQYKvqYokMWqJdXXNe92fx
 7/nA==
X-Gm-Message-State: AOAM530vLMdwVHUnz+jHX8kJXd77IQ1EmkbWgDly5B+Azz+Ev4wYaYLa
 M29wqdenEYW2uaqm/S88D72ssY2hHakmVfmMzYulGw==
X-Google-Smtp-Source: ABdhPJw9oXiDHGetc7Kw5MzZ3rsTL6M2LnLubbiAM9+CcBEUzz/qRI1KGvq1K+4tioDROw4QG+bdUkzuQNyvRL+9FI0=
X-Received: by 2002:a17:902:d109:: with SMTP id
 w9mr6874586plw.138.1643348431315; 
 Thu, 27 Jan 2022 21:40:31 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-23-reijiw@google.com>
 <CA+EHjTyimL8nuE0gH8B3V-MzoA9rz+n3KazqFxMtdJKgjefAag@mail.gmail.com>
In-Reply-To: <CA+EHjTyimL8nuE0gH8B3V-MzoA9rz+n3KazqFxMtdJKgjefAag@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 27 Jan 2022 21:40:15 -0800
Message-ID: <CAAeT=Fw5LC559c=NxSp8xk1WO0CkD-DoJd-sACf78Uf6Yu1nMA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 22/26] KVM: arm64: Trap disabled features of
 ID_AA64DFR0_EL1
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

On Mon, Jan 24, 2022 at 9:20 AM Fuad Tabba <tabba@google.com> wrote:
>
> .Hi Reiji,
>
> On Thu, Jan 6, 2022 at 4:29 AM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Add feature_config_ctrl for PMUv3, PMS and TraceFilt, which are
> > indicated in ID_AA64DFR0_EL1, to program configuration registers
> > to trap guest's using those features when they are not exposed to
> > the guest.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 47 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 47 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 72e745c5a9c2..229671ec3abd 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -349,6 +349,22 @@ static void feature_mte_trap_activate(struct kvm_vcpu *vcpu)
> >         feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TID5, HCR_DCT | HCR_ATA);
> >  }
> >
> > +static void feature_pmuv3_trap_activate(struct kvm_vcpu *vcpu)
> > +{
> > +       feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TPM, 0);
>
> I think that for full coverage it might be good to include setting
> MDCR_EL2_TPMCR, and clearing MDCR_EL2_HPME | MDCR_EL2_MTPME |
> MDCR_EL2_HPMN_MASK, even if redundant at this point.

I included what is needed only, and I would prefer not to let KVM
do things that are not needed to trap guest's using the feature.
Please let me know if you have a specific reason why you think it
would be better to include them.

>
> > +}
> > +
> > +static void feature_pms_trap_activate(struct kvm_vcpu *vcpu)
> > +{
> > +       feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TPMS,
> > +                             MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT);
> > +}
> > +
> > +static void feature_tracefilt_trap_activate(struct kvm_vcpu *vcpu)
> > +{
> > +       feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TTRF, 0);
> > +}
> > +
> >  /* For ID_AA64PFR0_EL1 */
> >  static struct feature_config_ctrl ftr_ctrl_ras = {
> >         .ftr_reg = SYS_ID_AA64PFR0_EL1,
> > @@ -375,6 +391,31 @@ static struct feature_config_ctrl ftr_ctrl_mte = {
> >         .trap_activate = feature_mte_trap_activate,
> >  };
> >
> > +/* For ID_AA64DFR0_EL1 */
> > +static struct feature_config_ctrl ftr_ctrl_pmuv3 = {
> > +       .ftr_reg = SYS_ID_AA64DFR0_EL1,
> > +       .ftr_shift = ID_AA64DFR0_PMUVER_SHIFT,
> > +       .ftr_min = ID_AA64DFR0_PMUVER_8_0,
> > +       .ftr_signed = FTR_UNSIGNED,
> > +       .trap_activate = feature_pmuv3_trap_activate,
> > +};
> > +
> > +static struct feature_config_ctrl ftr_ctrl_pms = {
> > +       .ftr_reg = SYS_ID_AA64DFR0_EL1,
> > +       .ftr_shift = ID_AA64DFR0_PMSVER_SHIFT,
> > +       .ftr_min = ID_AA64DFR0_PMSVER_8_2,
> > +       .ftr_signed = FTR_UNSIGNED,
> > +       .trap_activate = feature_pms_trap_activate,
> > +};
> > +
> > +static struct feature_config_ctrl ftr_ctrl_tracefilt = {
> > +       .ftr_reg = SYS_ID_AA64DFR0_EL1,
> > +       .ftr_shift = ID_AA64DFR0_TRACE_FILT_SHIFT,
> > +       .ftr_min = 1,
> > +       .ftr_signed = FTR_UNSIGNED,
> > +       .trap_activate = feature_tracefilt_trap_activate,
> > +};
>
> I think you might be missing trace, ID_AA64DFR0_TRACEVER -> CPTR_EL2_TTA.

Thank you for catching this. I will add the trace.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
