Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B5517733
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 22:42:39 +0000 (UTC)
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2b9d3dacb33so92123311fa.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 15:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692139358; x=1692744158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2dxy5CUviouI5s+/87oQE60ygEz3bVp2P/B49OeB1Dk=;
        b=K1yrNSN1wGJ/Ij03+jbwsXdDmuXmqkDPfeTlAHInBeoPWwGMRSIw8LNxEnYatLe0oN
         Mkpr5pPJnyGRWH0+1XAfzo5mjI2uNekSUxp/++3cXNr8py0kGz5rN/nFr7TYcleWa6d6
         ENqL5rQdqvrszwaq5ucsYbl+LGuOdbsaBbPO/sEBTjh9w6Xo50VeA166tGkNYdCgBhgM
         1GM8ra84RWWjQRJZ1Qk9ovmcTNymbtB3Y7fH1Ql88pHlblgyJL3dPCKJtHWiOHNReExh
         hv8GQfXfwqUCMb68lF1a8AFFbAUzhpSslQ7RahNr4ErZKNKaYaSOZuErWaP2cOI7h+nh
         U45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692139358; x=1692744158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2dxy5CUviouI5s+/87oQE60ygEz3bVp2P/B49OeB1Dk=;
        b=l2jaQfkbBpv9zAZBaEuWTdbzRpHyvEJb6fYmDz2yYtROQHbK7dlmU0fCSq88j0j5aT
         +XrRtGbtarPv8Lyoq0eDAem1Y2PDEJuD9EDBmNzssqSBG5OIduiUBhfUgwYw9ktvgbXk
         l8ONJiTitPKHwAx6QRiml3M0K5j3FkFesqX4oUsj/xZW6N3/0CVJrgeaPDQUAjDHWQnX
         QPfOGJ44SxkadjihgcrgiQbPdJZmsCL87PnUn7UqTmM4fuc0IjiROoTAgspuupSELtr0
         erBGKlLAMfHtqjuF/2I8BiQDsQGC20CRoqAvuE3e0dJtvfUEwASb8IX99AfgTS5+XmoT
         ypXA==
X-Gm-Message-State: AOJu0Yzdci/n/NbJDK4JEirpc4fvh9d/LkI4WgvjX6MxWgKDCZAcuC7s
	wfBixfQVVqkzyIONch+7ZL75AA+ak1d867Xkii1FWg==
X-Google-Smtp-Source: AGHT+IFMm1Wbu88Vuj6htd0j73B+7kx6Dybl5Dk/8xGhk9wxcdtFWGY11J91uR6kiWAncxkoNsuzSbFi3BXybh78GkE=
X-Received: by 2002:a2e:9450:0:b0:2b6:a804:4cc with SMTP id
 o16-20020a2e9450000000b002b6a80404ccmr74470ljh.53.1692139357683; Tue, 15 Aug
 2023 15:42:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-19-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-19-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 15 Aug 2023 15:42:16 -0700
Message-ID: <CAAdAUtgW2siaCKfnx2iANB+hNg=YdB2dv5O9fdexkU2RmaQSfA@mail.gmail.com>
Subject: Re: [PATCH v4 18/28] KVM: arm64: nv: Add trap forwarding for CNTHCTL_EL2
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
> Describe the CNTHCTL_EL2 register, and associate it with all the sysregs
> it allows to trap.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 50 ++++++++++++++++++++++++++++++++-
>  1 file changed, 49 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index 241e44eeed6d..860910386b5b 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -100,9 +100,11 @@ enum cgt_group_id {
>
>         /*
>          * Anything after this point requires a callback evaluating a
> -        * complex trap condition. Hopefully we'll never need this...
> +        * complex trap condition. Ugly stuff.
>          */
>         __COMPLEX_CONDITIONS__,
> +       CGT_CNTHCTL_EL1PCTEN =3D __COMPLEX_CONDITIONS__,
> +       CGT_CNTHCTL_EL1PTEN,
>
>         /* Must be last */
>         __NR_CGT_GROUP_IDS__
> @@ -369,10 +371,51 @@ static const enum cgt_group_id *coarse_control_comb=
o[] =3D {
>
>  typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *=
);
>
> +/*
> + * Warning, maximum confusion ahead.
> + *
> + * When E2H=3D0, CNTHCTL_EL2[1:0] are defined as EL1PCEN:EL1PCTEN
> + * When E2H=3D1, CNTHCTL_EL2[11:10] are defined as EL1PTEN:EL1PCTEN
> + *
> + * Note the single letter difference? Yet, the bits have the same
> + * function despite a different layout and a different name.
> + *
> + * We don't try to reconcile this mess. We just use the E2H=3D0 bits
> + * to generate something that is in the E2H=3D1 format, and live with
> + * it. You're welcome.
> + */
> +static u64 get_sanitized_cnthctl(struct kvm_vcpu *vcpu)
> +{
> +       u64 val =3D __vcpu_sys_reg(vcpu, CNTHCTL_EL2);
> +
> +       if (!vcpu_el2_e2h_is_set(vcpu))
> +               val =3D (val & (CNTHCTL_EL1PCEN | CNTHCTL_EL1PCTEN)) << 1=
0;
> +
> +       return val & ((CNTHCTL_EL1PCEN | CNTHCTL_EL1PCTEN) << 10);
> +}
> +
> +static enum trap_behaviour check_cnthctl_el1pcten(struct kvm_vcpu *vcpu)
> +{
> +       if (get_sanitized_cnthctl(vcpu) & (CNTHCTL_EL1PCTEN << 10))
> +               return BEHAVE_HANDLE_LOCALLY;
> +
> +       return BEHAVE_FORWARD_ANY;
> +}
> +
> +static enum trap_behaviour check_cnthctl_el1pten(struct kvm_vcpu *vcpu)
> +{
> +       if (get_sanitized_cnthctl(vcpu) & (CNTHCTL_EL1PCEN << 10))
> +               return BEHAVE_HANDLE_LOCALLY;
> +
> +       return BEHAVE_FORWARD_ANY;
> +}
> +
>  #define CCC(id, fn)                            \
>         [id - __COMPLEX_CONDITIONS__] =3D fn
>
>  static const complex_condition_check ccc[] =3D {
> +       CCC(CGT_CNTHCTL_EL1PCTEN, check_cnthctl_el1pcten),
> +       CCC(CGT_CNTHCTL_EL1PTEN, check_cnthctl_el1pten),
>  };
>
>  /*
> @@ -877,6 +920,11 @@ static const struct encoding_to_trap_config encoding=
_to_cgt[] __initconst =3D {
>         SR_TRAP(SYS_TRBPTR_EL1,         CGT_MDCR_E2TB),
>         SR_TRAP(SYS_TRBSR_EL1,          CGT_MDCR_E2TB),
>         SR_TRAP(SYS_TRBTRG_EL1,         CGT_MDCR_E2TB),
> +       SR_TRAP(SYS_CNTP_TVAL_EL0,      CGT_CNTHCTL_EL1PTEN),
> +       SR_TRAP(SYS_CNTP_CVAL_EL0,      CGT_CNTHCTL_EL1PTEN),
> +       SR_TRAP(SYS_CNTP_CTL_EL0,       CGT_CNTHCTL_EL1PTEN),
> +       SR_TRAP(SYS_CNTPCT_EL0,         CGT_CNTHCTL_EL1PCTEN),
> +       SR_TRAP(SYS_CNTPCTSS_EL0,       CGT_CNTHCTL_EL1PCTEN),
>  };
>
>  static DEFINE_XARRAY(sr_forward_xa);
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
