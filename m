Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 419FB374177
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 14:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768831216; cv=none; b=OoNW0CVHuWitLlGoLb13lJ1xmwRMT3i0yCxFG6pLNnzs4If1qymkaqCFEchFFiYdiT52OeEC2VpLYA4NsygBUCbxkC0Wp/iIqqkZRcDzlCp8hD2klD679hPl9kbxBcuKCaMgbFqmXqLDbs9zBPKwMp8e9UDRxJF0Ho4ExBAk1Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768831216; c=relaxed/simple;
	bh=c8qrC7LXIt8fTfz8jCyB0PHnc1DUISJxFODZGi97t00=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rEnWh7L9VAmzEQ8CCRTZ7iKzef+MTcGtHf0BRVRA1s6uvFkz0PvY1v+jqdq4eq3sZtD5qXc94s/AWmDWrXUR6k1eXrncO4uUet6yIkP0XpqcRZkGCLg1V+hk/HltwRk8u1cdJyr96etHhm8yUC0zce2SEt6/gpTrkGjT3X3T75I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 12EC6FEC;
	Mon, 19 Jan 2026 06:00:07 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D68CB3F632;
	Mon, 19 Jan 2026 06:00:08 -0800 (PST)
Message-ID: <eba5f35c-2edc-47e4-9c74-e60aaf7ab4ec@arm.com>
Date: Mon, 19 Jan 2026 14:00:07 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/47] arm64: mpam: Context switch the MPAM registers
To: Jonathan Cameron <jonathan.cameron@huawei.com>,
 Gavin Shan <gshan@redhat.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, james.morse@arm.com, kobak@nvidia.com,
 lcherian@marvell.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, peternewman@google.com,
 punit.agrawal@oss.qualcomm.com, quic_jiles@quicinc.com,
 reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-7-ben.horgan@arm.com>
 <12779ebc-1928-42db-8a44-ee97e2a58fd1@redhat.com>
 <20260115120923.000079fa@huawei.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20260115120923.000079fa@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Gavin, Jonathan,

