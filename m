Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02F515CA
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 03:34:26 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so10285673pjg.4
        for <kvmarm@lists.linux.dev>; Sun, 12 Mar 2023 20:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678678466;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K7c5jAY08UAv//Ae/goiaQTw3VyvwlH6KcT5ugpnHns=;
        b=alKqa5hG+Rl5pqhVqbVPZ2qCNwXgWRVNgfR6IQHI5jD8yc8JC4E00lm9RFYVKXeZXE
         /UIJ6sN8YDzaDPSyqg0UNWza231nCtJK50e08rQOcepn9aQ50y97bwi8FhS9Ci4hPk78
         A/NrUSvElIQGtYLULfTFmDVE+a2mrqofQffPfMKWj3j324MIXlk3ue7wDXejBhuCMPbK
         WZ+YuXYy8/3DAzWHp7RogryFui61FDON9SYQXK9dtWiAPQTB2VrXvh1WFBqHzNvfXFhj
         QLSs6PLIpj4DC3SDzO2fQcYbPIjdKgBMPFRpapEDocJ6dTBROrfoYdBFMupMygUMgimf
         2HBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678678466;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K7c5jAY08UAv//Ae/goiaQTw3VyvwlH6KcT5ugpnHns=;
        b=HZho43ujI6deP5OQ26IpQjD1CgmcDhDlmF8q+EkNJgli1TNWt+Wxw92d4shyOI7sbk
         5goiDr+UcbdoWtKcCMZBfjmqdw9hwr6UPBDdqtu9jy1/dUhnscNjH143HwYmvEUE1I4z
         hBkw/zsWer8yez6iqvmBbIqdn+u8J1ePV2w9aPBjb3YKvnf/+SHuowQc+p84WWM559C1
         ELoVvVtkiPPe5cpE6m9SMPT5Mx/Iej8EetdXzwj2YHSGTlF2v7Spd+DFhsKQgIRx2i0x
         XNI/OV5aX8ioTbQX9gWEKfdycdB4jhuJshDv6gaaZ5rAg2GU3/R1Ue/mA1jNBXitgs3P
         f9Ww==
X-Gm-Message-State: AO0yUKUMV3Isl/tXZkTxKI0BCWL+s0fXfyKG1lqni0Epew8/H6Lc1bJ5
	C4nUyGs6ZtAViFCSErC1nJY2OhfglyvHLzfth0AZOA==
X-Google-Smtp-Source: AK7set/QkYQ5x8DlXWqqggEpeZ2zMX+v5gg+we1kDw+npqM2bImlqd6vIr3LxHCbPLkw1LqAJkAHOxerUOFPbbI36XA=
X-Received: by 2002:a17:903:2c1:b0:19a:7e41:5a2c with SMTP id
 s1-20020a17090302c100b0019a7e415a2cmr12074640plk.2.1678678466118; Sun, 12 Mar
 2023 20:34:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230302055033.3081456-1-reijiw@google.com> <20230302055033.3081456-2-reijiw@google.com>
 <87zg8i3tma.wl-maz@kernel.org>
In-Reply-To: <87zg8i3tma.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Sun, 12 Mar 2023 20:34:09 -0700
Message-ID: <CAAeT=FwbDViWhtPJFFv4CTE9rTJvu7vNvarNQOmsGsctFiwTNw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: PMU: Fix GET_ONE_REG for vPMC regs to
 return the current value
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ricardo Koller <ricarkol@google.com>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Sun, Mar 12, 2023 at 7:57=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Thu, 02 Mar 2023 05:50:32 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Have KVM_GET_ONE_REG for vPMU counter (vPMC) registers (PMCCNTR_EL0
> > and PMEVCNTR<n>_EL0) return the sum of the register value in the sysreg
> > file and the current perf event counter value.
> >
> > Values of vPMC registers are saved in sysreg files on certain occasions=
.
> > These saved values don't represent the current values of the vPMC
> > registers if the perf events for the vPMCs count events after the save.
> > The current values of those registers are the sum of the sysreg file
> > value and the current perf event counter value.  But, when userspace
> > reads those registers (using KVM_GET_ONE_REG), KVM returns the sysreg
> > file value to userspace (not the sum value).
> >
> > Fix this to return the sum value for KVM_GET_ONE_REG.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 21 +++++++++++++++++++--
> >  1 file changed, 19 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index c6cbfe6b854b..c48c053d6146 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -765,6 +765,22 @@ static bool pmu_counter_idx_valid(struct kvm_vcpu =
*vcpu, u64 idx)
> >       return true;
> >  }
> >
> > +static int get_pmu_evcntr(struct kvm_vcpu *vcpu, const struct sys_reg_=
desc *r,
> > +                       u64 *val)
> > +{
> > +     u64 idx;
> > +
> > +     if (r->CRn =3D=3D 9 && r->CRm =3D=3D 13 && r->Op2 =3D=3D 0)
> > +             /* PMCCNTR_EL0 */
> > +             idx =3D ARMV8_PMU_CYCLE_IDX;
> > +     else
> > +             /* PMEVCNTRn_EL0 */
> > +             idx =3D ((r->CRm & 3) << 3) | (r->Op2 & 7);
> > +
> > +     *val =3D kvm_pmu_get_counter_value(vcpu, idx);
> > +     return 0;
>
> It is a bit odd not to return an error when no PMU present, but this
> is already filtered out by the top-level accessors.

Yes, exactly.

>
> > +}
> > +
> >  static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
> >                             struct sys_reg_params *p,
> >                             const struct sys_reg_desc *r)
> > @@ -981,7 +997,7 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu,=
 struct sys_reg_params *p,
> >  /* Macro to expand the PMEVCNTRn_EL0 register */
> >  #define PMU_PMEVCNTR_EL0(n)                                          \
> >       { PMU_SYS_REG(SYS_PMEVCNTRn_EL0(n)),                            \
> > -       .reset =3D reset_pmevcntr,                                     =
 \
> > +       .reset =3D reset_pmevcntr, .get_user =3D get_pmu_evcntr,       =
   \
> >         .access =3D access_pmu_evcntr, .reg =3D (PMEVCNTR0_EL0 + n), }
> >
> >  /* Macro to expand the PMEVTYPERn_EL0 register */
> > @@ -1745,7 +1761,8 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >       { PMU_SYS_REG(SYS_PMCEID1_EL0),
> >         .access =3D access_pmceid, .reset =3D NULL },
> >       { PMU_SYS_REG(SYS_PMCCNTR_EL0),
> > -       .access =3D access_pmu_evcntr, .reset =3D reset_unknown, .reg =
=3D PMCCNTR_EL0 },
> > +       .access =3D access_pmu_evcntr, .reset =3D reset_unknown,
> > +       .reg =3D PMCCNTR_EL0, .get_user =3D get_pmu_evcntr},
> >       { PMU_SYS_REG(SYS_PMXEVTYPER_EL0),
> >         .access =3D access_pmu_evtyper, .reset =3D NULL },
> >       { PMU_SYS_REG(SYS_PMXEVCNTR_EL0),
>
> Reviewed-by: Marc Zyngier <maz@kernel.org>

Thank you!
Reiji

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
