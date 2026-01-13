Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895FA288C81
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 14:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768313925; cv=none; b=iSaMM3m1ox4BhYoh4QHmT2u2D4vlCmzH29EZtGQmTMOCGmHhHnOP0O8wFEUelU/ppwcVF7P/aQEfpGaeMm7JlEXBbWNp7Hw4fWNG8+S0AhmltYAeRZJR5C49g6LHywLhfW09XfxMtlx47HB9xXXMuLIVopTnNyGtiL1l5aHbtuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768313925; c=relaxed/simple;
	bh=+WCMvHFdUQzkv4coj1g8TVZgxorYzb+8BkCL073q8eM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j7S8JMkUGbFEHR0Uy5G/EkQ37fDkPv00KcssIuRjISnOPcVNG7ud+7kkBX+7hBhUNfqXojPB7Y7c1n3Cj8NPZ/OlAf9BfcatP2y+TIQd7DkNaK6e+Zmym8/DPh5A6t+XyWl+1dAvPzv4vk0XaMquETohyzdkUxZ9gQHQ65856TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fBi4OF0a; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fBi4OF0a"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-477770019e4so56505545e9.3
        for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 06:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768313922; x=1768918722; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P+/QWbrCZSKC1SVIjuFOyGX7Ro1h7gycZSpmSCaFnsM=;
        b=fBi4OF0aooFjTVRlaX68ezan0Bf4vNK7SJEcWB71oPtgA0hSF3eDaFhHWG8bbm/qOo
         iW9CO85FRCIXFRGDXfTBY4mlOpObn8peZ3NXUFn5IgQ4kyt4HRUBmBso0pTD3yUTIc0n
         NOl0Exl/l76T5WGLwzOI6GPgWEMDgUX+IYc6v2n//3bvcr3sFm2YYI/VZ4oXEBB0juLw
         MO4U1teGoOAl5wAe+7LkSy4eb1nU1Genj3xnZBHHY+XqZ7cwyyB7WBbBoZ/cKEBfBnMa
         Yx0IAYYfB502Qqy1bdQ2Kepx6U10RFEf969maP4iODQqBDbC52EHZGkv2fxFP6LWEt9h
         8RAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768313922; x=1768918722;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P+/QWbrCZSKC1SVIjuFOyGX7Ro1h7gycZSpmSCaFnsM=;
        b=c+dpPUSIXTUf+KVIYp/MNuV73KoFokTLMye7hXZw97w6Ip03lG5g5sgzVhm9sFTuso
         2C0ZO/VtNP15UbOqu29tHorSumpjtZEHVkZvalvqfEYRwjWIA5PDJP3lyAfvExemTfYk
         lw3aDFh7koJgAtoeWziJRTPvyNdzeZiaOkeNA5qjHqtz3Phc0ev2aC9W/gBa3+SrWjmv
         Yu+if/Ck/f1xj3a7tTRXzBsEjdzY+F0WYU06Dh0mkKQYiTzQA3mzLflUVJIqRXj+wtrV
         3roqDrdnlMyqDkK5f5bnfJXX43i5WpwMdknYXp+QYmDZ/K9nJtZVpxC1R7KGZpiE9Qv4
         MwKA==
X-Forwarded-Encrypted: i=1; AJvYcCXQTU55qF7eUD/5jXnU3VCp0DblYEsod7jeacjxAJSfYNLMLMBofCrIs2I6utIBS0g8ZLQHs5c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4uzOBX2kRkaGsoGwWWOrdBJFze1WcrBD6x2oHYaBNYcxun0Xq
	KfavkyNRmytWY1fZKRlsxrj7AqtqSh6U64MKUyifkSriYYwfHMNAwlqnyhQtT1Nzg18=
X-Gm-Gg: AY/fxX5oxIj36ZfgPA+r095RXv6v6TpWmOA2tcx/dqloOfeZtYQdIsJXKZMhIzsMz0o
	+rA6V8smQVwuER5Sij7W4lgh5rrMoJQD4A/2LsN2yQW/W0+BaliOl4p98H0MmdvRrqpSYt29BPP
	35bJEYI7syWLntR1KG+BRcgVF4q1+QPpgqFRyDTlN1RyUqrhx++9Eozrn0cAkWq3KwDmL5fUJBW
	jGQAiBEw79qXpIduRITx+2M7Azg9wYOIeMxCSlxolB7d/j04hXi+lHj2WoesoUOW1KP7fCCm3lp
	ryDsB+BT63l8K/mPGqaJ+lA9+WBpc26lsWB12fBH7F8IvfVZ7TVrf7NJepS9K5aiUXc4zmufiJA
	tp8gh+sXR4Lgcw1IFUwL/k+uIZ2KorJwxj7Vvigx8Rbl3UXLvE9MFjqtGeDjfx487oddD3QkRJs
	vUf9zdVOCiJoTZ6i6YrOFFo/8xDdA=
