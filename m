Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A981271468
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 10:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773138860; cv=none; b=MASx4f692FIU+HzpGK9NeytLw58Z00R7I965wUitfGeFZsf29morT1W4nky8irfGfwUKKU7nQzjZNpfmZXkidPwSMn3En2ym3LiumICH6vMXQroI9Tczi0A+g0yDR465tFXoYOgEpJjkEg0VPPvV4muTh/mWF57MnBz5b1YOEZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773138860; c=relaxed/simple;
	bh=obtXSTgT8JpjDHhY5QD7pNKBhbub+1s3/k9bXFyX1YA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AnClGLJJAQtbMza4rjQDtpL81LEB/Oe5EalGAL2xeR4mrr7YxzdJBc/kxqDXhKifM/iaUx6p4pslsyY+P3v/x9N6pt0gQ9fJQx08uGa7jqu0HOcW5VolvBcfyU/jMSu7eWO1E7a0oerDiGIZFm0oOc48SrQN6zka4RG9Gytv8DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3136F14BF;
	Tue, 10 Mar 2026 03:34:10 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 80AFA3F7BD;
	Tue, 10 Mar 2026 03:34:12 -0700 (PDT)
Message-ID: <efcc71ac-35a2-4a2d-8e26-4b4e1079f411@arm.com>
Date: Tue, 10 Mar 2026 10:34:11 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v5 13/41] arm_mpam: resctrl: Add boilerplate cpuhp and
 domain allocation
To: Gavin Shan <gshan@redhat.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org,
 Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260224175720.2663924-1-ben.horgan@arm.com>
 <20260224175720.2663924-14-ben.horgan@arm.com>
 <5a1429a6-c551-4d49-ae65-1ac7fd5e4715@redhat.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <5a1429a6-c551-4d49-ae65-1ac7fd5e4715@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Gavin,

On 3/10/26 06:17, Gavin Shan wrote:
> Hi Ben,
> 
> On 2/25/26 3:56 AM, Ben Horgan wrote:
>> From: James Morse <james.morse@arm.com>
>>
>> resctrl has its own data structures to describe its resources. We
>> can't use
>> these directly as we play tricks with the 'MBA' resource, picking the
>> MPAM
>> controls or monitors that best apply. We may export the same component as
>> both L3 and MBA.
>>
>> Add mpam_resctrl_res[] as the array of class->resctrl mappings we are
>> exporting, and add the cpuhp hooks that allocated and free the resctrl
>> domain structures. Only the mpam control feature are considered here and
>> monitor support will be added later.
>>
>> While we're here, plumb in a few other obvious things.
>>
>> CONFIG_ARM_CPU_RESCTRL is used to allow this code to be built even though
>> it can't yet be linked against resctrl.
>>
> 
> CONFIG_ARM_CPU_RESCTRL isn't valid. I guess you're probably mentioning
> CONFIG_ARCH_HAS_CPU_RESCTRL?

CONFIG_ARM_CPU_RESCTRL is added in the Makefile in this patch. As
stated, this is just to allow build testing and the link will fail.
E.g.

$ CONFIG_ARM_CPU_RESCTRL=y make O=out drivers/resctrl/

Trying this now I note there is also a build warning about the
'offline_ctrl_domain' label being unused which I'll fix.

> 
>> Tested-by: Gavin Shan <gshan@redhat.com>
>> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
>> Tested-by: Peter Newman <peternewman@google.com>
>> Tested-by: Zeng Heng <zengheng4@huawei.com>
>> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>> Changes since rfc:
>> Domain list is an rcu list
>> Add synchronize_rcu() to free the deleted element
>> Code flow simplification (Jonathan)
>>
>> Changes since v2:
>> Iterate over mpam_resctrl_dom directly (Jonathan)
>> Code flow clarification
>> Comment tidying
>> Remove power of 2 check as no longer creates holes in rmid indices
>> Remove unused type argument
>> add macro helper for_each_mpam_resctrl_control
>>
>> Changes since v3:
>> Add and use mpam_resctrl_online_domain_hdr()
>> mpam_resctrl_alloc_domain() error paths (Reinette)
>> rebase on x86/cache changes rdt_mon_domain becomes rdt_l3_mon_domain
>> etc
>>
>> Changes since v4:
>> Set rid in domain_hdr
>> Use rescctrl_res.alloc_capable to determine if alloc_capable as the
>> decision may depend on the resctrl mount options (cdp)
>> Squash in arm_mpam: resctrl: Sort the order of the domain lists
>> Move out monitor/counter changes to a separate patch
>> Commit message update
>> ---
>>   drivers/resctrl/Makefile        |   1 +
>>   drivers/resctrl/mpam_devices.c  |  12 ++
>>   drivers/resctrl/mpam_internal.h |  21 ++
>>   drivers/resctrl/mpam_resctrl.c  | 327 ++++++++++++++++++++++++++++++++
>>   include/linux/arm_mpam.h        |   3 +
>>   5 files changed, 364 insertions(+)
>>   create mode 100644 drivers/resctrl/mpam_resctrl.c
>>
>> diff --git a/drivers/resctrl/Makefile b/drivers/resctrl/Makefile
>> index 898199dcf80d..40beaf999582 100644
>> --- a/drivers/resctrl/Makefile
>> +++ b/drivers/resctrl/Makefile
>> @@ -1,4 +1,5 @@
>>   obj-$(CONFIG_ARM64_MPAM_DRIVER)            += mpam.o
>>   mpam-y                        += mpam_devices.o
>> +mpam-$(CONFIG_ARM_CPU_RESCTRL)            += mpam_resctrl.o

