Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1386C3128A7
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 14:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767708099; cv=none; b=qOML5S8lJtGJe+53whSPI0QiWoo78Oay2ZHNF7Wz33PIVwNcvKzQAOdplC4R4zuHoEY479azgNwizP0fl7QJ3jVxzIDqM/YGBfrKy38SsXbKQ1ACBwIwknVVm8ZRTMPMDlJg0PY9/wezO79RKS3zxqRGtseG1URtUc+cWJ5OH0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767708099; c=relaxed/simple;
	bh=fpSr73uOshzXCH2vd+aheFDZPqANqMjCWZYjY8hsGns=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UJI99obdCKlFcw+kkQOnzXoi5r7/0dmh2QoeFeXZt6vSUY+DBdTTaGpWJAnL5NxOZMmIIATCSr3l1kKm1/huJtf1Es0zW98vFeEolIBrErODy9jv4N8hro3NVJGS6CEACiQGyYs/e9E3LoLd0Qt0HZcYVxVn5JWzJntf7a/E0LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dltBL1k05zJ4786;
	Tue,  6 Jan 2026 22:01:30 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id DBFDD40565;
	Tue,  6 Jan 2026 22:01:31 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 14:01:30 +0000
Date: Tue, 6 Jan 2026 14:01:26 +0000
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
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>
Subject: Re: [PATCH v2 28/45] arm_mpam: resctrl: Pick classes for use as mbm
 counters
Message-ID: <20260106140126.0000558f@huawei.com>
In-Reply-To: <20251219181147.3404071-29-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-29-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 18:11:30 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> resctrl has two types of counters, NUMA-local and global. MPAM has only
> bandwidth counters, but the position of the MSC may mean it counts
> NUMA-local, or global traffic.
> 
> But the topology information is not available.
> 
> Apply a heuristic: the L2 or L3 supports bandwidth monitors, these are
> probably NUMA-local. If the memory controller supports bandwidth monitors,
> they are probably global.
> 
> This also allows us to assert that we don't have the same class backing two
> different resctrl events.
> 
> Because the class or component backing the event may not be 'the L3', it is
> necessary for mpam_resctrl_get_domain_from_cpu() to search the monitor
> domains too. This matters the most for 'monitor only' systems, where 'the
> L3' control domains may be empty, and the ctrl_comp pointer NULL.
> 
> resctrl expects there to be enough monitors for every possible control and
> monitor group to have one. Such a system gets called 'free running' as the
> monitors can be programmed once and left running.  Any other platform will
> need to emulate ABMC.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Hi Ben,

A few minor comments inline. + one question on a worrying sounding todo.

Jonathan

> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 5fde610cc9d7..51caf3b82392 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c



> @@ -925,6 +982,20 @@ static void mpam_resctrl_domain_insert(struct list_head *list,
>  	list_add_tail_rcu(&new->list, pos);
>  }
>  
> +static struct mpam_component *find_component(struct mpam_class *victim, int cpu)

This is a lovely generic sounding thing, but then the term victim comes in which
is very usecase specific.  Maybe something could have a better name? (either
function or avoid the victim naming).

> +{
> +	struct mpam_component *victim_comp;
> +
> +	guard(srcu)(&mpam_srcu);
> +	list_for_each_entry_srcu(victim_comp, &victim->components, class_list,
> +				 srcu_read_lock_held(&mpam_srcu)) {
> +		if (cpumask_test_cpu(cpu, &victim_comp->affinity))
> +			return victim_comp;
> +	}
> +
> +	return NULL;
> +}
> +
>  static struct mpam_resctrl_dom *
>  mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  {
> @@ -973,8 +1044,32 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  	}
>  
>  	if (exposed_mon_capable) {
> +		int i;
> +		struct mpam_component *mon_comp, *any_mon_comp;
> +
> +		/*
> +		 * Even if the monitor domain is backed by a different
> +		 * component, the L3 component IDs need to be used... only
> +		 * there may be no ctrl_comp for the L3.
> +		 * Search each event's class list for a component with
> +		 * overlapping CPUs and set up the dom->mon_comp array.
> +		 */
> +		for (i = 0; i < QOS_NUM_EVENTS; i++) {
For consistency with other loops (some of them anyway, I've not done
a detailed survey ;) I'd do
		for (int i = 0; ...
Probably bring scope of the mon_comp in here too.


> +			struct mpam_resctrl_mon *mon;
> +
> +			mon = &mpam_resctrl_counters[i];
> +			if (!mon->class)
> +				continue;       // dummy resource
> +
> +			mon_comp = find_component(mon->class, cpu);
> +			dom->mon_comp[i] = mon_comp;
> +			if (mon_comp)
> +				any_mon_comp = mon_comp;
> +		}
> +		WARN_ON_ONCE(!any_mon_comp);
> +
>  		mon_d = &dom->resctrl_mon_dom;
> -		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, &mon_d->hdr);
> +		mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, &mon_d->hdr);
>  		mon_d->hdr.type = RESCTRL_MON_DOMAIN;
>  		mpam_resctrl_domain_insert(&r->mon_domains, &mon_d->hdr);
>  		err = resctrl_online_mon_domain(r, mon_d);
> @@ -996,6 +1091,39 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>  	return dom;
>  }
>  
> +/*
> + * We know all the monitors are associated with the L3, even if there are no
> + * controls and therefore no control component. Find the cache-id for the CPU
> + * and use that to search for existing resctrl domains.
> + * This relies on mpam_resctrl_pick_domain_id() using the L3 cache-id
> + * for anything that is not a cache.
> + */
> +static struct mpam_resctrl_dom *mpam_resctrl_get_mon_domain_from_cpu(int cpu)
> +{
> +	u32 cache_id;
> +	struct rdt_mon_domain *mon_d;
> +	struct mpam_resctrl_dom *dom;
> +	struct mpam_resctrl_res *l3 = &mpam_resctrl_controls[RDT_RESOURCE_L3];
> +
> +	lockdep_assert_cpus_held();
> +
> +	if (!l3->class)
> +		return NULL;
> +	/* TODO: how does this order with cacheinfo updates under cpuhp? */

Considered a blocking todo or something that is future work to resolve if there
is an issue?

> +	cache_id = get_cpu_cacheinfo_id(cpu, 3);
> +	if (cache_id == ~0)
> +		return NULL;
> +
> +	list_for_each_entry_rcu(mon_d, &l3->resctrl_res.mon_domains, hdr.list) {
> +		dom = container_of(mon_d, struct mpam_resctrl_dom, resctrl_mon_dom);
Might as well move this under the condition.
I'm assuming no later patch needs dom for other reasons.

		if (mon_d->hdr.id == cache_id)
			return container_of(mon_d, struct mpam_resctrl_dom, resctrl_mon_dom);

> +
> +		if (mon_d->hdr.id == cache_id)
> +			return dom;
> +	}
> +
> +	return NULL;
> +}
