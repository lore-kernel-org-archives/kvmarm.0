Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D25255E43
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767976177; cv=none; b=Qv+U53EhTRcWUNy/y0/u7nQNkOn95uD82hVpALaLvCJIm59YpDGuXN43iGHmkJsSPH9ETzfWUKeVAA2Hmcsxbd0YZzBuNNwhEUC/hFafB3v05L1LmoPROjQMmP/AnvoTdrDXECR0+NB0cXV+Um+o8ptk89rw/8FruktSyWTd6ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767976177; c=relaxed/simple;
	bh=bWACLZCekTaSogrljOMoW53UvcGLcQvttUrYQ10xHgs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K3BbAS71g3KPng6f/5RvbHTPcTWb1ugya7iWloWFQ724tT4dOpKejmDhQYv2D8/FvQn4Sso2dmrgFpBGtU9hdaQv6Y75UM3o2gTwGKqUKR445RJHkQIuvyitlnE/7Q1fBYy35an97RRIkM/1hyxZs/tBJoZFFGTsax7D/EhpTd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jwxjAvyi; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jwxjAvyi"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4779ce2a624so36927975e9.2
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 08:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767976175; x=1768580975; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E87lHJdowwtu3YidaoeJSfoS6xk/5FNJEHNpvmHqK4w=;
        b=jwxjAvyiCY4UpYtZV4bltghq4kQ8eFelhseQeTDxy+yGoV0NibMNjStxKS6zzbwLO3
         vo0DBQ8RfMtx+t1GuQhuWM7rNrAhI6YFlprmtgQSlkrIACYhzcjG75D6MYTmQtH3yFok
         udcs3Au9g09fPEeBDsScJpnPpbiEd9WCUreD2d2yT0lv2KJ68ZPNg9fvZPHYKzksYAvi
         yGHdw/BI2did5ZDOyEEhGG4h23kTLsSbZfsDYnxuzEZFUgq0sORpcjD6zEfYGTHo12Ny
         ktxgR9Tb+Lu0s5PUkVP24poOtEL6V18LWrxfr1y3isMnKC6dHVTSudbjqdqQXdraCIAs
         EgGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767976175; x=1768580975;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E87lHJdowwtu3YidaoeJSfoS6xk/5FNJEHNpvmHqK4w=;
        b=CJW05rFCexHdxfpexblmZd7Uc0waJwiSg7W3x4uXC1FN0vniSHEtU5QDVpmFzYP/00
         1cr+LAC72NF5eGnNeO07RFr3tg3gaxG0o4JLwB2HOoepCsKtyKRk89wP+Tdc0XCJzykU
         Gi41F4itbIHmi3/Zk+ktqvKL6VFtQ0zMniOITmdJS8SyoqeUbnhrV0GHPENMd0SxHD/b
         fl/xx+Eqv4fAJIaH8BxAneGQcmzP0GYQpNzhKCfKsoXCr0HbTy1nHk1W6RfgkQP/o/zc
         8gxtCN7QH2u1oU8iK4VAAeNbbDLh6CLVpIe+HGLfINwTebpXs+RW69img39dTp23OUSt
         AyPg==
X-Forwarded-Encrypted: i=1; AJvYcCWGlcn2YrDksxP+KbG2JXFT71xoe3xojtugUMkJRmCvsDXm6UgAhtsQQPZQSA6Eon7AYDfFygQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yybhgm0FuS6cdTGCKP8G+eAeTbMXz08qccOesgRyYYhJcg9F+cP
	BEXq7tiVted16+KY589tfdhU5OFlmJb5Mk+CO8bM75ww19z+1Q9FLI1XIo58/+/lI5E=
X-Gm-Gg: AY/fxX7So89udCn44NhHyMcOMZUP30ivr1np6WW5h/r1i8THDKbY4pJ+AU4fUAaDeQP
	mJKdJ0aHQgVeKiwse5ae8wG353I8HR4pHJU6r+4JhWMzRxVFXU9XmDf1RO66uBH8GlZFSbDWSnb
	NIC2WrNcKQHx1ChbDslBpUk8hBPbQc0kVZaSv1buYDHxdUXglffpXAOkCoqZURXmZkwO2Z9EJAe
	l4J40eK3ew4ZECsgF+vH9GhXRcvEn6I+eTr9HInoKiwplndTW0QADj9ZHHmWJVOGBegjEHY8Zio
	DGOzC60ba0oLgDVXa8V3+klFfoercGQsoCWmU9DIx5wajtH1lo0dG2iEzlHTxiab/G3xMFpDo4L
	XxlvytwfLuKFN4dtP7NJzD756uNZRJC9ZnCJsoUJyAYgCtmRjutvcC7BBdKp+zwUK0DDnoi5y/C
	ae7n6K1LGyzAFehAu5
