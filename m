Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4283735FF70
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 16:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767976550; cv=none; b=XVQqlS2bW746IrbG5C/nXHaZdLrvOI/rA3I13c/yFQ71xYvYqt3areRVDYKGsvN4QBnc5yUoZ9eG7YaCE3Bir0ob+ikEB2aGWG/BL+zEotG8Wdf5krPTTJP890TeNvXqbMUHqoQwEBCO0zUP8gloMLmk3hYxXhp1zcS4cjp3rZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767976550; c=relaxed/simple;
	bh=cUWC9TkEWPWm1KcHlmIlmms9O8Tdjx84AwU78Vlco+4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=dkZAPv0zjXX8pPBR+/tgVAelHiVKqJ8PwOk59+DSmGfWtJUJkuBsr/Q11Pdxky73iyvRLvkXxdkKEEJHwxBmCt/iYG8IC+F3tLqGA8Dzn19qmOaTp40o1Xyi9jnkh63Q1tKD2IpPWXoru8WBhfUcxRHgtYPB/zpDmX4C/nE7mKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Hg7GLo8u; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Hg7GLo8u"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-477563e28a3so22654225e9.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 08:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767976548; x=1768581348; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mYq4XTnbwe8g/sd+bNMtb4SVhwA4K4IuyRiWM4Te0+M=;
        b=Hg7GLo8uR3izqFJiZ/P6tC/1DM89h5c8++jaoE/jLQs0T51w8e56QNnvbWycxZIyjx
         PxGyMUXdgORITUau/Nna1zbdwGoRU98zSE0AdVZZ2sUOSQrmo+QEoU2AB9rWpFahIl4y
         N2xYT6blduUvNFrx9WIdjjcnkkhyLgVOYX38ZWqiYLgKyafJ+vEj4QI5V1EgMeHAtYGc
         SpGfzX6lk/kbPLQ82ZqkdOBPqjL0Sv9ftMJngBbe9cw4WBwFZh7wHXWnMjE7YhsOBIF+
         Go4CBahMcPtemcYaIAHKl3eIEYbS1To49mOx2B4qw9utaPeoJ3SHfTctmltLweCfEk9x
         R65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767976548; x=1768581348;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mYq4XTnbwe8g/sd+bNMtb4SVhwA4K4IuyRiWM4Te0+M=;
        b=jMt+kVmVwWtcuHWor803iW4YgIFJzEcm59b+sllsCS/YsA/u49PjqIe03PpL4dmz4y
         EEXnURawG0GLpXYUql0zqNRAspctvbW4itqcMLKrJ5rneduWyDLbHnn01FjfUQkAAejb
         eLxoKhD4DJemqgxtas+H5EFAsDik/Mbk+L7Bsk0v84VlRy/egNYfm1Vx2RiU3EQHzPnN
         2x5ff1I01jMCtY7lveBC5e7SP9/GzmzzTtTk46KNNuqRixQ+t8/lkvcUkgIG3/E8tRiI
         rgqVRxcfXBbU+M2eH2DjI60bXHsqPhnSAYGXu0tGXLgW+45Bjrr9KACoN+fPtNjz9+ob
         lKLA==
X-Forwarded-Encrypted: i=1; AJvYcCXnzIe9RaClkEvrOZKO8/kyS5FMpGUXa4FPczXjZxygQeZgLPR8490edXpx5eVyQGFKKfS09Cc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNeCH7Q8G04ryNsKANRCJLFnSAY2nDhFHkNyv2Ajmga1XBLpIF
	aAArYaxoUK0Qm1F4cFVoTh2QqEtW7K6MlLUVIFRjv9HRRAHdhrrmXdGIXm7lbKa0cxM=
X-Gm-Gg: AY/fxX4tJ2seTiW48Pw1g2nXN+WasG4hllVLDrQ0v2fs8FsaIp+xkRMkbKXJyaUJnLc
	4xzeST124vM+D52Ba0k/y9ub7oiOeAu/nkbc3XGaNnJ3YJGXxabi0nzR4+wCH20sAUFDQROmKUJ
	zIApq/onzGn/m+a5Ty3RrrOYYjiOyoAcAdnQeQNwrfMdEQC5/7LV8UtFAMsgbfvwWXNRO+Ynlb1
	oxisfz7ylTKw0Cr4F/8OqUecYwCUkeMwJtSXh7VpGjsqpoWnZTD5IuQ3yia8l9M9NF6hg4X7t9I
	t/zv8Z910NyGa4gCaRy2MB6ne2MU0nX/ZvuJC9lW5IGXWzQCoCR5hjO9CXQa9ir+RAbUIcpORJv
	XcAU/XG7lDcWduGYLRqZAr3H83suGT5WiyA9T6Xpn9ybL6xL1rP1aEgPpsIyQmsAQweWfeHTtWu
	LfZ8DHxCYiTjty0VhT
X-Google-Smtp-Source: AGHT+IEAjgf+lbfDMBhJeK65teYZfj9k9R/EgG3oHcJdbO0MuQcicmWirw3jnMponF1BxGAtxSDoHA==
X-Received: by 2002:a05:600c:5916:b0:475:d7fd:5c59 with SMTP id 5b1f17b1804b1-47d81810b1fmr125710995e9.16.1767976547522;
        Fri, 09 Jan 2026 08:35:47 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f661a03sm228438135e9.13.2026.01.09.08.35.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 08:35:47 -0800 (PST)
