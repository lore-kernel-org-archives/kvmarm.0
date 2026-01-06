Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD2F242D89
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 12:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767701994; cv=none; b=Cts5YhHENpXE6zKGnRCgZlbKR51t2nNbWUR0rf8Vn0FvtDkbPk8I+zbrV8jMtQQusSgncARiXIBSmDcsVJ0LehjmY2QbEb0//lmK5G5J/kwgWlyjWGIx70qYMk8ob9nluYuP8nvLkcDYWVq9iCQa6zun/iOwLICu+fCDECD1xO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767701994; c=relaxed/simple;
	bh=ziydUESvAGcj7iq9qvXywHLw3FMdfnI5YtVH0eTgHqM=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uUQdERdYfTlmOQU9Csm8mPL05qlsw0u1PDI5EX5afc6oeoCTi5Lz6M5OqB/65/gKRSeiUw2+QNmXu5vWjuELIQHFhHmlEoJpaAFjbzzk8cu4cX7Do5KCqmYbb2rFsJgDkYVzM0l7WeuY6TuEF/ZMbHbof8CyCsQP1xt9bsilKDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlqwx5Qw4zJ4678;
	Tue,  6 Jan 2026 20:19:45 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 491D240570;
	Tue,  6 Jan 2026 20:19:47 +0800 (CST)
Received: from localhost (10.48.155.65) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 12:19:45 +0000
Date: Tue, 6 Jan 2026 12:19:44 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Ben Horgan <ben.horgan@arm.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <carl@os.amperecomputing.com>,
	<dave.martin@arm.com>, <david@kernel.org>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <gshan@redhat.com>, <james.morse@arm.com>,
	<kobak@nvidia.com>, <lcherian@marvell.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<peternewman@google.com>, <punit.agrawal@oss.qualcomm.com>,
	<quic_jiles@quicinc.com>, <reinette.chatre@intel.com>,
	<rohit.mathew@arm.com>, <scott@os.amperecomputing.com>,
	<sdonthineni@nvidia.com>, <tan.shaopeng@fujitsu.com>,
	<xhao@linux.alibaba.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<corbet@lwn.net>, <maz@kernel.org>, <oupton@kernel.org>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>,
	Zeng Heng <zengheng4@huawei.com>
Subject: Re: [PATCH v2 25/45] arm_mpam: resctrl: Add support for 'MB'
 resource
Message-ID: <20260106121944.0000499e@huawei.com>
In-Reply-To: <20251219181147.3404071-26-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-26-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 18:11:27 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> resctrl supports 'MB', as a percentage throttling of traffic somewhere
> after the L3. This is the control that mba_sc uses, so ideally the class
> chosen should be as close as possible to the counters used for mba_local.
> 
> MB's percentage control should be backed either with the fixed point

either's "or" is missing.  (sentence should include the second choice)

> fraction MBW_MAX. The bandwidth portion bitmaps is not used as its tricky
> to pick which bits to use to avoid contention, and may be possible to
> expose this as something other than a percentage in the future.
> 
> CC: Zeng Heng <zengheng4@huawei.com>
> Co-developed-by: Dave Martin <Dave.Martin@arm.com>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Signed-off-by: James Morse <james.morse@arm.com>>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

As mentioned in earlier review I'd like an overview doc of the heuristics
used to map to the resctrl everything is a xeon view of the world.

At least some of our platforms are far enough from this view that the
heuristics fail (others can provide more info on that than I can).
That's fine as I'd rather not squash something inappropriate into a
viewpoint that doesn't fit. Better to leave those for later solutions!


Otherwise, just minor comments inline.

Jonathan

> ---
>  drivers/resctrl/mpam_resctrl.c | 212 ++++++++++++++++++++++++++++++++-
>  1 file changed, 211 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index a20656e49edc..e376841c5596 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c

...

> +static u32 get_mba_min(struct mpam_props *cprops)
> +{
> +	u32 val = 0;
> +
> +	if (mba_class_use_mbw_max(cprops))
> +		val = mbw_max_to_percent(val, cprops);
> +	else
> +		WARN_ON_ONCE(1);
> +
> +	return val;

I'd be tempted to handle the error case first to make
clear this is really just a sanity checking wrapper around the max_to_percent()
function.

	if (!mba_class_use_mbw_max(cprops)) {
		WARN_ON_ONCE(1);
		return 0;
	}

	return mbw_max_to_percent(val, cprops);

> +}

> +/*
> + * topology_matches_l3() - Is the provided class the same shape as L3
> + * @victim:		The class we'd like to pretend is L3.
> + *
> + * resctrl expects all the world's a Xeon, and all counters are on the
> + * L3. We play fast and loose with this, mapping counters on other
> + * classes - provided the CPU->domain mapping is the same kind of shape.
> + *
> + * Using cacheinfo directly would make this work even if resctrl can't
> + * use the L3 - but cacheinfo can't tell us anything about offline CPUs.
> + * Using the L3 resctrl domain list also depends on CPUs being online.
> + * Using the mpam_class we picked for L3 so we can use its domain list
> + * assumes that there are MPAM controls on the L3.
> + * Instead, this path eventually uses the mpam_get_cpumask_from_cache_id()
> + * helper which can tell us about offline CPUs ... but getting the cache_id
> + * to start with relies on at least one CPU per L3 cache being online at
> + * boot.

So the usual mess of maxcpus=1 breaks it for anything other than first L3?
I'm not entirely against that but it may be a little unexpected.

> + *
> + * Walk the victim component list and compare the affinity mask with the
> + * corresponding L3. The topology matches if each victim:component's affinity
> + * mask is the same as the CPU's corresponding L3's. These lists/masks are
> + * computed from firmware tables so don't change at runtime.
> + */
> +static bool topology_matches_l3(struct mpam_class *victim)



> +
>  static int mpam_resctrl_control_init(struct mpam_resctrl_res *res,
>  				     enum resctrl_res_level type)
>  {
>  	struct mpam_class *class = res->class;
> +	struct mpam_props *cprops = &class->props;
>  	struct rdt_resource *r = &res->resctrl_res;
>  
>  	switch (r->rid) {
> @@ -361,6 +531,20 @@ static int mpam_resctrl_control_init(struct mpam_resctrl_res *res,
>  		 * 'all the bits' is the correct answer here.
>  		 */
>  		r->cache.shareable_bits = resctrl_get_default_ctrl(r);
> +		break;
> +	case RDT_RESOURCE_MBA:
> +		r->alloc_capable = true;
> +		r->schema_fmt = RESCTRL_SCHEMA_RANGE;
> +		r->ctrl_scope = RESCTRL_L3_CACHE;
> +
> +		r->membw.delay_linear = true;
> +		r->membw.throttle_mode = THREAD_THROTTLE_UNDEFINED;
> +		r->membw.min_bw = get_mba_min(cprops);
> +		r->membw.max_bw = MAX_MBA_BW;
> +		r->membw.bw_gran = get_mba_granularity(cprops);
> +
> +		r->name = "MB";
> +

Probably should be consistent with either a blank line before break or not.
That might also make the diff a little nicer.

>  		break;
>  	default:
>  		break;


