Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37DDD37647B
	for <kvmarm@lists.linux.dev>; Fri, 30 Jan 2026 12:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769775711; cv=none; b=A2qRvrv6rHKO6wkmMfaEI+vhWQDLqMvkcgnzZm+E1bkxf6rgbAGwkxFYBHFLvcjiN+txVIV+CG2rzgHS0ByslY0mIijzy43irdvw8To8ohOpcPYmqLfX4T1NVtpshGlfhtU9XUWY6IbNQu//g37nWcw82XMGbbK8gBsA17u8WYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769775711; c=relaxed/simple;
	bh=4rW3klVonaRjqtTArWPp0tognmUQmSzmkxdoBF4gL3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e4+UYLlnPG0AfA0e8xcSUYer4vW9Ig3lBf7cJs3pS/B0oRKPYFFN6pXGp6qXgas7GJtHcq6/G+8THJbxzgmr1BYsnVYlsZYpRPeH54BLMNqpKg1t8jIBi+o0uwjcCYYSBaG9qVWWqTfkE3Zblb9nkJHvE5PGCgy52vdfURgLn7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F4148153B;
	Fri, 30 Jan 2026 04:21:41 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9921D3F632;
	Fri, 30 Jan 2026 04:21:43 -0800 (PST)
Message-ID: <a069fd6f-41d8-45b4-b63d-ccace1a0f501@arm.com>
Date: Fri, 30 Jan 2026 12:21:42 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 45/47] arm_mpam: Add workaround for T241-MPAM-4
To: Fenghua Yu <fenghuay@nvidia.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 gshan@redhat.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-46-ben.horgan@arm.com>
 <23f08379-301d-4ffc-bf6f-d6a7bb952724@nvidia.com>
 <e38cb392-ff29-4008-aa4f-e9d7166836f0@arm.com>
 <e10fa678-9564-4e09-a848-fac22e1c9a64@nvidia.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <e10fa678-9564-4e09-a848-fac22e1c9a64@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Fenghua,

On 1/29/26 22:14, Fenghua Yu wrote:
> Hi, Ben,
> 
> On 1/19/26 12:56, Ben Horgan wrote:
>> Hi Fenghua,
>>
>> On 1/15/26 23:20, Fenghua Yu wrote:
>>> Hi, Shanker and Ben,
>>>
>>> On 1/12/26 08:59, Ben Horgan wrote:
>>>> From: Shanker Donthineni <sdonthineni@nvidia.com>
>>>>
>>>> In the T241 implementation of memory-bandwidth partitioning, in the
>>>> absence
>>>> of contention for bandwidth, the minimum bandwidth setting can
>>>> affect the
>>>> amount of achieved bandwidth. Specifically, the achieved bandwidth
>>>> in the
>>>> absence of contention can settle to any value between the values of
>>>> MPAMCFG_MBW_MIN and MPAMCFG_MBW_MAX.  Also, if MPAMCFG_MBW_MIN is set
>>>> zero (below 0.78125%), once a core enters a throttled state, it will
>>>> never
>>>> leave that state.
>>>>
>>>> The first issue is not a concern if the MPAM software allows to program
>>>> MPAMCFG_MBW_MIN through the sysfs interface. This patch ensures program
>>>> MBW_MIN=1 (0.78125%) whenever MPAMCFG_MBW_MIN=0 is programmed.
>>>
>>> When MBW_MIN=1, min mem bw can be very low when contention. This may
>>> drop mem access performance. Is it possible to set MBW_MIN bigger so
>>> that ensure the floor of mem access is high?
>>
>> Isn't that a policy decision rather than something we should be putting
>> in a quirk framework?
> 
> MBW_MIN is 1% or 5% less than MBW_MAX.
> 
> The lower MBW_MIN hints hardware to lower mem bandwidth when mem access
> contention. That causes memory performance degradation.
> 
> Is it possible to do the following changes to fix the performance issue?
> 1. By default min mbw is equal to max mbw. So hardware won't lower
> performance unless it's needed. This can fix the current performance issue.
> 2. Add a new schemata line (e.g. MBI:<id>=x;<id>=y;...) to specify min
> mbw just like max mbw specified by schemata line "MB:...". User can use
> this line to change min mbw per partition per node. This could be added
> in the future.

Thanks for bringing this up. It raises some more general queries about
the handling of mbw_min and so I'll move the discussion to
[PATCH v3 41/47] arm_mpam: Generate a configuration for min controls
as it isn't specific to the nvidia quirks.

> 
> Thanks.
> 
> -Fenghua

Thanks,

Ben

