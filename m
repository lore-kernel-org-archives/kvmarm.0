Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2E71F4634
	for <kvmarm@lists.linux.dev>; Sat,  7 Mar 2026 09:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772875761; cv=none; b=qEpK3gs4NT3OUH6zqbJKOJIfK1x7EGocskqZms9ObDphCT1fOrOV34BmTRJsFUYVhaTeUN4CSAkVOt1k7NGHLm78Qv7cM9c+aOZ/A+/Dj7MyY6C8FLcIW+/pcC52wJ+/gP0UixkmPhFXJCOIVfxTQyp7crb0+C+esZ0XsBpqm3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772875761; c=relaxed/simple;
	bh=FTFaF964VuEEZyY/+Up2UNacEAMIhe96dGfInsY5dUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MAEqrsIITSBjGOuj/HypruzuIb2Wg9C0U9EcCqJnV1ZromqJ4IroJjNvaBqZdfW3ffPtEGIcLwGY6IILvqyRGKaP0GtMx/wYDlMQLtwGFZS0MpxooYDJF2ctcjUn87wW94s9Qh3BPj7Fime50xSkcNWBgsoZd/rGNN3J3wPCreg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Fs11xKyQ; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Fs11xKyQ"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Itfyi6buFhW0nHsJ4qojlX1bMfsgLsC91Ah779lyCrk=;
	b=Fs11xKyQ7nYIUgH7UvxH6gth0KfIDoXe3uaHwUa+hP2mJzVZJigFyib1O/8y8bMWZ9PynqOJq
	LeDP3LD9iI2HZWoHuWR/+AH7FhJ+VYRsBva+lTGdx7OXB8Qp3JRCwAsF1AfzAwAczndgMMb+Si9
	peMQSuEjhf5GAUkAIcxM3i4=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fSdCD6B2Rz12LCy;
	Sat,  7 Mar 2026 17:24:40 +0800 (CST)
Received: from kwepemf100008.china.huawei.com (unknown [7.202.181.222])
	by mail.maildlp.com (Postfix) with ESMTPS id 971AB40561;
	Sat,  7 Mar 2026 17:29:15 +0800 (CST)
Received: from [10.174.179.37] (10.174.179.37) by
 kwepemf100008.china.huawei.com (7.202.181.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Sat, 7 Mar 2026 17:29:13 +0800
Message-ID: <96ffc81d-3f37-7f48-f9f4-6a58da3e0f99@huawei.com>
Date: Sat, 7 Mar 2026 17:29:13 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 31/41] arm_mpam: resctrl: Add resctrl_arch_rmid_read()
 and resctrl_arch_reset_rmid()
Content-Language: en-US
To: Ben Horgan <ben.horgan@arm.com>, James Morse <james.morse@arm.com>
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
	<linux-doc@vger.kernel.org>, Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>
References: <20260224175720.2663924-1-ben.horgan@arm.com>
 <20260224175720.2663924-32-ben.horgan@arm.com>
From: Zeng Heng <zengheng4@huawei.com>
In-Reply-To: <20260224175720.2663924-32-ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemf100008.china.huawei.com (7.202.181.222)

Hi Ben,

On 2026/2/25 1:57, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> resctrl uses resctrl_arch_rmid_read() to read counters. CDP emulation means
> the counter may need reading in three different ways. The same goes for
> reset.
> 
> The helpers behind the resctrl_arch_ functions will be re-used for the ABMC
> equivalent functions.
> 
> Add the rounding helper for checking monitor values while we're here.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---

[...]

> +
> +static int read_mon_cdp_safe(struct mpam_resctrl_mon *mon, struct mpam_component *mon_comp,
> +			     enum mpam_device_features mon_type,
> +			     int mon_idx, u32 closid, u32 rmid, u64 *val)
> +{
> +	if (cdp_enabled) {

While reviewing the resctrl limbo handling code, I noticed a issue in
__check_limbo() that could lead to premature RMID release when CDP is
enabled.

In __check_limbo(), RMIDs in limbo state undergo L3 occupancy checks
before being released. This check is performed via
resctrl_arch_rmid_read(), on arm64 MPAM, which relies on the cdp_enabled
state to determine to check which PARTID.

The concern arises in the following scenario: Filesystem is mounted with
CDP enabled. During normal operation, some RMIDs enter limbo. On umount,
cdp_enabled is reset to false. __check_limbo() may then run and perform
L3 checks with cdp_enabled = false. This could cause RMIDs to be
incorrectly released from limbo while still effectively busy after
remount.

Apologies for not providing a ready-made fix in this email. However,
I would appreciate to hear the community's thoughts on this issue.


> +		u64 code_val = 0, data_val = 0;
> +		int err;
> +
> +		err = __read_mon(mon, mon_comp, mon_type, mon_idx,
> +				 CDP_CODE, closid, rmid, &code_val);
> +		if (err)
> +			return err;
> +
> +		err = __read_mon(mon, mon_comp, mon_type, mon_idx,
> +				 CDP_DATA, closid, rmid, &data_val);
> +		if (err)
> +			return err;
> +
> +		*val += code_val + data_val;
> +		return 0;
> +	}
> +
> +	return __read_mon(mon, mon_comp, mon_type, mon_idx,
> +			  CDP_NONE, closid, rmid, val);
> +}
> +
> +/* MBWU when not in ABMC mode, and CSU counters. */
> +int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
> +			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
> +			   void *arch_priv, u64 *val, void *arch_mon_ctx)
> +{
> +	struct mpam_resctrl_dom *l3_dom;
> +	struct mpam_component *mon_comp;
> +	u32 mon_idx = *(u32 *)arch_mon_ctx;
> +	enum mpam_device_features mon_type;
> +	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[eventid];
> +
> +	resctrl_arch_rmid_read_context_check();
> +
> +	if (eventid >= QOS_NUM_EVENTS || !mon->class)
> +		return -EINVAL;
> +
> +	l3_dom = container_of(hdr, struct mpam_resctrl_dom, resctrl_mon_dom.hdr);
> +	mon_comp = l3_dom->mon_comp[eventid];
> +
> +	switch (eventid) {
> +	case QOS_L3_OCCUP_EVENT_ID:
> +		mon_type = mpam_feat_msmon_csu;
> +		break;
> +	case QOS_L3_MBM_LOCAL_EVENT_ID:
> +	case QOS_L3_MBM_TOTAL_EVENT_ID:
> +		mon_type = mpam_feat_msmon_mbwu;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return read_mon_cdp_safe(mon, mon_comp, mon_type, mon_idx,
> +				 closid, rmid, val);
> +}
> +


Best regards,
Zeng Heng
