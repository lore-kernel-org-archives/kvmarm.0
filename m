Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38F931B13B
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 17:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767634816; cv=none; b=djCIV+jX0GlwceUn1+L3ZPUZmfLElKrj2PgwDNdIYPftz/Vy3j+S6NVH51tA5n2+wSE7O477obgB85LVK9+T9ebFlnEZpjPqwwIHDUXsvEO6042L0GT9A+xzvedQ3maEEdD+1mAe1sgM2d+DTFTAR7U8RddMevnm67sgpAF/jM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767634816; c=relaxed/simple;
	bh=PEuJkoItlMCDyN3ZHNhE3UfMwhjSUmGZFpnct/LlekM=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XgFFZVC30tjeDr3Q05hp1PWsBNIgMxm4Vc3eWo3qzoLkwoD0FU1/fSkXOPZ9dBi7MWQyYyzOm0fsJ8iL7dOZGJaKf27LusDhfCXOXMgjDbG4GDRZiQVcHEvezcwnL6TsrpnR+goij1MfQwKXCpMVNrA/rz8S+OJFhIDB6hFeilQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlM526ZjtzHnGcc;
	Tue,  6 Jan 2026 01:40:06 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 83CB840539;
	Tue,  6 Jan 2026 01:40:09 +0800 (CST)
Received: from localhost (10.126.174.38) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 5 Jan
 2026 17:40:07 +0000
Date: Mon, 5 Jan 2026 17:40:05 +0000
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
Subject: Re: [PATCH v2 15/45] arm_mpam: resctrl: Add boilerplate cpuhp and
 domain allocation
Message-ID: <20260105174005.00001ba0@huawei.com>
In-Reply-To: <20251219181147.3404071-16-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-16-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 18:11:17 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> resctrl has its own data structures to describe its resources. We can't use
> these directly as we play tricks with the 'MBA' resource, picking the MPAM
> controls or monitors that best apply. We may export the same component as
> both L3 and MBA.
> 
> Add mpam_resctrl_exports[] as the array of class->resctrl mappings we are
> exporting, and add the cpuhp hooks that allocated and free the resctrl
> domain structures.
> 
> While we're here, plumb in a few other obvious things.
> 
> CONFIG_ARM_CPU_RESCTRL is used to allow this code to be built even though
> it can't yet be linked against resctrl.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Domain list is an rcu list
> Add synchronize_rcu() to free the deleted element
> Code flow simplification (Jonathan)

Just trivial stuff and that one what do we loop over thing that
we continued discussing in the RFC thread (I think you already
tidied that up)  Nothing here to stop:
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
(which is another way of saying I'm not planning to read it again :)


> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> new file mode 100644
> index 000000000000..4beeeded00ff
> --- /dev/null
> +++ b/drivers/resctrl/mpam_resctrl.c

> +
> +static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *comp)
> +{
> +	struct mpam_class *class = comp->class;
> +
> +	if (class->type == MPAM_CLASS_CACHE)
> +		return comp->comp_id;
> +
> +	/* TODO: repaint domain ids to match the L3 domain ids */
> +	/*
> +	 * Otherwise, expose the ID used by the firmware table code.
Maybe more turns up in here. Otherwise, easily fits in single line comment.
> +	 */
> +	return comp->comp_id;
> +}

> +static struct mpam_resctrl_dom *
> +mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
> +{
> +	struct mpam_resctrl_dom *dom;
> +	struct rdt_ctrl_domain *ctrl_d;
> +	struct rdt_resource *r = &res->resctrl_res;
> +
> +	lockdep_assert_cpus_held();
> +
> +	list_for_each_entry_rcu(ctrl_d, &r->ctrl_domains, hdr.list) {

As a reminder, though I think you already changed this, discussion carried
on wrt to the RFC version of this loop.

> +		dom = container_of(ctrl_d, struct mpam_resctrl_dom,
> +				   resctrl_ctrl_dom);
> +
> +		if (cpumask_test_cpu(cpu, &dom->ctrl_comp->affinity))
> +			return dom;
> +	}
> +
> +	return NULL;
> +}

> +
> +void mpam_resctrl_offline_cpu(unsigned int cpu)
> +{
> +	resctrl_offline_cpu(cpu);
> +
> +	guard(mutex)(&domain_list_lock);
> +	for (int i = 0; i < RDT_NUM_RESOURCES; i++) {
> +		struct mpam_resctrl_res *res;
> +		struct mpam_resctrl_dom *dom;
> +		struct rdt_mon_domain *mon_d;
> +		struct rdt_ctrl_domain *ctrl_d;
> +		bool ctrl_dom_empty, mon_dom_empty;
> +
> +		res = &mpam_resctrl_controls[i];
> +		if (!res->class)
> +			continue;	// dummy resource
> +
> +		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
> +		if (WARN_ON_ONCE(!dom))
> +			continue;
> +
> +		ctrl_dom_empty = true;
> +		if (exposed_alloc_capable) {
> +			ctrl_d = &dom->resctrl_ctrl_dom;
> +			ctrl_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
> +			if (ctrl_dom_empty)
> +				resctrl_offline_ctrl_domain(&res->resctrl_res, ctrl_d);
> +		}
really small thing but I'd do 
		} else {
			ctrl_dom_empty = true;
		}
here to make it visually obvious why that is set to true. The initialize and override
if we have more info pattern is to me less readable.

> +
> +		mon_dom_empty = true;
> +		if (exposed_mon_capable) {
> +			mon_d = &dom->resctrl_mon_dom;
> +			mon_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &mon_d->hdr);
> +			if (mon_dom_empty)
> +				resctrl_offline_mon_domain(&res->resctrl_res, mon_d);
> +		}
Similar for this one.
> +
> +		if (ctrl_dom_empty && mon_dom_empty)
> +			kfree(dom);
> +	}
> +}

