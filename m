Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DB2B2BDC35
	for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 15:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770824215; cv=none; b=bA4VeBn3611EP4rkLAL36ZiKmObV8qeAb8Wdb9vOX01JBD2UQqOe0BevhWbIxRLOCar/vv5MiLjtR9l3ADEZ+/y4/jbzC/QKSGICJhkO6w7fsQJbdZ7mS0EX7Jeq43te0xrh7MdgymivpgsIoCd/3yaND0xt3kZfrbX2/GViUlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770824215; c=relaxed/simple;
	bh=9eodLtiKiUBne97H3ZMFNsvvchRXNaUKeHTqVd37dgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NFMpAAF+SrqIKLSp8hkX2COQj0g6s7JgroImaoDyVHQTBmtrkB/i0n+bOB2BB6TmCEtw9dzjNo2iH3hvUMVspxoq5h83TNU6hVrvy6us9xzXWU7HbVb6Y2WZAxW61YPnnIetvagmgEiw6Io2ZG+bsWXmw7bq34wCWuMMd7f1XvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34CA2339;
	Wed, 11 Feb 2026 07:36:47 -0800 (PST)
Received: from e134344.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 25FC83F63F;
	Wed, 11 Feb 2026 07:36:48 -0800 (PST)
Date: Wed, 11 Feb 2026 15:36:45 +0000
From: Ben Horgan <ben.horgan@arm.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
	baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
	dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
	fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
	jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	peternewman@google.com, punit.agrawal@oss.qualcomm.com,
	quic_jiles@quicinc.com, rohit.mathew@arm.com,
	scott@os.amperecomputing.com, sdonthineni@nvidia.com,
	tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com,
	catalin.marinas@arm.com, will@kernel.org, corbet@lwn.net,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
	zengheng4@huawei.com, linux-doc@vger.kernel.org,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Subject: Re: [PATCH v4 13/41] arm_mpam: resctrl: Add boilerplate cpuhp and
 domain allocation
Message-ID: <aYyiDRD6u6p4a98h@e134344.arm.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-14-ben.horgan@arm.com>
 <f2951303-6fe9-4674-bd16-0dbef39cc1d4@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2951303-6fe9-4674-bd16-0dbef39cc1d4@intel.com>

Hi Reinette,

