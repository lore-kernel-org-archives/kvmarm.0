Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE422C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 24 Jan 2022 17:17:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 244F24141A;
	Mon, 24 Jan 2022 12:17:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id szCiMHS+jVRH; Mon, 24 Jan 2022 12:17:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBFA543C96;
	Mon, 24 Jan 2022 12:17:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2D00412FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 12:17:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sth69XYf6piR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jan 2022 12:17:33 -0500 (EST)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com
 [209.85.210.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54E03411D2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 12:17:33 -0500 (EST)
Received: by mail-ot1-f51.google.com with SMTP id
 m8-20020a9d4c88000000b00592bae7944bso23184820otf.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jan 2022 09:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=CL0djcumxtWN+BgS/G/QSSO38KOz4Hm+Dv6snxvPnLQ=;
 b=bEOX7mlSFbkKgmP35DipMBrLAvuLXbJBAG11aNsVoJzXY/NmD/d76/IBO5PRKM2z//
 mJ0hVyqyd59JqpacFdIoSXCurKr4RCKD3BOffUaqKo7Yqky3UvgRYxen3vtR2qmqZxnx
 oV3ef6KkJd/geDXrNFxs826oj+MRRB78BL5PEjyDug/vnEgYydSB6DORewhW9nyQl3T0
 7xrDiKzcV87LacmuCBZcbhevtuONAyEDBDrbqY7fanuy0CJ557oWYzZnXjy5G0uEpDPE
 Aejd+s/oWGk4vMeZCFepE5pR8gGYCcXgpWicwzdduLePpTlcBfv0EMtGBY0+gCOF+3zu
 J/xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=CL0djcumxtWN+BgS/G/QSSO38KOz4Hm+Dv6snxvPnLQ=;
 b=Loxxv281bLbjM1qTrSFcaPmL3YVx8yldnil652P8eFUVSWFyvT326yAfej99LjJTQF
 rUAWFtodNXqiFOG+XeWcg6tCmfZkliuUAmIjyAXfNazp7+A7oxM160CUIurPYnKSrIQI
 AlcErRWM1HuBLrsnVXaVhzkcyQp5UJ1FYD8dzNV8j8XmK55eYlKtp5CbI/Zm5T6Oyrek
 mhyIOUul1Zm4Q01JPIAQPGPP8QqPcK8Vhs/M+dQY3XMokYrZcwk4bmbsVV6dRrB9mnjf
 xAs0yeZ3zVf2I2lSxYmWITS1SO3m55Z4q6WDaCT/70kjMN4Aqemk1RcN4PCoSFbgbIxL
 S2jA==
X-Gm-Message-State: AOAM532J2TEC3LpXsEDRJmO4vhyathVUvbLUw5cLMKpnYqmAaw1sKNbQ
 08U7oTO1UCZBzjPxxIVqOOireDn8eSxaMsEiX9sypw==
X-Google-Smtp-Source: ABdhPJyrMjp3o7vm5+0kX9TJJ+ivG+r/ZOeyr6HGlSMAW0c24FM3CFAps82KuddHQJzsa74DX8Q5gGgHPMEQq/YOTHY=
X-Received: by 2002:a9d:6c0d:: with SMTP id f13mr648555otq.299.1643044652111; 
 Mon, 24 Jan 2022 09:17:32 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-21-reijiw@google.com>
In-Reply-To: <20220106042708.2869332-21-reijiw@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 24 Jan 2022 17:16:55 +0000
Message-ID: <CA+EHjTy4L37G89orJ+cPTTZdFUehxNSMy0Pd36PW41JKVB0ohA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 20/26] KVM: arm64: Trap disabled features of
 ID_AA64PFR0_EL1
To: Reiji Watanabe <reijiw@google.com>
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

Hi Reiji,

On Thu, Jan 6, 2022 at 4:29 AM Reiji Watanabe <reijiw@google.com> wrote:
>
> Add feature_config_ctrl for RAS and AMU, which are indicated in
> ID_AA64PFR0_EL1, to program configuration registers to trap
> guest's using those features when they are not exposed to the guest.
>
> Introduce trap_ras_regs() to change a behavior of guest's access to
> the registers, which is currently raz/wi, depending on the feature's
> availability for the guest (and inject undefined instruction
> exception when guest's RAS register access are trapped and RAS is
> not exposed to the guest).  In order to keep the current visibility
> of the RAS registers from userspace (always visible), a visibility
> function for RAS registers is not added.
>
> No code is added for AMU's access/visibility handler because the
> current code already injects the exception for Guest's AMU register
> access unconditionally because AMU is never exposed to the guest.

I think it might be code to trap it anyway, in case AMU guest support
is added in the future.

