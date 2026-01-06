Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD087233722
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 14:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767709344; cv=none; b=qzoyNpKukbnSeRScLofuuIQOelS1oTWMtYVXfru49sfIOcSikmnaVeb8ifiSPLziknvsLUR1SMsd1xCdhW2abPcc5mIa+gqdwlZeqJmjOxp3vvPy1wLXQDv/uscjDUgdwiXbGUexwSYd/vvy9QRjEo/rf8aBeWl3fiIDJcGk9/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767709344; c=relaxed/simple;
	bh=6nvNStd6P3MVBLDkUw7WSgmNVUWZKQS0umoGerzOnDw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F0XSTCRBMpGGgv9H0S+s5tpjDizbD3e9siwl7rMS0oe/0ZqVJX0cFg79DQ4XNANJLtZj9yjW1cVgHjGsYpKnKbu4cZ4wZ67LWkM0Hf6rTAUSOWHBBBDcdh4yZ85Az65QvNWTrBNEIjIHwoX/hLbyfic69N3/ZcF9AP5or/XssKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dltfH2tCfzHnHCH;
	Tue,  6 Jan 2026 22:22:15 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id AF6F140539;
	Tue,  6 Jan 2026 22:22:19 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 14:22:17 +0000
Date: Tue, 6 Jan 2026 14:22:14 +0000
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
Subject: Re: [PATCH v2 29/45] arm_mpam: resctrl: Pre-allocate free running
 monitors
Message-ID: <20260106142214.0000686c@huawei.com>
In-Reply-To: <20251219181147.3404071-30-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-30-ben.horgan@arm.com>
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

On Fri, 19 Dec 2025 18:11:31 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> When there are enough monitors, the resctrl mbm local and total files can
> be exposed. These need all the monitors that resctrl may use to be
> allocated up front.
> 
> Add helpers to do this.
> 
> If a different candidate class is discovered, the old array should be
> free'd and the allocated monitors returned to the driver.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

See below.  Maybe there isn't a nicer way to handle the error
cases in counter_update_class() but I think it can be improved at least
a little.

> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 51caf3b82392..bea16bc096f7 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c

> +
>  static void counter_update_class(enum resctrl_event_id evt_id,
>  				 struct mpam_class *class)
The stuff below is very much a case of me trying to figure out a nicer
code flow in here and stumbling a bit over what it can be, however
I do think this function would benefit from another look.

>  {
> -	struct mpam_class *existing_class = mpam_resctrl_counters[evt_id].class;
> +	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[evt_id];
> +	struct mpam_class *existing_class = mon->class;
> +	u16 num_mbwu_mon = class->props.num_mbwu_mon;
> +	int *existing_array = mon->mbwu_idx_to_mon;
>  
>  	if (existing_class) {
>  		if (class->level == 3) {
> @@ -576,8 +624,40 @@ static void counter_update_class(enum resctrl_event_id evt_id,
>  		}
>  	}
>  
> -	mpam_resctrl_counters[evt_id].class = class;
> +	pr_debug("Updating event %u to use class %u\n", evt_id, class->level);
> +	mon->class = class;
>  	exposed_mon_capable = true;
> +
> +	if (evt_id == QOS_L3_OCCUP_EVENT_ID)
> +		return;
> +
> +	/* Might not need all the monitors */
> +	num_mbwu_mon = __mpam_monitors_free_running(num_mbwu_mon);
> +	if (!num_mbwu_mon) {

For the below suggestion would need duplicate setting 
		mon->class = class;
here (which is the one disadvantage I can see in setting it later than
currently.  One option would be to flip the logic here and
not exit early, allowing sharing of that statement after the
rest of the code.
	if (num_mbw_mon) {
		stuff to allocate array.
	} else {
		pr_debug("Not pre-allocating...);
	}
	mon->class = class;
}



> +		pr_debug("Not pre-allocating free-running counters\n");
> +		return;
> +	}
> +
> +	/*
> +	 * This is the pre-allocated free-running monitors path. It always
> +	 * allocates one monitor per PARTID * PMG.
> +	 */
> +	WARN_ON_ONCE(num_mbwu_mon != resctrl_arch_system_num_rmid_idx());
> +
> +	mon->mbwu_idx_to_mon = __alloc_mbwu_array(class, num_mbwu_mon);

This might be cleaner with a local so as to avoid setting and reverting on error.
Also, does anything stop mon->class being set after this?
Seems like that would be cleaner.

	int *new_array; // up top obviously.

	new_array = __alloc_mbwu_array(class, num_mbwu_mon);
	if (IS_ERR(new_array)) {
		pr_debug("Failed to allocate MBWU array\n");
		return;
	}

//this bit less obviously a good idea.
	if (mon->mbwu_idx_to_mon) {
		pr_debug("Releasing previous class %u's monitors\n",
			 mon->mbwu_idx_to_mon->level);
		__free_mbwu_mon(mon->class, mon->mbwu_idx_to_mon, num_mbwu_mon);
		kfree(mon->mbwu_idx_to_mon);
	}
//so maybe skip that bit.
//Anyhow aim is to set these only after we know we are good carry on.
	mon->mbwu_idx_to_mon = new_array;
	mon->class = class;


Some parts of this might make sense without going the whole way. Maybe
just setting the array late and leaving the class set early then
reverting that on error.


> +	if (IS_ERR(mon->mbwu_idx_to_mon)) {
> +		pr_debug("Failed to allocate MBWU array\n");
> +		mon->class = existing_class;
> +		mon->mbwu_idx_to_mon = existing_array;
> +		return;
> +	}
> +
> +	if (existing_array) {
> +		pr_debug("Releasing previous class %u's monitors\n",
> +			 existing_class->level);
> +		__free_mbwu_mon(existing_class, existing_array, num_mbwu_mon);
> +		kfree(existing_array);
> +	}
>  }
>  
>  static void mpam_resctrl_pick_counters(void)

