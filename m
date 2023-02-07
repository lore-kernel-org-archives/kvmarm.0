Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB8FBD21
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 05:50:23 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id be8so14571173plb.7
        for <kvmarm@lists.linux.dev>; Mon, 06 Feb 2023 21:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oZBbE4B65hUDuH1HnXHL5ASmWMM0dAxqMJ1ZhzQmpnw=;
        b=egiLhZtzohTbZYjWA8iGGezWkaPcqbBoYl5cY4rb1JOuJxs3Yd7DSsqX5piDpXOFI3
         LP2TIdGQw8WcbzoMbKmnvirRnxZ3IhvIVKBoaUHtyqMacgLeDO/n0aj3vay487+hjJ3q
         jLM7oNAixMY6xPWFukA+k9igdTKbCa8K4JYkjUYI1ELZvpXLAMJ7Uup/QNb0O6+TQM+p
         cLVyChmIHjwngN4yadfzEpBuA5nN6cCHt4EUH9nWFquklruNq2nqBV5Nmv9Aw+xEnQCc
         RVzmu43G5F6kB6mxRR0qU/Dmk2PrUjIDwyuxybjmSea6QHzO0x3jcqv/PnWcjPuLW+/m
         kH3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oZBbE4B65hUDuH1HnXHL5ASmWMM0dAxqMJ1ZhzQmpnw=;
        b=t/UgZ9xIYChgSIdK+9DUSE44UBRnyRyT0iTjcRhFR5rmi5C+ejOxnrRu3uAJxNwfCa
         DThqTABDJtMMylF+VjS472sE1Uq7dgx7pZRIB4qI+4Bz7/kjQoS4HB7c0OimzITEhVrk
         YntoWpZ1SPrqBIxtJvgbkOz128ywz3UNrSourcVtvmm4NJuzHkTodOiQiwfThIjVOE+x
         rXYK2o3oXrcMo36h8otS2sgSd81v5SC1JgmqXXTaQW5thRhcsaXFEyYeuXp5ios0FLHx
         Ip8F1sYRBRmrWxfxqzjsyl/0rqsOGx+L7ETu1thBbt97lGCJwjQU+jJMLVpzmU+5ZI0+
         lGZA==
X-Gm-Message-State: AO0yUKVZqMcYZ1EuWc/EJvdUe3saRoRGsvHScP2NkmGfP3l5x80OIVGz
	6FGWtklzI5dqixJPvwr6dc2C7QK8QZh2ck1vB1u1o1zLSXxajShbl00=
X-Google-Smtp-Source: AK7set8Na1NQiKsbvoQPjMQmK2tMWJ5/ePhjnPd3iIgVAPd6hPcCO9ZvuLjyDfFp7yb80MmEhWRUGg2ScnG0MnnmZPw=
X-Received: by 2002:a17:90a:6941:b0:22b:b19e:9feb with SMTP id
 j1-20020a17090a694100b0022bb19e9febmr575451pjm.5.1675749022896; Mon, 06 Feb
 2023 21:50:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230201025048.205820-1-jingzhangos@google.com> <20230201025048.205820-4-jingzhangos@google.com>
In-Reply-To: <20230201025048.205820-4-jingzhangos@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 6 Feb 2023 21:50:06 -0800
Message-ID: <CAAeT=FzFR4EO4+vWsYvO=+Gj1oSZr6D+y6N6-XUDtQmnKEe=_w@mail.gmail.com>
Subject: Re: [PATCH v1 3/6] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Jing,

