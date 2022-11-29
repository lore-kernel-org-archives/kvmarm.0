Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8162C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 29 Nov 2022 03:03:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 233FD4A105;
	Mon, 28 Nov 2022 22:03:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F2kUkegxuL6I; Mon, 28 Nov 2022 22:03:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F59B4B269;
	Mon, 28 Nov 2022 22:03:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D74F4A105
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2022 22:03:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j3DE6QeXaaUv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2022 22:03:46 -0500 (EST)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A3BF40DE1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2022 22:03:46 -0500 (EST)
Received: by mail-pf1-f169.google.com with SMTP id x66so12410749pfx.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2022 19:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=0Kg/52ubAS7lYntifWjcdjceQK1BLohFjWF5i5H7C2g=;
 b=LyJdXZU7uaKusi+kqxl9ZkEzuxwa9ulRA0IBmC9/g7rdNHvZtM4unGfA13yYbcNN8m
 qt970BXRcaFFYibTs3IKCjGomYc8uU5f8pKT259zb+Ea7sAE7SW8Mav3yU1VlP0IL3C4
 sieSLtCV0Es/shtTX4QKd2jHiF/Ay0EfFwGI6Jvp29f4sB0vVDA9K5XhYrYwXXXFtHTl
 gyV4IECnqrY0nKOgRAvZlVD9C9RBkE5QXYYOS1aOchPuIn8y3BbmRWeECCDlFNUGp978
 gCPhTUIJt3Xm//5TkFyEzxkl36E1JL5iJdtNUcBGV2ea5WdrNms6uD09NJJivULbIIBu
 2eEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=0Kg/52ubAS7lYntifWjcdjceQK1BLohFjWF5i5H7C2g=;
 b=19H4TCdoKjI24Et+PRjn97M/t57e7EKluph4ERR8tRU730anVTQLEDvT23ig9laFH+
 CFJrG4SbEpiHAlcovypuK6bI0cGbymTqZkjf7E8O6GEFs++t2pfzZB2CU8C6CkTi9Vg8
 LAHS1oFHGGYPly36hCUh8qvaLmVfBDt/7j9K52SYh5PYcsDfRxhOzp1PZKnlbmIhABio
 Ww613vbQPkBe7DLjEEaAZ/ekMoTmiwUxQLU9zawkxKwUTxJtOhngsLyuroZSM5XsLA5I
 WSIvEiK8kSuUwZLP+N4bkGU22qYCm2e4c64uEd/eTTXZLVanT3y8oK1Or62xnHiRYgXk
 WIIw==
X-Gm-Message-State: ANoB5pnsla3+/qfTycY8yM1qg0wTppxl72FJvEGoERmiu2rReIe111RO
 lcIwmpwateAwaVkLQGnhYzKuBc1WZpYRd63/5SKEQA==
X-Google-Smtp-Source: AA0mqf6n5gzQM9wxBIj6N5TzhMnt30g/6xc1YnQYzaFzjhuVxjUyQvCrS8wZ1QjJjyXSNyW/0KzpfM6BAWNQDRHV7Xg=
X-Received: by 2002:a05:6a00:27ab:b0:56c:71a4:efe with SMTP id
 bd43-20020a056a0027ab00b0056c71a40efemr39636148pfb.84.1669691022323; Mon, 28
 Nov 2022 19:03:42 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-14-maz@kernel.org>
 <CAAeT=Fx=8g2-Z8nzqUit5owtoxbenXnAFA5Mu6AfgZJFN4CfVw@mail.gmail.com>
 <86leo2ncxl.wl-maz@kernel.org>
 <CAAeT=Fyy6ViW+f4w-GWjQp3tdjyzhMaRd3pbkys9iS4gxsAY_Q@mail.gmail.com>
 <86bkowodwg.wl-maz@kernel.org>
In-Reply-To: <86bkowodwg.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 28 Nov 2022 19:03:25 -0800
Message-ID: <CAAeT=FyogYsNbKQ5U0GnV0_M=vG+WNmKFfvaqwJi6b6hp_X1Ow@mail.gmail.com>
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

