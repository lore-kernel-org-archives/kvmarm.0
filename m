Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDDED3ED117
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 14:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767882822; cv=none; b=B+YHRRdFFaJ8ZC2PeiZiUP5DtsQ/sMk/xR3Kp+HHZ2DVi0L/EtIC7nrQyW7/6LtwCc34rsc38rXskbqWCkp6NylS2RV9aakqKIStmrJAIeCfW2UugKfi7u3Q4TIsEfYZJq+Cl/badLLx1OYU1K0RDdpqOn3mDLy2d8rYNvfiQu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767882822; c=relaxed/simple;
	bh=3mn83bqbEVh1+FNlb0DQ0ccyKSzRsQYJZINxOrNiFRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zgty/jVHT3pjSKgiQ12/UEOtVdGHkH/rwEVH+KIWz77L8EjD4qzZUXWzyMfFOE1DKqZ6XvfKrYLIUiXq/BiQu3qhsSKIaRB4ZMHAqOmkCczr1NaLEIdFyu5lwxzIL3BCktzgpdGVdlPjBMd4muae/JDh1p7CC3/n64E9CcrmOwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6437B497;
	Thu,  8 Jan 2026 06:33:30 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 49BB23F5A1;
	Thu,  8 Jan 2026 06:33:30 -0800 (PST)
Message-ID: <daa69e3a-29c0-4c21-a4ae-43b2c7b8f8e6@arm.com>
Date: Thu, 8 Jan 2026 14:33:27 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 30/45] arm_mpam: resctrl: Pre-allocate assignable
 monitors
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20251219181147.3404071-1-ben.horgan@arm.com>
 <20251219181147.3404071-31-ben.horgan@arm.com>
 <20260106142937.00000e33@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260106142937.00000e33@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jonathan,

On 1/6/26 14:29, Jonathan Cameron wrote:
> On Fri, 19 Dec 2025 18:11:32 +0000
> Ben Horgan <ben.horgan@arm.com> wrote:
> 
>> From: James Morse <james.morse@arm.com>
>>
>> When there are not enough monitors, MPAM is able to emulate ABMC by making
>> a smaller number of monitors assignable. These monitors still need to be
>> allocated from the driver, and mapped to whichever control/monitor group
>> resctrl wants to use them with.
>>
>> Add a second array to hold the monitor values indexed by resctrl's cntr_id.
>>
>> When CDP is in use, two monitors are needed so the available number of
>> counters halves. Platforms with one monitor will have zero monitors when
>> CDP is in use.
>>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>> Changes since rfc:
>> Move __free
>> kmalloc -> kcalloc
>>  
> 
> Trivial comments only,
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> 
>>  static inline int mpam_alloc_csu_mon(struct mpam_class *class)
>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>> index bea16bc096f7..e96d320c219c 100644
>> --- a/drivers/resctrl/mpam_resctrl.c
>> +++ b/drivers/resctrl/mpam_resctrl.c
> 
>> +/*
>> + * This must run after all event counters have been picked so that any free
>> + * running counters have already been allocated.
>> + */
>> +static int mpam_resctrl_monitor_init_abmc(struct mpam_resctrl_mon *mon)
>> +{
>> +	struct mpam_resctrl_res *res = &mpam_resctrl_controls[RDT_RESOURCE_L3];
>> +	struct rdt_resource *l3 = &res->resctrl_res;
>> +	struct mpam_class *class = mon->class;
>> +	u16 num_mbwu_mon;
>> +
>> +	if (mon->mbwu_idx_to_mon) {
>> +		pr_debug("monitors free running\n");
>> +		return 0;
>> +	}
>> +
>> +	int *rmid_array __free(kfree) =
>> +		kcalloc(resctrl_arch_system_num_rmid_idx(), sizeof(int), GFP_KERNEL);
> 
> It's a long line, but I'd prefer sizeof(*rmid_array).
> could use kmalloc_array to avoid zeroing just before you fill it with -1.

Nice, I hadn't found kmalloc_array().

> 
>> +
>> +	if (!rmid_array) {
>> +		pr_debug("Failed to allocate RMID array\n");
>> +		return -ENOMEM;
>> +	}
>> +	memset(rmid_array, -1, resctrl_arch_system_num_rmid_idx() * sizeof(int));
>> +
>> +	num_mbwu_mon = class->props.num_mbwu_mon;
>> +	mon->assigned_counters = __alloc_mbwu_array(mon->class, num_mbwu_mon);
>> +	if (IS_ERR(mon->assigned_counters))
>> +		return PTR_ERR(mon->assigned_counters);
>> +	mon->mbwu_idx_to_mon = no_free_ptr(rmid_array);
>> +
>> +	mpam_resctrl_monitor_sync_abmc_vals(l3);
>> +
>> +	return 0;
>> +}
> 
> 

Thanks,

Ben