Here.

>>     ccflags-$(CONFIG_ARM64_MPAM_DRIVER_DEBUG)    += -DDEBUG
>> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/
>> mpam_devices.c
>> index b400a7381d9a..b45743c5fb46 100644
>> --- a/drivers/resctrl/mpam_devices.c
>> +++ b/drivers/resctrl/mpam_devices.c
>> @@ -1628,6 +1628,9 @@ static int mpam_cpu_online(unsigned int cpu)
>>               mpam_reprogram_msc(msc);
>>       }
>>   +    if (mpam_is_enabled())
>> +        return mpam_resctrl_online_cpu(cpu);
>> +
>>       return 0;
>>   }
>>   @@ -1671,6 +1674,9 @@ static int mpam_cpu_offline(unsigned int cpu)
>>   {
>>       struct mpam_msc *msc;
>>   +    if (mpam_is_enabled())
>> +        mpam_resctrl_offline_cpu(cpu);
>> +
>>       guard(srcu)(&mpam_srcu);
>>       list_for_each_entry_srcu(msc, &mpam_all_msc, all_msc_list,
>>                    srcu_read_lock_held(&mpam_srcu)) {
>> @@ -2516,6 +2522,12 @@ static void mpam_enable_once(void)
>>       mutex_unlock(&mpam_list_lock);
>>       cpus_read_unlock();
>>   +    if (!err) {
>> +        err = mpam_resctrl_setup();
>> +        if (err)
>> +            pr_err("Failed to initialise resctrl: %d\n", err);
>> +    }
>> +
>>       if (err) {
>>           mpam_disable_reason = "Failed to enable.";
>>           schedule_work(&mpam_broken_work);
>> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/
>> mpam_internal.h
>> index 4632985bcca6..28ac501e1ac3 100644
>> --- a/drivers/resctrl/mpam_internal.h
>> +++ b/drivers/resctrl/mpam_internal.h
>> @@ -12,6 +12,7 @@
>>   #include <linux/jump_label.h>
>>   #include <linux/llist.h>
>>   #include <linux/mutex.h>
>> +#include <linux/resctrl.h>
>>   #include <linux/spinlock.h>
>>   #include <linux/srcu.h>
>>   #include <linux/types.h>
>> @@ -337,6 +338,16 @@ struct mpam_msc_ris {
>>       struct mpam_garbage    garbage;
>>   };
>>   +struct mpam_resctrl_dom {
>> +    struct mpam_component        *ctrl_comp;
>> +    struct rdt_ctrl_domain        resctrl_ctrl_dom;
>> +};
>> +
>> +struct mpam_resctrl_res {
>> +    struct mpam_class    *class;
>> +    struct rdt_resource    resctrl_res;
>> +};
>> +
>>   static inline int mpam_alloc_csu_mon(struct mpam_class *class)
>>   {
>>       struct mpam_props *cprops = &class->props;
>> @@ -391,6 +402,16 @@ void mpam_msmon_reset_mbwu(struct mpam_component
>> *comp, struct mon_cfg *ctx);
>>   int mpam_get_cpumask_from_cache_id(unsigned long cache_id, u32
>> cache_level,
>>                      cpumask_t *affinity);
>>   +#ifdef CONFIG_RESCTRL_FS
>> +int mpam_resctrl_setup(void);
>> +int mpam_resctrl_online_cpu(unsigned int cpu);
>> +void mpam_resctrl_offline_cpu(unsigned int cpu);
>> +#else
>> +static inline int mpam_resctrl_setup(void) { return 0; }
>> +static inline int mpam_resctrl_online_cpu(unsigned int cpu) { return
>> 0; }
>> +static inline void mpam_resctrl_offline_cpu(unsigned int cpu) { }
>> +#endif /* CONFIG_RESCTRL_FS */
>> +
>>   /*
>>    * MPAM MSCs have the following register layout. See:
>>    * Arm Memory System Resource Partitioning and Monitoring (MPAM) System
>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/
>> mpam_resctrl.c
>> new file mode 100644
>> index 000000000000..2ffba7a15d6a
>> --- /dev/null
>> +++ b/drivers/resctrl/mpam_resctrl.c
>> @@ -0,0 +1,327 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +// Copyright (C) 2025 Arm Ltd.
>> +
>> +#define pr_fmt(fmt) "%s:%s: " fmt, KBUILD_MODNAME, __func__
>> +
>> +#include <linux/arm_mpam.h>
>> +#include <linux/cacheinfo.h>
>> +#include <linux/cpu.h>
>> +#include <linux/cpumask.h>
>> +#include <linux/errno.h>
>> +#include <linux/list.h>
>> +#include <linux/printk.h>
>> +#include <linux/rculist.h>
>> +#include <linux/resctrl.h>
>> +#include <linux/slab.h>
>> +#include <linux/types.h>
>> +
>> +#include <asm/mpam.h>
>> +
>> +#include "mpam_internal.h"
>> +
> 
> The list of included headers could be simplified since several header files
> have been included to mpam_internal.h, for example <linux/arm_mpam.h>,
> <linux/cpumask.h>, <asm/mpam.h> and others.

Could be but it is a deliberate choice to where practical include the
header where the symbols are defined rather than relying on the indirect
includes.

> 
>> +/*
>> + * The classes we've picked to map to resctrl resources, wrapped
>> + * in with their resctrl structure.
>> + * Class pointer may be NULL.
>> + */
>> +static struct mpam_resctrl_res mpam_resctrl_controls[RDT_NUM_RESOURCES];
>> +
>> +#define for_each_mpam_resctrl_control(res, rid)                    \
>> +    for (rid = 0, res = &mpam_resctrl_controls[rid];            \
>> +         rid < RDT_NUM_RESOURCES;                        \
>> +         rid++, res = &mpam_resctrl_controls[rid])
>> +
>> +/* The lock for modifying resctrl's domain lists from cpuhp
>> callbacks. */
>> +static DEFINE_MUTEX(domain_list_lock);
>> +
>> +bool resctrl_arch_alloc_capable(void)
>> +{
>> +    struct mpam_resctrl_res *res;
>> +    enum resctrl_res_level rid;
>> +
>> +    for_each_mpam_resctrl_control(res, rid) {
>> +        if (res->resctrl_res.alloc_capable)
>> +            return true;
>> +    }
>> +
>> +    return false;
>> +}
>> +
>> +/*
>> + * MSC may raise an error interrupt if it sees an out or range
>> partid/pmg,
>> + * and go on to truncate the value. Regardless of what the hardware
>> supports,
>> + * only the system wide safe value is safe to use.
>> + */
>> +u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
>> +{
>> +    return mpam_partid_max + 1;
>> +}
>> +
>> +struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
>> +{
>> +    if (l >= RDT_NUM_RESOURCES)
>> +        return NULL;
>> +
>> +    return &mpam_resctrl_controls[l].resctrl_res;
>> +}
>> +
>> +static int mpam_resctrl_control_init(struct mpam_resctrl_res *res)
>> +{
>> +    /* TODO: initialise the resctrl resources */
>> +
>> +    return 0;
>> +}
>> +
>> +static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component
>> *comp)
>> +{
>> +    struct mpam_class *class = comp->class;
>> +
>> +    if (class->type == MPAM_CLASS_CACHE)
>> +        return comp->comp_id;
>> +
>> +    /* TODO: repaint domain ids to match the L3 domain ids */
>> +    /* Otherwise, expose the ID used by the firmware table code. */
>> +    return comp->comp_id;
>> +}
>> +
>> +static void mpam_resctrl_domain_hdr_init(int cpu, struct
>> mpam_component *comp,
>> +                     enum resctrl_res_level rid,
>> +                     struct rdt_domain_hdr *hdr)
>> +{
>> +    lockdep_assert_cpus_held();
>> +
>> +    INIT_LIST_HEAD(&hdr->list);
>> +    hdr->id = mpam_resctrl_pick_domain_id(cpu, comp);
>> +    hdr->rid = rid;
>> +    cpumask_set_cpu(cpu, &hdr->cpu_mask);
>> +}
>> +
>> +static void mpam_resctrl_online_domain_hdr(unsigned int cpu,
>> +                       struct rdt_domain_hdr *hdr)
>> +{
>> +    lockdep_assert_cpus_held();
>> +
>> +    cpumask_set_cpu(cpu, &hdr->cpu_mask);
>> +}
>> +
>> +/**
>> + * mpam_resctrl_offline_domain_hdr() - Update the domain header to
>> remove a CPU.
>> + * @cpu:    The CPU to remove from the domain.
>> + * @hdr:    The domain's header.
>> + *
>> + * Removes @cpu from the header mask. If this was the last CPU in the
>> domain,
>                                                  ^^^
>                                                  is
> 
>> + * the domain header is removed from its parent list and true is
>> returned,
>> + * indicating the parent structure can be freed.
>> + * If there are other CPUs in the domain, returns false.
>> + */
>> +static bool mpam_resctrl_offline_domain_hdr(unsigned int cpu,
>> +                        struct rdt_domain_hdr *hdr)
>> +{
>> +    lockdep_assert_held(&domain_list_lock);
>> +
>> +    cpumask_clear_cpu(cpu, &hdr->cpu_mask);
>> +    if (cpumask_empty(&hdr->cpu_mask)) {
>> +        list_del_rcu(&hdr->list);
>> +        synchronize_rcu();
>> +        return true;
>> +    }
>> +
>> +    return false;
>> +}
>> +
>> +static void mpam_resctrl_domain_insert(struct list_head *list,
>> +                       struct rdt_domain_hdr *new)
>> +{
>> +    struct rdt_domain_hdr *err;
>> +    struct list_head *pos = NULL;
>> +
>> +    lockdep_assert_held(&domain_list_lock);
>> +
>> +    err = resctrl_find_domain(list, new->id, &pos);
>> +    if (WARN_ON_ONCE(err))
>> +        return;
>> +
>> +    list_add_tail_rcu(&new->list, pos);
>> +}
>> +
>> +static struct mpam_resctrl_dom *
>> +mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res
>> *res)
>> +{
>> +    int err;
>> +    struct mpam_resctrl_dom *dom;
>> +    struct rdt_ctrl_domain *ctrl_d;
>> +    struct mpam_class *class = res->class;
>> +    struct mpam_component *comp_iter, *ctrl_comp;
>> +    struct rdt_resource *r = &res->resctrl_res;
>> +
>> +    lockdep_assert_held(&domain_list_lock);
>> +
>> +    ctrl_comp = NULL;
>> +    guard(srcu)(&mpam_srcu);
>> +    list_for_each_entry_srcu(comp_iter, &class->components, class_list,
>> +                 srcu_read_lock_held(&mpam_srcu)) {
>> +        if (cpumask_test_cpu(cpu, &comp_iter->affinity)) {
>> +            ctrl_comp = comp_iter;
>> +            break;
>> +        }
>> +    }
>> +
>> +    /* class has no component for this CPU */
>> +    if (WARN_ON_ONCE(!ctrl_comp))
>> +        return ERR_PTR(-EINVAL);
>> +
>> +    dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
>> +    if (!dom)
>> +        return ERR_PTR(-ENOMEM);
>> +
>> +    if (resctrl_arch_alloc_capable()) {
>> +        dom->ctrl_comp = ctrl_comp;
>> +
>> +        ctrl_d = &dom->resctrl_ctrl_dom;
>> +        mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, r->rid, &ctrl_d-
>> >hdr);
>> +        ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
>> +        err = resctrl_online_ctrl_domain(r, ctrl_d);
>> +        if (err)
>> +            goto free_domain;
>> +
>> +        mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
>> +    } else {
>> +        pr_debug("Skipped control domain online - no controls\n");
>> +    }
>> +    return dom;
>> +
>> +offline_ctrl_domain:
>> +    if (resctrl_arch_alloc_capable()) {
>> +        mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
>> +        resctrl_offline_ctrl_domain(r, ctrl_d);
>> +    }
>> +free_domain:
>> +    kfree(dom);
>> +    dom = ERR_PTR(err);
>> +
>> +    return dom;
>> +}
>> +
>> +static struct mpam_resctrl_dom *
>> +mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
>> +{
>> +    struct mpam_resctrl_dom *dom;
>> +    struct rdt_resource *r = &res->resctrl_res;
>> +
>> +    lockdep_assert_cpus_held();
>> +
>> +    list_for_each_entry_rcu(dom, &r->ctrl_domains,
>> resctrl_ctrl_dom.hdr.list) {
>> +        if (cpumask_test_cpu(cpu, &dom->ctrl_comp->affinity))
>> +            return dom;
>> +    }
>> +
>> +    return NULL;
>> +}
>> +
>> +int mpam_resctrl_online_cpu(unsigned int cpu)
>> +{
>> +    struct mpam_resctrl_res *res;
>> +    enum resctrl_res_level rid;
>> +
>> +    guard(mutex)(&domain_list_lock);
>> +    for_each_mpam_resctrl_control(res, rid) {
>> +        struct mpam_resctrl_dom *dom;
>> +
>> +        if (!res->class)
>> +            continue;    // dummy_resource;
>> +
>> +        dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
>> +        if (!dom) {
>> +            dom = mpam_resctrl_alloc_domain(cpu, res);
>> +        } else {
>> +            if (resctrl_arch_alloc_capable()) {
>> +                struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
>> +
>> +                mpam_resctrl_online_domain_hdr(cpu, &ctrl_d->hdr);
>> +            }
>> +        }
>> +        if (IS_ERR(dom))
>> +            return PTR_ERR(dom);
>> +    }
>> +
>> +    resctrl_online_cpu(cpu);
>> +
>> +    return 0;
>> +}
>> +
>> +void mpam_resctrl_offline_cpu(unsigned int cpu)
>> +{
>> +    struct mpam_resctrl_res *res;
>> +    enum resctrl_res_level rid;
>> +
>> +    resctrl_offline_cpu(cpu);
>> +
>> +    guard(mutex)(&domain_list_lock);
>> +    for_each_mpam_resctrl_control(res, rid) {
>> +        struct mpam_resctrl_dom *dom;
>> +        struct rdt_ctrl_domain *ctrl_d;
>> +        bool ctrl_dom_empty;
>> +
>> +        if (!res->class)
>> +            continue;    // dummy resource
>> +
>> +        dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
>> +        if (WARN_ON_ONCE(!dom))
>> +            continue;
>> +
>> +        if (resctrl_arch_alloc_capable()) {
>> +            ctrl_d = &dom->resctrl_ctrl_dom;
>> +            ctrl_dom_empty = mpam_resctrl_offline_domain_hdr(cpu,
>> &ctrl_d->hdr);
>> +            if (ctrl_dom_empty)
>> +                resctrl_offline_ctrl_domain(&res->resctrl_res, ctrl_d);
>> +        } else {
>> +            ctrl_dom_empty = true;
>> +        }
>> +
>> +        if (ctrl_dom_empty)
>> +            kfree(dom);
>> +    }
>> +}
>> +
>> +int mpam_resctrl_setup(void)
>> +{
>> +    int err = 0;
>> +    struct mpam_resctrl_res *res;
>> +    enum resctrl_res_level rid;
>> +
>> +    cpus_read_lock();
>> +    for_each_mpam_resctrl_control(res, rid) {
>> +        INIT_LIST_HEAD_RCU(&res->resctrl_res.ctrl_domains);
>> +        res->resctrl_res.rid = rid;
>> +    }
>> +
>> +    /* TODO: pick MPAM classes to map to resctrl resources */
>> +
>> +    /* Initialise the resctrl structures from the classes */
>> +    for_each_mpam_resctrl_control(res, rid) {
>> +        if (!res->class)
>> +            continue;    // dummy resource
>> +
>> +        err = mpam_resctrl_control_init(res);
>> +        if (err) {
>> +            pr_debug("Failed to initialise rid %u\n", rid);
>> +            break;
>> +        }
>> +    }
>> +    cpus_read_unlock();
>> +
>> +    if (err) {
>> +        pr_debug("Internal error %d - resctrl not supported\n", err);
>> +        return err;
>> +    }
>> +
> 
> This pr_debug() could be dropped since @err is set to true only when
> a error is returned from mpam_resctrl_control_init(), we already had
> a pr_debug() for the reported error.

Later in the series this can be an error from
mpam_resctrl_monitor_init() which does also have an associated
pr_debug() but to me it seems reasonable to have this extra message
to make the severity clearer.

Thanks,

Ben

