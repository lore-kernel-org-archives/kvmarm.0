Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEA0A50
	for <kvmarm@lists.linux.dev>; Fri, 25 Aug 2023 22:34:17 +0000 (UTC)
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-34bae839382so19235ab.1
        for <kvmarm@lists.linux.dev>; Fri, 25 Aug 2023 15:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693002856; x=1693607656; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VmGrXf9cYjykgOlg/u6doGW9vtPA8bMLiJ9T7b++na4=;
        b=xFgXd7ZCU+me60lxGFy/i/yalGeet0XJ3GtGduN++0RqVQEZFATClcsR/xXPFFdqgl
         1HPVul50FcnIquWG5JM9yPFvFlopHNzTUQ1hu9YrDoJpGTj/O2sTJ9rswomniCBjQG0b
         0lXS6ehlXG320wb+4oL50SjYdEDS8kuKPPgiWCm3LV+rgiv4vCGtumRUYsxgHIAPS5EH
         oJACgRovZLoK+R/6JxxGW7LpSKGb6+gR4BsG8AzLeDmeD0iqygpJgLpRIITFhAO7jTMJ
         r6WXh28FZqOcEA7Yyud2KjmnGvtFnWy1kBTajXEX66U+SpDSu9TgbwNxo7UazZXlX63y
         7+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693002856; x=1693607656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VmGrXf9cYjykgOlg/u6doGW9vtPA8bMLiJ9T7b++na4=;
        b=KrmdOBzy7GSChe9LJGcfWzJduwo6w3ZsZCc6iDi0sW+wEPNgeuzZYRzCNDWoBUcTQb
         BBVtOsFyQlFD2jOSCYBdVr9CwyMolKqaiSfMlepb+XSwv3ZMSXr7dIXFVQxszutdpgIv
         R6kZ4pzJENJncuObvpTuO7e8h0KE+LQ+UlHCWcw3/b3jEkWt0yiBhVXYJ3yhpzvcVkNF
         SKiy1D3eBqAo40y7awOZB2iYaL1Pp2PXPPj7hC+B1hifp7MWSTSZviuowu/256jbM2T8
         O4Ol9VsHAJzzyiNJaT3NMjaiTEPrCOCU+/H1cYjykB53PehEG8+RhKCRwXyeYT28ud7X
         FqyQ==
X-Gm-Message-State: AOJu0YxEJ0oyIvie9/afw9XwxFjERQ92TiJMH2z4YOyq5b0Fh64Z2IC4
	sAZRI2O2QNuNgheRiCoO9OyY9AZ3QgakdL/5MZlpRQ==
X-Google-Smtp-Source: AGHT+IF3vhd8OdJzn3dbhBkM5wd1Hnk0dkeY4f07ZarV1sUQ5JqtJCGCgpfhgOuwf6tzaRd87yn7tlhJtjLYV3wJxgs=
X-Received: by 2002:a92:cda1:0:b0:347:1b96:9d48 with SMTP id
 g1-20020a92cda1000000b003471b969d48mr28190ild.15.1693002856153; Fri, 25 Aug
 2023 15:34:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-9-rananta@google.com>
 <1c6c07af-f6d0-89a6-1b7d-164ca100ac88@redhat.com> <CAJHc60x=rZTpeJ3PDUWmc08Aziow6S+2nndcL90vHfru5GhXtA@mail.gmail.com>
 <a0543866-1fac-6a3f-20cd-43b6d1263c0e@redhat.com>
