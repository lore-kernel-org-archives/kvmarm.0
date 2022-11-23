Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21C8C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 23 Nov 2022 17:12:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EAA44086D;
	Wed, 23 Nov 2022 12:12:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JDDQ8KCYPY6W; Wed, 23 Nov 2022 12:12:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C140D40762;
	Wed, 23 Nov 2022 12:12:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C95F40762
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2022 12:12:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tIvMXIfvw0eG for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Nov 2022 12:11:59 -0500 (EST)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A15C4403CB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2022 12:11:59 -0500 (EST)
Received: by mail-pl1-f182.google.com with SMTP id k7so17202905pll.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2022 09:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=DXmfMcAbqneNQh2BtbA2SOdfF55FaoyuXPVThWrMQPk=;
 b=j+Nr879GxcF8uDjTcxy+dn4iKWz5OWWQy3XOLhQrnfEq+xl71RP17kOYq0+DIPKQBv
 0/9fJGAZxhXAr5GkcPOtUud1ftzRmmTzMfBCx0vX+g/7MiztpxiDyOBEVpL6oItu9Hgd
 Oe+yA11XN1+GEn77sX+S8/XDnzvc3NTmgyAN/thYDEorOBi7JHprGhoRtSHxwzlRmVwx
 toRh5rXQUT3jaWbPXmdBcgEQ0lraUv9k9a8RyHebHODyACac1OwO2/iJQGxZJ2/ODc5Q
 IObCJ2Q5RzNfshLGAsZ1P4ULI+hg2uMhkKYR+WupzjjpKi4+CZjKJbdpRtamClXRjaTB
 AScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=DXmfMcAbqneNQh2BtbA2SOdfF55FaoyuXPVThWrMQPk=;
 b=7urFWn6zkxdM3d4o9AETYmz4wRgx+bLubvz64vk0zV6c7dyRV9QxsEGYKE+L6UUqOZ
 joI3reuRXnH0os1JXbq8PLd+7L4BE+Sj18rmj6urKj1mSlkY71RBSy2Roathb7Q2f0Ai
 4OWIpOx4IUAfH4gNSqOl4TsDrg2dCUXGFr5feuRF6F2AFkJl6FKk3h55ZXQX0iGuV7ET
 Tpcj55oD0c1ykdCjTrcIkP6m0maZJFGd+yVv+iA2LegMsPQnG8dbmNKVbP9vhTvbjKfN
 aM8cxsFHtNESw+5q6FFT9wGIb6ImXSQzghAsUI4NeZiJLr6WBq/iQEVo9M4+bhGgM4Xe
 NtjA==
X-Gm-Message-State: ANoB5pnuHEMAk9As5GTBuOMbPoRGT//OpEIwfsE0czsS4cNvFzwadYo8
 WsIblnZWqTk3q5POvcCl0UK/zNNKPttfgutQOSQKjA==
X-Google-Smtp-Source: AA0mqf5FjXv5JHq3QrDuqdHG6FlinCfWMMIXQ/XsjXPJVdIf2BSIxAtgpvd8UuPeJlnhoLHUXy+x91cmFNMS0f1smlg=
X-Received: by 2002:a17:902:cacb:b0:188:5e78:be0 with SMTP id
 y11-20020a170902cacb00b001885e780be0mr9976545pld.18.1669223518357; Wed, 23
 Nov 2022 09:11:58 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-14-maz@kernel.org>
 <CAAeT=Fx=8g2-Z8nzqUit5owtoxbenXnAFA5Mu6AfgZJFN4CfVw@mail.gmail.com>
 <86leo2ncxl.wl-maz@kernel.org>
In-Reply-To: <86leo2ncxl.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 23 Nov 2022 09:11:41 -0800
Message-ID: <CAAeT=Fyy6ViW+f4w-GWjQp3tdjyzhMaRd3pbkys9iS4gxsAY_Q@mail.gmail.com>
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

