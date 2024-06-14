Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7364D16F0EA
	for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 16:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382363; cv=none; b=TYh110U0MaPbWX97D5H/fqkalLWvkjvOwA6w/F8cKfLyjM+nfaO92r16CQQs4hsLMThqw/XXV7o4JhieANE8D9/O5jP4Nqs9iLpoQNY0YIQ+txK/kquFJh5/dhSnqiDXPmk8mBxIKcphJ44zCALI3Hgn/lLw/PeMkaUHVf0xANI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382363; c=relaxed/simple;
	bh=dHTXaFjy7EDQ61BY50H4hM8tRElttWjEqiWE2DiL3eg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OkiQMYOukaSZ63agM15lCPEwupMgIDZ0YvoQSQpndofKEPFJAI6wmYipgs+8koF/fE1V0nbcGCl96STtB1Q0lWif07LMvCT1spAsRiPPs4OVvaksXYtUfdtr6wCzf2t2Mqrs+rJTw3O/zKiM5O5h41D5/+6lhNkjyIvzwlA1X3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SaMXN69d; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SaMXN69d"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52b78ef397bso3244153e87.0
        for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 09:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718382360; x=1718987160; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/TmirVK2iDN0C4A6D1u8AF5H9b9aKhqRi6Fpl4Wdggw=;
        b=SaMXN69d1yrD0FYiQJ1UPOl2bw1okwtzFZRpvv2CbumHBpUG0rLBaOWAqTYaf67Wq7
         /m2Q11DQTX2B5VyoxA74aeqL6ztuJNxxcL+arwdYn7wwjcapaSTJQG4qJMq1PYlGrIP/
         bEjahwVC80UbQUpj1rHVx5zueO4cZkzDMMNDtaOxgazRQYuXn4wl3sWnEpvZeb+Cl2wD
         ZMRCugdtrp/WYbRXNCxTymPfV4yHsWlIAZ6hvcvgermULTKCD95BMDj6IbHyNoqabjJ4
         gIjz/DckwEzEuWzRG6R3gdxTKNKS/hybcyDsxUs3NRq12UQhu9zqyIX7TXJeZKt1Zzo4
         lLLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718382360; x=1718987160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/TmirVK2iDN0C4A6D1u8AF5H9b9aKhqRi6Fpl4Wdggw=;
        b=TObxKGwUpRoDfH+FqY69xOiQfgihmaX9QF9VXyKxOPOoFsivtcji9MyNPyZp2bxDHZ
         VUJP9MWFP7aefcG4ZeVgJesC25KpT/AQuduKXyyRwA8b+qnwB1JrsOuV0RGS8wIPB5hi
         eGvvYIxTm40cVCDSmTj4PUjcTF3YqH2ro1Za1aebw///QS/c5kplmKcEw8gOaYt9vXdq
         EWH/CUO7pVr0QfWFAUwe/9eAqoSeHHh1B4rOKWp8/poLbZDEkc2X9cBA4MHBm8R4jhNB
         wU0YZE8gC/jJ7hMn5PU2US4vyKnOL/tZCAVdWO4sEUGiYC1LGZUkS+x1CQxhpG2b9fug
         TQSg==
X-Forwarded-Encrypted: i=1; AJvYcCXmyvhKWeN2kJClGqO5LLa2CLCIsO7TBhch13Df93xSud69BDbvQT8N6Ozh3lTQU61kHI6V/YFqKSW1czZkOt5GQJF5oRBE
X-Gm-Message-State: AOJu0YywyBVkZYoAeG3ZJwWAg3e1k2D1GyagfN4DO3QDYardeVLN9nQe
	CQZjrKhdjjOgJ4g1OD92+K2i5zqf6H84tBQo7jThS118JVukB2jzFIfu8C/KOFu3CDZwYKVK8XE
	KYQyxEBnzugzmHrbPR1e+4sU91uwC3As29sDK
X-Google-Smtp-Source: AGHT+IHxH/3kEEuqimpaagS+T9Lx55dKHwfXgH3HElXACO+TRdHSIrfg7QeT+U0kH8uptq7Kw3h9vGx5ltCZneUnen8=
X-Received: by 2002:a19:9107:0:b0:52b:e2ad:7cde with SMTP id
 2adb3069b0e04-52ca6cc6e85mr918471e87.23.1718382359418; Fri, 14 Jun 2024
 09:25:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240523174056.1565133-1-coltonlewis@google.com>
