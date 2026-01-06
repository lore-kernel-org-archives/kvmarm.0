Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB1131354D
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 14:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767710040; cv=none; b=Ppcju3Yy5t90io45T9335NNJAldls7vR4Mz3osolyUabZVQ7hwlmH+0DS5mBN9gllHkODDsjWk4ElqgykTMMxh4mDOr5W9PMklOd4McwxkSIBRSyV+RmdXZMpUd86Gr/zRHu7wN6THz42AQ1or9bFLL7XfV8G1c7BTtlH1aQmKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767710040; c=relaxed/simple;
	bh=cRoQZ5XhYqdvJfU9bYYTw3zLw89K46lZhHwThbcoGg8=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RYnjqffN4Lmc7vgVWAj164dOYidPyprIue8rR66bFG8EeiOW9lRH2b0u9oNjEasBYTQHzOcE8rVCW2xSQpux3W8EbQZi7nfZ3xdFvtzhhFFx1Mq8jYeaakKm8vB0azCeT8SdVdJZPhAyDB9nlMIqntccOcMD4o7RE/7WYRWZtQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dltvf6MVlzHnHBS;
	Tue,  6 Jan 2026 22:33:50 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 36E344056A;
	Tue,  6 Jan 2026 22:33:55 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 14:33:53 +0000
Date: Tue, 6 Jan 2026 14:33:49 +0000
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
Subject: Re: [PATCH v2 32/45] arm_mpam: resctrl: Add
 resctrl_arch_config_cntr() for ABMC use
Message-ID: <20260106143349.000007f3@huawei.com>
In-Reply-To: <20251219181147.3404071-33-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-33-ben.horgan@arm.com>
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

On Fri, 19 Dec 2025 18:11:34 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> ABMC has a helper resctrl_arch_config_cntr() for changing the mapping
> between 'cntr_id' and a CLOSID/RMID pair.
> 
> Add the helper.
> 
> For MPAM this is done by updating the mon->mbwu_idx_to_mon[] array, and as
> usual CDP means it needs doing in three different ways.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  drivers/resctrl/mpam_resctrl.c | 37 ++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index e96d320c219c..328a81ab68b4 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -765,6 +765,43 @@ static void mpam_resctrl_pick_counters(void)
>  			     mpam_resctrl_counters[QOS_L3_MBM_TOTAL_EVENT_ID].class);
>  }
>  
> +static void __config_cntr(struct mpam_resctrl_mon *mon, u32 cntr_id,
> +			  enum resctrl_conf_type cdp_type, u32 closid, u32 rmid,
> +			  bool assign)
> +{
> +	u32 mbwu_idx, mon_idx = resctrl_get_config_index(cntr_id, cdp_type);
> +
> +	closid = resctrl_get_config_index(closid, cdp_type);
> +	mbwu_idx = resctrl_arch_rmid_idx_encode(closid, rmid);
> +	WARN_ON_ONCE(mon_idx > l3_num_allocated_mbwu);
> +
> +	if (assign)
> +		mon->mbwu_idx_to_mon[mbwu_idx] = mon->assigned_counters[mon_idx];
> +	else
> +		mon->mbwu_idx_to_mon[mbwu_idx] = -1;
> +}

