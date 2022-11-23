Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DABD7E
	for <kvmarm@lists.linux.dev>; Wed, 23 Nov 2022 05:58:35 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id 83so731119pfy.11
        for <kvmarm@lists.linux.dev>; Tue, 22 Nov 2022 21:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1CLrxGHIryllbmQSGlgVdnSjWrEt46BNto6MWNDpJ/w=;
        b=QJP/DeqNLgu5BsGuGj3lQQO7TWZSEyZBCLjCsZ0Qh3Bh+h2X2TzepaUPMiA1uEhsS8
         j8LnTgqxk9UWCub2wf3ch4lRUyNyI53tLZFh9wdYw1nfKn8RFFpGj2ZTq3pvVMskPV0L
         jAMsNd1lj1JzH0IAtTPJ/ZBwVQHf/7mFBP9mszx13lOa/KuWdi7ymtILHlPnZMwZ+wgN
         8IAA6jRUNjSznBFXhDZJ8i/v95sgrfufd+2zSTk0O6kGOTvJPwp8Q0Lx/lrvQRaJifhR
         UE/jsEtrcKKRpLqXXeYkOVVdxZVtD2zu1B51d/Xon/dzDl9f1oXLoGNhdT35DAXeKAOJ
         3plQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1CLrxGHIryllbmQSGlgVdnSjWrEt46BNto6MWNDpJ/w=;
        b=oVhxSrOIjVZZMGir+yDe4f1a3gn8VMfkcHgmxValV+8TXo5o8c5ekptqgYit1poHNP
         7UfdMwlZXKJCkfkhDvNiPGuRac5KMxnCa52aK1R4hsSmPZXWpTZVIY7kM4mAUPqlAT8l
         XhNUDPVfO7WKXBZWIVxzlZSlw6cqMBKY911LslOJSx1URttX7sLIsfUsLjAzJrz15FC7
         /lwKZBQF7rIcJXCwr31in6woTgq7UYC8D/7esCc/rC0vXYtZX4j1tA3Hh3RYRsP7Z60z
         ssrivAYV6w8Prm6YfCBjj/drGz7bxd5lz0bcNyLcw7V7jPcrJGo+n7AxJ5vnHPrlPXS7
         852g==
X-Gm-Message-State: ANoB5plaw/3sOdHx1GSde69VwbKajTX6oMR/IDEB34VKVOkYLDTJjQjp
	txD4SKRraTsGxhbdfGbOAYSJZaLNd57aipyVQvo5xEne4iLc4w==
X-Google-Smtp-Source: AA0mqf5rcwSn/rDasVmz9NwN4rEesvQhcO7YEY2dJI9TMGCtzF5J3JarHfmU6aKvPVk6NYeUD56jm9Wf3vRxgbqxFw0=
X-Received: by 2002:a05:6a00:27ab:b0:56c:71a4:efe with SMTP id
 bd43-20020a056a0027ab00b0056c71a40efemr11831681pfb.84.1669183114564; Tue, 22
 Nov 2022 21:58:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-14-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-14-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 22 Nov 2022 21:58:17 -0800
Message-ID: <CAAeT=Fx=8g2-Z8nzqUit5owtoxbenXnAFA5Mu6AfgZJFN4CfVw@mail.gmail.com>
Subject: Re: [PATCH v4 13/16] KVM: arm64: PMU: Implement PMUv3p5 long counter support
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221123055817.jCdZCjRMQEmDbv1hY7Pum4swoH4T9spaxuB4xyW_2FQ@z>

Hi Marc,

