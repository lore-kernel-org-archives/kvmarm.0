Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0CA9C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 18 Nov 2022 06:17:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 164444B875;
	Fri, 18 Nov 2022 01:17:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R6HbIh2nzX29; Fri, 18 Nov 2022 01:17:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D41AA4B89C;
	Fri, 18 Nov 2022 01:17:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B07F4B7FC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 01:17:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zYmQTCbukK3Z for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 01:17:15 -0500 (EST)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E94E94B796
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 01:17:14 -0500 (EST)
Received: by mail-pj1-f54.google.com with SMTP id
 w3-20020a17090a460300b00218524e8877so6356086pjg.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 22:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=O4krRe8XDBdLIpjFY/ER5AqvIQp00WsZTiZcVijc1ZI=;
 b=XpXWPsuUQPdeaSh+PB7FepZiiaCD2ScGfbp3zoh2o1VxOfHYXcccs2zVlSeCXWR482
 pCgoir28+6RM1WCKscSprXI4GSA2g/hw/KzlqPmC6NBRL+R5p7u43tzcfU/SU3udOt5F
 W5I5b+NdertH6JIBi9b5aXaTJH3560AduFVgMy4ZwliolBJZzhKD8XdpUo6oiIRyaItW
 N2/Np8pDGroR8EizlFI11TZViucKHufjUjdFl2pjND/C1f/21Fx1NtiR57VMcrnvKUR3
 X95M8MrtNqshEKXbjTONVOmHRfAIWniYJoRB2jvwUcQC4oQyFdSiEfsThFytQ1yGv4bX
 Hpmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=O4krRe8XDBdLIpjFY/ER5AqvIQp00WsZTiZcVijc1ZI=;
 b=ZfgrHBW4rnqvSWQlrCUuVEhgQnjZq8VEWrQ903I/KNDZlrEqILBAsN0jAxklAJ3mcq
 rPbhYsbWO0eMSbJAtVSN8/Dry5p2zI3sRMcp/HBek8h7TTtcAKUZuElhU+fg2zWFV3np
 yB2faJiHuYeHywxi0rYQVBezF+xpomGC8KNgtnqwonP+OKufmkWChK7phHdkJg5vs6LD
 5w7cFNjMKTFP/cgCycdoT7oQKiaN37iw80PPs6efK/tQi700QERyzCS+u6+eSc67krtX
 fhNYxckqIU2c1jgyqhgwxMipFSEK2H2ULRvxpm/L827vd2Rq8NxkoAuqT90vZJWVbJJ3
 FObA==
X-Gm-Message-State: ANoB5pkn9VzqDzRBV32MnUmxDMma4CFFihQmIEWjz6zFFBxRF4C7O+SO
 TmbgbijG4YEDcfaMoU/tV0g+b+NhhTxmLTRwoQQ8Tg==
X-Google-Smtp-Source: AA0mqf6F3NyThYJD8zv8B8XMOE2kYz0CUcnIuV6DoYi9y5eEjTe+8F6Mn2Uq93dJuL2v0dYfk/N2/a1lsRjiy2L+4Kw=
X-Received: by 2002:a17:90a:ab84:b0:213:343:9873 with SMTP id
 n4-20020a17090aab8400b0021303439873mr12284511pjq.102.1668752233721; Thu, 17
 Nov 2022 22:17:13 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-8-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-8-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 17 Nov 2022 22:16:57 -0800
Message-ID: <CAAeT=FysJPMs5mG1E02rMcGtjULb7MviZr6RE699x_a=LZNK6w@mail.gmail.com>
Subject: Re: [PATCH v4 07/16] KVM: arm64: PMU: Add counter_index_to_*reg()
 helpers
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

On Sun, Nov 13, 2022 at 8:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> In order to reduce the boilerplate code, add two helpers returning
> the counter register index (resp. the event register) in the vcpu
> register file from the counter index.
>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 33 ++++++++++++++++++---------------
>  1 file changed, 18 insertions(+), 15 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 1fab889dbc74..faab0f57a45d 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -77,6 +77,16 @@ static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
>         return container_of(vcpu_arch, struct kvm_vcpu, arch);
>  }
>
> +static u32 counter_index_to_reg(u64 idx)
> +{
> +       return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + idx;
> +}
> +
> +static u32 counter_index_to_evtreg(u64 idx)
> +{
> +       return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + idx;
> +}

It looks like we could use this function for access_pmu_evtyper()
in arch/arm64/kvm/sys_regs.c as well.

Thank you,
Reiji


> +
>  /**
>   * kvm_pmu_get_counter_value - get PMU counter value
>   * @vcpu: The vcpu pointer
> @@ -91,8 +101,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>         if (!kvm_vcpu_has_pmu(vcpu))
>                 return 0;
>
> -       reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> -               ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> +       reg = counter_index_to_reg(select_idx);
>         counter = __vcpu_sys_reg(vcpu, reg);
>
>         /*
> @@ -122,8 +131,7 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>         if (!kvm_vcpu_has_pmu(vcpu))
>                 return;
>
> -       reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -             ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
> +       reg = counter_index_to_reg(select_idx);
>         __vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
>
>         /* Recreate the perf event to reflect the updated sample_period */
> @@ -158,10 +166,7 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>
>         val = kvm_pmu_get_counter_value(vcpu, pmc->idx);
>
> -       if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> -               reg = PMCCNTR_EL0;
> -       else
> -               reg = PMEVCNTR0_EL0 + pmc->idx;
> +       reg = counter_index_to_reg(pmc->idx);
>
>         __vcpu_sys_reg(vcpu, reg) = val;
>
> @@ -404,16 +409,16 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
>                 u64 type, reg;
>
>                 /* Filter on event type */
> -               type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
> +               type = __vcpu_sys_reg(vcpu, counter_index_to_evtreg(i));
>                 type &= kvm_pmu_event_mask(vcpu->kvm);
>                 if (type != event)
>                         continue;
>
>                 /* Increment this counter */
> -               reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
> +               reg = __vcpu_sys_reg(vcpu, counter_index_to_reg(i)) + 1;
>                 if (!kvm_pmu_idx_is_64bit(vcpu, i))
>                         reg = lower_32_bits(reg);
> -               __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
> +               __vcpu_sys_reg(vcpu, counter_index_to_reg(i)) = reg;
>
>                 /* No overflow? move on */
>                 if (kvm_pmu_idx_has_64bit_overflow(vcpu, i) ? reg : lower_32_bits(reg))
> @@ -549,8 +554,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>         struct perf_event_attr attr;
>         u64 eventsel, counter, reg, data;
>
> -       reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> -             ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + pmc->idx;
> +       reg = counter_index_to_evtreg(select_idx);
>         data = __vcpu_sys_reg(vcpu, reg);
>
>         kvm_pmu_stop_counter(vcpu, pmc);
> @@ -632,8 +636,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>         mask &= ~ARMV8_PMU_EVTYPE_EVENT;
>         mask |= kvm_pmu_event_mask(vcpu->kvm);
>
> -       reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -             ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
> +       reg = counter_index_to_evtreg(select_idx);
>
>         __vcpu_sys_reg(vcpu, reg) = data & mask;
>
> --
> 2.34.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
