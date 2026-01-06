Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 766D0338932
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 15:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767712995; cv=none; b=nhKqHRVz43FauBHsQwhqSKSB8DTzUyXJ+wrZwdWJ//0dzCqpg+ktfQ/bo/DmJ1Tm+jaSy/gLoxjMBIAT/X7MsN1WK1i2GM/574Ddr8oVnOy0gvAW5zuK7n0IInwNgJA13fIVzHFP3fI/kqyyi4iU4MWGIic7c9UQhPo2tUpWnQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767712995; c=relaxed/simple;
	bh=p5nUWO5+OlHwXmE9Nhvkfke+uGAizu12Xj/w8NHePzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t2Ndn0gSuURmQ7uZnFZFYSSdZCzS9ULsJKnLO5K/RklP2WIyr6/5QJ//szy5T2MgJGCTB6oq8JMj4qdKuQr9hL5GrcspElBXiA26FA+oXIT+qEV1W0ISALTmzdnNybBl88xO7GxbMawKqcZb2A3MsG3058/D/45QPmWu602zknE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4771497;
	Tue,  6 Jan 2026 07:23:04 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C79833F5A1;
	Tue,  6 Jan 2026 07:23:06 -0800 (PST)
Message-ID: <db799d84-53be-41ea-97a4-f11e03d7f517@arm.com>
Date: Tue, 6 Jan 2026 15:23:05 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/45] arm_mpam: resctrl: Add rmid index helpers
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
 <20251219181147.3404071-24-ben.horgan@arm.com>
 <20260106112115.00000201@huawei.com>
 <316c5635-75af-4ebb-ad2c-fab0742beb20@arm.com>
 <20260106140447.0000602b@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260106140447.0000602b@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jonathan,

On 1/6/26 14:04, Jonathan Cameron wrote:
> On Tue, 6 Jan 2026 11:33:44 +0000
> Ben Horgan <ben.horgan@arm.com> wrote:
> 
>> Hi Jonathan,
>>
>> On 1/6/26 11:21, Jonathan Cameron wrote:
>>> On Fri, 19 Dec 2025 18:11:25 +0000
>>> Ben Horgan <ben.horgan@arm.com> wrote:
>>>   
>>>> From: James Morse <james.morse@arm.com>
>>>>
>>>> Because MPAM's pmg aren't identical to RDT's rmid, resctrl handles some
>>>> data structures by index. This allows x86 to map indexes to RMID, and MPAM
>>>> to map them to partid-and-pmg.
>>>>
>>>> Add the helpers to do this.
>>>>
>>>> Signed-off-by: James Morse <james.morse@arm.com>
>>>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>  
>>> one comment inline.
>>> I messed around with GENMASK + field_prep()/field_get() - new
>>> versions of these with no need for runtime constant masks, but
>>> it ended up as not that much more readable than what you have here.
>>>
>>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>  
>>>> ---
>>>> Changes since rfc:
>>>> Use ~0U instead of ~0 in lhs of left shift
>>>> ---
>>>>  drivers/resctrl/mpam_resctrl.c | 28 ++++++++++++++++++++++++++++
>>>>  include/linux/arm_mpam.h       |  3 +++
>>>>  2 files changed, 31 insertions(+)
>>>>
>>>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>>>> index 4275b1a85887..bdbc5504964b 100644
>>>> --- a/drivers/resctrl/mpam_resctrl.c
>>>> +++ b/drivers/resctrl/mpam_resctrl.c
>>>> @@ -120,6 +120,34 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
>>>>  	return mpam_partid_max + 1;
>>>>  }
>>>>  
>>>> +u32 resctrl_arch_system_num_rmid_idx(void)
>>>> +{
>>>> +	u8 closid_shift = fls(mpam_pmg_max);
>>>> +	u32 num_partid = resctrl_arch_get_num_closid(NULL);
>>>> +
>>>> +	return num_partid << closid_shift;  
>>>
>>> Given I think you restrict mpam_pmg_max to be power of 2 elsewhere,
>>> doesn't this end up the same as something like
>>> 	return mpam_pmg_max * resctrl_arch_get_num_closid(NULL);
>>> Maybe its worth keeping it in the form you have here as
>>> it sort of provides documentation for how you pack those IDs  
>>
>> We only warn if (mpam_pmg_max + 1) is a power of 2 and so I'll keep this
>> as it is, although yours is equivalent in the expected case.
> 
> Do the resulting 'holes' in the values that are valid here cause
> trouble it isn't power of 2? 

Theoretically they are a problem, and if resctrl allocates them then we
would get invalid pmg values which can cause msc error interrupts.
However, I don't know of any platforms where pmg_max is more than 1.

Anyhow, I'll look into using multiplication in these rmid arch helpers
rather than just shifting to avoid leaving these holes.

> 
>>
>>>   
>>>> +}  
>>>   
>>
>> Thanks,
>>
>> Ben
>>
>>
> 

-- 
Thanks,

Ben

