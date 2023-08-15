Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5319317733
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 22:51:44 +0000 (UTC)
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2ba1e9b1fa9so92270571fa.3
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 15:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692139902; x=1692744702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NB4kFVYk0VzDJYVvftDfK9K6NvUawMTsvoAjbvdMEwE=;
        b=xgWSsZ+yzfnrNepdJd9XBKptt8IBaaOIWpyliBOfk98/gDqM9hqn9IAINYWKyqDXCe
         a2QTw3wHr5LMwxBfCU1r6nCgSLENTlW8JdZfS4VagOKwwYkDrk+TBQg3EpfbYB6fxmMf
         F76IQ6ckGv3M002Dx4RQpwQYxHhZTGVJd3ORJpcCQ/eeK0HZSqd7lesUi6By5wdPwE+J
         qO5CqsVaeO+If0rjYqooqIma7c/sN0NISzN8Ei7W9dov7u6f5YzUDWPWtz/d/mCooMTk
         X6foepwXAFMnsBL4ynSB6O1IdNv3qZISsU04Jr7QfVVm2I+5FONp11ovhipWeeN2B1qO
         s1CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692139902; x=1692744702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NB4kFVYk0VzDJYVvftDfK9K6NvUawMTsvoAjbvdMEwE=;
        b=jWiUBfY4vaZYp1xkTBcSR3taNPy/DO403WdAk7p31rQ+8l2vQEkG/K8I7x8L2ZqlLN
         DAP4Ayvfyj0xfVbKX8kSBf88WUF03/yahxhTNPj+lMCl03l3K56uT68u71oKUrIq83b1
         1cJsS0zaE/fdkcjnqcH2z4Lp/zKew3g98vPCB1JTpdlEkgFi/Iu+vqs9T8OyYO2aj0Li
         fADn4uIL87rE2VUEIxL5rn5Eubdz94aT0JWLNFvyV0PBFZGQlUF8b5y6MOOxX+XmlkP9
         EdyF+1BfI7r3vqGcqLxeGtyAYE9aBlASZKD1/1Bdkmpq7s/QGmrHDsMzmvN/+JRBN8hX
         55SA==
X-Gm-Message-State: AOJu0YxS5QMy5/9KXwyjymqHCA9fcniBuWWKl7mwDAFVWL2+LkIDrkWb
	RPL5yWayu4cmyRY7VCzckxSnQDf4cIb0pKukKOHmCAWn2m8Vp/KghgpRZQ==
X-Google-Smtp-Source: AGHT+IF424AIaaDGP3mEmWADXxKvMafTTEVIEC9y2GodBdWM1nxssfIaf+VbQh6Lw5rZ3EFxI3eKZ6tBBfbeDYUnH8A=
X-Received: by 2002:a2e:9915:0:b0:2b6:e0d3:45b7 with SMTP id
 v21-20020a2e9915000000b002b6e0d345b7mr113089lji.14.1692139902024; Tue, 15 Aug
 2023 15:51:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-21-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-21-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 15 Aug 2023 15:51:29 -0700
Message-ID: <CAAdAUtgFUkwuRZTwXe3E2MkFYV4e8zjgUYjJAP_JLeYWtN9H4g@mail.gmail.com>
Subject: Re: [PATCH v4 20/28] KVM: arm64: nv: Add trap forwarding for HFGxTR_EL2
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Andre Przywara <andre.przywara@arm.com>, 
	Chase Conklin <chase.conklin@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	Darren Hart <darren@os.amperecomputing.com>, Miguel Luis <miguel.luis@oracle.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Tue, Aug 15, 2023 at 11:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Implement the trap forwarding for traps described by HFGxTR_EL2,
