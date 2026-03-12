Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3422459EA
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 22:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773355065; cv=none; b=uC9LMO1HrAq6Ie+vy5jWTQgbNJYfi5ppiUDUMv/GvtvhjAf4SOcepZyiSPC71CP+Xd8cbhItVC1J/MksQZXr8SuNQLv0hVUoh3eQyNsBjD71bmCSzK6cZEfEqdEA6hA5q5b4h8ydTRgmaSMSCqLQXFfgmUN5eBdFYvnY2d/zulM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773355065; c=relaxed/simple;
	bh=riRdHtbC6MOlF1LQ1+Xi70vycwoUYV3bcD9E2Zuu6NY=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=qlgf8RrC4nW10TfoAG/uZ/aqXge2jEXMRciH3q/2q3jm9nhtqpDGwTifJKBIVZ+bcUR+QS+Qmy5GKZvZviLVpNhCvzfKQZtLK7wP9K5EqKvHKAGcTV53VMFJnZeuIdnfz99zxE+W51eYYBSFw6rlyVZQI9s2HxGgrhF7Fdjl9K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DIJR0yN+; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DIJR0yN+"
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-40ea48ccbd2so6257398fac.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 15:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773355061; x=1773959861; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BOQPFUygErdEhR+VhLQ8d5SqWsIL2z8SybdB1Lqp5qg=;
        b=DIJR0yN+xjG1jHkRzY+Hoq+na2i1UON+zRwSfMn5DTxBwxBZgP66fQ7voV2evlu3a5
         93fM7rkcLrlBk9YhTkRCjGuLxPGkHlsyIk4FxGZ4qugp7PNjHcpRYfBnwZqHb1J4svcM
         obJ8AhiX7yzm/CikV0jiR1Idl2Kl36LvBaWqCnrSlt4s61UHb84XxDCFv54FAhEiVBJn
         3vJa3YyJ2rEowEimGi/eqyTIfGfiYPhjjotqT5KCFZTIKwdWkYCyKXM7kI1qtWneowsK
         E4LbXqIaOUDFkF0a9PfVtE4aBtYg9iFAwo/FgNZ12U/YgXXMbLPHDzu94jXqb5ZwKK3S
         wf7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773355061; x=1773959861;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BOQPFUygErdEhR+VhLQ8d5SqWsIL2z8SybdB1Lqp5qg=;
        b=ryn2O3eRbDd8KpgbHftcKvi5/CAOrrqxlIXTj3KWTCipx9FU+D4FwcFyScuMfgI5Rh
         5pPkucxgUVuWUtEKrEapXV1T1ZqbM+E/oj9IMYOAvGo4S/IqJCTlIJt6P0HGv2lM2WRY
         gmIKwXaaMxr01WDKTNA15yYKBRwh1cBgxCV9Yd8fwvUZpGl3XjmT4SuSe6ItnYr96kkx
         eoRFYfYEEHL3tehHa02E7Oq4WIsnaV8wxF26fbqKTqXJnHJjMJKY+jOi4Db3+5/aME/K
         P/zt4d+GM9HDjestQu4MuDbca1nD1gAq7wkmPV8Khe7gYWZ3G/+qk91UAMpMFqDgz7qc
         fWCQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4d8F3WHZaiNgOeAPoj/91DSChdrw7uOvNNxWwDk4Tl2XNpecbeh+afVWZlE9Xm13x55Lk5Fc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7bpP+ONI/fJNWESAmIuXo6mpITGVLzMz7nLdSEygxXOpI92fc
	aZKEDbmvMp/LrUYnQnIOniU4SQohSxC/WATPck+gGK4d2o3rFYjQ1VKg+dZlkeY3AhnKnTFR2VM
	3syj0+t7WZN/6t9qLGPI3Yf0KkQ==
X-Received: from iobif40.prod.google.com ([2002:a05:6602:1e28:b0:960:f5a:2cea])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:228b:b0:662:f8bd:fc9 with SMTP id 006d021491bc7-67bdaa2ddeamr684027eaf.41.1773355061163;
 Thu, 12 Mar 2026 15:37:41 -0700 (PDT)
Date: Thu, 12 Mar 2026 22:37:40 +0000
In-Reply-To: <a75924dd-0fa7-4574-837c-1778366195a6@linaro.org> (message from
 James Clark on Wed, 11 Mar 2026 17:45:55 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntfr64oerv.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v6 04/19] perf: arm_pmuv3: Introduce method to partition
 the PMU
