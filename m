Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2B5275AE9
	for <kvmarm@lists.linux.dev>; Sat, 30 Aug 2025 04:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756527223; cv=none; b=H9BzG7q1VyQm3N1KUNjqikIzuAn602SeWO5tAkBrZvN7SlHHffOfkChr1IGikEUlkmIqxe0OJRvU9wAYYCSBlk+tY1Si7aVL8nzMvQialjdj8Fao52oP4m73zl8ckcPKFck33HO2bblmKE6hr4hs8KOjvFlZ8YbuXRsYopMKciw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756527223; c=relaxed/simple;
	bh=thi/bsfRJE8mOHvtlDeJYRmTtL6vd0bQzTdsl7pXpJY=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=dkA4Ub8jea4Ln0fNlQ3IApSmVLFWMh2Xtj+qEh97QkjZs0F+2Spp1C4oL2ACcJ4mIWiEfg8tbr1kAbqj67nuoU/+L/bmgEflcNGXvj49PI0TpsYRMCsgpVVIPscJhn18wgFHlHXjnDBPARgcPJ99sS3z8stEMEDqO1N54N/fTac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O65Su7rk; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O65Su7rk"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-8870e77d31aso176242439f.1
        for <kvmarm@lists.linux.dev>; Fri, 29 Aug 2025 21:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756527221; x=1757132021; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9Z5xnfU2qT1cpEr4IPQsf35kJiGWlzs/2i53/O7XG7w=;
        b=O65Su7rkN0YQfZDBLSCcsv7XJfm+xdfDbGWjF6u7WA9jSJSJTPTdAgjYWmPgq9cyyN
         capQEf3siMX2EdGRPYlHJnUL4GwcAVSMZTsjPjnLJMkS+rjyQ0eDRbVN9ieMXe+imwfV
         IrzJDKK44LBLOGLX5vdJUxtJVW7eo938YZxd8PFi/m85ZqU7OsQa5u84h6FK2S3erjT/
         v1beIRyxuTyfZ0uu8U7z82dA/KvVHymp2VR0RrfIS7hZI9VzScHJikEAOttUH3TTbC7g
         oNRHlkGYZqNliSvzPRtITApf44Yx2aIBbUD2yQiQIleo/l3q8Bk1rINqMgKuDFfJWPro
         TQCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756527221; x=1757132021;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Z5xnfU2qT1cpEr4IPQsf35kJiGWlzs/2i53/O7XG7w=;
        b=bSwqSBAOXUdSha4SR/IJtLs/5MKAUSYJWTKRgV+8NfM6QrXRzWot/o5Ikua3pOwBMR
         xtIcCEUgDLHFKckSPbWk8EwpCaHU+WEQCcw+qSMch3OaXEs+npsUoYWa6VgGDILOX0n+
         MoekTuKpsval+q4Zwr8KzZ4ZaHojjiO3i1zoyxtHKqDOPRw1vaArveHT4a6mA/H7rViF
         +/U+HItsXGPyi3OOvzQBPBjDA6KBlidPK1bbrRjt6Fvith2BOdsTLlkpbWyonm3RS+jx
         q6jyQNW3YLO/TWP7XgiZAZCuIOhq14K439Qf5ictLOMg8tc75neIrW+j5qfMemNdEpsE
         XFiA==
X-Forwarded-Encrypted: i=1; AJvYcCXFflGD9exX2r3bAQnfFU76YoRLNPRPGooSQbj+orVbBW/hx0hQDRK+U8xwoS828DiFRNrEShg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwHbHEZimWWIMnvAS69J8KoA9TOYh5/UC1y4K+Z7RjNmWHmypqV
	n0hM6oyaH7p2SBvvWSsLKytVP7qtIYncaS+Gze15NevDHtSB9lPi5f3d5viqya1ApvqHaLPDupv
	FvCBLOxqVdYi03d3lP8yHh6nqSA==
