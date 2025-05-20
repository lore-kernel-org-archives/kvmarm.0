Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06D22701C9
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 10:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747737366; cv=none; b=WdC/dpHnqoU3vK1zS8neDEfuBbc24Iiz+Q9NcIiOpaClHORrRmOdzPbA9pte68FwbEvBM0HT4U5Sn8ILKKxqqSYUR/4b92xR5KHu8b6qxKm1BdrfUiXneH4J6ldquMQmNRbvpS04ng+pHGk1Cw3fpyOyA99imGBbCMC8uAiHuro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747737366; c=relaxed/simple;
	bh=w7K5pMtdrZyVLt797Uyr9uyQu/cmuG0bNkwUckl/TuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J3FqR7ECKYbNN+BsRItG+dG1Ilf1I25Q5KedEv93DoHMWAul8KomMhN2TcWXUbjS4qXBJEbj+l8FWsvScsZrN+t0XPsKXVSVOICRpm3/vZltjL+wytnJIeOSb5UQWh1yKf3DqwgoY+8hDKvfoAVeKE5YKiE6oja94oe/PGudOos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC3CF1516;
	Tue, 20 May 2025 03:35:49 -0700 (PDT)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC6343F6A8;
	Tue, 20 May 2025 03:36:02 -0700 (PDT)
Date: Tue, 20 May 2025 11:35:58 +0100
From: Leo Yan <leo.yan@arm.com>
To: James Clark <james.clark@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 03/10] perf: arm_spe: Add support for FEAT_SPE_EFT
 extended filtering
Message-ID: <20250520103558.GM412060@e132581.arm.com>
References: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
 <20250506-james-perf-feat_spe_eft-v1-3-dd480e8e4851@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250506-james-perf-feat_spe_eft-v1-3-dd480e8e4851@linaro.org>

On Tue, May 06, 2025 at 12:41:35PM +0100, James Clark wrote:
> FEAT_SPE_EFT (optional from Armv9.4) adds mask bits for the existing
> load, store and branch filters. It also adds two new filter bits for
> SIMD and floating point with their own associated mask bits. The current
> filters only allow OR filtering on samples that are load OR store etc,
> and the new mask bits allow setting part of the filter to an AND, for
> example filtering samples that are store AND SIMD. With mask bits set to
> 0, the OR behavior is preserved, so the unless any masks are explicitly
> set old filters will behave the same.
> 
> Add them all and make them behave the same way as existing format bits,
> hidden and return EOPNOTSUPP if set when the feature doesn't exist.
> 
> Signed-off-by: James Clark <james.clark@linaro.org>

Reviewed-by: Leo Yan <leo.yan@arm.com>

