Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B216D21D5A6
	for <kvmarm@lists.linux.dev>; Fri, 20 Dec 2024 17:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734715942; cv=none; b=SwMKOjoEohLRamCxEqGksOWEFpIrAJjfgOq9zTNt2licD10zkRJ3ETf2A3kULts5Bb5n3FB13ZYI9el56A9aAB+pGeW0kY/lF7LQRHtLu/A2G2wSwEx7DE/lX0CIBpuqdhx2yjkFz4xq2pwAzLJck3nAvO/uGZrCdaCjYoU8+8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734715942; c=relaxed/simple;
	bh=ztpTssPcZ8EO0jDvtv6AD2MO9aGuNeOB+PTgbvDEo0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O17UeG6q/Fk1YZTAG2JRXKhg97n5G0a/kGbheeYpZnqql/SMQEjEXcaT/v8S/Z0baBOF+G4z43hZTiVpJrt3ox3/8O4EPY6SIGML84QA8f1d9bK++m5VsqGoE5Z7MbLJhS4vdGvEQD2j2AouNDN+djgitlNY5jS9FPcG9vYke/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f/i7fAtX; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f/i7fAtX"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4363dc916ceso20706225e9.0
        for <kvmarm@lists.linux.dev>; Fri, 20 Dec 2024 09:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734715939; x=1735320739; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wsMy3W1P48XjE0lxvZ3w+sENNSu9cxJbTFgniBcyNBI=;
        b=f/i7fAtXUaBCuvb279zzLW7JIyoCF4LTyP6OzBqrP7C0D1LZg7Nact5fn9njEAvIo+
         Q6soEp9ijvRqmRd8pn3EjhO3KW4xtV+Y4cVpAMpO+ubunhyyycHoMNo++HhNBZAvz9Bx
         kj6F185BP/dVZ5qZXpjr6qcEvKFp0q/okWpJvrkAwVL6yQcNXDtHZDV3N60B/r04eZvu
         gezY1ch3PaEXAhvd1fOdHFK/9saXfVQ/H8ZV3WWwOUFfr+j2EJd/Tr1VDL69h/iEIV/p
         dw2msjXSqWB89pajdPLGRdP1U3PWUfSZg/1UJ395gh2wlY2sstWipgkpnkJ7WODiaVGN
         /uUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734715939; x=1735320739;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wsMy3W1P48XjE0lxvZ3w+sENNSu9cxJbTFgniBcyNBI=;
        b=W5ob2lCAMEr4RveQyu8A9TaST6CrBvxcJQLUug15IU+IcKE1PipyRjAPFjMbqfiUN+
         pCvZcC7zuyyXPv5+r2bhS/l3rafM2F3YbbapuJjysoq+8blTgJD6qWKzV+6wcjfBo8oy
         VM+NkJOHip5fGSaAL84MgQF5yAIp7QDIMKzg16Gt6zprT9tUJ3VwtaG247jYlaEhg2Ob
         UKnxU7RSClsCN99Jozalhxe3Jk0GEAduMWbHWIa+2/967mgFlbN2eQCp9ago5TmUKK6K
         p18BX1EXqHhGReGfSjTloHSB1IRAb4qmPqcIcSy+FS6Sp5TIDlW1ff/KftcKEQ+GcKUa
         hDZw==
X-Gm-Message-State: AOJu0YyS0ZhXiEqIcP7O0V1vAl03ZllqJlkCjoQrtwujVU/2rbCQlp+Q
	rSMAtN8gtEuK1OMj6phwNWDuoHgwqYlFSnYC8X2LqRtUC20tPOCD9vaalRiM+Fc=
X-Gm-Gg: ASbGnctwAZdDw2lcJWpsIrqtzEuXr9jM8RV7jA5mhnDj5f+i+kNS3jzMEzIxppau5/Z
	9ybWJrDvCCyAE368zJQdl+CNAi+33BTV0nojryv4+vDxdrYp4rOL/46Wv4bn1bKAZoGkNjcUUef
	5L96ed7u3ai/INWn9sigXZBwZLibsLc89EqSPybti84nOJX3lm++q50EBX3u7RV24/bZlPJRAah
	mmPSH6mmX9Ve6OCqjwXzBf/XUOguYU7XGMumxWi/GChdFLz4Fp63iC+ya0VAq3K63U=