Message-ID: <c1d3c9e4-68e2-495f-8171-6780a9badf56@linaro.org>
Date: Fri, 9 Jan 2026 16:35:46 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 29/35] KVM: arm64: Pin the SPE buffer in the host
 and map it at stage 2
From: James Clark <james.clark@linaro.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: mark.rutland@arm.com, james.morse@arm.com, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-30-alexandru.elisei@arm.com>
 <38443801-af4e-4ce1-a1c2-603eca8d90da@linaro.org>
Content-Language: en-US
In-Reply-To: <38443801-af4e-4ce1-a1c2-603eca8d90da@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 09/01/2026 4:29 pm, James Clark wrote:
> 
> 
> On 14/11/2025 4:07 pm, Alexandru Elisei wrote:
>> If the SPU encounters a translation fault when it attempts to write a
>> profiling record to memory, it stops profiling and asserts the PMBIRQ
>> interrupt.  Interrupts are not delivered instantaneously to the CPU, and
>> this creates a profiling blackout window where the profiled CPU executes
>> instructions, but no samples are collected.
>>
>> This is not desirable, and the SPE driver avoids it by keeping the buffer
>> mapped for the entire the profiling session.
>>
>> KVM maps memory at stage 2 when the guest accesses it, following a 
>> fault on
>> a missing stage 2 translation, which means that the problem is present 
>> in a
>> SPE enabled virtual machine. Worse yet, the blackout windows are
>> unpredictable: the guest profiling the same process can during one
>> profiling session, not trigger any stage 2 faults (the entire buffer 
>> memory
>> is already mapped at stage 2), but worst case scenario, during another
>> profiling session, trigger stage 2 faults for every record it attempts to
>> write (if KVM keeps removing the buffer pages from stage 2), or something
>> in between - some records trigger a stage 2 fault, some don't.
>>
>> The solution is for KVM to follow what the SPE driver does: keep the 
>> buffer
>> mapped at stage 2 while ProfilingBufferEnabled() is true. To accomplish
> 
> Hi Alex,
> 
> The problem is that the driver enables and disables the buffer every 
> time the target process is switched out unless you explicitly ask for 
> per-CPU mode. Is there some kind of heuristic you can add to prevent 
> pinning and unpinning unless something actually changes?
> 
> Otherwise it's basically unusable with normal perf commands and larger 
> buffer sizes. Take these basic examples were I've added a filter so no 
> SPE data is even recorded:
> 
>   $ perf record -e arm_spe/min_latency=1000,event_filter=10/ -m,256M --\
>       true
> 
> On a kernel with lockep and kmemleak etc this takes 20s to complete. On 
> a normal kernel build it still takes 4s.
> 
> Much worse is anything more complicated than just 'true' which will have 
> more context switching:
> 
> $ perf record -e arm_spe/min_latency=1000,event_filter=10/ -m,256M --\
>      perf stat true
> 
> This takes 3 minutes or 50 seconds to complete (with and without kernel 
> debugging features respectively)
> 
> For comparison, running these on the host all take less than half a 
> second. I measured each pin/unpin taking about 0.2s and the basic 'true' 
> example resulting in 100 context switches which adds up to the 20s.
> 
> Another interesting stat is that the second example says 'true' ends up 
> running at an average clock speed of 4Mhz:
> 
>            12683357      cycles   #    0.004 GHz
> 
> You also get warnings like this
> 
>   rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
>   rcu:     Tasks blocked on level-0 rcu_node (CPUs 0-0): P53/1:b..l
>   rcu:     (detected by 0, t=6503 jiffies, g=8461, q=43 ncpus=1)
>   task:perf            state:R  running task     stack:0     pid:53 
> tgid:53    ppid:52     task_flags:0x400000 flags:0x00000008
>   Call trace:
>    __switch_to+0x1b8/0x2d8 (T)
>    __schedule+0x8b4/0x1050
>    preempt_schedule_common+0x2c/0xb8
>    preempt_schedule+0x30/0x38
>    _raw_spin_unlock+0x60/0x70
>    finish_fault+0x330/0x408
>    do_pte_missing+0x7d4/0x1188
>    handle_mm_fault+0x244/0x568
>    do_page_fault+0x21c/0x548
>    do_translation_fault+0x44/0x68
>    do_mem_abort+0x4c/0x100
>    el0_da+0x58/0x200
>    el0t_64_sync_handler+0xc0/0x130
>    el0t_64_sync+0x198/0x1a0
> 
> If we can't add a heuristic to keep the buffer pinned, it almost seems 
> like the random blackouts would be preferable to pinning being so slow.
> 

One other comment to add to this, is that increasing the buffer size is 
the normal reaction to profiling overheads being high. I think that's 
how I came across this in the first place. Or if you want to avoid 
overhead entirely you set a buffer that's large enough to handle the 
whole run.

In this case in a VM it actually has the opposite effect to doing the 
same thing on a host. The bigger you make it the worse the problem gets.

