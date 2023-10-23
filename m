Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA4420B0D
	for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 17:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QHK0tt4N"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-357d0d15b29so3615ab.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 10:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698082114; x=1698686914; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hh5gbGTjwswNSJut0j41J9mky6NNqMMsm33VLdUTGQU=;
        b=QHK0tt4N3i0V2wbIBPhuaLEvw3OFuzlIlUorlRqzSH5bXiRdNqtfZHY5zfJclVjvub
         ytqKYIqDdBUIFotskVuYchrlY2aioBs9sW1heIERezSaMHfku2zxBDWB4jZjgelrIcBx
         euAkNHJLdkUAv29Z0STyEmy1g0GPQCmHdchVvPiDnqU0jcrMJI62ldZ5ZelY9rVoMiav
         JvXMpRrBzyNzLNUNHRLcfZ8GTDEf1FXbrNbsV/ysUfst/TcYdPlUiyFE1auzygyx5nqp
         YrsKx624EF7B/VHeOoeICn2ajwDamCjjpYitTw5KgrendXO71Z1lRNR/Kkpii+Kk8+lU
         Dvhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698082114; x=1698686914;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hh5gbGTjwswNSJut0j41J9mky6NNqMMsm33VLdUTGQU=;
        b=p41mfudfvTTQ/EW2y6astzcN8Ec167UwZZ198+2Hars2j75MX4zgbPmDLQzON6j9tD
         cRZdHVTkdDoBO0LVylOkROcWV18pTOkJBZpVRb9dIWFFpDBRlrcQW20OVG/oBbOWkCPg
         klscF9W4lCIKhuroZ6fHzwauvyupBJfEYJBHNzwHsEQYsDHx2RHpkOxPJ8Qew5vH9njU
         McHOdVnysaGm+novU0VzwlcNX0IsStyPPfv/cvzfUtNHVI7gBylurTe8hyC0+xDFGA3V
         iqPhJ8yW/uh7+p5T6Xr5tCufPapXSACkmzGHi5bUrtSxuYvh6LYd9gKpCa3SXNG8iT6s
         tXcg==
X-Gm-Message-State: AOJu0YwYdl4oVfEEFf9+LF647O8/1+zjvY2r3K/sSyXf6ZxJuV1DSINp
	zS+heht87X/tqf5teb/by7bVMd+0pf/ST3yqrJzo+A==
X-Google-Smtp-Source: AGHT+IGVUVY7CGh97Fb45OyO1PzaUAleRd5IyCXNtJ+bUNq5F5zhjHvvOXBRC7PVZbE40qgq9FQjlIBjiiboUleG7b8=
X-Received: by 2002:a92:ac07:0:b0:351:ad4:85b with SMTP id r7-20020a92ac07000000b003510ad4085bmr27471ilh.4.1698082113782;
 Mon, 23 Oct 2023 10:28:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com> <20231020214053.2144305-6-rananta@google.com>
 <86zg094j1o.wl-maz@kernel.org>
In-Reply-To: <86zg094j1o.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 23 Oct 2023 10:28:21 -0700
Message-ID: <CAJHc60z97PZ5adQEzW-m2GyTPf2=f5RECMQ5P-2e-rObr1LbaQ@mail.gmail.com>
Subject: Re: [PATCH v8 05/13] KVM: arm64: Add {get,set}_user for
 PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 23, 2023 at 5:31=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 20 Oct 2023 22:40:45 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > For unimplemented counters, the bits in PM{C,I}NTEN{SET,CLR} and
