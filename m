Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEB528DF07
	for <kvmarm@lists.linux.dev>; Thu,  5 Feb 2026 16:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770310231; cv=none; b=uuHrTTkH53OspVoPTKBdUsV2kVgpJhJZ+0sWuLY2J6IgblIjs7uCpX/wTUXy1FcYZGIWmuU6JMDLo+ey4ZTwLIcQyoAzFWNY1Bk0KbZqILZ9xQgvEzQ9QMrBAIVbIhdvgDUh/FVNLBpWcdxqiIQLt9nkoba5TyhZTrm77TNHVWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770310231; c=relaxed/simple;
	bh=rbgRPiqM5uEcZbwOhS+0SoSpLM5h4JB/ORx+wx2+20Q=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mhCTZjRL6Gx6V4CK5psi+zEiyAP8QMF/9D+TpP2ysFLLXdeeAHFXmpQG9WJAUFxuQ2jNi4SLsXuLgVMhvM7aFXwWF1TGp3itweXjGnMo5lvX1PjArbtWLIzEoLr1iXp2YowZVER1UK37AyOKyMzSyRoSjHwkOWI2lfwV+OkWfI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f6NVN0NNdzJ467c;
	Fri,  6 Feb 2026 00:49:32 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id F095B40584;
	Fri,  6 Feb 2026 00:50:22 +0800 (CST)
Received: from localhost (10.48.151.164) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 5 Feb
 2026 16:50:21 +0000
Date: Thu, 5 Feb 2026 16:50:18 +0000
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
	<zengheng4@huawei.com>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 26/41] arm_mpam: resctrl: Add support for 'MB'
 resource
Message-ID: <20260205165018.0000089c@huawei.com>
In-Reply-To: <20260203214342.584712-27-ben.horgan@arm.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
	<20260203214342.584712-27-ben.horgan@arm.com>
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
 dubpeml500005.china.huawei.com (7.214.145.207)

On Tue, 3 Feb 2026 21:43:27 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> resctrl supports 'MB', as a percentage throttling of traffic from the
> L3. This is the control that mba_sc uses, so ideally the class chosen
> should be as close as possible to the counters used for mbm_total. If
> there is a single L3 and the topology of the memory matches then the
> traffic at the memory controller will be equivalent to that at egress of
> the L3. If these conditions are met allow the memory class to back MB.
> 
> MB's percentage control should be backed either with the fixed point
> fraction MBW_MAX or bandwidth portion bitmaps. The bandwidth portion
> bitmaps is not used as its tricky to pick which bits to use to avoid
> contention, and may be possible to expose this as something other than a
> percentage in the future.

I'm very curious to know whether this heuristic is actually useful on many
systems or whether many / most of them fail this 'shape' heuristic.

Otherwise, just comments on the placement of __free related declarations.
See the guidance in cleanup.h for that.

With those moved, 
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


> 
> CC: Zeng Heng <zengheng4@huawei.com>
> Co-developed-by: Dave Martin <Dave.Martin@arm.com>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Signed-off-by: James Morse <james.morse@arm.com>>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since v2:
> Code flow change
> Commit message 'or'
> 
> Changes since v3:
> initialise tmp_cpumask
> update commit message
> check the traffic matches l3
> update comment on candidate_class update, only mbm_total
> drop tags due to rework
> ---
>  drivers/resctrl/mpam_resctrl.c | 275 ++++++++++++++++++++++++++++++++-
>  1 file changed, 274 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 25950e667077..4cca3694978d 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c

