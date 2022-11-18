Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6559AC43217
	for <kvmarm@archiver.kernel.org>; Fri, 18 Nov 2022 07:45:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1AF54B8B5;
	Fri, 18 Nov 2022 02:45:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LLvgvA0E4n6i; Fri, 18 Nov 2022 02:45:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93F834B8AD;
	Fri, 18 Nov 2022 02:45:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10BD04B802
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 02:45:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O-7ghkFO3xni for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 02:45:40 -0500 (EST)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9A434B785
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 02:45:40 -0500 (EST)
Received: by mail-pf1-f179.google.com with SMTP id d192so4192215pfd.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2022 23:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=cEKvw0Q5UaCPvnOXnoDBWNWNBCknog/dSF4KBtRfB5+MnGb8sAyQGA+Xg4PbVSgY2a
 tGgrHHG9W35UI1QStrNKiy0Ytycp7v5l8rm1t4AXfG5qxWeSZJ1elOpR15k45I5mvR2l
 wnq57yQBxct/w0W272aEOnLLOKwUX0izbHw5beMdfaGxG9i8hJ10WZ46DMvEEaGKUv9e
 J9Q5KHNIL8H/qNxYxsMK7o1gLHzTjRdpeRm+Vzde9MwiI22LGurAnN4ikAQ5a52dyk60
 nAhAvCT5gPPpNm32e++JKypdL+V5sHmy8bVQXhoO6DOwq0fyu7cKSoMCxDJIgQKPbunN
 os4A==
X-Gm-Message-State: ANoB5pmMq5SN/19fqdTptS0hLnMO+9gBQuP64filJdaTnA3XT7mKkcp6
 0oqeNxDUjAx3/RaKaEAs8hXSpEN204Jqt4XHbYIGYw==
X-Google-Smtp-Source: AA0mqf5+Kmp2LJTTHcEFtRf3v9oCJzsEHfPTrRYloeoM4dpAxHCbuDwGxEccdUkQgFawYVyPt2I5kRsljmJH0+N9Z6Y=
X-Received: by 2002:a63:e509:0:b0:474:4380:cca6 with SMTP id
 r9-20020a63e509000000b004744380cca6mr5598521pgh.229.1668757539573; Thu, 17
 Nov 2022 23:45:39 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-10-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-10-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 17 Nov 2022 23:45:23 -0800
Message-ID: <CAAeT=FzvGPs04N8=y2pjBxv_HTgQHwRN8hEsyheu0bi+WJzRQQ@mail.gmail.com>
Subject: Re: [PATCH v4 09/16] KVM: arm64: PMU: Do not let AArch32 change the
 counters' top 32 bits
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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
