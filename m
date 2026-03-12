Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ED23B388A
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 22:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773355071; cv=none; b=apkxpkdasxq99Y22i5aTBzdd2Hf3yrU8S3H9hufpsQ3y414TUIqUW+GkOLuF/kmZPPl3jS+/07YddqYyQ3KfltBNlebYVFLFjYLjMsjrFSiiJY0jyK3jlutkT1d0g2wCm60lWDi8+k4in4f77M/0u2VqeqgJw0nJCrYnGhVI6Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773355071; c=relaxed/simple;
	bh=cQYwjszy08TiodrYkyFWbdjjy3e59P/5BFD3mR5ghcs=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=BTACbN9hi0bQsTxSVmjJa8geqwDC7JTRlLZlYGFsp3lFuKnGf7nomEveuRBvcZNWbkpo41G6J8p4FfTZVarqd8JodYiRAVsRDS4OZeLNFivDhybhrztuJpHmvRovn1PZJuCfHfU2HlIQda+1JQMRmJySHPS6k/nj7FhMiJG1so4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m24Zps8B; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m24Zps8B"
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7d748bc34cfso13378915a34.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 15:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773355069; x=1773959869; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SmkGviBwoE6ujafdNpWKA+3+jPQC/zPRTGdWWZWDMA0=;
        b=m24Zps8BaEHnlVtYLErSIRskFgZiIAAeTJyljJ2TTKBo34DzE/huBEHumILLMO62Wa
         jwiFBpEKsFtdyr4URc3feSx2OV/OnYuDpBf3RCWjeUneDn0nPvJrc9mYduEeRYh0DecH
         0pdlLc46+ypaO9wQc9QC/PYYUG+QwWzbbXgGXA0xvm6I2HfPGSwBiI6+5R6sqeIuRfl6
         ytJJJs/5KffGEoZPIAzORECF9YUz+1y2DMuLZMAjbeR22Lo1OtEzVnKWPDXJFAkZ/Zmk
         4lh5WFXll4S8CWaVhpy48OLIk07ISzRbCSGPZ0uONoSYKXVgKGEmuuvszmdGwfp6P5ag
         SUNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773355069; x=1773959869;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SmkGviBwoE6ujafdNpWKA+3+jPQC/zPRTGdWWZWDMA0=;
        b=Ruj0LTPPnlIlYDb3qGf8bpCLnPR3vWi+tGum+bqPudeuenIUqkEDyzU6DS7F0APUI7
         Di8bfDeLxO9Ya0wIYqkluclztRsaR9C63ZhZN6bUAEF6ogRKKC8xH3QoSlAYLUBsXA/C
         XPySL6Wv7UWRn9wFepCuTdFevnQA+w/WhLfrtbm7q8Ycpo3ikIyYWK39XdBtHkZTiViM
         yZAlo6vs9Odbph/cJe1HZmgsDlXKO1vP2mRTu8GQNdPYGLBtYP0Ar9dEnlz/nYy2MG5U
         4x6nEs4nHN922P/0fodiLGy1wanaWkqqiiVepUmcrkIQ5yIPbOzVkxObcQW5/kKjCZZM
         Buiw==
X-Forwarded-Encrypted: i=1; AJvYcCXxz2nG25RU6a8P6oWxTUB+FMf4lEQVE10RkmSOIek9X74cfTGPX0KpqkjC6yjQ5kagkH4m0Hs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWxyLGip17QEs1IbKOUPdR9MNK1A9/1b1sJhZwNSdKgfjEcX3E
	rRtM/31SJ0hpPwC+J26RmVOKQeok0E6pQ62OBJYuwUzgFxbsQKTrFo+Glw8sc4tvjlInJvQMvqT
	B1SCmDZ0w/fz3MpdhIwfbf4MhzA==
X-Received: from ilmt3.prod.google.com ([2002:a05:6e02:103:b0:4f6:f377:166a])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:4df3:b0:677:48f4:3c66 with SMTP id 006d021491bc7-67bdaa927d6mr720368eaf.67.1773355068888;
 Thu, 12 Mar 2026 15:37:48 -0700 (PDT)
