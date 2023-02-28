Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59207636
	for <kvmarm@lists.linux.dev>; Tue, 28 Feb 2023 01:52:13 +0000 (UTC)
Received: by mail-oi1-f181.google.com with SMTP id bh20so6823349oib.9
        for <kvmarm@lists.linux.dev>; Mon, 27 Feb 2023 17:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehjl1nRh2q4wbKSDkdNsFcokdeHtTYZvDcHFL4Jqp2A=;
        b=K0qMs9mlNoeX9b6ActYFi8SOh/WXALLypb7SWzXmfj45Jz6liYlHkzHjYarJMQ08I6
         BHIIppZlbf1CDM2SAy6XGD32N3ZEwFIl4IYNIbY7K0HvomkCDwBgBs277G3sLIuD5BGD
         eZqdi2xWadgMDITn8xzqJ/QJ2LOQQXemAwmCS7sfpGR2g7VnHxZDA4G347vKLDV2w0ej
         nZplLaygHYbIZORrk0LKeAJqMVkWzA8L7KXdOGXWocSpZy+Je+KrQEVdXWRFz9ELA+Zz
         202jgISbeEkqWPF1iMc5dmND93T95NmgVkO3RRDKu3WkiDPY1YQl8ClupRob4j5C+fHt
         TNpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ehjl1nRh2q4wbKSDkdNsFcokdeHtTYZvDcHFL4Jqp2A=;
        b=TzoWDhUDhXtyMd/VSpCLfec7iHV4QWq+TBFyb+K/7LTP7ldGqm/SY5qQ1p6T1FsMS2
         MCYDFbf8BjJsrfaM6Y3ZZMloHonUS5l8j4lXoMNcjkusolGVtLX3V5TQV65X4rfC6jmL
         +6TC42IB8yCY1NpGWa2JGjifzPKNWGdUsW6tPzd+YUKYhdUfNo1kWOOaPbFq2JYCdm9y
         eLCl8tNrEUvN/N6c8GiY/LteBtkA4MPhO0/KTSBrjXn+giUrviYfs/IvqYtkWCsh523+
         CFCp2tlDlDnd23avSOBwrt6mC5BsuMvOsUGlpGbtvjqE2fiKh1YZgaeU3KrXjMSJlYBA
         E4uA==
X-Gm-Message-State: AO0yUKVwL1M5oOkuH8q0ozzyyjdteBTC5xhYvrywLgEA9hdLDW255mF6
	SeDm/pNK7TldNq9wrSwqmT271F639J03K7GLVXxNWQ==
X-Google-Smtp-Source: AK7set/56oCpkZsKMq7TREogSe5Lp+IqE7zxEBcIpvRkabgp8jigtKNC8hJBBt4Lrsa1Tg5UXyD/Ca6l51sPqUYgGCY=
X-Received: by 2002:a05:6808:5c3:b0:384:a13:952a with SMTP id
 d3-20020a05680805c300b003840a13952amr408783oij.11.1677549132056; Mon, 27 Feb
 2023 17:52:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230212215830.2975485-1-jingzhangos@google.com>
 <20230212215830.2975485-6-jingzhangos@google.com> <CAAeT=Fz-G_EUmh=Pj3UHA7pnKKYi7UyYuedziJxfmSoKpntw3Q@mail.gmail.com>
 <CAAdAUtgZ7WF--jz13bydY8PLeF6OqW+cNgeLZOUNB=wquMh6iw@mail.gmail.com> <CAAeT=FyF9gx=M_+towV2SnwuNroM9FktVCRUuaBphLpM20netQ@mail.gmail.com>
In-Reply-To: <CAAeT=FyF9gx=M_+towV2SnwuNroM9FktVCRUuaBphLpM20netQ@mail.gmail.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 27 Feb 2023 17:52:00 -0800
Message-ID: <CAAdAUtisEbKNeRT-vm8LKCxsdQBNnjUXkRdcdBzK6sf+Bh=JxA@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] KVM: arm64: Introduce ID register specific descriptor
To: Reiji Watanabe <reijiw@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Reiji,

