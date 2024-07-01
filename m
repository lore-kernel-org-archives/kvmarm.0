Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13EBD16E861
	for <kvmarm@lists.linux.dev>; Mon,  1 Jul 2024 17:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719854409; cv=none; b=kPgtFD8K6hFTloENslFYWvyuhCYoTX/3rv5ReCv2+8lfUmBCGcRJQwZ/aUeF/WaYM6osIEXdN3m7fB+KG+MTTt44CSjq3sU4Sb9L5fRFhmx03WDm394EC36iNS/oDZ4vF5MjjIC4UIPfXVc525tAGBOzlNhpgsUlccd6uhnW6yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719854409; c=relaxed/simple;
	bh=iKZ+piwPo0Hfx3MZErLWk3acN21TJ/SLxnmDDyzjeP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5B/hQGD0JUgnGDqt2furCqaJ7zoGLCNKCotqI7x9PlYpzuKmvUeyejiiriGViAtRuram+9HnA6GbeDWadmr3uVkt2msMM7JM1OXm9zQmTlYAcYd2/tswU6pz2yNsYMRgkp2pFhovh1TRL+LKggsfNZrkiqN+X9mMJxAmKTYHd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D49C339;
	Mon,  1 Jul 2024 10:20:31 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 333E13F766;
	Mon,  1 Jul 2024 10:20:03 -0700 (PDT)
Date: Mon, 1 Jul 2024 18:20:00 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Clark <james.clark@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 12/12] perf: arm_pmuv3: Add support for Armv9.4 PMU
 instruction counter
Message-ID: <ZoLlQCv-V-5p9RvP@J2N7QTR9R3>
References: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
 <20240626-arm-pmu-3-9-icntr-v2-12-c9784b4f4065@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626-arm-pmu-3-9-icntr-v2-12-c9784b4f4065@kernel.org>

