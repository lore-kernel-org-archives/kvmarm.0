Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FAC34107A
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 17:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767635932; cv=none; b=eGxWzAUZ05jmkli25rs+sxpPiYcd5ydHfZR52iscx7YLMxZWTaifWmROsFB5uXJLzi8yBw/FYpy+Q3Lhj2h1IumUPhFuakPnpYltZ8bT+ndJFubMK/U4DwGcBsv98YjVnP9zHjFvQGGRyN1LMVDdSlkLh38i9HAm3kb980HKoh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767635932; c=relaxed/simple;
	bh=GhVl4rY2gw5cR0eRzo0mkpNmSCWKZ59bnI882mOLjPo=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K+AXjikH14sli2218ll8vjQhaLkqbHTBOJfc+NQEFWT0ehrL1dC0z4LQTUgIVgS4X1WL/GBCO2XKdvbeX1HP/yqqltSCjWb/zZX4EfHdrW0FoLna3SRUcQznmsIqpxDZ4YTXkhY9rMKzWXUt1eXPJM6o1a2yOtDwFjzqlFM8MT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlMVZ1DBwzJ468h;
	Tue,  6 Jan 2026 01:58:46 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 7193240086;
	Tue,  6 Jan 2026 01:58:46 +0800 (CST)
Received: from localhost (10.126.174.38) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 5 Jan
 2026 17:58:44 +0000
Date: Mon, 5 Jan 2026 17:58:43 +0000
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
Subject: Re: [PATCH v2 20/45] arm_mpam: resctrl: Implement helpers to update
 configuration
Message-ID: <20260105175843.00007e35@huawei.com>
In-Reply-To: <20251219181147.3404071-21-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-21-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 18:11:22 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> resctrl has two helpers for updating the configuration.
> resctrl_arch_update_one() updates a single value, and is used by the
> software-controller to apply feedback to the bandwidth controls, it has to
> be called on one of the CPUs in the resctrl:domain.
> 
> resctrl_arch_update_domains() copies multiple staged configurations, it can
> be called from anywhere.
> 
> Both helpers should update any changes to the underlying hardware.
> 
> Implement resctrl_arch_update_domains() to use
> resctrl_arch_update_one(). Neither need to be called on a specific CPU as
> the mpam driver will send IPIs as needed.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
One trivial thing inline.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
> list_for_each_entry -> list_for_each_entry_rcu
> return 0
> Restrict scope of local variables
> ---
>  drivers/resctrl/mpam_resctrl.c | 70 ++++++++++++++++++++++++++++++++++
>  1 file changed, 70 insertions(+)
> 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 607e5f41f9e7..e5ec5438eca8 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -210,6 +210,76 @@ u32 resctrl_arch_get_config(struct rdt_resource *r, struct rdt_ctrl_domain *d,
>  	}
>  }
>  
> +int resctrl_arch_update_one(struct rdt_resource *r, struct rdt_ctrl_domain *d,
> +			    u32 closid, enum resctrl_conf_type t, u32 cfg_val)
> +{
...

> +	partid = resctrl_get_config_index(closid, t);
> +	if (!r->alloc_capable || partid >= resctrl_arch_get_num_closid(r)) {
> +		pr_debug("Not alloc capable or computed PARTID out of range\n");
> +		return -EINVAL;
> +	}
> +
> +       /*

Spaces instead of a tab.

> +	* Copy the current config to avoid clearing other resources when the
> +	* same component is exposed multiple times through resctrl.
> +	*/
