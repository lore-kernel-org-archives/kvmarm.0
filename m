Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B57616DED5
	for <kvmarm@lists.linux.dev>; Mon,  1 Jul 2024 17:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719853637; cv=none; b=eUrbTcWNnLkvuXz7qCsNNAUGrSTydkAxw5BunKkxkUY7TOKjr0nczcK6+3OhHg/qacj12b6JY6CuTUrgl1Sh7L5tL7BSwnEOP2iYpSPN7lCRtOT0QfUnxL4D0FuaByDpKqV72JhvnVhW23yRNoAvrMoudfgMrv4d5qTTeHHwg6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719853637; c=relaxed/simple;
	bh=DN/KxO3dGV/2vXtnLWfIBRZu9oosw0hZsA3V8O/408w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t8ugyzcp+db+yLcRxNtliQv9zkLoKnlGxbpTneISXM7x2artsB0TegYDQBFfJH8SljaaaBHsppkdQcyV8CpH3qYX5kjq86EJXL6mfcz0l0V1mY5s37av9SBRD5yMYxmm7U9meWvOJVjjfnCaZzH0WXs2Ldv/sLqbG0NYeS+L3yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6209339;
	Mon,  1 Jul 2024 10:07:39 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 846AD3F766;
	Mon,  1 Jul 2024 10:07:11 -0700 (PDT)
Date: Mon, 1 Jul 2024 18:07:09 +0100
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
Subject: Re: [PATCH v2 10/12] arm64: perf/kvm: Use a common PMU cycle counter
 define
Message-ID: <ZoLiPaTi3b52nCKh@J2N7QTR9R3>
References: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
 <20240626-arm-pmu-3-9-icntr-v2-10-c9784b4f4065@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626-arm-pmu-3-9-icntr-v2-10-c9784b4f4065@kernel.org>

On Wed, Jun 26, 2024 at 04:32:34PM -0600, Rob Herring (Arm) wrote:
> The PMUv3 and KVM code each have a define for the PMU cycle counter
> index. Move KVM's define to a shared location and use it for PMUv3
> driver.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
> v2:
>  - Move ARMV8_PMU_CYCLE_IDX to linux/perf/arm_pmuv3.h
> ---
>  arch/arm64/kvm/sys_regs.c      |  1 +
>  drivers/perf/arm_pmuv3.c       | 19 +++++++------------
>  include/kvm/arm_pmu.h          |  1 -
>  include/linux/perf/arm_pmuv3.h |  3 +++
>  4 files changed, 11 insertions(+), 13 deletions(-)

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f8b5db48ea8a..22393ae7ce14 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -18,6 +18,7 @@
>  #include <linux/printk.h>
>  #include <linux/uaccess.h>
>  
> +#include <asm/arm_pmuv3.h>
>  #include <asm/cacheflush.h>
>  #include <asm/cputype.h>
>  #include <asm/debug-monitors.h>
> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index f771242168f1..f58dff49ea7d 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -451,11 +451,6 @@ static const struct attribute_group armv8_pmuv3_caps_attr_group = {
>  	.attrs = armv8_pmuv3_caps_attrs,
>  };
>  
> -/*
> - * Perf Events' indices
> - */
> -#define	ARMV8_IDX_CYCLE_COUNTER	31
> -
>  /*
>   * We unconditionally enable ARMv8.5-PMU long event counter support
>   * (64-bit events) where supported. Indicate if this arm_pmu has long
> @@ -574,7 +569,7 @@ static u64 armv8pmu_read_counter(struct perf_event *event)
>  	int idx = hwc->idx;
>  	u64 value;
>  
> -	if (idx == ARMV8_IDX_CYCLE_COUNTER)
> +	if (idx == ARMV8_PMU_CYCLE_IDX)
>  		value = read_pmccntr();
>  	else
>  		value = armv8pmu_read_hw_counter(event);
> @@ -607,7 +602,7 @@ static void armv8pmu_write_counter(struct perf_event *event, u64 value)
>  
>  	value = armv8pmu_bias_long_counter(event, value);
>  
> -	if (idx == ARMV8_IDX_CYCLE_COUNTER)
> +	if (idx == ARMV8_PMU_CYCLE_IDX)
>  		write_pmccntr(value);
>  	else
>  		armv8pmu_write_hw_counter(event, value);
> @@ -644,7 +639,7 @@ static void armv8pmu_write_event_type(struct perf_event *event)
>  		armv8pmu_write_evtype(idx - 1, hwc->config_base);
>  		armv8pmu_write_evtype(idx, chain_evt);
>  	} else {
> -		if (idx == ARMV8_IDX_CYCLE_COUNTER)
> +		if (idx == ARMV8_PMU_CYCLE_IDX)
>  			write_pmccfiltr(hwc->config_base);
>  		else
>  			armv8pmu_write_evtype(idx, hwc->config_base);
> @@ -772,7 +767,7 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
>  	/* Clear any unused counters to avoid leaking their contents */
>  	for_each_andnot_bit(i, cpu_pmu->cntr_mask, cpuc->used_mask,
>  			    ARMPMU_MAX_HWEVENTS) {
> -		if (i == ARMV8_IDX_CYCLE_COUNTER)
> +		if (i == ARMV8_PMU_CYCLE_IDX)
>  			write_pmccntr(0);
>  		else
>  			armv8pmu_write_evcntr(i, 0);
> @@ -933,8 +928,8 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
>  	/* Always prefer to place a cycle counter into the cycle counter. */
>  	if ((evtype == ARMV8_PMUV3_PERFCTR_CPU_CYCLES) &&
>  	    !armv8pmu_event_get_threshold(&event->attr)) {
> -		if (!test_and_set_bit(ARMV8_IDX_CYCLE_COUNTER, cpuc->used_mask))
> -			return ARMV8_IDX_CYCLE_COUNTER;
> +		if (!test_and_set_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask))
> +			return ARMV8_PMU_CYCLE_IDX;
>  		else if (armv8pmu_event_is_64bit(event) &&
>  			   armv8pmu_event_want_user_access(event) &&
>  			   !armv8pmu_has_long_event(cpu_pmu))
> @@ -1196,7 +1191,7 @@ static void __armv8pmu_probe_pmu(void *info)
>  		   0, FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read()));
>  
>  	/* Add the CPU cycles counter */
> -	set_bit(ARMV8_IDX_CYCLE_COUNTER, cpu_pmu->cntr_mask);
> +	set_bit(ARMV8_PMU_CYCLE_IDX, cpu_pmu->cntr_mask);
>  
>  	pmceid[0] = pmceid_raw[0] = read_pmceid0();
>  	pmceid[1] = pmceid_raw[1] = read_pmceid1();
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 334d7c5503cf..871067fb2616 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -10,7 +10,6 @@
>  #include <linux/perf_event.h>
>  #include <linux/perf/arm_pmuv3.h>
>  
> -#define ARMV8_PMU_CYCLE_IDX		(ARMV8_PMU_MAX_COUNTERS - 1)
>  
>  #if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
>  struct kvm_pmc {
> diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
> index 792b8e10b72a..f4ec76f725a3 100644
> --- a/include/linux/perf/arm_pmuv3.h
> +++ b/include/linux/perf/arm_pmuv3.h
> @@ -9,6 +9,9 @@
>  #define ARMV8_PMU_MAX_GENERAL_COUNTERS	31
>  #define ARMV8_PMU_MAX_COUNTERS	32
>  
> +#define ARMV8_PMU_CYCLE_IDX		31
> +
> +
>  /*
>   * Common architectural and microarchitectural event numbers.
>   */
> 
> -- 
> 2.43.0
> 