> > PMOVS{SET,CLR} registers are expected to RAZ. To honor this,
> > explicitly implement the {get,set}_user functions for these
> > registers to mask out unimplemented counters for userspace reads
> > and writes.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 91 ++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 85 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index faf97878dfbbb..2e5d497596ef8 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -987,6 +987,45 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vc=
pu, struct sys_reg_params *p,
> >       return true;
> >  }
> >
> > +static void set_pmreg_for_valid_counters(struct kvm_vcpu *vcpu,
> > +                                       u64 reg, u64 val, bool set)
> > +{
> > +     struct kvm *kvm =3D vcpu->kvm;
> > +
> > +     mutex_lock(&kvm->arch.config_lock);
> > +
> > +     /* Make the register immutable once the VM has started running */
> > +     if (kvm_vm_has_ran_once(kvm)) {
> > +             mutex_unlock(&kvm->arch.config_lock);
> > +             return;
> > +     }
> > +
> > +     val &=3D kvm_pmu_valid_counter_mask(vcpu);
> > +     mutex_unlock(&kvm->arch.config_lock);
> > +
> > +     if (set)
> > +             __vcpu_sys_reg(vcpu, reg) |=3D val;
> > +     else
> > +             __vcpu_sys_reg(vcpu, reg) &=3D ~val;
> > +}
> > +
> > +static int get_pmcnten(struct kvm_vcpu *vcpu, const struct sys_reg_des=
c *r,
> > +                     u64 *val)
> > +{
> > +     u64 mask =3D kvm_pmu_valid_counter_mask(vcpu);
> > +
> > +     *val =3D __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
> > +     return 0;
> > +}
> > +
> > +static int set_pmcnten(struct kvm_vcpu *vcpu, const struct sys_reg_des=
c *r,
> > +                     u64 val)
> > +{
> > +     /* r->Op2 & 0x1: true for PMCNTENSET_EL0, else PMCNTENCLR_EL0 */
> > +     set_pmreg_for_valid_counters(vcpu, PMCNTENSET_EL0, val, r->Op2 & =
0x1);
> > +     return 0;
> > +}
>
> Huh, this is really ugly. Why the explosion of pointless helpers when
> the whole design of the sysreg infrastructure to have *common* helpers
> for registers that behave the same way?
>
> I'd expect something like the hack below instead.
>
>         M.
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index a2c5f210b3d6..8f560a2496f2 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -987,42 +987,46 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcp=
u, struct sys_reg_params *p,
>         return true;
>  }
>
> -static void set_pmreg_for_valid_counters(struct kvm_vcpu *vcpu,
> -                                         u64 reg, u64 val, bool set)
> +static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
, u64 val)
>  {
>         struct kvm *kvm =3D vcpu->kvm;
> +       bool set;
>
>         mutex_lock(&kvm->arch.config_lock);
>
>         /* Make the register immutable once the VM has started running */
>         if (kvm_vm_has_ran_once(kvm)) {
>                 mutex_unlock(&kvm->arch.config_lock);
> -               return;
> +               return 0;
>         }
>
>         val &=3D kvm_pmu_valid_counter_mask(vcpu);
>         mutex_unlock(&kvm->arch.config_lock);
>
> +       switch(r->reg) {
> +       case PMOVSSET_EL0:
> +               /* CRm[1] being set indicates a SET register, and CLR oth=
erwise */
> +               set =3D r->CRm & 2;
> +               break;
> +       default:
> +               /* Op2[0] being set indicates a SET register, and CLR oth=
erwise */
> +               set =3D r->Op2 & 1;
> +               break;
> +       }
> +
>         if (set)
> -               __vcpu_sys_reg(vcpu, reg) |=3D val;
> +               __vcpu_sys_reg(vcpu, r->reg) |=3D val;
>         else
> -               __vcpu_sys_reg(vcpu, reg) &=3D ~val;
> -}
> -
> -static int get_pmcnten(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*r,
> -                       u64 *val)
> -{
> -       u64 mask =3D kvm_pmu_valid_counter_mask(vcpu);
> +               __vcpu_sys_reg(vcpu, r->reg) &=3D ~val;
>
> -       *val =3D __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
>         return 0;
>  }
>
> -static int set_pmcnten(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*r,
> -                       u64 val)
> +static int get_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
, u64 *val)
>  {
> -       /* r->Op2 & 0x1: true for PMCNTENSET_EL0, else PMCNTENCLR_EL0 */
> -       set_pmreg_for_valid_counters(vcpu, PMCNTENSET_EL0, val, r->Op2 & =
0x1);
> +       u64 mask =3D kvm_pmu_valid_counter_mask(vcpu);
> +
> +       *val =3D __vcpu_sys_reg(vcpu, r->reg) & mask;
>         return 0;
>  }
>
> @@ -1054,23 +1058,6 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, =
struct sys_reg_params *p,
>         return true;
>  }
>
> -static int get_pminten(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*r,
> -                       u64 *val)
> -{
> -       u64 mask =3D kvm_pmu_valid_counter_mask(vcpu);
> -
> -       *val =3D __vcpu_sys_reg(vcpu, PMINTENSET_EL1) & mask;
> -       return 0;
> -}
> -
> -static int set_pminten(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*r,
> -                       u64 val)
> -{
> -       /* r->Op2 & 0x1: true for PMINTENSET_EL1, else PMINTENCLR_EL1 */
> -       set_pmreg_for_valid_counters(vcpu, PMINTENSET_EL1, val, r->Op2 & =
0x1);
> -       return 0;
> -}
> -
>  static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params =
*p,
>                            const struct sys_reg_desc *r)
>  {
> @@ -1095,23 +1082,6 @@ static bool access_pminten(struct kvm_vcpu *vcpu, =
struct sys_reg_params *p,
>         return true;
>  }
>
> -static int set_pmovs(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
> -                     u64 val)
> -{
> -       /* r->CRm & 0x2: true for PMOVSSET_EL0, else PMOVSCLR_EL0 */
> -       set_pmreg_for_valid_counters(vcpu, PMOVSSET_EL0, val, r->CRm & 0x=
2);
> -       return 0;
> -}
> -
> -static int get_pmovs(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
> -                     u64 *val)
> -{
> -       u64 mask =3D kvm_pmu_valid_counter_mask(vcpu);
> -
> -       *val =3D __vcpu_sys_reg(vcpu, PMOVSSET_EL0) & mask;
> -       return 0;
> -}
> -
>  static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p=
,
>                          const struct sys_reg_desc *r)
>  {
> @@ -2311,10 +2281,10 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>
>         { PMU_SYS_REG(PMINTENSET_EL1),
>           .access =3D access_pminten, .reg =3D PMINTENSET_EL1,
> -         .get_user =3D get_pminten, .set_user =3D set_pminten },
> +         .get_user =3D get_pmreg, .set_user =3D set_pmreg },
>         { PMU_SYS_REG(PMINTENCLR_EL1),
>           .access =3D access_pminten, .reg =3D PMINTENSET_EL1,
> -         .get_user =3D get_pminten, .set_user =3D set_pminten },
> +         .get_user =3D get_pmreg, .set_user =3D set_pmreg },
>         { SYS_DESC(SYS_PMMIR_EL1), trap_raz_wi },
>
>         { SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 =
},
> @@ -2366,13 +2336,13 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>           .reg =3D PMCR_EL0, .get_user =3D get_pmcr, .set_user =3D set_pm=
cr },
>         { PMU_SYS_REG(PMCNTENSET_EL0),
>           .access =3D access_pmcnten, .reg =3D PMCNTENSET_EL0,
> -         .get_user =3D get_pmcnten, .set_user =3D set_pmcnten },
> +         .get_user =3D get_pmreg, .set_user =3D set_pmreg },
>         { PMU_SYS_REG(PMCNTENCLR_EL0),
>           .access =3D access_pmcnten, .reg =3D PMCNTENSET_EL0,
> -         .get_user =3D get_pmcnten, .set_user =3D set_pmcnten },
> +         .get_user =3D get_pmreg, .set_user =3D set_pmreg },
>         { PMU_SYS_REG(PMOVSCLR_EL0),
>           .access =3D access_pmovs, .reg =3D PMOVSSET_EL0,
> -         .get_user =3D get_pmovs, .set_user =3D set_pmovs },
> +         .get_user =3D get_pmreg, .set_user =3D set_pmreg },
>         /*
>          * PM_SWINC_EL0 is exposed to userspace as RAZ/WI, as it was
>          * previously (and pointlessly) advertised in the past...
> @@ -2401,7 +2371,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>           .reset =3D reset_val, .reg =3D PMUSERENR_EL0, .val =3D 0 },
>         { PMU_SYS_REG(PMOVSSET_EL0),
>           .access =3D access_pmovs, .reg =3D PMOVSSET_EL0,
> -         .get_user =3D get_pmovs, .set_user =3D set_pmovs },
> +         .get_user =3D get_pmreg, .set_user =3D set_pmreg },
>
>         { SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
>         { SYS_DESC(SYS_TPIDRRO_EL0), NULL, reset_unknown, TPIDRRO_EL0 },
>

Thanks for the suggestion. I'll consider this in the next iteration.

- Raghavendra
