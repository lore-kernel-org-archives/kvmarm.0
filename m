Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA55A3016E7
	for <kvmarm@lists.linux.dev>; Wed, 25 Feb 2026 06:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772000761; cv=none; b=PzoAw7WEsE++w0hw6Jpqt4DuvA7wuwJYfP8yMfwYKkkt6Te3UqO+gEgdhtOgNi/JLH90NmuuL+LTIp4yh5uhUWhxal7OPrTsCYv3VeKJU91FnsQ52lUa5sOykpApARWb8LjLzt6SEUGNZfPVxgBvp+txKDzEjv6bleHR038kXO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772000761; c=relaxed/simple;
	bh=bgt0bYjGivUhp41rZRHtH+jFgV53GRT2xkwEVCcPTik=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZIglKJdYM7A/CGWb5Hs859ghl01aui7blZzv6Rus+3AdHJNPW2rI61/rRIv1bHmXGgC3M/huDTyfz8tysBqG7TEif2U5+isw/nr0sRUOpTJhQX/AAlRpOKKmgOGUY2QaRhIykK7ooVjRJ7ub5U6HSD85CyRlMWYzxjvFL1LFmlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=MUtEuK/4; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="MUtEuK/4"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HQr1KIdtCg4BgqPYVIhEydfZsGCVg8yetCxgBfSUU8g=;
	b=MUtEuK/4x8KgYir8Lo++kTygCM5l2rCzR3lHSR3Xu5QN+njHzTKoER9L/zYtWIvVrWAMvJV6z
	cgk4RG/CAQQ6R6l5IdJdBdFN0MZUf+odI8BwUPHNaJQnIXGqgoWQcPpg3CDPCaGnjEHKmgmVacU
	DBKusdSKgIhng506On4+pHw=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4fLPbf20kmzcb4G;
	Wed, 25 Feb 2026 14:20:46 +0800 (CST)
Received: from kwepemf100008.china.huawei.com (unknown [7.202.181.222])
	by mail.maildlp.com (Postfix) with ESMTPS id D05FE40538;
	Wed, 25 Feb 2026 14:25:46 +0800 (CST)
Received: from [10.174.179.37] (10.174.179.37) by
 kwepemf100008.china.huawei.com (7.202.181.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 25 Feb 2026 14:25:44 +0800
Message-ID: <514cd4d8-e00d-54bc-c88a-516f28a05531@huawei.com>
Date: Wed, 25 Feb 2026 14:25:44 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 19/41] arm_mpam: resctrl: Add CDP emulation
Content-Language: en-US
To: Ben Horgan <ben.horgan@arm.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <carl@os.amperecomputing.com>,
	<dave.martin@arm.com>, <david@kernel.org>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <gshan@redhat.com>, <james.morse@arm.com>,
	<jonathan.cameron@huawei.com>, <kobak@nvidia.com>, <lcherian@marvell.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<peternewman@google.com>, <punit.agrawal@oss.qualcomm.com>,
	<quic_jiles@quicinc.com>, <reinette.chatre@intel.com>,
	<rohit.mathew@arm.com>, <scott@os.amperecomputing.com>,
	<sdonthineni@nvidia.com>, <tan.shaopeng@fujitsu.com>,
	<xhao@linux.alibaba.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<corbet@lwn.net>, <maz@kernel.org>, <oupton@kernel.org>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>,
	<linux-doc@vger.kernel.org>, Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260224175720.2663924-1-ben.horgan@arm.com>
 <20260224175720.2663924-20-ben.horgan@arm.com>
From: Zeng Heng <zengheng4@huawei.com>
In-Reply-To: <20260224175720.2663924-20-ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf100008.china.huawei.com (7.202.181.222)



On 2026/2/25 1:56, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> Intel RDT's CDP feature allows the cache to use a different control value
> depending on whether the accesses was for instruction fetch or a data
> access. MPAM's equivalent feature is the other way up: the CPU assigns a
> different partid label to traffic depending on whether it was instruction
> fetch or a data access, which causes the cache to use a different control
> value based solely on the partid.
> 
> MPAM can emulate CDP, with the side effect that the alternative partid is
> seen by all MSC, it can't be enabled per-MSC.
> 
> Add the resctrl hooks to turn this on or off. Add the helpers that match a
> closid against a task, which need to be aware that the value written to
> hardware is not the same as the one resctrl is using.
> 
> Update the 'arm64_mpam_global_default' variable the arch code uses during
> context switch to know when the per-cpu value should be used instead. Also,
> update these per-cpu values and sync the resulting mpam partid/pmg
> configuration to hardware.
> 
> resctrl can enable CDP for L2 caches, L3 caches or both. When it is enabled
> by one and not the other MPAM globally enabled CDP but hides the effect
> on the other cache resource. This hiding is possible as CPOR is the only
> supported cache control and that uses a resource bitmap; two partids with
> the same bitmap act as one.
> 
> Awkwardly, the MB controls don't implement CDP and CDP can't be hidden as
> the memory bandwidth control is a maximum per partid which can't be
> modelled with more partids. If the total maximum is used for both the data
> and instruction partids then then the maximum may be exceeded and if it is
> split in two then the one using more bandwidth will hit a lower
> limit. Hence, hide the MB controls completely if CDP is enabled for any
> resource.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> CC: Dave Martin <Dave.Martin@arm.com>
> CC: Amit Singh Tomar <amitsinght@marvell.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> Fail cdp initialisation if there is only one partid
> Correct data/code confusion
> 
> Changes since v2:
> Don't include unused header
> 
> Changes since v3:
> Update the per-cpu values and sync to h/w
> 
> Changes since v4:
> Enable separately for L2 and L3
> Disable MB controls if CDP enabled
> Consider cdp hiding in resctrl_arch_update_one()

[...]

@ -245,6 +338,14 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, 
struct rdt_ctrl_domain *d,
>   	dom = container_of(d, struct mpam_resctrl_dom, resctrl_ctrl_dom);
>   	cprops = &res->class->props;
>   
> +	/*
> +	 * When CDP is enabled, but the resource doesn't support it,
> +	 * the control is cloned across both partids.
> +	 * Pick one at random to read:
> +	 */
> +	if (mpam_resctrl_hide_cdp(r->rid))
> +		type = CDP_DATA;
> +

Yes, I have observed that this issue had already been addressed in
resctrl_arch_get_config() before the mpam_resctrl_glue_v4 release.

>   	partid = resctrl_get_config_index(closid, type);
>   	cfg = &dom->ctrl_comp->cfg[partid];
>   
> @@ -272,6 +373,7 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>   int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>   			    u32 closid, enum resctrl_conf_type t, u32 cfg_val)
>   {
> +	int err;
>   	u32 partid;
>   	struct mpam_config cfg;
>   	struct mpam_props *cprops;
> @@ -289,6 +391,9 @@ int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>   	dom = container_of(d, struct mpam_resctrl_dom, resctrl_ctrl_dom);
>   	cprops = &res->class->props;
>   
> +	if (mpam_resctrl_hide_cdp(r->rid))
> +		t = CDP_DATA;
> +

Fix for resctrl_arch_update_one() has been confirmed.

Reviewed-by: Zeng Heng <zengheng4@huawei.com>


Best regards,
Zeng Heng