On 1/15/26 12:09, Jonathan Cameron wrote:
> On Thu, 15 Jan 2026 14:47:28 +0800
> Gavin Shan <gshan@redhat.com> wrote:
> 
>> Hi Ben,
>>
>> On 1/13/26 12:58 AM, Ben Horgan wrote:
>>> From: James Morse <james.morse@arm.com>
>>>
>>> MPAM allows traffic in the SoC to be labeled by the OS, these labels are
>>> used to apply policy in caches and bandwidth regulators, and to monitor
>>> traffic in the SoC. The label is made up of a PARTID and PMG value. The x86
>>> equivalent calls these CLOSID and RMID, but they don't map precisely.
>>>
>>> MPAM has two CPU system registers that is used to hold the PARTID and PMG
>>> values that traffic generated at each exception level will use. These can
>>> be set per-task by the resctrl file system. (resctrl is the defacto
>>> interface for controlling this stuff).
>>>
>>> Add a helper to switch this.
>>>
>>> struct task_struct's separate CLOSID and RMID fields are insufficient to
>>> implement resctrl using MPAM, as resctrl can change the PARTID (CLOSID) and
>>> PMG (sort of like the RMID) separately. On x86, the rmid is an independent
>>> number, so a race that writes a mismatched closid and rmid into hardware is
>>> benign. On arm64, the pmg bits extend the partid.
>>> (i.e. partid-5 has a pmg-0 that is not the same as partid-6's pmg-0).  In
>>> this case, mismatching the values will 'dirty' a pmg value that resctrl
>>> believes is clean, and is not tracking with its 'limbo' code.
>>>
>>> To avoid this, the partid and pmg are always read and written as a
>>> pair. This requires a new u64 field. In struct task_struct there are two
>>> u32, rmid and closid for the x86 case, but as we can't use them here do
>>> something else. Add this new field, mpam_partid_pmg, to struct thread_info
>>> to avoid adding more architecture specific code to struct task_struct.
>>> Always use READ_ONCE()/WRITE_ONCE() when accessing this field.
>>>
>>> Resctrl allows a per-cpu 'default' value to be set, this overrides the
>>> values when scheduling a task in the default control-group, which has
>>> PARTID 0. The way 'code data prioritisation' gets emulated means the
>>> register value for the default group needs to be a variable.
>>>
>>> The current system register value is kept in a per-cpu variable to avoid
>>> writing to the system register if the value isn't going to change.  Writes
>>> to this register may reset the hardware state for regulating bandwidth.
>>>
>>> Finally, there is no reason to context switch these registers unless there
>>> is a driver changing the values in struct task_struct. Hide the whole thing
>>> behind a static key. This also allows the driver to disable MPAM in
>>> response to errors reported by hardware. Move the existing static key to
>>> belong to the arch code, as in the future the MPAM driver may become a
>>> loadable module.
>>>
>>> All this should depend on whether there is an MPAM driver, hide it behind
>>> CONFIG_ARM64_MPAM.
>>>
>>> CC: Amit Singh Tomar <amitsinght@marvell.com>
>>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>>> Signed-off-by: James Morse <james.morse@arm.com>
>>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>>> ---
>>> Changes since rfc:
>>> CONFIG_MPAM -> CONFIG_ARM64_MPAM in commit message
>>> Remove extra DECLARE_STATIC_KEY_FALSE
>>> Function name in comment, __mpam_sched_in() -> mpam_thread_switch()
>>> Remove unused headers
>>> Expand comment (Jonathan)
>>>
>>> Changes since v2:
>>> Tidy up ifdefs
>>> ---
>>>   arch/arm64/Kconfig                   |  2 +
>>>   arch/arm64/include/asm/mpam.h        | 67 ++++++++++++++++++++++++++++
>>>   arch/arm64/include/asm/thread_info.h |  3 ++
>>>   arch/arm64/kernel/Makefile           |  1 +
>>>   arch/arm64/kernel/mpam.c             | 13 ++++++
>>>   arch/arm64/kernel/process.c          |  7 +++
>>>   drivers/resctrl/mpam_devices.c       |  2 -
>>>   drivers/resctrl/mpam_internal.h      |  4 +-
>>>   8 files changed, 95 insertions(+), 4 deletions(-)
>>>   create mode 100644 arch/arm64/include/asm/mpam.h
>>>   create mode 100644 arch/arm64/kernel/mpam.c
>>>   
>>
>> With the following nitpick addressed:
>>
> 
> I commented on the nitpick.
> 
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
>>> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
>>> index 76f32e424065..15979f366519 100644
>>> --- a/arch/arm64/kernel/Makefile
>>> +++ b/arch/arm64/kernel/Makefile
>>> @@ -67,6 +67,7 @@ obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
>>>   obj-$(CONFIG_VMCORE_INFO)		+= vmcore_info.o
>>>   obj-$(CONFIG_ARM_SDE_INTERFACE)		+= sdei.o
>>>   obj-$(CONFIG_ARM64_PTR_AUTH)		+= pointer_auth.o
>>> +obj-$(CONFIG_ARM64_MPAM)		+= mpam.o
>>>   obj-$(CONFIG_ARM64_MTE)			+= mte.o
>>>   obj-y					+= vdso-wrap.o
>>>   obj-$(CONFIG_COMPAT_VDSO)		+= vdso32-wrap.o
>>> diff --git a/arch/arm64/kernel/mpam.c b/arch/arm64/kernel/mpam.c
>>> new file mode 100644
>>> index 000000000000..9866d2ca0faa
>>> --- /dev/null
>>> +++ b/arch/arm64/kernel/mpam.c
>>> @@ -0,0 +1,13 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/* Copyright (C) 2025 Arm Ltd. */
>>> +
>>> +#include <asm/mpam.h>
>>> +
>>> +#include <linux/jump_label.h>
>>> +#include <linux/percpu.h>
>>> +  
>>
>> Nitpick: Needn't include those two header files since they have been included
>> to <asm/mpam.h>
> 
> That is a non obvious include chain that we should not rely on.
> Please keep the headers and continue to follow include what you use
> style (with exceptions when a given header is clearly documented as always including
> another like some of the bit map stuff.) It is more obviously correct and
> causes less grief if headers get refactored in future.

Keeping the includes here makes sense to me too. Gavin, are you ok with
keeping this as is?

> 
>>   
>>> +DEFINE_STATIC_KEY_FALSE(mpam_enabled);
>>> +DEFINE_PER_CPU(u64, arm64_mpam_default);
>>> +DEFINE_PER_CPU(u64, arm64_mpam_current);
>>> +
>>> +u64 arm64_mpam_global_default;
> 
>>
> 

Thanks,

Ben

