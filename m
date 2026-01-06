Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E2C3A1E7F
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 14:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767710633; cv=none; b=Vl6eu8VYLiOI2boljCn9A9nuPdFtCsfos90rBe4vRVvZnfZ2O/9pdDqYJ6A9xH1uNYb8iDXesXT6GwQdccEuF+LQHLwXWgHTBpneMIj8WDZoDxCTAqS5fP6On7ykNDyoXMEiedArwfYAuV3nc4t/ueL+nFPdwJtT4cgTWT6fKvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767710633; c=relaxed/simple;
	bh=Pj/v5MnFItg3SqgQfCNnU2ctRfww9ijAvPdYJnVmJwc=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iZ5KkAoowobvxgs6+FgoWhrQQm15c9cDksKDBnDvBqLrVJ8HJj6K5qYoTSAHZFIc26hStEWWVrd6nLBaGG8KdMl5qqqppOSLJSzlmlrs+wv0aQdT+GGe7yh1Fx4r2S/d6n02B/kFrpKvUUa7FzPX9X4UmOpNzdG9tusFQlS46RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlv746yytzHnH7K;
	Tue,  6 Jan 2026 22:43:44 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 4EAD740570;
	Tue,  6 Jan 2026 22:43:49 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 14:43:47 +0000
Date: Tue, 6 Jan 2026 14:43:46 +0000
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
Subject: Re: [PATCH v2 34/45] arm_mpam: resctrl: Add
 resctrl_arch_rmid_read() and resctrl_arch_reset_rmid()
Message-ID: <20260106144346.000053b0@huawei.com>
In-Reply-To: <20251219181147.3404071-35-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-35-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 18:11:36 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

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
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Trivial stuff only.
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
> Changes since rfc:
> cfg intialisation style
> code flow at end of read_mon_cdp_safe()
> ---
>  drivers/resctrl/mpam_resctrl.c | 159 +++++++++++++++++++++++++++++++++
>  include/linux/arm_mpam.h       |   5 ++
>  2 files changed, 164 insertions(+)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 638c84cdcfb6..8a1263986145 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -354,6 +354,165 @@ void resctrl_arch_mon_ctx_free(struct rdt_resource *r,
>  	resctrl_arch_mon_ctx_free_no_wait(evtid, mon_idx);
>  }
>  
> +static int
Whilst I don't really care, this does seem inconsistent from other functions
static int __read_mon(...
probably for consistent looking code.

> +__read_mon(struct mpam_resctrl_mon *mon, struct mpam_component *mon_comp,
> +	   enum mpam_device_features mon_type,
> +	   int mon_idx,
> +	   enum resctrl_conf_type cdp_type, u32 closid, u32 rmid, u64 *val)
> +{
> +	struct mon_cfg cfg;
> +
> +	if (!mpam_is_enabled())
> +		return -EINVAL;
> +
> +	/* Shift closid to account for CDP */
> +	closid = resctrl_get_config_index(closid, cdp_type);
> +
> +	if (mon_idx == USE_PRE_ALLOCATED) {
> +		int mbwu_idx = resctrl_arch_rmid_idx_encode(closid, rmid);
> +
> +		mon_idx = mon->mbwu_idx_to_mon[mbwu_idx];
> +		if (mon_idx == -1) {
> +			if (mpam_resctrl_abmc_enabled()) {
> +				/* Report Unassigned */
> +				return -ENOENT;
> +			}
> +			/* Report Unavailable */
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (irqs_disabled()) {
> +		/* Check if we can access this domain without an IPI */
> +		return -EIO;
> +	}
> +
> +	cfg = (struct mon_cfg) {
> +		.mon = mon_idx,
> +		.match_pmg = true,
> +		.partid = closid,
> +		.pmg = rmid,
> +	};
> +
> +	return mpam_msmon_read(mon_comp, &cfg, mon_type, val);
> +}

> +/* MBWU when not in ABMC mode, and CSU counters. */
> +int resctrl_arch_rmid_read(struct rdt_resource	*r, struct rdt_mon_domain *d,

Odd tab before *r.

> +			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
> +			   u64 *val, void *arch_mon_ctx)
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
> +	l3_dom = container_of(d, struct mpam_resctrl_dom, resctrl_mon_dom);
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