> +/*
> + * topology_matches_l3() - Is the provided class the same shape as L3
> + * @victim:		The class we'd like to pretend is L3.
> + *
> + * resctrl expects all the world's a Xeon, and all counters are on the
> + * L3. We allow some mapping counters on other classes. This requires
> + * that the CPU->domain mapping is the same kind of shape.
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
> + *
> + * Walk the victim component list and compare the affinity mask with the
> + * corresponding L3. The topology matches if each victim:component's affinity
> + * mask is the same as the CPU's corresponding L3's. These lists/masks are
> + * computed from firmware tables so don't change at runtime.
> + */
> +static bool topology_matches_l3(struct mpam_class *victim)
> +{
> +	int cpu, err;
> +	struct mpam_component *victim_iter;
> +	cpumask_var_t __free(free_cpumask_var) tmp_cpumask = CPUMASK_VAR_NULL;

Same as below.  Move it down right next to the alloc.

> +
> +	lockdep_assert_cpus_held();
> +
> +	if (!alloc_cpumask_var(&tmp_cpumask, GFP_KERNEL))
> +		return false;
> +
> +	guard(srcu)(&mpam_srcu);
> +	list_for_each_entry_srcu(victim_iter, &victim->components, class_list,
> +				 srcu_read_lock_held(&mpam_srcu)) {
> +		if (cpumask_empty(&victim_iter->affinity)) {
> +			pr_debug("class %u has CPU-less component %u - can't match L3!\n",
> +				 victim->level, victim_iter->comp_id);
> +			return false;
> +		}
> +
> +		cpu = cpumask_any_and(&victim_iter->affinity, cpu_online_mask);
> +		if (WARN_ON_ONCE(cpu >= nr_cpu_ids))
> +			return false;
> +
> +		cpumask_clear(tmp_cpumask);
> +		err = find_l3_equivalent_bitmask(cpu, tmp_cpumask);
> +		if (err) {
> +			pr_debug("Failed to find L3's equivalent component to class %u component %u\n",
> +				 victim->level, victim_iter->comp_id);
> +			return false;
> +		}
> +
> +		/* Any differing bits in the affinity mask? */
> +		if (!cpumask_equal(tmp_cpumask, &victim_iter->affinity)) {
> +			pr_debug("class %u component %u has Mismatched CPU mask with L3 equivalent\n"
> +				 "L3:%*pbl != victim:%*pbl\n",
> +				 victim->level, victim_iter->comp_id,
> +				 cpumask_pr_args(tmp_cpumask),
> +				 cpumask_pr_args(&victim_iter->affinity));
> +
> +			return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * Test if the traffic for a class matches that at egress from the L3. For
> + * MSC at memory controllers this is only possible if there is a single L3
> + * as otherwise the counters at the memory can include bandwidth from the
> + * non-local L3.
> + */
> +static bool traffic_matches_l3(struct mpam_class *class) {
> +	int err, cpu;
> +	cpumask_var_t __free(free_cpumask_var) tmp_cpumask = CPUMASK_VAR_NULL;
> +
> +	lockdep_assert_cpus_held();
> +
> +	if (class->type == MPAM_CLASS_CACHE && class->level == 3)
> +		return true;
> +
> +	if (class->type == MPAM_CLASS_CACHE && class->level != 3) {
> +		pr_debug("class %u is a different cache from L3\n", class->level);
> +		return false;
> +	}
> +
> +	if (class->type != MPAM_CLASS_MEMORY) {
> +		pr_debug("class %u is neither of type cache or memory\n", class->level);
> +		return false;
> +	}
> +

I would suggest following guidance in cleanup.h to put declaration of
destructor and constructor together. That would mean bringing declaration
of tmp_cpumask down here.  The set it NULL at the top pattern got some
firm push back from Linus a while back.

> +	if (!alloc_cpumask_var(&tmp_cpumask, GFP_KERNEL)) {
> +		pr_debug("cpumask allocation failed\n");
> +		return false;
> +	}
> +
> +	if (class->type != MPAM_CLASS_MEMORY) {
> +		pr_debug("class %u is neither of type cache or memory\n",
> +			 class->level);
> +		return false;
> +	}
> +
> +	cpu = cpumask_any_and(&class->affinity, cpu_online_mask);
> +	err = find_l3_equivalent_bitmask(cpu, tmp_cpumask);
> +	if (err) {
> +		pr_debug("Failed to find L3 downstream to cpu %d\n", cpu);
> +		return false;
> +	}
> +
> +	if (!cpumask_equal(tmp_cpumask, cpu_possible_mask)) {
> +		pr_debug("There is more than one L3\n");
> +		return false;
> +	}
> +
> +	/* Be strict; the traffic might stop in the intermediate cache. */
> +	if (get_cpu_cacheinfo_id(cpu, 4) != -1) {
> +		pr_debug("L3 isn't the last level of cache\n");
> +		return false;
> +	}
> +
> +	return true;
> +}

