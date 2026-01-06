Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A5631283C
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 14:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767709785; cv=none; b=PrmyJHU5ohFfR1fuEDgKoWRqrnLNCYjR6O7nuYOwRPPymZ1jgDH++abls5SOzIVP60X4cyL81uxndEdR5ADwjSFTNQ6JqKoyq8MgcFWNu2FnaZGMw83CTonwx/g61y4GI9lev0blPaJ6ZpNJ0spFYGeysvlZDl7nyI3IPt5fVAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767709785; c=relaxed/simple;
	bh=8fS3pJa3gCFutEifVVdfRei2AYbrEeZs9Cp8Dw7uQI0=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QQBFFh65yh45InaBYYb2peEI+1c03EYrxh0xvzQQAYTFX7c/rRKecWyPAgi+Kc4GiADnyC+L2T1rU1uJ2yqigUUqLW4zpMeRX98iiR+U3uKyueRQ7IszH8I6NOvG/eoBNmXyzJ/DEpgkEqZaOZIoRE99/EM6NgjlakpOgUm8m04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dltpp5BHDzJ4682;
	Tue,  6 Jan 2026 22:29:38 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 62E614056F;
	Tue,  6 Jan 2026 22:29:40 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 14:29:38 +0000
Date: Tue, 6 Jan 2026 14:29:37 +0000
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
Subject: Re: [PATCH v2 30/45] arm_mpam: resctrl: Pre-allocate assignable
 monitors
Message-ID: <20260106142937.00000e33@huawei.com>
In-Reply-To: <20251219181147.3404071-31-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-31-ben.horgan@arm.com>
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

On Fri, 19 Dec 2025 18:11:32 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> When there are not enough monitors, MPAM is able to emulate ABMC by making
> a smaller number of monitors assignable. These monitors still need to be
> allocated from the driver, and mapped to whichever control/monitor group
> resctrl wants to use them with.
> 
> Add a second array to hold the monitor values indexed by resctrl's cntr_id.
> 
> When CDP is in use, two monitors are needed so the available number of
> counters halves. Platforms with one monitor will have zero monitors when
> CDP is in use.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes since rfc:
> Move __free
> kmalloc -> kcalloc
>  

Trivial comments only,
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

>  static inline int mpam_alloc_csu_mon(struct mpam_class *class)
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index bea16bc096f7..e96d320c219c 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c

> +/*
> + * This must run after all event counters have been picked so that any free
> + * running counters have already been allocated.
> + */
> +static int mpam_resctrl_monitor_init_abmc(struct mpam_resctrl_mon *mon)
> +{
> +	struct mpam_resctrl_res *res = &mpam_resctrl_controls[RDT_RESOURCE_L3];
> +	struct rdt_resource *l3 = &res->resctrl_res;
> +	struct mpam_class *class = mon->class;
> +	u16 num_mbwu_mon;
> +
> +	if (mon->mbwu_idx_to_mon) {
> +		pr_debug("monitors free running\n");
> +		return 0;
> +	}
> +
> +	int *rmid_array __free(kfree) =
> +		kcalloc(resctrl_arch_system_num_rmid_idx(), sizeof(int), GFP_KERNEL);

It's a long line, but I'd prefer sizeof(*rmid_array).
could use kmalloc_array to avoid zeroing just before you fill it with -1.

> +
> +	if (!rmid_array) {
> +		pr_debug("Failed to allocate RMID array\n");
> +		return -ENOMEM;
> +	}
> +	memset(rmid_array, -1, resctrl_arch_system_num_rmid_idx() * sizeof(int));
> +
> +	num_mbwu_mon = class->props.num_mbwu_mon;
> +	mon->assigned_counters = __alloc_mbwu_array(mon->class, num_mbwu_mon);
> +	if (IS_ERR(mon->assigned_counters))
> +		return PTR_ERR(mon->assigned_counters);
> +	mon->mbwu_idx_to_mon = no_free_ptr(rmid_array);
> +
> +	mpam_resctrl_monitor_sync_abmc_vals(l3);
> +
> +	return 0;
> +}