X-Google-Smtp-Source: AGHT+IHY4vn1mqRalNRHYDytRu2rdsx+RbQn0i1TrFXo8yYZdYFDPmN+UJ6HDalf3E1zNgCt7wnIiSapM5kbcPqUZA==
X-Received: from iljh16.prod.google.com ([2002:a05:6e02:d50:b0:3f2:80cd:5b9e])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:12cd:b0:3ef:175e:fd20 with SMTP id e9e14a558f8ab-3f400288a46mr20510375ab.8.1756527220822;
 Fri, 29 Aug 2025 21:13:40 -0700 (PDT)
Date: Sat, 30 Aug 2025 04:13:39 +0000
In-Reply-To: <20250714225917.1396543-7-coltonlewis@google.com> (message from
 Colton Lewis on Mon, 14 Jul 2025 22:59:00 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntiki5cuq4.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v4 06/23] perf: arm_pmuv3: Keep out of guest counter partition
From: Colton Lewis <coltonlewis@google.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Colton Lewis <coltonlewis@google.com> writes:

> If the PMU is partitioned, keep the driver out of the guest counter
> partition and only use the host counter partition. Partitioning is
> defined by the MDCR_EL2.HPMN register field and the maximum value KVM
> can use is saved in cpu_pmu->hpmn_max. The range 0..HPMN-1 is
> accessible by EL1 and EL0 while HPMN..PMCR.N is reserved for EL2.

> Define some functions that take HPMN as an argument and construct
> mutually exclusive bitmaps for testing which partition a particular
> counter is in. Note that despite their different position in the
> bitmap, the cycle and instruction counters are always in the guest
> partition.

> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>   arch/arm/include/asm/arm_pmuv3.h | 18 +++++++
>   arch/arm64/include/asm/kvm_pmu.h | 24 +++++++++
>   arch/arm64/kvm/pmu-direct.c      | 84 ++++++++++++++++++++++++++++++++
>   drivers/perf/arm_pmuv3.c         | 36 ++++++++++++--
>   4 files changed, 158 insertions(+), 4 deletions(-)

> diff --git a/arch/arm/include/asm/arm_pmuv3.h  
> b/arch/arm/include/asm/arm_pmuv3.h
> index 49b1f2d7842d..5f6269039f44 100644
> --- a/arch/arm/include/asm/arm_pmuv3.h
> +++ b/arch/arm/include/asm/arm_pmuv3.h
> @@ -231,6 +231,24 @@ static inline bool kvm_set_pmuserenr(u64 val)
>   }

>   static inline void kvm_vcpu_pmu_resync_el0(void) {}
> +static inline void kvm_pmu_host_counters_enable(void) {}
> +static inline void kvm_pmu_host_counters_disable(void) {}
> +
> +static inline bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
> +{
> +	return false;
> +}
> +
> +static inline u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu)
> +{
> +	return ~0;
> +}
> +
> +static inline u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
> +{
> +	return ~0;
> +}
> +

>   static inline bool has_vhe(void)
>   {
> diff --git a/arch/arm64/include/asm/kvm_pmu.h  
> b/arch/arm64/include/asm/kvm_pmu.h
> index 8a2ed02e157d..6328e90952ba 100644
> --- a/arch/arm64/include/asm/kvm_pmu.h
> +++ b/arch/arm64/include/asm/kvm_pmu.h
> @@ -88,6 +88,12 @@ void kvm_vcpu_pmu_resync_el0(void);
>   #define kvm_vcpu_has_pmu(vcpu)					\
>   	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))

> +bool kvm_pmu_is_partitioned(struct arm_pmu *pmu);
> +u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu);
> +u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
> +void kvm_pmu_host_counters_enable(void);
> +void kvm_pmu_host_counters_disable(void);
> +
>   /*
>    * Updates the vcpu's view of the pmu events for this cpu.
>    * Must be called before every vcpu run after disabling interrupts, to  
> ensure
> @@ -220,6 +226,24 @@ static inline bool kvm_pmu_counter_is_hyp(struct  
> kvm_vcpu *vcpu, unsigned int id

>   static inline void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu) {}

> +static inline bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
> +{
> +	return false;
> +}
> +
> +static inline u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu)
> +{
> +	return ~0;
> +}
> +
> +static inline u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
> +{
> +	return ~0;
> +}
> +
> +static inline void kvm_pmu_host_counters_enable(void) {}
> +static inline void kvm_pmu_host_counters_disable(void) {}
> +
>   #endif

>   #endif
> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> index 9423d6f65059..22e9b2f9e7b6 100644
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c
> @@ -5,7 +5,10 @@
>    */

