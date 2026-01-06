Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D7F320A38
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 11:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767698490; cv=none; b=aZM51xeB+3sh4R0pbjqldUQgj+ZQYcmjJTfwt2KTr/tdp/lRiazDLV+SWI/U4G108W67JgfSUgq92pra+S0aOJoaNpXNPOa+0VQDmo0gVd8F+ivZQRBGAluKvPRjcWNwrliPnNGmpAJLpOIQG4O+dVt090dCO/JCJOV/NTyg7hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767698490; c=relaxed/simple;
	bh=HtVQxGqxmycZRrMSpUGFDno6BjtIe7FZF0i2ITi6/3E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mm+eeLHoTE3najxxDTHtMRSsfpp2N/DpqwN3o9Xc2uHMSBYkj1gsfZ3xzIKd5k+0OdCJBFcPvyHCtxFr7kX2kQVNgcwpzvQsd0s6GojrbF/J+MKCBgHjUNRFpCsJk1EEhxWgrtlhX6dUxM9LQt3qaTJ6fJqcNy2DPPyJh5Crc04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93F3C1596;
	Tue,  6 Jan 2026 03:21:20 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F8D83F5A1;
	Tue,  6 Jan 2026 03:21:22 -0800 (PST)
Message-ID: <22eadfd1-67f9-470f-8e4e-b9af4dc869e1@arm.com>
Date: Tue, 6 Jan 2026 11:21:20 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 22/45] arm_mpam: resctrl: Add CDP emulation
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
 <20251219181147.3404071-23-ben.horgan@arm.com>
 <20260105180700.000037c8@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260105180700.000037c8@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jonathan,

On 1/5/26 18:07, Jonathan Cameron wrote:
> On Fri, 19 Dec 2025 18:11:24 +0000
> Ben Horgan <ben.horgan@arm.com> wrote:
> 
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
>> Add the resctrl hooks to turn this on or off. Add the helpers that match a
>> closid against a task, which need to be aware that the value written to
>> hardware is not the same as the one resctrl is using.
>>
>> Update the 'arm64_mpam_global_default' variable the arch code uses during
>> context switch to know when the per-cpu value should be used instead.
>>
>> Awkwardly, the MB controls don't implement CDP. To emulate this, the MPAM
>> equivalent needs programming twice by the resctrl glue, as resctrl expects
>> the bandwidth controls to be applied independently for both data and
>> instruction-fetch.
>>
>> CC: Dave Martin <Dave.Martin@arm.com>
>> CC: Amit Singh Tomar <amitsinght@marvell.com>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> 
> Minor thing below.
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> 
> 
>> diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h
>> index 5a78299ec464..ba0312b55d9f 100644
>> --- a/include/linux/arm_mpam.h
>> +++ b/include/linux/arm_mpam.h
>> @@ -5,6 +5,7 @@
>>  #define __LINUX_ARM_MPAM_H
>>  
>>  #include <linux/acpi.h>
>> +#include <linux/resctrl_types.h>
> 
> This seems odd as nothing added to the header in this path appears to need it.
> Maybe should be down in the c file or in a different patch?

Yep, moved it to patch 33, arm_mpam: resctrl: Allow resctrl to allocate
monitors.

> 
>>  #include <linux/types.h>
>>  
>>  struct mpam_msc;
>> @@ -56,6 +57,8 @@ void resctrl_arch_set_cpu_default_closid(int cpu, u32 closid);
>>  void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
>>  void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid, u32 rmid);
>>  void resctrl_arch_sched_in(struct task_struct *tsk);
>> +bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid);
>> +bool resctrl_arch_match_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
>>  
>>  /**
>>   * mpam_register_requestor() - Register a requestor with the MPAM driver
> 

Thanks,

Ben