> ---
>  drivers/perf/arm_spe_pmu.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
> 
> diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> index d9f6d229dce8..9309b846f642 100644
> --- a/drivers/perf/arm_spe_pmu.c
> +++ b/drivers/perf/arm_spe_pmu.c
> @@ -86,6 +86,7 @@ struct arm_spe_pmu {
>  #define SPE_PMU_FEAT_ERND			(1UL << 5)
>  #define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
>  #define SPE_PMU_FEAT_DISCARD			(1UL << 7)
> +#define SPE_PMU_FEAT_EFT			(1UL << 8)
>  #define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
>  	u64					features;
>  
> @@ -197,6 +198,27 @@ static const struct attribute_group arm_spe_pmu_cap_group = {
>  #define ATTR_CFG_FLD_discard_CFG		config	/* PMBLIMITR_EL1.FM = DISCARD */
>  #define ATTR_CFG_FLD_discard_LO			35
>  #define ATTR_CFG_FLD_discard_HI			35
> +#define ATTR_CFG_FLD_branch_filter_mask_CFG	config	/* PMSFCR_EL1.Bm */
> +#define ATTR_CFG_FLD_branch_filter_mask_LO	36
> +#define ATTR_CFG_FLD_branch_filter_mask_HI	36
> +#define ATTR_CFG_FLD_load_filter_mask_CFG	config	/* PMSFCR_EL1.LDm */
> +#define ATTR_CFG_FLD_load_filter_mask_LO	37
> +#define ATTR_CFG_FLD_load_filter_mask_HI	37
> +#define ATTR_CFG_FLD_store_filter_mask_CFG	config	/* PMSFCR_EL1.STm */
> +#define ATTR_CFG_FLD_store_filter_mask_LO	38
> +#define ATTR_CFG_FLD_store_filter_mask_HI	38
> +#define ATTR_CFG_FLD_simd_filter_CFG		config	/* PMSFCR_EL1.SIMD */
> +#define ATTR_CFG_FLD_simd_filter_LO		39
> +#define ATTR_CFG_FLD_simd_filter_HI		39
> +#define ATTR_CFG_FLD_simd_filter_mask_CFG	config	/* PMSFCR_EL1.SIMDm */
> +#define ATTR_CFG_FLD_simd_filter_mask_LO	40
> +#define ATTR_CFG_FLD_simd_filter_mask_HI	40
> +#define ATTR_CFG_FLD_float_filter_CFG		config	/* PMSFCR_EL1.FP */
> +#define ATTR_CFG_FLD_float_filter_LO		41
> +#define ATTR_CFG_FLD_float_filter_HI		41
> +#define ATTR_CFG_FLD_float_filter_mask_CFG	config	/* PMSFCR_EL1.FPm */
> +#define ATTR_CFG_FLD_float_filter_mask_LO	42
> +#define ATTR_CFG_FLD_float_filter_mask_HI	42
>  
>  #define ATTR_CFG_FLD_event_filter_CFG		config1	/* PMSEVFR_EL1 */
>  #define ATTR_CFG_FLD_event_filter_LO		0
> @@ -215,8 +237,15 @@ GEN_PMU_FORMAT_ATTR(pa_enable);
>  GEN_PMU_FORMAT_ATTR(pct_enable);
>  GEN_PMU_FORMAT_ATTR(jitter);
>  GEN_PMU_FORMAT_ATTR(branch_filter);
> +GEN_PMU_FORMAT_ATTR(branch_filter_mask);
>  GEN_PMU_FORMAT_ATTR(load_filter);
> +GEN_PMU_FORMAT_ATTR(load_filter_mask);
>  GEN_PMU_FORMAT_ATTR(store_filter);
> +GEN_PMU_FORMAT_ATTR(store_filter_mask);
> +GEN_PMU_FORMAT_ATTR(simd_filter);
> +GEN_PMU_FORMAT_ATTR(simd_filter_mask);
> +GEN_PMU_FORMAT_ATTR(float_filter);
> +GEN_PMU_FORMAT_ATTR(float_filter_mask);
>  GEN_PMU_FORMAT_ATTR(event_filter);
>  GEN_PMU_FORMAT_ATTR(inv_event_filter);
>  GEN_PMU_FORMAT_ATTR(min_latency);
> @@ -228,8 +257,15 @@ static struct attribute *arm_spe_pmu_formats_attr[] = {
>  	&format_attr_pct_enable.attr,
>  	&format_attr_jitter.attr,
>  	&format_attr_branch_filter.attr,
> +	&format_attr_branch_filter_mask.attr,
>  	&format_attr_load_filter.attr,
> +	&format_attr_load_filter_mask.attr,
>  	&format_attr_store_filter.attr,
> +	&format_attr_store_filter_mask.attr,
> +	&format_attr_simd_filter.attr,
> +	&format_attr_simd_filter_mask.attr,
> +	&format_attr_float_filter.attr,
> +	&format_attr_float_filter_mask.attr,
>  	&format_attr_event_filter.attr,
>  	&format_attr_inv_event_filter.attr,
>  	&format_attr_min_latency.attr,
> @@ -250,6 +286,16 @@ static umode_t arm_spe_pmu_format_attr_is_visible(struct kobject *kobj,
>  	if (attr == &format_attr_inv_event_filter.attr && !(spe_pmu->features & SPE_PMU_FEAT_INV_FILT_EVT))
>  		return 0;
>  
> +	if ((attr == &format_attr_branch_filter_mask.attr ||
> +	     attr == &format_attr_load_filter_mask.attr ||
> +	     attr == &format_attr_store_filter_mask.attr ||
> +	     attr == &format_attr_simd_filter.attr ||
> +	     attr == &format_attr_simd_filter_mask.attr ||
> +	     attr == &format_attr_float_filter.attr ||
> +	     attr == &format_attr_float_filter_mask.attr) &&
> +	     !(spe_pmu->features & SPE_PMU_FEAT_EFT))
> +		return 0;
> +
>  	return attr->mode;
>  }
>  
> @@ -341,8 +387,15 @@ static u64 arm_spe_event_to_pmsfcr(struct perf_event *event)
>  	u64 reg = 0;
>  
>  	reg |= FIELD_PREP(PMSFCR_EL1_LD, ATTR_CFG_GET_FLD(attr, load_filter));
> +	reg |= FIELD_PREP(PMSFCR_EL1_LDm, ATTR_CFG_GET_FLD(attr, load_filter_mask));
>  	reg |= FIELD_PREP(PMSFCR_EL1_ST, ATTR_CFG_GET_FLD(attr, store_filter));
> +	reg |= FIELD_PREP(PMSFCR_EL1_STm, ATTR_CFG_GET_FLD(attr, store_filter_mask));
>  	reg |= FIELD_PREP(PMSFCR_EL1_B, ATTR_CFG_GET_FLD(attr, branch_filter));
> +	reg |= FIELD_PREP(PMSFCR_EL1_Bm, ATTR_CFG_GET_FLD(attr, branch_filter_mask));
> +	reg |= FIELD_PREP(PMSFCR_EL1_SIMD, ATTR_CFG_GET_FLD(attr, simd_filter));
> +	reg |= FIELD_PREP(PMSFCR_EL1_SIMDm, ATTR_CFG_GET_FLD(attr, simd_filter_mask));
> +	reg |= FIELD_PREP(PMSFCR_EL1_FP, ATTR_CFG_GET_FLD(attr, float_filter));
> +	reg |= FIELD_PREP(PMSFCR_EL1_FPm, ATTR_CFG_GET_FLD(attr, float_filter_mask));
>  
>  	if (reg)
>  		reg |= PMSFCR_EL1_FT;
> @@ -716,6 +769,10 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
>  	u64 reg;
>  	struct perf_event_attr *attr = &event->attr;
>  	struct arm_spe_pmu *spe_pmu = to_spe_pmu(event->pmu);
> +	const u64 feat_spe_eft_bits = PMSFCR_EL1_LDm | PMSFCR_EL1_STm |
> +				      PMSFCR_EL1_Bm | PMSFCR_EL1_SIMD |
> +				      PMSFCR_EL1_SIMDm | PMSFCR_EL1_FP |
> +				      PMSFCR_EL1_FPm;
>  
>  	/* This is, of course, deeply driver-specific */
>  	if (attr->type != event->pmu->type)
> @@ -761,6 +818,10 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
>  	    !(spe_pmu->features & SPE_PMU_FEAT_FILT_LAT))
>  		return -EOPNOTSUPP;
>  
> +	if ((reg & feat_spe_eft_bits) &&
> +	    !(spe_pmu->features & SPE_PMU_FEAT_EFT))
> +		return -EOPNOTSUPP;
> +
>  	if (ATTR_CFG_GET_FLD(&event->attr, discard) &&
>  	    !(spe_pmu->features & SPE_PMU_FEAT_DISCARD))
>  		return -EOPNOTSUPP;
> @@ -1052,6 +1113,9 @@ static void __arm_spe_pmu_dev_probe(void *info)
>  	if (spe_pmu->pmsver >= ID_AA64DFR0_EL1_PMSVer_V1P2)
>  		spe_pmu->features |= SPE_PMU_FEAT_DISCARD;
>  
> +	if (FIELD_GET(PMSIDR_EL1_EFT, reg))
> +		spe_pmu->features |= SPE_PMU_FEAT_EFT;
> +
>  	/* This field has a spaced out encoding, so just use a look-up */
>  	fld = FIELD_GET(PMSIDR_EL1_INTERVAL, reg);
>  	switch (fld) {
> 
> -- 
> 2.34.1
> 
