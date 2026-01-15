Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 923E73570AE
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 15:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768491844; cv=none; b=vFsLS75QWt9y+T7pu51enBmwkATvyoy3kKNok+wTfcDm1CGY//fgBpRuNzbqv/8aC2zhTXzx9RLWY4wEE04T63sWs3PBDDyBhd+C3MravkP93TAW6diREQMo6UONUVXMYJTWCuqI+K5MKVWLpUT/PnbK/O/JuyLUlsvGmHVMBqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768491844; c=relaxed/simple;
	bh=4zxoxpZ8WdqXuRvm0leoPyoaBDX40Ms5ZTqvzSuvC74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OwPFpMrQCd8VoycbDmGycIlh02hBpc1OME96MOgRwIBCm6y+NGG0vyUzBV4hhx0AoSebW90rKqXLFkqblqtDMJcF6eMjq6J75qZgN7LtZK0fDY7dJsJ+Cf164bI+qyNAYXQAwEx0XrWLKvVBybrjv7iifVZKjUNVbu+PCDTRllE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D99C5FEC;
	Thu, 15 Jan 2026 07:43:53 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B62DD3F59E;
	Thu, 15 Jan 2026 07:43:55 -0800 (PST)
Message-ID: <90561371-96f0-4bdb-8316-1b657f26da54@arm.com>
Date: Thu, 15 Jan 2026 15:43:54 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 28/47] arm_mpam: resctrl: Add support for csu counters
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, rohit.mathew@arm.com, scott@os.amperecomputing.com,
 sdonthineni@nvidia.com, tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com,
 catalin.marinas@arm.com, will@kernel.org, corbet@lwn.net, maz@kernel.org,
 oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
 kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-29-ben.horgan@arm.com>
 <e65d2b54-e14c-4b1d-a9ea-04b6e0eb051f@intel.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <e65d2b54-e14c-4b1d-a9ea-04b6e0eb051f@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 1/13/26 23:14, Reinette Chatre wrote:
