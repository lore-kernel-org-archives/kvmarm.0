Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70EF811CBA
	for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 14:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771942787; cv=none; b=EMZZYYWPh7hLddIiKPnn9yWhvJUK36BaGCB+BMY8APX8vj05Hb/YAHXtg2GyEQT02syMNNGFKrf4z7qMKlAXKlDN51+4j1791NCznBthrQKS8qF02USQhJsm8j34FykwKxXXFeqG4/7TtV4gGBOXDQokKap07/Os+qOTlMgpbbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771942787; c=relaxed/simple;
	bh=84a6gmVfj010Q9bnahEGhZaiMCbSQNHYqKIhcM8c/w0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V1/yNF5H+V9gHd1W0/3j03fIzByiYPjFwo8gl6SXD7hrVk8YEiTYfJdlwuOQEhHpaMqLdsxmKsAvD7KB7ZL8ZqdVtz7ljGURa8MoCH9nd0tUswVUmuD2liDX1emSPI0PpE7ynSq1Mam75FP0U903avtMBOEFFFowghXFRjh/rXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 335E0339;
	Tue, 24 Feb 2026 06:19:38 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 364683F62B;
	Tue, 24 Feb 2026 06:19:39 -0800 (PST)
Message-ID: <2f2410a0-69dd-4da5-bd84-d168ba6b0605@arm.com>
Date: Tue, 24 Feb 2026 14:19:37 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/41] arm_mpam: Add KVM/arm64 and resctrl glue code
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
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <28dbde39-5b21-5f2f-59f5-4500c8b0296d@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Zeng,

On 2/24/26 11:03, Zeng Heng wrote:
> Hi Ben,
> 
> On 2026/2/16 20:22, Ben Horgan wrote:
>> Hi Zeng,
>>
>> On 2/14/26 09:40, Zeng Heng wrote:
>>> Hi Ben,
>>>
>>> On 2026/2/4 5:43, Ben Horgan wrote:
>> [...]
>>>>
>>>> Based on:
>>>> [1] git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/cache
>>>> (To include telemetry code which changes the resctrl arch interface)
>>>>
>>>> The series can be retrieved from:
>>>> https://gitlab.arm.com/linux-arm/linux-bh.git mpam_resctrl_glue_v4
>>>> (Final commit is a fix already in 6.19-rc8)
>>>>
>> [...]
>>>>
>>>
>>> I've tested the MPAM functionality on my local Kunpeng platform. Here's
>>> a summary of the results:
>>
>> Thank you very much for your testing and detailed report.
>>
>>>
>>> Features enabled and verified:
>>>    * L2 and L3 CPBM
>>>    * L3 CSU
>>>    * L2 and L3 CDP
>>> All enabled features passed functional testing as expected.
>>>
>>> + Tested-by: Zeng Heng <zengheng4@huawei.com>
>>>
>>> Features not enabled:
>>>    1. MATA MBMAX partition and MBWU monitor.
>>
>> What's MATA here? Just memory allocation or something more specific?
>>
> 
> The MATA serves as the agent for the Broadway MESI coherence protocol
> among multiple L3 caches or between I/O and L3 caches. It maintains data
> coherence among multiple L3 caches or between I/O and L3 caches.
> 
> As the connection module between the SoC and the memory system, the MATA
> interfaces with the DMC on the DDR die. It provides the system with DDR
> access paths, delivering high-bandwidth, low-latency DDR read/write
> access.
> 
> On the Kunpeng chip, the MB related MSC resides in this module rather
> than being directly located on the L3 cache controller.
> 
>>>       Reason: These do not meet the driver's current topology>
>> expectations for MB support, hence they were not initialized.
>>>       This behavior is expected.
>>
>> Is this because you have more than 1 L3 cache?
> 
> Yes, Kunpeng platform has more than 1 L3 cache.
> 
> However, the reason it is not supported here is that the current driver
> does not support MATA recognition, while both Kunpeng MBM and MBA
> functionalities reside in the MATA MSC side as mentioned above,
> resulting in the inability to provide support.
> 
> Relevant logs are as follows:
> 
> [   10.997406] mpam:topology_matches_l3: class 255 component 0 has
> Mismatched CPU mask with L3 equivalent
> [   10.997411] mpam:mpam_resctrl_pick_mba: class 255 topology doesn't
> match L3
> 
>>
>>>
>>>    2. L2 CSU and MBWU monitors.
>>>       Reason: The current MPAM driver does not support L2-related
>>>       functionality yet.
>>
>> Thanks for letting us know you have these. But, yes, unfortunately
>> monitoring is only supported on the L3 at the moment.
>>
>>>
>>> + Tested-by: Zeng Heng <zengheng4@huawei.com>
>>>
>>>
>>> Detailed test logs are as follows:
>>
>> I'm confused by these logs as it looks like you aren't getting any
>> monitors but you verified the L3 CSU. Also, it looks like cpor (cbpm) is
>> disabled (at least partially) but you verified L2 and L3 CPBM. Is this
>> across different machines?
>>
> 
> The logs were of course tested on the same machine.