In-Reply-To: <a0543866-1fac-6a3f-20cd-43b6d1263c0e@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 25 Aug 2023 15:34:04 -0700
Message-ID: <CAJHc60z=+LG8kayRzYEZ6rCZuov7zC-nLMmzAabPiPKY5OhSEg@mail.gmail.com>
Subject: Re: [PATCH v5 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 24, 2023 at 1:50=E2=80=AFAM Shaoqin Huang <shahuang@redhat.com>=
 wrote:
>
>
>
> On 8/24/23 00:06, Raghavendra Rao Ananta wrote:
> > On Tue, Aug 22, 2023 at 3:06=E2=80=AFAM Shaoqin Huang <shahuang@redhat.=
com> wrote:
> >>
> >> Hi Raghavendra,
> >>
> >> On 8/17/23 08:30, Raghavendra Rao Ananta wrote:
> >>> From: Reiji Watanabe <reijiw@google.com>
> >>>
> >>> KVM does not yet support userspace modifying PMCR_EL0.N (With
> >>> the previous patch, KVM ignores what is written by upserspace).
> >>> Add support userspace limiting PMCR_EL0.N.
> >>>
> >>> Disallow userspace to set PMCR_EL0.N to a value that is greater
> >>> than the host value (KVM_SET_ONE_REG will fail), as KVM doesn't
> >>> support more event counters than the host HW implements.
> >>> Although this is an ABI change, this change only affects
> >>> userspace setting PMCR_EL0.N to a larger value than the host.
> >>> As accesses to unadvertised event counters indices is CONSTRAINED
> >>> UNPREDICTABLE behavior, and PMCR_EL0.N was reset to the host value
> >>> on every vCPU reset before this series, I can't think of any
> >>> use case where a user space would do that.
> >>>
> >>> Also, ignore writes to read-only bits that are cleared on vCPU reset,
> >>> and RES{0,1} bits (including writable bits that KVM doesn't support
> >>> yet), as those bits shouldn't be modified (at least with
> >>> the current KVM).
> >>>
> >>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> >>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> >>> ---
> >>>    arch/arm64/include/asm/kvm_host.h |  3 ++
> >>>    arch/arm64/kvm/pmu-emul.c         |  1 +
> >>>    arch/arm64/kvm/sys_regs.c         | 49 +++++++++++++++++++++++++++=
++--
> >>>    3 files changed, 51 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/a=
sm/kvm_host.h
> >>> index 0f2dbbe8f6a7e..c15ec365283d1 100644
> >>> --- a/arch/arm64/include/asm/kvm_host.h
> >>> +++ b/arch/arm64/include/asm/kvm_host.h
> >>> @@ -259,6 +259,9 @@ struct kvm_arch {
> >>>        /* PMCR_EL0.N value for the guest */
> >>>        u8 pmcr_n;
> >>>
> >>> +     /* Limit value of PMCR_EL0.N for the guest */
> >>> +     u8 pmcr_n_limit;
> >>> +
> >>>        /* Hypercall features firmware registers' descriptor */
> >>>        struct kvm_smccc_features smccc_feat;
> >>>        struct maple_tree smccc_filter;
> >>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> >>> index ce7de6bbdc967..39ad56a71ad20 100644
> >>> --- a/arch/arm64/kvm/pmu-emul.c
> >>> +++ b/arch/arm64/kvm/pmu-emul.c
> >>> @@ -896,6 +896,7 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct ar=
m_pmu *arm_pmu)
> >>>         * while the latter does not.
> >>>         */
> >>>        kvm->arch.pmcr_n =3D arm_pmu->num_events - 1;
> >>> +     kvm->arch.pmcr_n_limit =3D arm_pmu->num_events - 1;
> >>>
> >>>        return 0;
> >>>    }
> >>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> >>> index 2075901356c5b..c01d62afa7db4 100644
> >>> --- a/arch/arm64/kvm/sys_regs.c
> >>> +++ b/arch/arm64/kvm/sys_regs.c
> >>> @@ -1086,6 +1086,51 @@ static int get_pmcr(struct kvm_vcpu *vcpu, con=
st struct sys_reg_desc *r,
> >>>        return 0;
> >>>    }
> >>>
> >>> +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc=
 *r,
