Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D6CFC25B08
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 04:30:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58DA24D1A1;
	Tue, 23 Aug 2022 00:30:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fjZJzqZYuW18; Tue, 23 Aug 2022 00:30:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10D724D171;
	Tue, 23 Aug 2022 00:30:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 756744D12C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 00:30:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LB8mN1L0OHCM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Aug 2022 00:30:38 -0400 (EDT)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com
 [209.85.217.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5817A4D15E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 00:30:38 -0400 (EDT)
Received: by mail-vs1-f53.google.com with SMTP id k2so13305152vsk.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Aug 2022 21:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=ijx0C+d57iq+pvzQNWirwEDqw4ivKU9TFMjkO0FFcZE=;
 b=RDykuuZgUkcjt+8YBHhJIufl9I+DA9lzwOmHdxSiUdrME7oqTZhgAvx5Oc+A+zmW7O
 AWNsI3fqWan00FgC4ygU6o5aLT8QR3ACM/hGvV4vLEccmKdSwSJmCP+59Ef82p77VhCh
 rovXL0AjmnU9VcPUmGp/c/v+oZNX1In+15BKMUkiMcmoIH8/6tODKCht5UDAASjIjXLu
 8xTU5gE86N0GHFtVqrIkI/YKV49Ko6M3WwgyEsXBzUlmBOghdH1tzUhizF55ob1L3mgi
 YfO3Fseh05VsTROG+67fUJHoQl3gtxrTOmdxsNoFffpHKJUY1wuju+06ScImLUmqsTrl
 XmAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=ijx0C+d57iq+pvzQNWirwEDqw4ivKU9TFMjkO0FFcZE=;
 b=uK3byRSsSdlPrqRVJd0Jta+o+dAYKvmntIVIAO8srkBT9APLNba4tHMHj4gzhvOJW8
 STIdSFAGKESA1G+ZVXVACM4In5wA8WByoIh00B8JBct8NU2WotwmuXOGha4R/L2eslEC
 3B+C6e05Qp0j0hktK8UuvM4lY1cuy6R9fSjnN53/0HV3Qd7jF3oH77syIlgY3GaS/ML2
 7kCDfnrv/BUFAGVoaBvQlyHfoSDD3mr06/nRekGWrkUGmZDgsghV9F2as9v7PG7FxZZe
 t7oZqKr0m+MLuPURfPETpfirtMbk4D1bbYP0wsboK/9eY13cQZE+B8TRBlMW0XCIyKLN
 t4/A==
X-Gm-Message-State: ACgBeo20piUdjERP86/743WNTXA+Qng6C9roq1rSlvD6CxPdOuwixTQ4
 1OihGr+LQ/e0LWh1WmowXeX9nNj7FSiCR6TjJUy47g==
X-Google-Smtp-Source: AA6agR5n1yLb01c0X2RGPjsuYni4Q4phcrBmTyAFkLoQr84xO/0PWvEjjQzaRzs0cNr7l6H9B2zaXYiuInWE273FlZ8=
X-Received: by 2002:a67:ea58:0:b0:38f:d89a:e4b3 with SMTP id
 r24-20020a67ea58000000b0038fd89ae4b3mr7916080vso.51.1661229037570; Mon, 22
 Aug 2022 21:30:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-2-maz@kernel.org>
In-Reply-To: <20220805135813.2102034-2-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 22 Aug 2022 21:30:21 -0700
Message-ID: <CAAeT=Fz55H09PWpmMu1sBkV=iUEHWezwhghJskaWAoqQsi2N0A@mail.gmail.com>
Subject: Re: [PATCH 1/9] KVM: arm64: PMU: Align chained counter implementation
 with architecture pseudocode
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>, kvm@vger.kernel.org
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

On Fri, Aug 5, 2022 at 6:58 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Ricardo recently pointed out that the PMU chained counter emulation
> in KVM wasn't quite behaving like the one on actual hardware, in
> the sense that a chained counter would expose an overflow on
> both halves of a chained counter, while KVM would only expose the
> overflow on the top half.
>
> The difference is subtle, but significant. What does the architecture
> say (DDI0087 H.a):
>
> - Before PMUv3p4, all counters but the cycle counter are 32bit
> - A 32bit counter that overflows generates a CHAIN event on the
>   adjacent counter after exposing its own overflow status
> - The CHAIN event is accounted if the counter is correctly
>   configured (CHAIN event selected and counter enabled)
>
> This all means that our current implementation (which uses 64bit
> perf events) prevents us from emulating this overflow on the lower half.
>
> How to fix this? By implementing the above, to the letter.
>
> This largly results in code deletion, removing the notions of
> "counter pair", "chained counters", and "canonical counter".
> The code is further restructured to make the CHAIN handling similar
> to SWINC, as the two are now extremely similar in behaviour.
>
> Reported-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 324 +++++++++++---------------------------
>  include/kvm/arm_pmu.h     |   2 -
>  2 files changed, 91 insertions(+), 235 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 11c43bed5f97..4986e8b3ea6c 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -21,10 +21,6 @@ static LIST_HEAD(arm_pmus);
>  static DEFINE_MUTEX(arm_pmus_lock);
>
>  static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
> -static void kvm_pmu_update_pmc_chained(struct kvm_vcpu *vcpu, u64 select_idx);
> -static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
> -
> -#define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1
>
>  static u32 kvm_pmu_event_mask(struct kvm *kvm)
>  {
> @@ -57,6 +53,11 @@ static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
>                 __vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
>  }
>
> +static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
> +{
> +       return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX);
> +}
> +
>  static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
>  {
>         struct kvm_pmu *pmu;
> @@ -69,91 +70,22 @@ static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
>  }
>
>  /**
> - * kvm_pmu_pmc_is_chained - determine if the pmc is chained
> - * @pmc: The PMU counter pointer
> - */
> -static bool kvm_pmu_pmc_is_chained(struct kvm_pmc *pmc)
> -{
> -       struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
> -
> -       return test_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
> -}
> -
> -/**
> - * kvm_pmu_idx_is_high_counter - determine if select_idx is a high/low counter
> - * @select_idx: The counter index
> - */
> -static bool kvm_pmu_idx_is_high_counter(u64 select_idx)
> -{
> -       return select_idx & 0x1;
> -}
> -
> -/**
> - * kvm_pmu_get_canonical_pmc - obtain the canonical pmc
> - * @pmc: The PMU counter pointer
> - *
> - * When a pair of PMCs are chained together we use the low counter (canonical)
> - * to hold the underlying perf event.
> - */
> -static struct kvm_pmc *kvm_pmu_get_canonical_pmc(struct kvm_pmc *pmc)
> -{
> -       if (kvm_pmu_pmc_is_chained(pmc) &&
> -           kvm_pmu_idx_is_high_counter(pmc->idx))
> -               return pmc - 1;
> -
> -       return pmc;
> -}
> -static struct kvm_pmc *kvm_pmu_get_alternate_pmc(struct kvm_pmc *pmc)
> -{
> -       if (kvm_pmu_idx_is_high_counter(pmc->idx))
> -               return pmc - 1;
> -       else
> -               return pmc + 1;
> -}
> -
> -/**
> - * kvm_pmu_idx_has_chain_evtype - determine if the event type is chain
> + * kvm_pmu_get_counter_value - get PMU counter value
>   * @vcpu: The vcpu pointer
>   * @select_idx: The counter index
>   */
> -static bool kvm_pmu_idx_has_chain_evtype(struct kvm_vcpu *vcpu, u64 select_idx)
> -{
> -       u64 eventsel, reg;
> -
> -       select_idx |= 0x1;
> -
> -       if (select_idx == ARMV8_PMU_CYCLE_IDX)
> -               return false;
> -
> -       reg = PMEVTYPER0_EL0 + select_idx;
> -       eventsel = __vcpu_sys_reg(vcpu, reg) & kvm_pmu_event_mask(vcpu->kvm);
> -
> -       return eventsel == ARMV8_PMUV3_PERFCTR_CHAIN;
> -}
> -
> -/**
> - * kvm_pmu_get_pair_counter_value - get PMU counter value
> - * @vcpu: The vcpu pointer
> - * @pmc: The PMU counter pointer
> - */
> -static u64 kvm_pmu_get_pair_counter_value(struct kvm_vcpu *vcpu,
> -                                         struct kvm_pmc *pmc)
> +u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>  {
> -       u64 counter, counter_high, reg, enabled, running;
> -
> -       if (kvm_pmu_pmc_is_chained(pmc)) {
> -               pmc = kvm_pmu_get_canonical_pmc(pmc);
> -               reg = PMEVCNTR0_EL0 + pmc->idx;
> +       u64 counter, reg, enabled, running;
> +       struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +       struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>
> -               counter = __vcpu_sys_reg(vcpu, reg);
> -               counter_high = __vcpu_sys_reg(vcpu, reg + 1);
> +       if (!kvm_vcpu_has_pmu(vcpu))
> +               return 0;
>
> -               counter = lower_32_bits(counter) | (counter_high << 32);
> -       } else {
> -               reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> -                     ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> -               counter = __vcpu_sys_reg(vcpu, reg);
> -       }
> +       reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> +               ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> +       counter = __vcpu_sys_reg(vcpu, reg);
>
>         /*
>          * The real counter value is equal to the value of counter register plus
> @@ -163,29 +95,7 @@ static u64 kvm_pmu_get_pair_counter_value(struct kvm_vcpu *vcpu,
>                 counter += perf_event_read_value(pmc->perf_event, &enabled,
>                                                  &running);
>
> -       return counter;
> -}
> -
> -/**
> - * kvm_pmu_get_counter_value - get PMU counter value
> - * @vcpu: The vcpu pointer
> - * @select_idx: The counter index
> - */
> -u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> -{
> -       u64 counter;
> -       struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -       struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> -
> -       if (!kvm_vcpu_has_pmu(vcpu))
> -               return 0;
> -
> -       counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
> -
> -       if (kvm_pmu_pmc_is_chained(pmc) &&
> -           kvm_pmu_idx_is_high_counter(select_idx))
> -               counter = upper_32_bits(counter);
> -       else if (select_idx != ARMV8_PMU_CYCLE_IDX)
> +       if (select_idx != ARMV8_PMU_CYCLE_IDX)
>                 counter = lower_32_bits(counter);
>
>         return counter;
> @@ -218,7 +128,6 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>   */
>  static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
>  {
> -       pmc = kvm_pmu_get_canonical_pmc(pmc);
>         if (pmc->perf_event) {
>                 perf_event_disable(pmc->perf_event);
>                 perf_event_release_kernel(pmc->perf_event);
> @@ -236,11 +145,10 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  {
>         u64 counter, reg, val;
>
> -       pmc = kvm_pmu_get_canonical_pmc(pmc);
>         if (!pmc->perf_event)
>                 return;
>
> -       counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
> +       counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
>
>         if (pmc->idx == ARMV8_PMU_CYCLE_IDX) {
>                 reg = PMCCNTR_EL0;
> @@ -252,9 +160,6 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>
>         __vcpu_sys_reg(vcpu, reg) = val;
>
> -       if (kvm_pmu_pmc_is_chained(pmc))
> -               __vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
> -
>         kvm_pmu_release_perf_event(pmc);
>  }
>
> @@ -285,8 +190,6 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
>
>         for_each_set_bit(i, &mask, 32)
>                 kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
> -
> -       bitmap_zero(vcpu->arch.pmu.chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
>  }
>
>  /**
> @@ -340,11 +243,8 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>
>                 pmc = &pmu->pmc[i];
>
> -               /* A change in the enable state may affect the chain state */
> -               kvm_pmu_update_pmc_chained(vcpu, i);
>                 kvm_pmu_create_perf_event(vcpu, i);
>
> -               /* At this point, pmc must be the canonical */
>                 if (pmc->perf_event) {
>                         perf_event_enable(pmc->perf_event);
>                         if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
> @@ -375,11 +275,8 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>
>                 pmc = &pmu->pmc[i];
>
> -               /* A change in the enable state may affect the chain state */
> -               kvm_pmu_update_pmc_chained(vcpu, i);
>                 kvm_pmu_create_perf_event(vcpu, i);
>
> -               /* At this point, pmc must be the canonical */
>                 if (pmc->perf_event)
>                         perf_event_disable(pmc->perf_event);
>         }
> @@ -484,6 +381,51 @@ static void kvm_pmu_perf_overflow_notify_vcpu(struct irq_work *work)
>         kvm_vcpu_kick(vcpu);
>  }
>
> +/*
> + * Perform an increment on any of the counters described in @mask,
> + * generating the overflow if required, and propagate it as a chained
> + * event if possible.
> + */
> +static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
> +                                     unsigned long mask, u32 event)
> +{
> +       int i;
> +
> +       if (!kvm_vcpu_has_pmu(vcpu))
> +               return;
> +
> +       if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
> +               return;
> +
> +       /* Weed out disabled counters */
> +       mask &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
> +
> +       for_each_set_bit(i, &mask, ARMV8_PMU_CYCLE_IDX) {
> +               u64 type, reg;
> +
> +               /* Filter on event type */
> +               type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
> +               type &= kvm_pmu_event_mask(vcpu->kvm);
> +               if (type != event)
> +                       continue;
> +
> +               /* Increment this counter */
> +               reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
> +               reg = lower_32_bits(reg);
> +               __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
> +
> +               if (reg) /* No overflow? move on */
> +                       continue;
> +
> +               /* Mark overflow */
> +               __vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);

Perhaps it might be useful to create another helper that takes
care of just one counter (it would essentially do the code above
in the loop). The helper could be used (in addition to the above
loop) from the code below for the CHAIN event case and from
kvm_pmu_perf_overflow(). Then unnecessary execution of
for_each_set_bit() could be avoided for these two cases.


> +
> +               if (kvm_pmu_counter_can_chain(vcpu, i))
> +                       kvm_pmu_counter_increment(vcpu, BIT(i + 1),
> +                                                 ARMV8_PMUV3_PERFCTR_CHAIN);
> +       }
> +}
> +
>  /**
>   * When the perf event overflows, set the overflow status and inform the vcpu.
>   */
> @@ -514,6 +456,10 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
>
>         __vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx);
>
> +       if (kvm_pmu_counter_can_chain(vcpu, idx))
> +               kvm_pmu_counter_increment(vcpu, BIT(idx + 1),
> +                                         ARMV8_PMUV3_PERFCTR_CHAIN);
> +
>         if (kvm_pmu_overflow_status(vcpu)) {
>                 kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>
> @@ -533,50 +479,7 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
>   */
>  void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
>  {
> -       struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -       int i;
> -
> -       if (!kvm_vcpu_has_pmu(vcpu))
> -               return;
> -
> -       if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
> -               return;
> -
> -       /* Weed out disabled counters */
> -       val &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
> -
> -       for (i = 0; i < ARMV8_PMU_CYCLE_IDX; i++) {
> -               u64 type, reg;
> -
> -               if (!(val & BIT(i)))
> -                       continue;
> -
> -               /* PMSWINC only applies to ... SW_INC! */
> -               type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
> -               type &= kvm_pmu_event_mask(vcpu->kvm);
> -               if (type != ARMV8_PMUV3_PERFCTR_SW_INCR)
> -                       continue;
> -
> -               /* increment this even SW_INC counter */
> -               reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
> -               reg = lower_32_bits(reg);
> -               __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
> -
> -               if (reg) /* no overflow on the low part */
> -                       continue;
> -
> -               if (kvm_pmu_pmc_is_chained(&pmu->pmc[i])) {
> -                       /* increment the high counter */
> -                       reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i + 1) + 1;
> -                       reg = lower_32_bits(reg);
> -                       __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i + 1) = reg;
> -                       if (!reg) /* mark overflow on the high counter */
> -                               __vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i + 1);
> -               } else {
> -                       /* mark overflow on low counter */
> -                       __vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
> -               }
> -       }
> +       kvm_pmu_counter_increment(vcpu, val, ARMV8_PMUV3_PERFCTR_SW_INCR);
>  }
>
>  /**
> @@ -625,30 +528,27 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  {
>         struct arm_pmu *arm_pmu = vcpu->kvm->arch.arm_pmu;
>         struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -       struct kvm_pmc *pmc;
> +       struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>         struct perf_event *event;
>         struct perf_event_attr attr;
>         u64 eventsel, counter, reg, data;
>
> -       /*
> -        * For chained counters the event type and filtering attributes are
> -        * obtained from the low/even counter. We also use this counter to
> -        * determine if the event is enabled/disabled.
> -        */
> -       pmc = kvm_pmu_get_canonical_pmc(&pmu->pmc[select_idx]);
> -
> -       reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> +       reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
>               ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + pmc->idx;

