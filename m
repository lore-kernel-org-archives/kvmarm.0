Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55689EB8
	for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 03:46:49 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id 61-20020a9d02c3000000b0069fe8de3139so7576859otl.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 20:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680061608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1sIf0i/Neawt2EB8FgOhwzX6csvSgR2t7hSQT1je9M=;
        b=LjxV4Lzq9n1tJI2W8j+n+93+f3EV0305wGqqXv/Cs7wsqwr8M1zIygO4wIlgRJLzow
         jlNNHPuxSvdvWRc1SaJhUAZEylqddWfXqhM9eTpRBtbqfCgqD2lH0y59PJ7WEDy1UoXW
         WKWuH3+lLCaoPH69XygssnD/7Wc77lohOWRoBrvdBgxYzMSY252FmSEOin3LwxoXbi9n
         wZzZeY5qJzzS2XhdrZNypu7tvlwRlRZS3UpXXSjXc4XU58FaEcSl0ryDiz18LHe1dSyh
         5Yd30i0OYvkSTFIAu996caUOwt5fRs0AyMBJITKHITHx56qRMWknxYBeuoKRuXWAhOyB
         rTLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680061608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1sIf0i/Neawt2EB8FgOhwzX6csvSgR2t7hSQT1je9M=;
        b=7GCuhe4GKxRgT6Av5yu6eLxuxK4KV2WOxoVvkF1Cj9RWddBYDk8M9kjT2/eITjowGx
         xJhFqFmsVrs6TwhJsI0XG6d4JsXOWK8TN1vWIxwFUWPY+61I4h1WVwZHSrqvbfS66+2C
         W3HcTx11Qcx3vUz3q84yXbZ5HOj17jk2gnfFOW/IaqfbA3ofwA+InOFpiH2X1hjVtcCl
         HZXhnJX3xSf+X/64Puz6pZi/cDwd6W28bC3MFGznBZs+55nxzZ3lwH4JHUmArWtyRKiz
         Fiaphn8ah4EHNM5AWX7sX94x+ZJNPz0o4OYzD4caQH4chyiKante9+LQX449mae+N4jl
         Nh4Q==
X-Gm-Message-State: AAQBX9dKU8rN8yyacZ8CQnOMGVvPFgmrDujAaxy33kJFVCqMfUPw66yA
	QZvIn1h/Erq7xwUBbFVz860o5JnCPPLMKaVWucuKnA==
X-Google-Smtp-Source: AKy350Z+Z174k3BgpisXdXS3+pquENehgIrKytpPI3JjEt1lRpSgrg4ULoA1p25iuKlNomo+baqVb2XLgdBlvKi94aU=
X-Received: by 2002:a05:6830:1515:b0:6a1:342f:7ba4 with SMTP id
 k21-20020a056830151500b006a1342f7ba4mr3574534otp.0.1680061608110; Tue, 28 Mar
 2023 20:46:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com>
 <20230317050637.766317-6-jingzhangos@google.com> <86wn32whzo.wl-maz@kernel.org>
