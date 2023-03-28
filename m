Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0DD323D
	for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 12:40:24 +0000 (UTC)
Received: by mail-lj1-f169.google.com with SMTP id z42so12358500ljq.13
        for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 05:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680007222; x=1682599222;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lprD4pCRwSAmOb/x5G5B89cXuADSnqcZ/SF0bcsP0yY=;
        b=TKLe7iL75KQ3wc592lTfpCZykIFd9XgOXBQ2+MOqnG82SA4nchXcMInFMJmYO6Xk27
         uw1kYRcNF6gKkuRaz1sg85t8Jb3dk2dXMNncAiWguYwWVZJaPzbsDpeztyvXuh/iQhNR
         2j7reQ2P8bRAZl3BFe2cDLSPlEPchiWaHdY3giM2YAeK/3t8XwZiD5fVxbTmbc54KD5j
         AAQ6c4fPTyhSH83tseVnatjeC4sl3crVu1Lt4hG29sINcrcKwaVKpKcjJ3at+FcLsBTi
         4skpQ5oQoZTF08t/HWb9lflHGQJqgQ9VQWt4oF8SgyuNraBnSzBcmoAvC9fLvzff2q8e
         0xyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680007222; x=1682599222;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lprD4pCRwSAmOb/x5G5B89cXuADSnqcZ/SF0bcsP0yY=;
        b=MQveD1FCfh2YIZCMLpSCsYAXzzrd58KjSAgJv2BpFa+Ki3RSBekfvgl310xK/YUB/W
         zrh5Y4LWTHzKPtBEJQT1buSGHAWZfNgr101eeyRzmyXTzGruWYkqxTkMdEhEhxl4zvgU
         ELBa80EEWwWVnWTLYdIsSpaAB1I8xb34vtKvcaxVkU3cMvL1MMac/RHa6KVkv51Sxa3p
         xLXpdbZ/ZPtFu8ZXmPapSx08FUV38cpU4ov8uOL+y0auUV5NHO3C+SqGy7a4YQGfffk7
         cv3eTaQ+CmUwS5W/SFPINkbcKS3ue5cUgoBi/nwIutoGYbvegrRbR8933JzAp8Avr0LW
         /Drg==
X-Gm-Message-State: AAQBX9e3sEH4XGuXC61IEL8dK9E2vTAvdfMdxEBE/6Lajj+zs5jXFvYN
	Fz7uS+JAUkSvOglX+K8FzcyXH6a28kBZpae157pE7A==
X-Google-Smtp-Source: AKy350bPV0S3wLqxtDSIEGDFzjzlCaBto4Za1QTed7vrsuOGfZKuFLjSa2jlI9Kd7TJt225YALREKHrP/8dBeZ/2394=
X-Received: by 2002:a2e:a0c6:0:b0:293:39fe:b712 with SMTP id
 f6-20020a2ea0c6000000b0029339feb712mr4695052ljm.3.1680007222045; Tue, 28 Mar
 2023 05:40:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com> <20230317050637.766317-4-jingzhangos@google.com>
In-Reply-To: <20230317050637.766317-4-jingzhangos@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 28 Mar 2023 13:39:45 +0100
Message-ID: <CA+EHjTwXA9TprX4jeG+-D+c8v9XG+oFdU1o6TSkvVye145_OvA@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Reiji Watanabe <reijiw@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 17, 2023 at 5:06=E2=80=AFAM Jing Zhang <jingzhangos@google.com>=
 wrote:
>
> With per guest ID registers, ID_AA64PFR0_EL1.[CSV2|CSV3] settings from
> userspace can be stored in its corresponding ID register.
>
> No functional change intended.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h  |  2 --
>  arch/arm64/kvm/arm.c               | 19 +------------------
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c |  7 +++----
>  arch/arm64/kvm/id_regs.c           | 30 ++++++++++++++++++++++--------
>  4 files changed, 26 insertions(+), 32 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index fb6b50b1f111..e926ea91a73c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -230,8 +230,6 @@ struct kvm_arch {
>
>         cpumask_var_t supported_cpus;
>
> -       u8 pfr0_csv2;
> -       u8 pfr0_csv3;
>         struct {
>                 u8 imp:4;
>                 u8 unimp:4;
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 4579c878ab30..c78d68d011cb 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -104,22 +104,6 @@ static int kvm_arm_default_max_vcpus(void)
>         return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
>  }
>
> -static void set_default_spectre(struct kvm *kvm)
> -{
> -       /*
> -        * The default is to expose CSV2 =3D=3D 1 if the HW isn't affecte=
d.
> -        * Although this is a per-CPU feature, we make it global because
> -        * asymmetric systems are just a nuisance.
> -        *
> -        * Userspace can override this as long as it doesn't promise
> -        * the impossible.
> -        */
> -       if (arm64_get_spectre_v2_state() =3D=3D SPECTRE_UNAFFECTED)
> -               kvm->arch.pfr0_csv2 =3D 1;
> -       if (arm64_get_meltdown_state() =3D=3D SPECTRE_UNAFFECTED)
> -               kvm->arch.pfr0_csv3 =3D 1;
> -}
> -
>  /**
>   * kvm_arch_init_vm - initializes a VM data structure
>   * @kvm:       pointer to the KVM struct
> @@ -151,9 +135,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long t=
ype)
>         /* The maximum number of VCPUs is limited by the host's GIC model=
 */
>         kvm->max_vcpus =3D kvm_arm_default_max_vcpus();
>
> -       set_default_spectre(kvm);
> -       kvm_arm_init_hypercalls(kvm);
>         kvm_arm_set_default_id_regs(kvm);
> +       kvm_arm_init_hypercalls(kvm);
>
>         /*
>          * Initialise the default PMUver before there is a chance to
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe=
/sys_regs.c
> index 08d2b004f4b7..0e1988740a65 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -93,10 +93,9 @@ static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *=
vcpu)
>                 PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
>
>         /* Spectre and Meltdown mitigation in KVM */
> -       set_mask |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2)=
,
> -                              (u64)kvm->arch.pfr0_csv2);
> -       set_mask |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3)=
,
> -                              (u64)kvm->arch.pfr0_csv3);
> +       set_mask |=3D vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_E=
L1)] &
> +               (ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
> +                       ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));

This triggers a compiler warning now since the variable `struct kvm
*kvm` isn't used anymore, this, however, isn't the main issue.

The main issue is that `struct kvm` here (vcpu->kvm) is the
hypervisor's version for protected vms, and not the host's. Therefore,
reading that value is wrong. That said, this is an existing bug in
pKVM since kvm->arch.pfr0_csv2 and kvm->arch.pfr0_csv3 are not
initialized.

The solution would be to track the spectre/meltown state at hyp and
use that. I'll submit a patch that does that. In the meantime, I think
that it would be better not to set the CSV bits for protected VMs,
which is the current behavior in practice.

Non-protected VMs in protected mode go back to the host on id register
traps, and use the host's `struct kvm`, so they should behave as
expected.

Thanks,
/fuad


>
>         return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
>  }
> diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> index e393b5730557..b60ca1058301 100644
> --- a/arch/arm64/kvm/id_regs.c
> +++ b/arch/arm64/kvm/id_regs.c
> @@ -61,12 +61,6 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u=
32 id)
>                 if (!vcpu_has_sve(vcpu))
>                         val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE)=
;
>                 val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> -               val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> -               val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V2),
> -                                 (u64)vcpu->kvm->arch.pfr0_csv2);
> -               val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> -               val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V3),
> -                                 (u64)vcpu->kvm->arch.pfr0_csv3);
>                 if (kvm_vgic_global_state.type =3D=3D VGIC_V3) {
>                         val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC)=
;
>                         val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR=
0_EL1_GIC), 1);
> @@ -201,6 +195,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>                                u64 val)
>  {
>         u8 csv2, csv3;
> +       u64 sval =3D val;
>
>         /*
>          * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
> @@ -225,8 +220,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>         if (val)
>                 return -EINVAL;
>
> -       vcpu->kvm->arch.pfr0_csv2 =3D csv2;
> -       vcpu->kvm->arch.pfr0_csv3 =3D csv3;
> +       vcpu->kvm->arch.id_regs[IDREG_IDX(reg_to_encoding(rd))] =3D sval;
>
>         return 0;
>  }
> @@ -529,4 +523,24 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
>                 val =3D read_sanitised_ftr_reg(id);
>                 kvm->arch.id_regs[IDREG_IDX(id)] =3D val;
>         }
> +       /*
> +        * The default is to expose CSV2 =3D=3D 1 if the HW isn't affecte=
d.
> +        * Although this is a per-CPU feature, we make it global because
> +        * asymmetric systems are just a nuisance.
> +        *
> +        * Userspace can override this as long as it doesn't promise
> +        * the impossible.
> +        */
> +       val =3D kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)];
> +
> +       if (arm64_get_spectre_v2_state() =3D=3D SPECTRE_UNAFFECTED) {
> +               val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> +               val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V2), 1);
> +       }
> +       if (arm64_get_meltdown_state() =3D=3D SPECTRE_UNAFFECTED) {
> +               val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> +               val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V3), 1);
> +       }
> +
> +       kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] =3D val;
>  }
> --
> 2.40.0.rc1.284.g88254d51c5-goog
>
