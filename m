Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D56A936405F
	for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 15:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771946865; cv=none; b=nPtO3oeAHprr5omTX4Eoj0Jt9PT6HDix1EcccAj4e9Xhb83HiSNY1f2IOl5dxaAoGwFgDXcbp3Vq932Bjj1LUWuyqC5d9f4BkW5WdumvDqk/lk5GbpHFFX8FMKVWMcQ06aBtJ7aluX6g7EUWLm33iH/ZgkbF9BcDpfKXfoMD5GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771946865; c=relaxed/simple;
	bh=kCAs/oCGGe3PuDL/CDky+AOuTk5NdR+Ta2wpSay6QFc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=funZ85NjKOePIC116phw/v3eRPtACxawVVvIym7XvZeL727fP3vTzS9EmkS5Ew8nfA7LXAs1KRBdvHhfiLNcrZMzVVFpFs/8ux+OfvQReZtrmrQmtt7kUEbpGyjZ05vuckXu9m6dWKai2hmmJ4yzTO/fqAQ7e6Szy0YVnoiRfOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A80A2339;
	Tue, 24 Feb 2026 07:27:28 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD7AF3F59E;
	Tue, 24 Feb 2026 07:27:29 -0800 (PST)
Message-ID: <78af29ea-772a-4fbb-8a34-dbc2760d6415@arm.com>
Date: Tue, 24 Feb 2026 15:27:28 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/41] arm_mpam: Add KVM/arm64 and resctrl glue code
From: Ben Horgan <ben.horgan@arm.com>
To: Zeng Heng <zengheng4@huawei.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 linux-doc@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <9945d28e-f1f2-e11a-1481-8d80167d6f89@huawei.com>
 <b844c632-c8fc-48f1-b347-07f166019b22@arm.com>
 <28dbde39-5b21-5f2f-59f5-4500c8b0296d@huawei.com>
 <2f2410a0-69dd-4da5-bd84-d168ba6b0605@arm.com>
Content-Language: en-US
In-Reply-To: <2f2410a0-69dd-4da5-bd84-d168ba6b0605@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Zeng,

On 2/24/26 14:19, Ben Horgan wrote:
> Hi Zeng,
> 
> On 2/24/26 11:03, Zeng Heng wrote:
>> Hi Ben,
>>
>> On 2026/2/16 20:22, Ben Horgan wrote:
>>> Hi Zeng,
>>>
>>> On 2/14/26 09:40, Zeng Heng wrote:
>>>> Hi Ben,
>>>>
>>>> On 2026/2/4 5:43, Ben Horgan wrote:
>>> [...]
>>>>>
>>>>> Based on:
>>>>> [1] git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/cache
>>>>> (To include telemetry code which changes the resctrl arch interface)
>>>>>
>>>>> The series can be retrieved from:
>>>>> https://gitlab.arm.com/linux-arm/linux-bh.git mpam_resctrl_glue_v4
>>>>> (Final commit is a fix already in 6.19-rc8)
[...]
>>>> [   10.978497] mpam:mpam_resctrl_pick_caches: class 255 is not a cache
>>>> [   10.980470] mpam:mpam_resctrl_pick_mba: class 2 is before L3

This debug message was removed in v4 of the series.
v3 has it: https://lore.kernel.org/linux-arm-kernel/20260112165914.4086692-28-ben.horgan@arm.com/
v4 doesn't: https://lore.kernel.org/linux-arm-kernel/20260203214342.584712-27-ben.horgan@arm.com/

Do you know which version of the series you were running?

>>>> [   10.980472] mpam:mpam_resctrl_pick_mba: class 3 has no bandwidth
>>>> control
>>>> [   10.997406] mpam:topology_matches_l3: class 255 component 0 has
>>>> Mismatched CPU mask with L3 equivalent
>>>> [   10.997411] mpam:mpam_resctrl_pick_mba: class 255 topology doesn't
>>>> match L3
>>>> [   10.997415] mpam:mpam_resctrl_pick_counters: class 2 is before L3
>>>> [   11.024109] mpam:topology_matches_l3: class 3 component 276 has
>>>> Mismatched CPU mask with L3 equivalent
>>>> [   11.024114] mpam:class_has_usable_mbwu: monitors usable in free-
>>>> running mode
>>>
>>> mbwu enabled?
>>
>> The fact that the number of monitors merely satisfies the conditions for
>> free-running mode does not imply that the MBWU functionality can be
>> successfully mounted. The specific reasons are explained above.
> 
> True
> 
>>
>>>
>>>> [   11.063882] mpam:topology_matches_l3: class 255 component 0 has
>>>> Mismatched CPU mask with L3 equivalent
>>>> [   11.113183] mpam:mpam_resctrl_alloc_domain: Skipped monitor domain
>>>> online - no monitors
>>>> [   11.113189] MPAM enabled with 32 PARTIDs and 4 PMGs
>>>>
>>>>
>>
>> Sorry for the late reply. And this is my first day back from a long
>> vacation.
> 
> No problem. Hope you had a good holiday.
> 
>>
>>
>> Best regards,
>> Zeng Heng
> 
> Thanks,
> 
> Ben
> 
> 


Thanks,

Ben

