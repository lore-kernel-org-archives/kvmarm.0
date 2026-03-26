Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45BE43F7ABF
	for <kvmarm@lists.linux.dev>; Thu, 26 Mar 2026 12:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774527621; cv=none; b=KAmJHx9JdefM1WGne9vJ28pw2wMDn/w79REJWzBgQc2i4cWHfsDTeGLoYHyQHHIeqISjdWa0DeUy4AThvZQ4USpgEefWen0VSGA5kRMKtBTzLTwBsFM9lgRkkyrSQtGJanOncKyS8jyuhxb2ffZzNYAr2sEZMIGVxx0KtscP1Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774527621; c=relaxed/simple;
	bh=xEQA6SisU3HHwYJZShHvoheaZziZO1w4JiAjm/iCumE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aBCvpp5jsX/3oPLimQBcMLA8gctlGV2Nz+k023LazUgqhnrTwvyqjQKpaIy8uKsVq/PkM7zIzWRvxA1mjE9N1AyXiv69tMcbwGPXHm3YzTuFUoGC/qKc7ESj/bpEGJsQNDilvTO3xYEsllafkpHVSL2+49fHxKdVHvnrELJPE8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vgmpjcWc; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vgmpjcWc"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D0BE175A;
	Thu, 26 Mar 2026 05:20:13 -0700 (PDT)
Received: from [10.1.196.96] (eglon.cambridge.arm.com [10.1.196.96])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F94E3FB90;
	Thu, 26 Mar 2026 05:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774527619; bh=xEQA6SisU3HHwYJZShHvoheaZziZO1w4JiAjm/iCumE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vgmpjcWcSSEqdk/78S9qlZnnF6r2EzxX3WkJxlI/thmnwQ8RM3aNgrHrk6vJD/ho4
	 l4gLK4deUapDK1jVRXUB61+zOla/iZhltoP8aB548mcGkvdStmoTbWAlApQ82gkPRs
	 Cs+nBiySonZVIUxQyMGNPc0slyefLsqZArJyvp2Q=
Message-ID: <699ffe60-2c52-49d2-be7a-e348839c25e2@arm.com>
Date: Thu, 26 Mar 2026 12:20:10 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/40] arm_mpam: resctrl: Add boilerplate cpuhp and
 domain allocation
To: Ben Horgan <ben.horgan@arm.com>, Gavin Shan <gshan@redhat.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, jonathan.cameron@huawei.com, kobak@nvidia.com,
 lcherian@marvell.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, peternewman@google.com,
 punit.agrawal@oss.qualcomm.com, quic_jiles@quicinc.com,
 reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org,
 Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <20260313144617.3420416-15-ben.horgan@arm.com>
 <98708bfe-7930-49d5-b383-42b7b2d6759d@redhat.com>
 <80915f50-b5c9-4790-81c6-4f08b2af1274@arm.com>
Content-Language: en-GB
From: James Morse <james.morse@arm.com>
In-Reply-To: <80915f50-b5c9-4790-81c6-4f08b2af1274@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Ben, Gavin,

On 23/03/2026 10:13, Ben Horgan wrote:
> On 3/23/26 06:31, Gavin Shan wrote:
>> On 3/14/26 12:45 AM, Ben Horgan wrote:
>>> From: James Morse <james.morse@arm.com>
>>>
>>> resctrl has its own data structures to describe its resources. We can't use
>>> these directly as we play tricks with the 'MBA' resource, picking the MPAM
>>> controls or monitors that best apply. We may export the same component as
>>> both L3 and MBA.
>>>
>>> Add mpam_resctrl_res[] as the array of class->resctrl mappings we are
>>> exporting, and add the cpuhp hooks that allocated and free the resctrl
>>> domain structures. Only the mpam control feature are considered here and
>>> monitor support will be added later.
>>>
>>> While we're here, plumb in a few other obvious things.
>>>
>>> CONFIG_ARM_CPU_RESCTRL is used to allow this code to be built even though
>>> it can't yet be linked against resctrl.


>> With the following two comments addressed. I don't think none of them are critical
>> given the fact that this series has been respinned to v6 and may be ready for Linux
>> v7.1. If there is still a chance for another respin, they may be worthy to be addressed.
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>

I've picked up the change from your second comment, I assume you're happy to keep this
tag. (otherwise shout!)


>>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>>> new file mode 100644
>>> index 000000000000..e698b534e3db
>>> --- /dev/null
>>> +++ b/drivers/resctrl/mpam_resctrl.c

