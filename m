Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF65320CAD
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 06:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773123454; cv=none; b=fXgp6cD1kT62PanTwYJjnCMrllezSeAjwNRpof1PFLkwMhMEdbAOFNuPDyogETv2KreG3eZibrvAuk/IZwChjy4Yx49ae5tGxpxLUj6xaC0ZfgcR4dGIL7Tc6OO8Ibxxa2VfVUTtAx7I6z17soxaniZtNusZIY3ad89wyv8x3wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773123454; c=relaxed/simple;
	bh=Z0Yx7NHbe+11cbCMINY8rei2nXHrkJieCLtkewXX7HU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r2fDhCCzF2XFHLhQhSvS3onf/j/uIrjL2oq8HJqizAkQletdydWydL5Aoi6+TAFlc8HVark72FZ+HaF1913ucxYe7yNuadQX5Ks3RR2hIOmeoYUhcvmiEmv5MZoEqsMSz/R6F1c+LCJAbN5q8+Vkd0WhTem6jGVaw86G+PEHafk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fRDM71jF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fRDM71jF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773123450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=app7xGe8oMjvB71vTCi2tRDtRjSSKrIDsBPuZ+BRhJY=;
	b=fRDM71jFjcq0bTQtSbAC8iSAip7FlN74LIkA3S3Rttk+GDgS8x8J1s6GwH7MTqOzD0RIIz
	4/o5Ek8PiyF5+BkKsTjTKxMwUeQ18JopC9wXc0pH2I+PuEMcWWXu3ebcjfrOI6HQLPIgCS
	THW7amA28yC9iSIgbADQXvSgVE/PJwE=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-FS0wnVquOQWBGSwwaLlJPQ-1; Tue, 10 Mar 2026 02:17:29 -0400
X-MC-Unique: FS0wnVquOQWBGSwwaLlJPQ-1
X-Mimecast-MFC-AGG-ID: FS0wnVquOQWBGSwwaLlJPQ_1773123449
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ae6dd98043so61472815ad.3
        for <kvmarm@lists.linux.dev>; Mon, 09 Mar 2026 23:17:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773123448; x=1773728248;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=app7xGe8oMjvB71vTCi2tRDtRjSSKrIDsBPuZ+BRhJY=;
        b=WWJQUV/fM3AY8LELx8/t73mDvfOXzfe7u/ZVZRpNP6/STasF/aYhm+qcSAYzktEapI
         jeAMmXQkP4lOpd2MhjbMA7UfP7Slp6/1nfT2IflFIOUqYY7+upkvsv5/DHWYdfj0JLma
         Xh1KCSRCwVOkxFGMytbg85wrUV9Mw69CotGbUgm5Y+LSQHeD7ofvlHS/5VHtL/Sc/I5M
         oAiKKdXtumbQ5QIGfi0pS1b2lzTiWLkvdN/OOuT5qxdQPkJS7a+lgIEXW0RUabVC6qJc
         GNieFAtcLbVSsFVaADOUJZu8L4ID2ngkFtNkl3bPOBzfBqILRYlHZVMf92+x0WRfV4P5
         z7sQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQEagenI3PK7wLBenuufy3pQv8Rk/Da4tdDh6aXWEAHQW0du0k8sNtbjvYTx+gXoRcxHFe5mM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVKVjd4dCUiy/cCztt9X4EzeNREcjd67gAWu39PeGLwxPMsntZ
	EzELVibld98ckon4AVWjpgbp+0e6SXTNs9V+L1MkJr0VD5B8TZAzUI2qGdv5FTADOnuv1Csm5wj
	Be0UqnZN0K4DKTXSqoxS3tmWNZVdKk2czSDlWqJ/3PE+6EpW6Y2LZIIQOow==
