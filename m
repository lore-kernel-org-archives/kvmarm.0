Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1F12D8370
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 17:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773251160; cv=none; b=cqwnsAH4hgGsZ6DAJfqwZBszUI4qJVcmnTNR1uAe6WofBijzz8gJi4PfIkKE5ZN5RPQjphYdlj0Rui0wL0lLpPhgEZX6++R2jvnMPyGgfdjbpdUYPflZlJzpswYl/eU95mrtqCiSgoq9PQjuCGyQq3n6wu+K07InTVbJoTgT4Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773251160; c=relaxed/simple;
	bh=rPJK7Se9PvcdUmXRMKMZxkKjCXYOc+dnvl4vUpV52io=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j5vB577c23bIl5EAo77uQQhC3RRLeN7DYkuNhMtvnPYLZ9Kdco6mfVjHOYYlCnwkyipQhiJaTS+H9oKvBEZm1gIjtWxQyKkNO5a6PcipOhTEmj2prs9w10/n2JaMifD/lPKthXerfY8U1RRHrsFtI2DJbdNRJ/NO0mXnfWA1R7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=laXS44UK; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="laXS44UK"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48539cbb7b1so590445e9.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1773251157; x=1773855957; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/VIaQVzDDm7FRkzFhPyJ+ipxFALXzUWH3qkbbvO8u0Q=;
        b=laXS44UKoC5Xt8S0oIohNBvPleYiBLV/nDB5xduuHcmQmQZa2e2OCku0eT+Kbarg8I
         1A7judlS+ZUSKMEgiIsuJnI9DXfaPTKflBDAnYR0Ow9yd+n+5JD9RQPKONXC/A/aKPOp
         yImGuiOo0kxvPlEYrG+Rp6sBTCDWRooD3N8S+SCLHtBf702wGmhwm80vbYy6p/L0AhN3
         3KxahomFyAkNJvbdmiU3nfUJd7olhP7h4EWDEnCzfdUOKrhkYUa53l0VIG3O4yGhZy2o
         Froi4uYd5hSqpw7iPT5FKbdswf/40CXpA9nM4nejRnatZ9qHT4AE1uvdZcRchrBj+oaI
         GEfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773251157; x=1773855957;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/VIaQVzDDm7FRkzFhPyJ+ipxFALXzUWH3qkbbvO8u0Q=;
        b=YgGlQHseob03JiGBMTzAGXWwdrHBxPFlAXZyxbXDmG40OOWrWBvDUC77gz9P/QZVdc
         4wN2S+kXo1CT37GzeoM6IQDA61tA6mjQQEHCIv8EeDmgaAaq1yxtdsJRQCLyy2ME9kI6
         2UVbfOx+BAfJzkHOdCsVSxAfhKGs+QmgnQxuZG5ghskarKnxxAYUfTVDFZDWjpePtlWp
         gye4y6/s+Exk538VlqRV8+cK18gt0y6QBT/Z1PS7QxyrjIwD53ccc/5Ip/3RiHvPYEcm
         vIwwEUvU3eRfIkEKnMb9FzPtJHKSIyUw66DNznWqL0Imxp5q8QItfHVzZjCE0sRrF1Z6
         8puw==
X-Forwarded-Encrypted: i=1; AJvYcCVvZZwVyWiDKx8a005ikRmctUIlEfEJ1SpNsCt6EgYlyN8AK49jcnpiZjB4PUpc6AFK+pZ1aOc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQl0YZ6BVNGGDi0tCllbUDTihgguSVxNClGgRPJdhJSn+Dti+P
	QvSr9mXJBp6HdHutRGGWeFVra2mlUKnZCplqW2FgqSyOz02BRnNnpP/wMOfhQ0iUg6s=
X-Gm-Gg: ATEYQzweqWNJGXRKgD9TQv6ZhgLICHv6lLMeTSA+cy+T3X9VynaByPaLLjCXjOPUwko
	IuH4ySy6RUGS0zGM8eoA4KwIgjBeG/pqL26GiyxmwH1b8J/daNSY9cl7vzMzy+13IUdGQi0wbGs
	di8ZFfGbr54rNm7ELLtK7JOHxuyL9qRWQdAkvDxMAFojH1dXL2KDJQ2s5WhjlJkVxNC2sx1BBk/
	STuRmfGPl1pQkayWR7H1Yxvj1CMLYxOH6MY8drGkc982XvM+7cZroxGniBj8RLmlyZKa5BY0jBn
	5Lw1ffFvMSJh3ZMW4BEbyhK9LpcSps9QQWZ/0MSIh7ezQO1VMSqLH61kK5b/L3hzFP6Um1Aj8A+
	+ICizQLwiD7fsth+PinoPVw+xtpRynUKsOukAT/23x8y0Jh9b4NTqf4KE+MlgQ1KS9cIv6Mk5g0
	LYjWgiqsQKWMbvwUy1J4waHCzixoX+