> reusing the Fine Grained Traps infrastructure previously implemented.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 71 +++++++++++++++++++++++++++++++++
>  1 file changed, 71 insertions(+)
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index 0da9d92ed921..0e34797515b6 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -938,6 +938,7 @@ static DEFINE_XARRAY(sr_forward_xa);
>
>  enum fgt_group_id {
>         __NO_FGT_GROUP__,
> +       HFGxTR_GROUP,
>
>         /* Must be last */
>         __NR_FGT_GROUP_IDS__
> @@ -956,6 +957,69 @@ enum fgt_group_id {
>         }
>
>  static const struct encoding_to_trap_config encoding_to_fgt[] __initcons=
t =3D {
> +       /* HFGRTR_EL2, HFGWTR_EL2 */
> +       SR_FGT(SYS_TPIDR2_EL0,          HFGxTR, nTPIDR2_EL0, 0),
> +       SR_FGT(SYS_SMPRI_EL1,           HFGxTR, nSMPRI_EL1, 0),
> +       SR_FGT(SYS_ACCDATA_EL1,         HFGxTR, nACCDATA_EL1, 0),
> +       SR_FGT(SYS_ERXADDR_EL1,         HFGxTR, ERXADDR_EL1, 1),
> +       SR_FGT(SYS_ERXPFGCDN_EL1,       HFGxTR, ERXPFGCDN_EL1, 1),
> +       SR_FGT(SYS_ERXPFGCTL_EL1,       HFGxTR, ERXPFGCTL_EL1, 1),
> +       SR_FGT(SYS_ERXPFGF_EL1,         HFGxTR, ERXPFGF_EL1, 1),
> +       SR_FGT(SYS_ERXMISC0_EL1,        HFGxTR, ERXMISCn_EL1, 1),
> +       SR_FGT(SYS_ERXMISC1_EL1,        HFGxTR, ERXMISCn_EL1, 1),
> +       SR_FGT(SYS_ERXMISC2_EL1,        HFGxTR, ERXMISCn_EL1, 1),
> +       SR_FGT(SYS_ERXMISC3_EL1,        HFGxTR, ERXMISCn_EL1, 1),
> +       SR_FGT(SYS_ERXSTATUS_EL1,       HFGxTR, ERXSTATUS_EL1, 1),
> +       SR_FGT(SYS_ERXCTLR_EL1,         HFGxTR, ERXCTLR_EL1, 1),
> +       SR_FGT(SYS_ERXFR_EL1,           HFGxTR, ERXFR_EL1, 1),
> +       SR_FGT(SYS_ERRSELR_EL1,         HFGxTR, ERRSELR_EL1, 1),
> +       SR_FGT(SYS_ERRIDR_EL1,          HFGxTR, ERRIDR_EL1, 1),
> +       SR_FGT(SYS_ICC_IGRPEN0_EL1,     HFGxTR, ICC_IGRPENn_EL1, 1),
> +       SR_FGT(SYS_ICC_IGRPEN1_EL1,     HFGxTR, ICC_IGRPENn_EL1, 1),
> +       SR_FGT(SYS_VBAR_EL1,            HFGxTR, VBAR_EL1, 1),
> +       SR_FGT(SYS_TTBR1_EL1,           HFGxTR, TTBR1_EL1, 1),
> +       SR_FGT(SYS_TTBR0_EL1,           HFGxTR, TTBR0_EL1, 1),
> +       SR_FGT(SYS_TPIDR_EL0,           HFGxTR, TPIDR_EL0, 1),
> +       SR_FGT(SYS_TPIDRRO_EL0,         HFGxTR, TPIDRRO_EL0, 1),
> +       SR_FGT(SYS_TPIDR_EL1,           HFGxTR, TPIDR_EL1, 1),
> +       SR_FGT(SYS_TCR_EL1,             HFGxTR, TCR_EL1, 1),
> +       SR_FGT(SYS_SCXTNUM_EL0,         HFGxTR, SCXTNUM_EL0, 1),
> +       SR_FGT(SYS_SCXTNUM_EL1,         HFGxTR, SCXTNUM_EL1, 1),
> +       SR_FGT(SYS_SCTLR_EL1,           HFGxTR, SCTLR_EL1, 1),
> +       SR_FGT(SYS_REVIDR_EL1,          HFGxTR, REVIDR_EL1, 1),
> +       SR_FGT(SYS_PAR_EL1,             HFGxTR, PAR_EL1, 1),
> +       SR_FGT(SYS_MPIDR_EL1,           HFGxTR, MPIDR_EL1, 1),
> +       SR_FGT(SYS_MIDR_EL1,            HFGxTR, MIDR_EL1, 1),
> +       SR_FGT(SYS_MAIR_EL1,            HFGxTR, MAIR_EL1, 1),
> +       SR_FGT(SYS_LORSA_EL1,           HFGxTR, LORSA_EL1, 1),
> +       SR_FGT(SYS_LORN_EL1,            HFGxTR, LORN_EL1, 1),
> +       SR_FGT(SYS_LORID_EL1,           HFGxTR, LORID_EL1, 1),
> +       SR_FGT(SYS_LOREA_EL1,           HFGxTR, LOREA_EL1, 1),
> +       SR_FGT(SYS_LORC_EL1,            HFGxTR, LORC_EL1, 1),
> +       SR_FGT(SYS_ISR_EL1,             HFGxTR, ISR_EL1, 1),
> +       SR_FGT(SYS_FAR_EL1,             HFGxTR, FAR_EL1, 1),
> +       SR_FGT(SYS_ESR_EL1,             HFGxTR, ESR_EL1, 1),
> +       SR_FGT(SYS_DCZID_EL0,           HFGxTR, DCZID_EL0, 1),
> +       SR_FGT(SYS_CTR_EL0,             HFGxTR, CTR_EL0, 1),
> +       SR_FGT(SYS_CSSELR_EL1,          HFGxTR, CSSELR_EL1, 1),
> +       SR_FGT(SYS_CPACR_EL1,           HFGxTR, CPACR_EL1, 1),
> +       SR_FGT(SYS_CONTEXTIDR_EL1,      HFGxTR, CONTEXTIDR_EL1, 1),
> +       SR_FGT(SYS_CLIDR_EL1,           HFGxTR, CLIDR_EL1, 1),
> +       SR_FGT(SYS_CCSIDR_EL1,          HFGxTR, CCSIDR_EL1, 1),
> +       SR_FGT(SYS_APIBKEYLO_EL1,       HFGxTR, APIBKey, 1),
> +       SR_FGT(SYS_APIBKEYHI_EL1,       HFGxTR, APIBKey, 1),
> +       SR_FGT(SYS_APIAKEYLO_EL1,       HFGxTR, APIAKey, 1),
> +       SR_FGT(SYS_APIAKEYHI_EL1,       HFGxTR, APIAKey, 1),
> +       SR_FGT(SYS_APGAKEYLO_EL1,       HFGxTR, APGAKey, 1),
> +       SR_FGT(SYS_APGAKEYHI_EL1,       HFGxTR, APGAKey, 1),
> +       SR_FGT(SYS_APDBKEYLO_EL1,       HFGxTR, APDBKey, 1),
> +       SR_FGT(SYS_APDBKEYHI_EL1,       HFGxTR, APDBKey, 1),
> +       SR_FGT(SYS_APDAKEYLO_EL1,       HFGxTR, APDAKey, 1),
> +       SR_FGT(SYS_APDAKEYHI_EL1,       HFGxTR, APDAKey, 1),
> +       SR_FGT(SYS_AMAIR_EL1,           HFGxTR, AMAIR_EL1, 1),
> +       SR_FGT(SYS_AIDR_EL1,            HFGxTR, AIDR_EL1, 1),
> +       SR_FGT(SYS_AFSR1_EL1,           HFGxTR, AFSR1_EL1, 1),
> +       SR_FGT(SYS_AFSR0_EL1,           HFGxTR, AFSR0_EL1, 1),
>  };
>
>  static union trap_config get_trap_config(u32 sysreg)
> @@ -1160,6 +1224,13 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>         case __NO_FGT_GROUP__:
>                 break;
>
> +       case HFGxTR_GROUP:
> +               if (is_read)
> +                       val =3D sanitised_sys_reg(vcpu, HFGRTR_EL2);
> +               else
> +                       val =3D sanitised_sys_reg(vcpu, HFGWTR_EL2);
> +               break;
> +
>         case __NR_FGT_GROUP_IDS__:
>                 /* Something is really wrong, bail out */
>                 WARN_ONCE(1, "__NR_FGT_GROUP_IDS__");
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
