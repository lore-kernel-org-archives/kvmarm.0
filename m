Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DAEB22D7A8
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 13:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747748800; cv=none; b=aWt2xeW2f+oMTT9RgOTugnbLudpxnVLsN/pWOFJ3Ep/5jgQtIvLp0YpAfCGDeXOE9DOQ+L5CWolR3hynlRVluNyOrtVCYOerSWMB3VN4cGI1M9S5jad1ODYditp4b99ArlLWmHEzGrVkXSbdtRypkdlE9ILICI59MBjEjINx0x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747748800; c=relaxed/simple;
	bh=A3ymgb18BnOuOySJr5/XRA0C9ZYBVPd49CK+UkvTeoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oPPDU7XycZJ6P7LCPde97Aroj664TSIuKvF2MiK5fVACoB2sAN0e8RjF/OLtRvdQJt6dmZEr/AKJH9EzS6sQDmaIgypWvpJhNl090G6lyaAjm5KU+Ajz0w7PtkMo0dwk4FvFFHfdp5Pt9N40N9wOqh7FqvcS+pTNOWdjHJrtgHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 709A31516;
	Tue, 20 May 2025 06:46:23 -0700 (PDT)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7CBB93F5A1;
	Tue, 20 May 2025 06:46:36 -0700 (PDT)
Date: Tue, 20 May 2025 14:46:32 +0100
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
Subject: Re: [PATCH 07/10] perf: arm_spe: Add support for filtering on data
 source
Message-ID: <20250520134632.GR412060@e132581.arm.com>
References: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
 <20250506-james-perf-feat_spe_eft-v1-7-dd480e8e4851@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250506-james-perf-feat_spe_eft-v1-7-dd480e8e4851@linaro.org>