>   #include <linux/kvm_host.h>
> +#include <linux/perf/arm_pmu.h>
> +#include <linux/perf/arm_pmuv3.h>

> +#include <asm/arm_pmuv3.h>
>   #include <asm/kvm_pmu.h>

>   /**
> @@ -20,3 +23,84 @@ bool kvm_pmu_partition_supported(void)
>   {
>   	return has_vhe();
>   }
> +
> +/**
> + * kvm_pmu_is_partitioned() - Determine if given PMU is partitioned
> + * @pmu: Pointer to arm_pmu struct
> + *
> + * Determine if given PMU is partitioned by looking at hpmn field. The
> + * PMU is partitioned if this field is less than the number of
> + * counters in the system.
> + *
> + * Return: True if the PMU is partitioned, false otherwise
> + */
> +bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
> +{
> +	return pmu->hpmn_max >= 0 &&
> +		pmu->hpmn_max <= *host_data_ptr(nr_event_counters);
> +}
> +
> +/**
> + * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved  
> counters
> + * @pmu: Pointer to arm_pmu struct
> + *
> + * Compute the bitmask that selects the host-reserved counters in the
> + * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers. These are the counters
> + * in HPMN..N
> + *
> + * Assumes pmu is partitioned and hpmn_max is a valid value.
> + *
> + * Return: Bitmask
> + */
> +u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu)
> +{
> +	u8 nr_counters = *host_data_ptr(nr_event_counters);
> +
> +	return GENMASK(nr_counters - 1, pmu->hpmn_max);
> +}
> +
> +/**
> + * kvm_pmu_guest_counter_mask() - Compute bitmask of guest-reserved  
> counters
> + *
> + * Compute the bitmask that selects the guest-reserved counters in the
> + * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers. These are the counters
> + * in 0..HPMN and the cycle and instruction counters.
> + *
> + * Assumes pmu is partitioned and hpmn_max is a valid value.
> + *
> + * Return: Bitmask
> + */
> +u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
> +{
> +	return ARMV8_PMU_CNT_MASK_ALL & ~kvm_pmu_host_counter_mask(pmu);
> +}
> +
> +/**
> + * kvm_pmu_host_counters_enable() - Enable host-reserved counters
> + *
> + * When partitioned the enable bit for host-reserved counters is
> + * MDCR_EL2.HPME instead of the typical PMCR_EL0.E, which now
> + * exclusively controls the guest-reserved counters. Enable that bit.
> + */
> +void kvm_pmu_host_counters_enable(void)
> +{
> +	u64 mdcr = read_sysreg(mdcr_el2);
> +
> +	mdcr |= MDCR_EL2_HPME;
> +	write_sysreg(mdcr, mdcr_el2);
> +}
> +
> +/**
> + * kvm_pmu_host_counters_disable() - Disable host-reserved counters
> + *
> + * When partitioned the disable bit for host-reserved counters is
> + * MDCR_EL2.HPME instead of the typical PMCR_EL0.E, which now
> + * exclusively controls the guest-reserved counters. Disable that bit.
> + */
> +void kvm_pmu_host_counters_disable(void)
> +{
> +	u64 mdcr = read_sysreg(mdcr_el2);
> +
> +	mdcr &= ~MDCR_EL2_HPME;
> +	write_sysreg(mdcr, mdcr_el2);
> +}
> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index 339d3c2d91a0..bc8a99cf4f88 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -839,12 +839,18 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
>   	kvm_vcpu_pmu_resync_el0();

>   	/* Enable all counters */
> +	if (kvm_pmu_is_partitioned(cpu_pmu))
> +		kvm_pmu_host_counters_enable();
> +
>   	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
>   }

>   static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
>   {
>   	/* Disable all counters */
> +	if (kvm_pmu_is_partitioned(cpu_pmu))
> +		kvm_pmu_host_counters_disable();
> +
>   	armv8pmu_pmcr_write(armv8pmu_pmcr_read() & ~ARMV8_PMU_PMCR_E);
>   }

