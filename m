Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D4C832548C
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 14:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767795712; cv=none; b=cVQ+zcPGpqcvWJtX0UdvT2o5odza0sWEVByo1GLYhojn30JSXwoj6f9dd3LZPDJng8qjZoiyIYku2PPjEGzhIAr6DvQ4w8CSq0TSOs2hECxbDSAjtZEZDxdP/e8Z7OiOfMPs9pntus2MGvrdiOcZnWQ/aXlu1RtQnVTzCMREhIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767795712; c=relaxed/simple;
	bh=Ht8CVL4cTZCeRAc2yCMcXfuJQ3mjv+Vgn2jqJp2gRP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ohFobUKHNcmR1ogIXSdaqRzqed+0aX2LFjFXg1VcnATXadfx32Y3Gak2/8Pqu68RDLf9CyFyMyP+GPBeLXQ30dfxQeg8d8yyE/qfeiGEEqtBLE1QstgyBLHGP2d6SvjdUa9W5rZOkdvjOBPSeZv5PGxcMa/Xlx/RFJdh2gX0gZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA800497;
	Wed,  7 Jan 2026 06:21:37 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9382A3F6A8;
	Wed,  7 Jan 2026 06:21:39 -0800 (PST)
Message-ID: <818b03f6-effb-4e7e-9ee8-49917504a5dd@arm.com>
Date: Wed, 7 Jan 2026 14:21:37 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 25/45] arm_mpam: resctrl: Add support for 'MB' resource
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 Zeng Heng <zengheng4@huawei.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
 <20251219181147.3404071-26-ben.horgan@arm.com>
 <20260106121944.0000499e@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260106121944.0000499e@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jonathan,

On 1/6/26 12:19, Jonathan Cameron wrote:
> On Fri, 19 Dec 2025 18:11:27 +0000
> Ben Horgan <ben.horgan@arm.com> wrote:
> 
>> From: James Morse <james.morse@arm.com>
>>
>> resctrl supports 'MB', as a percentage throttling of traffic somewhere
>> after the L3. This is the control that mba_sc uses, so ideally the class
>> chosen should be as close as possible to the counters used for mba_local.
>>
>> MB's percentage control should be backed either with the fixed point
> 
> either's "or" is missing.  (sentence should include the second choice)
> 
>> fraction MBW_MAX. The bandwidth portion bitmaps is not used as its tricky
>> to pick which bits to use to avoid contention, and may be possible to
>> expose this as something other than a percentage in the future.
>>
>> CC: Zeng Heng <zengheng4@huawei.com>
>> Co-developed-by: Dave Martin <Dave.Martin@arm.com>
>> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
>> Signed-off-by: James Morse <james.morse@arm.com>>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> 
> As mentioned in earlier review I'd like an overview doc of the heuristics
> used to map to the resctrl everything is a xeon view of the world.
> 
> At least some of our platforms are far enough from this view that the
> heuristics fail (others can provide more info on that than I can).
> That's fine as I'd rather not squash something inappropriate into a
> viewpoint that doesn't fit. Better to leave those for later solutions!

Yes, this is still in the pipeline.

> 
> 
> Otherwise, just minor comments inline.
> 
> Jonathan
> 
>> ---
>>  drivers/resctrl/mpam_resctrl.c | 212 ++++++++++++++++++++++++++++++++-
>>  1 file changed, 211 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>> index a20656e49edc..e376841c5596 100644
>> --- a/drivers/resctrl/mpam_resctrl.c
>> +++ b/drivers/resctrl/mpam_resctrl.c
> 
> ...
> 
>> +static u32 get_mba_min(struct mpam_props *cprops)
>> +{
>> +	u32 val = 0;
>> +
>> +	if (mba_class_use_mbw_max(cprops))
>> +		val = mbw_max_to_percent(val, cprops);
>> +	else
>> +		WARN_ON_ONCE(1);
>> +
>> +	return val;
> 
> I'd be tempted to handle the error case first to make
> clear this is really just a sanity checking wrapper around the max_to_percent()
> function.
> 
> 	if (!mba_class_use_mbw_max(cprops)) {
> 		WARN_ON_ONCE(1);
> 		return 0;
> 	}
> 
> 	return mbw_max_to_percent(val, cprops);

Sure, I've updated this.

> 
>> +}
> 
>> +/*
>> + * topology_matches_l3() - Is the provided class the same shape as L3
>> + * @victim:		The class we'd like to pretend is L3.
>> + *
>> + * resctrl expects all the world's a Xeon, and all counters are on the
>> + * L3. We play fast and loose with this, mapping counters on other
>> + * classes - provided the CPU->domain mapping is the same kind of shape.
>> + *
>> + * Using cacheinfo directly would make this work even if resctrl can't
>> + * use the L3 - but cacheinfo can't tell us anything about offline CPUs.
>> + * Using the L3 resctrl domain list also depends on CPUs being online.
>> + * Using the mpam_class we picked for L3 so we can use its domain list
>> + * assumes that there are MPAM controls on the L3.
>> + * Instead, this path eventually uses the mpam_get_cpumask_from_cache_id()
>> + * helper which can tell us about offline CPUs ... but getting the cache_id
>> + * to start with relies on at least one CPU per L3 cache being online at
>> + * boot.
> 
> So the usual mess of maxcpus=1 breaks it for anything other than first L3?
> I'm not entirely against that but it may be a little unexpected.

Yes but this doesn't really add any knew restriction as the mpam base
driver only enables mpam when all (known) msc have been probed and for
an msc on a cache we only ever access it from the cpus local to that cache.

> 
>> + *
>> + * Walk the victim component list and compare the affinity mask with the
>> + * corresponding L3. The topology matches if each victim:component's affinity
>> + * mask is the same as the CPU's corresponding L3's. These lists/masks are
>> + * computed from firmware tables so don't change at runtime.
>> + */
>> +static bool topology_matches_l3(struct mpam_class *victim)
> 
> 
> 
>> +
>>  static int mpam_resctrl_control_init(struct mpam_resctrl_res *res,
>>  				     enum resctrl_res_level type)
>>  {
>>  	struct mpam_class *class = res->class;
>> +	struct mpam_props *cprops = &class->props;
>>  	struct rdt_resource *r = &res->resctrl_res;
>>  
>>  	switch (r->rid) {
>> @@ -361,6 +531,20 @@ static int mpam_resctrl_control_init(struct mpam_resctrl_res *res,
>>  		 * 'all the bits' is the correct answer here.
>>  		 */
>>  		r->cache.shareable_bits = resctrl_get_default_ctrl(r);
>> +		break;
>> +	case RDT_RESOURCE_MBA:
>> +		r->alloc_capable = true;
>> +		r->schema_fmt = RESCTRL_SCHEMA_RANGE;
>> +		r->ctrl_scope = RESCTRL_L3_CACHE;
>> +
>> +		r->membw.delay_linear = true;
>> +		r->membw.throttle_mode = THREAD_THROTTLE_UNDEFINED;
>> +		r->membw.min_bw = get_mba_min(cprops);
>> +		r->membw.max_bw = MAX_MBA_BW;
>> +		r->membw.bw_gran = get_mba_granularity(cprops);
>> +
>> +		r->name = "MB";
>> +
> 
> Probably should be consistent with either a blank line before break or not.
> That might also make the diff a little nicer.

Dropped the blank line.

> 
>>  		break;
>>  	default:
>>  		break;
> 
> 

Thanks,

Ben