Ok and the same run? Just asking because I can't yet see how this all
goes together.

> 
> Since the L3 CSU/CPBM resides on the L3 cache, it can be correctly
> recognized and run smoothly.
> 
> In fact, not only was L2 successfully mounted, but all L2 MSC CPBMs were
> also correctly recognized. The suspicion here is that the L2
> class->components were incorrectly mounted to an unknown object, which
> is believed to be related to the monitoring capabilities (CSU and MBWU)
> of Kunpeng L2. The root cause is still being investigated.

I'll try and mock up a system with L2 monitoring and cpbm to see if the
driver behaves in the same way.

However, I still can't understand how you get CPOR on L2 after seeing
"mpam:mpam_resctrl_pick_caches: class 2 cache misses CPOR" as that
should be the only place class is set for the l2 cache which guards the
call to mpam_control_init() in mpam_resctrl_setup(). The
mpam_monitor_init() comes later so I can't see how that effects.

Is the driver corrupting something or writing to mpam_resctrl_controls
with the wrong index? Clutching at straws here.

> 
> Resctrl mounting status:
> 
> # cat schemata
> L2:4=ff;7=ff;10=ff;13=ff;16=ff;19=ff;22=ff;25=ff;29=ff;32=ff;35=ff;
> 38=ff;41=ff;44=ff;47=ff;50=ff;54=ff;57=ff;60=ff;63=ff;66=ff;69=ff;72=ff;
> 75=ff;79=ff;82=ff;85=ff;88=ff;91=ff;94=ff;97=ff;100=ff;104=ff;107=ff;
> 110=ff;113=ff;116=ff;119=ff;122=ff;125=ff;129=ff;132=ff;135=ff;138=ff;
> 141=ff;144=ff;147=ff;150=ff;154=ff;157=ff;160=ff;163=ff;166=ff;169=ff;
> 172=ff;175=ff;179=ff;182=ff;185=ff;188=ff;191=ff;194=ff;197=ff;200=ff;
> 204=ff;207=ff;210=ff;213=ff;216=ff;219=ff;222=ff;225=ff;229=ff;232=ff;
> 235=ff;238=ff;241=ff;244=ff;247=ff;250=ff;254=ff;257=ff;260=ff;263=ff;
> 266=ff;269=ff;272=ff;275=ff;279=ff;282=ff;285=ff;288=ff;291=ff;294=ff;
> 297=ff;300=ff
> L3:1=1ffff;26=1ffff;51=1ffff;76=1ffff;101=1ffff;126=1ffff;151=1ffff;
> 176=1ffff;201=1ffff;226=1ffff;251=1ffff;276=1ffff
> 
> # ls mon_data/*/*
> mon_data/mon_L3_01/llc_occupancy   mon_data/mon_L3_151/llc_occupancy
> mon_data/mon_L3_226/llc_occupancy  mon_data/mon_L3_276/llc_occupancy
> mon_data/mon_L3_101/llc_occupancy  mon_data/mon_L3_176/llc_occupancy
> mon_data/mon_L3_251/llc_occupancy  mon_data/mon_L3_51/llc_occupancy
> mon_data/mon_L3_126/llc_occupancy  mon_data/mon_L3_201/llc_occupancy
> mon_data/mon_L3_26/llc_occupancy   mon_data/mon_L3_76/llc_occupancy