On Mon, Feb 27, 2023 at 2:24 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Jing,
>
> On Sun, Feb 26, 2023 at 7:05=E2=80=AFPM Jing Zhang <jingzhangos@google.co=
m> wrote:
> >
> > Hi Reiji,
> >
> > On Fri, Feb 24, 2023 at 8:00 PM Reiji Watanabe <reijiw@google.com> wrot=
e:
> > >
> > > Hi Jing,
> > >
> > > On Sun, Feb 12, 2023 at 1:58 PM Jing Zhang <jingzhangos@google.com> w=
rote:
> > > >
> > > > Introduce an ID feature register specific descriptor to include ID
> > > > register specific fields and callbacks besides its corresponding
> > > > general system register descriptor.
> > > > New fields for ID register descriptor would be added later when it
> > > > is necessary to support a writable ID register.
> > > >
> > > > No functional change intended.
> > > >
> > > > Co-developed-by: Reiji Watanabe <reijiw@google.com>
> > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > > ---
> > > >  arch/arm64/kvm/id_regs.c  | 187 +++++++++++++++++++++++++++++-----=
----
> > > >  arch/arm64/kvm/sys_regs.c |   2 +-
> > > >  arch/arm64/kvm/sys_regs.h |   1 +
> > > >  3 files changed, 144 insertions(+), 46 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > > > index 14ae03a1d8d0..15d0338742b6 100644
> > > > --- a/arch/arm64/kvm/id_regs.c
> > > > +++ b/arch/arm64/kvm/id_regs.c
> > > > @@ -18,6 +18,10 @@
> > > >
> > > >  #include "sys_regs.h"
> > > >
> > > > +struct id_reg_desc {
> > > > +       const struct sys_reg_desc       reg_desc;
> > > > +};
> > > > +
> > > >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> > > >  {
> > > >         if (kvm_vcpu_has_pmu(vcpu))
> > > > @@ -329,21 +333,25 @@ static int set_id_dfr0_el1(struct kvm_vcpu *v=
cpu,
> > > >  }
> > > >
> > > >  /* sys_reg_desc initialiser for known cpufeature ID registers */
> > > > -#define ID_SANITISED(name) {                   \
> > > > -       SYS_DESC(SYS_##name),                   \
> > > > -       .access =3D access_id_reg,                \
> > > > -       .get_user =3D get_id_reg,                 \
> > > > -       .set_user =3D set_id_reg,                 \
> > > > -       .visibility =3D id_visibility,            \
> > > > +#define ID_SANITISED(name) {                           \
> > > > +       .reg_desc =3D {                                   \
> > > > +               SYS_DESC(SYS_##name),                   \
> > > > +               .access =3D access_id_reg,                \
> > > > +               .get_user =3D get_id_reg,                 \
> > > > +               .set_user =3D set_id_reg,                 \
> > > > +               .visibility =3D id_visibility,            \
> > > > +       },                                              \
> > > >  }
> > > >
> > > >  /* sys_reg_desc initialiser for known cpufeature ID registers */
> > > > -#define AA32_ID_SANITISED(name) {              \
> > > > -       SYS_DESC(SYS_##name),                   \
> > > > -       .access =3D access_id_reg,                \
> > > > -       .get_user =3D get_id_reg,                 \
> > > > -       .set_user =3D set_id_reg,                 \
> > > > -       .visibility =3D aa32_id_visibility,       \
> > > > +#define AA32_ID_SANITISED(name) {                      \
> > > > +       .reg_desc =3D {                                   \
> > > > +               SYS_DESC(SYS_##name),                   \
> > > > +               .access =3D access_id_reg,                \
> > > > +               .get_user =3D get_id_reg,                 \
> > > > +               .set_user =3D set_id_reg,                 \
> > > > +               .visibility =3D aa32_id_visibility,       \
> > > > +       },                                              \
> > > >  }
> > > >
> > > >  /*
> > > > @@ -351,12 +359,14 @@ static int set_id_dfr0_el1(struct kvm_vcpu *v=
cpu,
> > > >   * register with encoding Op0=3D3, Op1=3D0, CRn=3D0, CRm=3Dcrm, Op=
2=3Dop2
> > > >   * (1 <=3D crm < 8, 0 <=3D Op2 < 8).
> > > >   */
> > > > -#define ID_UNALLOCATED(crm, op2) {                     \
> > > > -       Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),     \
> > > > -       .access =3D access_id_reg,                        \
> > > > -       .get_user =3D get_id_reg,                         \
> > > > -       .set_user =3D set_id_reg,                         \
> > > > -       .visibility =3D raz_visibility                    \
> > > > +#define ID_UNALLOCATED(crm, op2) {                             \
> > > > +       .reg_desc =3D {                                           \
> > > > +               Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),     \
> > > > +               .access =3D access_id_reg,                        \
> > > > +               .get_user =3D get_id_reg,                         \
> > > > +               .set_user =3D set_id_reg,                         \
> > > > +               .visibility =3D raz_visibility                    \
> > > > +       },                                                      \
> > > >  }
> > > >
> > > >  /*
> > > > @@ -364,15 +374,17 @@ static int set_id_dfr0_el1(struct kvm_vcpu *v=
cpu,
> > > >   * For now, these are exposed just like unallocated ID regs: they =
appear
> > > >   * RAZ for the guest.
> > > >   */
> > > > -#define ID_HIDDEN(name) {                      \
> > > > -       SYS_DESC(SYS_##name),                   \
> > > > -       .access =3D access_id_reg,                \
> > > > -       .get_user =3D get_id_reg,                 \
> > > > -       .set_user =3D set_id_reg,                 \
> > > > -       .visibility =3D raz_visibility,           \
> > > > +#define ID_HIDDEN(name) {                              \
> > > > +       .reg_desc =3D {                                   \
> > > > +               SYS_DESC(SYS_##name),                   \
> > > > +               .access =3D access_id_reg,                \
> > > > +               .get_user =3D get_id_reg,                 \
> > > > +               .set_user =3D set_id_reg,                 \
> > > > +               .visibility =3D raz_visibility,           \
> > > > +       },                                              \
> > > >  }
> > > >
> > > > -static const struct sys_reg_desc id_reg_descs[] =3D {
> > > > +static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] =
=3D {
> > > >         /*
> > > >          * ID regs: all ID_SANITISED() entries here must have corre=
sponding
> > > >          * entries in arm64_ftr_regs[].
> > > > @@ -382,9 +394,13 @@ static const struct sys_reg_desc id_reg_descs[=
] =3D {
> > > >         /* CRm=3D1 */
> > > >         AA32_ID_SANITISED(ID_PFR0_EL1),
> > > >         AA32_ID_SANITISED(ID_PFR1_EL1),
> > > > -       { SYS_DESC(SYS_ID_DFR0_EL1), .access =3D access_id_reg,
> > > > -         .get_user =3D get_id_reg, .set_user =3D set_id_dfr0_el1,
> > > > -         .visibility =3D aa32_id_visibility, },
> > > > +       { .reg_desc =3D {
> > > > +               SYS_DESC(SYS_ID_DFR0_EL1),
> > > > +               .access =3D access_id_reg,
> > > > +               .get_user =3D get_id_reg,
> > > > +               .set_user =3D set_id_dfr0_el1,
> > > > +               .visibility =3D aa32_id_visibility, },
> > > > +       },
> > > >         ID_HIDDEN(ID_AFR0_EL1),
> > > >         AA32_ID_SANITISED(ID_MMFR0_EL1),
> > > >         AA32_ID_SANITISED(ID_MMFR1_EL1),
> > > > @@ -413,8 +429,12 @@ static const struct sys_reg_desc id_reg_descs[=
] =3D {
> > > >
> > > >         /* AArch64 ID registers */
> > > >         /* CRm=3D4 */
> > > > -       { SYS_DESC(SYS_ID_AA64PFR0_EL1), .access =3D access_id_reg,
> > > > -         .get_user =3D get_id_reg, .set_user =3D set_id_aa64pfr0_e=
l1, },
> > > > +       { .reg_desc =3D {
> > > > +               SYS_DESC(SYS_ID_AA64PFR0_EL1),
> > > > +               .access =3D access_id_reg,
> > > > +               .get_user =3D get_id_reg,
> > > > +               .set_user =3D set_id_aa64pfr0_el1, },
> > > > +       },
> > > >         ID_SANITISED(ID_AA64PFR1_EL1),
> > > >         ID_UNALLOCATED(4, 2),
> > > >         ID_UNALLOCATED(4, 3),
> > > > @@ -424,8 +444,12 @@ static const struct sys_reg_desc id_reg_descs[=
] =3D {
> > > >         ID_UNALLOCATED(4, 7),
> > > >
> > > >         /* CRm=3D5 */
> > > > -       { SYS_DESC(SYS_ID_AA64DFR0_EL1), .access =3D access_id_reg,
> > > > -         .get_user =3D get_id_reg, .set_user =3D set_id_aa64dfr0_e=
l1, },
> > > > +       { .reg_desc =3D {
> > > > +               SYS_DESC(SYS_ID_AA64DFR0_EL1),
> > > > +               .access =3D access_id_reg,
> > > > +               .get_user =3D get_id_reg,
> > > > +               .set_user =3D set_id_aa64dfr0_el1, },
> > > > +       },
> > > >         ID_SANITISED(ID_AA64DFR1_EL1),
> > > >         ID_UNALLOCATED(5, 2),
> > > >         ID_UNALLOCATED(5, 3),
> > > > @@ -457,7 +481,13 @@ static const struct sys_reg_desc id_reg_descs[=
] =3D {
> > > >
> > > >  const struct sys_reg_desc *kvm_arm_find_id_reg(const struct sys_re=
g_params *params)
> > > >  {
> > > > -       return find_reg(params, id_reg_descs, ARRAY_SIZE(id_reg_des=
cs));
> > > > +       u32 id;
> > > > +
> > > > +       id =3D reg_to_encoding(params);
> > > > +       if (!is_id_reg(id))
> > > > +               return NULL;
> > > > +
> > > > +       return &id_reg_descs[IDREG_IDX(id)].reg_desc;
> > > >  }
> > > >
> > > >  void kvm_arm_reset_id_regs(struct kvm_vcpu *vcpu)
> > > > @@ -465,39 +495,106 @@ void kvm_arm_reset_id_regs(struct kvm_vcpu *=
vcpu)
> > > >         unsigned long i;
> > > >
> > > >         for (i =3D 0; i < ARRAY_SIZE(id_reg_descs); i++)
> > > > -               if (id_reg_descs[i].reset)
> > > > -                       id_reg_descs[i].reset(vcpu, &id_reg_descs[i=
]);
> > > > +               if (id_reg_descs[i].reg_desc.reset)
> > > > +                       id_reg_descs[i].reg_desc.reset(vcpu, &id_re=
g_descs[i].reg_desc);
> > > >  }
> > > >
> > > >  int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one=
_reg *reg)
> > > >  {
> > > > -       return kvm_sys_reg_get_user(vcpu, reg,
> > > > -                                   id_reg_descs, ARRAY_SIZE(id_reg=
_descs));
> > > > +       u64 __user *uaddr =3D (u64 __user *)(unsigned long)reg->add=
r;
> > > > +       const struct sys_reg_desc *r;
> > > > +       struct sys_reg_params params;
> > > > +       u64 val;
> > > > +       int ret;
> > > > +       u32 id;
> > > > +
> > > > +       if (!index_to_params(reg->id, &params))
> > > > +               return -ENOENT;
> > > > +       id =3D reg_to_encoding(&params);
> > > > +
> > > > +       if (!is_id_reg(id))
> > > > +               return -ENOENT;
> > > > +
> > > > +       r =3D &id_reg_descs[IDREG_IDX(id)].reg_desc;
> > > > +       if (r->get_user) {
> > > > +               ret =3D (r->get_user)(vcpu, r, &val);
> > > > +       } else {
> > > > +               ret =3D 0;
> > > > +               val =3D 0;
> > >
> > > When get_user is NULL, I wonder why you want to treat them RAZ.
> > > It can be achieved by using visibility(), which I think might be
> > > better to use before calling get_user.
> > > Another option would be simply reading from IDREG(), which I would
> > > guess might be useful(?) when no special handling is necessary.
> > >
> > Will simply use the value from IDREG().
> > >
> > > > +       }
> > > > +
> > > > +       if (!ret)
> > > > +               ret =3D put_user(val, uaddr);
> > > > +
> > > > +       return ret;
> > > >  }
> > > >
> > > >  int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one=
_reg *reg)
> > > >  {
> > > > -       return kvm_sys_reg_set_user(vcpu, reg,
> > > > -                                   id_reg_descs, ARRAY_SIZE(id_reg=
_descs));
> > > > +       u64 __user *uaddr =3D (u64 __user *)(unsigned long)reg->add=
r;
> > > > +       const struct sys_reg_desc *r;
> > > > +       struct sys_reg_params params;
> > > > +       u64 val;
> > > > +       int ret;
> > > > +       u32 id;
> > > > +
> > > > +       if (!index_to_params(reg->id, &params))
> > > > +               return -ENOENT;
> > > > +       id =3D reg_to_encoding(&params);
> > > > +
> > > > +       if (!is_id_reg(id))
> > > > +               return -ENOENT;
> > > > +
> > > > +       if (get_user(val, uaddr))
> > > > +               return -EFAULT;
> > > > +
> > > > +       r =3D &id_reg_descs[IDREG_IDX(id)].reg_desc;
> > > > +
> > > > +       if (sysreg_user_write_ignore(vcpu, r))
> > > > +               return 0;
> > > > +
> > > > +       if (r->set_user)
> > > > +               ret =3D (r->set_user)(vcpu, r, val);
> > > > +       else
> > > > +               ret =3D 0;
> > >
> > > This appears to be the same handling as WI.
> > > How do you plan to use this set_user =3D=3D NULL case ?
> > > I don't think this shouldn't happen with the current code.
> > > You might want to use WARN_ONCE here ?
> > Yes, you are right. It won't happen with current code. WIll use WARN_ON=
CE here.
> > >
> > > > +
> > > > +       return ret;
> > > >  }
> > > >
> > > >  bool kvm_arm_check_idreg_table(void)
> > > >  {
> > > > -       return check_sysreg_table(id_reg_descs, ARRAY_SIZE(id_reg_d=
escs), false);
> > > > +       unsigned int i;
> > > > +
> > > > +       for (i =3D 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> > > > +               const struct sys_reg_desc *r =3D &id_reg_descs[i].r=
eg_desc;
> > > > +
> > > > +               if (r->reg && !r->reset) {
> > >
> > > I don't think we need to check "!r->reset".
> > > If r->reg is not NULL, I believe the entry must be incorrect.
> > I am not sure I got your idea here? r->reg usually should not be NULL.
>
> In general (not for ID registers), the r->reg is used as an index of sys_=
reg[].
> In this patch, ID registers are not saved in sys_regs[], but in kvm_arch'=
s
> id_regs[].  So, I think the r->reg should be NULL for the ID registers.
> (In fact, it is NULL for all ID registers in the current patch, right ?)
>
> Or am I missing something ?
Got it. Thanks. Will remove the lines for checking reset callback.
> > >
> > > > +                       kvm_err("sys_reg table %pS entry %d lacks r=
eset\n", r, i);
> > > > +                       return false;
> > > > +               }
> > > > +
> > > > +               if (i && cmp_sys_reg(&id_reg_descs[i-1].reg_desc, r=
) >=3D 0) {
> > >
> > > In this table, each ID register needs to be in the proper place.
> > > So, I would think what should be checked would be if each entry
> > > in the table includes the right ID register.
> > > (e.g. id_reg_descs[0] must be for ID_PFR0_EL1, etc)
> > This comparison does the work, I think. It can detect any duplicate or
> > non-ID entry, unless all entries are wrong and in the order.
>
> Yes, I agree it does some work. There are some more cases that the
> checking can't detect though (e.g. if one ID register is missing
> from the table, I don't think the check can detect that).
> I would prefer to adjust the checking specifically for this table
> (i.e. Instead of checking the ordering, make sure that the entry
> is for an ID register, and it is located in the right position).
> What do you think ?
Agreed. Will improve the checking.
>
> Thank you,
> Reiji
