Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D63AB7E56C
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 10:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718016293; cv=none; b=PdCkU1xxKPaH513ErZbCo3MkeSWHQ3wsztxana8gqckRDk7c0te4I6pCJvRWFO67b//liVrK0DqPzxoPcWF0Wpm90yVBrcJvC/pMPdv7AbrwEU7ZqcJPunMM/foD/A7Q+wPNb5j1jRrzbLheP5ZVtmPfhJ6mgWRH9OzXgvQGyK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718016293; c=relaxed/simple;
	bh=prO2aeYPINExUzVSsDQDEg/EB4ix6UGhkuKRV83YxsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OFpk8uUCesH8uKryZxTmDj2XHlfEPCakFG13whZ8z4r8xFHRec3Ahxw0A3VaGJJnuYcwsDtD9+27hNgqeN5zb+eXF4qsAtGyUtfc8Ng7vqHtSQarU547WkMIPdK2q/9g5ll1RINo3biiL+QDNjpgz0EW2l4TiTBpsG/xe8CclwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B17B112FC;
	Mon, 10 Jun 2024 03:45:14 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D641F3F73B;
	Mon, 10 Jun 2024 03:44:46 -0700 (PDT)
Date: Mon, 10 Jun 2024 11:44:43 +0100
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
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/9] perf: arm_pmu: Remove event index to counter
 remapping
Message-ID: <ZmbZG-eaqE4NPcE3@J2N7QTR9R3>
References: <20240607-arm-pmu-3-9-icntr-v1-0-c7bd2dceff3b@kernel.org>
 <20240607-arm-pmu-3-9-icntr-v1-3-c7bd2dceff3b@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607-arm-pmu-3-9-icntr-v1-3-c7bd2dceff3b@kernel.org>

On Fri, Jun 07, 2024 at 02:31:28PM -0600, Rob Herring (Arm) wrote:
> Xscale and Armv6 PMUs defined the cycle counter at 0 and event counters
> starting at 1 and had 1:1 event index to counter numbering. On Armv7 and
> later, this changed the cycle counter to 31 and event counters start at
> 0. The drivers for Armv7 and PMUv3 kept the old event index numbering
> and introduced an event index to counter conversion. The conversion uses
> masking to convert from event index to a counter number. This operation
> relies on having at most 32 counters so that the cycle counter index 0
> can be transformed to counter number 31.
> 
> Armv9.4 adds support for an additional fixed function counter
> (instructions) which increases possible counters to more than 32, and
> the conversion won't work anymore as a simple subtract and mask. The
> primary reason for the translation (other than history) seems to be to
> have a contiguous mask of counters 0-N. Keeping that would result in
> more complicated index to counter conversions. Instead, store a mask of
> available counters rather than just number of events. That provides more
> information in addition to the number of events.
> 
> No (intended) functional changes.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c     |  6 ++--
>  drivers/perf/arm_pmu.c        | 11 ++++---
>  drivers/perf/arm_pmuv3.c      | 57 ++++++++++----------------------
>  drivers/perf/arm_v6_pmu.c     |  6 ++--
>  drivers/perf/arm_v7_pmu.c     | 77 ++++++++++++++++---------------------------
>  drivers/perf/arm_xscale_pmu.c | 12 ++++---
>  include/linux/perf/arm_pmu.h  |  2 +-
>  7 files changed, 69 insertions(+), 102 deletions(-)

This looks like a nice cleanup!

As the test robot reports, it looks like this missed
drivers/perf/apple_m1_cpu_pmu.c, but IIUC that's simple enough to fix
up.

Otherwise, I have a few minor comments below, 

> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index 23fa6c5da82c..80202346fc7a 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -451,9 +451,7 @@ static const struct attribute_group armv8_pmuv3_caps_attr_group = {
>  /*
>   * Perf Events' indices
>   */
> -#define	ARMV8_IDX_CYCLE_COUNTER	0
> -#define	ARMV8_IDX_COUNTER0	1
> -#define	ARMV8_IDX_CYCLE_COUNTER_USER	32
> +#define	ARMV8_IDX_CYCLE_COUNTER	31

I was going to ask whether this affected the ABI, but I see from below
that armv8pmu_user_event_idx() will now always offset the counter by
one rather than special-casing the cycle counter, and this gives us the
same behavior as before.

[...]

> @@ -783,7 +767,7 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
>  	struct pmu_hw_events *cpuc = this_cpu_ptr(cpu_pmu->hw_events);
>  
>  	/* Clear any unused counters to avoid leaking their contents */
> -	for_each_clear_bit(i, cpuc->used_mask, cpu_pmu->num_events) {
> +	for_each_clear_bit(i, cpuc->used_mask, ARMPMU_MAX_HWEVENTS) {
>  		if (i == ARMV8_IDX_CYCLE_COUNTER)
>  			write_pmccntr(0);
>  		else

IIUC this will now hit all unimplemented counters; e.g. for N counters the body
will run for counters N..31, and the else case has:

	armv8pmu_write_evcntr(i, 0);

... where the resulting write to PMEVCNTR<n>_EL0 for unimplemented
counters is CONSTRAINED UNPREDICTABLE and might be UNDEFINED.

We can fix that with for_each_andnot_bit(), e.g.

	for_each_andnot_bit(i, cpu_pmu->cntr_mask, cpuc->used_mask,
			    ARMPMU_MAX_HWEVENTS) {
		if (i == ARMV8_IDX_CYCLE_COUNTER)
			write_pmccntr(0);
		else
			 armv8pmu_write_evcntr(i, 0);
	}

[...]

> @@ -905,7 +889,7 @@ static int armv8pmu_get_single_idx(struct pmu_hw_events *cpuc,
>  {
>  	int idx;
>  
> -	for (idx = ARMV8_IDX_COUNTER0; idx < cpu_pmu->num_events; idx++) {
> +	for_each_set_bit(idx, cpu_pmu->cntr_mask, 31) {
>  		if (!test_and_set_bit(idx, cpuc->used_mask))
>  			return idx;
>  	}
> @@ -921,7 +905,9 @@ static int armv8pmu_get_chain_idx(struct pmu_hw_events *cpuc,
>  	 * Chaining requires two consecutive event counters, where
>  	 * the lower idx must be even.
>  	 */
> -	for (idx = ARMV8_IDX_COUNTER0 + 1; idx < cpu_pmu->num_events; idx += 2) {
> +	for_each_set_bit(idx, cpu_pmu->cntr_mask, 31) {
> +		if (!(idx & 0x1))
> +			continue;
>  		if (!test_and_set_bit(idx, cpuc->used_mask)) {
>  			/* Check if the preceding even counter is available */
>  			if (!test_and_set_bit(idx - 1, cpuc->used_mask))

It would be nice to replace those instances of '31' with something
indicating that this was only covering the generic/programmable
counters, but I wasn't able to come up with a nice mnemonic for that.
The best I could think of was:

#define ARMV8_MAX_NR_GENERIC_COUNTERS 31

Maybe it makes sense to define that along with ARMV8_IDX_CYCLE_COUNTER.

> @@ -974,15 +960,7 @@ static int armv8pmu_user_event_idx(struct perf_event *event)
>  	if (!sysctl_perf_user_access || !armv8pmu_event_has_user_read(event))
>  		return 0;
>  
> -	/*
> -	 * We remap the cycle counter index to 32 to
> -	 * match the offset applied to the rest of
> -	 * the counter indices.
> -	 */
> -	if (event->hw.idx == ARMV8_IDX_CYCLE_COUNTER)
> -		return ARMV8_IDX_CYCLE_COUNTER_USER;
> -
> -	return event->hw.idx;
> +	return event->hw.idx + 1;
>  }

[...]

>  static void armv7_read_num_pmnc_events(void *info)
>  {
> -	int *nb_cnt = info;
> +	int nb_cnt;
> +	struct arm_pmu *cpu_pmu = info;
>  
>  	/* Read the nb of CNTx counters supported from PMNC */
> -	*nb_cnt = (armv7_pmnc_read() >> ARMV7_PMNC_N_SHIFT) & ARMV7_PMNC_N_MASK;
> +	nb_cnt = (armv7_pmnc_read() >> ARMV7_PMNC_N_SHIFT) & ARMV7_PMNC_N_MASK;
> +	bitmap_set(cpu_pmu->cntr_mask, 0, nb_cnt);
>  
>  	/* Add the CPU cycles counter */
> -	*nb_cnt += 1;
> +	bitmap_set(cpu_pmu->cntr_mask, ARMV7_IDX_CYCLE_COUNTER, 1);

This can be:

	set_bit(cpu_pmu->cntr_mask, ARMV7_IDX_CYCLE_COUNTER);

... and likewise for the PMUv3 version.

[...]

> diff --git a/drivers/perf/arm_xscale_pmu.c b/drivers/perf/arm_xscale_pmu.c
> index 3d8b72d6b37f..e075df521350 100644
> --- a/drivers/perf/arm_xscale_pmu.c
> +++ b/drivers/perf/arm_xscale_pmu.c
> @@ -52,6 +52,8 @@ enum xscale_counters {
>  	XSCALE_COUNTER1,
>  	XSCALE_COUNTER2,
>  	XSCALE_COUNTER3,
> +	XSCALE2_NUM_COUNTERS,
> +	XSCALE_NUM_COUNTERS = 3,
>  };

Minor nit, but for consistency with other xscale1-only definitions, it'd
be good to s/XSCALE_NUM_COUNTERS/XSCALE1_NUM_COUNTERS/.

While it'd be different fro mthe other PMU drivers, I reckon it's
clearer to pull those out as:

#define XSCALE1_NUM_COUNTERS	3
#define XSCALE2_NUM_COUNTERS	5

Mark.