You may want to use select_idx instead of pmc->id for consistency ?


>         data = __vcpu_sys_reg(vcpu, reg);
>
>         kvm_pmu_stop_counter(vcpu, pmc);
> -       if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> +       if (select_idx == ARMV8_PMU_CYCLE_IDX)
>                 eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
>         else
>                 eventsel = data & kvm_pmu_event_mask(vcpu->kvm);
>
> -       /* Software increment event doesn't need to be backed by a perf event */
> -       if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR)
> +       /*
> +        * Neither SW increment nor chained events need to be backed
> +        * by a perf event.
> +        */
> +       if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR ||
> +           eventsel == ARMV8_PMUV3_PERFCTR_CHAIN)
>                 return;
>
>         /*
> @@ -663,37 +563,27 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>         attr.type = arm_pmu->pmu.type;
>         attr.size = sizeof(attr);
>         attr.pinned = 1;
> -       attr.disabled = !kvm_pmu_counter_is_enabled(vcpu, pmc->idx);
> +       attr.disabled = !kvm_pmu_counter_is_enabled(vcpu, select_idx);
>         attr.exclude_user = data & ARMV8_PMU_EXCLUDE_EL0 ? 1 : 0;
>         attr.exclude_kernel = data & ARMV8_PMU_EXCLUDE_EL1 ? 1 : 0;
>         attr.exclude_hv = 1; /* Don't count EL2 events */
>         attr.exclude_host = 1; /* Don't count host events */
>         attr.config = eventsel;
>
> -       counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
> +       /* If counting a 64bit event, advertise it to the perf code */
> +       if (kvm_pmu_idx_is_64bit(vcpu, select_idx))
> +               attr.config1 |= 1;
>
> -       if (kvm_pmu_pmc_is_chained(pmc)) {
> -               /**
> -                * The initial sample period (overflow count) of an event. For
> -                * chained counters we only support overflow interrupts on the
> -                * high counter.
> -                */
> -               attr.sample_period = (-counter) & GENMASK(63, 0);
> -               attr.config1 |= PERF_ATTR_CFG1_KVM_PMU_CHAINED;
> +       counter = kvm_pmu_get_counter_value(vcpu, select_idx);
>
> -               event = perf_event_create_kernel_counter(&attr, -1, current,
> -                                                        kvm_pmu_perf_overflow,
> -                                                        pmc + 1);
> -       } else {
> -               /* The initial sample period (overflow count) of an event. */
> -               if (kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
> -                       attr.sample_period = (-counter) & GENMASK(63, 0);
> -               else
> -                       attr.sample_period = (-counter) & GENMASK(31, 0);
> +       /* The initial sample period (overflow count) of an event. */
> +       if (kvm_pmu_idx_is_64bit(vcpu, select_idx))
> +               attr.sample_period = (-counter) & GENMASK(63, 0);
> +       else
> +               attr.sample_period = (-counter) & GENMASK(31, 0);
>
> -               event = perf_event_create_kernel_counter(&attr, -1, current,
> +       event = perf_event_create_kernel_counter(&attr, -1, current,
>                                                  kvm_pmu_perf_overflow, pmc);
> -       }
>
>         if (IS_ERR(event)) {
>                 pr_err_once("kvm: pmu event creation failed %ld\n",
> @@ -704,41 +594,6 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>         pmc->perf_event = event;
>  }
>
> -/**
> - * kvm_pmu_update_pmc_chained - update chained bitmap
> - * @vcpu: The vcpu pointer
> - * @select_idx: The number of selected counter
> - *
> - * Update the chained bitmap based on the event type written in the
> - * typer register and the enable state of the odd register.
> - */
> -static void kvm_pmu_update_pmc_chained(struct kvm_vcpu *vcpu, u64 select_idx)
> -{
> -       struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -       struct kvm_pmc *pmc = &pmu->pmc[select_idx], *canonical_pmc;
> -       bool new_state, old_state;
> -
> -       old_state = kvm_pmu_pmc_is_chained(pmc);
> -       new_state = kvm_pmu_idx_has_chain_evtype(vcpu, pmc->idx) &&
> -                   kvm_pmu_counter_is_enabled(vcpu, pmc->idx | 0x1);
> -
> -       if (old_state == new_state)
> -               return;
> -
> -       canonical_pmc = kvm_pmu_get_canonical_pmc(pmc);
> -       kvm_pmu_stop_counter(vcpu, canonical_pmc);
> -       if (new_state) {
> -               /*
> -                * During promotion from !chained to chained we must ensure
> -                * the adjacent counter is stopped and its event destroyed
> -                */
> -               kvm_pmu_stop_counter(vcpu, kvm_pmu_get_alternate_pmc(pmc));
> -               set_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
> -               return;
> -       }
> -       clear_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
> -}
> -
>  /**
>   * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
>   * @vcpu: The vcpu pointer
> @@ -752,11 +607,15 @@ static void kvm_pmu_update_pmc_chained(struct kvm_vcpu *vcpu, u64 select_idx)
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>                                     u64 select_idx)
>  {
> +       struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +       struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>         u64 reg, mask;
>
>         if (!kvm_vcpu_has_pmu(vcpu))
>                 return;
>
> +       kvm_pmu_stop_counter(vcpu, pmc);

It appears that kvm_pmu_stop_counter() doesn't have to be called here
because it is called in the beginning of kvm_pmu_create_perf_event().

Thank you,
Reiji


> +
>         mask  =  ARMV8_PMU_EVTYPE_MASK;
>         mask &= ~ARMV8_PMU_EVTYPE_EVENT;
>         mask |= kvm_pmu_event_mask(vcpu->kvm);
> @@ -766,7 +625,6 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>
>         __vcpu_sys_reg(vcpu, reg) = data & mask;
>
> -       kvm_pmu_update_pmc_chained(vcpu, select_idx);
>         kvm_pmu_create_perf_event(vcpu, select_idx);
>  }
>
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index c0b868ce6a8f..96b192139a23 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -11,7 +11,6 @@
>  #include <asm/perf_event.h>
>
>  #define ARMV8_PMU_CYCLE_IDX            (ARMV8_PMU_MAX_COUNTERS - 1)
> -#define ARMV8_PMU_MAX_COUNTER_PAIRS    ((ARMV8_PMU_MAX_COUNTERS + 1) >> 1)
>
>  #ifdef CONFIG_HW_PERF_EVENTS
>
> @@ -29,7 +28,6 @@ struct kvm_pmu {
>         struct irq_work overflow_work;
>         struct kvm_pmu_events events;
>         struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
> -       DECLARE_BITMAP(chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
>         int irq_num;
>         bool created;
>         bool irq_level;
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
