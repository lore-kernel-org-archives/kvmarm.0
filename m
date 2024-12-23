Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89E219AA5A
	for <kvmarm@lists.linux.dev>; Mon, 23 Dec 2024 11:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734953808; cv=none; b=raT6UbtnxrfPi3dUydrCQqzghmMa67Fp+aYJWqmrxMdTnMYDC7/EnvnWKiI4xQpSncIVigXMrT8uUAxvY/mUqmd7QEsidF+PzwjTwNPl+0k8T5GOe3oyISCusq/pgitg1q9AE4mTm/GyIkb/YYU1r8aF8C9g8A8C8Kl8+2FXpYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734953808; c=relaxed/simple;
	bh=P5x4oAHeG7HJEd/0t9TBmtHI+gPp2r6ifa994LIjj8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WVJfZ7zmflPMIuE0GnXGOI8zr4nKWp+KF4tuElXmh7YnLW8LAemO5WMe5eeGOC/8Tr4AmgKZ+IAIXhdPMt4DgOf7IG6lPoGhVZrWrUHaFjdwhcwvAI5SIVil6FAGuITiRT+XiQlEeUxVq96wnGKX/+D59zKZ0nwaS2nYiFSld6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qwXarii6; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qwXarii6"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4361a50e337so27858555e9.0
        for <kvmarm@lists.linux.dev>; Mon, 23 Dec 2024 03:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734953804; x=1735558604; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pfAEnN47k2yUPyXkehPRQB5Var7XNNy5tr8DW7zJULQ=;
        b=qwXarii6Rwt0Rd9cdPZRp6j6kMg+68g4ykYJlw8Xwi+TOlMDasQvTnjCg6XVSyeTWH
         qIOu32sT0Jo+gfoiMmYZau4bjsvTlH/tFkg4kD+ZOXaMBB4bejW041jAbDPbOMufJU+e
         HhFcQ2u3UDolAdgz1sQFTzgC6rRP49iMhCov4lo8sAaZJzisFq3lV1RWUHva/YxUO7mf
         rNA3w1B5U2+/wmbfGsY25LEYQMAc13JZrzbfdv24eflghMu47ocNbLVj6ffc+qPAPXmY
         23S2y2+x5Weo3El/0OrAX0bmXsQIRU3ARayTcAyKFLSLpoHgVbF5elqgr7J2qB+to3VV
         /CHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734953804; x=1735558604;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pfAEnN47k2yUPyXkehPRQB5Var7XNNy5tr8DW7zJULQ=;
        b=i9MJq5XR4/IFFza9ANciAI3IGtsZ6Zs9geupPlMnuEjxCjfz3FfRdgPKHae2hjo+BT
         DnW3msxnIOAzu+djIGOM2vZVqGFdOZwYHVjxaRseixq/q69Px8jJwN6+yK/wEvH7+gDy
         umCRkqIcnsuhdzFZDJo0QxZD92aAyDRR8beDLLUACconEfhY6Bl3RpsCja+rdIqEWgWq
         dMmFJA8lJCb28IAi6hQ0bLJTBA9Un5JhIjItwdE4MEtHlb8Hr7ySm/AmGb4C6Mh2sxG4
         WW9QEgHNn3gfD0xj3+rFyE8/gpRinF5u4EvhzYT+mSNv22OG/Pe3O1SFKmBtxTAV21uS
         uSQQ==
X-Gm-Message-State: AOJu0Yybms4UDEFHcfYuu6ok0cisZ4cfCFJSPsT+UpXSLDC8W4FSdCGu
	lo28+BqKUMlth7ToksnjBWE9tPvTa6mcgZF9sbGYJIPWfp+L+cEu7jTVsIrtRZ4=
X-Gm-Gg: ASbGncv2mlz6AXEL0pe8tPNJ2gk3SxmbT04C/Ek2rGwXcXh5f/m6BsOZfdUK5e7YLZ0
	5DD8V+D83b/a4tKCEUYgoOBXptuY2zKVsL/eNQiK6glNnjsc7I2enZFTezd90mvdusgLFHilGyw
	U3zHgpq07oN4o2I3S1dorvimZNv0CMzKTgsXNNUdFBmd9i4ffwWoKBOTngMghf0uCeGwVHfk0Ty
	hd21edB1JsjP/WgXUVxyrEPhYkaKFarKdm8A2GPcd8149onf5RHBzFYoU3caHUHdg==
X-Google-Smtp-Source: AGHT+IH1xux9sPKNWQ/qyA/QpYj6eYBI9DgnVKcK7PP07rrtLIZQhCaDtbBqQzfpAVwh4XJhK9q1vw==
X-Received: by 2002:a5d:5f4a:0:b0:385:f19f:5a8f with SMTP id ffacd0b85a97d-38a221f2d90mr10269118f8f.4.1734953803802;
        Mon, 23 Dec 2024 03:36:43 -0800 (PST)
