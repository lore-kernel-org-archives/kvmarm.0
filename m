Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5DB215787
	for <kvmarm@lists.linux.dev>; Wed,  4 Jun 2025 20:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749067928; cv=none; b=tn1P683HfbB8sqaFJ9YaekJTcQcjs16Gt4G3/SBLCO0No4UTAnqHJsRFmKVVTl39g6Fr6MH13PIXLfApOeefiUE3oFHQMKzxiittJNGcNsku0MCDexOWy+niglFE1FsC8tOygcWqf7rUjwL7ipE9mXOlMOW2EucIfuP7XBzMdwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749067928; c=relaxed/simple;
	bh=Yf/iHPu8H60AsxB9qOlBzBCZlW0/bPjuVXhfXOJSwAA=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=I3WkncHn/RWpP8IJtECvs8Oh+jCS42VqVk9O7c7M+mfMfKZT9gHxbgGizYQ3MzZln/SsQmJUf7y8EWW7q1dSIHNF7QPUJVnNFK1NNdmM8yCqtbdr95ueXmqj3r1zocKLfb6MxFEZPksjyVQZ522RDnV0cQG4VKycL6VK7tIXsu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VogwEdpk; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VogwEdpk"
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-2e8809bb584so322978fac.0
        for <kvmarm@lists.linux.dev>; Wed, 04 Jun 2025 13:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749067926; x=1749672726; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l2ZfRBtkCFUyGNfWWgvViMBCRTnEKTD5lF2sn5A9h8E=;
        b=VogwEdpkfKvDr1LHQ8o0l825JHUyMD1EIXFJGcpZZmlGBhrZjq1JgRyL3kwKPR71Cz
         I2mCS4syrcBAclQg/f8lH3DjKruz9l80mizX0+7SoCirjk9ix0ZugKOMV4v8tu8AopSR
         6ITfsFY8zkhnaDAXqUVzyly3kiVaaaFjqDoMujulznlnxAs+9JcP0Io1iWrBmpAtfw9C
         LpQh1eD6Qbq/0jwoOH4m9nrL2zT/HAv1Sj/FcvPB3Kqh+P1b6wnLI2ChVyWI+Li2WZfj
         kq3Cw7W6S2B+q1W/pzOlriSfZynfl0+VIUKFuMY4cugUDB26FXRkBS11cbw7v3clDZZA
         +UQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749067926; x=1749672726;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l2ZfRBtkCFUyGNfWWgvViMBCRTnEKTD5lF2sn5A9h8E=;
        b=p6xHZZ/nLmCscN3rYeUhpkrXdhz9Bk9XkBzdkGW1l3uMcgyAC444V73YIAmP19gEvs
         6eR9uhsX2PLZl4Yp3zW7s/7rrxwDJ3Hl+gAKcpAH5QwvRt6sIWWNEaTVt7N/kEZ0h0Kz
         XO91xHRDcTmKtz8HWjVxLQ+jgfp8xymFMs1ln/BuDRciJH7yoBDxc3KbSLMpH90ZbWsZ
         DmjeEXXCtOUq/RNkb1bkqfy90Xl/FZcqyvbSsKpjdSdc9t2GnS9YMsJO9vbaO9mtHwtv
         4dVWNtJ2+oDEfRePuGhse7rNBSrfcIlyLhkgP1fmB23HMQk60xouEe4MoHKuxFD8dkoB
         bpRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWbrJhKIn/Rkoywx3sXO5MHoWJyBgmHi73hwBatSmd2kkUAK5KwD71eDf1lNtz4+YbPDjCuaY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUC3Mx+1VGr6MM6iL/8T8QzpqrlXmuoE1578q7E9WVZ4l8NjMu
	fFB9gE0/xA/faPJ+PlF1RUtViYXEBOnvK5wiXMZDgJg/ksGBfYIv7qIDCZx7VS2mjUQQgnB5xMJ
	KtWsmoKZV7hd7fKp8To3XbyDz5w==
X-Google-Smtp-Source: AGHT+IHnv4E1vDPP/ZiBUn0UZugjQZBj8858Crg/sw9WU1O9tNE8wE+e6qgJBHSzAxiHAj9ZIzvPLqoD1kotwzxLmg==
X-Received: from oabfz25.prod.google.com ([2002:a05:6870:ed99:b0:2e9:175e:cff3])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6871:e716:b0:2d4:e29d:5297 with SMTP id 586e51a60fabf-2e9bfbe153emr3220979fac.29.1749067926258;
 Wed, 04 Jun 2025 13:12:06 -0700 (PDT)
Date: Wed, 04 Jun 2025 20:12:05 +0000
In-Reply-To: <gsnt1ps033ch.fsf@coltonlewis-kvm.c.googlers.com> (message from
 Colton Lewis on Tue, 03 Jun 2025 21:46:54 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntplfj1d2i.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 16/17] KVM: arm64: Add ioctl to partition the PMU when supported
From: Colton Lewis <coltonlewis@google.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, mark.rutland@arm.com, shuah@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

> Oliver Upton <oliver.upton@linux.dev> writes:

>> On Mon, Jun 02, 2025 at 07:27:01PM +0000, Colton Lewis wrote:
>>> +	case KVM_ARM_PARTITION_PMU: {

>> This should be a vCPU attribute similar to the other PMUv3 controls we
>> already have. Ideally a single attribute where userspace tells us it
>> wants paritioning and specifies the PMU ID to use. None of this can be
>> changed after INIT'ing the PMU.

> Okay

>>> +		struct arm_pmu *pmu;
>>> +		u8 host_counters;
>>> +
>>> +		if (unlikely(!kvm_vcpu_initialized(vcpu)))
>>> +			return -ENOEXEC;
>>> +
>>> +		if (!kvm_pmu_partition_supported())
>>> +			return -EPERM;
>>> +
>>> +		if (copy_from_user(&host_counters, argp, sizeof(host_counters)))
>>> +			return -EFAULT;
>>> +
>>> +		pmu = vcpu->kvm->arch.arm_pmu;
>>> +		return kvm_pmu_partition(pmu, host_counters);

>> Yeah, we really can't be changing the counters available to the ARM PMU
>> driver at this point. What happens to host events already scheduled on
>> the CPU?

> Okay. I remember talking about this before.

>> Either the partition of host / KVM-owned counters needs to be computed
>> up front (prior to scheduling events) or KVM needs a way to direct perf
>> to reschedule events on the PMU based on the new operating constraints.

> Yes. I will think about it.

It would be cool to have perf reschedule events. I'm not positive how to
do that, but it looks not too hard. Can someone comment on the
correctness and feasibility here?

1. Scan perf events and call event_sched_out on all events using the
    counters KVM wants.
2. Do the PMU surgery to change the available counters.
3. Call ctx_resched to reschedule events with the available counters.

There is a second option to avoid a permanent partition up front. We
know which counters are in use through used_mask. We could check if the
partition would claim any counters in use and fail with an error if it
would.