X-Google-Smtp-Source: AGHT+IGmzL1tXZl8ZPSvbm1DNjtYU9LFptg5q1JatUZDvK/eZmYzIHWMM1cUqtN42COJOMK1PRCMUg==
X-Received: by 2002:a05:600c:4e49:b0:477:a36f:1a57 with SMTP id 5b1f17b1804b1-47d84b1897fmr112990735e9.3.1767976174573;
        Fri, 09 Jan 2026 08:29:34 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f703a8csm213675025e9.13.2026.01.09.08.29.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 08:29:34 -0800 (PST)
Message-ID: <38443801-af4e-4ce1-a1c2-603eca8d90da@linaro.org>
Date: Fri, 9 Jan 2026 16:29:33 +0000
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
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-30-alexandru.elisei@arm.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20251114160717.163230-30-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 14/11/2025 4:07 pm, Alexandru Elisei wrote:
> If the SPU encounters a translation fault when it attempts to write a
> profiling record to memory, it stops profiling and asserts the PMBIRQ
> interrupt.  Interrupts are not delivered instantaneously to the CPU, and
> this creates a profiling blackout window where the profiled CPU executes
> instructions, but no samples are collected.
> 
> This is not desirable, and the SPE driver avoids it by keeping the buffer
> mapped for the entire the profiling session.
> 
> KVM maps memory at stage 2 when the guest accesses it, following a fault on
> a missing stage 2 translation, which means that the problem is present in a
> SPE enabled virtual machine. Worse yet, the blackout windows are
> unpredictable: the guest profiling the same process can during one
> profiling session, not trigger any stage 2 faults (the entire buffer memory
> is already mapped at stage 2), but worst case scenario, during another
> profiling session, trigger stage 2 faults for every record it attempts to
> write (if KVM keeps removing the buffer pages from stage 2), or something
> in between - some records trigger a stage 2 fault, some don't.
> 
> The solution is for KVM to follow what the SPE driver does: keep the buffer
> mapped at stage 2 while ProfilingBufferEnabled() is true. To accomplish

Hi Alex,

The problem is that the driver enables and disables the buffer every 
time the target process is switched out unless you explicitly ask for 
per-CPU mode. Is there some kind of heuristic you can add to prevent 
pinning and unpinning unless something actually changes?

Otherwise it's basically unusable with normal perf commands and larger 
buffer sizes. Take these basic examples were I've added a filter so no 
SPE data is even recorded:

  $ perf record -e arm_spe/min_latency=1000,event_filter=10/ -m,256M --\
      true

On a kernel with lockep and kmemleak etc this takes 20s to complete. On 
a normal kernel build it still takes 4s.

Much worse is anything more complicated than just 'true' which will have 
more context switching:

$ perf record -e arm_spe/min_latency=1000,event_filter=10/ -m,256M --\
     perf stat true

This takes 3 minutes or 50 seconds to complete (with and without kernel 
debugging features respectively)

For comparison, running these on the host all take less than half a 
second. I measured each pin/unpin taking about 0.2s and the basic 'true' 
example resulting in 100 context switches which adds up to the 20s.

Another interesting stat is that the second example says 'true' ends up 
running at an average clock speed of 4Mhz:

           12683357      cycles   #    0.004 GHz

You also get warnings like this

  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-0): P53/1:b..l
  rcu: 	(detected by 0, t=6503 jiffies, g=8461, q=43 ncpus=1)
  task:perf            state:R  running task     stack:0     pid:53 
tgid:53    ppid:52     task_flags:0x400000 flags:0x00000008
  Call trace:
   __switch_to+0x1b8/0x2d8 (T)
   __schedule+0x8b4/0x1050
   preempt_schedule_common+0x2c/0xb8
   preempt_schedule+0x30/0x38
   _raw_spin_unlock+0x60/0x70
   finish_fault+0x330/0x408
   do_pte_missing+0x7d4/0x1188
   handle_mm_fault+0x244/0x568
   do_page_fault+0x21c/0x548
   do_translation_fault+0x44/0x68
   do_mem_abort+0x4c/0x100
   el0_da+0x58/0x200
   el0t_64_sync_handler+0xc0/0x130
   el0t_64_sync+0x198/0x1a0

If we can't add a heuristic to keep the buffer pinned, it almost seems 
like the random blackouts would be preferable to pinning being so slow.

