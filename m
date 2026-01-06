Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95A43BB4A
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 14:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767711522; cv=none; b=hSrQOHkuVK5dr7ZZn2sf0ncKg7sYdnDn4OcAaaEOZrBZ1fWKShplWc8GfKnid3VLYbVE7kmTf8dWeoRR892NvB6TxEtdfHQmwjPFZtrI0q+gX4ZKax6sTFrVgXz5nNTLTZJ1VfWTRlkG3ntmGixopnveOsh8a+eV5+ulxenAx7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767711522; c=relaxed/simple;
	bh=uB/XLTyANLNfYwA+QzWdU9TqzXpSWUmoPOGg6+eBVEc=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ju5w/GlFrkbaxC5e2kTWDkw2oRAxVMRZOOwUT0Z97Dh/Q+FyXzL20W68xfMhcpO7e8+1bgbuyeTDyrpo4mhm6UD1FLLPi7ITZS0lzYGmkmebQNBs8X8RKiGJGZi7ymj824NkcDZGXT8HKMU+N8tvE2tJMn8wtT/B1Vd+HNweHnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlvS76XsDzHnGfC;
	Tue,  6 Jan 2026 22:58:31 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 447044056A;
	Tue,  6 Jan 2026 22:58:36 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 14:58:34 +0000
Date: Tue, 6 Jan 2026 14:58:31 +0000
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
Subject: Re: [PATCH v2 39/45] arm_mpam: resctrl: Call resctrl_init() on
 platforms that can support resctrl
Message-ID: <20260106145831.000055aa@huawei.com>
In-Reply-To: <20251219181147.3404071-40-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-40-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 18:11:41 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> Now that MPAM links against resctrl, call resctrl_init() to register the
> filesystem and setup resctrl's structures.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

Just minor suggestions inline.  I'm not sure the for loop macros
are worth doing but that particular pair of loops feel awfully familiar
at this point, so maybe. 

Either way..

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
 
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 059148c38a38..bbb12b5dfd8c 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c

> @@ -1840,11 +1861,70 @@ int mpam_resctrl_setup(void)
>  		pr_warn("Number of PMG is not a power of 2! resctrl may misbehave");
>  	}
>  
> -	/* TODO: call resctrl_init() */
> +	err = resctrl_init();
> +	if (!err)
> +		WRITE_ONCE(resctrl_enabled, true);

Trivial but I'd prefer the error path out of line.

	if (err)
		return err;

	WRITE_ONCE(resctrl_enabled, true);
	
	return 0;
>  
>  	return err;
>  }

> +
> +/*
> + * The driver is detaching an MSC from this class, if resctrl was using it,
> + * pull on resctrl_exit().
> + */
> +void mpam_resctrl_teardown_class(struct mpam_class *class)
> +{
> +	int i;
> +	struct mpam_resctrl_res *res;
> +	struct mpam_resctrl_mon *mon;
> +
> +	might_sleep();
> +
> +	for (i = 0; i < RDT_NUM_RESOURCES; i++) {
There are enough iterators over these that I wonder
if it is worth some macros.
 
	for_each_mpam_resctrl_control(res) {
	}
and
	for_each_mpam_resctrl_counter(mon) {
	}


> +		res = &mpam_resctrl_controls[i];
> +		if (res->class == class) {
> +			res->class = NULL;
> +			break;
> +		}
> +	}
> +	for (i = 0; i < QOS_NUM_EVENTS; i++) {
> +		mon = &mpam_resctrl_counters[i];
> +		if (mon->class == class) {
> +			mon->class = NULL;
> +
> +			mpam_resctrl_teardown_mon(mon, class);
> +
> +			break;
> +		}
> +	}
> +}
> +
>  static int __init __cacheinfo_ready(void)
>  {
>  	cacheinfo_ready = true;

