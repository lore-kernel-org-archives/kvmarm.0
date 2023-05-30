Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92A21EA76
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 18:02:16 +0000 (UTC)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-19f0e612589so3111824fac.2
        for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 11:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685469736; x=1688061736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tiu7rXuorWY5mH4mq6mIoOQzQGYuuOeKo6Re9nnsf7Q=;
        b=XJ9NM/fFnIxlipKw6jDzOppB8MFSfmACAQtysQamcmkfTKpmywkjyX7Oky85jyl9Aj
         UdfEUmeS9o0vdcj7RGbJsnfroHM4fyyh+HVMl8bnMc4+Fyrd/bI7XyfhBdcnydJzHL5Z
         ffpH2Vq1c5OItAG0JYOWvQjGV972JSIpR9svAcTNI7MYFAoKjYQLD+AXXHSeMxPUIXa/
         2MeZV0gqAeRvvQ/taLZpxWpqgQOJQIEo9PJ7xueT0IMAQoWj8RBa7Q/3+J8hF+/Aj/sc
         xp9eTQUS42GLb4l9wwm3SIe4GLl9o199x6VkmpAuh4QIMDUOkIVH97K3BzuoN+687aFy
         Vcdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685469736; x=1688061736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tiu7rXuorWY5mH4mq6mIoOQzQGYuuOeKo6Re9nnsf7Q=;
        b=N1UNS59q92oPhKcqrw8TMc7R22h1EMgyQHa/dAqFood0g9kHcxcpS/R/D9qkrCmvCf
         3jYp/p40J4NzgInnPxowKHxe6PdjiJ8arA0mt8RodUUuOktCzZnU24upjFjyziQtRxCp
         6D1tLObXJAN0CAXVF6WF0p1TafvGH+LLwCYa9LMncnbTlILaQvR/2Uwky1hP5B6sQ383
         Dc/Kh087POl3/I9RtQVRfLSP9VIWLbmRrLNoN0rmrZne+1zxHNFhokZhZ/dYv7WTfzbW
         LeIAdFpW8SRuKqgTNoD7nSxkyW1wDIjzPn35oy/00qgRDbGPwKinYMsS70gNjQlsZSc1
         zaFg==
X-Gm-Message-State: AC+VfDyFXJa1MMg7iTJAn84Kih9DIemvLqqgf8ctga2WlbROC2HqvO3J
	EbpmxLn/qC8AOBn1mW48wnNF2xfunp9v+1DNO4zG5A==
X-Google-Smtp-Source: ACHHUZ4ryK7Q9mzuGR8i63bJ6dvNAo3NCFuQcMDDXQKFPtK+Z2a/btOmjY0dmjYPAQ5RER/G3tuAMw0Y2sCd1mpHspE=
X-Received: by 2002:a05:6870:b1d2:b0:184:1c47:853d with SMTP id
 x18-20020a056870b1d200b001841c47853dmr1265878oak.35.1685469735738; Tue, 30
 May 2023 11:02:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230522221835.957419-1-jingzhangos@google.com>
 <20230522221835.957419-2-jingzhangos@google.com> <87ttvwok3d.wl-maz@kernel.org>
