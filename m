Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A863A16E884
	for <kvmarm@lists.linux.dev>; Mon,  1 Jul 2024 17:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719853783; cv=none; b=ONHapKgixoJMXXhkaxehQoN6vqF+/10nHcNWLiQPrr7QJonyFDZkjIYQ2yT0+/kUNWSGOdy+2tpPr0WyDfkOOYz9abC7O+usG89XPdWeo2GBM2VfV7tHsrOiCnsBvb+YTNYWbMOyBGASXuuYAlSUcRTfJGsh+PLCnJy4/uXLjFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719853783; c=relaxed/simple;
	bh=/0P36xAcbDr1Y49JaZRQ1aDkbz3B2ByND+s9thhdz6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=orwQdTs4co9AT/ggE083ofTiUSuMWAqExrtAuBeG/bXEd/UE3+pZRrmX358tJqbV1w+neZhW9D4TfGidFgJdY4zn6WEcD8ULXSf+1iwtnkSGpzTc9D3zYcfAkbwe0G8Z08kZ9YFdtRc8GouCbhyFOk2sZBF5arTAsFAksxH6h4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 13A7C339;
	Mon,  1 Jul 2024 10:10:06 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F5003F766;
	Mon,  1 Jul 2024 10:09:37 -0700 (PDT)
Date: Mon, 1 Jul 2024 18:09:35 +0100
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
Subject: Re: [PATCH v2 01/12] perf: arm_pmuv3: Avoid assigning fixed cycle
 counter with threshold
Message-ID: <ZoLiz5FoPsd89p5E@J2N7QTR9R3>
References: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
 <20240626-arm-pmu-3-9-icntr-v2-1-c9784b4f4065@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626-arm-pmu-3-9-icntr-v2-1-c9784b4f4065@kernel.org>

On Wed, Jun 26, 2024 at 04:32:25PM -0600, Rob Herring (Arm) wrote:
> If the user has requested a counting threshold for the CPU cycles event,
> then the fixed cycle counter can't be assigned as it lacks threshold
> support. Currently, the thresholds will work or not randomly depending
> on which counter the event is assigned.
> 
> While using thresholds for CPU cycles doesn't make much sense, it can be
> useful for testing purposes.
> 
> Fixes: 816c26754447 ("arm64: perf: Add support for event counting threshold")
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
> This should go to 6.10 and stable. It is also a dependency for ICNTR
> support.
> 
> v2:
>  - Add and use armv8pmu_event_get_threshold() helper.
> 
> v1: https://lore.kernel.org/all/20240611155012.2286044-1-robh@kernel.org/
> ---
>  drivers/perf/arm_pmuv3.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index 23fa6c5da82c..8ed5c3358920 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -338,6 +338,11 @@ static bool armv8pmu_event_want_user_access(struct perf_event *event)
>  	return ATTR_CFG_GET_FLD(&event->attr, rdpmc);
>  }
>  
> +static u32 armv8pmu_event_get_threshold(struct perf_event_attr *attr)
> +{
> +	return ATTR_CFG_GET_FLD(attr, threshold);
> +}
> +
>  static u8 armv8pmu_event_threshold_control(struct perf_event_attr *attr)
>  {
>  	u8 th_compare = ATTR_CFG_GET_FLD(attr, threshold_compare);
> @@ -941,7 +946,8 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
>  	unsigned long evtype = hwc->config_base & ARMV8_PMU_EVTYPE_EVENT;
>  
>  	/* Always prefer to place a cycle counter into the cycle counter. */
> -	if (evtype == ARMV8_PMUV3_PERFCTR_CPU_CYCLES) {
> +	if ((evtype == ARMV8_PMUV3_PERFCTR_CPU_CYCLES) &&
> +	    !armv8pmu_event_get_threshold(&event->attr)) {
>  		if (!test_and_set_bit(ARMV8_IDX_CYCLE_COUNTER, cpuc->used_mask))
>  			return ARMV8_IDX_CYCLE_COUNTER;
>  		else if (armv8pmu_event_is_64bit(event) &&
> @@ -1033,7 +1039,7 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
>  	 * If FEAT_PMUv3_TH isn't implemented, then THWIDTH (threshold_max) will
>  	 * be 0 and will also trigger this check, preventing it from being used.
>  	 */
> -	th = ATTR_CFG_GET_FLD(attr, threshold);
> +	th = armv8pmu_event_get_threshold(attr);
>  	if (th > threshold_max(cpu_pmu)) {
>  		pr_debug("PMU event threshold exceeds max value\n");
>  		return -EINVAL;
> 
> -- 
> 2.43.0
> 