X-Google-Smtp-Source: AGHT+IF1243bsR1sj1tOohhcakyreH+9yDAk0KDlPj4gIaskVx0VBFGg2bqs4J3/QsdBFniI06qELw==
X-Received: by 2002:a05:600c:37c8:b0:479:3a87:2092 with SMTP id 5b1f17b1804b1-47d84b3db2cmr221506705e9.36.1768313921585;
        Tue, 13 Jan 2026 06:18:41 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ed98abad1sm41492035e9.10.2026.01.13.06.18.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 06:18:41 -0800 (PST)
Message-ID: <324a1e90-6d85-4f6b-b81f-f6ccd2e64042@linaro.org>
Date: Tue, 13 Jan 2026 14:18:40 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 29/35] KVM: arm64: Pin the SPE buffer in the host
 and map it at stage 2
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: mark.rutland@arm.com, james.morse@arm.com, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 Leo Yan <leo.yan@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-30-alexandru.elisei@arm.com>
 <38443801-af4e-4ce1-a1c2-603eca8d90da@linaro.org> <aWTiqNfMPQzGBmHk@raptor>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <aWTiqNfMPQzGBmHk@raptor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/01/2026 12:01 pm, Alexandru Elisei wrote:
> Hi James,
> 
> On Fri, Jan 09, 2026 at 04:29:33PM +0000, James Clark wrote:
>>
>>
>> On 14/11/2025 4:07 pm, Alexandru Elisei wrote:
>>> If the SPU encounters a translation fault when it attempts to write a
>>> profiling record to memory, it stops profiling and asserts the PMBIRQ
>>> interrupt.  Interrupts are not delivered instantaneously to the CPU, and
>>> this creates a profiling blackout window where the profiled CPU executes
>>> instructions, but no samples are collected.
>>>
>>> This is not desirable, and the SPE driver avoids it by keeping the buffer
>>> mapped for the entire the profiling session.
>>>
>>> KVM maps memory at stage 2 when the guest accesses it, following a fault on
>>> a missing stage 2 translation, which means that the problem is present in a
>>> SPE enabled virtual machine. Worse yet, the blackout windows are
>>> unpredictable: the guest profiling the same process can during one
>>> profiling session, not trigger any stage 2 faults (the entire buffer memory
>>> is already mapped at stage 2), but worst case scenario, during another
>>> profiling session, trigger stage 2 faults for every record it attempts to
>>> write (if KVM keeps removing the buffer pages from stage 2), or something
>>> in between - some records trigger a stage 2 fault, some don't.
>>>
>>> The solution is for KVM to follow what the SPE driver does: keep the buffer
>>> mapped at stage 2 while ProfilingBufferEnabled() is true. To accomplish
>>
>> Hi Alex,
>>
>> The problem is that the driver enables and disables the buffer every time
>> the target process is switched out unless you explicitly ask for per-CPU
>> mode. Is there some kind of heuristic you can add to prevent pinning and
>> unpinning unless something actually changes?
>>
>> Otherwise it's basically unusable with normal perf commands and larger
>> buffer sizes. Take these basic examples were I've added a filter so no SPE
>> data is even recorded:
>>
>>   $ perf record -e arm_spe/min_latency=1000,event_filter=10/ -m,256M --\
>>       true
>>
>> On a kernel with lockep and kmemleak etc this takes 20s to complete. On a
>> normal kernel build it still takes 4s.
>>
>> Much worse is anything more complicated than just 'true' which will have
>> more context switching:
>>
>> $ perf record -e arm_spe/min_latency=1000,event_filter=10/ -m,256M --\
>>      perf stat true
>>
>> This takes 3 minutes or 50 seconds to complete (with and without kernel
>> debugging features respectively)
>>
>> For comparison, running these on the host all take less than half a second.
>> I measured each pin/unpin taking about 0.2s and the basic 'true' example
>> resulting in 100 context switches which adds up to the 20s.
>>
>> Another interesting stat is that the second example says 'true' ends up
>> running at an average clock speed of 4Mhz:
>>
>>            12683357      cycles   #    0.004 GHz
>>
>> You also get warnings like this
>>
>>   rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
>>   rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-0): P53/1:b..l
>>   rcu: 	(detected by 0, t=6503 jiffies, g=8461, q=43 ncpus=1)
>>   task:perf            state:R  running task     stack:0     pid:53 tgid:53
>> ppid:52     task_flags:0x400000 flags:0x00000008
>>   Call trace:
>>    __switch_to+0x1b8/0x2d8 (T)
>>    __schedule+0x8b4/0x1050
>>    preempt_schedule_common+0x2c/0xb8
>>    preempt_schedule+0x30/0x38
>>    _raw_spin_unlock+0x60/0x70
>>    finish_fault+0x330/0x408
>>    do_pte_missing+0x7d4/0x1188
>>    handle_mm_fault+0x244/0x568
>>    do_page_fault+0x21c/0x548
>>    do_translation_fault+0x44/0x68
>>    do_mem_abort+0x4c/0x100
>>    el0_da+0x58/0x200
>>    el0t_64_sync_handler+0xc0/0x130
>>    el0t_64_sync+0x198/0x1a0
> 
> This is awful, I was able to reproduce it.
> 
>>
>> If we can't add a heuristic to keep the buffer pinned, it almost seems like
>> the random blackouts would be preferable to pinning being so slow.
> 
> I guess I could make it so the memory is kept pinned when the buffer is
> disabled. And then unpin that memory only when the guest enables a buffer that
> doesn't intersect with it. And also have a timer to unpin memory so it doesn't
> stay pinned forever, together with some sort of memory aging mechanism. This is
> getting to be very complex.
> 
> And all of this still requires walking the guest's stage 1
> each time the buffer is enabled, because even though the VAs might be the same,
> the VA->IPA mappings might have changed.
> 
> I'll try to prototype something, see if I can get an improvement.
> 
> Question: if having a large buffer is an issue, couldn't the VMM just restrict
> the buffer size? Or having a large buffer size is that important?

