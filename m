Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D355295DAC
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 15:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770651401; cv=none; b=PcWxy+/B9I/UKjdl39BOutnvuOUNz9NKFxfe8cDnwjPC/dO72ooAoyVduuTCi9eOT4xSynyn8OFMGN//aYvk8g/BxBnaWLvTpYnHO1WT1MDzkIAhtqBjQH8RLYxe2e/yc4RpciYn7HCMAnr95nTycoczXTjD1TqxPbIZ3yAfTyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770651401; c=relaxed/simple;
	bh=HIoSMO9egrZ4A6UCPVzGa9X1jJVWkQH0s0LiFyimx2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qqVE09ykg/3jz2MDGVWHi4ko+i2sUQAgu21jHsBzOK6kfEhw1qHP/zUMPMscfPgCkjc2fiktjgircee/uOdHxXQZOg3CthT6Z1GQsVzbnfpPJAbGVyn5N2pvnZsRRNJmhOiTksx30A3RRIu4Qjgx5Is+TlaCupw+YI2tLYYN61E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 800B8339;
	Mon,  9 Feb 2026 07:36:33 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93DFE3F740;
	Mon,  9 Feb 2026 07:36:34 -0800 (PST)
Message-ID: <7a0953ff-6475-4311-b34c-47eed9d38cb1@arm.com>
Date: Mon, 9 Feb 2026 15:36:32 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 20/41] arm_mpam: resctrl: Add CDP emulation
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
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org,
 Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-21-ben.horgan@arm.com>
 <2271224c-1796-4823-8c2c-6f529814e645@nvidia.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <2271224c-1796-4823-8c2c-6f529814e645@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Fenghua,

On 2/9/26 01:16, Fenghua Yu wrote:
> Hi, Ben,
> 
> On 2/3/26 13:43, Ben Horgan wrote:
>> From: James Morse <james.morse@arm.com>
>>
>> Intel RDT's CDP feature allows the cache to use a different control value
>> depending on whether the accesses was for instruction fetch or a data
>> access. MPAM's equivalent feature is the other way up: the CPU assigns a
>> different partid label to traffic depending on whether it was instruction
>> fetch or a data access, which causes the cache to use a different control
>> value based solely on the partid.
>>
>> MPAM can emulate CDP, with the side effect that the alternative partid is
>> seen by all MSC, it can't be enabled per-MSC.
>>
>> Add the resctrl hooks to turn this on or off. Add the helpers that
>> match a
>> closid against a task, which need to be aware that the value written to
>> hardware is not the same as the one resctrl is using.
>>
>> Update the 'arm64_mpam_global_default' variable the arch code uses during
>> context switch to know when the per-cpu value should be used instead.
>> Also,
>> update these per-cpu values and sync the resulting mpam partid/pmg
>> configuration to hardware.
>>
>> Awkwardly, the MB controls don't implement CDP. To emulate this, the MPAM
>> equivalent needs programming twice by the resctrl glue, as resctrl
>> expects
>> the bandwidth controls to be applied independently for both data and
>> instruction-fetch.
>>
>> Tested-by: Gavin Shan <gshan@redhat.com>
>> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
>> Tested-by: Peter Newman <peternewman@google.com>
>> CC: Dave Martin <Dave.Martin@arm.com>
>> CC: Amit Singh Tomar <amitsinght@marvell.com>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>> Changes since rfc:
>> Fail cdp initialisation if there is only one partid
>> Correct data/code confusion
>>
>> Changes since v2:
>> Don't include unused header
>>
>> Changes since v3:
>> Update the per-cpu values and sync to h/w
>> ---
>>   arch/arm64/include/asm/mpam.h  |   1 +
>>   drivers/resctrl/mpam_resctrl.c | 117 +++++++++++++++++++++++++++++++++
>>   include/linux/arm_mpam.h       |   2 +
>>   3 files changed, 120 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/
>> mpam.h
>> index 05aa71200f61..70d396e7b6da 100644
>> --- a/arch/arm64/include/asm/mpam.h
>> +++ b/arch/arm64/include/asm/mpam.h
>> @@ -4,6 +4,7 @@
>>   #ifndef __ASM__MPAM_H
>>   #define __ASM__MPAM_H
>>   +#include <linux/arm_mpam.h>
>>   #include <linux/bitfield.h>
>>   #include <linux/jump_label.h>
>>   #include <linux/percpu.h>
>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/
>> mpam_resctrl.c
>> index cd52ca279651..12017264530a 100644
>> --- a/drivers/resctrl/mpam_resctrl.c
>> +++ b/drivers/resctrl/mpam_resctrl.c
>> @@ -38,6 +38,10 @@ static DEFINE_MUTEX(domain_list_lock);
>>   static bool exposed_alloc_capable;
>>   static bool exposed_mon_capable;
>>   +/*
>> + * MPAM emulates CDP by setting different PARTID in the I/D fields of
>> MPAM0_EL1.
>> + * This applies globally to all traffic the CPU generates.
>> + */
>>   static bool cdp_enabled;
>>     bool resctrl_arch_alloc_capable(void)
>> @@ -50,6 +54,72 @@ bool resctrl_arch_mon_capable(void)
>>       return exposed_mon_capable;
>>   }
>>   +bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level rid)
>> +{
>> +    switch (rid) {
>> +    case RDT_RESOURCE_L2:
>> +    case RDT_RESOURCE_L3:
>> +        return cdp_enabled;
>> +    case RDT_RESOURCE_MBA:
>> +    default:
>> +        /*
>> +         * x86's MBA control doesn't support CDP, so user-space doesn't
> 
> s/x86's/ARM's/

In CPUs supporting MPAM the instruction/data distinction is made at the
CPU so doesn't depend on the specific control. The point this comment is
trying to make is that as x86 doesn't support CDP on MBA, resctrl, which
was initially x86 specific, expected CDP not to be supported on MBA and
hence MPAM/ARM64 has to match this behaviour. Therefore, the MPAM driver
doesn't support CDP on MBA either. In essence, the MPAM driver emulates
the x86 CDP behaviour. Having said that, this comment relies on the
reader knowing this historical context, and so I'll update it to not
reference x86 and just mention that it is the expectation of the resctrl
interface.

> 
> Thanks.
> 
> -Fenghua
> 
> [SNIP]

Thanks,

Ben