> >>> +                 u64 val)
> >>> +{
> >>> +     struct kvm *kvm =3D vcpu->kvm;
> >>> +     u64 new_n, mutable_mask;
> >>> +     int ret =3D 0;
> >>> +
> >>> +     new_n =3D FIELD_GET(ARMV8_PMU_PMCR_N, val);
> >>> +
> >>> +     mutex_lock(&kvm->arch.config_lock);
> >>> +     if (unlikely(new_n !=3D kvm->arch.pmcr_n)) {
> >>> +             /*
> >>> +              * The vCPU can't have more counters than the PMU
> >>> +              * hardware implements.
> >>> +              */
> >>> +             if (new_n <=3D kvm->arch.pmcr_n_limit)
> >>> +                     kvm->arch.pmcr_n =3D new_n;
> >>> +             else
> >>> +                     ret =3D -EINVAL;
> >>> +     }
> >>> +     mutex_unlock(&kvm->arch.config_lock);
> >>
> >> Another thing I am just wonder is that should we block any modificatio=
n
> >> to the pmcr_n after vm start to run? Like add one more checking
> >> kvm_vm_has_ran_once() at the beginning of the set_pmcr() function.
> >>
> > Thanks for bringing it up. Reiji and I discussed about this. Checking
> > for kvm_vm_has_ran_once() will be a good move, however, it will go
> > against the ABI expectations of setting the PMCR. I'd like others to
> > weigh in on this as well. What do you think?
> >
> > Thank you.
> > Raghavendra
>
> Before this change, kvm not allowed userspace to change the pmcr_n, but
> allowed to change the lower ARMV8_PMU_PMCR_MASK bits. With this change,
> we now allow to change the pmcr_n, we should not block the change to
> ARMV8_PMU_PMCR_MASK after vm start to run, but how about we just block
> the change to ARMV8_PMU_PMCR_N after vm start to run?
>
I believe you are referring to the guest trap access part of it
(access_pmcr()). This patch focuses on the userspace access of PMCR
via the KVM_SET_ONE_REG ioctl. Before this patch, KVM did not control
the writes to the reg and userspace was free to write to any bits at
any time.

Thank you.
Raghavendra
> Thanks,
> Shaoqin
>
> >> Thanks,
> >> Shaoqin
> >>
> >>> +     if (ret)
> >>> +             return ret;
> >>> +
> >>> +     /*
> >>> +      * Ignore writes to RES0 bits, read only bits that are cleared =
on
> >>> +      * vCPU reset, and writable bits that KVM doesn't support yet.
> >>> +      * (i.e. only PMCR.N and bits [7:0] are mutable from userspace)
> >>> +      * The LP bit is RES0 when FEAT_PMUv3p5 is not supported on the=
 vCPU.
> >>> +      * But, we leave the bit as it is here, as the vCPU's PMUver mi=
ght
> >>> +      * be changed later (NOTE: the bit will be cleared on first vCP=
U run
> >>> +      * if necessary).
> >>> +      */
> >>> +     mutable_mask =3D (ARMV8_PMU_PMCR_MASK | ARMV8_PMU_PMCR_N);
> >>> +     val &=3D mutable_mask;
> >>> +     val |=3D (__vcpu_sys_reg(vcpu, r->reg) & ~mutable_mask);
> >>> +
> >>> +     /* The LC bit is RES1 when AArch32 is not supported */
> >>> +     if (!kvm_supports_32bit_el0())
> >>> +             val |=3D ARMV8_PMU_PMCR_LC;
> >>> +
> >>> +     __vcpu_sys_reg(vcpu, r->reg) =3D val;
> >>> +     return 0;
> >>> +}
> >>> +
> >>>    /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers i=
n one go */
> >>>    #define DBG_BCR_BVR_WCR_WVR_EL1(n)                                =
  \
> >>>        { SYS_DESC(SYS_DBGBVRn_EL1(n)),                               =
  \
> >>> @@ -2147,8 +2192,8 @@ static const struct sys_reg_desc sys_reg_descs[=
] =3D {
> >>>        { SYS_DESC(SYS_CTR_EL0), access_ctr },
> >>>        { SYS_DESC(SYS_SVCR), undef_access },
> >>>
> >>> -     { PMU_SYS_REG(PMCR_EL0), .access =3D access_pmcr,
> >>> -       .reset =3D reset_pmcr, .reg =3D PMCR_EL0, .get_user =3D get_p=
mcr },
> >>> +     { PMU_SYS_REG(PMCR_EL0), .access =3D access_pmcr, .reset =3D re=
set_pmcr,
> >>> +       .reg =3D PMCR_EL0, .get_user =3D get_pmcr, .set_user =3D set_=
pmcr },
> >>>        { PMU_SYS_REG(PMCNTENSET_EL0),
> >>>          .access =3D access_pmcnten, .reg =3D PMCNTENSET_EL0 },
> >>>        { PMU_SYS_REG(PMCNTENCLR_EL0),
> >>
> >> --
> >> Shaoqin
> >>
> >
>
> --
> Shaoqin
>