Received: from [192.168.68.163] ([145.224.66.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8ace0esm10999383f8f.106.2024.12.23.03.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2024 03:36:43 -0800 (PST)
Message-ID: <b1cc3ea5-e1d4-494e-9110-dd7b6d5e95e7@linaro.org>
Date: Mon, 23 Dec 2024 11:36:41 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 6/8] KVM: arm64: coresight: Give TRBE enabled state to
 KVM
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 coresight@lists.linaro.org, Joey Gouly <joey.gouly@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mike Leach <mike.leach@linaro.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 "Rob Herring (Arm)" <robh@kernel.org>, Shiqi Liu <shiqiliu@hust.edu.cn>,
 Fuad Tabba <tabba@google.com>, James Morse <james.morse@arm.com>,
 Raghavendra Rao Ananta <rananta@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20241127100130.1162639-1-james.clark@linaro.org>
 <20241127100130.1162639-7-james.clark@linaro.org>
 <86ttayp9n9.wl-maz@kernel.org>
 <e6b46080-b9ae-4aad-b06d-81407c195e28@linaro.org>
 <86seqhp7yg.wl-maz@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <86seqhp7yg.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 21/12/2024 11:54 am, Marc Zyngier wrote:
> On Fri, 20 Dec 2024 17:32:17 +0000,
> James Clark <james.clark@linaro.org> wrote:
>>
>>
>>
>> On 20/12/2024 5:05 pm, Marc Zyngier wrote:
>>> On Wed, 27 Nov 2024 10:01:23 +0000,
>>> James Clark <james.clark@linaro.org> wrote:
>>>>
>>>> Currently in nVHE, KVM has to check if TRBE is enabled on every guest
>>>> switch even if it was never used. Because it's a debug feature and is
>>>> more likely to not be used than used, give KVM the TRBE buffer status to
>>>> allow a much simpler and faster do-nothing path in the hyp.
>>>>
>>>> This is always called with preemption disabled except for probe/hotplug
>>>> which gets wrapped with preempt_disable().
>>>>
>>>> Protected mode disables trace regardless of TRBE (because
>>>> guest_trfcr_el1 is always 0), which was not previously done. HAS_TRBE
>>>> becomes redundant, but HAS_TRF is now required for this.
>>>>
>>>> Signed-off-by: James Clark <james.clark@linaro.org>
>>>> ---
>>>>    arch/arm64/include/asm/kvm_host.h            | 10 +++-
>>>>    arch/arm64/kvm/debug.c                       | 25 ++++++++--
>>>>    arch/arm64/kvm/hyp/nvhe/debug-sr.c           | 51 +++++++++++---------
>>>>    drivers/hwtracing/coresight/coresight-trbe.c |  5 ++
>>>>    4 files changed, 65 insertions(+), 26 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>> index 7e3478386351..ba251caa593b 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -611,7 +611,8 @@ struct cpu_sve_state {
>>>>     */
>>>>    struct kvm_host_data {
>>>>    #define KVM_HOST_DATA_FLAG_HAS_SPE	0
>>>> -#define KVM_HOST_DATA_FLAG_HAS_TRBE	1
>>>> +#define KVM_HOST_DATA_FLAG_HAS_TRF	1
>>>> +#define KVM_HOST_DATA_FLAG_TRBE_ENABLED	2
>>>>    	unsigned long flags;
>>>>      	struct kvm_cpu_context host_ctxt;
>>>> @@ -657,6 +658,9 @@ struct kvm_host_data {
>>>>    		u64 mdcr_el2;
>>>>    	} host_debug_state;
>>>>    +	/* Guest trace filter value */
>>>> +	u64 guest_trfcr_el1;
>>>
>>> Guest value? Or host state while running the guest? If the former,
>>> then this has nothing to do here. If the latter, this should be
>>> spelled out (trfcr_in_guest?), and the comment amended.
>>>
>>>> +
>>>>    	/* Number of programmable event counters (PMCR_EL0.N) for this CPU */
>>>>    	unsigned int nr_event_counters;
>>>>    };
>>>> @@ -1381,6 +1385,8 @@ static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
>>>>    void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
>>>>    void kvm_clr_pmu_events(u64 clr);
>>>>    bool kvm_set_pmuserenr(u64 val);
>>>> +void kvm_enable_trbe(void);
>>>> +void kvm_disable_trbe(void);
>>>>    #else
>>>>    static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
>>>>    static inline void kvm_clr_pmu_events(u64 clr) {}
>>>> @@ -1388,6 +1394,8 @@ static inline bool kvm_set_pmuserenr(u64 val)
>>>>    {
>>>>    	return false;
>>>>    }
>>>> +static inline void kvm_enable_trbe(void) {}
>>>> +static inline void kvm_disable_trbe(void) {}
>>>>    #endif
>>>>      void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
>>>> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
>>>> index dd9e139dfd13..0c340ae7b5d1 100644
>>>> --- a/arch/arm64/kvm/debug.c
>>>> +++ b/arch/arm64/kvm/debug.c
>>>> @@ -314,7 +314,26 @@ void kvm_init_host_debug_data(void)
>>>>    	    !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P))
>>>>    		host_data_set_flag(HAS_SPE);
>>>>    -	if (cpuid_feature_extract_unsigned_field(dfr0,
>>>> ID_AA64DFR0_EL1_TraceBuffer_SHIFT) &&
>>>> -	    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_P))
>>>> -		host_data_set_flag(HAS_TRBE);
>>>> +	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceFilt_SHIFT))
>>>> +		host_data_set_flag(HAS_TRF);
>>>>    }
>>>> +
>>>> +void kvm_enable_trbe(void)
>>>> +{
>>>> +	if (has_vhe() || is_protected_kvm_enabled() ||
>>>> +	    WARN_ON_ONCE(preemptible()))
>>>> +		return;
>>>> +
>>>> +	host_data_set_flag(TRBE_ENABLED);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(kvm_enable_trbe);
>>>> +
>>>> +void kvm_disable_trbe(void)
>>>> +{
>>>> +	if (has_vhe() || is_protected_kvm_enabled() ||
>>>> +	    WARN_ON_ONCE(preemptible()))
>>>> +		return;
>>>> +
>>>> +	host_data_clear_flag(TRBE_ENABLED);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(kvm_disable_trbe);
>>>> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>>>> index 858bb38e273f..9479bee41801 100644
>>>> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>>>> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>>>> @@ -51,32 +51,39 @@ static void __debug_restore_spe(u64 pmscr_el1)
>>>>    	write_sysreg_el1(pmscr_el1, SYS_PMSCR);
>>>>    }
>>>>    -static void __debug_save_trace(u64 *trfcr_el1)
>>>> +static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
>>>>    {
>>>> -	*trfcr_el1 = 0;
>>>> +	*saved_trfcr = read_sysreg_el1(SYS_TRFCR);
>>>> +	write_sysreg_el1(new_trfcr, SYS_TRFCR);
>>>>    -	/* Check if the TRBE is enabled */
>>>> -	if (!(read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E))
>>>> +	/* No need to drain if going to an enabled state or from disabled state */
>>>> +	if (new_trfcr || !*saved_trfcr)
>>>
>>> What if TRFCR_EL1.TS is set to something non-zero? I'd rather you
>>> check for the E*TRE bits instead of assuming things.
>>>
>>
>> Yeah it's probably better that way. TS is actually always set when any
>> tracing session starts and then never cleared, so doing it the simpler
>> way made it always flush even after tracing finished, which probably
>> wasn't great.
> 
> Quite. Can you please *test* these things?
> 
> [...]
> 

Sorry to confuse things I wasn't 100% accurate here, yes it's tested and 
working. It works because of the split set/clear_trfcr() API. The 
Coresight driver specifically calls clear at the end of the session 
rather than a set of 0. That signals this function not to be called so 
there's no excessive swapping.

Secondly, the buffer flushing case is triggered by TRBE_ENABLED, which 
forces TRFCR to 0, so "if (new_trfcr)" is an OK way to gate the flush.


>>>> @@ -253,8 +256,10 @@ static void trbe_drain_and_disable_local(struct trbe_cpudata *cpudata)
>>>>      static void trbe_reset_local(struct trbe_cpudata *cpudata)
>>>>    {
>>>> +	preempt_disable();
>>>>    	trbe_drain_and_disable_local(cpudata);
>>>>    	write_sysreg_s(0, SYS_TRBLIMITR_EL1);
>>>> +	preempt_enable();
>>>
>>> This looks terribly wrong. If you need to disable preemption here, why
>>> doesn't the critical section cover all register accesses? Surely you
>>> don't want to nuke another CPU's context?
>>>
>>> But looking at the calling sites, this makes even less sense. The two
>>> callers of this thing mess with *per-CPU* interrupts. Dealing with
>>> per-CPU interrupts in preemptible context is a big no-no (hint: they
>>> start with a call to smp_processor_id()).
>>>
>>> So what is this supposed to ensure?
>>>
>>> 	M.
>>>
>>
>> These ones are only intended to silence the
>> WARN_ON_ONCE(preemptible()) in kvm_enable_trbe() when this is called
>> from boot/hotplug (arm_trbe_enable_cpu()). Preemption isn't disabled,
>> but a guest can't run at that point either.
>>
>> The "real" calls to kvm_enable_trbe() _are_ called from an atomic
>> context. I think there was a previous review comment about when it was
>> safe to call the KVM parts of this change, which is why I added the
>> warning making sure it was always called with preemption disabled. But
>> actually I could remove the warning and these preempt_disables() and
>> replace them with a comment.
> 
> You should keep the WARN_ON(), and either *never* end-up calling this
> stuff during a CPUHP event, or handle the fact that preemption isn't
> initialised yet. For example by checking whether the current CPU is
> online.
> 
> But this sort of random spreading of preemption disabling is not an
> acceptable outcome.
> 
> 	M.
> 

I'll look into this again. This was my initial attempt but couldn't find 
any easily accessible state that allowed to to be done this way. Maybe I 
missed something, but the obvious cpu_online() etc were already true at 
this point.

Thanks
James