On Thu, Nov 24, 2022 at 2:17 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 23 Nov 2022 17:11:41 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Wed, Nov 23, 2022 at 3:11 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Wed, 23 Nov 2022 05:58:17 +0000,
> > > Reiji Watanabe <reijiw@google.com> wrote:
> > > >
> > > > Hi Marc,
> > > >
> > > > On Sun, Nov 13, 2022 at 8:46 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > >
> > > > > PMUv3p5 (which is mandatory with ARMv8.5) comes with some extra
> > > > > features:
> > > > >
> > > > > - All counters are 64bit
> > > > >
> > > > > - The overflow point is controlled by the PMCR_EL0.LP bit
> > > > >
> > > > > Add the required checks in the helpers that control counter
> > > > > width and overflow, as well as the sysreg handling for the LP
> > > > > bit. A new kvm_pmu_is_3p5() helper makes it easy to spot the
> > > > > PMUv3p5 specific handling.
> > > > >
> > > > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > > > ---
> > > > >  arch/arm64/kvm/pmu-emul.c | 8 +++++---
> > > > >  arch/arm64/kvm/sys_regs.c | 4 ++++
> > > > >  include/kvm/arm_pmu.h     | 7 +++++++
> > > > >  3 files changed, 16 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > > > > index 4320c389fa7f..c37cc67ff1d7 100644
> > > > > --- a/arch/arm64/kvm/pmu-emul.c
> > > > > +++ b/arch/arm64/kvm/pmu-emul.c
> > > > > @@ -52,13 +52,15 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
> > > > >   */
> > > > >  static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
> > > > >  {
> > > > > -       return (select_idx == ARMV8_PMU_CYCLE_IDX);
> > > > > +       return (select_idx == ARMV8_PMU_CYCLE_IDX || kvm_pmu_is_3p5(vcpu));
> > > > >  }
> > > > >
> > > > >  static bool kvm_pmu_idx_has_64bit_overflow(struct kvm_vcpu *vcpu, u64 select_idx)
> > > > >  {
> > > > > -       return (select_idx == ARMV8_PMU_CYCLE_IDX &&
> > > > > -               __vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
> > > > > +       u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0);
> > > > > +
> > > > > +       return (select_idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
> > > > > +              (select_idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));
> > > >
> > > > Since the vCPU's PMCR_EL0 value is not always in sync with
> > > > kvm->arch.dfr0_pmuver.imp, shouldn't kvm_pmu_idx_has_64bit_overflow()
> > > > check kvm_pmu_is_3p5() ?
> > > > (e.g. when the host supports PMUv3p5, PMCR.LP will be set by reset_pmcr()
> > > > initially. Then, even if userspace sets ID_AA64DFR0_EL1.PMUVER to
> > > > PMUVer_V3P1, PMCR.LP will stay the same (still set) unless PMCR is
> > > > written.  So, kvm_pmu_idx_has_64bit_overflow() might return true
> > > > even though the guest's PMU version is lower than PMUVer_V3P5.)
>
> I realised that reset_pmcr() cannot result in LP being set early, as
> the default PMU version isn't PMUv3p5. But I'm starting to think that
> we should stop playing random tricks with PMCR reset value, and make
> the whole thing as straightforward as possible. TBH, the only
> information we actually need from the host is PMCR_EL0.N, so we should
> limit ourselves to that.

I'm not sure what you meant by "the default PMU version isn't PMUv3p5".

Anyway, the current default reset value, which is 0xdecafbad (for
lower 8 bits), has been problematic prior to this series because
it always sets the LP bit (bit 7 of 0xdecafbad is set) even without
PMUv3p5 support (this series fixes this particular problem though).

I like the idea of preserving only PMCR_EL0.N, and reset the rest
to 0 (other than LC when no 32bit EL0 support) since it is obvious
at glance which fields could be set at the vCPU reset unlike using
0xdecafbad.


>
> > >
> > > I can see two ways to address this: either we spray PMUv3p5 checks
> > > every time we evaluate PMCR, or we sanitise PMCR after each userspace
> > > write to ID_AA64DFR0_EL1.
> > >
> > > I'd like to be able to take what is stored in the register file at
> > > face value, so I'm angling towards the second possibility. It also
> >
> > I thought about that too.  What makes it a bit tricky is that
> > given that kvm->arch.dfr0_pmuver.imp is shared among all vCPUs
> > for the guest, updating the PMCR should be done for all the vCPUs.
>
> Yeah, good point. This really is a mess.
>
> > > +static void update_dfr0_pmuver(struct kvm_vcpu *vcpu, u8 pmuver)
> > > +{
> > > +       if (vcpu->kvm->arch.dfr0_pmuver.imp != pmuver) {
> > > +               vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
> > > +               __reset_pmcr(vcpu, __vcpu_sys_reg(vcpu, PMCR_EL0));
> > > +       }
> > > +}
> >
> > Or if userspace is expected to set ID_AA64DFR0_EL1 (PMUVER) for
> > each vCPU, update_dfr0_pmuver() should update PMCR even when
> > 'kvm->arch.dfr0_pmuver.imp' is the same as the given 'pmuver'.
> > (as PMCR for the vCPU might have not been updated yet)
> >
> > > makes some sense from a 'HW' perspective: you change the HW
> > > dynamically by selecting a new version, the HW comes up with its reset
> > > configuration (i.e don't expect PMCR to stick after you write to
> > > DFR0 with a different PMUVer).
> >
> > Yes, it makes some sense.
> > But, with that, for live migration, PMCR should be restored only
> > after ID_AA64DFR0_EL1/ID_DFR0_EL1 is restored (to avoid PMCR
> > being reset after PMCR is restored), which I would think might
> > affect live migration.
> > (Or am I misunderstanding something ?)
>
> You are correct. There is no way out of that anyway, as you need to
> select PMUv3p5 early in order to be able to restore PMCR itself.
>
> I *may* have a slightly better solution though, which is to piggy-back
> on the call to kvm_pmu_handle_pmcr() that happens on the first run of
> each vcpu. This would allow us to sanitise PMCR in the other direction
> (set PMUv3p5, set PMCR, set PMUV3p1, need to fix the potential stale
> PMCR_EL0.LP bit).
>
> Something like this:

Yeah, I agree that it would be better.
I don't see any problem with the new code below.

Thank you,
Reiji


>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 3295dea34f4c..2d291a29d978 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -538,6 +538,12 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
>         if (!kvm_vcpu_has_pmu(vcpu))
>                 return;
>
> +       /* Fixup PMCR_EL0 to reconcile the PMU version and the LP bit */
> +       if (!kvm_pmu_is_3p5(vcpu))
> +               val &= ~ARMV8_PMU_PMCR_LP;
> +
> +       __vcpu_sys_reg(vcpu, PMCR_EL0) = val;
> +
>         if (val & ARMV8_PMU_PMCR_E) {
>                 kvm_pmu_enable_counter_mask(vcpu,
>                        __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 12a873d94aaf..a5a340346749 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -703,15 +703,15 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>                 return false;
>
>         if (p->is_write) {
> -               /* Only update writeable bits of PMCR */
> +               /*
> +                * Only update writeable bits of PMCR (continuing into
> +                * kvm_pmu_handle_pmcr() as well)
> +                */
>                 val = __vcpu_sys_reg(vcpu, PMCR_EL0);
>                 val &= ~ARMV8_PMU_PMCR_MASK;
>                 val |= p->regval & ARMV8_PMU_PMCR_MASK;
>                 if (!kvm_supports_32bit_el0())
>                         val |= ARMV8_PMU_PMCR_LC;
> -               if (!kvm_pmu_is_3p5(vcpu))
> -                       val &= ~ARMV8_PMU_PMCR_LP;
> -               __vcpu_sys_reg(vcpu, PMCR_EL0) = val;
>                 kvm_pmu_handle_pmcr(vcpu, val);
>                 kvm_vcpu_pmu_restore_guest(vcpu);
>         } else {
>
> And for the reset aspect, something like this:
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 67eac0f747be..528d253c571a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -639,24 +639,18 @@ static void reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>
>  static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
> -       u64 pmcr, val;
> +       u64 pmcr;
>
>         /* No PMU available, PMCR_EL0 may UNDEF... */
>         if (!kvm_arm_support_pmu_v3())
>                 return;
>
> -       pmcr = read_sysreg(pmcr_el0);
> -       /*
> -        * Writable bits of PMCR_EL0 (ARMV8_PMU_PMCR_MASK) are reset to UNKNOWN
> -        * except PMCR.E resetting to zero.
> -        */
> -       val = ((pmcr & ~ARMV8_PMU_PMCR_MASK)
> -              | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
> +       /* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> +       pmcr = read_sysreg(pmcr_el0) & ARMV8_PMU_PMCR_N_MASK;
>         if (!kvm_supports_32bit_el0())
> -               val |= ARMV8_PMU_PMCR_LC;
> -       if (!kvm_pmu_is_3p5(vcpu))
> -               val &= ~ARMV8_PMU_PMCR_LP;
> -       __vcpu_sys_reg(vcpu, r->reg) = val;
> +               pmcr |= ARMV8_PMU_PMCR_LC;
> +
> +       __vcpu_sys_reg(vcpu, r->reg) = pmcr;
>  }
>
>  static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
