Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17D5248F68
	for <kvmarm@lists.linux.dev>; Tue, 20 Jan 2026 01:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768873352; cv=none; b=GMIubkfGcttEyZ9KsvazuTT+uwRRQBPew2nKyDjptwZQVItMEC5O5b/51vOoKI/w6k++UCvngw7OlLczit9UAb//ZiYf1I5dcdJeroPwzIDboPqhcmwmbE1BaFRcfGSLhKw9hNx70eVhaKRKUKOaVdESXkPTKx7UZrG5LRfO3CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768873352; c=relaxed/simple;
	bh=tul6WymqJ/s3Tk4TNME9AB4Kz/jCw7W+EFgcLEa1TLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jxChU8ZpC5nlddvGZbTPvavVyZAtEPLrZ3qHEo6jojCY8L4wXZ04HvOoftM9Rnw9AeXwY12zB4ZBjp+Z8mph+DFOo7kdPhQpKavkoK6LAhh5RcypI6xtFJJik3SjQzYfZCg0kL/B2AwJF3hQ9AFhpC9XauDZbCTY38VEk09F/9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E8eKDTVs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E8eKDTVs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768873347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jUmHX3uxcNc6yjpwU1CNhVsSz48eAE4qC1VWpnEVxvE=;
	b=E8eKDTVs/Qnk72nFt1ylhNFYI2F9gtclrDviOqupJkMGwcUl4h2GVjk4DGdud+J8dHWUdG
	MasKDo7l0rLCzPAyjNmiCOsneCLlAtFl1uvE2EH5kr1GZFMdZaZ4uQbySjkTpdEnnov9mF
	O6Vt85ZjGhfzG+Sff7Hkr2Rb02EYNow=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-RYpg2zWGO0eRlp56qlYnFw-1; Mon, 19 Jan 2026 20:42:26 -0500
X-MC-Unique: RYpg2zWGO0eRlp56qlYnFw-1
X-Mimecast-MFC-AGG-ID: RYpg2zWGO0eRlp56qlYnFw_1768873346
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c337cde7e40so2471342a12.1
        for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 17:42:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768873346; x=1769478146;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jUmHX3uxcNc6yjpwU1CNhVsSz48eAE4qC1VWpnEVxvE=;
        b=tkc6dgf94wCyS8m0l4WIHx7TRiO8mT3x5li9JvkcesYiWZPk6f1dY1NUXT2ZKIPtq+
         ONhV+fSlU9HFJTm73lcFD/KdFr6fW/q5bHePoYFfe/gjX/9OilVx361vEqSOPX9mKWEX
         YBUSEg92nJlCEIUeWidFupMZPatkE6xiovckBXA2X7seDoAjDdCzTDCxiiDxmwWKXjfF
         FQOYl0oO8zhEIZ/kb2E38RERLezqaEWM+IJpqjz29UsysmJXpXeuu7AClcap1GTpVjKi
         pj2dKAWvBLliO5kvN50xJMTsNLBGDeunOlglbfBaqz54KYchs2Z/d42M80RlYxh4hXdS
         KpKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTtgi9K9aGSzJpqk1+x+G9eY4CefSOBhvT/UcCf8CRC41tVVgTMUz6E5GqBK7wchR0eyiru2Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRZLq/Ha6BTrh9gY1qZXgSvZV3BbJPm8SFqs52TC5kXNKRqpJx
	HL51gzm9Xs79kDDoTczLX749SqZP65Je0wRcoHJsrcefQbCkWykOCmacIZJCRcaPJtEP0RteceZ
	WYANG0Nnxo9lZfZKuGS2Igi725oEVyzlEqaI6eOiFm7pXfQNNqssOiwY00g==
X-Gm-Gg: AY/fxX4tjs/deQ93g+GzIi09jMRnh8AqaWyNMOTKYemCqdwAX5TvuFbqPlw0C5YHbS4
	NLL3tbezkpwUrDze8t3vnZZ1Pore4Mzsxc3DvdXCSZjLBdNE4YdPTZZiATqG15AWvgJxv+0ypta
	UOG6xxkNQa2jl1L2Oy805NVVEn4lQhJq97A/HJP9Ni4QKPaTe60HEUI5qf/zfe+0y8odfs4UfsM
	djtX0bM5XRattB5Goiv3OlnziKYOLGxBq8xgLiyDkAWboMnddN+dO+KMrPQIK2cheVk6dwoPFsX
	sif4Bcxs831b4c4bDH1In6IN019leXQjc38vBr/52dd64E5aiJT6T39RhgIyra2uUStqY4bB2wB
	RTiVJPYSeAKk=