On Tue, Jan 31, 2023 at 6:51 PM Jing Zhang <jingzhangos@google.com> wrote:
>
> With per guest ID registers, ID_AA64PFR0_EL1.[CSV2|CSV3] settings from
> userspace can be stored in its corresponding ID register.
>
> No functional change intended.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h  |  3 +--
>  arch/arm64/kvm/arm.c               | 19 +------------------
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c |  7 +++----
>  arch/arm64/kvm/id_regs.c           | 30 ++++++++++++++++++++++--------
>  4 files changed, 27 insertions(+), 32 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index b1beef93465c..fabb30185a4a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -225,8 +225,6 @@ struct kvm_arch {
>
>         cpumask_var_t supported_cpus;
>
> -       u8 pfr0_csv2;
> -       u8 pfr0_csv3;
>         struct {
>                 u8 imp:4;
>                 u8 unimp:4;
> @@ -249,6 +247,7 @@ struct kvm_arch {
>  #define KVM_ARM_ID_REG_NUM     56
>  #define IDREG_IDX(id)          (((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
>  #define IDREG(kvm, id)         kvm->arch.id_regs[IDREG_IDX(id)]
> +#define IDREG_RD(kvm, rd)      IDREG(kvm, reg_to_encoding(rd))
>         u64 id_regs[KVM_ARM_ID_REG_NUM];
>  };
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index d525b71d0523..d8ba5106bf51 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -104,22 +104,6 @@ static int kvm_arm_default_max_vcpus(void)
>         return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
>  }
>
> -static void set_default_spectre(struct kvm *kvm)
> -{
> -       /*
> -        * The default is to expose CSV2 == 1 if the HW isn't affected.
> -        * Although this is a per-CPU feature, we make it global because
> -        * asymmetric systems are just a nuisance.
> -        *
> -        * Userspace can override this as long as it doesn't promise
> -        * the impossible.
> -        */
> -       if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
> -               kvm->arch.pfr0_csv2 = 1;
> -       if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
> -               kvm->arch.pfr0_csv3 = 1;
> -}
> -
>  /**
>   * kvm_arch_init_vm - initializes a VM data structure
>   * @kvm:       pointer to the KVM struct
> @@ -151,9 +135,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>         /* The maximum number of VCPUs is limited by the host's GIC model */
>         kvm->max_vcpus = kvm_arm_default_max_vcpus();
>
> -       set_default_spectre(kvm);
> -       kvm_arm_init_hypercalls(kvm);
>         kvm_arm_set_default_id_regs(kvm);
> +       kvm_arm_init_hypercalls(kvm);
>
>         /*
>          * Initialise the default PMUver before there is a chance to
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 0f9ac25afdf4..03919d342136 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -92,10 +92,9 @@ static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
>                 PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
>
>         /* Spectre and Meltdown mitigation in KVM */
> -       set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
> -                              (u64)kvm->arch.pfr0_csv2);
> -       set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
> -                              (u64)kvm->arch.pfr0_csv3);
> +       set_mask |= IDREG(kvm, SYS_ID_AA64PFR0_EL1) &
> +               (ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
> +                       ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
>
>         return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
>  }
> diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> index f53ce00ab14d..bc5d9bc84eb1 100644
> --- a/arch/arm64/kvm/id_regs.c
> +++ b/arch/arm64/kvm/id_regs.c
> @@ -71,12 +71,6 @@ u64 kvm_arm_read_id_reg_with_encoding(const struct kvm_vcpu *vcpu, u32 id)
>                 if (!vcpu_has_sve(vcpu))
>                         val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
>                 val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> -               val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> -               val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
> -                                 (u64)vcpu->kvm->arch.pfr0_csv2);
> -               val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> -               val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
> -                                 (u64)vcpu->kvm->arch.pfr0_csv3);
>                 if (kvm_vgic_global_state.type == VGIC_V3) {
>                         val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
>                         val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
> @@ -208,6 +202,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>                                u64 val)
>  {
>         u8 csv2, csv3;
> +       u64 sval = val;
>
>         /*
>          * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
> @@ -232,8 +227,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>         if (val)
>                 return -EINVAL;
>
> -       vcpu->kvm->arch.pfr0_csv2 = csv2;
> -       vcpu->kvm->arch.pfr0_csv3 = csv3;
> +       IDREG_RD(vcpu->kvm, rd) = sval;
>
>         return 0;
>  }
> @@ -516,4 +510,24 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
>                 val = read_sanitised_ftr_reg(id);
>                 IDREG(kvm, id) = val;
>         }
> +       /*
> +        * The default is to expose CSV2 == 1 if the HW isn't affected.
> +        * Although this is a per-CPU feature, we make it global because
> +        * asymmetric systems are just a nuisance.
> +        *
> +        * Userspace can override this as long as it doesn't promise
> +        * the impossible.
> +        */
> +       val = IDREG(kvm, SYS_ID_AA64PFR0_EL1);

Did you deliberately have the code stop explicitly
clearing CSV2/CSV3 (unlike the original code) when
arm64_get_spectre_v2_state()/arm64_get_meltdown_state() doesn't
return SPECTRE_UNAFFECTED ?
(It wasn't not apparent from the commit log comment)

In terms of the default values of those fields, looking at the
kernel code, probably the end result would be the same though.

Thanks,
Reiji

> +       if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED) {
> +               val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> +               val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), 1);
> +       }
> +       if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED) {
> +               val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> +               val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), 1);
> +       }
> +
> +       IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
>  }
> --
> 2.39.1.456.gfc5497dd1b-goog
>