>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 90 +++++++++++++++++++++++++++++++++++----
>  1 file changed, 82 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 33893a501475..015d67092d5e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -304,6 +304,63 @@ struct feature_config_ctrl {
>         void    (*trap_activate)(struct kvm_vcpu *vcpu);
>  };
>
> +enum vcpu_config_reg {
> +       VCPU_HCR_EL2 = 1,
> +       VCPU_MDCR_EL2,
> +       VCPU_CPTR_EL2,
> +};
> +
> +static void feature_trap_activate(struct kvm_vcpu *vcpu,
> +                                 enum vcpu_config_reg cfg_reg,
> +                                 u64 cfg_set, u64 cfg_clear)
> +{
> +       u64 *reg_ptr, reg_val;
> +
> +       switch (cfg_reg) {
> +       case VCPU_HCR_EL2:
> +               reg_ptr = &vcpu->arch.hcr_el2;
> +               break;
> +       case VCPU_MDCR_EL2:
> +               reg_ptr = &vcpu->arch.mdcr_el2;
> +               break;
> +       case VCPU_CPTR_EL2:
> +               reg_ptr = &vcpu->arch.cptr_el2;
> +               break;
> +       }
> +
> +       /* Clear/Set fields that are indicated by cfg_clear/cfg_set. */
> +       reg_val = (*reg_ptr & ~cfg_clear);
> +       reg_val |= cfg_set;
> +       *reg_ptr = reg_val;
> +}
> +
> +static void feature_ras_trap_activate(struct kvm_vcpu *vcpu)
> +{
> +       feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TERR | HCR_TEA, HCR_FIEN);

Covers all the flags for ras.

> +}
> +
> +static void feature_amu_trap_activate(struct kvm_vcpu *vcpu)
> +{
> +       feature_trap_activate(vcpu, VCPU_CPTR_EL2, CPTR_EL2_TAM, 0);

Covers the CPTR flags for AMU, but as you mentioned, does not
explicitly clear HCR_AMVOFFEN.

Cheers,
/fuad


> +}
> +
> +/* For ID_AA64PFR0_EL1 */
> +static struct feature_config_ctrl ftr_ctrl_ras = {
> +       .ftr_reg = SYS_ID_AA64PFR0_EL1,
> +       .ftr_shift = ID_AA64PFR0_RAS_SHIFT,
> +       .ftr_min = ID_AA64PFR0_RAS_V1,
> +       .ftr_signed = FTR_UNSIGNED,
> +       .trap_activate = feature_ras_trap_activate,
> +};
> +
> +static struct feature_config_ctrl ftr_ctrl_amu = {
> +       .ftr_reg = SYS_ID_AA64PFR0_EL1,
> +       .ftr_shift = ID_AA64PFR0_AMU_SHIFT,
> +       .ftr_min = ID_AA64PFR0_AMU,
> +       .ftr_signed = FTR_UNSIGNED,
> +       .trap_activate = feature_amu_trap_activate,
> +};
> +
>  struct id_reg_info {
>         u32     sys_reg;        /* Register ID */
>         u64     sys_val;        /* Sanitized system value */
> @@ -778,6 +835,11 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
>         .init = init_id_aa64pfr0_el1_info,
>         .validate = validate_id_aa64pfr0_el1,
>         .vcpu_mask = vcpu_mask_id_aa64pfr0_el1,
> +       .trap_features = &(const struct feature_config_ctrl *[]) {
> +               &ftr_ctrl_ras,
> +               &ftr_ctrl_amu,
> +               NULL,
> +       },
>  };
>
>  static struct id_reg_info id_aa64pfr1_el1_info = {
> @@ -901,6 +963,18 @@ static inline bool vcpu_feature_is_available(struct kvm_vcpu *vcpu,
>         return feature_avail(ctrl, val);
>  }
>
> +static bool trap_ras_regs(struct kvm_vcpu *vcpu,
> +                         struct sys_reg_params *p,
> +                         const struct sys_reg_desc *r)
> +{
> +       if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_ras)) {
> +               kvm_inject_undefined(vcpu);
> +               return false;
> +       }
> +
> +       return trap_raz_wi(vcpu, p, r);
> +}
> +
>  /*
>   * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
>   * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
> @@ -2265,14 +2339,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>         { SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
>         { SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
>
> -       { SYS_DESC(SYS_ERRIDR_EL1), trap_raz_wi },
> -       { SYS_DESC(SYS_ERRSELR_EL1), trap_raz_wi },
> -       { SYS_DESC(SYS_ERXFR_EL1), trap_raz_wi },
> -       { SYS_DESC(SYS_ERXCTLR_EL1), trap_raz_wi },
> -       { SYS_DESC(SYS_ERXSTATUS_EL1), trap_raz_wi },
> -       { SYS_DESC(SYS_ERXADDR_EL1), trap_raz_wi },
> -       { SYS_DESC(SYS_ERXMISC0_EL1), trap_raz_wi },
> -       { SYS_DESC(SYS_ERXMISC1_EL1), trap_raz_wi },
> +       { SYS_DESC(SYS_ERRIDR_EL1), trap_ras_regs },
> +       { SYS_DESC(SYS_ERRSELR_EL1), trap_ras_regs },
> +       { SYS_DESC(SYS_ERXFR_EL1), trap_ras_regs },
> +       { SYS_DESC(SYS_ERXCTLR_EL1), trap_ras_regs },
> +       { SYS_DESC(SYS_ERXSTATUS_EL1), trap_ras_regs },
> +       { SYS_DESC(SYS_ERXADDR_EL1), trap_ras_regs },
> +       { SYS_DESC(SYS_ERXMISC0_EL1), trap_ras_regs },
> +       { SYS_DESC(SYS_ERXMISC1_EL1), trap_ras_regs },
>
>         MTE_REG(TFSR_EL1),
>         MTE_REG(TFSRE0_EL1),
> --
> 2.34.1.448.ga2b2bfdf31-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