From: Colton Lewis <coltonlewis@google.com>
To: James Clark <james.clark@linaro.org>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

James Clark <james.clark@linaro.org> writes:

> On 09/02/2026 10:13 pm, Colton Lewis wrote:
>> For PMUv3, the register field MDCR_EL2.HPMN partitiones the PMU
>> counters into two ranges where counters 0..HPMN-1 are accessible by
>> EL1 and, if allowed, EL0 while counters HPMN..N are only accessible by
>> EL2.

>> Create module parameter reserved_host_counters to reserve a number of
>> counters for the host. This number is set at boot because the perf
>> subsystem assumes the number of counters will not change after the PMU
>> is probed.

>> Introduce the function armv8pmu_partition() to modify the PMU driver's
>> cntr_mask of available counters to exclude the counters being reserved
>> for the guest and record reserved_guest_counters as the maximum
>> allowable value for HPMN.

>> Due to the difficulty this feature would create for the driver running
>> in nVHE mode, partitioning is only allowed in VHE mode. In order to
>> support a partitioning on nVHE we'd need to explicitly disable guest
>> counters on every exit and reset HPMN to place all counters in the
>> first range.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>    arch/arm/include/asm/arm_pmuv3.h   |  4 ++
>>    arch/arm64/include/asm/arm_pmuv3.h |  5 ++
>>    arch/arm64/kvm/Makefile            |  2 +-
>>    arch/arm64/kvm/pmu-direct.c        | 22 +++++++++
>>    drivers/perf/arm_pmuv3.c           | 78 +++++++++++++++++++++++++++++-
>>    include/kvm/arm_pmu.h              |  8 +++
>>    include/linux/perf/arm_pmu.h       |  1 +
>>    7 files changed, 117 insertions(+), 3 deletions(-)
>>    create mode 100644 arch/arm64/kvm/pmu-direct.c

>> diff --git a/arch/arm/include/asm/arm_pmuv3.h  
>> b/arch/arm/include/asm/arm_pmuv3.h
>> index 2ec0e5e83fc98..154503f054886 100644
>> --- a/arch/arm/include/asm/arm_pmuv3.h
>> +++ b/arch/arm/include/asm/arm_pmuv3.h
>> @@ -221,6 +221,10 @@ static inline bool kvm_pmu_counter_deferred(struct  
>> perf_event_attr *attr)
>>    	return false;
>>    }

>> +static inline bool has_host_pmu_partition_support(void)
>> +{
>> +	return false;
>> +}
>>    static inline bool kvm_set_pmuserenr(u64 val)
>>    {
>>    	return false;
>> diff --git a/arch/arm64/include/asm/arm_pmuv3.h  
>> b/arch/arm64/include/asm/arm_pmuv3.h
>> index cf2b2212e00a2..27c4d6d47da31 100644
>> --- a/arch/arm64/include/asm/arm_pmuv3.h
>> +++ b/arch/arm64/include/asm/arm_pmuv3.h
>> @@ -171,6 +171,11 @@ static inline bool pmuv3_implemented(int pmuver)
>>    		 pmuver == ID_AA64DFR0_EL1_PMUVer_NI);
>>    }

