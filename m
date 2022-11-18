Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0707C
	for <kvmarm@lists.linux.dev>; Fri, 18 Nov 2022 07:45:40 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id y13so4147884pfp.7
        for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 23:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Gdi9Y0gA2RIvhSzWh83jBN+VndNjkNvj2Yl5/Jq0Qwc=;
        b=Ixr/QfKKvVCY/z813TIOr2kixg8g7Q2tYoA9hXcbYVMP7l60PiwC2W1YE+i9vo4igC
         0CNk3c/yZvjtdnx4JxEGIg5eCNPr8EZ2LzHN8wtYoQ0RDrldnlwqsZ9fsZuT0sXD+KAZ
         MpRwp/AqLjIitmtJtFiTYwszhdw813n7uPfd6nA/Qvecp5C6+KwHJ2JX9hf9flTg4LdS
         Qmpu2P9BqWLb7X9m6N246pZXLBY3Eu0Gxd9JZbWKKOyZ3MMJgUQlTxVogDBWNE8+IL9h
         z/17pZe47npvmxk3P1/pXsnE/TVlDDb9H8tslmpdYGIs3vVyNnKBUcP/9haUGtaQeJ5n
         HNZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gdi9Y0gA2RIvhSzWh83jBN+VndNjkNvj2Yl5/Jq0Qwc=;
        b=xQjmoZFAtLnohs+QyV9enghLJsBRtAy44Yt3izjJJauqIoEvxONSIrT54pVFzTpKWR
         bMJwY0Me35JRYwM124k0aTlNZ3gLRN9u8ZLLfqlnvTHM2U7uMbTOUGvRxatYSw8a9PT4
         PkC1mMKuwgnZ2Hk2M7CrMmWErKzSAUS1BRpI6RCNsAo6WGu8ZoMb2Dl9xt/Jki+lxkjk
         w/gbAFzUW2oMbFAFbcle0zTHGPU+PjRyqQRCOQrIFlA+5jF6XlauJH5lfgts+kc9x3Ub
         yQZbwHON0GJ70Thrt+L7j5UhiFdCC6L6l/OM+4fRb+QQsgOeiGAtPc+pPbNTt0x/DJsz
         7uAQ==
X-Gm-Message-State: ANoB5pmvmLxYLESNXDIj5yKLg/+fJcawhvDjGBIwBQrHrw2Vakbij/00
	lvFhw/tiy5FRZSSVdDBPCJtdks2RPL0U6dz4jpGPJQ==
X-Google-Smtp-Source: AA0mqf5+Kmp2LJTTHcEFtRf3v9oCJzsEHfPTrRYloeoM4dpAxHCbuDwGxEccdUkQgFawYVyPt2I5kRsljmJH0+N9Z6Y=
X-Received: by 2002:a63:e509:0:b0:474:4380:cca6 with SMTP id
 r9-20020a63e509000000b004744380cca6mr5598521pgh.229.1668757539573; Thu, 17
 Nov 2022 23:45:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org> <20221113163832.3154370-10-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-10-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 17 Nov 2022 23:45:23 -0800
Message-ID: <CAAeT=FzvGPs04N8=y2pjBxv_HTgQHwRN8hEsyheu0bi+WJzRQQ@mail.gmail.com>
Subject: Re: [PATCH v4 09/16] KVM: arm64: PMU: Do not let AArch32 change the
 counters' top 32 bits
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221118074523.iXBgpuMqOU4_yvaVDMPzci_UWNq5041Iw2xOiV_0qM4@z>

Hi Marc,

On Sun, Nov 13, 2022 at 8:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Even when using PMUv3p5 (which implies 64bit counters), there is
> no way for AArch32 to write to the top 32 bits of the counters.
> The only way to influence these bits (other than by counting
> events) is by writing PMCR.P==1.
>
> Make sure we obey the architecture and preserve the top 32 bits
> on a counter update.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 35 +++++++++++++++++++++++++++--------
>  1 file changed, 27 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index ea0c8411641f..419e5e0a13d0 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -119,13 +119,8 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>         return counter;
>  }
>
> -/**
> - * kvm_pmu_set_counter_value - set PMU counter value
> - * @vcpu: The vcpu pointer
> - * @select_idx: The counter index
> - * @val: The counter value
> - */
> -void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
> +static void kvm_pmu_set_counter(struct kvm_vcpu *vcpu, u64 select_idx, u64 val,
> +                               bool force)
>  {
>         u64 reg;
>
> @@ -135,12 +130,36 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>         kvm_pmu_release_perf_event(&vcpu->arch.pmu.pmc[select_idx]);
>
>         reg = counter_index_to_reg(select_idx);
> +
> +       if (vcpu_mode_is_32bit(vcpu) && select_idx != ARMV8_PMU_CYCLE_IDX &&
> +           !force) {
> +               /*
> +                * Even with PMUv3p5, AArch32 cannot write to the top
> +                * 32bit of the counters. The only possible course of
> +                * action is to use PMCR.P, which will reset them to
> +                * 0 (the only use of the 'force' parameter).
> +                */
> +               val  = lower_32_bits(val);
> +               val |= upper_32_bits(__vcpu_sys_reg(vcpu, reg));

Shouldn't the result of upper_32_bits() be shifted 32bits left
before ORing (to maintain the upper 32bits of the current value) ?

Thank you,
Reiji

> +       }
> +
>         __vcpu_sys_reg(vcpu, reg) = val;
>
>         /* Recreate the perf event to reflect the updated sample_period */
>         kvm_pmu_create_perf_event(vcpu, select_idx);
>  }
>
> +/**
> + * kvm_pmu_set_counter_value - set PMU counter value
> + * @vcpu: The vcpu pointer
> + * @select_idx: The counter index
> + * @val: The counter value
> + */
> +void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
> +{
> +       kvm_pmu_set_counter(vcpu, select_idx, val, false);
> +}
> +
>  /**
>   * kvm_pmu_release_perf_event - remove the perf event
>   * @pmc: The PMU counter pointer
> @@ -533,7 +552,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
>                 unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
>                 mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
>                 for_each_set_bit(i, &mask, 32)
> -                       kvm_pmu_set_counter_value(vcpu, i, 0);
> +                       kvm_pmu_set_counter(vcpu, i, 0, true);
>         }
>  }
>
> --
> 2.34.1
>
