Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F6F3446D8
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 14:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767884032; cv=none; b=Q79O0krerZqNuisrMM6BQ49+KP6qwlHqAgcM+43iorxpxsl3qV90AnVKgA30g9PQtQw+OoCW/Nckiu1YLFQ7kck7oGht8gzeCFP1ZpfVyeMdnHBWKAZLMMUx7WmiJDImrk2Q/G4yQvUppcyes4Ow3OJbIk+jliBPkB+JopAdMjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767884032; c=relaxed/simple;
	bh=rNpuBgLIllEGB0VexiqF4WSTX84x5OKyhI/Ki/dM5z4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hK0H1vxOmyrEzu8WnmyPWMnV7ytEtitZ3/PpM22KorHHK+XLg9rMDnxBzNK52YzuWXuMwBKYY1Ve2OnrXJ8zYKrdQKSBpa9fD3N3XHLOuAYs2U7vIbZEFtbsehdCSgGjul80kevYd+E9LerNh1RaBWcDVHXPzFvPtAzOLp+GNQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 964B81515;
	Thu,  8 Jan 2026 06:53:39 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 799983F6A8;
	Thu,  8 Jan 2026 06:53:39 -0800 (PST)
Message-ID: <5b7a66e2-7310-4770-bb7c-c7d7993cd6fe@arm.com>
Date: Thu, 8 Jan 2026 14:53:37 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 39/45] arm_mpam: resctrl: Call resctrl_init() on
 platforms that can support resctrl
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
 <20251219181147.3404071-40-ben.horgan@arm.com>
 <20260106145831.000055aa@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260106145831.000055aa@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jonathan,

On 1/6/26 14:58, Jonathan Cameron wrote:
> On Fri, 19 Dec 2025 18:11:41 +0000
> Ben Horgan <ben.horgan@arm.com> wrote:
> 
>> From: James Morse <james.morse@arm.com>
>>
>> Now that MPAM links against resctrl, call resctrl_init() to register the
>> filesystem and setup resctrl's structures.
>>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> 
> Just minor suggestions inline.  I'm not sure the for loop macros
> are worth doing but that particular pair of loops feel awfully familiar
> at this point, so maybe. 
> 
> Either way..
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>  
>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>> index 059148c38a38..bbb12b5dfd8c 100644
>> --- a/drivers/resctrl/mpam_resctrl.c
>> +++ b/drivers/resctrl/mpam_resctrl.c
> 
>> @@ -1840,11 +1861,70 @@ int mpam_resctrl_setup(void)
>>  		pr_warn("Number of PMG is not a power of 2! resctrl may misbehave");
>>  	}
>>  
>> -	/* TODO: call resctrl_init() */
>> +	err = resctrl_init();
>> +	if (!err)
>> +		WRITE_ONCE(resctrl_enabled, true);
> 
> Trivial but I'd prefer the error path out of line.
> 
> 	if (err)
> 		return err;
> 
> 	WRITE_ONCE(resctrl_enabled, true);
> 	
> 	return 0;

Ok, updated.

>>  
>>  	return err;
>>  }
> 
>> +
>> +/*
>> + * The driver is detaching an MSC from this class, if resctrl was using it,
>> + * pull on resctrl_exit().
>> + */
>> +void mpam_resctrl_teardown_class(struct mpam_class *class)
>> +{
>> +	int i;
>> +	struct mpam_resctrl_res *res;
>> +	struct mpam_resctrl_mon *mon;
>> +
>> +	might_sleep();
>> +
>> +	for (i = 0; i < RDT_NUM_RESOURCES; i++) {
> There are enough iterators over these that I wonder
> if it is worth some macros.
>  
> 	for_each_mpam_resctrl_control(res) {
> 	}
> and
> 	for_each_mpam_resctrl_counter(mon) {
> 	}

The index is often needed too so I changed to helpers that include it too:
for_each_mpam_resctrl_control(res, rid) and
for_each_mpam_resctrl_mon(mon, eventid).

> 
> 
>> +		res = &mpam_resctrl_controls[i];
>> +		if (res->class == class) {
>> +			res->class = NULL;
>> +			break;
>> +		}
>> +	}
>> +	for (i = 0; i < QOS_NUM_EVENTS; i++) {
>> +		mon = &mpam_resctrl_counters[i];
>> +		if (mon->class == class) {
>> +			mon->class = NULL;
>> +
>> +			mpam_resctrl_teardown_mon(mon, class);
>> +
>> +			break;
>> +		}
>> +	}
>> +}
>> +
>>  static int __init __cacheinfo_ready(void)
>>  {
>>  	cacheinfo_ready = true;
> 

Thanks,

Ben

