Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B07512E0B48
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 17:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768843260; cv=none; b=c63wqIKwExn1vaH7QOEkV55l1DcDQS3QxWP9sxP5Cbd7VTglntOlVcfPQtAkrG3WOJNc8nlgx/HHRxAAA+lAfpylRLOKjaVcdvSpBM5AH26PczV40760L4eOwTpPZWNSR4yNrLOAMhI/0+mh06/eTJqGF4DP93LpTcdjjU7qbDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768843260; c=relaxed/simple;
	bh=X/pybC9QCKOCIextmGOoWin0f8z4/c30n+NNEWqpXgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y8Koy4T7VDPXuUGfofkihb4PxiRt39eIkuGFMXrq7ZJxvEwvMbdjeyrX5Bwa8hv+NHTotkxnC50SSVDkEm7rZtIUORFK9WVDOvliK4EDJiU1FkzUHGFM9N6sXozGgp+Ce0XuQvmwRP3mITPUWGG/ta9XAxgIiDXETrFEBZCFETY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5DA5B497;
	Mon, 19 Jan 2026 09:20:51 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B3FB3F632;
	Mon, 19 Jan 2026 09:20:53 -0800 (PST)
Message-ID: <fd338526-9c89-409a-8bbd-13704b79a70a@arm.com>
Date: Mon, 19 Jan 2026 17:20:51 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/47] arm_mpam: resctrl: Add boilerplate cpuhp and
 domain allocation
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
 <20260112165914.4086692-15-ben.horgan@arm.com>
 <2851b4cd-fffe-4dbb-8094-60c2d4bc208d@intel.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <2851b4cd-fffe-4dbb-8094-60c2d4bc208d@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 1/13/26 16:49, Reinette Chatre wrote:
> Hi Ben,
> 
> (Please note I am unfamiliar with this code so missing some context.)
> 
> On 1/12/26 8:58 AM, Ben Horgan wrote:
>> +
>> +static struct mpam_resctrl_dom *
>> +mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>> +{
>> +	int err;
>> +	struct mpam_resctrl_dom *dom;
>> +	struct rdt_mon_domain *mon_d;
>> +	struct rdt_ctrl_domain *ctrl_d;
>> +	struct mpam_class *class = res->class;
>> +	struct mpam_component *comp_iter, *ctrl_comp;
>> +	struct rdt_resource *r = &res->resctrl_res;
>> +
>> +	lockdep_assert_held(&domain_list_lock);
>> +
>> +	ctrl_comp = NULL;
>> +	guard(srcu)(&mpam_srcu);
>> +	list_for_each_entry_srcu(comp_iter, &class->components, class_list,
>> +				 srcu_read_lock_held(&mpam_srcu)) {
>> +		if (cpumask_test_cpu(cpu, &comp_iter->affinity)) {
>> +			ctrl_comp = comp_iter;
>> +			break;
>> +		}
>> +	}
>> +
>> +	/* class has no component for this CPU */
>> +	if (WARN_ON_ONCE(!ctrl_comp))
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
>> +	if (!dom)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	if (exposed_alloc_capable) {
>> +		dom->ctrl_comp = ctrl_comp;
>> +
>> +		ctrl_d = &dom->resctrl_ctrl_dom;
>> +		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, &ctrl_d->hdr);
>> +		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
>> +		/* TODO: this list should be sorted */
>> +		list_add_tail_rcu(&ctrl_d->hdr.list, &r->ctrl_domains);
>> +		err = resctrl_online_ctrl_domain(r, ctrl_d);
>> +		if (err) {
>> +			dom = ERR_PTR(err);
>> +			goto offline_ctrl_domain;
> 
> It should not be necessary to offline the control domain if attempt to
> online it failed but removing it from the ctrl_domains list is necessary. What
> happens to memory dom points to?

Yeah, that leaks the memory and the offline call is unnecessary.

> 
>> +		}
>> +	} else {
>> +		pr_debug("Skipped control domain online - no controls\n");
>> +	}
>> +
>> +	if (exposed_mon_capable) {
>> +		mon_d = &dom->resctrl_mon_dom;
>> +		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, &mon_d->hdr);
>> +		mon_d->hdr.type = RESCTRL_MON_DOMAIN;
>> +		/* TODO: this list should be sorted */
>> +		list_add_tail_rcu(&mon_d->hdr.list, &r->mon_domains);
>> +		err = resctrl_online_mon_domain(r, mon_d);
>> +		if (err) {
>> +			dom = ERR_PTR(err);
>> +			goto offline_mon_hdr;
>> +		}
>> +	} else {
>> +		pr_debug("Skipped monitor domain online - no monitors\n");
>> +	}
>> +
>> +	return dom;
>> +
>> +offline_mon_hdr:
>> +	mpam_resctrl_offline_domain_hdr(cpu, &mon_d->hdr);
>> +offline_ctrl_domain:
>> +	resctrl_offline_ctrl_domain(r, ctrl_d);
>> +
>> +	return dom;
> 
> This error path is unexpected to me. From what I can tell, if there is a problem
> initializing the monitor domain this flow will undo both monitor and control domain,
> even if initialization of control domain was successful. In this case:
> - Flow jumps to error path from within the if (exposed_mon_capable) block and proceeds
>   to do control domain cleanup without considering whether control domain was initialized
>   or not. That is, does not take exposed_alloc_capable into account
Yes.
> - Control domain cleanup seems to be partial, for example, should it remove domain from ctrl_domains list?
Indeed.
> - On failure there is dom = ERR_PTR(err) but I cannot see where this memory is freed in both
>   the monitor and control domain error paths.
Yes, it's missing.

I've reworked the code to move the resctrl_online_*() calls further up
so there is less to do on error, added a kfree(dom) and made the
ctrl_mon cleanup after the monitor domain failure to be conditional on
exposed_alloc_capable.

> 
> 
>> +int mpam_resctrl_online_cpu(unsigned int cpu)
>> +{
>> +	struct mpam_resctrl_res *res;
>> +	enum resctrl_res_level rid;
>> +
>> +	guard(mutex)(&domain_list_lock);
>> +	for_each_mpam_resctrl_control(res, rid) {
>> +		struct mpam_resctrl_dom *dom;
>> +
>> +		if (!res->class)
>> +			continue;	// dummy_resource;
>> +
>> +		dom = mpam_resctrl_get_domain_from_cpu(cpu, res);
> 
> On success, should cpu be added to the respective headers' cpumask?

Yes, added.

> 
>> +		if (!dom)
>> +			dom = mpam_resctrl_alloc_domain(cpu, res);
>> +		if (IS_ERR(dom))
>> +			return PTR_ERR(dom);
>> +	}
>> +
>> +	resctrl_online_cpu(cpu);
>> +
>> +	return 0;
>> +}
> 
> 
> Reinette
> 

Thanks,

Ben