You could restrict the buffer size, but then you'd also be restricting 
users on the same system who are happy to only use per-cpu mode but want 
larger buffers.

I looked for any examples online that don't use the default buffer size 
and didn't come up with anything. Linaro Forge and Arm Streamline also 
support SPE but they seem to be using either the value from 
perf_event_mlock_kb or some small default, so they probably aren't 
problematic.

One real use case for large buffers is snapshot mode. Say you are 
interested in a single event, and you want the execution history prior 
to that event. The buffer wraps and overwrites continuously until you 
take the snapshot, at which point the execution history is only limited 
to how big the buffer was. I don't think 256MB or larger is 
unreasonable, but it really depends on the user and the specific 
workload or problem they're working on.

If the only real usecase of SPE was with 4MB buffers then it probably 
wouldn't have been designed the way it was in the first place.

Even with the default 4M it's still very slow. It adds about 1ms to the 
context switch which has a big knock on effect:

Host:

$ perf record -e arm_spe/min_latency=1000,event_filter=10/ -m,4M -- \
   perf stat true

   Performance counter stats for 'true':

        0      context-switches   #      0.0 cs/sec  cs_per_second
        0      cpu-migrations     #      0.0 migrations/sec
       40      page-faults        # 126103.4 faults/sec
     0.32 msec task-clock         #      0.3 CPUs  CPUs_utilized
     6441      branch-misses      #      4.0 %  branch_miss_rate
   162317      branches           #    511.7 M/sec  branch_frequency
   788795      cpu-cycles         #      2.5 GHz  cycles_frequency
   835001      instructions       #      1.1 instructions  insn_per_cycle

   0.000783226 seconds time elapsed

   0.000921000 seconds user
   0.000000000 seconds sys

Guest:

$ perf record -e arm_spe/min_latency=1000,event_filter=10/ -m,4M -- \
   perf stat true

   Performance counter stats for 'true':

   54193400      task-clock               #    0.517 CPUs utilized
         71      context-switches         #    1.310 K/sec
          0      cpu-migrations           #    0.000 /sec
         42      page-faults              #  775.002 /sec
    2652453      instructions             #    0.72  insn per cycle
    3659952      cycles                   #    0.068 GHz
    1860786      stalled-cycles-frontend  #   50.84% frontend cycles idle
     783207      stalled-cycles-backend   #   21.40% backend cycles idle
     518600      branches                 #    9.569 M/sec
      26703      branch-misses            #    5.15% of all branches

   0.104725080 seconds time elapsed

   0.000000000 seconds user
   0.089999000 seconds sys

Guest, but without SPE (just 'perf record' instead'):

$ perf record -- perf stat true

  Performance counter stats for 'true':

     7311680      task-clock              #    0.534 CPUs utilized
        70      context-switches        #    9.574 K/sec
         0      cpu-migrations          #    0.000 /sec
        41      page-faults             #    5.607 K/sec
   2102657      instructions            #    0.88  insn per cycle

   2398273      cycles                  #    0.328 GHz
   1032732      stalled-cycles-frontend #   43.06% frontend cycles idle
    589058      stalled-cycles-backend  #   24.56% backend cycles idle
    411830      branches                #   56.325 M/sec
     17839      branch-misses           #    4.33% of all branches

   0.013694400 seconds time elapsed

   0.000000000 seconds user
   0.008881000 seconds sys


So, 0.0008s -> 0.01367s -> 0.10472s elapsed time from fastest to slowest
or 2.5 GHz -> 0.328 GHz -> 0.068 GHz

Probably worth doing some real benchmarking that's not just 'true' 
though. And trying to understand what scenarios are fair to compare with 
each other. Either way I think SPE is supposed to be lower overhead than 
that.

> 
> Thanks,
> Alex

