Return-Path: <SRS0=Fx/F=SN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0C1C10F13
	for <kvmarm@archiver.kernel.org>; Thu, 11 Apr 2019 22:25:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 42FD22146F
	for <kvmarm@archiver.kernel.org>; Thu, 11 Apr 2019 22:25:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42FD22146F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88D9C4A4C9;
	Thu, 11 Apr 2019 18:25:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0fz92z1xQpci; Thu, 11 Apr 2019 18:25:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FFEA4A4AD;
	Thu, 11 Apr 2019 18:25:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EE464A48C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Apr 2019 18:25:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IVF-cyraD2A6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Apr 2019 18:25:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25B2B4A3BF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Apr 2019 18:25:51 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63168374;
 Thu, 11 Apr 2019 15:25:50 -0700 (PDT)
Received: from [10.37.12.253] (unknown [10.37.12.253])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A5973F718;
 Thu, 11 Apr 2019 15:25:48 -0700 (PDT)
Subject: Re: [PATCH v13 4/8] arm64: arm_pmu: Add !VHE support for
 exclude_host/exclude_guest attributes
To: andrew.murray@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com,
 catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com
References: <20190409192217.23459-1-andrew.murray@arm.com>
 <20190409192217.23459-5-andrew.murray@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <1cd8d927-6cb9-feed-86ef-cb7598428966@arm.com>
Date: Thu, 11 Apr 2019 23:28:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20190409192217.23459-5-andrew.murray@arm.com>
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
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190411222804.UhFML79_Juxgtn6936_AlI4u20eJl8fSwZ67fyykjTg@z>

On 04/09/2019 08:22 PM, Andrew Murray wrote:
> Add support for the :G and :H attributes in perf by handling the
> exclude_host/exclude_guest event attributes.
> 
> We notify KVM of counters that we wish to be enabled or disabled on
> guest entry/exit and thus defer from starting or stopping events based
> on their event attributes.
> 
> With !VHE we switch the counters between host/guest at EL2. We are able
> to eliminate counters counting host events on the boundaries of guest
> entry/exit when using :G by filtering out EL2 for exclude_host. When
> using !exclude_hv there is a small blackout window at the guest
> entry/exit where host events are not captured.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> Acked-by: Will Deacon <will.deacon@arm.com>
> ---



>   arch/arm64/kernel/perf_event.c | 43 ++++++++++++++++++++++++++++------
>   1 file changed, 36 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index cccf4fc86d67..6bb28aaf5aea 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -26,6 +26,7 @@
>   
>   #include <linux/acpi.h>
>   #include <linux/clocksource.h>
> +#include <linux/kvm_host.h>
>   #include <linux/of.h>
>   #include <linux/perf/arm_pmu.h>
>   #include <linux/platform_device.h>
> @@ -528,11 +529,21 @@ static inline int armv8pmu_enable_counter(int idx)
>   
>   static inline void armv8pmu_enable_event_counter(struct perf_event *event)
>   {
> +	struct perf_event_attr *attr = &event->attr;
>   	int idx = event->hw.idx;
> +	u32 counter_bits = BIT(ARMV8_IDX_TO_COUNTER(idx));
>   
> -	armv8pmu_enable_counter(idx);
>   	if (armv8pmu_event_is_chained(event))
> -		armv8pmu_enable_counter(idx - 1);
> +		counter_bits |= BIT(ARMV8_IDX_TO_COUNTER(idx - 1));
> +
> +	kvm_set_pmu_events(counter_bits, attr);
> +
> +	/* We rely on the hypervisor switch code to enable guest counters */
> +	if (!kvm_pmu_counter_deferred(attr)) {
> +		armv8pmu_enable_counter(idx);
> +		if (armv8pmu_event_is_chained(event))
> +			armv8pmu_enable_counter(idx - 1);
> +	}
>   }
>   
>   static inline int armv8pmu_disable_counter(int idx)
> @@ -545,11 +556,21 @@ static inline int armv8pmu_disable_counter(int idx)
>   static inline void armv8pmu_disable_event_counter(struct perf_event *event)
>   {
>   	struct hw_perf_event *hwc = &event->hw;
> +	struct perf_event_attr *attr = &event->attr;
>   	int idx = hwc->idx;
> +	u32 counter_bits = BIT(ARMV8_IDX_TO_COUNTER(idx));
>   
>   	if (armv8pmu_event_is_chained(event))
> -		armv8pmu_disable_counter(idx - 1);
> -	armv8pmu_disable_counter(idx);
> +		counter_bits |= BIT(ARMV8_IDX_TO_COUNTER(idx - 1));
> +
> +	kvm_clr_pmu_events(counter_bits);
> +
> +	/* We rely on the hypervisor switch code to disable guest counters */
> +	if (!kvm_pmu_counter_deferred(attr)) {
> +		if (armv8pmu_event_is_chained(event))
> +			armv8pmu_disable_counter(idx - 1);
> +		armv8pmu_disable_counter(idx);
> +	}
>   }
>   
>   static inline int armv8pmu_enable_intens(int idx)
> @@ -829,11 +850,16 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
>   		if (!attr->exclude_kernel)
>   			config_base |= ARMV8_PMU_INCLUDE_EL2;
>   	} else {
> -		if (attr->exclude_kernel)
> -			config_base |= ARMV8_PMU_EXCLUDE_EL1;
> -		if (!attr->exclude_hv)
> +		if (!attr->exclude_hv && !attr->exclude_host)
>   			config_base |= ARMV8_PMU_INCLUDE_EL2;
>   	}
> +
> +	/*
> +	 * Filter out !VHE kernels and guest kernels
> +	 */
> +	if (attr->exclude_kernel)
> +		config_base |= ARMV8_PMU_EXCLUDE_EL1;
> +
>   	if (attr->exclude_user)
>   		config_base |= ARMV8_PMU_EXCLUDE_EL0;
>   
> @@ -863,6 +889,9 @@ static void armv8pmu_reset(void *info)
>   		armv8pmu_disable_intens(idx);
>   	}
>   
> +	/* Clear the counters we flip at guest entry/exit */
> +	kvm_clr_pmu_events(U32_MAX);
> +
>   	/*
>   	 * Initialize & Reset PMNC. Request overflow interrupt for
>   	 * 64 bit cycle counter but cheat in armv8pmu_write_counter().
> 


Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