X-Received: by 2002:a05:600c:46d3:b0:485:3c66:e230 with SMTP id 5b1f17b1804b1-4854b12ced9mr59198095e9.29.1773251157103;
        Wed, 11 Mar 2026 10:45:57 -0700 (PDT)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b0bff95sm45389575e9.3.2026.03.11.10.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 10:45:56 -0700 (PDT)
Message-ID: <a75924dd-0fa7-4574-837c-1778366195a6@linaro.org>
Date: Wed, 11 Mar 2026 17:45:55 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/19] perf: arm_pmuv3: Introduce method to partition
 the PMU
To: Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>,
 Shuah Khan <shuah@kernel.org>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260209221414.2169465-1-coltonlewis@google.com>
 <20260209221414.2169465-5-coltonlewis@google.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20260209221414.2169465-5-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 09/02/2026 10:13 pm, Colton Lewis wrote:
> For PMUv3, the register field MDCR_EL2.HPMN partitiones the PMU
> counters into two ranges where counters 0..HPMN-1 are accessible by
> EL1 and, if allowed, EL0 while counters HPMN..N are only accessible by
> EL2.
> 
> Create module parameter reserved_host_counters to reserve a number of
> counters for the host. This number is set at boot because the perf
> subsystem assumes the number of counters will not change after the PMU
> is probed.
> 
> Introduce the function armv8pmu_partition() to modify the PMU driver's
> cntr_mask of available counters to exclude the counters being reserved
> for the guest and record reserved_guest_counters as the maximum
> allowable value for HPMN.
> 
> Due to the difficulty this feature would create for the driver running
> in nVHE mode, partitioning is only allowed in VHE mode. In order to
> support a partitioning on nVHE we'd need to explicitly disable guest
> counters on every exit and reset HPMN to place all counters in the
> first range.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>   arch/arm/include/asm/arm_pmuv3.h   |  4 ++
>   arch/arm64/include/asm/arm_pmuv3.h |  5 ++
>   arch/arm64/kvm/Makefile            |  2 +-
>   arch/arm64/kvm/pmu-direct.c        | 22 +++++++++
>   drivers/perf/arm_pmuv3.c           | 78 +++++++++++++++++++++++++++++-
>   include/kvm/arm_pmu.h              |  8 +++
>   include/linux/perf/arm_pmu.h       |  1 +
>   7 files changed, 117 insertions(+), 3 deletions(-)
>   create mode 100644 arch/arm64/kvm/pmu-direct.c
> 
> diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
> index 2ec0e5e83fc98..154503f054886 100644
> --- a/arch/arm/include/asm/arm_pmuv3.h
> +++ b/arch/arm/include/asm/arm_pmuv3.h
> @@ -221,6 +221,10 @@ static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
>   	return false;
>   }
>   
> +static inline bool has_host_pmu_partition_support(void)
> +{
> +	return false;
> +}
>   static inline bool kvm_set_pmuserenr(u64 val)
>   {
>   	return false;
> diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
> index cf2b2212e00a2..27c4d6d47da31 100644
> --- a/arch/arm64/include/asm/arm_pmuv3.h
> +++ b/arch/arm64/include/asm/arm_pmuv3.h
> @@ -171,6 +171,11 @@ static inline bool pmuv3_implemented(int pmuver)
>   		 pmuver == ID_AA64DFR0_EL1_PMUVer_NI);
>   }
>   
> +static inline bool is_pmuv3p1(int pmuver)
> +{
> +	return pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P1;
> +}
> +
>   static inline bool is_pmuv3p4(int pmuver)
>   {
>   	return pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P4;
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 3ebc0570345cc..baf0f296c0e53 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -26,7 +26,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>   	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
>   	 vgic/vgic-v5.o
>   
> -kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
> +kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu-direct.o pmu.o
>   kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
>   kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
>   
> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> new file mode 100644
> index 0000000000000..74e40e4915416
> --- /dev/null
> +++ b/arch/arm64/kvm/pmu-direct.c
> @@ -0,0 +1,22 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2025 Google LLC
> + * Author: Colton Lewis <coltonlewis@google.com>
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +#include <asm/arm_pmuv3.h>
> +
> +/**
> + * has_host_pmu_partition_support() - Determine if partitioning is possible
> + *
> + * Partitioning is only supported in VHE mode with PMUv3
> + *
> + * Return: True if partitioning is possible, false otherwise
> + */
> +bool has_host_pmu_partition_support(void)
> +{
> +	return has_vhe() &&
> +		system_supports_pmuv3();
> +}
> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index 8d3b832cd633a..798c93678e97c 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -42,6 +42,13 @@
>   #define ARMV8_THUNDER_PERFCTR_L1I_CACHE_PREF_ACCESS		0xEC
>   #define ARMV8_THUNDER_PERFCTR_L1I_CACHE_PREF_MISS		0xED
>   
> +static int reserved_host_counters __read_mostly = -1;
> +int armv8pmu_max_guest_counters = -1;
> +
> +module_param(reserved_host_counters, int, 0);
> +MODULE_PARM_DESC(reserved_host_counters,
> +		 "PMU Partition: -1 = No partition; +N = Reserve N counters for the host");
> +
>   /*
>    * ARMv8 Architectural defined events, not all of these may
>    * be supported on any given implementation. Unsupported events will
> @@ -532,6 +539,11 @@ static void armv8pmu_pmcr_write(u64 val)
>   	write_pmcr(val);
>   }
>   
> +static u64 armv8pmu_pmcr_n_read(void)
> +{
> +	return FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read());
> +}
> +
>   static int armv8pmu_has_overflowed(u64 pmovsr)
>   {
>   	return !!(pmovsr & ARMV8_PMU_OVERFLOWED_MASK);
> @@ -1309,6 +1321,61 @@ struct armv8pmu_probe_info {
>   	bool present;
>   };
>   
> +/**
> + * armv8pmu_reservation_is_valid() - Determine if reservation is allowed
> + * @host_counters: Number of host counters to reserve
> + *
> + * Determine if the number of host counters in the argument is an
> + * allowed reservation, 0 to NR_COUNTERS inclusive.
> + *
> + * Return: True if reservation allowed, false otherwise
> + */
> +static bool armv8pmu_reservation_is_valid(int host_counters)
> +{
> +	return host_counters >= 0 &&
> +		host_counters <= armv8pmu_pmcr_n_read();
> +}
> +
> +/**
> + * armv8pmu_partition() - Partition the PMU
> + * @pmu: Pointer to pmu being partitioned
> + * @host_counters: Number of host counters to reserve
> + *
> + * Partition the given PMU by taking a number of host counters to
> + * reserve and, if it is a valid reservation, recording the
> + * corresponding HPMN value in the max_guest_counters field of the PMU and
> + * clearing the guest-reserved counters from the counter mask.
> + *
> + * Return: 0 on success, -ERROR otherwise
> + */
> +static int armv8pmu_partition(struct arm_pmu *pmu, int host_counters)
> +{
> +	u8 nr_counters;
> +	u8 hpmn;
> +
> +	if (!armv8pmu_reservation_is_valid(host_counters)) {
> +		pr_err("PMU partition reservation of %d host counters is not valid", host_counters);
> +		return -EINVAL;
> +	}
> +
> +	nr_counters = armv8pmu_pmcr_n_read();
> +	hpmn = nr_counters - host_counters;
> +
> +	pmu->max_guest_counters = hpmn;
> +	armv8pmu_max_guest_counters = hpmn;
> +
> +	bitmap_clear(pmu->cntr_mask, 0, hpmn);
> +	bitmap_set(pmu->cntr_mask, hpmn, host_counters);
> +	clear_bit(ARMV8_PMU_CYCLE_IDX, pmu->cntr_mask);
> +
> +	if (pmuv3_has_icntr())
> +		clear_bit(ARMV8_PMU_INSTR_IDX, pmu->cntr_mask);

We take the fixed instruction counter away from the host here but then 
guest never gets it because AA64DFR1 is RAZ. Probably doesn't need to be 
a blocker to expose the instruction counter, but worth noting that using 
this feature results in losing a counter completely.

There's a comment above kvm_pmu_guest_counter_mask() that suggests the 
instruction counter is available for guests, which is why I was looking 
here. I think "Compute the bitmask that selects the guest-reserved 
counters ... These are the counters in 0..HPMN and the cycle and 
instruction counters." shouldn't include "instruction counters".

