Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A3517733
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 22:44:58 +0000 (UTC)
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2b962c226ceso92563161fa.3
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 15:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692139496; x=1692744296;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fjQrprw4nMiLKtwIPJkgTv2IKpasPONr8uvxyj8fNzU=;
        b=HvGg2AgrypcLMwtQY8yzQzwEEhJv50v2zX2E2hbW/ysnRw82Ac8RygOwAW12YLNe85
         L87DSyi2EJfulNQpQiHfg6UYQGGB5/3jnWx3RgP4s4p8fBV0VMHzZvzMNagh0mvqfKTL
         tEiuFSjSjJg3A8yEdl4hMUXsWRorSzH+mThHNHogmJYNpVjp3guAjtV7uKCK2AhnIHzm
         k0IMubOQCnJTW4LrCsP7YftorsfBeCTyTxJLP5ai0MED5xfaRsb8Ce7lUrMCwSfBWBWW
         p5WTtztIx34aUwMKnWI762aV3xkhq4oZCUk0AVHsQNroZ4NfMYU6lds3WzSo72C9PG2f
         MFdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692139496; x=1692744296;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fjQrprw4nMiLKtwIPJkgTv2IKpasPONr8uvxyj8fNzU=;
        b=EjMxATxR47Z7YoexWTflJgZBo3thlSeCOtlMS9NUrTv8QuX9OnTNSur0/FZ2VDAkbu
         rvrSTdFN52ooyqPM7Yl2rERPeaGWMtfegRFyXkb+ljDfOpcd/TD5hnA2ShWfSKJPyXuE
         LMU66hQgtaN1agFQ9N0Qyr7pzmJpkGx6bB/yFwBBcVeE95XMApd8FZCH0Ozb1TR1aPW5
         lZPNGPrL8+ISN9oENzcK7njFyAtWTx0kcpc21uEokICcwYvteWrr888e7ZRILp0faRg4
         X7PvAz3GOMmIY5LM+0mdsG9srJT67qTM5JqM4g51VCNhb+LYS1ruIP/TZnqqnFW5Y4Km
         pQMA==
X-Gm-Message-State: AOJu0Yx0TtDWmYjdtTz6nrNYK+yupaaqnW2KACuGDL/KnFbmCTHtXdBv
	VQYfeGRr2oWMZtEWS1DMjwVSVdinl3GU4u8aegZLh/C0iVltwEYaXEJRmQ==
X-Google-Smtp-Source: AGHT+IEEXYRWc2ESGmwPgouMb0IUf1j7nJBblZmQ5xG6tEo9CIKpIo08aq7FlON3zov9HXnZ1KIl6giL185XfpDlQAA=
X-Received: by 2002:a2e:9e86:0:b0:2b6:cf0f:1fbf with SMTP id
 f6-20020a2e9e86000000b002b6cf0f1fbfmr95306ljk.42.1692139496488; Tue, 15 Aug
 2023 15:44:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-20-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-20-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 15 Aug 2023 15:44:44 -0700