> @@ -954,6 +960,7 @@ static int armv8pmu_get_event_idx(struct  
> pmu_hw_events *cpuc,

>   	/* Always prefer to place a cycle counter into the cycle counter. */
>   	if ((evtype == ARMV8_PMUV3_PERFCTR_CPU_CYCLES) &&
> +	    !kvm_pmu_is_partitioned(cpu_pmu) &&
>   	    !armv8pmu_event_get_threshold(&event->attr)) {
>   		if (!test_and_set_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask))
>   			return ARMV8_PMU_CYCLE_IDX;
> @@ -969,6 +976,7 @@ static int armv8pmu_get_event_idx(struct  
> pmu_hw_events *cpuc,
>   	 * may not know how to handle it.
>   	 */
>   	if ((evtype == ARMV8_PMUV3_PERFCTR_INST_RETIRED) &&
> +	    !kvm_pmu_is_partitioned(cpu_pmu) &&
>   	    !armv8pmu_event_get_threshold(&event->attr) &&
>   	    test_bit(ARMV8_PMU_INSTR_IDX, cpu_pmu->cntr_mask) &&
>   	    !armv8pmu_event_want_user_access(event)) {
> @@ -980,7 +988,7 @@ static int armv8pmu_get_event_idx(struct  
> pmu_hw_events *cpuc,
>   	 * Otherwise use events counters
>   	 */
>   	if (armv8pmu_event_is_chained(event))
> -		return	armv8pmu_get_chain_idx(cpuc, cpu_pmu);
> +		return armv8pmu_get_chain_idx(cpuc, cpu_pmu);
>   	else
>   		return armv8pmu_get_single_idx(cpuc, cpu_pmu);
>   }
> @@ -1072,6 +1080,14 @@ static int armv8pmu_set_event_filter(struct  
> hw_perf_event *event,
>   	return 0;
>   }

> +static void armv8pmu_reset_host_counters(struct arm_pmu *cpu_pmu)
> +{
> +	int idx;
> +
> +	for_each_set_bit(idx, cpu_pmu->cntr_mask,  
> ARMV8_PMU_MAX_GENERAL_COUNTERS)
> +		armv8pmu_write_evcntr(idx, 0);
> +}
> +
>   static void armv8pmu_reset(void *info)
>   {
>   	struct arm_pmu *cpu_pmu = (struct arm_pmu *)info;
> @@ -1079,6 +1095,9 @@ static void armv8pmu_reset(void *info)

>   	bitmap_to_arr64(&mask, cpu_pmu->cntr_mask, ARMPMU_MAX_HWEVENTS);

> +	if (kvm_pmu_is_partitioned(cpu_pmu))
> +		mask &= kvm_pmu_host_counter_mask(cpu_pmu);
> +
>   	/* The counter and interrupt enable registers are unknown at reset. */
>   	armv8pmu_disable_counter(mask);
>   	armv8pmu_disable_intens(mask);
> @@ -1086,11 +1105,20 @@ static void armv8pmu_reset(void *info)
>   	/* Clear the counters we flip at guest entry/exit */
>   	kvm_clr_pmu_events(mask);

> +
> +	pmcr = ARMV8_PMU_PMCR_LC;
> +
>   	/*
> -	 * Initialize & Reset PMNC. Request overflow interrupt for
> -	 * 64 bit cycle counter but cheat in armv8pmu_write_counter().
> +	 * Initialize & Reset PMNC. Request overflow interrupt for 64
> +	 * bit cycle counter but cheat in armv8pmu_write_counter().
> +	 *
> +	 * When partitioned, there is no single bit to reset only the
> +	 * host counters. so reset them individually.
>   	 */
> -	pmcr = ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR_LC;
> +	if (kvm_pmu_is_partitioned(cpu_pmu))
> +		armv8pmu_reset_host_counters(cpu_pmu);
> +	else
> +		pmcr = ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C;

That line should be |=


>   	/* Enable long event counter support where available */
>   	if (armv8pmu_has_long_event(cpu_pmu))
> --
> 2.50.0.727.gbf7dc18ff4-goog
