Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E43AAD51
	for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 19:54:56 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id l18so9868569oic.13
        for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 12:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680033295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oY2DefvwRjMVYZvNMynZ/BXtgK+qZddJQJabRj+b6wg=;
        b=tU0NKl9Uw3dwSuxQGdfcI//TWLhzZrf2U+SJ0M8hepFKei1tdLnfK5uuBXMptFbAdf
         DYGPUk3N3SlQ4aYDjox1Cwm57j2YbBGPFrciRk0Y9S6O//tRDZPq6iwmqMPUPh2pMaHH
         FsiBiIfDW18RSEUI24VQsnnVPRwpNBlIqeLI0Q4vni1SMfOcjoYIV/EAE6mtFbUKN6Td
         G6IeVoSiEE/EUIeg5rfMa6xd5aqAtGCI6U2EDRmhWlN4Sx/XdDrouHMBq7FKbDW/PM+A
         SzNmmhFEr5iEPzb39iDjktbHWBkP6WfRDwY+MmDInEZRqOd5OuzqentgNqveIeibb4r9
         Kmsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680033295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oY2DefvwRjMVYZvNMynZ/BXtgK+qZddJQJabRj+b6wg=;
        b=eRdeUCnVcbLZ1JjuPXlRcAIaBQU2msN0gUyHAweOxYzX9dcTz9Sfv3cUXtOLWftBMb
         rtKYfzBU0qjY7WVLeIcMGyeSHkql+tLB4Bxv2S9oGUUiOn5h0tbXr80XAOQnrrd2AKmU
         MOW30UQJiGdRa1SYup4NvN3j6H9J7G8ZuF/PMhquttIIxFzRZrdABr0H5LZeThVEBuPp
         h6lSWGdTUufQ0nQlmtMODxjYhHpzHfTcB5W6jgiT5DsKyJe2CWxrX/YoPg92kHJL8q9t
         3Mv5O6M1gHitTObqZA8Beciz9Y6YkohUyD701X6/OnMOaPnjAK6sf4exHUqVWKK/fMt5
         9PiA==
X-Gm-Message-State: AO0yUKVNHX35UBLtzjxx8E+AX3YzMlT5R3RM3k1d7Tr8KMF8F/hfQI9w
	4hV9B+QicNslTwrbpY34pNiSYFhJ1CRFTmW5JH2bqw==
X-Google-Smtp-Source: AK7set8uSU3gun+sT9WnD+Q9CK8fW/xAHDHJwNRpmEpEn2GgFB0wqRVTKI5JR9NDXsz40fywXeN3qYOkqmqpV+aOD1s=
X-Received: by 2002:a05:6808:b38:b0:387:1afd:5924 with SMTP id
 t24-20020a0568080b3800b003871afd5924mr4722534oij.8.1680033295293; Tue, 28 Mar
 2023 12:54:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com>
 <20230317050637.766317-4-jingzhangos@google.com> <86zg7ywkmd.wl-maz@kernel.org>
In-Reply-To: <86zg7ywkmd.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 28 Mar 2023 12:54:43 -0700
Message-ID: <CAAdAUtgEXdv1czttmTJZ6Thg1z-XPmbRP9i3EiYvQ9fH=FwRXA@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
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