On Wed, Jun 26, 2024 at 04:32:36PM -0600, Rob Herring (Arm) wrote:
> Armv9.4/8.9 PMU adds optional support for a fixed instruction counter
> similar to the fixed cycle counter. Support for the feature is indicated
> in the ID_AA64DFR1_EL1 register PMICNTR field. The counter is not
> accessible in AArch32.
> 
> Existing userspace using direct counter access won't know how to handle
> the fixed instruction counter, so we have to avoid using the counter
> when user access is requested.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
> v2:
>  - Use set_bit() instead of bitmap_set()
>  - Check for ARMV8_PMUV3_PERFCTR_INST_RETIRED first in counter assignment
>  - Check for threshold disabled in counter assignment
> ---
>  arch/arm/include/asm/arm_pmuv3.h   | 20 ++++++++++++++++++++
>  arch/arm64/include/asm/arm_pmuv3.h | 28 ++++++++++++++++++++++++++++
>  arch/arm64/kvm/pmu.c               |  8 ++++++--
>  arch/arm64/tools/sysreg            | 25 +++++++++++++++++++++++++
>  drivers/perf/arm_pmuv3.c           | 25 +++++++++++++++++++++++++
>  include/linux/perf/arm_pmu.h       |  8 ++++++--
>  include/linux/perf/arm_pmuv3.h     |  6 ++++--
>  7 files changed, 114 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
> index a41b503b7dcd..f63ba8986b24 100644
> --- a/arch/arm/include/asm/arm_pmuv3.h
> +++ b/arch/arm/include/asm/arm_pmuv3.h
> @@ -127,6 +127,12 @@ static inline u32 read_pmuver(void)
>  	return (dfr0 >> 24) & 0xf;
>  }
>  
> +static inline bool pmuv3_has_icntr(void)
> +{
> +	/* FEAT_PMUv3_ICNTR not accessible for 32-bit */
> +	return false;
> +}
> +
>  static inline void write_pmcr(u32 val)
>  {
>  	write_sysreg(val, PMCR);
> @@ -152,6 +158,13 @@ static inline u64 read_pmccntr(void)
>  	return read_sysreg(PMCCNTR);
>  }
>  
> +static inline void write_pmicntr(u64 val) {}
> +
> +static inline u64 read_pmicntr(void)
> +{
> +	return 0;
> +}
> +
>  static inline void write_pmcntenset(u32 val)
>  {
>  	write_sysreg(val, PMCNTENSET);
> @@ -177,6 +190,13 @@ static inline void write_pmccfiltr(u32 val)
>  	write_sysreg(val, PMCCFILTR);
>  }
>  
> +static inline void write_pmicfiltr(u64 val) {}
> +
> +static inline u64 read_pmicfiltr(void)
> +{
> +	return 0;
> +}
> +
>  static inline void write_pmovsclr(u32 val)
>  {
>  	write_sysreg(val, PMOVSR);
> diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
> index 36c3e82b4eec..468a049bc63b 100644
> --- a/arch/arm64/include/asm/arm_pmuv3.h
> +++ b/arch/arm64/include/asm/arm_pmuv3.h
> @@ -54,6 +54,14 @@ static inline u32 read_pmuver(void)
>  			ID_AA64DFR0_EL1_PMUVer_SHIFT);
>  }
>  
> +static inline bool pmuv3_has_icntr(void)
> +{
> +	u64 dfr1 = read_sysreg(id_aa64dfr1_el1);
> +
> +	return !!cpuid_feature_extract_unsigned_field(dfr1,
> +			ID_AA64DFR1_EL1_PMICNTR_SHIFT);
> +}
> +
>  static inline void write_pmcr(u64 val)
>  {
>  	write_sysreg(val, pmcr_el0);
> @@ -79,6 +87,16 @@ static inline u64 read_pmccntr(void)
>  	return read_sysreg(pmccntr_el0);
>  }
>  
> +static inline void write_pmicntr(u64 val)
> +{
> +	write_sysreg_s(val, SYS_PMICNTR_EL0);
> +}
> +
> +static inline u64 read_pmicntr(void)
> +{
> +	return read_sysreg_s(SYS_PMICNTR_EL0);
> +}
> +
>  static inline void write_pmcntenset(u64 val)
>  {
>  	write_sysreg(val, pmcntenset_el0);
> @@ -109,6 +127,16 @@ static inline u64 read_pmccfiltr(void)
>  	return read_sysreg(pmccfiltr_el0);
>  }
>  
> +static inline void write_pmicfiltr(u64 val)
> +{
> +	write_sysreg_s(val, SYS_PMICFILTR_EL0);
> +}
> +
> +static inline u64 read_pmicfiltr(void)
> +{
> +	return read_sysreg_s(SYS_PMICFILTR_EL0);
> +}
> +
>  static inline void write_pmovsclr(u64 val)
>  {
>  	write_sysreg(val, pmovsclr_el0);
> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> index 215b74875815..0b3adf3e17b4 100644
> --- a/arch/arm64/kvm/pmu.c
> +++ b/arch/arm64/kvm/pmu.c
> @@ -66,24 +66,28 @@ void kvm_clr_pmu_events(u64 clr)
>  
>  /*
>   * Read a value direct from PMEVTYPER<idx> where idx is 0-30
> - * or PMCCFILTR_EL0 where idx is ARMV8_PMU_CYCLE_IDX (31).
> + * or PMxCFILTR_EL0 where idx is 31-32.
>   */
>  static u64 kvm_vcpu_pmu_read_evtype_direct(int idx)
>  {
>  	if (idx == ARMV8_PMU_CYCLE_IDX)
>  		return read_pmccfiltr();
> +	else if (idx == ARMV8_PMU_INSTR_IDX)
> +		return read_pmicfiltr();
>  
>  	return read_pmevtypern(idx);
>  }
>  
>  /*
>   * Write a value direct to PMEVTYPER<idx> where idx is 0-30
> - * or PMCCFILTR_EL0 where idx is ARMV8_PMU_CYCLE_IDX (31).
> + * or PMxCFILTR_EL0 where idx is 31-32.
>   */
>  static void kvm_vcpu_pmu_write_evtype_direct(int idx, u32 val)
>  {
>  	if (idx == ARMV8_PMU_CYCLE_IDX)
>  		write_pmccfiltr(val);
> +	else if (idx == ARMV8_PMU_INSTR_IDX)
> +		write_pmicfiltr(val);
>  	else
>  		write_pmevtypern(idx, val);
>  }
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 231817a379b5..8ab6e09871de 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2029,6 +2029,31 @@ Sysreg	FAR_EL1	3	0	6	0	0
>  Field	63:0	ADDR
>  EndSysreg
>  
> +Sysreg	PMICNTR_EL0	3	3	9	4	0
> +Field	63:0	ICNT
> +EndSysreg
> +
> +Sysreg	PMICFILTR_EL0	3	3	9	6	0
> +Res0	63:59
> +Field	58	SYNC
> +Field	57:56	VS
> +Res0	55:32
> +Field	31	P
> +Field	30	U
> +Field	29	NSK
> +Field	28	NSU
> +Field	27	NSH
> +Field	26	M
> +Res0	25
> +Field	24	SH
> +Field	23	T
> +Field	22	RLK
> +Field	21	RLU
> +Field	20	RLH
> +Res0	19:16
> +Field	15:0	evtCount
> +EndSysreg
> +
>  Sysreg	PMSCR_EL1	3	0	9	9	0
>  Res0	63:8
>  Field	7:6	PCT
> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index f58dff49ea7d..3b3a3334cc3f 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -571,6 +571,8 @@ static u64 armv8pmu_read_counter(struct perf_event *event)
>  
>  	if (idx == ARMV8_PMU_CYCLE_IDX)
>  		value = read_pmccntr();
> +	else if (idx == ARMV8_PMU_INSTR_IDX)
> +		value = read_pmicntr();
>  	else
>  		value = armv8pmu_read_hw_counter(event);
>  
> @@ -604,6 +606,8 @@ static void armv8pmu_write_counter(struct perf_event *event, u64 value)
>  
>  	if (idx == ARMV8_PMU_CYCLE_IDX)
>  		write_pmccntr(value);
> +	else if (idx == ARMV8_PMU_INSTR_IDX)
> +		write_pmicntr(value);
>  	else
>  		armv8pmu_write_hw_counter(event, value);
>  }
> @@ -641,6 +645,8 @@ static void armv8pmu_write_event_type(struct perf_event *event)
>  	} else {
>  		if (idx == ARMV8_PMU_CYCLE_IDX)
>  			write_pmccfiltr(hwc->config_base);
> +		else if (idx == ARMV8_PMU_INSTR_IDX)
> +			write_pmicfiltr(hwc->config_base);
>  		else
>  			armv8pmu_write_evtype(idx, hwc->config_base);
>  	}
> @@ -769,6 +775,8 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
>  			    ARMPMU_MAX_HWEVENTS) {
>  		if (i == ARMV8_PMU_CYCLE_IDX)
>  			write_pmccntr(0);
> +		else if (i == ARMV8_PMU_INSTR_IDX)
> +			write_pmicntr(0);
>  		else
>  			armv8pmu_write_evcntr(i, 0);
>  	}
> @@ -936,6 +944,19 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
>  				return -EAGAIN;
>  	}
>  
> +	/*
> +	 * Always prefer to place a instruction counter into the instruction counter,
> +	 * but don't expose the instruction counter to userspace access as userspace
> +	 * may not know how to handle it.
> +	 */
> +	if ((evtype == ARMV8_PMUV3_PERFCTR_INST_RETIRED) &&
> +	    !armv8pmu_event_get_threshold(&event->attr) &&
> +	    test_bit(ARMV8_PMU_INSTR_IDX, cpu_pmu->cntr_mask) &&
> +	    !armv8pmu_event_want_user_access(event)) {
> +		if (!test_and_set_bit(ARMV8_PMU_INSTR_IDX, cpuc->used_mask))
> +			return ARMV8_PMU_INSTR_IDX;
> +	}
> +
>  	/*
>  	 * Otherwise use events counters
>  	 */
> @@ -1193,6 +1214,10 @@ static void __armv8pmu_probe_pmu(void *info)
>  	/* Add the CPU cycles counter */
>  	set_bit(ARMV8_PMU_CYCLE_IDX, cpu_pmu->cntr_mask);
>  
> +	/* Add the CPU instructions counter */
> +	if (pmuv3_has_icntr())
> +		set_bit(ARMV8_PMU_INSTR_IDX, cpu_pmu->cntr_mask);
> +
>  	pmceid[0] = pmceid_raw[0] = read_pmceid0();
>  	pmceid[1] = pmceid_raw[1] = read_pmceid1();
>  
> diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
> index e5d6d204beab..4b5b83677e3f 100644
> --- a/include/linux/perf/arm_pmu.h
> +++ b/include/linux/perf/arm_pmu.h
> @@ -17,10 +17,14 @@
>  #ifdef CONFIG_ARM_PMU
>  
>  /*
> - * The ARMv7 CPU PMU supports up to 32 event counters.
> + * The Armv7 and Armv8.8 or less CPU PMU supports up to 32 event counters.
> + * The Armv8.9/9.4 CPU PMU supports up to 33 event counters.
>   */
> +#ifdef CONFIG_ARM
>  #define ARMPMU_MAX_HWEVENTS		32
> -
> +#else
> +#define ARMPMU_MAX_HWEVENTS		33
> +#endif
>  /*
>   * ARM PMU hw_event flags
>   */
> diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
> index 4f7a7f2222e5..3372c1b56486 100644
> --- a/include/linux/perf/arm_pmuv3.h
> +++ b/include/linux/perf/arm_pmuv3.h
> @@ -8,7 +8,7 @@
>  
>  #define ARMV8_PMU_MAX_GENERAL_COUNTERS	31
>  #define ARMV8_PMU_CYCLE_IDX		31
> -
> +#define ARMV8_PMU_INSTR_IDX		32 /* Not accessible from AArch32 */
>  
>  /*
>   * Common architectural and microarchitectural event numbers.
> @@ -228,8 +228,10 @@
>   */
>  #define ARMV8_PMU_OVSR_P		GENMASK(30, 0)
>  #define ARMV8_PMU_OVSR_C		BIT(31)
> +#define ARMV8_PMU_OVSR_F		BIT_ULL(32) /* arm64 only */
>  /* Mask for writable bits is both P and C fields */
> -#define ARMV8_PMU_OVERFLOWED_MASK	(ARMV8_PMU_OVSR_P | ARMV8_PMU_OVSR_C)
> +#define ARMV8_PMU_OVERFLOWED_MASK	(ARMV8_PMU_OVSR_P | ARMV8_PMU_OVSR_C | \
> +					ARMV8_PMU_OVSR_F)
>  
>  /*
>   * PMXEVTYPER: Event selection reg
> 
> -- 
> 2.43.0
> 
