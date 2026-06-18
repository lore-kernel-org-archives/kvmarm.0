Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2FF1DDC1B
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 23:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781825554; cv=none; b=bOYTz8pCkZzVhlO3iq2jE+4TG6znqry3IbtLKmr4Q49OPqtgeFWEsDlDRxXf7ZyeRlmBwNoCztS6B3AZbJgM14IIuru36PqA7wZlhv7DFHP9mztEgCPoNij4zDkmwP1tUMZumbS0nZ9BdsEboWl9mam2b1oOtRhpqXhTw362yYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781825554; c=relaxed/simple;
	bh=aOBaHP4DOk4vq3tW3rv9yXUlZFd1+xiTupwDlFmXHKA=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=dxQ7KNgE7g2hlDLeN/f8D95zOJD6HFvKIUbYbURRsyChYUNU1ODi2uwNtGwB1vZ1s53zDqsRqqJYpW+zB6BNQENDJDka4Yw3aQHuA/hj3RqSiMzFwHxntBKsbjETSHyBDg45wkuB9IYW/Olc4WkKNKIb1RogeNdoW2iBw52ZSY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o58m1xx0; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o58m1xx0"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-486e64c8edeso2083954b6e.2
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 16:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781825552; x=1782430352; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cwWYCnxdR0CMlBSotsz1RrmN4O2SDrdrRioZC+xeVso=;
        b=o58m1xx0eXAmtvgA1o/eQemMhY72WT1RyHtC/qLOjq/5r2aO7tCHfBSJ9EYvrOnoSm
         WyyV95za+23JgOGhpSFwTaM1tJlx29MYXpJrbTL0cI+CoWd95LweP7IwJJt6Df8lGxho
         ZyKcNzUx7wvp0zXRyegErOmYa3t+6iTmce61Q/AcKOodfYX+za2HR/R1cZ1X6yfW1Qwq
         JmJv2ahjxSeEaiJqkr1+30gLDGTj5XF+i7eOTeeCujaGB+sXM/RCLveQXqnIGFZjt5k+
         I1+8/Lftq3QULvdmpXKgAEAKFIgpr50FGksmp8cUHCJVtXX4bTuAoA0nuo9uPQFiGIjC
         Ljcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781825552; x=1782430352;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cwWYCnxdR0CMlBSotsz1RrmN4O2SDrdrRioZC+xeVso=;
        b=q48yc01ZoyZzG0K2Zj6Ahhi3erwKLV9Mamc3In0IrPGxZOG5eiUbisqhh7eCOZwuoy
         eK5SfI2az6P1bNdL9XneNtdJ/0KH7V2Vjcfb1OML2br6EI6B2Gw5o6sfLTRVNgAMf8Pc
         yfY5qZUu8u4ZaqaVdnM81cUsvRZgEX4LEeXAt+HeKQG6+h9MBVvBifk4Dz2QJO/9lbEU
         3U7TussFMfqhLq0skOdBXbyJs+qpscneFpqlc8cSuGjEXmKJDJWZYvG2yl9s+umnjkE/
         bbpBLWyN3QfKva63gcgwAJKbEXJiabWwZGdufHzmlNzOLaXSsgjAU+FgKZjEq9rNYNHT
         IyOQ==
X-Forwarded-Encrypted: i=1; AFNElJ8zKjGhC/SvcPPuXR81Nzgok8bhzMEShFUScguS+aoVsEK37fwEqlZ2Yk69jl79q1CQjCFchY0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxtAyjI8yhtztYUsmPmrRhTBzBHCUsCJNQqEhdIQafb1OCMj5P/
	y4CXmC961lc9weLGzVRuVmRV+dLrGWAHb8unvOVRDPuS3tGbYfgGVfZsGYTLvRccYq7dwAgb6Z2
	lJRyJU/GjprwZcTmmfykDS87PpQ==
X-Received: from ilbdv1-n1.prod.google.com ([2002:a05:6e02:4001:10b0:502:e73:d02b])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1808:b0:46c:e542:cc25 with SMTP id 5614622812f47-489aeaa5634mr180520b6e.9.1781825551504;
 Thu, 18 Jun 2026 16:32:31 -0700 (PDT)
Date: Thu, 18 Jun 2026 23:32:30 +0000
In-Reply-To: <6dca2d6e-54d0-42c4-95df-45a30a473e0b@huawei.com> (message from
 wuyifan on Thu, 18 Jun 2026 09:53:15 +0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntse6jctm9.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v7 15/20] perf: arm_pmuv3: Handle IRQs for Partitioned PMU
 guest counters
From: Colton Lewis <coltonlewis@google.com>
To: wuyifan <wuyifan50@huawei.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	james.clark@linaro.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, wangyushan12@huawei.com, 
	wangzhou1@hisilicon.com, xuwei5@huawei.com, prime.zeng@hisilicon.com, 
	fanghao11@huawei.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

wuyifan <wuyifan50@huawei.com> writes:

> Hi Colton,

> On 5/5/2026 5:18 AM, Colton Lewis wrote:
>>    static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
>>    {
>> -	u64 pmovsr;
>>    	struct perf_sample_data data;
>>    	struct pmu_hw_events *cpuc = this_cpu_ptr(cpu_pmu->hw_events);
>>    	struct pt_regs *regs;
>> +	u64 host_set = kvm_pmu_host_counter_mask(cpu_pmu);
>> +	u64 pmovsr;
> kvm_pmu_host_counter_mask() is called from armv8pmu_handle_irq(). This
> interrupt fires in both host and guest contexts.

> However, kvm_pmu_host_counter_mask() dereferences
> host_data_ptr(nr_event_counters). This indirection requires
> kvm_arm_hyp_percpu_base[cpu] to be initialized, which only happens during
> KVM hypervisor setup. When the interrupt fires in a guest kernel where
> KVM is
> compiled but not active, the per-CPU base is NULL and the dereference
> faults.

I will fix that.


> Thanks,
> Yifan
