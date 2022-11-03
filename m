Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E8B7E2
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 04:56:09 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id p15-20020a17090a348f00b002141615576dso4124915pjb.4
        for <kvmarm@lists.linux.dev>; Wed, 02 Nov 2022 21:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZfT+xH5daIHfYda7w4iKG23dA4fhlMkgmp12GuuMJAM=;
        b=RE1TEVrDFGOK40SDV8n92DwtM4R9QdvpnuP044aLs0Tuu7el3qO6aAjlog9lGXsaKM
         K7aaaLAOip9lO+NRhSbQBhZM+2353CSMLkHb72WNswRW73S8zlVsoRk4X9xcGPxxtxoD
         C9milF/3HzcTTywzmERWlnIuUIP5inF9pJSdl8O05YQ27CjkjMebR65EbeCpEKQ4ix9l
         J0LkfvqqpFZbgtV+9JfrwfveK5fEjvNkH45Apo2eNhueNGHBF57kWiL6aKpHa+bqkwyj
         eMgz7+ahe8p6MYa1CgaN4zqpkMS8QB00PTXVWCVSM5OHdxIQ5bFFJU4i5oSbfZf2yrSS
         DS5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZfT+xH5daIHfYda7w4iKG23dA4fhlMkgmp12GuuMJAM=;
        b=kUn8DlZ+PvIz2SBl0Recr/VtTX4fjLq/CBIFRJaY4osx5WSpvfMPdF/cJcSgmfUo2l
         WEYmJGMOzWjZ4G7pd9yuo6boyueosx+Auj/oOAI2wNl+ZyXmeVsxyc7L5BT0/dr71dfP
         VDagpoJmvtiyl/T876a5h0xvscYxgMBep5eDmZ6C9KHxJGu/sqQaQwSTEzaLgBVajefQ
         W+fYWVv79mr/KmvPXmIZbhmBJ23MAgHzFTyN0zJ+CgjA2SzZkvLXeChqTg5szaZutQ+9
         QmPWMnswOrrenJGMb233CqHZWJTUH8xejEre6v01j+IzCkrKsttyjYGjqWf84jEgowaf
         pWGA==
X-Gm-Message-State: ACrzQf1AEqNGLf9O1MIr9exc6oKmcYaJW11K2CcCE2eGgsLDYDEbBBL6
	6JR0/Y9K0PdvBYrHh1/IgdoOu57IBNYuleWAqQI10Q==
X-Google-Smtp-Source: AMsMyM6h9BIasxCM9PdF/S+diyYhRBJW3VJCIBBriIZjDYXzzAy7xOtE0u5r7Dfk7N3A9fWqvstnPwFejtEzJeLWzM8=
X-Received: by 2002:a17:902:9049:b0:180:7922:ce36 with SMTP id
 w9-20020a170902904900b001807922ce36mr29190830plz.30.1667451369015; Wed, 02
 Nov 2022 21:56:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221028105402.2030192-1-maz@kernel.org> <20221028105402.2030192-11-maz@kernel.org>
In-Reply-To: <20221028105402.2030192-11-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 2 Nov 2022 21:55:52 -0700
Message-ID: <CAAeT=FycObU5eHaR23OZ_PeR6-cQeNrmGs=Mi-VnrVuWR6ovSg@mail.gmail.com>
Subject: Re: [PATCH v2 10/14] KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver
 limit to VM creation
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221103045552.Sc5IIVxv8KzpViELaMV8Xe7uXkXSLiG2yixrQ05M46A@z>

Hi Marc,