X-Google-Smtp-Source: AGHT+IFikjZHOMMfEvBNiPcgVk0yfDEPrPtxq6cuzI25mFCoL/ghDDZZ7oXruh1/HrOGtBK2xMO6jg==
X-Received: by 2002:a05:600c:1387:b0:435:1a2:262a with SMTP id 5b1f17b1804b1-436696fec31mr34296305e9.3.1734715939065;
        Fri, 20 Dec 2024 09:32:19 -0800 (PST)
Received: from [192.168.68.163] ([145.224.65.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b013a1sm86508355e9.11.2024.12.20.09.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2024 09:32:18 -0800 (PST)
Message-ID: <e6b46080-b9ae-4aad-b06d-81407c195e28@linaro.org>
Date: Fri, 20 Dec 2024 17:32:17 +0000
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
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <86ttayp9n9.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 20/12/2024 5:05 pm, Marc Zyngier wrote:
> On Wed, 27 Nov 2024 10:01:23 +0000,
> James Clark <james.clark@linaro.org> wrote:
>>
>> Currently in nVHE, KVM has to check if TRBE is enabled on every guest
>> switch even if it was never used. Because it's a debug feature and is
>> more likely to not be used than used, give KVM the TRBE buffer status to
>> allow a much simpler and faster do-nothing path in the hyp.
>>
>> This is always called with preemption disabled except for probe/hotplug
>> which gets wrapped with preempt_disable().
>>
>> Protected mode disables trace regardless of TRBE (because
>> guest_trfcr_el1 is always 0), which was not previously done. HAS_TRBE
>> becomes redundant, but HAS_TRF is now required for this.
>>
>> Signed-off-by: James Clark <james.clark@linaro.org>
>> ---
>>   arch/arm64/include/asm/kvm_host.h            | 10 +++-
>>   arch/arm64/kvm/debug.c                       | 25 ++++++++--
>>   arch/arm64/kvm/hyp/nvhe/debug-sr.c           | 51 +++++++++++---------
>>   drivers/hwtracing/coresight/coresight-trbe.c |  5 ++
>>   4 files changed, 65 insertions(+), 26 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 7e3478386351..ba251caa593b 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -611,7 +611,8 @@ struct cpu_sve_state {
>>    */
>>   struct kvm_host_data {
>>   #define KVM_HOST_DATA_FLAG_HAS_SPE	0
>> -#define KVM_HOST_DATA_FLAG_HAS_TRBE	1
>> +#define KVM_HOST_DATA_FLAG_HAS_TRF	1
>> +#define KVM_HOST_DATA_FLAG_TRBE_ENABLED	2
>>   	unsigned long flags;
>>   
>>   	struct kvm_cpu_context host_ctxt;
>> @@ -657,6 +658,9 @@ struct kvm_host_data {
>>   		u64 mdcr_el2;
>>   	} host_debug_state;
>>   
>> +	/* Guest trace filter value */
>> +	u64 guest_trfcr_el1;
> 
> Guest value? Or host state while running the guest? If the former,
> then this has nothing to do here. If the latter, this should be
> spelled out (trfcr_in_guest?), and the comment amended.
> 
>> +
>>   	/* Number of programmable event counters (PMCR_EL0.N) for this CPU */
>>   	unsigned int nr_event_counters;
>>   };
>> @@ -1381,6 +1385,8 @@ static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
>>   void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
>>   void kvm_clr_pmu_events(u64 clr);
>>   bool kvm_set_pmuserenr(u64 val);
>> +void kvm_enable_trbe(void);
>> +void kvm_disable_trbe(void);
>>   #else
>>   static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
>>   static inline void kvm_clr_pmu_events(u64 clr) {}
>> @@ -1388,6 +1394,8 @@ static inline bool kvm_set_pmuserenr(u64 val)
>>   {
>>   	return false;
>>   }
>> +static inline void kvm_enable_trbe(void) {}
>> +static inline void kvm_disable_trbe(void) {}
>>   #endif
>>   
>>   void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
>> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
>> index dd9e139dfd13..0c340ae7b5d1 100644
>> --- a/arch/arm64/kvm/debug.c
>> +++ b/arch/arm64/kvm/debug.c
>> @@ -314,7 +314,26 @@ void kvm_init_host_debug_data(void)
>>   	    !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P))
>>   		host_data_set_flag(HAS_SPE);
>>   
>> -	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceBuffer_SHIFT) &&
>> -	    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_P))
>> -		host_data_set_flag(HAS_TRBE);
>> +	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceFilt_SHIFT))
>> +		host_data_set_flag(HAS_TRF);
>>   }
>> +
>> +void kvm_enable_trbe(void)
>> +{
>> +	if (has_vhe() || is_protected_kvm_enabled() ||
>> +	    WARN_ON_ONCE(preemptible()))
>> +		return;
>> +
>> +	host_data_set_flag(TRBE_ENABLED);
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_enable_trbe);
>> +
>> +void kvm_disable_trbe(void)
>> +{
>> +	if (has_vhe() || is_protected_kvm_enabled() ||
>> +	    WARN_ON_ONCE(preemptible()))
>> +		return;
>> +
>> +	host_data_clear_flag(TRBE_ENABLED);
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_disable_trbe);
>> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>> index 858bb38e273f..9479bee41801 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>> @@ -51,32 +51,39 @@ static void __debug_restore_spe(u64 pmscr_el1)
>>   	write_sysreg_el1(pmscr_el1, SYS_PMSCR);
>>   }
>>   
>> -static void __debug_save_trace(u64 *trfcr_el1)
>> +static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
>>   {
>> -	*trfcr_el1 = 0;
>> +	*saved_trfcr = read_sysreg_el1(SYS_TRFCR);
>> +	write_sysreg_el1(new_trfcr, SYS_TRFCR);
>>   
>> -	/* Check if the TRBE is enabled */
>> -	if (!(read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E))
>> +	/* No need to drain if going to an enabled state or from disabled state */
>> +	if (new_trfcr || !*saved_trfcr)
> 
> What if TRFCR_EL1.TS is set to something non-zero? I'd rather you
> check for the E*TRE bits instead of assuming things.
> 

Yeah it's probably better that way. TS is actually always set when any 
tracing session starts and then never cleared, so doing it the simpler 
way made it always flush even after tracing finished, which probably 
wasn't great.

>>   		return;
>> -	/*
>> -	 * Prohibit trace generation while we are in guest.
>> -	 * Since access to TRFCR_EL1 is trapped, the guest can't
>> -	 * modify the filtering set by the host.
>> -	 */
>> -	*trfcr_el1 = read_sysreg_el1(SYS_TRFCR);
>> -	write_sysreg_el1(0, SYS_TRFCR);
>> +
>>   	isb();
>> -	/* Drain the trace buffer to memory */
>>   	tsb_csync();
>>   }
>>   
>> -static void __debug_restore_trace(u64 trfcr_el1)
>> +static bool __trace_needs_switch(void)
>>   {
>> -	if (!trfcr_el1)
>> -		return;
>> +	return host_data_test_flag(TRBE_ENABLED) ||
>> +	       (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRF));
>> +}
>>   
>> -	/* Restore trace filter controls */
>> -	write_sysreg_el1(trfcr_el1, SYS_TRFCR);
>> +static void __trace_switch_to_guest(void)
>> +{
>> +	/* Unsupported with TRBE so disable */
>> +	if (host_data_test_flag(TRBE_ENABLED))
>> +		*host_data_ptr(guest_trfcr_el1) = 0;
>> +
>> +	__trace_do_switch(host_data_ptr(host_debug_state.trfcr_el1),
>> +			  *host_data_ptr(guest_trfcr_el1));
>> +}
>> +
>> +static void __trace_switch_to_host(void)
>> +{
>> +	__trace_do_switch(host_data_ptr(guest_trfcr_el1),
>> +			  *host_data_ptr(host_debug_state.trfcr_el1));
>>   }
>>   
>>   void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>> @@ -84,9 +91,9 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>>   	/* Disable and flush SPE data generation */
>>   	if (host_data_test_flag(HAS_SPE))
>>   		__debug_save_spe(host_data_ptr(host_debug_state.pmscr_el1));
>> -	/* Disable and flush Self-Hosted Trace generation */
>> -	if (host_data_test_flag(HAS_TRBE))
>> -		__debug_save_trace(host_data_ptr(host_debug_state.trfcr_el1));
>> +
>> +	if (__trace_needs_switch())
>> +		__trace_switch_to_guest();
>>   }
>>   
>>   void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
>> @@ -98,8 +105,8 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>>   {
>>   	if (host_data_test_flag(HAS_SPE))
>>   		__debug_restore_spe(*host_data_ptr(host_debug_state.pmscr_el1));
>> -	if (host_data_test_flag(HAS_TRBE))
>> -		__debug_restore_trace(*host_data_ptr(host_debug_state.trfcr_el1));
>> +	if (__trace_needs_switch())
>> +		__trace_switch_to_host();
>>   }
>>   
>>   void __debug_switch_to_host(struct kvm_vcpu *vcpu)
>> diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
>> index 96a32b213669..9c0f8c43e6fe 100644
>> --- a/drivers/hwtracing/coresight/coresight-trbe.c
>> +++ b/drivers/hwtracing/coresight/coresight-trbe.c
>> @@ -18,6 +18,7 @@
>>   #include <asm/barrier.h>
>>   #include <asm/cpufeature.h>
>>   #include <linux/vmalloc.h>
>> +#include <linux/kvm_host.h>
> 
> Ordering of include files.
> 
>>   
>>   #include "coresight-self-hosted-trace.h"
>>   #include "coresight-trbe.h"
>> @@ -221,6 +222,7 @@ static inline void set_trbe_enabled(struct trbe_cpudata *cpudata, u64 trblimitr)
>>   	 */
>>   	trblimitr |= TRBLIMITR_EL1_E;
>>   	write_sysreg_s(trblimitr, SYS_TRBLIMITR_EL1);
>> +	kvm_enable_trbe();
>>   
>>   	/* Synchronize the TRBE enable event */
>>   	isb();
>> @@ -239,6 +241,7 @@ static inline void set_trbe_disabled(struct trbe_cpudata *cpudata)
>>   	 */
>>   	trblimitr &= ~TRBLIMITR_EL1_E;
>>   	write_sysreg_s(trblimitr, SYS_TRBLIMITR_EL1);
>> +	kvm_disable_trbe();
>>   
>>   	if (trbe_needs_drain_after_disable(cpudata))
>>   		trbe_drain_buffer();
>> @@ -253,8 +256,10 @@ static void trbe_drain_and_disable_local(struct trbe_cpudata *cpudata)
>>   
>>   static void trbe_reset_local(struct trbe_cpudata *cpudata)
>>   {
>> +	preempt_disable();
>>   	trbe_drain_and_disable_local(cpudata);
>>   	write_sysreg_s(0, SYS_TRBLIMITR_EL1);
>> +	preempt_enable();
> 
> This looks terribly wrong. If you need to disable preemption here, why
> doesn't the critical section cover all register accesses? Surely you
> don't want to nuke another CPU's context?
> 
> But looking at the calling sites, this makes even less sense. The two
> callers of this thing mess with *per-CPU* interrupts. Dealing with
> per-CPU interrupts in preemptible context is a big no-no (hint: they
> start with a call to smp_processor_id()).
> 
> So what is this supposed to ensure?
> 
> 	M.
> 

These ones are only intended to silence the WARN_ON_ONCE(preemptible()) 
in kvm_enable_trbe() when this is called from boot/hotplug 
(arm_trbe_enable_cpu()). Preemption isn't disabled, but a guest can't 
run at that point either.

The "real" calls to kvm_enable_trbe() _are_ called from an atomic 
context. I think there was a previous review comment about when it was 
safe to call the KVM parts of this change, which is why I added the 
warning making sure it was always called with preemption disabled. But 
actually I could remove the warning and these preempt_disables() and 
replace them with a comment.

Thanks
James