In-Reply-To: <86wn32whzo.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 28 Mar 2023 20:46:36 -0700
Message-ID: <CAAdAUtiy9bT=ccJQTcoU86WuL4R6d8krEKSuS=2Rh49sm=F4VQ@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] KVM: arm64: Introduce ID register specific descriptor
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Oliver Upton <oupton@google.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,
On Mon, Mar 27, 2023 at 4:28=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 17 Mar 2023 05:06:36 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Introduce an ID feature register specific descriptor to include ID
> > register specific fields and callbacks besides its corresponding
> > general system register descriptor.
> > New fields for ID register descriptor would be added later when it
> > is necessary to support a writable ID register.
>
> What would these be? Could they make sense for "normal" sysregs as
> well?
As you know from the later patch, some fields are added only
applicable to idregs.
As you suggested, some of those fields may not be necessary, I'll try
to improve the data idregs specific data structures based on your
comments or even don't use a new structure if it is possible.
>
> >
> > No functional change intended.
> >
> > Co-developed-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/id_regs.c  | 187 +++++++++++++++++++++++++++-----------
> >  arch/arm64/kvm/sys_regs.c |   2 +-
> >  arch/arm64/kvm/sys_regs.h |   1 +
> >  3 files changed, 138 insertions(+), 52 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > index 3a87a3d2390d..9956c99d20f7 100644
> > --- a/arch/arm64/kvm/id_regs.c
> > +++ b/arch/arm64/kvm/id_regs.c
> > @@ -18,6 +18,10 @@
> >
> >  #include "sys_regs.h"
> >
> > +struct id_reg_desc {
> > +     const struct sys_reg_desc       reg_desc;
> > +};
> > +
>
> What is the advantage in having this wrapping structure that forces us
> to reinvent the wheel (the structure is different) over an additional
> pointer or even a side table?
As stated in the last comment, I'll try to improve the data structure
or don't use it at all if possible.
>
> >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> >  {
> >       if (kvm_vcpu_has_pmu(vcpu))
> > @@ -334,21 +338,25 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >  }
> >
> >  /* sys_reg_desc initialiser for known cpufeature ID registers */
> > -#define ID_SANITISED(name) {                 \
> > -     SYS_DESC(SYS_##name),                   \
> > -     .access =3D access_id_reg,                \
> > -     .get_user =3D get_id_reg,                 \
> > -     .set_user =3D set_id_reg,                 \
> > -     .visibility =3D id_visibility,            \
> > +#define ID_SANITISED(name) {                         \
> > +     .reg_desc =3D {                                   \
> > +             SYS_DESC(SYS_##name),                   \
> > +             .access =3D access_id_reg,                \
> > +             .get_user =3D get_id_reg,                 \
> > +             .set_user =3D set_id_reg,                 \
> > +             .visibility =3D id_visibility,            \
> > +     },                                              \
> >  }
> >
> >  /* sys_reg_desc initialiser for known cpufeature ID registers */
> > -#define AA32_ID_SANITISED(name) {            \
> > -     SYS_DESC(SYS_##name),                   \
> > -     .access =3D access_id_reg,                \
> > -     .get_user =3D get_id_reg,                 \
> > -     .set_user =3D set_id_reg,                 \
> > -     .visibility =3D aa32_id_visibility,       \
> > +#define AA32_ID_SANITISED(name) {                    \
> > +     .reg_desc =3D {                                   \
> > +             SYS_DESC(SYS_##name),                   \
> > +             .access =3D access_id_reg,                \
> > +             .get_user =3D get_id_reg,                 \
> > +             .set_user =3D set_id_reg,                 \
> > +             .visibility =3D aa32_id_visibility,       \
> > +     },                                              \
> >  }
> >
> >  /*
> > @@ -356,12 +364,14 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >   * register with encoding Op0=3D3, Op1=3D0, CRn=3D0, CRm=3Dcrm, Op2=3D=
op2
> >   * (1 <=3D crm < 8, 0 <=3D Op2 < 8).
> >   */
> > -#define ID_UNALLOCATED(crm, op2) {                   \
> > -     Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),     \
> > -     .access =3D access_id_reg,                        \
> > -     .get_user =3D get_id_reg,                         \
> > -     .set_user =3D set_id_reg,                         \
> > -     .visibility =3D raz_visibility                    \
> > +#define ID_UNALLOCATED(crm, op2) {                           \
> > +     .reg_desc =3D {                                           \
> > +             Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),     \
> > +             .access =3D access_id_reg,                        \
> > +             .get_user =3D get_id_reg,                         \
> > +             .set_user =3D set_id_reg,                         \
> > +             .visibility =3D raz_visibility                    \
> > +     },                                                      \
> >  }
> >
> >  /*
> > @@ -369,15 +379,17 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >   * For now, these are exposed just like unallocated ID regs: they appe=
ar
> >   * RAZ for the guest.
> >   */
> > -#define ID_HIDDEN(name) {                    \
> > -     SYS_DESC(SYS_##name),                   \
> > -     .access =3D access_id_reg,                \
> > -     .get_user =3D get_id_reg,                 \
> > -     .set_user =3D set_id_reg,                 \
> > -     .visibility =3D raz_visibility,           \
> > +#define ID_HIDDEN(name) {                            \
> > +     .reg_desc =3D {                                   \
> > +             SYS_DESC(SYS_##name),                   \
> > +             .access =3D access_id_reg,                \
> > +             .get_user =3D get_id_reg,                 \
> > +             .set_user =3D set_id_reg,                 \
> > +             .visibility =3D raz_visibility,           \
> > +     },                                              \
> >  }
> >
> > -static const struct sys_reg_desc id_reg_descs[] =3D {
> > +static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] =3D {
> >       /*
> >        * ID regs: all ID_SANITISED() entries here must have correspondi=
ng
> >        * entries in arm64_ftr_regs[].
> > @@ -387,9 +399,13 @@ static const struct sys_reg_desc id_reg_descs[] =
=3D {
> >       /* CRm=3D1 */
> >       AA32_ID_SANITISED(ID_PFR0_EL1),
> >       AA32_ID_SANITISED(ID_PFR1_EL1),
> > -     { SYS_DESC(SYS_ID_DFR0_EL1), .access =3D access_id_reg,
> > -       .get_user =3D get_id_reg, .set_user =3D set_id_dfr0_el1,
> > -       .visibility =3D aa32_id_visibility, },
> > +     { .reg_desc =3D {
> > +             SYS_DESC(SYS_ID_DFR0_EL1),
> > +             .access =3D access_id_reg,
> > +             .get_user =3D get_id_reg,
> > +             .set_user =3D set_id_dfr0_el1,
> > +             .visibility =3D aa32_id_visibility, },
> > +     },
> >       ID_HIDDEN(ID_AFR0_EL1),
> >       AA32_ID_SANITISED(ID_MMFR0_EL1),
> >       AA32_ID_SANITISED(ID_MMFR1_EL1),
> > @@ -418,8 +434,12 @@ static const struct sys_reg_desc id_reg_descs[] =
=3D {
> >
> >       /* AArch64 ID registers */
> >       /* CRm=3D4 */
> > -     { SYS_DESC(SYS_ID_AA64PFR0_EL1), .access =3D access_id_reg,
> > -       .get_user =3D get_id_reg, .set_user =3D set_id_aa64pfr0_el1, },
> > +     { .reg_desc =3D {
> > +             SYS_DESC(SYS_ID_AA64PFR0_EL1),
> > +             .access =3D access_id_reg,
> > +             .get_user =3D get_id_reg,
> > +             .set_user =3D set_id_aa64pfr0_el1, },
> > +     },
> >       ID_SANITISED(ID_AA64PFR1_EL1),
> >       ID_UNALLOCATED(4, 2),
> >       ID_UNALLOCATED(4, 3),
> > @@ -429,8 +449,12 @@ static const struct sys_reg_desc id_reg_descs[] =
=3D {
> >       ID_UNALLOCATED(4, 7),
> >
> >       /* CRm=3D5 */
> > -     { SYS_DESC(SYS_ID_AA64DFR0_EL1), .access =3D access_id_reg,
> > -       .get_user =3D get_id_reg, .set_user =3D set_id_aa64dfr0_el1, },
> > +     { .reg_desc =3D {
> > +             SYS_DESC(SYS_ID_AA64DFR0_EL1),
> > +             .access =3D access_id_reg,
> > +             .get_user =3D get_id_reg,
> > +             .set_user =3D set_id_aa64dfr0_el1, },
> > +     },
> >       ID_SANITISED(ID_AA64DFR1_EL1),
> >       ID_UNALLOCATED(5, 2),
> >       ID_UNALLOCATED(5, 3),
> > @@ -469,12 +493,12 @@ static const struct sys_reg_desc id_reg_descs[] =
=3D {
> >   */
> >  int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *param=
s)
> >  {
> > -     const struct sys_reg_desc *r;
> > +     u32 id;
> >
> > -     r =3D find_reg(params, id_reg_descs, ARRAY_SIZE(id_reg_descs));
> > +     id =3D reg_to_encoding(params);
> >
> > -     if (likely(r)) {
> > -             perform_access(vcpu, params, r);
> > +     if (likely(is_id_reg(id))) {
> > +             perform_access(vcpu, params, &id_reg_descs[IDREG_IDX(id)]=
.reg_desc);
>
> How about minimising the diff and making the whole thing less verbose?
>
> static const struct sys_reg_desc *id_to_id_reg_desc(struct sys_reg_params=
 *params)
> {
>         u32 id;
>
>         id =3D reg_to_encoding(params);
>         if (is_id_reg(id))
>                 return &id_reg_descs[IDREG_IDX(id)].reg_desc;
>
>         return NULL;
> }
>
> int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params)
> {
>         const struct sys_reg_desc *r;
>
>         r =3D id_to_id_reg_desc(params);
>         [...]
> }
>
> And use the helper everywhere?
Sure, will do.
>
> >       } else {
> >               print_sys_reg_msg(params,
> >                                 "Unsupported guest id_reg access at: %l=
x [%08lx]\n",
> > @@ -491,38 +515,102 @@ void kvm_arm_reset_id_regs(struct kvm_vcpu *vcpu=
)
> >       unsigned long i;
> >
> >       for (i =3D 0; i < ARRAY_SIZE(id_reg_descs); i++)
> > -             if (id_reg_descs[i].reset)
> > -                     id_reg_descs[i].reset(vcpu, &id_reg_descs[i]);
> > +             if (id_reg_descs[i].reg_desc.reset)
> > +                     id_reg_descs[i].reg_desc.reset(vcpu, &id_reg_desc=
s[i].reg_desc);
> >  }
> >
> >  int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg=
 *reg)
> >  {
> > -     return kvm_sys_reg_get_user(vcpu, reg,
> > -                                 id_reg_descs, ARRAY_SIZE(id_reg_descs=
));
> > +     u64 __user *uaddr =3D (u64 __user *)(unsigned long)reg->addr;
> > +     const struct sys_reg_desc *r;
> > +     struct sys_reg_params params;
> > +     u64 val;
> > +     int ret;
> > +     u32 id;
> > +
> > +     if (!index_to_params(reg->id, &params))
> > +             return -ENOENT;
> > +     id =3D reg_to_encoding(&params);
> > +
> > +     if (!is_id_reg(id))
> > +             return -ENOENT;
> > +
> > +     r =3D &id_reg_descs[IDREG_IDX(id)].reg_desc;
> > +     if (r->get_user) {
> > +             ret =3D (r->get_user)(vcpu, r, &val);
> > +     } else {
> > +             ret =3D 0;
> > +             val =3D vcpu->kvm->arch.id_regs[IDREG_IDX(id)];
> > +     }
> > +
> > +     if (!ret)
> > +             ret =3D put_user(val, uaddr);
>
> How about the visibility? Why isn't it checked?
The visibility check is done in get_user()->get_id_reg()->read_id_reg().
>
> > +
> > +     return ret;
> >  }
> >
> >  int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg=
 *reg)
> >  {
> > -     return kvm_sys_reg_set_user(vcpu, reg,
> > -                                 id_reg_descs, ARRAY_SIZE(id_reg_descs=
));
> > +     u64 __user *uaddr =3D (u64 __user *)(unsigned long)reg->addr;
> > +     const struct sys_reg_desc *r;
> > +     struct sys_reg_params params;
> > +     u64 val;
> > +     int ret;
> > +     u32 id;
> > +
> > +     if (!index_to_params(reg->id, &params))
> > +             return -ENOENT;
> > +     id =3D reg_to_encoding(&params);
> > +
> > +     if (!is_id_reg(id))
> > +             return -ENOENT;
> > +
> > +     if (get_user(val, uaddr))
> > +             return -EFAULT;
> > +
> > +     r =3D &id_reg_descs[IDREG_IDX(id)].reg_desc;
> > +
> > +     if (sysreg_user_write_ignore(vcpu, r))
> > +             return 0;
> > +
> > +     if (r->set_user) {
> > +             ret =3D (r->set_user)(vcpu, r, val);
> > +     } else {
> > +             WARN_ONCE(1, "ID register set_user callback is NULL\n");
>
> Why the shouting? We didn't do that before. What's changed?
It was added according to one of Reiji's comments from
https://lore.kernel.org/all/CAAeT=3DFz-G_EUmh=3DPj3UHA7pnKKYi7UyYuedziJxfmS=
oKpntw3Q@mail.gmail.com.
WDYT?
>
> > +             ret =3D 0;
> > +     }
> > +
> > +     return ret;
> >  }
> >
> >  bool kvm_arm_check_idreg_table(void)
> >  {
> > -     return check_sysreg_table(id_reg_descs, ARRAY_SIZE(id_reg_descs),=
 false);
> > +     unsigned int i;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> > +             const struct sys_reg_desc *r =3D &id_reg_descs[i].reg_des=
c;
> > +
> > +             if (!is_id_reg(reg_to_encoding(r))) {
> > +                     kvm_err("id_reg table %pS entry %d not set correc=
tly\n",
> > +                             &id_reg_descs[i].reg_desc, i);
> > +                     return false;
> > +             }
> > +     }
> > +
> > +     return true;
> >  }
> >
> >  int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
> >  {
> > -     const struct sys_reg_desc *i2, *end2;
> > +     const struct id_reg_desc *i2, *end2;
> >       unsigned int total =3D 0;
> >       int err;
> >
> >       i2 =3D id_reg_descs;
> >       end2 =3D id_reg_descs + ARRAY_SIZE(id_reg_descs);
> >
> > -     while (i2 !=3D end2) {
> > -             err =3D walk_one_sys_reg(vcpu, i2++, &uind, &total);
> > +     for (; i2 !=3D end2; i2++) {
> > +             err =3D walk_one_sys_reg(vcpu, &(i2->reg_desc), &uind, &t=
otal);
> >               if (err)
> >                       return err;
> >       }
> > @@ -540,12 +628,9 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
> >       u64 val;
> >
> >       for (i =3D 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> > -             id =3D reg_to_encoding(&id_reg_descs[i]);
> > -             if (WARN_ON_ONCE(!is_id_reg(id)))
> > -                     /* Shouldn't happen */
> > -                     continue;
> > +             id =3D reg_to_encoding(&id_reg_descs[i].reg_desc);
>
> Why have you dropped that check? If it shouldn't happen before, it
> still shouldn't happen.
Since the check was done in kvm_arm_check_idreg_table() now.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