Date: Thu, 12 Mar 2026 22:37:47 +0000
In-Reply-To: <47592c2d-2b12-4d28-ae5d-9d2f68ec7186@linaro.org> (message from
 James Clark on Wed, 11 Mar 2026 11:59:31 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnteclooero.fsf@coltonlewis-kvm.c.googlers.com>
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

> Hi Colton,

> Couple of minor nits. But this error return value isn't used by the  
> caller.

Fair point. I don't think the caller can do anything with it, so I'll
make the function void (if it still exists in the same form with the
dynamic reservation approach)

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

> And this could be more like 'bool armv8pmu_partitioned'. PMUs will have
> different numbers of counters so it's a bit misleading to have one
> global, and the actual value isn't used either.

I can do that.

>> +
>> +	bitmap_clear(pmu->cntr_mask, 0, hpmn);
>> +	bitmap_set(pmu->cntr_mask, hpmn, host_counters);
>> +	clear_bit(ARMV8_PMU_CYCLE_IDX, pmu->cntr_mask);
>> +
>> +	if (pmuv3_has_icntr())
>> +		clear_bit(ARMV8_PMU_INSTR_IDX, pmu->cntr_mask);
>> +
>> +	pr_info("Partitioned PMU with %d host counters -> %u guest counters",  
>> host_counters, hpmn);
>> +
>> +	return 0;
>> +}
>> +
>>    static void __armv8pmu_probe_pmu(void *info)
>>    {
>>    	struct armv8pmu_probe_info *probe = info;
>> @@ -1323,10 +1390,10 @@ static void __armv8pmu_probe_pmu(void *info)

>>    	cpu_pmu->pmuver = pmuver;
>>    	probe->present = true;
>> +	cpu_pmu->max_guest_counters = -1;

>>    	/* Read the nb of CNTx counters supported from PMNC */
>> -	bitmap_set(cpu_pmu->cntr_mask,
>> -		   0, FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read()));
>> +	bitmap_set(cpu_pmu->cntr_mask, 0, armv8pmu_pmcr_n_read());

>>    	/* Add the CPU cycles counter */
>>    	set_bit(ARMV8_PMU_CYCLE_IDX, cpu_pmu->cntr_mask);
>> @@ -1335,6 +1402,13 @@ static void __armv8pmu_probe_pmu(void *info)
>>    	if (pmuv3_has_icntr())
>>    		set_bit(ARMV8_PMU_INSTR_IDX, cpu_pmu->cntr_mask);

>> +	if (reserved_host_counters >= 0) {
>> +		if (has_host_pmu_partition_support())
>> +			armv8pmu_partition(cpu_pmu, reserved_host_counters);
>> +		else
>> +			pr_err("PMU partition is not supported");
>> +	}
>> +
>>    	pmceid[0] = pmceid_raw[0] = read_pmceid0();
>>    	pmceid[1] = pmceid_raw[1] = read_pmceid1();

>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> index 24a471cf59d56..e7172db1e897d 100644
>> --- a/include/kvm/arm_pmu.h
>> +++ b/include/kvm/arm_pmu.h
>> @@ -47,7 +47,10 @@ struct arm_pmu_entry {
>>    	struct arm_pmu *arm_pmu;
>>    };

>> +extern int armv8pmu_max_guest_counters;
>> +
>>    bool kvm_supports_guest_pmuv3(void);
>> +bool has_host_pmu_partition_support(void);
>>    #define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >=  
>> VGIC_NR_SGIS)
>>    u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
>>    void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx,  
>> u64 val);
>> @@ -117,6 +120,11 @@ static inline bool kvm_supports_guest_pmuv3(void)
>>    	return false;
>>    }

>> +static inline bool has_host_pmu_partition_support(void)
>> +{
>> +	return false;
>> +}
>> +
>>    #define kvm_arm_pmu_irq_initialized(v)	(false)
>>    static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
>>    					    u64 select_idx)
>> diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
>> index 52b37f7bdbf9e..1bee8c6eba46b 100644
>> --- a/include/linux/perf/arm_pmu.h
>> +++ b/include/linux/perf/arm_pmu.h
>> @@ -129,6 +129,7 @@ struct arm_pmu {

>>    	/* Only to be used by ACPI probing code */
>>    	unsigned long acpi_cpuid;
>> +	int		max_guest_counters;
>>    };

>>    #define to_arm_pmu(p) (container_of(p, struct arm_pmu, pmu))