On Tue, Feb 10, 2026 at 02:57:29PM -0800, Reinette Chatre wrote:
> Hi Ben,
> 
> On 2/3/26 1:43 PM, Ben Horgan wrote:
> ...
> > diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> > new file mode 100644
> > index 000000000000..4c2248c92955
> > --- /dev/null
> > +++ b/drivers/resctrl/mpam_resctrl.c
> > @@ -0,0 +1,343 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// Copyright (C) 2025 Arm Ltd.
> > +
> > +#define pr_fmt(fmt) "%s:%s: " fmt, KBUILD_MODNAME, __func__
> > +
> > +#include <linux/arm_mpam.h>
> > +#include <linux/cacheinfo.h>
> > +#include <linux/cpu.h>
> > +#include <linux/cpumask.h>
> > +#include <linux/errno.h>
> > +#include <linux/list.h>
> > +#include <linux/printk.h>
> > +#include <linux/rculist.h>
> > +#include <linux/resctrl.h>
> > +#include <linux/slab.h>
> > +#include <linux/types.h>
> > +
> > +#include <asm/mpam.h>
> > +
> > +#include "mpam_internal.h"
> > +
> > +/*
> > + * The classes we've picked to map to resctrl resources, wrapped
> > + * in with their resctrl structure.
> > + * Class pointer may be NULL.
> > + */
> > +static struct mpam_resctrl_res mpam_resctrl_controls[RDT_NUM_RESOURCES];
> > +
> > +#define for_each_mpam_resctrl_control(res, rid)					\
> > +	for (rid = 0, res = &mpam_resctrl_controls[rid];			\
> > +	     rid < RDT_NUM_RESOURCES;						\
> > +	     rid++, res = &mpam_resctrl_controls[rid])
> > +
> > +/* The lock for modifying resctrl's domain lists from cpuhp callbacks. */
> > +static DEFINE_MUTEX(domain_list_lock);
> > +
> > +static bool exposed_alloc_capable;
> > +static bool exposed_mon_capable;
> > +
> > +bool resctrl_arch_alloc_capable(void)
> > +{
> > +	return exposed_alloc_capable;
> > +}
> > +
> > +bool resctrl_arch_mon_capable(void)
> > +{
> > +	return exposed_mon_capable;
> > +}
> > +
> > +/*
> > + * MSC may raise an error interrupt if it sees an out or range partid/pmg,
> > + * and go on to truncate the value. Regardless of what the hardware supports,
> > + * only the system wide safe value is safe to use.
> > + */
> > +u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
> > +{
> > +	return mpam_partid_max + 1;
> > +}
> > +
> > +struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
> > +{
> > +	if (l >= RDT_NUM_RESOURCES)
> > +		return NULL;
> > +
> > +	return &mpam_resctrl_controls[l].resctrl_res;
> > +}
> > +
> > +static int mpam_resctrl_control_init(struct mpam_resctrl_res *res)
> > +{
> > +	/* TODO: initialise the resctrl resources */
> > +
> > +	return 0;
> > +}
> > +
> > +static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *comp)
> > +{
> > +	struct mpam_class *class = comp->class;
> > +
> > +	if (class->type == MPAM_CLASS_CACHE)
> > +		return comp->comp_id;
> > +
> > +	/* TODO: repaint domain ids to match the L3 domain ids */
> > +	/* Otherwise, expose the ID used by the firmware table code. */
> > +	return comp->comp_id;
> > +}
> > +
> > +static void mpam_resctrl_domain_hdr_init(int cpu, struct mpam_component *comp,
> > +					 struct rdt_domain_hdr *hdr)
> > +{
> > +	lockdep_assert_cpus_held();
> > +
> > +	INIT_LIST_HEAD(&hdr->list);
> > +	hdr->id = mpam_resctrl_pick_domain_id(cpu, comp);
> > +	cpumask_set_cpu(cpu, &hdr->cpu_mask);
> 
> One addition via the resctrl telemetry enabling is a new rdt_domain_hdr::rid
> used for some additional checks on the header.
> https://lore.kernel.org/all/20251217172121.12030-2-tony.luck@intel.com/
> I may be missing something here though since the additional checking that this
> new field supports should have complained loudly ... unless this was tested with
> only the L3 resource that happens to be 0.

Hmmm, thanks for pointing this out. I think I've been getting away with this as
in the resctrl common code checking for 'rid' only happens for monitors which we
do keep on the L3 resource and the control checking is only in the x86.  I'll
look into this a bit more and update for this change.

> 
> ...
> 
> > +static struct mpam_resctrl_dom *
> > +mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
> > +{
> > +	struct mpam_resctrl_dom *dom;
> > +	struct rdt_resource *r = &res->resctrl_res;
> > +
> > +	lockdep_assert_cpus_held();
> > +
> > +	list_for_each_entry_rcu(dom, &r->ctrl_domains, resctrl_ctrl_dom.hdr.list) {
> > +		if (cpumask_test_cpu(cpu, &dom->ctrl_comp->affinity))
> > +			return dom;
> > +	}
> 
> I notice here that that only the ctrl_domains list is searched ...

The monitor searching is added in:
 [PATCH v4 28/41] arm_mpam: resctrl: Pick classes for use as mbm counters
This does seems like a bad code split. Even more so as csu counters are
added before the mbm counters.

> 
> > +
> > +	return NULL;
> > +}
> > +
> > +int mpam_resctrl_online_cpu(unsigned int cpu)
> > +{
> > +	struct mpam_resctrl_res *res;
> > +	enum resctrl_res_level rid;
> > +
> > +	guard(mutex)(&domain_list_lock);
> > +	for_each_mpam_resctrl_control(res, rid) {
> > +		struct mpam_resctrl_dom *dom;
> > +
> > +		if (!res->class)
> > +			continue;	// dummy_resource;
> > +
> > +		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
> 
> Consider a system that only supports monitoring (exposed_alloc_capable == false,
> exposed_mon_capable == true). Since mpam_resctrl_get_domain_from_cpu() only
> searches control domains then it looks to me as though dom will always be false
> here?
> 
> > +		if (!dom) {
> > +			dom = mpam_resctrl_alloc_domain(cpu, res);
> 
> Would this (on hypothetical exposed_alloc_capable == false, exposed_mon_capable == true system)
> then cause a new domain to be allocated for each CPU with a single CPU in its cpumask
> instead of allocating a single monitoring domain with multiple CPUs in its mask?
> 
> > +		} else {
> > +			if (exposed_alloc_capable) {
> > +				struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
> > +
> > +				mpam_resctrl_online_domain_hdr(cpu, &ctrl_d->hdr);
> > +			}
> > +			if (exposed_mon_capable) {
> > +				struct rdt_l3_mon_domain *mon_d = &dom->resctrl_mon_dom;
> > +
> > +				mpam_resctrl_online_domain_hdr(cpu, &mon_d->hdr);
> > +			}
> > +		}
> > +		if (IS_ERR(dom))
> > +			return PTR_ERR(dom);
> > +	}
> > +
> > +	resctrl_online_cpu(cpu);
> > +
> > +	return 0;
> > +}
> > +
> > +void mpam_resctrl_offline_cpu(unsigned int cpu)
> > +{
> > +	struct mpam_resctrl_res *res;
> > +	enum resctrl_res_level rid;
> > +
> > +	resctrl_offline_cpu(cpu);
> > +
> > +	guard(mutex)(&domain_list_lock);
> > +	for_each_mpam_resctrl_control(res, rid) {
> > +		struct mpam_resctrl_dom *dom;
> > +		struct rdt_l3_mon_domain *mon_d;
> > +		struct rdt_ctrl_domain *ctrl_d;
> > +		bool ctrl_dom_empty, mon_dom_empty;
> > +
> > +		if (!res->class)
> > +			continue;	// dummy resource
> > +
> > +		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
> > +		if (WARN_ON_ONCE(!dom))
> 
> Similar to above ... it looks to me as though this WARN may always be
> encountered on a system that only supports monitoring.

I think monitor only systems, (exposed_alloc_capable == false,
exposed_mon_capable == true), are handled properly from
[PATCH v4 28/41] arm_mpam: resctrl: Pick classes for use as mbm counters
onwards in the series.

I'll look into making the division into commits better.

> 
> > +			continue;
> > +
> > +		if (exposed_alloc_capable) {
> > +			ctrl_d = &dom->resctrl_ctrl_dom;
> > +			ctrl_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
> > +			if (ctrl_dom_empty)
> > +				resctrl_offline_ctrl_domain(&res->resctrl_res, ctrl_d);
> > +		} else {
> > +			ctrl_dom_empty = true;
> > +		}
> > +
> > +		if (exposed_mon_capable) {
> > +			mon_d = &dom->resctrl_mon_dom;
> > +			mon_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &mon_d->hdr);
> > +			if (mon_dom_empty)
> > +				resctrl_offline_mon_domain(&res->resctrl_res, &mon_d->hdr);
> > +		} else {
> > +			mon_dom_empty = true;
> > +		}
> > +
> > +		if (ctrl_dom_empty && mon_dom_empty)
> > +			kfree(dom);
> > +	}
> > +}
> > +
> 
> Reinette
> 
> 

Thanks,

Ben