>>> +static struct mpam_resctrl_dom *
>>> +mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>>> +{
>>> +    int err;
>>> +    struct mpam_resctrl_dom *dom;
>>> +    struct rdt_ctrl_domain *ctrl_d;
>>> +    struct mpam_class *class = res->class;
>>> +    struct mpam_component *comp_iter, *ctrl_comp;
>>> +    struct rdt_resource *r = &res->resctrl_res;
>>> +
>>> +    lockdep_assert_held(&domain_list_lock);
>>> +
>>> +    ctrl_comp = NULL;
>>> +    guard(srcu)(&mpam_srcu);
>>> +    list_for_each_entry_srcu(comp_iter, &class->components, class_list,
>>> +                 srcu_read_lock_held(&mpam_srcu)) {
>>> +        if (cpumask_test_cpu(cpu, &comp_iter->affinity)) {
>>> +            ctrl_comp = comp_iter;
>>> +            break;
>>> +        }
>>> +    }
>>> +
>>> +    /* class has no component for this CPU */
>>> +    if (WARN_ON_ONCE(!ctrl_comp))
>>> +        return ERR_PTR(-EINVAL);
>>> +
>>> +    dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
>>> +    if (!dom)
>>> +        return ERR_PTR(-ENOMEM);
>>> +
>>> +    if (r->alloc_capable) {
>>> +        dom->ctrl_comp = ctrl_comp;
>>> +
>>> +        ctrl_d = &dom->resctrl_ctrl_dom;
>>> +        mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, r->rid, &ctrl_d->hdr);
>>> +        ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
>>> +        err = resctrl_online_ctrl_domain(r, ctrl_d);
>>> +        if (err)
>>> +            goto free_domain;
>>> +
>>> +        mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
>>> +    } else {
>>> +        pr_debug("Skipped control domain online - no controls\n");
>>> +    }
>>> +    return dom;

>> Even though we will never support "r->alloc_capable == false", it's worthy to maintain
>> the consistence in the code level here, meaning @dom needs to be released with a proper
>> error number returned.
>>
>>     if (r->alloc_capable) {
>>         :
>>     } else {
>>         pr_debug("Skipped control domain online - no controls\n");
>>         err = -EINVAL;
>>         goto free_domain;
>>     }
>>
>> Alternatively, the check can be done before locating the component from its calss.
>>
>>     
>>     lockdep_assert_held(&domain_list_lock);
>>
>>     if (!r->alloc_capable) {
>>         pr_debug("Skipped control domain online - no controls\n");
>>         return ERR_PTR(-EINVAL);
>>     }
>>
>>     ctrl_comp = NULL;
> 
> Once monitor support is added later in the series this is no longer an
> error path as monitor only platforms are valid. In order to avoid adding
> a change and then reverting it later in the series I would like to keep
> this as it is.

I've left this as it is - adding the monitoring support builds on top of this.


>>> +int mpam_resctrl_online_cpu(unsigned int cpu)
>>> +{
>>> +    struct mpam_resctrl_res *res;
>>> +    enum resctrl_res_level rid;
>>> +
>>> +    guard(mutex)(&domain_list_lock);
>>> +    for_each_mpam_resctrl_control(res, rid) {
>>> +        struct mpam_resctrl_dom *dom;
>>> +        struct rdt_resource *r = &res->resctrl_res;
>>> +
>>> +        if (!res->class)
>>> +            continue;    // dummy_resource;
>>> +
>>> +        dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
>>> +        if (!dom) {
>>> +            dom = mpam_resctrl_alloc_domain(cpu, res);
>>> +        } else {
>>> +            if (r->alloc_capable) {
>>> +                struct rdt_ctrl_domain *ctrl_d = &dom->resctrl_ctrl_dom;
>>> +
>>> +                mpam_resctrl_online_domain_hdr(cpu, &ctrl_d->hdr);
>>> +            }
>>> +        }
>>> +        if (IS_ERR(dom))
>>> +            return PTR_ERR(dom);
>>> +    }
>>> +
>>
>> I think the "if (IS_ERR(dom))" check can be moved after "dom = mpam_resctrl_alloc_domain(cpu, res)"
>> because it seems the only path where an erroneous domain can be returned.
>>
>>         dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
>>         if (!dom) {
>>             dom = mpam_resctrl_alloc_domain(cpu, res);
>>             if (IS_ERR(dom))
>>                 return PTR_ERR(dom);
>>         } else {
>>             ...
>>         }
> 
> Yes, that would be clearer. I'll make this change if a respin becomes needed.

Applied locally.



Thanks!

James