X-Received: by 2002:a05:6a21:3943:b0:366:14af:9bd8 with SMTP id adf61e73a8af0-38e45eaca3dmr326355637.78.1768873345318;
        Mon, 19 Jan 2026 17:42:25 -0800 (PST)
X-Received: by 2002:a05:6a21:3943:b0:366:14af:9bd8 with SMTP id adf61e73a8af0-38e45eaca3dmr326343637.78.1768873344861;
        Mon, 19 Jan 2026 17:42:24 -0800 (PST)
Received: from [10.72.112.128] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c5edf249fcbsm10600102a12.12.2026.01.19.17.42.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 17:42:24 -0800 (PST)
Message-ID: <02b41ff8-1373-493d-93ab-7eb78e0a57a1@redhat.com>
Date: Tue, 20 Jan 2026 09:42:09 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/47] arm64: mpam: Context switch the MPAM registers
To: Ben Horgan <ben.horgan@arm.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>
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
 <eba5f35c-2edc-47e4-9c74-e60aaf7ab4ec@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <eba5f35c-2edc-47e4-9c74-e60aaf7ab4ec@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4cvXcXf681pcPoelCi6i-pQoYhy8F_5BqVdKHurttQw_1768873346
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ben and Jonathan,

On 1/19/26 10:00 PM, Ben Horgan wrote:
> Hi Gavin, Jonathan,
> 
> On 1/15/26 12:09, Jonathan Cameron wrote:
>> On Thu, 15 Jan 2026 14:47:28 +0800
>> Gavin Shan <gshan@redhat.com> wrote:
>>
>>> Hi Ben,
>>>
>>> On 1/13/26 12:58 AM, Ben Horgan wrote:
>>>> From: James Morse <james.morse@arm.com>
>>>>
>>>> MPAM allows traffic in the SoC to be labeled by the OS, these labels are
>>>> used to apply policy in caches and bandwidth regulators, and to monitor
>>>> traffic in the SoC. The label is made up of a PARTID and PMG value. The x86
>>>> equivalent calls these CLOSID and RMID, but they don't map precisely.
>>>>
>>>> MPAM has two CPU system registers that is used to hold the PARTID and PMG
>>>> values that traffic generated at each exception level will use. These can
>>>> be set per-task by the resctrl file system. (resctrl is the defacto
>>>> interface for controlling this stuff).
>>>>
>>>> Add a helper to switch this.
>>>>
>>>> struct task_struct's separate CLOSID and RMID fields are insufficient to
>>>> implement resctrl using MPAM, as resctrl can change the PARTID (CLOSID) and
>>>> PMG (sort of like the RMID) separately. On x86, the rmid is an independent
>>>> number, so a race that writes a mismatched closid and rmid into hardware is
>>>> benign. On arm64, the pmg bits extend the partid.
>>>> (i.e. partid-5 has a pmg-0 that is not the same as partid-6's pmg-0).  In
>>>> this case, mismatching the values will 'dirty' a pmg value that resctrl
>>>> believes is clean, and is not tracking with its 'limbo' code.
>>>>
>>>> To avoid this, the partid and pmg are always read and written as a
>>>> pair. This requires a new u64 field. In struct task_struct there are two
>>>> u32, rmid and closid for the x86 case, but as we can't use them here do
>>>> something else. Add this new field, mpam_partid_pmg, to struct thread_info
>>>> to avoid adding more architecture specific code to struct task_struct.
>>>> Always use READ_ONCE()/WRITE_ONCE() when accessing this field.
>>>>
>>>> Resctrl allows a per-cpu 'default' value to be set, this overrides the
>>>> values when scheduling a task in the default control-group, which has
>>>> PARTID 0. The way 'code data prioritisation' gets emulated means the
>>>> register value for the default group needs to be a variable.
>>>>
>>>> The current system register value is kept in a per-cpu variable to avoid
>>>> writing to the system register if the value isn't going to change.  Writes
>>>> to this register may reset the hardware state for regulating bandwidth.
>>>>
>>>> Finally, there is no reason to context switch these registers unless there
>>>> is a driver changing the values in struct task_struct. Hide the whole thing
>>>> behind a static key. This also allows the driver to disable MPAM in
>>>> response to errors reported by hardware. Move the existing static key to
>>>> belong to the arch code, as in the future the MPAM driver may become a
>>>> loadable module.
>>>>
>>>> All this should depend on whether there is an MPAM driver, hide it behind
>>>> CONFIG_ARM64_MPAM.
>>>>
>>>> CC: Amit Singh Tomar <amitsinght@marvell.com>
>>>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>>>> Signed-off-by: James Morse <james.morse@arm.com>
>>>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>>>> ---
>>>> Changes since rfc:
>>>> CONFIG_MPAM -> CONFIG_ARM64_MPAM in commit message
>>>> Remove extra DECLARE_STATIC_KEY_FALSE
>>>> Function name in comment, __mpam_sched_in() -> mpam_thread_switch()
>>>> Remove unused headers
>>>> Expand comment (Jonathan)
>>>>
>>>> Changes since v2:
>>>> Tidy up ifdefs
>>>> ---
>>>>    arch/arm64/Kconfig                   |  2 +
>>>>    arch/arm64/include/asm/mpam.h        | 67 ++++++++++++++++++++++++++++
>>>>    arch/arm64/include/asm/thread_info.h |  3 ++
>>>>    arch/arm64/kernel/Makefile           |  1 +
>>>>    arch/arm64/kernel/mpam.c             | 13 ++++++
>>>>    arch/arm64/kernel/process.c          |  7 +++
>>>>    drivers/resctrl/mpam_devices.c       |  2 -
>>>>    drivers/resctrl/mpam_internal.h      |  4 +-
>>>>    8 files changed, 95 insertions(+), 4 deletions(-)
>>>>    create mode 100644 arch/arm64/include/asm/mpam.h
>>>>    create mode 100644 arch/arm64/kernel/mpam.c
>>>>    
>>>
>>> With the following nitpick addressed:
>>>
>>
>> I commented on the nitpick.
>>
>>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>
>>>> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
>>>> index 76f32e424065..15979f366519 100644
>>>> --- a/arch/arm64/kernel/Makefile
>>>> +++ b/arch/arm64/kernel/Makefile
>>>> @@ -67,6 +67,7 @@ obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
>>>>    obj-$(CONFIG_VMCORE_INFO)		+= vmcore_info.o
>>>>    obj-$(CONFIG_ARM_SDE_INTERFACE)		+= sdei.o
>>>>    obj-$(CONFIG_ARM64_PTR_AUTH)		+= pointer_auth.o
>>>> +obj-$(CONFIG_ARM64_MPAM)		+= mpam.o
>>>>    obj-$(CONFIG_ARM64_MTE)			+= mte.o
>>>>    obj-y					+= vdso-wrap.o
>>>>    obj-$(CONFIG_COMPAT_VDSO)		+= vdso32-wrap.o
>>>> diff --git a/arch/arm64/kernel/mpam.c b/arch/arm64/kernel/mpam.c
>>>> new file mode 100644
>>>> index 000000000000..9866d2ca0faa
>>>> --- /dev/null
>>>> +++ b/arch/arm64/kernel/mpam.c
>>>> @@ -0,0 +1,13 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +/* Copyright (C) 2025 Arm Ltd. */
>>>> +
>>>> +#include <asm/mpam.h>
>>>> +
>>>> +#include <linux/jump_label.h>
>>>> +#include <linux/percpu.h>
>>>> +
>>>
>>> Nitpick: Needn't include those two header files since they have been included
>>> to <asm/mpam.h>
>>
>> That is a non obvious include chain that we should not rely on.
>> Please keep the headers and continue to follow include what you use
>> style (with exceptions when a given header is clearly documented as always including
>> another like some of the bit map stuff.) It is more obviously correct and
>> causes less grief if headers get refactored in future.
> 
> Keeping the includes here makes sense to me too. Gavin, are you ok with
> keeping this as is?
> 

Yeah, I'm fine to keep it as of being :-)

>>
>>>    
>>>> +DEFINE_STATIC_KEY_FALSE(mpam_enabled);
>>>> +DEFINE_PER_CPU(u64, arm64_mpam_default);
>>>> +DEFINE_PER_CPU(u64, arm64_mpam_current);
>>>> +
>>>> +u64 arm64_mpam_global_default;
>>
>>>
>>
> 
> Thanks,
> 
> Ben
> 
> 

Thanks,
Gavin