On Wed, Nov 23, 2022 at 3:11 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 23 Nov 2022 05:58:17 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Sun, Nov 13, 2022 at 8:46 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > PMUv3p5 (which is mandatory with ARMv8.5) comes with some extra
> > > features:
> > >
> > > - All counters are 64bit
> > >
> > > - The overflow point is controlled by the PMCR_EL0.LP bit
> > >
> > > Add the required checks in the helpers that control counter
> > > width and overflow, as well as the sysreg handling for the LP
> > > bit. A new kvm_pmu_is_3p5() helper makes it easy to spot the
> > > PMUv3p5 specific handling.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/pmu-emul.c | 8 +++++---
> > >  arch/arm64/kvm/sys_regs.c | 4 ++++
> > >  include/kvm/arm_pmu.h     | 7 +++++++
> > >  3 files changed, 16 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > > index 4320c389fa7f..c37cc67ff1d7 100644
> > > --- a/arch/arm64/kvm/pmu-emul.c
> > > +++ b/arch/arm64/kvm/pmu-emul.c
> > > @@ -52,13 +52,15 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
> > >   */
> > >  static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
> > >  {
> > > -       return (select_idx == ARMV8_PMU_CYCLE_IDX);
> > > +       return (select_idx == ARMV8_PMU_CYCLE_IDX || kvm_pmu_is_3p5(vcpu));
> > >  }
> > >
> > >  static bool kvm_pmu_idx_has_64bit_overflow(struct kvm_vcpu *vcpu, u64 select_idx)
> > >  {
> > > -       return (select_idx == ARMV8_PMU_CYCLE_IDX &&
> > > -               __vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
> > > +       u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0);
> > > +
> > > +       return (select_idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
> > > +              (select_idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));
> >
> > Since the vCPU's PMCR_EL0 value is not always in sync with
> > kvm->arch.dfr0_pmuver.imp, shouldn't kvm_pmu_idx_has_64bit_overflow()
> > check kvm_pmu_is_3p5() ?
> > (e.g. when the host supports PMUv3p5, PMCR.LP will be set by reset_pmcr()
> > initially. Then, even if userspace sets ID_AA64DFR0_EL1.PMUVER to
> > PMUVer_V3P1, PMCR.LP will stay the same (still set) unless PMCR is
> > written.  So, kvm_pmu_idx_has_64bit_overflow() might return true
> > even though the guest's PMU version is lower than PMUVer_V3P5.)
>
> I can see two ways to address this: either we spray PMUv3p5 checks
> every time we evaluate PMCR, or we sanitise PMCR after each userspace
> write to ID_AA64DFR0_EL1.
>
> I'd like to be able to take what is stored in the register file at
> face value, so I'm angling towards the second possibility. It also

I thought about that too.  What makes it a bit tricky is that
given that kvm->arch.dfr0_pmuver.imp is shared among all vCPUs
for the guest, updating the PMCR should be done for all the vCPUs.

> +static void update_dfr0_pmuver(struct kvm_vcpu *vcpu, u8 pmuver)
> +{
> +       if (vcpu->kvm->arch.dfr0_pmuver.imp != pmuver) {
> +               vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
> +               __reset_pmcr(vcpu, __vcpu_sys_reg(vcpu, PMCR_EL0));
> +       }
> +}

Or if userspace is expected to set ID_AA64DFR0_EL1 (PMUVER) for
each vCPU, update_dfr0_pmuver() should update PMCR even when
'kvm->arch.dfr0_pmuver.imp' is the same as the given 'pmuver'.
(as PMCR for the vCPU might have not been updated yet)

> makes some sense from a 'HW' perspective: you change the HW
> dynamically by selecting a new version, the HW comes up with its reset
> configuration (i.e don't expect PMCR to stick after you write to
> DFR0 with a different PMUVer).

Yes, it makes some sense.
But, with that, for live migration, PMCR should be restored only
after ID_AA64DFR0_EL1/ID_DFR0_EL1 is restored (to avoid PMCR
being reset after PMCR is restored), which I would think might
affect live migration.
(Or am I misunderstanding something ?)

Thank you,
Reiji


>
> >
> >
> > >  }
> > >
> > >  static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index dc201a0557c0..615cb148e22a 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -654,6 +654,8 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> > >                | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
> > >         if (!kvm_supports_32bit_el0())
> > >                 val |= ARMV8_PMU_PMCR_LC;
> > > +       if (!kvm_pmu_is_3p5(vcpu))
> > > +               val &= ~ARMV8_PMU_PMCR_LP;
> > >         __vcpu_sys_reg(vcpu, r->reg) = val;
> > >  }
> > >
> > > @@ -703,6 +705,8 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> > >                 val |= p->regval & ARMV8_PMU_PMCR_MASK;
> > >                 if (!kvm_supports_32bit_el0())
> > >                         val |= ARMV8_PMU_PMCR_LC;
> > > +               if (!kvm_pmu_is_3p5(vcpu))
> > > +                       val &= ~ARMV8_PMU_PMCR_LP;
> > >                 __vcpu_sys_reg(vcpu, PMCR_EL0) = val;
> > >                 kvm_pmu_handle_pmcr(vcpu, val);
> > >                 kvm_vcpu_pmu_restore_guest(vcpu);
> >
> > For the read case of access_pmcr() (the code below),
> > since PMCR.LP is RES0 when FEAT_PMUv3p5 is not implemented,
> > shouldn't it clear PMCR.LP if kvm_pmu_is_3p5(vcpu) is false ?
> > (Similar issue to kvm_pmu_idx_has_64bit_overflow())
> >
> >         } else {
> >                 /* PMCR.P & PMCR.C are RAZ */
> >                 val = __vcpu_sys_reg(vcpu, PMCR_EL0)
> >                       & ~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
> >                 p->regval = val;
> >         }
>
> I think the above would address it. I've tentatively queued the
> following patch, please let me know if this looks OK to you.
>
> Thanks,
>
>         M.
>
> From d90ec0e8768ce5f7ae11403b29db76260dfaa3f2 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Wed, 23 Nov 2022 11:03:07 +0000
> Subject: [PATCH] KVM: arm64: PMU: Reset PMCR_EL0 on PMU version change
>
> Changing the version of the PMU emulation may result in stale
> bits still being present in the PMCR_EL0 register, leading to
> unexpected results.
>
> Address it by forcing PMCR_EL0 to its reset value when the value
> of ID_AA64DFR0.PMUVer (or ID_DFR0.Perfmon) changes.
>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 67eac0f747be..12a873d94aaf 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -637,15 +637,10 @@ static void reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>         __vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_COUNTER_MASK;
>  }
>
> -static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +static void __reset_pmcr(struct kvm_vcpu *vcpu, u64 pmcr)
>  {
> -       u64 pmcr, val;
> -
> -       /* No PMU available, PMCR_EL0 may UNDEF... */
> -       if (!kvm_arm_support_pmu_v3())
> -               return;
> +       u64 val;
>
> -       pmcr = read_sysreg(pmcr_el0);
>         /*
>          * Writable bits of PMCR_EL0 (ARMV8_PMU_PMCR_MASK) are reset to UNKNOWN
>          * except PMCR.E resetting to zero.
> @@ -656,7 +651,16 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>                 val |= ARMV8_PMU_PMCR_LC;
>         if (!kvm_pmu_is_3p5(vcpu))
>                 val &= ~ARMV8_PMU_PMCR_LP;
> -       __vcpu_sys_reg(vcpu, r->reg) = val;
> +       __vcpu_sys_reg(vcpu, PMCR_EL0) = val;
> +}
> +
> +static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +       /* No PMU available, PMCR_EL0 may UNDEF... */
> +       if (!kvm_arm_support_pmu_v3())
> +               return;
> +
> +       __reset_pmcr(vcpu, read_sysreg(pmcr_el0));
>  }
>
>  static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
> @@ -1259,6 +1263,14 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +static void update_dfr0_pmuver(struct kvm_vcpu *vcpu, u8 pmuver)
> +{
> +       if (vcpu->kvm->arch.dfr0_pmuver.imp != pmuver) {
> +               vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
> +               __reset_pmcr(vcpu, __vcpu_sys_reg(vcpu, PMCR_EL0));
> +       }
> +}
> +
>  static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>                                const struct sys_reg_desc *rd,
>                                u64 val)
> @@ -1291,7 +1303,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>                 return -EINVAL;
>
>         if (valid_pmu)
> -               vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
> +               update_dfr0_pmuver(vcpu, pmuver);
>         else
>                 vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
>
> @@ -1331,7 +1343,7 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>                 return -EINVAL;
>
>         if (valid_pmu)
> -               vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
> +               update_dfr0_pmuver(vcpu, perfmon_to_pmuver(perfmon));
>         else
>                 vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
>
> --
> 2.34.1
>
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