On Tue, May 06, 2025 at 12:41:39PM +0100, James Clark wrote:
> SPE_FEAT_FDS adds the ability to filter on the data source of packets.
> Like the other existing filters, enable filtering with PMSFCR_EL1.FDS
> when any of the filter bits are set.
> 
> Each bit maps to data sources 0-63 described by bits[0:5] in the data
> source packet (although the full range of data source is 16 bits so
> higher value data sources can't be filtered on). The filter is an OR of
> all the bits, so for example setting bits 0 and 3 filters packets from
> data sources 0 OR 3.

As Arm ARM says:

  0b0 : If PMSFCR_EL1.FDS is 1, do not record load operations that have
        bits [5:0] of the Data Source packet set to <m>.
  0b1 : Load operations with Data Source <m> are unaffected by
        PMSFCR_EL1.FDS.

We need extra handling for this configuration (0b0 means filtering,
0b1 means no affaction):

- By default, the driver should set all bits in the 'data_src_filter'
  field.

- The perf tool needs an extra patch in userspace to initialize all
  bits in config4 unless user specify other values.

Thanks,
Leo

> Signed-off-by: James Clark <james.clark@linaro.org>
> ---
>  drivers/perf/arm_spe_pmu.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> index 9309b846f642..d04318411f77 100644
> --- a/drivers/perf/arm_spe_pmu.c
> +++ b/drivers/perf/arm_spe_pmu.c
> @@ -87,6 +87,7 @@ struct arm_spe_pmu {
>  #define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
>  #define SPE_PMU_FEAT_DISCARD			(1UL << 7)
>  #define SPE_PMU_FEAT_EFT			(1UL << 8)
> +#define SPE_PMU_FEAT_FDS			(1UL << 9)
>  #define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
>  	u64					features;
>  
> @@ -232,6 +233,10 @@ static const struct attribute_group arm_spe_pmu_cap_group = {
>  #define ATTR_CFG_FLD_inv_event_filter_LO	0
>  #define ATTR_CFG_FLD_inv_event_filter_HI	63
>  
> +#define ATTR_CFG_FLD_data_src_filter_CFG	config4	/* PMSDSFR_EL1 */
> +#define ATTR_CFG_FLD_data_src_filter_LO	0
> +#define ATTR_CFG_FLD_data_src_filter_HI	63
> +
>  GEN_PMU_FORMAT_ATTR(ts_enable);
>  GEN_PMU_FORMAT_ATTR(pa_enable);
>  GEN_PMU_FORMAT_ATTR(pct_enable);
> @@ -248,6 +253,7 @@ GEN_PMU_FORMAT_ATTR(float_filter);
>  GEN_PMU_FORMAT_ATTR(float_filter_mask);
>  GEN_PMU_FORMAT_ATTR(event_filter);
>  GEN_PMU_FORMAT_ATTR(inv_event_filter);
> +GEN_PMU_FORMAT_ATTR(data_src_filter);
>  GEN_PMU_FORMAT_ATTR(min_latency);
>  GEN_PMU_FORMAT_ATTR(discard);
>  
> @@ -268,6 +274,7 @@ static struct attribute *arm_spe_pmu_formats_attr[] = {
>  	&format_attr_float_filter_mask.attr,
>  	&format_attr_event_filter.attr,
>  	&format_attr_inv_event_filter.attr,
> +	&format_attr_data_src_filter.attr,
>  	&format_attr_min_latency.attr,
>  	&format_attr_discard.attr,
>  	NULL,
> @@ -286,6 +293,9 @@ static umode_t arm_spe_pmu_format_attr_is_visible(struct kobject *kobj,
>  	if (attr == &format_attr_inv_event_filter.attr && !(spe_pmu->features & SPE_PMU_FEAT_INV_FILT_EVT))
>  		return 0;
>  
> +	if (attr == &format_attr_data_src_filter.attr && !(spe_pmu->features & SPE_PMU_FEAT_FDS))
> +		return 0;
> +
>  	if ((attr == &format_attr_branch_filter_mask.attr ||
>  	     attr == &format_attr_load_filter_mask.attr ||
>  	     attr == &format_attr_store_filter_mask.attr ||
> @@ -406,6 +416,9 @@ static u64 arm_spe_event_to_pmsfcr(struct perf_event *event)
>  	if (ATTR_CFG_GET_FLD(attr, inv_event_filter))
>  		reg |= PMSFCR_EL1_FnE;
>  
> +	if (ATTR_CFG_GET_FLD(attr, data_src_filter))
> +		reg |= PMSFCR_EL1_FDS;
> +
>  	if (ATTR_CFG_GET_FLD(attr, min_latency))
>  		reg |= PMSFCR_EL1_FL;
>  
> @@ -430,6 +443,12 @@ static u64 arm_spe_event_to_pmslatfr(struct perf_event *event)
>  	return FIELD_PREP(PMSLATFR_EL1_MINLAT, ATTR_CFG_GET_FLD(attr, min_latency));
>  }
>  
> +static u64 arm_spe_event_to_pmsdsfr(struct perf_event *event)
> +{
> +	struct perf_event_attr *attr = &event->attr;
> +	return ATTR_CFG_GET_FLD(attr, data_src_filter);
> +}
> +
>  static void arm_spe_pmu_pad_buf(struct perf_output_handle *handle, int len)
>  {
>  	struct arm_spe_pmu_buf *buf = perf_get_aux(handle);
> @@ -788,6 +807,10 @@ static int arm_spe_pmu_event_init(struct perf_event *event)
>  	if (arm_spe_event_to_pmsnevfr(event) & arm_spe_pmsevfr_res0(spe_pmu->pmsver))
>  		return -EOPNOTSUPP;
>  
> +	if (arm_spe_event_to_pmsdsfr(event) &&
> +	    !(spe_pmu->features & SPE_PMU_FEAT_FDS))
> +		return -EOPNOTSUPP;
> +
>  	if (attr->exclude_idle)
>  		return -EOPNOTSUPP;
>  
> @@ -857,6 +880,11 @@ static void arm_spe_pmu_start(struct perf_event *event, int flags)
>  		write_sysreg_s(reg, SYS_PMSNEVFR_EL1);
>  	}
>  
> +	if (spe_pmu->features & SPE_PMU_FEAT_FDS) {
> +		reg = arm_spe_event_to_pmsdsfr(event);
> +		write_sysreg_s(reg, SYS_PMSDSFR_EL1);
> +	}
> +
>  	reg = arm_spe_event_to_pmslatfr(event);
>  	write_sysreg_s(reg, SYS_PMSLATFR_EL1);
>  
> @@ -1116,6 +1144,9 @@ static void __arm_spe_pmu_dev_probe(void *info)
>  	if (FIELD_GET(PMSIDR_EL1_EFT, reg))
>  		spe_pmu->features |= SPE_PMU_FEAT_EFT;
>  
> +	if (FIELD_GET(PMSIDR_EL1_FDS, reg))
> +		spe_pmu->features |= SPE_PMU_FEAT_FDS;
> +
>  	/* This field has a spaced out encoding, so just use a look-up */
>  	fld = FIELD_GET(PMSIDR_EL1_INTERVAL, reg);
>  	switch (fld) {
> 
> -- 
> 2.34.1
> 
