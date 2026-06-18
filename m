Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A08934EEE3
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 23:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781825413; cv=none; b=NEBW3iC13erM4a9OTE4HmWS3Aw+aVmxHffeG9rNxKMr1fWYOZJ3HqqNdsWqAyZbfVNc43ND363VIIvPzygE9OfDUXAUDl78RVcsM+ZtTmq42vvvZ8UL9ty68j+LC+RuyW9L7s2D1VjwRetnNy+AIxv0Um1lWWUoRWBGjWIOyvq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781825413; c=relaxed/simple;
	bh=oixVs33DJaRW/AnnIc47KyBAENZW8NUyFFX8YWS2PJU=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=RAx0pPWhl20FkblJ9mAG1hSdFcrAF7jtjG67fJHQTxhI83ANRNt+kXWAhR40ywerKnwgI674A0jNvYVtJLTq4RDR/T2VjvxlF9sqn4hAKFvLD5Z6+NcWay90svePqpbvvkBoYcgS7rBftt9qPZX9qGF9vuRSH5tY+8fbb1upOPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qu8fUkmY; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qu8fUkmY"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-485ebc5706cso5875588b6e.0
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 16:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781825411; x=1782430211; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4p6UmVH4InlQHDX0xOai2hxHDLRoZeq2zsnVbO1aygg=;
        b=Qu8fUkmYg7VJGtpC28lWBCNs4JozVBZ7CBsEbx6ntYXP3jA7oFxLJdNxJ+DNRdzhR4
         EZ+pV+3TdAZHeG+7E2gpqZADMO3W6fKWhLLA2aqbpSiM5IZ3dWw1AAEgihN5XClVaJIn
         0HhNAlaUin7LEPITgQLwVDQLXbzXNPYvJOz15y9hC9JuBBsq0kl4s6VgRxlxx8Pi8UVp
         MZJ4eMxen25rA8rebqVO0PykZY2JbgsEZoIz4zCQoQc54bmRxXgNx1xw2YArhN/Vfjyq
         juiWaC5SWgBtEwxRmTwvaP9xI+Ry4gWMBit4x6ss+MUOsLG0qSlWd28KzIAYD9ncU+Pl
         gtfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781825411; x=1782430211;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4p6UmVH4InlQHDX0xOai2hxHDLRoZeq2zsnVbO1aygg=;
        b=Fl80jq1051vTZBucHmWCmTtBDjiFBwktwPfgaHWpTBYMl0o5uVGy3qwbLfxFGFVvlD
         0SZ2cMPvBKaemhn1kNIpI3cldVTiXfMyOoSUuaMVQD2rlqb7kb29LnRkHTeLxXH36q1u
         35iu90QfCPKXAq8GWPwDyTYZEVJrth8RvDtKZv0HdZrZV3m27n/8yhCDrf3rHkdzX2vz
         +PaOI1OmZHxesvQrDXFhf3xXTFMXt5wRdNr4AotBUFtE4k/hF3xFxZTExqgKplKXtkQ1
         ZaB+rTD5c0GWZW7ETVy16mSWSVIqkUrxGOiUHVGUdCebzkw9OOI12GZ711bSXvcxGDOw
         /Jsg==
X-Forwarded-Encrypted: i=1; AFNElJ+QOV79ImXiskHDgPmrH+ldgXXid8Q1SJyfuRSegBIekcHOpEjewUHvOptgdeIzofW+FI1PiAc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVnH5zB0VzbgnIbffB7gSJnG5Kz/k4AzoiDYQzPFovxLquJ+nP
	3ikpKMJH2qgjiohXXHJeWK6pJ6fIhRg9764Niomp9uDBarMqgLWK3z1/5wZVUS7McW/inbzYNNQ
	WpssnlMmnIjpsRSQZ9Aw5t+r9lQ==
X-Received: from jabjq11.prod.google.com ([2002:a05:6638:8d8b:b0:5e2:40af:256a])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:2444:b0:467:d71:7f1a with SMTP id 5614622812f47-4896c8a3f7cmr734469b6e.21.1781825411153;
 Thu, 18 Jun 2026 16:30:11 -0700 (PDT)
Date: Thu, 18 Jun 2026 23:30:10 +0000
In-Reply-To: <df30b9e0-6938-47f5-bb5d-5b1e67c8879c@huawei.com> (message from
 wuyifan on Tue, 16 Jun 2026 17:07:48 +0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntv7bfctq5.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v7 11/20] KVM: arm64: Enforce PMU event filter at vcpu_load()
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
	fanghao11@huawei.com, wangzhou1@hisilicon.com, prime.zeng@hisilicon.com, 
	xuwei5@huawei.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes


Hi Yifan, thanks for the review.

wuyifan <wuyifan50@huawei.com> writes:

> Hi Colton,

> On 5/5/2026 5:18 AM, Colton Lewis wrote:
>> +	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
>> +		if (i == ARMV8_PMU_CYCLE_IDX) {
>> +			val = __vcpu_sys_reg(vcpu, PMCCFILTR_EL0);
>> +			evsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
>> +		} else {
>> +			val = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
>> +			evsel = val & kvm_pmu_event_mask(vcpu->kvm);
>> +		}
>> +
>> +		guest_include_el2 = (val & ARMV8_PMU_INCLUDE_EL2);
>> +		val &= ~evtyper_clr;
>> +
>> +		if (unlikely(is_hyp_ctxt(vcpu)) && guest_include_el2)
>> +			val &= ~ARMV8_PMU_EXCLUDE_EL1;
>> +
>> +		if (vcpu->kvm->arch.pmu_filter &&
>> +		    !test_bit(evsel, vcpu->kvm->arch.pmu_filter))
>> +			val |= evtyper_set;
>> +
>> +		if (i == ARMV8_PMU_CYCLE_IDX) {
>> +			write_sysreg(val, pmccntr_el0);
> This should be pmccfiltr_el0.
> Writing the filter bits to pmccntr_el0 would corrupt the cycle count  
> value.

Yes it should. I found that and thought I corrected it before I sent out
the series. Thanks for catching it.

>> +		} else {
>> +			write_sysreg(i, pmselr_el0);
>> +			write_sysreg(val, pmxevtyper_el0);
>> +		}
>> +	}
>> +}
> Thanks,
> Yifan
