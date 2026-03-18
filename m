Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4872E3BFE2D
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 11:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773831856; cv=none; b=tmGv5PAWoWpwo/qfLCyLzMYDpfSF7Ut2u2dmqnNoeesQi9D3ZHHXbH9FIPmVfXX4FRgzpHYo/RrSt8t+GWDBd9Zh84fE2PYf3MAfPNeM67oIF81Wawst2qdmX3jJDOtYy5sjoLixkInGmgqjLPtDLWGOhhxH/KtAnOj98trIluI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773831856; c=relaxed/simple;
	bh=5CBvTE3VxZKOYDn+lTEGcCVtNhzainWFyveh6ewR5wo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=axhVqKRnUh0jqZXWlJPHmDuCxsIgPV9kLOUTREA32/zElcIKX1HmmrH8rESw3JMkLBVD2/EjeXHFEOCG8Ss1V6rWWAHHRE9mhN40Q2PU9ZSmUGJvIsxMzXCzS7+Aj1Cv0q0/l/D9brQi/crxij/aWnVacEVpjkb/IYlk2auuGBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=lk8ZWqHL; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="lk8ZWqHL"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2FYu3eYmosXCPk9EhFLN1puzsoxOcAP2QckJBCO/sU4=;
	b=lk8ZWqHLIcI0LXKJaHrGm2T5kDXFOOiaf5ImfkVWeD6oo2Zzhi0Z/a2P8BX7+qf8P6jD7U/jB
	wpn8TX8oB1NSWdTe1nUPssAs3XKF8XHcrUhhrNrL3kOTGITWo14UthyQPVAeA1JsVLR5d/KLuZ/
	JGZ3b9EOpSfLAkwE2shDR50=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4fbQmQ0HBkzcb1V;
	Wed, 18 Mar 2026 18:58:30 +0800 (CST)
Received: from kwepemf100008.china.huawei.com (unknown [7.202.181.222])
	by mail.maildlp.com (Postfix) with ESMTPS id 3C81940569;
	Wed, 18 Mar 2026 19:04:09 +0800 (CST)
Received: from [10.174.179.37] (10.174.179.37) by
 kwepemf100008.china.huawei.com (7.202.181.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 18 Mar 2026 19:04:07 +0800
Message-ID: <57e9ddeb-f767-8eae-1123-0d9085fe01f0@huawei.com>
Date: Wed, 18 Mar 2026 19:04:06 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v6 21/40] arm_mpam: resctrl: Hide CDP emulation behind
 CONFIG_EXPERT
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
	<linux-doc@vger.kernel.org>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <20260313144617.3420416-22-ben.horgan@arm.com>
From: Zeng Heng <zengheng4@huawei.com>
In-Reply-To: <20260313144617.3420416-22-ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemf100008.china.huawei.com (7.202.181.222)

Hi Ben,

On 2026/3/13 22:45, Ben Horgan wrote:
> When CDP is not enabled, the 'rmid_entry's in the limbo list,
> rmid_busy_llc, map directly to a (PARTID,PMG) pair and when CDP is enabled
> the mapping is to two different pairs. As the limbo list is reused between
> mounts and CDP disabled on unmount this can lead to stale mapping and the
> limbo handler will then make monitor reads with potentially out of range
> PARTID. This may then cause an MPAM error interrupt and the driver will
> disable MPAM.
> 
> No problems are expected if you just mount the resctrl file system
> once with CDP enabled and never unmount it. Hide CDP emulation behind
> CONFIG_EXPERT to protect the unwary.
> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Adding this ugliness in the hope of avoiding patch churn and extra
> reviewer work. I am looking into the resctrl changes needed to fix this.
> ---
>   drivers/resctrl/mpam_resctrl.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 903d1a0f564f..cab3e9ccb5c7 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -82,6 +82,18 @@ int resctrl_arch_set_cdp_enabled(enum resctrl_res_level rid, bool enable)
>   	u32 partid_i = RESCTRL_RESERVED_CLOSID, partid_d = RESCTRL_RESERVED_CLOSID;
>   	int cpu;
>   
> +	if (!IS_ENABLED(CONFIG_EXPERT) && enable) {
> +		/*
> +		 * If the resctrl fs is mounted more than once, sequentially,
> +		 * then CDP can lead to the use of out of range PARTIDs.
> +		 */
> +		pr_warn("CDP not supported\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (enable)
> +		pr_warn("CDP is an expert feature and may cause MPAM to malfunction.\n");
> +

Agree that a proper fix will require modifications to resctrl to handle 
the limbo state across mount sessions. Hiding CDP behind CONFIG_EXPERT 
is acceptable as a short-term mitigation to prevent users from 
accidentally hitting the mentioned issue.

Reviewed-by: Zeng Heng <zengheng4@huawei.com>
