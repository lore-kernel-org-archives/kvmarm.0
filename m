Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644E717AD9
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 23:24:29 +0000 (UTC)
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2b9ab1725bbso90227471fa.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 16:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692141867; x=1692746667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XCKFH+/QQKxxj3AqqG9V01/m+KYYGkMO1/YNKVfZBs=;
        b=SiTYn3r0clh84QKxmhPqS+Jtn34BBwbECywudhTQm4OvP5ufZA/IgrkcoLp3dJE+0S
         uGIDIaMvajyXVVg3U1g/kJrfNwrfTIdMvcSZoLdLOoDgXy4LZ28W7KJApd3bCqN8OF14
         lOolRw2Cz3/peGScvIBCrZsaDNJdWbwWaWjFIIMDTTbwIMievG5hD7drgJGsAZ64xaHq
         b2939hNKzAjSoaz7kQ6X/0fWVBxQhQtaftwjWeV8zUecqBNGY02lAhYKO62fj+UE8oSU
         3KQBFmKB+6nsgRdZR90TNIh1637NdqUg7WZ0CDA81m7akeCGQ/DqUa20CZPGTLYkLu8l
         inaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692141867; x=1692746667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7XCKFH+/QQKxxj3AqqG9V01/m+KYYGkMO1/YNKVfZBs=;
        b=AwjBfiVhlzkcjzBNTBf8zuyQ7gWBfB2V7fpBg4m0xV+qjrUMm1NBvT+cVTrlwxJvr/
         AgveQJnyb5HO5/QQoNvncmogZioof5Z20qJrSfaU4dQQZUH+RC8NcTOucbeIT3Qcc+EP
         WH/aOXJ/MY9fINUXOIfkysbMEMsuTLkdNGpgSp5IGMmX0/6Mn3NQcz1vtRb+ZHLHP63Z
         5f6h0klVL9oHAeG2JfRySAwWqDyp+lL9jtqUd1Mih3ir3N03l47TgmEQnjawAZwYntuH
         WNXyiHwMZYD+mvf/JL/W9TooELFNU55YWsUR/BLFaqHCVp9G2TFl01FLjtnnArxXFIfz
         YLnw==
X-Gm-Message-State: AOJu0Yyfsw8kSYaSpTT0cjtTtiX3Drb3UnzQaMTWM7ejGtJBagoOWXcB
	vyAVOWFwRxARq/RWHuiOJ4VukJbW3ZDcAPAPHwO8p2QQgqos9I6PICTtgw==
X-Google-Smtp-Source: AGHT+IH/udtI2GvjKpnEDbbl8CvOGG+qkAU0mxoGOii1YsQ6DTHzAsksItAbJ+v7af8Hid6VvLJX4u6gKJWZMVtiSNI=
X-Received: by 2002:a2e:84d0:0:b0:2bb:8bda:4c9 with SMTP id
 q16-20020a2e84d0000000b002bb8bda04c9mr174751ljh.11.1692141867071; Tue, 15 Aug
 2023 16:24:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-24-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-24-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 15 Aug 2023 16:24:14 -0700
Message-ID: <CAAdAUtgUBiRuMEiMPvJ3JXB-=a3n2_88tf5w_4LYT3s9OGAgoA@mail.gmail.com>
Subject: Re: [PATCH v4 23/28] KVM: arm64: nv: Add SVC trap forwarding
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Andre Przywara <andre.przywara@arm.com>, 
	Chase Conklin <chase.conklin@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	Darren Hart <darren@os.amperecomputing.com>, Miguel Luis <miguel.luis@oracle.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Tue, Aug 15, 2023 at 11:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> HFGITR_EL2 allows the trap of SVC instructions to EL2. Allow these
> traps to be forwarded. Take this opportunity to deny any 32bit activity
> when NV is enabled.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c         |  4 ++++
>  arch/arm64/kvm/handle_exit.c | 12 ++++++++++++
>  2 files changed, 16 insertions(+)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 72dc53a75d1c..8b51570a76f8 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -36,6 +36,7 @@
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_nested.h>
>  #include <asm/kvm_pkvm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/sections.h>
> @@ -818,6 +819,9 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *v=
cpu)
>         if (likely(!vcpu_mode_is_32bit(vcpu)))
>                 return false;
>
> +       if (vcpu_has_nv(vcpu))
> +               return true;
> +
>         return !kvm_supports_32bit_el0();
>  }
>
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 6dcd6604b6bc..3b86d534b995 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -226,6 +226,17 @@ static int kvm_handle_eret(struct kvm_vcpu *vcpu)
>         return 1;
>  }
>
> +static int handle_svc(struct kvm_vcpu *vcpu)
> +{
> +       /*
> +        * So far, SVC traps only for NV via HFGITR_EL2. A SVC from a
> +        * 32bit guest would be caught by vpcu_mode_is_bad_32bit(), so
> +        * we should only have to deal with a 64 bit exception.
> +        */
> +       kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +       return 1;
> +}
> +
>  static exit_handle_fn arm_exit_handlers[] =3D {
>         [0 ... ESR_ELx_EC_MAX]  =3D kvm_handle_unknown_ec,
>         [ESR_ELx_EC_WFx]        =3D kvm_handle_wfx,
> @@ -239,6 +250,7 @@ static exit_handle_fn arm_exit_handlers[] =3D {
>         [ESR_ELx_EC_SMC32]      =3D handle_smc,
>         [ESR_ELx_EC_HVC64]      =3D handle_hvc,
>         [ESR_ELx_EC_SMC64]      =3D handle_smc,
> +       [ESR_ELx_EC_SVC64]      =3D handle_svc,
>         [ESR_ELx_EC_SYS64]      =3D kvm_handle_sys_reg,
>         [ESR_ELx_EC_SVE]        =3D handle_sve,
>         [ESR_ELx_EC_ERET]       =3D kvm_handle_eret,
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