On Fri, Oct 28, 2022 at 4:16 AM Marc Zyngier <maz@kernel.org> wrote:
>
> As further patches will enable the selection of a PMU revision
> from userspace, sample the supported PMU revision at VM creation
> time, rather than building each time the ID_AA64DFR0_EL1 register
> is accessed.
>
> This shouldn't result in any change in behaviour.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/arm.c              |  6 +++++
>  arch/arm64/kvm/pmu-emul.c         | 11 +++++++++
>  arch/arm64/kvm/sys_regs.c         | 41 +++++++++++++++++++++++++------
>  include/kvm/arm_pmu.h             |  6 +++++
>  5 files changed, 57 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 45e2136322ba..90c9a2dd3f26 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -163,6 +163,7 @@ struct kvm_arch {
>
>         u8 pfr0_csv2;
>         u8 pfr0_csv3;
> +       u8 dfr0_pmuver;
>
>         /* Hypercall features firmware registers' descriptor */
>         struct kvm_smccc_features smccc_feat;
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 94d33e296e10..6b3ed524630d 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -164,6 +164,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>         set_default_spectre(kvm);
>         kvm_arm_init_hypercalls(kvm);
>
> +       /*
> +        * Initialise the default PMUver before there is a chance to
> +        * create an actual PMU.
> +        */
> +       kvm->arch.dfr0_pmuver = kvm_arm_pmu_get_pmuver_limit();
> +
>         return ret;
>  out_free_stage2_pgd:
>         kvm_free_stage2_pgd(&kvm->arch.mmu);
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 87585c12ca41..f126b45aa6c6 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -1049,3 +1049,14 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>
>         return -ENXIO;
>  }
> +
> +u8 kvm_arm_pmu_get_pmuver_limit(void)
> +{
> +       u64 tmp;
> +
> +       tmp = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> +       tmp = cpuid_feature_cap_perfmon_field(tmp,
> +                                             ID_AA64DFR0_EL1_PMUVer_SHIFT,
> +                                             ID_AA64DFR0_EL1_PMUVer_V3P4);
> +       return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), tmp);
> +}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f4a7c5abcbca..7a4cd644b9c0 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1062,6 +1062,32 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>         return true;
>  }
>
> +static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> +{
> +       if (kvm_vcpu_has_pmu(vcpu))
> +               return vcpu->kvm->arch.dfr0_pmuver;
> +
> +       /* Special case for IMPDEF PMUs that KVM has exposed in the past... */
> +       if (vcpu->kvm->arch.dfr0_pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
> +               return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
> +
> +       /* The real "no PMU" */
> +       return 0;
> +}
> +
> +static u8 pmuver_to_perfmon(u8 pmuver)
> +{
> +       switch (pmuver) {
> +       case ID_AA64DFR0_EL1_PMUVer_IMP:
> +               return ID_DFR0_PERFMON_8_0;
> +       case ID_AA64DFR0_EL1_PMUVer_IMP_DEF:
> +               return ID_DFR0_PERFMON_IMP_DEF;
> +       default:
> +               /* Anything ARMv8.1+ has the same value. For now. */
> +               return pmuver;
> +       }
> +}
> +
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
>  static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
>  {
> @@ -1111,18 +1137,17 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
>                 /* Limit debug to ARMv8.0 */
>                 val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
>                 val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), 6);
> -               /* Limit guests to PMUv3 for ARMv8.4 */
> -               val = cpuid_feature_cap_perfmon_field(val,
> -                                                     ID_AA64DFR0_EL1_PMUVer_SHIFT,
> -                                                     kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_EL1_PMUVer_V3P4 : 0);
> +               /* Set PMUver to the required version */
> +               val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> +               val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> +                                 vcpu_pmuver(vcpu));
>                 /* Hide SPE from guests */
>                 val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
>                 break;
>         case SYS_ID_DFR0_EL1:
> -               /* Limit guests to PMUv3 for ARMv8.4 */
> -               val = cpuid_feature_cap_perfmon_field(val,
> -                                                     ID_DFR0_PERFMON_SHIFT,
> -                                                     kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
> +               val &= ~ARM64_FEATURE_MASK(ID_DFR0_PERFMON);
> +               val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_PERFMON),
> +                                 pmuver_to_perfmon(vcpu_pmuver(vcpu)));

Shouldn't KVM expose the sanitized value as it is when AArch32 is
not supported at EL0 ? Since the register value is UNKNOWN when AArch32
is not supported at EL0, I would think this code might change the PERFMON
field value on such systems (could cause live migration to fail).

I should have noticed this with the previous version...

Thank you,
Reiji

>                 break;
>         }
>
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 96b192139a23..812f729c9108 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -89,6 +89,8 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>                         vcpu->arch.pmu.events = *kvm_get_pmu_events();  \
>         } while (0)
>
> +u8 kvm_arm_pmu_get_pmuver_limit(void);
> +
>  #else
>  struct kvm_pmu {
>  };
> @@ -154,6 +156,10 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
>  static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
> +static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
> +{
> +       return 0;
> +}
>
>  #endif
>
> --
> 2.34.1
>
