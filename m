Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64846C4321E
	for <kvmarm@archiver.kernel.org>; Wed, 23 Nov 2022 05:58:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE2184B62A;
	Wed, 23 Nov 2022 00:58:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JRMrLUTfVP-B; Wed, 23 Nov 2022 00:58:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9401C4B5EE;
	Wed, 23 Nov 2022 00:58:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 647A24B3E5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2022 00:58:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qo0ZvuC4glOZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Nov 2022 00:58:36 -0500 (EST)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 100FF4B08A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2022 00:58:35 -0500 (EST)
Received: by mail-pg1-f178.google.com with SMTP id q1so15912987pgl.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Nov 2022 21:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=WB8O/bFLbXx8QM4gAPvdssPl2Ve4vgF+FzlfDYvN21ew8X/Wnq/vcLJuC/XrOnEAUS
 aoR1sfOuvwOAIRK4MjPZ1WvgSo3iCqJXXlYzwJQWyaPQ4H/24N+woq/x3VnZX/sYffx1
 UwSXHHBKGnZ+ojmYS1jRpt5ku8SuAk8KCOWTVPbhV9zpApp8HdcBUr2cxf/bSQB7ukWN
 G7Dll8O1ISSnc7o8NDLOY6Vwsn/zpD6rJdT6HztxgfYXb12yUK6lJx6PodJRGyI0En+f
 G7l2Ct86aQ94a0+NQBZH17spwicJ8hFOL/R8YdavqV6Mm+hzAUJquGQNfShoNjmhJm7P
 9vUQ==
X-Gm-Message-State: ANoB5pmSWJalVOLZ9vhu6k3PUoN0q32vPsW09XX/htgB/nORJ2iVImzo
 7dfn7o5U4raAyYL8qQE4PrGhiow0Z2Ei07Ac+Qh7Jw==
X-Google-Smtp-Source: AA0mqf5rcwSn/rDasVmz9NwN4rEesvQhcO7YEY2dJI9TMGCtzF5J3JarHfmU6aKvPVk6NYeUD56jm9Wf3vRxgbqxFw0=
X-Received: by 2002:a05:6a00:27ab:b0:56c:71a4:efe with SMTP id
 bd43-20020a056a0027ab00b0056c71a40efemr11831681pfb.84.1669183114564; Tue, 22
 Nov 2022 21:58:34 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-14-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-14-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 22 Nov 2022 21:58:17 -0800
Message-ID: <CAAeT=Fx=8g2-Z8nzqUit5owtoxbenXnAFA5Mu6AfgZJFN4CfVw@mail.gmail.com>
Subject: Re: [PATCH v4 13/16] KVM: arm64: PMU: Implement PMUv3p5 long counter
 support
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
