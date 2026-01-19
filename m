Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86D54363C46
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 14:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768834187; cv=none; b=m4OQaqyYNAjGsME5udGswHVnGxE7rkJrkPgFfZBZG7SktT6Ds7/84zkYO7ZlIFx+Sr4nURP4XxBKeSm3H0aLQgBuYMqFy0enAX+EYcT05l1yn14hz4pGrtEeCCayDO8KSFO/xC+0ufZngyQe+0NgOu6IAPuU6AQR+JLLrMCXDmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768834187; c=relaxed/simple;
	bh=shAx41jQ+WA5CJY9HmXKZpPrjDgMpIUTd4AzTpXFlKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MFJe3k6I6e119ri66+xr3Rdh0C8b08ngphTZKjdmPRTQ/eYqq/dUXkOGpHqba6CIJlOrljPDv+2vcnlj6BdZL+Zn7Y7QEkU8lihFcT7/YLC8oWkrw/BO1l7JCIdbHNEUJFpJzFRY+wFXgCbjbbB9Jbhx2YKFIJLg+ioMG4xWuYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19817497;
	Mon, 19 Jan 2026 06:49:38 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D79E73F632;
	Mon, 19 Jan 2026 06:49:39 -0800 (PST)
Message-ID: <892730c8-e4a1-44e2-a6b4-2c9af0a7eab0@arm.com>
Date: Mon, 19 Jan 2026 14:49:38 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/47] arm64: mpam: Advertise the CPUs MPAM limits to
 the driver
To: Gavin Shan <gshan@redhat.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-9-ben.horgan@arm.com>
 <7c224083-595b-432f-9147-1e8067df634c@redhat.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <7c224083-595b-432f-9147-1e8067df634c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Gavin,

On 1/19/26 06:37, Gavin Shan wrote:
> Hi Ben,
> 
> On 1/13/26 12:58 AM, Ben Horgan wrote:
>> From: James Morse <james.morse@arm.com>
>>
>> Requestors need to populate the MPAM fields for any traffic they send on
>> the interconnect. For the CPUs these values are taken from the
>> corresponding MPAMy_ELx register. Each requestor may have a limit on the
>> largest PARTID or PMG value that can be used. The MPAM driver has to
>> determine the system-wide minimum supported PARTID and PMG values.
>>
>> To do this, the driver needs to be told what each requestor's limit is.
>>
>> CPUs are special, but this infrastructure is also needed for the SMMU and
>> GIC ITS. Call the helper to tell the MPAM driver what the CPUs can do.
>>
>> The return value can be ignored by the arch code as it runs well
>> before the
>> MPAM driver starts probing.
>>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>>   arch/arm64/kernel/mpam.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/mpam.c b/arch/arm64/kernel/mpam.c
>> index 9866d2ca0faa..e6feff2324ac 100644
>> --- a/arch/arm64/kernel/mpam.c
>> +++ b/arch/arm64/kernel/mpam.c
>> @@ -3,6 +3,7 @@
>>     #include <asm/mpam.h>
>>   +#include <linux/arm_mpam.h>
>>   #include <linux/jump_label.h>
>>   #include <linux/percpu.h>
>>   @@ -11,3 +12,14 @@ DEFINE_PER_CPU(u64, arm64_mpam_default);
>>   DEFINE_PER_CPU(u64, arm64_mpam_current);
>>     u64 arm64_mpam_global_default;
>> +
>> +static int __init arm64_mpam_register_cpus(void)
>> +{
>> +    u64 mpamidr = read_sanitised_ftr_reg(SYS_MPAMIDR_EL1);
>> +    u16 partid_max = FIELD_GET(MPAMIDR_EL1_PARTID_MAX, mpamidr);
>> +    u8 pmg_max = FIELD_GET(MPAMIDR_EL1_PMG_MAX, mpamidr);
>> +
>> +    return mpam_register_requestor(partid_max, pmg_max);
> 
> mpam_register_requestor() is exposed until CONFIG_ARM64_MPAM_DRIVER is set.
> CONFIG_ARM64_MPAM_DRIVER and CONFIG_ARM64_MPAM can be different until
> PATCH[39/47]
> is applied. So we need PATCH[39/47] to be applied prior to this patch so
> that
> mpam_register_requestor() is always existing and exposed.

I've split out the part of PATCH[39/47] that removes the CONFIG_EXPERT
restriction and put it before this patch. With that CONFIG_ARM64_MPAM
will unconditionally select CONFIG_ARM64_MPAM_DRIVER.

> 
>> +}
>> +/* Must occur before mpam_msc_driver_init() from subsys_initcall() */
>> +arch_initcall(arm64_mpam_register_cpus)
> 
> Thanks,
> Gavin
> 
Thanks,

Ben