In-Reply-To: <87ttvwok3d.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 30 May 2023 11:02:03 -0700
Message-ID: <CAAdAUtinwccyd+URCLjowXq47_LP_SjLNEqm-F9GqycmTZrYuw@mail.gmail.com>
Subject: Re: [PATCH v10 1/5] KVM: arm64: Save ID registers' sanitized value
 per guest
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Oliver Upton <oupton@google.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 28, 2023 at 2:56=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Mon, 22 May 2023 23:18:31 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
> > and save ID registers' sanitized value in the array at KVM_CREATE_VM.
> > Use the saved ones when ID registers are read by the guest or
> > userspace (via KVM_GET_ONE_REG).
> >
> > No functional change intended.
> >
> > Co-developed-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 20 +++++++++
> >  arch/arm64/kvm/arm.c              |  1 +
> >  arch/arm64/kvm/sys_regs.c         | 69 +++++++++++++++++++++++++------
> >  arch/arm64/kvm/sys_regs.h         |  7 ++++
> >  4 files changed, 85 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index 7e7e19ef6993..069606170c82 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -178,6 +178,21 @@ struct kvm_smccc_features {
> >       unsigned long vendor_hyp_bmap;
> >  };
> >
> > +/*
> > + * Emulated CPU ID registers per VM
> > + * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
> > + * is (3, 0, 0, crm, op2), where 1<=3Dcrm<8, 0<=3Dop2<8.
> > + *
> > + * These emulated idregs are VM-wide, but accessed from the context of=
 a vCPU.
> > + * Atomic access to multiple idregs are guarded by kvm_arch.config_loc=
k.
> > + */
> > +#define IDREG_IDX(id)                (((sys_reg_CRm(id) - 1) << 3) | s=
ys_reg_Op2(id))
> > +#define IDREG(kvm, id)               ((kvm)->arch.idregs.regs[IDREG_ID=
X(id)])
> > +#define KVM_ARM_ID_REG_NUM   (IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
> > +struct kvm_idregs {
> > +     u64 regs[KVM_ARM_ID_REG_NUM];
> > +};
> > +
> >  typedef unsigned int pkvm_handle_t;
> >
> >  struct kvm_protected_vm {
> > @@ -253,6 +268,9 @@ struct kvm_arch {
> >       struct kvm_smccc_features smccc_feat;
> >       struct maple_tree smccc_filter;
> >
> > +     /* Emulated CPU ID registers */
> > +     struct kvm_idregs idregs;
> > +
> >       /*
> >        * For an untrusted host VM, 'pkvm.handle' is used to lookup
> >        * the associated pKVM instance in the hypervisor.
> > @@ -1045,6 +1063,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >  int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
> >                                   struct kvm_arm_counter_offset *offset=
);
> >
> > +void kvm_arm_init_id_regs(struct kvm *kvm);
> > +
> >  /* Guest/host FPSIMD coordination helpers */
> >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> >  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 14391826241c..774656a0718d 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -163,6 +163,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
> >
> >       set_default_spectre(kvm);
> >       kvm_arm_init_hypercalls(kvm);
> > +     kvm_arm_init_id_regs(kvm);
> >
> >       /*
> >        * Initialise the default PMUver before there is a chance to
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 71b12094d613..d2ee3a1c7f03 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -41,6 +41,7 @@
> >   * 64bit interface.
> >   */
> >
> > +static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
> >  static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
> >
> >  static bool read_from_write_only(struct kvm_vcpu *vcpu,
> > @@ -364,7 +365,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> >                         struct sys_reg_params *p,
> >                         const struct sys_reg_desc *r)
> >  {
> > -     u64 val =3D read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > +     u64 val =3D kvm_arm_read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
> >       u32 sr =3D reg_to_encoding(r);
> >
> >       if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
> > @@ -1208,16 +1209,9 @@ static u8 pmuver_to_perfmon(u8 pmuver)
> >       }
> >  }
> >
> > -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > -static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_des=
c const *r)
> > +static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>
> 'id' is misleading here. Is it an encoding? Or is it the index in the
> array? Reading the code, it is likely to be the former, but maybe
> calling the parameter 'encoding' would help.
Yes, it is an encoding. Will replace it with 'encoding".
>
> >  {
> > -     u32 id =3D reg_to_encoding(r);
> > -     u64 val;
> > -
> > -     if (sysreg_visible_as_raz(vcpu, r))
> > -             return 0;
> > -
> > -     val =3D read_sanitised_ftr_reg(id);
> > +     u64 val =3D IDREG(vcpu->kvm, id);
> >
> >       switch (id) {
> >       case SYS_ID_AA64PFR0_EL1:
> > @@ -1280,6 +1274,26 @@ static u64 read_id_reg(const struct kvm_vcpu *vc=
pu, struct sys_reg_desc const *r
> >       return val;
> >  }
> >
> > +/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > +static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_des=
c const *r)
> > +{
> > +     if (sysreg_visible_as_raz(vcpu, r))
> > +             return 0;
> > +
> > +     return kvm_arm_read_id_reg(vcpu, reg_to_encoding(r));
> > +}
> > +
> > +/*
> > + * Return true if the register's (Op0, Op1, CRn, CRm, Op2) is
> > + * (3, 0, 0, crm, op2), where 1<=3Dcrm<8, 0<=3Dop2<8.
> > + */
> > +static inline bool is_id_reg(u32 id)
> > +{
> > +     return (sys_reg_Op0(id) =3D=3D 3 && sys_reg_Op1(id) =3D=3D 0 &&
> > +             sys_reg_CRn(id) =3D=3D 0 && sys_reg_CRm(id) >=3D 1 &&
> > +             sys_reg_CRm(id) < 8);
> > +}
> > +
> >  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
> >                                 const struct sys_reg_desc *r)
> >  {
> > @@ -2244,8 +2258,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
> >       if (p->is_write) {
> >               return ignore_write(vcpu, p);
> >       } else {
> > -             u64 dfr =3D read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> > -             u64 pfr =3D read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> > +             u64 dfr =3D kvm_arm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1=
);
> > +             u64 pfr =3D kvm_arm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1=
);
> >               u32 el3 =3D !!cpuid_feature_extract_unsigned_field(pfr, I=
D_AA64PFR0_EL1_EL3_SHIFT);
> >
> >               p->regval =3D ((((dfr >> ID_AA64DFR0_EL1_WRPs_SHIFT) & 0x=
f) << 28) |
> > @@ -3343,6 +3357,37 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu=
 *vcpu, u64 __user *uindices)