X-Gm-Gg: ATEYQzwsMJA0ftPc1zLVUoiTNTcGVDL0vMf0dmUF88tI8LxhB70z0YB+WcUKrBFuJ0g
	dFN3I6IM21jgK8QpGBefY0QRO7IEPPeGPY1w7JSMgNhBg1Qm3fQjahXGIrkGsbfwUBetNENDnye
	Ink4BObSs79p6mE01CPcLigyEGt+QiUpZEp2Ipb/9S9FdNA8ywILG4hgfJrJg2pYp8NANON/Ccw
	EfEHUd+/rPOLa81jGjTw0s/DeYiQ90ODq/2x7mDrEl/iZOp6g0vZOTCf3EhGtL6T1OtucU2aIps
	c2HB10VNQTkf9zc4rmlwPvgzkJULUvNqVrNpXxyB5QPCbTMUJk4wMojFgsdWzzgS/TVhfny5FJe
	RC0ELezoeLP26gl+ZhoVkL7/dd8mtUhyeKHm2G1o03+a8pTR/YTf4VWVnT72qUW6Z
X-Received: by 2002:a05:6a20:9c99:b0:394:a026:4c48 with SMTP id adf61e73a8af0-3985908a166mr13984017637.41.1773123448555;
        Mon, 09 Mar 2026 23:17:28 -0700 (PDT)
X-Received: by 2002:a05:6a20:9c99:b0:394:a026:4c48 with SMTP id adf61e73a8af0-3985908a166mr13983974637.41.1773123447985;
        Mon, 09 Mar 2026 23:17:27 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e0a70f9sm10886942a12.6.2026.03.09.23.17.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 23:17:27 -0700 (PDT)
Message-ID: <5a1429a6-c551-4d49-ae65-1ac7fd5e4715@redhat.com>
Date: Tue, 10 Mar 2026 16:17:09 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/41] arm_mpam: resctrl: Add boilerplate cpuhp and
 domain allocation
To: Ben Horgan <ben.horgan@arm.com>
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
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260224175720.2663924-14-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MOV44cAI9TagtUxMlKf_O_H91RRQWF6qHximF6AgesY_1773123449
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ben,

On 2/25/26 3:56 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> resctrl has its own data structures to describe its resources. We can't use
> these directly as we play tricks with the 'MBA' resource, picking the MPAM
> controls or monitors that best apply. We may export the same component as
> both L3 and MBA.
> 
> Add mpam_resctrl_res[] as the array of class->resctrl mappings we are
> exporting, and add the cpuhp hooks that allocated and free the resctrl
> domain structures. Only the mpam control feature are considered here and
> monitor support will be added later.
> 
> While we're here, plumb in a few other obvious things.
> 
> CONFIG_ARM_CPU_RESCTRL is used to allow this code to be built even though
> it can't yet be linked against resctrl.
> 

CONFIG_ARM_CPU_RESCTRL isn't valid. I guess you're probably mentioning
CONFIG_ARCH_HAS_CPU_RESCTRL?

> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> Domain list is an rcu list
> Add synchronize_rcu() to free the deleted element
> Code flow simplification (Jonathan)
> 
> Changes since v2:
> Iterate over mpam_resctrl_dom directly (Jonathan)
> Code flow clarification
> Comment tidying
> Remove power of 2 check as no longer creates holes in rmid indices
> Remove unused type argument
> add macro helper for_each_mpam_resctrl_control
> 
> Changes since v3:
> Add and use mpam_resctrl_online_domain_hdr()
> mpam_resctrl_alloc_domain() error paths (Reinette)
> rebase on x86/cache changes rdt_mon_domain becomes rdt_l3_mon_domain
> etc
> 
> Changes since v4:
> Set rid in domain_hdr
> Use rescctrl_res.alloc_capable to determine if alloc_capable as the
> decision may depend on the resctrl mount options (cdp)
> Squash in arm_mpam: resctrl: Sort the order of the domain lists
> Move out monitor/counter changes to a separate patch
> Commit message update
> ---
>   drivers/resctrl/Makefile        |   1 +
>   drivers/resctrl/mpam_devices.c  |  12 ++
>   drivers/resctrl/mpam_internal.h |  21 ++
>   drivers/resctrl/mpam_resctrl.c  | 327 ++++++++++++++++++++++++++++++++
>   include/linux/arm_mpam.h        |   3 +
>   5 files changed, 364 insertions(+)
>   create mode 100644 drivers/resctrl/mpam_resctrl.c
> 
> diff --git a/drivers/resctrl/Makefile b/drivers/resctrl/Makefile
> index 898199dcf80d..40beaf999582 100644
> --- a/drivers/resctrl/Makefile
> +++ b/drivers/resctrl/Makefile
> @@ -1,4 +1,5 @@
>   obj-$(CONFIG_ARM64_MPAM_DRIVER)			+= mpam.o
>   mpam-y						+= mpam_devices.o
> +mpam-$(CONFIG_ARM_CPU_RESCTRL)			+= mpam_resctrl.o
>   
>   ccflags-$(CONFIG_ARM64_MPAM_DRIVER_DEBUG)	+= -DDEBUG
> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
> index b400a7381d9a..b45743c5fb46 100644
> --- a/drivers/resctrl/mpam_devices.c
> +++ b/drivers/resctrl/mpam_devices.c
> @@ -1628,6 +1628,9 @@ static int mpam_cpu_online(unsigned int cpu)
>   			mpam_reprogram_msc(msc);
>   	}
>   
> +	if (mpam_is_enabled())
> +		return mpam_resctrl_online_cpu(cpu);
> +
>   	return 0;
>   }
>   
> @@ -1671,6 +1674,9 @@ static int mpam_cpu_offline(unsigned int cpu)
>   {
>   	struct mpam_msc *msc;
>   
> +	if (mpam_is_enabled())
> +		mpam_resctrl_offline_cpu(cpu);
> +
>   	guard(srcu)(&mpam_srcu);
>   	list_for_each_entry_srcu(msc, &mpam_all_msc, all_msc_list,
>   				 srcu_read_lock_held(&mpam_srcu)) {
> @@ -2516,6 +2522,12 @@ static void mpam_enable_once(void)
>   	mutex_unlock(&mpam_list_lock);
>   	cpus_read_unlock();
>   
> +	if (!err) {
> +		err = mpam_resctrl_setup();
> +		if (err)
> +			pr_err("Failed to initialise resctrl: %d\n", err);
> +	}
> +
>   	if (err) {
>   		mpam_disable_reason = "Failed to enable.";
>   		schedule_work(&mpam_broken_work);
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
> index 4632985bcca6..28ac501e1ac3 100644
> --- a/drivers/resctrl/mpam_internal.h
> +++ b/drivers/resctrl/mpam_internal.h
> @@ -12,6 +12,7 @@
>   #include <linux/jump_label.h>
>   #include <linux/llist.h>
>   #include <linux/mutex.h>
> +#include <linux/resctrl.h>
>   #include <linux/spinlock.h>
>   #include <linux/srcu.h>
>   #include <linux/types.h>
> @@ -337,6 +338,16 @@ struct mpam_msc_ris {
>   	struct mpam_garbage	garbage;
>   };
>   
> +struct mpam_resctrl_dom {
> +	struct mpam_component		*ctrl_comp;
> +	struct rdt_ctrl_domain		resctrl_ctrl_dom;
> +};
> +
> +struct mpam_resctrl_res {
> +	struct mpam_class	*class;
> +	struct rdt_resource	resctrl_res;
> +};
> +
>   static inline int mpam_alloc_csu_mon(struct mpam_class *class)
>   {
>   	struct mpam_props *cprops = &class->props;
> @@ -391,6 +402,16 @@ void mpam_msmon_reset_mbwu(struct mpam_component *comp, struct mon_cfg *ctx);
>   int mpam_get_cpumask_from_cache_id(unsigned long cache_id, u32 cache_level,
>   				   cpumask_t *affinity);
>   
> +#ifdef CONFIG_RESCTRL_FS
> +int mpam_resctrl_setup(void);
> +int mpam_resctrl_online_cpu(unsigned int cpu);
> +void mpam_resctrl_offline_cpu(unsigned int cpu);
> +#else
> +static inline int mpam_resctrl_setup(void) { return 0; }
> +static inline int mpam_resctrl_online_cpu(unsigned int cpu) { return 0; }
> +static inline void mpam_resctrl_offline_cpu(unsigned int cpu) { }
> +#endif /* CONFIG_RESCTRL_FS */
> +
>   /*
>    * MPAM MSCs have the following register layout. See:
>    * Arm Memory System Resource Partitioning and Monitoring (MPAM) System
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> new file mode 100644
> index 000000000000..2ffba7a15d6a
> --- /dev/null
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -0,0 +1,327 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2025 Arm Ltd.
> +
> +#define pr_fmt(fmt) "%s:%s: " fmt, KBUILD_MODNAME, __func__
> +
> +#include <linux/arm_mpam.h>
> +#include <linux/cacheinfo.h>
> +#include <linux/cpu.h>
> +#include <linux/cpumask.h>
> +#include <linux/errno.h>
> +#include <linux/list.h>
> +#include <linux/printk.h>
> +#include <linux/rculist.h>
> +#include <linux/resctrl.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +
> +#include <asm/mpam.h>
> +
> +#include "mpam_internal.h"
> +

The list of included headers could be simplified since several header files
have been included to mpam_internal.h, for example <linux/arm_mpam.h>,
<linux/cpumask.h>, <asm/mpam.h> and others.

> +/*
> + * The classes we've picked to map to resctrl resources, wrapped
> + * in with their resctrl structure.
> + * Class pointer may be NULL.
> + */
> +static struct mpam_resctrl_res mpam_resctrl_controls[RDT_NUM_RESOURCES];
> +
> +#define for_each_mpam_resctrl_control(res, rid)					\
> +	for (rid = 0, res = &mpam_resctrl_controls[rid];			\
> +	     rid < RDT_NUM_RESOURCES;						\
> +	     rid++, res = &mpam_resctrl_controls[rid])
> +
> +/* The lock for modifying resctrl's domain lists from cpuhp callbacks. */
> +static DEFINE_MUTEX(domain_list_lock);
> +
> +bool resctrl_arch_alloc_capable(void)
> +{
> +	struct mpam_resctrl_res *res;
> +	enum resctrl_res_level rid;
> +
> +	for_each_mpam_resctrl_control(res, rid) {
> +		if (res->resctrl_res.alloc_capable)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * MSC may raise an error interrupt if it sees an out or range partid/pmg,
> + * and go on to truncate the value. Regardless of what the hardware supports,
> + * only the system wide safe value is safe to use.
> + */
> +u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
> +{
> +	return mpam_partid_max + 1;
> +}
> +
> +struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
> +{
> +	if (l >= RDT_NUM_RESOURCES)
> +		return NULL;
> +
> +	return &mpam_resctrl_controls[l].resctrl_res;
> +}
> +
> +static int mpam_resctrl_control_init(struct mpam_resctrl_res *res)
> +{
> +	/* TODO: initialise the resctrl resources */
> +
> +	return 0;
> +}
> +
> +static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *comp)
> +{
> +	struct mpam_class *class = comp->class;
> +
> +	if (class->type == MPAM_CLASS_CACHE)
> +		return comp->comp_id;
> +
> +	/* TODO: repaint domain ids to match the L3 domain ids */
> +	/* Otherwise, expose the ID used by the firmware table code. */
> +	return comp->comp_id;
> +}
> +
> +static void mpam_resctrl_domain_hdr_init(int cpu, struct mpam_component *comp,
> +					 enum resctrl_res_level rid,
> +					 struct rdt_domain_hdr *hdr)
> +{
> +	lockdep_assert_cpus_held();
> +
> +	INIT_LIST_HEAD(&hdr->list);
> +	hdr->id = mpam_resctrl_pick_domain_id(cpu, comp);
> +	hdr->rid = rid;
> +	cpumask_set_cpu(cpu, &hdr->cpu_mask);
> +}
> +
> +static void mpam_resctrl_online_domain_hdr(unsigned int cpu,
> +					   struct rdt_domain_hdr *hdr)
> +{
> +	lockdep_assert_cpus_held();
> +
> +	cpumask_set_cpu(cpu, &hdr->cpu_mask);
> +}
> +
> +/**
> + * mpam_resctrl_offline_domain_hdr() - Update the domain header to remove a CPU.
> + * @cpu:	The CPU to remove from the domain.
> + * @hdr:	The domain's header.
> + *
> + * Removes @cpu from the header mask. If this was the last CPU in the domain,
                                                  ^^^
                                                  is

> + * the domain header is removed from its parent list and true is returned,
> + * indicating the parent structure can be freed.
> + * If there are other CPUs in the domain, returns false.
> + */
> +static bool mpam_resctrl_offline_domain_hdr(unsigned int cpu,
> +					    struct rdt_domain_hdr *hdr)
> +{
> +	lockdep_assert_held(&domain_list_lock);
> +
> +	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
> +	if (cpumask_empty(&hdr->cpu_mask)) {
> +		list_del_rcu(&hdr->list);
> +		synchronize_rcu();
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static void mpam_resctrl_domain_insert(struct list_head *list,
> +				       struct rdt_domain_hdr *new)
> +{
> +	struct rdt_domain_hdr *err;
> +	struct list_head *pos = NULL;
> +
> +	lockdep_assert_held(&domain_list_lock);
> +
> +	err = resctrl_find_domain(list, new->id, &pos);
> +	if (WARN_ON_ONCE(err))
> +		return;
> +
> +	list_add_tail_rcu(&new->list, pos);
> +}
> +
> +static struct mpam_resctrl_dom *
> +mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
> +{
> +	int err;
> +	struct mpam_resctrl_dom *dom;
> +	struct rdt_ctrl_domain *ctrl_d;
> +	struct mpam_class *class = res->class;
> +	struct mpam_component *comp_iter, *ctrl_comp;
> +	struct rdt_resource *r = &res->resctrl_res;
> +
> +	lockdep_assert_held(&domain_list_lock);
> +
> +	ctrl_comp = NULL;
> +	guard(srcu)(&mpam_srcu);
> +	list_for_each_entry_srcu(comp_iter, &class->components, class_list,
> +				 srcu_read_lock_held(&mpam_srcu)) {
> +		if (cpumask_test_cpu(cpu, &comp_iter->affinity)) {
> +			ctrl_comp = comp_iter;
> +			break;
> +		}
> +	}
> +
> +	/* class has no component for this CPU */
> +	if (WARN_ON_ONCE(!ctrl_comp))
> +		return ERR_PTR(-EINVAL);
> +
> +	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
> +	if (!dom)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (resctrl_arch_alloc_capable()) {
> +		dom->ctrl_comp = ctrl_comp;
> +
> +		ctrl_d = &dom->resctrl_ctrl_dom;
> +		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, r->rid, &ctrl_d->hdr);
> +		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
> +		err = resctrl_online_ctrl_domain(r, ctrl_d);
> +		if (err)
> +			goto free_domain;
> +
> +		mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
> +	} else {
> +		pr_debug("Skipped control domain online - no controls\n");
> +	}
> +	return dom;
> +
> +offline_ctrl_domain:
> +	if (resctrl_arch_alloc_capable()) {
> +		mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
> +		resctrl_offline_ctrl_domain(r, ctrl_d);
> +	}
> +free_domain:
> +	kfree(dom);
> +	dom = ERR_PTR(err);
> +
> +	return dom;
> +}
> +
> +static struct mpam_resctrl_dom *
> +mpam_resctrl_get_domain_from_cpu(int cpu, struct mpam_resctrl_res *res)
> +{
> +	struct mpam_resctrl_dom *dom;
> +	struct rdt_resource *r = &res->resctrl_res;
> +
> +	lockdep_assert_cpus_held();
> +
> +	list_for_each_entry_rcu(dom, &r->ctrl_domains, resctrl_ctrl_dom.hdr.list) {
> +		if (cpumask_test_cpu(cpu, &dom->ctrl_comp->affinity))
> +			return dom;
> +	}
> +
> +	return NULL;
> +}
> +
> +int mpam_resctrl_online_cpu(unsigned int cpu)
> +{
> +	struct mpam_resctrl_res *res;
> +	enum resctrl_res_level rid;
> +
> +	guard(mutex)(&domain_list_lock);
> +	for_each_mpam_resctrl_control(res, rid) {
> +		struct mpam_resctrl_dom *dom;
> +
> +		if (!res->class)
> +			continue;	// dummy_resource;
> +
> +		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
> +		if (!dom) {
> +			dom = mpam_resctrl_alloc_domain(cpu, res);
> +		} else {
> +			if (resctrl_arch_alloc_capable()) {
> +				struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
> +
> +				mpam_resctrl_online_domain_hdr(cpu, &ctrl_d->hdr);
> +			}
> +		}
> +		if (IS_ERR(dom))
> +			return PTR_ERR(dom);
> +	}
> +
> +	resctrl_online_cpu(cpu);
> +
> +	return 0;
> +}
> +
> +void mpam_resctrl_offline_cpu(unsigned int cpu)
> +{
> +	struct mpam_resctrl_res *res;
> +	enum resctrl_res_level rid;
> +
> +	resctrl_offline_cpu(cpu);
> +
> +	guard(mutex)(&domain_list_lock);
> +	for_each_mpam_resctrl_control(res, rid) {
> +		struct mpam_resctrl_dom *dom;
> +		struct rdt_ctrl_domain *ctrl_d;
> +		bool ctrl_dom_empty;
> +
> +		if (!res->class)
> +			continue;	// dummy resource
> +
> +		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
> +		if (WARN_ON_ONCE(!dom))
> +			continue;
> +
> +		if (resctrl_arch_alloc_capable()) {
> +			ctrl_d = &dom->resctrl_ctrl_dom;
> +			ctrl_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
> +			if (ctrl_dom_empty)
> +				resctrl_offline_ctrl_domain(&res->resctrl_res, ctrl_d);
> +		} else {
> +			ctrl_dom_empty = true;
> +		}
> +
> +		if (ctrl_dom_empty)
> +			kfree(dom);
> +	}
> +}
> +
> +int mpam_resctrl_setup(void)
> +{
> +	int err = 0;
> +	struct mpam_resctrl_res *res;
> +	enum resctrl_res_level rid;
> +
> +	cpus_read_lock();
> +	for_each_mpam_resctrl_control(res, rid) {
> +		INIT_LIST_HEAD_RCU(&res->resctrl_res.ctrl_domains);
> +		res->resctrl_res.rid = rid;
> +	}
> +
> +	/* TODO: pick MPAM classes to map to resctrl resources */
> +
> +	/* Initialise the resctrl structures from the classes */
> +	for_each_mpam_resctrl_control(res, rid) {
> +		if (!res->class)
> +			continue;	// dummy resource
> +
> +		err = mpam_resctrl_control_init(res);
> +		if (err) {
> +			pr_debug("Failed to initialise rid %u\n", rid);
> +			break;
> +		}
> +	}
> +	cpus_read_unlock();
> +
> +	if (err) {
> +		pr_debug("Internal error %d - resctrl not supported\n", err);
> +		return err;
> +	}
> +

This pr_debug() could be dropped since @err is set to true only when
a error is returned from mpam_resctrl_control_init(), we already had
a pr_debug() for the reported error.

> +	if (!resctrl_arch_alloc_capable()) {
> +		pr_debug("No alloc(%u) found - resctrl not supported\n",
> +			 resctrl_arch_alloc_capable());
> +		return -EOPNOTSUPP;
> +	}
> +
> +	/* TODO: call resctrl_init() */
> +
> +	return 0;
> +}
> diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h
> index 7f00c5285a32..2c7d1413a401 100644
> --- a/include/linux/arm_mpam.h
> +++ b/include/linux/arm_mpam.h
> @@ -49,6 +49,9 @@ static inline int mpam_ris_create(struct mpam_msc *msc, u8 ris_idx,
>   }
>   #endif
>   
> +bool resctrl_arch_alloc_capable(void);
> +bool resctrl_arch_mon_capable(void);
> +
>   /**
>    * mpam_register_requestor() - Register a requestor with the MPAM driver
>    * @partid_max:		The maximum PARTID value the requestor can generate.

Thanks,
Gavin