Thanks for the extra details. These are as expected, right?

> 
>>>
>>> Boot logs:
>>> [root@localhost ~]# dmesg | grep -i mpam
>>> [    0.000000] ACPI: MPAM 0x000000007FF35018 003024 (v01 HISI   HIP12
>>> 00000000 HISI 20151124)
>>> [    9.509852] mpam_msc mpam_msc.64: Merging features for
>>> vmsc:0xffff0800973cf5a0 |= ris:0xffff08009757ee90
>>> [    9.509859] mpam_msc mpam_msc.254: Merging features for
>>> class:0xffff08009736fe50 &= vmsc:0xffff080097628520
>>> [    9.509860] mpam:__props_mismatch:
>>> mpam_has_feature(mpam_feat_cpor_part, parent) = 1
>>> [    9.509864] mpam:__props_mismatch:
>>> mpam_has_feature(mpam_feat_cpor_part, child) = 0
>>> [    9.509866] mpam:__props_mismatch: parent->cpbm_wd = 8
>>> [    9.509869] mpam:__props_mismatch: child->cpbm_wd = 0
>>> [    9.509871] mpam:__props_mismatch: alias = 0
>>> [    9.509873] mpam:__props_mismatch: cleared cpor_part

Do you know where this mismatch is happening? Is it expected?

>>
>> cpor (partially) disabled?
>>
>>> [    9.509876] mpam:__props_mismatch: took the min num_csu_mon
>>> [    9.509878] mpam:__props_mismatch: took the min num_mbwu_mon
>>> [    9.509881] mpam_msc mpam_msc.252: Merging features for
> 
> [...]
> 
>>> [   10.978496] mpam:mpam_resctrl_pick_caches: class 2 cache misses CPOR
>>
>> No L2 cpor?

This particularly confuses me...

>>
>>> [   10.978497] mpam:mpam_resctrl_pick_caches: class 255 is not a cache
>>> [   10.980470] mpam:mpam_resctrl_pick_mba: class 2 is before L3
>>> [   10.980472] mpam:mpam_resctrl_pick_mba: class 3 has no bandwidth
>>> control
>>> [   10.997406] mpam:topology_matches_l3: class 255 component 0 has
>>> Mismatched CPU mask with L3 equivalent
>>> [   10.997411] mpam:mpam_resctrl_pick_mba: class 255 topology doesn't
>>> match L3
>>> [   10.997415] mpam:mpam_resctrl_pick_counters: class 2 is before L3
>>> [   11.024109] mpam:topology_matches_l3: class 3 component 276 has
>>> Mismatched CPU mask with L3 equivalent
>>> [   11.024114] mpam:class_has_usable_mbwu: monitors usable in free-
>>> running mode
>>
>> mbwu enabled?
> 
> The fact that the number of monitors merely satisfies the conditions for
> free-running mode does not imply that the MBWU functionality can be
> successfully mounted. The specific reasons are explained above.

True

> 
>>
>>> [   11.063882] mpam:topology_matches_l3: class 255 component 0 has
>>> Mismatched CPU mask with L3 equivalent
>>> [   11.113183] mpam:mpam_resctrl_alloc_domain: Skipped monitor domain
>>> online - no monitors
>>> [   11.113189] MPAM enabled with 32 PARTIDs and 4 PMGs
>>>
>>>
> 
> Sorry for the late reply. And this is my first day back from a long
> vacation.

No problem. Hope you had a good holiday.

> 
> 
> Best regards,
> Zeng Heng

Thanks,

Ben