On Mon, Mar 27, 2023 at 3:32=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 17 Mar 2023 05:06:34 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > With per guest ID registers, ID_AA64PFR0_EL1.[CSV2|CSV3] settings from
> > userspace can be stored in its corresponding ID register.
> >
> > No functional change intended.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h  |  2 --
> >  arch/arm64/kvm/arm.c               | 19 +------------------
> >  arch/arm64/kvm/hyp/nvhe/sys_regs.c |  7 +++----
> >  arch/arm64/kvm/id_regs.c           | 30 ++++++++++++++++++++++--------
> >  4 files changed, 26 insertions(+), 32 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index fb6b50b1f111..e926ea91a73c 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -230,8 +230,6 @@ struct kvm_arch {
> >
> >       cpumask_var_t supported_cpus;
> >
> > -     u8 pfr0_csv2;
> > -     u8 pfr0_csv3;
> >       struct {
> >               u8 imp:4;
> >               u8 unimp:4;
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 4579c878ab30..c78d68d011cb 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -104,22 +104,6 @@ static int kvm_arm_default_max_vcpus(void)
> >       return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
> >  }
> >
> > -static void set_default_spectre(struct kvm *kvm)
> > -{
> > -     /*
> > -      * The default is to expose CSV2 =3D=3D 1 if the HW isn't affecte=
d.
> > -      * Although this is a per-CPU feature, we make it global because
> > -      * asymmetric systems are just a nuisance.
> > -      *
> > -      * Userspace can override this as long as it doesn't promise
> > -      * the impossible.
> > -      */
> > -     if (arm64_get_spectre_v2_state() =3D=3D SPECTRE_UNAFFECTED)
> > -             kvm->arch.pfr0_csv2 =3D 1;
> > -     if (arm64_get_meltdown_state() =3D=3D SPECTRE_UNAFFECTED)
> > -             kvm->arch.pfr0_csv3 =3D 1;
> > -}
> > -
> >  /**
> >   * kvm_arch_init_vm - initializes a VM data structure
> >   * @kvm:     pointer to the KVM struct
> > @@ -151,9 +135,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
> >       /* The maximum number of VCPUs is limited by the host's GIC model=
 */
> >       kvm->max_vcpus =3D kvm_arm_default_max_vcpus();
> >
> > -     set_default_spectre(kvm);
> > -     kvm_arm_init_hypercalls(kvm);
> >       kvm_arm_set_default_id_regs(kvm);
> > +     kvm_arm_init_hypercalls(kvm);
>
> Please document the ordering dependency between idregs and hypercalls.
I didn't see an ordering dependency here. The reason I put
kvm_arm_set_default_id_regs before kvm_arm_init_hypercalls is that
kvm_arm_set_default_id_regs includes the code in set_default_spectre.
>
> >
> >       /*
> >        * Initialise the default PMUver before there is a chance to
> > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nv=
he/sys_regs.c
> > index 08d2b004f4b7..0e1988740a65 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > @@ -93,10 +93,9 @@ static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu=
 *vcpu)
> >               PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
> >
> >       /* Spectre and Meltdown mitigation in KVM */
> > -     set_mask |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2)=
,
> > -                            (u64)kvm->arch.pfr0_csv2);
> > -     set_mask |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3)=
,
> > -                            (u64)kvm->arch.pfr0_csv3);
> > +     set_mask |=3D vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_E=
L1)] &
>
> This really want an accessor.
>
> > +             (ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
> > +                     ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
> >
> >       return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
> >  }
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > index e393b5730557..b60ca1058301 100644
> > --- a/arch/arm64/kvm/id_regs.c
> > +++ b/arch/arm64/kvm/id_regs.c
> > @@ -61,12 +61,6 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu,=
 u32 id)
> >               if (!vcpu_has_sve(vcpu))
> >                       val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE)=
;
> >               val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> > -             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> > -             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V2),
> > -                               (u64)vcpu->kvm->arch.pfr0_csv2);
> > -             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> > -             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V3),
> > -                               (u64)vcpu->kvm->arch.pfr0_csv3);
> >               if (kvm_vgic_global_state.type =3D=3D VGIC_V3) {
> >                       val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC)=
;
> >                       val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR=
0_EL1_GIC), 1);
> > @@ -201,6 +195,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcp=
u,
> >                              u64 val)
> >  {
> >       u8 csv2, csv3;
> > +     u64 sval =3D val;
> >
> >       /*
> >        * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
> > @@ -225,8 +220,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcp=
u,
> >       if (val)
> >               return -EINVAL;
> >
> > -     vcpu->kvm->arch.pfr0_csv2 =3D csv2;
> > -     vcpu->kvm->arch.pfr0_csv3 =3D csv3;
> > +     vcpu->kvm->arch.id_regs[IDREG_IDX(reg_to_encoding(rd))] =3D sval;
>
> Accessor needed here to.
>
> >
> >       return 0;
> >  }
> > @@ -529,4 +523,24 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
> >               val =3D read_sanitised_ftr_reg(id);
> >               kvm->arch.id_regs[IDREG_IDX(id)] =3D val;
> >       }
> > +     /*
>
> Add a blank line after the closing bracket.
Will do.
>
> > +      * The default is to expose CSV2 =3D=3D 1 if the HW isn't affecte=
d.
> > +      * Although this is a per-CPU feature, we make it global because
> > +      * asymmetric systems are just a nuisance.
> > +      *
> > +      * Userspace can override this as long as it doesn't promise
> > +      * the impossible.
> > +      */
> > +     val =3D kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)];
>
> Accessor.
>
> > +
> > +     if (arm64_get_spectre_v2_state() =3D=3D SPECTRE_UNAFFECTED) {
> > +             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> > +             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V2), 1);
> > +     }
> > +     if (arm64_get_meltdown_state() =3D=3D SPECTRE_UNAFFECTED) {
> > +             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> > +             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V3), 1);
> > +     }
> > +
> > +     kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] =3D val;
>
> Accessor.
Sure, I'll use the macro IDREG() as in the last version of the patch series=
.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