> >       return write_demux_regids(uindices);
> >  }
> >
> > +/*
> > + * Set the guest's ID registers with ID_SANITISED() to the host's sani=
tized value.
> > + */
> > +void kvm_arm_init_id_regs(struct kvm *kvm)
> > +{
> > +     const struct sys_reg_desc *idreg;
> > +     struct sys_reg_params params;
> > +     u32 id;
> > +
> > +     /* Find the first idreg (SYS_ID_PFR0_EL1) in sys_reg_descs. */
> > +     id =3D SYS_ID_PFR0_EL1;
> > +     params =3D encoding_to_params(id);
> > +     idreg =3D find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_des=
cs));
> > +     if (WARN_ON(!idreg))
> > +             return;
>
> What is this trying to guard against? Not finding ID_PFR0_EL1 in the
> sysreg table? But this says nothing about the following registers (all
> 55 of them), so why do we need to special-case this one?
Here is to find the first idreg in the array and warn that no idregs
found in the array with the assumption that ID_PFR0_EL1 is the first
one defined and if it is not found, then no other idregs are defined
either.
Another way is to go through all the regs in array sys_reg_descs and
do the initialization if it is a idreg.
>
> > +
> > +     /* Initialize all idregs */
> > +     while (is_id_reg(id)) {
> > +             /*
> > +              * Some hidden ID registers which are not in arm64_ftr_re=
gs[]
> > +              * would cause warnings from read_sanitised_ftr_reg().
> > +              * Skip those ID registers to avoid the warnings.
> > +              */
> > +             if (idreg->visibility !=3D raz_visibility)
> > +                     IDREG(kvm, id) =3D read_sanitised_ftr_reg(id);
> > +
> > +             idreg++;
> > +             id =3D reg_to_encoding(idreg);
> > +     }
> > +}
> > +
> >  int __init kvm_sys_reg_table_init(void)
> >  {
> >       bool valid =3D true;
> > diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> > index 6b11f2cc7146..eba10de2e7ae 100644
> > --- a/arch/arm64/kvm/sys_regs.h
> > +++ b/arch/arm64/kvm/sys_regs.h
> > @@ -27,6 +27,13 @@ struct sys_reg_params {
> >       bool    is_write;
> >  };
> >
> > +#define encoding_to_params(reg)                                       =
       \
> > +     ((struct sys_reg_params){ .Op0 =3D sys_reg_Op0(reg),             =
 \
> > +                               .Op1 =3D sys_reg_Op1(reg),             =
 \
> > +                               .CRn =3D sys_reg_CRn(reg),             =
 \
> > +                               .CRm =3D sys_reg_CRm(reg),             =
 \
> > +                               .Op2 =3D sys_reg_Op2(reg) })
> > +
> >  #define esr_sys64_to_params(esr)                                      =
         \
> >       ((struct sys_reg_params){ .Op0 =3D ((esr) >> 20) & 3,            =
        \
> >                                 .Op1 =3D ((esr) >> 14) & 0x7,          =
        \
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
Thanks,
Jing