> Hi Ben,
> 
> On 1/12/26 8:58 AM, Ben Horgan wrote:
>> From: James Morse <james.morse@arm.com>
>>
>> resctrl exposes a counter via a file named llc_occupancy. This isn't really
>> a counter as its value goes up and down, this is a snapshot of the cache
>> storage usage monitor.
>>
>> Add some picking code to find a cache as close as possible to the L3 that
>> supports the CSU monitor.
>>
>> If there is an L3, but it doesn't have any controls, force the L3 resource
>> to exist. The existing topology_matches_l3() and
>> mpam_resctrl_domain_hdr_init() code will ensure this looks like the L3,
>> even if the class belongs to a later cache.
>>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Co-developed-by: Dave Martin <dave.martin@arm.com>
>> Signed-off-by: Dave Martin <dave.martin@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>> Changes since rfc:
>> Allow csu counters however many partid or pmg there are
>> else if -> if
>> reduce scope of local variables
>> drop has_csu
>>
>> Changes since v2:
>> return -> break so works for mbwu in later patch
>> add for_each_mpam_resctrl_mon
>> return error from mpam_resctrl_monitor_init(). It may fail when is abmc
>> allocation introduced in a later patch.
>> Squashed in patch from Dave Martin:
>> https://lore.kernel.org/lkml/20250820131621.54983-1-Dave.Martin@arm.com/
>> ---
>>  drivers/resctrl/mpam_internal.h |   6 ++
>>  drivers/resctrl/mpam_resctrl.c  | 173 +++++++++++++++++++++++++++++++-
>>  2 files changed, 174 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
>> index f89ceaf7623d..21cc776e57aa 100644
>> --- a/drivers/resctrl/mpam_internal.h
>> +++ b/drivers/resctrl/mpam_internal.h
>> @@ -349,6 +349,12 @@ struct mpam_resctrl_res {
>>  	struct rdt_resource	resctrl_res;
>>  };
>>  
>> +struct mpam_resctrl_mon {
>> +	struct mpam_class	*class;
>> +
>> +	/* per-class data that resctrl needs will live here */
>> +};
>> +
>>  static inline int mpam_alloc_csu_mon(struct mpam_class *class)
>>  {
>>  	struct mpam_props *cprops = &class->props;
>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>> index 7402bf4293b6..5020a5faed96 100644
>> --- a/drivers/resctrl/mpam_resctrl.c
>> +++ b/drivers/resctrl/mpam_resctrl.c
>> @@ -37,6 +37,21 @@ static struct mpam_resctrl_res mpam_resctrl_controls[RDT_NUM_RESOURCES];
>>  /* The lock for modifying resctrl's domain lists from cpuhp callbacks. */
>>  static DEFINE_MUTEX(domain_list_lock);
>>  
>> +/*
>> + * The classes we've picked to map to resctrl events.
>> + * Resctrl believes all the worlds a Xeon, and these are all on the L3. This
>> + * array lets us find the actual class backing the event counters. e.g.
>> + * the only memory bandwidth counters may be on the memory controller, but to
>> + * make use of them, we pretend they are on L3.
>> + * Class pointer may be NULL.
>> + */
>> +static struct mpam_resctrl_mon mpam_resctrl_counters[QOS_NUM_EVENTS];
>> +
>> +#define for_each_mpam_resctrl_mon(mon, eventid)					\
>> +	for (eventid = 0, mon = &mpam_resctrl_counters[eventid];		\
>> +	     eventid < QOS_NUM_EVENTS;						\
>> +	     eventid++, mon = &mpam_resctrl_counters[eventid])
>> +
> 
> Reading the above loop and how it is used to call mpam_resctrl_monitor_init() for every event
> it looks like there is an implicit assumption that MPAM supports all events known to
> resctrl.
> 
> Please consider the most recent resctrl feature "telemetry monitoring" currently queued
> for inclusion: https://lore.kernel.org/lkml/20251217172121.12030-1-tony.luck@intel.com/
> 
> (You can find latest resctrl code queued for inclusion on the x86/cache branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git)

I'll test against this.

> 
> New telemetry monitoring introduces several new events known to resctrl. Specifically, here
> is how enum resctrl_event_id looks at the moment:
> 
> /* Event IDs */                                                                 
> enum resctrl_event_id {                                                         
> 	/* Must match value of first event below */                             
> 	QOS_FIRST_EVENT			= 0x01,                                 
[...]

Thanks for bringing this to my attention. mpam_resctrl_monitor_init()
won't be called for all events known to resctrl as
mpam_resctrl_pick_counters() will only set a class for the 3 that MPAM
knows about. Still, it is probably best to restrict the iterator to the
relevant ones.

> };                                     
> 
> ...
> 
>> @@ -582,6 +677,57 @@ static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *comp)
>>  	return comp->comp_id;
>>  }
>>  
>> +static int mpam_resctrl_monitor_init(struct mpam_resctrl_mon *mon,
>> +				     enum resctrl_event_id type)
>> +{
>> +	struct mpam_resctrl_res *res = &mpam_resctrl_controls[RDT_RESOURCE_L3];
>> +	struct rdt_resource *l3 = &res->resctrl_res;
>> +
>> +	lockdep_assert_cpus_held();
>> +
>> +	/* There also needs to be an L3 cache present */
>> +	if (get_cpu_cacheinfo_id(smp_processor_id(), 3) == -1)
>> +		return 0;
>> +
>> +	/*
>> +	 * If there are no MPAM resources on L3, force it into existence.
>> +	 * topology_matches_l3() already ensures this looks like the L3.
>> +	 * The domain-ids will be fixed up by mpam_resctrl_domain_hdr_init().
>> +	 */
>> +	if (!res->class) {
>> +		pr_warn_once("Faking L3 MSC to enable counters.\n");
>> +		res->class = mpam_resctrl_counters[type].class;
>> +	}
>> +
>> +	/* Called multiple times!, once per event type */
>> +	if (exposed_mon_capable) {
>> +		l3->mon_capable = true;
>> +
>> +		/* Setting name is necessary on monitor only platforms */
>> +		l3->name = "L3";
>> +		l3->mon_scope = RESCTRL_L3_CACHE;
>> +
>> +		resctrl_enable_mon_event(type);
> 
> btw, the telemetry work also changed this function prototype to be:
> 	bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
> 				      unsigned int binary_bits, void *arch_priv);

I will update to use the new signature.

> 
> If I understand correctly resctrl_enable_mon_event() will be called for every event in 
> enum resctrl_event_id which now contains events that may not actually be supported. I think it
> may be safer to be specific in which events MPAM wants to enable.

As noted above, this only happens for the ones chosen
mpam_resctrl_pick_counters().

> 
>> +
>> +		/*
>> +		 * Unfortunately, num_rmid doesn't mean anything for
>> +		 * mpam, and its exposed to user-space!
>> +		 *
> 
> The idea of adding a per MON group "num_mon_groups" file has been floated a couple of
> times now. I have not heard any objections against doing something like this.
> https://lore.kernel.org/all/cbe665c2-fe83-e446-1696-7115c0f9fd76@arm.com/
> https://lore.kernel.org/lkml/46767ca7-1f1b-48e8-8ce6-be4b00d129f9@intel.com/

Hmm, I see now that 'num_rmid' is documented as an upper bound and so
neither 1 or mpam_pmg_max + 1 agree with the documentation.

"
"num_rmids":
		The number of RMIDs available. This is the
		upper bound for how many "CTRL_MON" + "MON"
		groups can be created.
"

So, if I understand correctly you're proposing setting
num_rmids = num_pmg * num_partids on arm platforms and that in the
interim this can then be used to calculate the num_pmg by calculating
num_closid/num_rmid but that a per CTRL_MON num_mon_groups should be
added to make this consistent across architectures?

> 
>> +		 * num-rmid is supposed to mean the minimum number of
>> +		 * monitoring groups that can exist simultaneously, including
>> +		 * the default monitoring group for each control group.
>> +		 *
>> +		 * For mpam, each control group has its own pmg/rmid space, so
>> +		 * it is not appropriate to advertise the whole rmid_idx space
>> +		 * here.  But the pmgs corresponding to the parent control
>> +		 * group can be allocated freely:
>> +		 */
>> +		l3->mon.num_rmid = mpam_pmg_max + 1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
> 
> Reinette
> 

I appreciate that you have shared this resctrl knowledge with me.

Thanks,

Ben