>> +static inline bool is_pmuv3p1(int pmuver)
>> +{
>> +	return pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P1;
>> +}
>> +
>>    static inline bool is_pmuv3p4(int pmuver)
>>    {
>>    	return pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P4;
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 3ebc0570345cc..baf0f296c0e53 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -26,7 +26,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o  
>> pvtime.o \
>>    	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
>>    	 vgic/vgic-v5.o

>> -kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
>> +kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu-direct.o pmu.o
>>    kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
>>    kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o

>> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
>> new file mode 100644
>> index 0000000000000..74e40e4915416
>> --- /dev/null
>> +++ b/arch/arm64/kvm/pmu-direct.c
>> @@ -0,0 +1,22 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2025 Google LLC
>> + * Author: Colton Lewis <coltonlewis@google.com>
>> + */
>> +
>> +#include <linux/kvm_host.h>
>> +
>> +#include <asm/arm_pmuv3.h>
>> +
>> +/**
>> + * has_host_pmu_partition_support() - Determine if partitioning is  
>> possible
>> + *
>> + * Partitioning is only supported in VHE mode with PMUv3
>> + *
>> + * Return: True if partitioning is possible, false otherwise
>> + */
>> +bool has_host_pmu_partition_support(void)
>> +{
>> +	return has_vhe() &&
>> +		system_supports_pmuv3();
>> +}
>> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
>> index 8d3b832cd633a..798c93678e97c 100644
>> --- a/drivers/perf/arm_pmuv3.c
>> +++ b/drivers/perf/arm_pmuv3.c
>> @@ -42,6 +42,13 @@
>>    #define ARMV8_THUNDER_PERFCTR_L1I_CACHE_PREF_ACCESS		0xEC
>>    #define ARMV8_THUNDER_PERFCTR_L1I_CACHE_PREF_MISS		0xED

>> +static int reserved_host_counters __read_mostly = -1;
>> +int armv8pmu_max_guest_counters = -1;
>> +
>> +module_param(reserved_host_counters, int, 0);
>> +MODULE_PARM_DESC(reserved_host_counters,
>> +		 "PMU Partition: -1 = No partition; +N = Reserve N counters for the  
>> host");
>> +
>>    /*
>>     * ARMv8 Architectural defined events, not all of these may
>>     * be supported on any given implementation. Unsupported events will
>> @@ -532,6 +539,11 @@ static void armv8pmu_pmcr_write(u64 val)
>>    	write_pmcr(val);
>>    }

>> +static u64 armv8pmu_pmcr_n_read(void)
>> +{
>> +	return FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read());
>> +}
>> +
>>    static int armv8pmu_has_overflowed(u64 pmovsr)
>>    {
>>    	return !!(pmovsr & ARMV8_PMU_OVERFLOWED_MASK);
>> @@ -1309,6 +1321,61 @@ struct armv8pmu_probe_info {
>>    	bool present;
>>    };

>> +/**
>> + * armv8pmu_reservation_is_valid() - Determine if reservation is allowed
>> + * @host_counters: Number of host counters to reserve
>> + *
>> + * Determine if the number of host counters in the argument is an
>> + * allowed reservation, 0 to NR_COUNTERS inclusive.
>> + *
>> + * Return: True if reservation allowed, false otherwise
>> + */
>> +static bool armv8pmu_reservation_is_valid(int host_counters)
>> +{
>> +	return host_counters >= 0 &&
>> +		host_counters <= armv8pmu_pmcr_n_read();
>> +}
>> +
>> +/**
>> + * armv8pmu_partition() - Partition the PMU
>> + * @pmu: Pointer to pmu being partitioned
>> + * @host_counters: Number of host counters to reserve
>> + *
>> + * Partition the given PMU by taking a number of host counters to
>> + * reserve and, if it is a valid reservation, recording the
>> + * corresponding HPMN value in the max_guest_counters field of the PMU  
>> and
>> + * clearing the guest-reserved counters from the counter mask.
>> + *
>> + * Return: 0 on success, -ERROR otherwise
>> + */
>> +static int armv8pmu_partition(struct arm_pmu *pmu, int host_counters)
>> +{
>> +	u8 nr_counters;
>> +	u8 hpmn;
>> +
>> +	if (!armv8pmu_reservation_is_valid(host_counters)) {
>> +		pr_err("PMU partition reservation of %d host counters is not valid",  
>> host_counters);
>> +		return -EINVAL;
>> +	}
>> +
>> +	nr_counters = armv8pmu_pmcr_n_read();
>> +	hpmn = nr_counters - host_counters;
>> +
>> +	pmu->max_guest_counters = hpmn;
>> +	armv8pmu_max_guest_counters = hpmn;
>> +
>> +	bitmap_clear(pmu->cntr_mask, 0, hpmn);
>> +	bitmap_set(pmu->cntr_mask, hpmn, host_counters);
>> +	clear_bit(ARMV8_PMU_CYCLE_IDX, pmu->cntr_mask);
>> +
>> +	if (pmuv3_has_icntr())
>> +		clear_bit(ARMV8_PMU_INSTR_IDX, pmu->cntr_mask);

> We take the fixed instruction counter away from the host here but then
> guest never gets it because AA64DFR1 is RAZ. Probably doesn't need to be
> a blocker to expose the instruction counter, but worth noting that using
> this feature results in losing a counter completely.

> There's a comment above kvm_pmu_guest_counter_mask() that suggests the
> instruction counter is available for guests, which is why I was looking
> here. I think "Compute the bitmask that selects the guest-reserved
> counters ... These are the counters in 0..HPMN and the cycle and
> instruction counters." shouldn't include "instruction counters".

Good point. Early iterations intended to expose the instruction counter
to guests but that was dropped. I will drop it here too.
