Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE3820FD
	for <kvmarm@lists.linux.dev>; Fri, 18 Nov 2022 06:17:14 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id p21so3719954plr.7
        for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 22:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=K/YfUYuMh9A6QijqTGPU5r/ye3faTe5NtfijCRna7t1DEu5t92lR4vIXpZ9WlZkmLF
         6g7Wsixm8Ib9Y4oM3cVi8A+IThG7hTYJT2BlUBNiaFerzFaWp9GyDxfdmhr2mEaTAQgS
         MLOUHzSoefMsge0J/Xldck0gNTO+iRZSPWm2okw7Ev6aBT49Q4f43vLUnZ4e6wub3jpA
         0FHGQKN0XRJuah47fJyjptExj2DuS5rEreCAb0Unb2Qrm7is1+s9+xLqJTG1l2gbt1nY
         /PCqHr+hfgb2H6ux/5Qph81T+nZC1tEJEFmR93mALqXoe3fm4zC6mRm42Xam7B5Zp14V
         P3bQ==
X-Gm-Message-State: ANoB5pl9g1th6BEI4StWA+pq/yB/hjinfCC0y3orUTXloIH8iO35+CpQ
	TTvLzF/95qy78rCNkXHD5e8jsG3RcCunDqDvOrEybA==
X-Google-Smtp-Source: AA0mqf6F3NyThYJD8zv8B8XMOE2kYz0CUcnIuV6DoYi9y5eEjTe+8F6Mn2Uq93dJuL2v0dYfk/N2/a1lsRjiy2L+4Kw=
X-Received: by 2002:a17:90a:ab84:b0:213:343:9873 with SMTP id
 n4-20020a17090aab8400b0021303439873mr12284511pjq.102.1668752233721; Thu, 17
 Nov 2022 22:17:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-8-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-8-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 17 Nov 2022 22:16:57 -0800
Message-ID: <CAAeT=FysJPMs5mG1E02rMcGtjULb7MviZr6RE699x_a=LZNK6w@mail.gmail.com>
Subject: Re: [PATCH v4 07/16] KVM: arm64: PMU: Add counter_index_to_*reg() helpers
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221118061657.n8KhmnpX6h8UoEf0VAht6oeBZtShSUc3XX-oVrbzks8@z>

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