Message-ID: <CAAdAUtgRGwfhjn=tEW_dNXpHMnDVcCObZKm48MO2WSUVS7kceg@mail.gmail.com>
Subject: Re: [PATCH v4 19/28] KVM: arm64: nv: Add fine grained trap forwarding infrastructure
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
> Fine Grained Traps are fun. Not.
>
> Implement the fine grained trap forwarding, reusing the Coarse Grained
> Traps infrastructure previously implemented.
>
> Each sysreg/instruction inserted in the xarray gets a FGT group
> (vaguely equivalent to a register number), a bit number in that register,
> and a polarity.
>
> It is then pretty easy to check the FGT state at handling time, just
> like we do for the coarse version (it is just faster).
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 90 +++++++++++++++++++++++++++++++--
>  1 file changed, 87 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index 860910386b5b..0da9d92ed921 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -423,16 +423,23 @@ static const complex_condition_check ccc[] =3D {
>   * following layout for each trapped sysreg:
>   *
>   * [9:0]       enum cgt_group_id (10 bits)
> - * [62:10]     Unused (53 bits)
> + * [13:10]     enum fgt_group_id (4 bits)
> + * [19:14]     bit number in the FGT register (6 bits)
> + * [20]                trap polarity (1 bit)
> + * [62:21]     Unused (42 bits)
>   * [63]                RES0 - Must be zero, as lost on insertion in the =
xarray
>   */
>  #define TC_CGT_BITS    10
> +#define TC_FGT_BITS    4
>
>  union trap_config {
>         u64     val;
>         struct {
>                 unsigned long   cgt:TC_CGT_BITS; /* Coarse Grained Trap i=
d */
> -               unsigned long   unused:53;       /* Unused, should be zer=
o */
> +               unsigned long   fgt:TC_FGT_BITS; /* Fine Grained Trap id =
*/
> +               unsigned long   bit:6;           /* Bit number */
> +               unsigned long   pol:1;           /* Polarity */
> +               unsigned long   unused:42;       /* Unused, should be zer=
o */
>                 unsigned long   mbz:1;           /* Must Be Zero */
>         };
>  };
> @@ -929,6 +936,28 @@ static const struct encoding_to_trap_config encoding=
_to_cgt[] __initconst =3D {
>
>  static DEFINE_XARRAY(sr_forward_xa);
>
> +enum fgt_group_id {
> +       __NO_FGT_GROUP__,
> +
> +       /* Must be last */
> +       __NR_FGT_GROUP_IDS__
> +};
> +
> +#define SR_FGT(sr, g, b, p)                                    \
> +       {                                                       \
> +               .encoding       =3D sr,                           \
> +               .end            =3D sr,                           \
> +               .tc             =3D {                             \
> +                       .fgt =3D g ## _GROUP,                     \
> +                       .bit =3D g ## _EL2_ ## b ## _SHIFT,       \
> +                       .pol =3D p,                               \
> +               },                                              \
> +               .line =3D __LINE__,                               \
> +       }
> +
> +static const struct encoding_to_trap_config encoding_to_fgt[] __initcons=
t =3D {
> +};
> +
>  static union trap_config get_trap_config(u32 sysreg)
>  {
>         return (union trap_config) {
> @@ -957,6 +986,7 @@ int __init populate_nv_trap_config(void)
>
>         BUILD_BUG_ON(sizeof(union trap_config) !=3D sizeof(void *));
>         BUILD_BUG_ON(__NR_CGT_GROUP_IDS__ > BIT(TC_CGT_BITS));
> +       BUILD_BUG_ON(__NR_FGT_GROUP_IDS__ > BIT(TC_FGT_BITS));
>
>         for (int i =3D 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
>                 const struct encoding_to_trap_config *cgt =3D &encoding_t=
o_cgt[i];
> @@ -990,6 +1020,34 @@ int __init populate_nv_trap_config(void)
>         kvm_info("nv: %ld coarse grained trap handlers\n",
>                  ARRAY_SIZE(encoding_to_cgt));
>
> +       if (!cpus_have_final_cap(ARM64_HAS_FGT))
> +               goto check_mcb;
> +
> +       for (int i =3D 0; i < ARRAY_SIZE(encoding_to_fgt); i++) {
> +               const struct encoding_to_trap_config *fgt =3D &encoding_t=
o_fgt[i];
> +               union trap_config tc;
> +
> +               if (fgt->tc.fgt >=3D __NR_FGT_GROUP_IDS__) {
> +                       ret =3D -EINVAL;
> +                       print_nv_trap_error(fgt, "Invalid FGT", ret);
> +               }
> +
> +               tc =3D get_trap_config(fgt->encoding);
> +
> +               if (tc.fgt) {
> +                       ret =3D -EINVAL;
> +                       print_nv_trap_error(fgt, "Duplicate FGT", ret);
> +               }
> +
> +               tc.val |=3D fgt->tc.val;
> +               xa_store(&sr_forward_xa, fgt->encoding,
> +                        xa_mk_value(tc.val), GFP_KERNEL);
> +       }
> +
> +       kvm_info("nv: %ld fine grained trap handlers\n",
> +                ARRAY_SIZE(encoding_to_fgt));
> +
> +check_mcb:
>         for (int id =3D __MULTIPLE_CONTROL_BITS__; id < __COMPLEX_CONDITI=
ONS__; id++) {
>                 const enum cgt_group_id *cgids;
>
> @@ -1056,13 +1114,26 @@ static enum trap_behaviour compute_trap_behaviour=
(struct kvm_vcpu *vcpu,
>         return __compute_trap_behaviour(vcpu, tc.cgt, b);
>  }
>
> +static bool check_fgt_bit(u64 val, const union trap_config tc)
> +{
> +       return ((val >> tc.bit) & 1) =3D=3D tc.pol;
> +}
> +
> +#define sanitised_sys_reg(vcpu, reg)                   \
> +       ({                                              \
> +               u64 __val;                              \
> +               __val =3D __vcpu_sys_reg(vcpu, reg);      \
> +               __val &=3D ~__ ## reg ## _RES0;           \
> +               (__val);                                \
> +       })
> +
>  bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>  {
>         union trap_config tc;
>         enum trap_behaviour b;
>         bool is_read;
>         u32 sysreg;
> -       u64 esr;
> +       u64 esr, val;
>
>         if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
>                 return false;
> @@ -1085,6 +1156,19 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>         if (!tc.val)
>                 return false;
>
> +       switch ((enum fgt_group_id)tc.fgt) {
> +       case __NO_FGT_GROUP__:
> +               break;
> +
> +       case __NR_FGT_GROUP_IDS__:
> +               /* Something is really wrong, bail out */
> +               WARN_ONCE(1, "__NR_FGT_GROUP_IDS__");
> +               return false;
> +       }
> +
> +       if (tc.fgt !=3D __NO_FGT_GROUP__ && check_fgt_bit(val, tc))
> +               goto inject;
> +
>         b =3D compute_trap_behaviour(vcpu, tc);
>
>         if (((b & BEHAVE_FORWARD_READ) && is_read) ||
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