In-Reply-To: <20240523174056.1565133-1-coltonlewis@google.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 14 Jun 2024 09:25:47 -0700
Message-ID: <CAAdAUtgJZxaNU0edSg1Q5hoCw+8xNqiQw+P_kPAQG-9WOUKozA@mail.gmail.com>
Subject: Re: [PATCH v6] KVM: arm64: Add early_param to control WFx trapping
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Colton,

On Thu, May 23, 2024 at 10:41=E2=80=AFAM Colton Lewis <coltonlewis@google.c=
om> wrote:
>
> Add an early_params to control WFI and WFE trapping. This is to
> control the degree guests can wait for interrupts on their own without
> being trapped by KVM. Options for each param are trap and notrap. trap
> enables the trap. notrap disables the trap. Note that when enabled,
> traps are allowed but not guaranteed by the CPU architecture. Absent
> an explicitly set policy, default to current behavior: disabling the
> trap if only a single task is running and enabling otherwise.
>
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
> v6:
>  * Rebase to v6.9.1
>  * Move decision to enable WFx traps back to vcpu load time
>  * Move policy enum to arm.c and mark variable as __read_mostly
>  * Add explicit disclaimer traps are not guaranteed even when setting ena=
bled
>  * Remove explicit "default" case from early param handling as it is not =
needed
>
> v5:
> https://lore.kernel.org/kvmarm/20240430181444.670773-1-coltonlewis@google=
.com/
>
> v4:
> https://lore.kernel.org/kvmarm/20240422181716.237284-1-coltonlewis@google=
.com/
>
> v3:
> https://lore.kernel.org/kvmarm/20240410175437.793508-1-coltonlewis@google=
.com/
>
> v2:
> https://lore.kernel.org/kvmarm/20240319164341.1674863-1-coltonlewis@googl=
e.com/
>
> v1:
> https://lore.kernel.org/kvmarm/20240129213918.3124494-1-coltonlewis@googl=
e.com/
>
>  .../admin-guide/kernel-parameters.txt         | 18 +++++
>  arch/arm64/include/asm/kvm_emulate.h          | 16 -----
>  arch/arm64/kvm/arm.c                          | 68 ++++++++++++++++++-
>  3 files changed, 83 insertions(+), 19 deletions(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentat=
ion/admin-guide/kernel-parameters.txt
> index 396137ee018d..f334265a9cfa 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2693,6 +2693,24 @@
>                         [KVM,ARM,EARLY] Allow use of GICv4 for direct
>                         injection of LPIs.
>
> +       kvm-arm.wfe_trap_policy=3D
> +                       [KVM,ARM] Control when to set WFE instruction tra=
p for
> +                       KVM VMs. Traps are allowed but not guaranteed by =
the
> +                       CPU architecture.
> +
> +                       trap: set WFE instruction trap
> +
> +                       notrap: clear WFE instruction trap
> +
> +       kvm-arm.wfi_trap_policy=3D
> +                       [KVM,ARM] Control when to set WFI instruction tra=
p for
> +                       KVM VMs. Traps are allowed but not guaranteed by =
the
> +                       CPU architecture.
> +
> +                       trap: set WFI instruction trap
> +
> +                       notrap: clear WFI instruction trap
> +
>         kvm_cma_resv_ratio=3Dn [PPC,EARLY]
>                         Reserves given percentage from system memory area=
 for
>                         contiguous memory allocation for KVM hash pagetab=
le
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/as=
m/kvm_emulate.h
> index 975af30af31f..68c4a170b871 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -109,22 +109,6 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcp=
u *vcpu)
>         return (unsigned long *)&vcpu->arch.hcr_el2;
>  }
>
> -static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
> -{
> -       vcpu->arch.hcr_el2 &=3D ~HCR_TWE;
> -       if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) =
||
> -           vcpu->kvm->arch.vgic.nassgireq)
> -               vcpu->arch.hcr_el2 &=3D ~HCR_TWI;
> -       else
> -               vcpu->arch.hcr_el2 |=3D HCR_TWI;
> -}
> -
> -static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
> -{
> -       vcpu->arch.hcr_el2 |=3D HCR_TWE;
> -       vcpu->arch.hcr_el2 |=3D HCR_TWI;
> -}
> -
>  static inline void vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
>  {
>         vcpu->arch.hcr_el2 |=3D (HCR_API | HCR_APK);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c4a0a35e02c7..1cd58ca5d410 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -47,6 +47,15 @@
>
>  static enum kvm_mode kvm_mode =3D KVM_MODE_DEFAULT;
>
> +enum kvm_wfx_trap_policy {
> +       KVM_WFX_NOTRAP_SINGLE_TASK, /* Default option */
> +       KVM_WFX_NOTRAP,
> +       KVM_WFX_TRAP,
> +};
> +
> +static enum kvm_wfx_trap_policy kvm_wfi_trap_policy __read_mostly =3D KV=
M_WFX_NOTRAP_SINGLE_TASK;
> +static enum kvm_wfx_trap_policy kvm_wfe_trap_policy __read_mostly =3D KV=
M_WFX_NOTRAP_SINGLE_TASK;
> +
>  DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
>
>  DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
> @@ -428,6 +437,24 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>
>  }
>
> +static bool kvm_vcpu_should_clear_twi(struct kvm_vcpu *vcpu)
> +{
> +       if (likely(kvm_wfi_trap_policy =3D=3D KVM_WFX_NOTRAP_SINGLE_TASK)=
)
> +               return single_task_running() &&
> +                       (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe=
.vlpi_count) ||
> +                        vcpu->kvm->arch.vgic.nassgireq);
> +
> +       return kvm_wfi_trap_policy =3D=3D KVM_WFX_NOTRAP;
> +}
> +
> +static bool kvm_vcpu_should_clear_twe(struct kvm_vcpu *vcpu)
> +{
> +       if (likely(kvm_wfe_trap_policy =3D=3D KVM_WFX_NOTRAP_SINGLE_TASK)=
)
> +               return single_task_running();
> +
> +       return kvm_wfe_trap_policy =3D=3D KVM_WFX_NOTRAP;
> +}
> +
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>         struct kvm_s2_mmu *mmu;
> @@ -461,10 +488,15 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int =
cpu)
>         if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
>                 kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
>
> -       if (single_task_running())
> -               vcpu_clear_wfx_traps(vcpu);
> +       if (kvm_vcpu_should_clear_twe(vcpu))
> +               vcpu->arch.hcr_el2 &=3D ~HCR_TWE;
> +       else
> +               vcpu->arch.hcr_el2 |=3D HCR_TWE;
> +
> +       if (kvm_vcpu_should_clear_twi(vcpu))
> +               vcpu->arch.hcr_el2 &=3D ~HCR_TWI;
>         else
> -               vcpu_set_wfx_traps(vcpu);
> +               vcpu->arch.hcr_el2 |=3D HCR_TWI;
>
>         if (vcpu_has_ptrauth(vcpu))
>                 vcpu_ptrauth_disable(vcpu);
> @@ -2663,6 +2695,36 @@ static int __init early_kvm_mode_cfg(char *arg)
>  }
>  early_param("kvm-arm.mode", early_kvm_mode_cfg);
>
> +static int __init early_kvm_wfx_trap_policy_cfg(char *arg, enum kvm_wfx_=
trap_policy *p)
> +{
> +       if (!arg)
> +               return -EINVAL;
> +
> +       if (strcmp(arg, "trap") =3D=3D 0) {
> +               *p =3D KVM_WFX_TRAP;
> +               return 0;
> +       }
> +
> +       if (strcmp(arg, "notrap") =3D=3D 0) {
> +               *p =3D KVM_WFX_NOTRAP;
> +               return 0;
> +       }
> +
> +       return -EINVAL;
> +}
> +
> +static int __init early_kvm_wfi_trap_policy_cfg(char *arg)
> +{
> +       return early_kvm_wfx_trap_policy_cfg(arg, &kvm_wfi_trap_policy);
> +}
> +early_param("kvm-arm.wfi_trap_policy", early_kvm_wfi_trap_policy_cfg);
> +
> +static int __init early_kvm_wfe_trap_policy_cfg(char *arg)
> +{
> +       return early_kvm_wfx_trap_policy_cfg(arg, &kvm_wfe_trap_policy);
> +}
> +early_param("kvm-arm.wfe_trap_policy", early_kvm_wfe_trap_policy_cfg);
> +
>  enum kvm_mode kvm_get_mode(void)
>  {
>         return kvm_mode;
> --
> 2.45.1.288.g0e0cd299f1-goog
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
