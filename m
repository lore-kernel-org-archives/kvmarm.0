Return-Path: <SRS0=ZPOc=UJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C26C31E40
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jun 2019 16:05:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E66220820
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jun 2019 16:05:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E66220820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA9F84A508;
	Mon, 10 Jun 2019 12:05:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iJioW-EBGRep; Mon, 10 Jun 2019 12:05:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FBA34A509;
	Mon, 10 Jun 2019 12:05:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D2254A507
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jun 2019 12:05:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3R7U2hnUggqG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jun 2019 12:05:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 599F34A4F7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jun 2019 12:05:27 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2011344;
 Mon, 10 Jun 2019 09:05:26 -0700 (PDT)
Received: from [10.1.196.93] (en101.cambridge.arm.com [10.1.196.93])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E941F3F246;
 Mon, 10 Jun 2019 09:05:25 -0700 (PDT)
Subject: Re: [PATCH v8 6/6] KVM: arm/arm64: support chained PMU counters
To: andrew.murray@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com
References: <20190522153019.18645-1-andrew.murray@arm.com>
 <20190522153019.18645-7-andrew.murray@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <72be95b6-e34b-2a04-d503-10399da09afc@arm.com>
Date: Mon, 10 Jun 2019 17:05:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190522153019.18645-7-andrew.murray@arm.com>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Andrew,

> @@ -398,27 +531,43 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>   
>   	/* Software increment event does't need to be backed by a perf event */
>   	if (eventsel == ARMV8_PMUV3_PERFCTR_SW_INCR &&
> -	    select_idx != ARMV8_PMU_CYCLE_IDX)
> +	    pmc->idx != ARMV8_PMU_CYCLE_IDX)
>   		return;
>   
>   	memset(&attr, 0, sizeof(struct perf_event_attr));
>   	attr.type = PERF_TYPE_RAW;
>   	attr.size = sizeof(attr);
>   	attr.pinned = 1;
> -	attr.disabled = !kvm_pmu_counter_is_enabled(vcpu, select_idx);
> +	attr.disabled = !kvm_pmu_counter_is_enabled(vcpu, pmc->idx);
>   	attr.exclude_user = data & ARMV8_PMU_EXCLUDE_EL0 ? 1 : 0;
>   	attr.exclude_kernel = data & ARMV8_PMU_EXCLUDE_EL1 ? 1 : 0;
>   	attr.exclude_hv = 1; /* Don't count EL2 events */
>   	attr.exclude_host = 1; /* Don't count host events */
> -	attr.config = (select_idx == ARMV8_PMU_CYCLE_IDX) ?
> +	attr.config = (pmc->idx == ARMV8_PMU_CYCLE_IDX) ?
>   		ARMV8_PMUV3_PERFCTR_CPU_CYCLES : eventsel;
>   
> -	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
> -	/* The initial sample period (overflow count) of an event. */
> -	attr.sample_period = (-counter) & GENMASK(31, 0);
> +	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
> +
> +	if (kvm_pmu_idx_has_chain_evtype(vcpu, pmc->idx)) {
> +		/**
> +		 * The initial sample period (overflow count) of an event. For
> +		 * chained counters we only support overflow interrupts on the
> +		 * high counter.
> +		 */
> +		attr.sample_period = (-counter) & GENMASK(63, 0);
> +		event = perf_event_create_kernel_counter(&attr, -1, current,
> +							 kvm_pmu_perf_overflow,
> +							 pmc + 1);
>   
> -	event = perf_event_create_kernel_counter(&attr, -1, current,
> +		if (kvm_pmu_counter_is_enabled(vcpu, pmc->idx + 1))
> +			attr.config1 |= PERF_ATTR_CFG1_KVM_PMU_CHAINED;
> +	} else {
> +		/* The initial sample period (overflow count) of an event. */
> +		attr.sample_period = (-counter) & GENMASK(31, 0);
> +		event = perf_event_create_kernel_counter(&attr, -1, current,
>   						 kvm_pmu_perf_overflow, pmc);
> +	}
> +

If this was the Cycle counter and t he PMCR_LC was set, shouldn't we be using
64bit mask here ? We fall back to using the Cycle counter in 64bit mode for
"normal" (read guest) kernel. So shouldn't we reflect that here ?

Rest looks fine to me.

Suzuki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