On Sun, Nov 13, 2022 at 8:46 AM Marc Zyngier <maz@kernel.org> wrote:
>
> PMUv3p5 (which is mandatory with ARMv8.5) comes with some extra
> features:
>
> - All counters are 64bit
>
> - The overflow point is controlled by the PMCR_EL0.LP bit
>
> Add the required checks in the helpers that control counter
> width and overflow, as well as the sysreg handling for the LP
> bit. A new kvm_pmu_is_3p5() helper makes it easy to spot the
> PMUv3p5 specific handling.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 8 +++++---
>  arch/arm64/kvm/sys_regs.c | 4 ++++
>  include/kvm/arm_pmu.h     | 7 +++++++
>  3 files changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 4320c389fa7f..c37cc67ff1d7 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -52,13 +52,15 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
>   */
>  static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
>  {
> -       return (select_idx == ARMV8_PMU_CYCLE_IDX);
> +       return (select_idx == ARMV8_PMU_CYCLE_IDX || kvm_pmu_is_3p5(vcpu));
>  }
>
>  static bool kvm_pmu_idx_has_64bit_overflow(struct kvm_vcpu *vcpu, u64 select_idx)
>  {
> -       return (select_idx == ARMV8_PMU_CYCLE_IDX &&
> -               __vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
> +       u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0);
> +
> +       return (select_idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
> +              (select_idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));

Since the vCPU's PMCR_EL0 value is not always in sync with
kvm->arch.dfr0_pmuver.imp, shouldn't kvm_pmu_idx_has_64bit_overflow()
check kvm_pmu_is_3p5() ?
(e.g. when the host supports PMUv3p5, PMCR.LP will be set by reset_pmcr()
initially. Then, even if userspace sets ID_AA64DFR0_EL1.PMUVER to
PMUVer_V3P1, PMCR.LP will stay the same (still set) unless PMCR is
written.  So, kvm_pmu_idx_has_64bit_overflow() might return true
even though the guest's PMU version is lower than PMUVer_V3P5.)


>  }
>
>  static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index dc201a0557c0..615cb148e22a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -654,6 +654,8 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>                | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
>         if (!kvm_supports_32bit_el0())
>                 val |= ARMV8_PMU_PMCR_LC;
> +       if (!kvm_pmu_is_3p5(vcpu))
> +               val &= ~ARMV8_PMU_PMCR_LP;
>         __vcpu_sys_reg(vcpu, r->reg) = val;
>  }
>
> @@ -703,6 +705,8 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>                 val |= p->regval & ARMV8_PMU_PMCR_MASK;
>                 if (!kvm_supports_32bit_el0())
>                         val |= ARMV8_PMU_PMCR_LC;
> +               if (!kvm_pmu_is_3p5(vcpu))
> +                       val &= ~ARMV8_PMU_PMCR_LP;
>                 __vcpu_sys_reg(vcpu, PMCR_EL0) = val;
>                 kvm_pmu_handle_pmcr(vcpu, val);
>                 kvm_vcpu_pmu_restore_guest(vcpu);

For the read case of access_pmcr() (the code below),
since PMCR.LP is RES0 when FEAT_PMUv3p5 is not implemented,
shouldn't it clear PMCR.LP if kvm_pmu_is_3p5(vcpu) is false ?
(Similar issue to kvm_pmu_idx_has_64bit_overflow())

        } else {
                /* PMCR.P & PMCR.C are RAZ */
                val = __vcpu_sys_reg(vcpu, PMCR_EL0)
                      & ~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
                p->regval = val;
        }

Thank you,
Reiji

> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 812f729c9108..628775334d5e 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -89,6 +89,12 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>                         vcpu->arch.pmu.events = *kvm_get_pmu_events();  \
>         } while (0)
>
> +/*
> + * Evaluates as true when emulating PMUv3p5, and false otherwise.
> + */
> +#define kvm_pmu_is_3p5(vcpu)                                           \
> +       (vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
> +
>  u8 kvm_arm_pmu_get_pmuver_limit(void);
>
>  #else
> @@ -153,6 +159,7 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
>  }
>
>  #define kvm_vcpu_has_pmu(vcpu)         ({ false; })
> +#define kvm_pmu_is_3p5(vcpu)           ({ false; })
>  static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
> --
> 2.34.1
>
