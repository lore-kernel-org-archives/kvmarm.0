Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BDD1D4336
	for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 12:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732193416; cv=none; b=IpYa9dk9N6tttCs37yy7FyQjEeG1DR3evDq2gBggnxAEq3pdYpa2vMmEUpLwXJ8WbTxOUGVrtHrPTqIvcBI0pNZr0nW7jO6rAmSTUWOQH7WXRcqp7AmltFNRoHVB7YnIGyIEPPsKNl6BbB53+HroN8Ptxnoje5AMfGdzphE2JHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732193416; c=relaxed/simple;
	bh=VGKCPOHabdChMVxA6hkchR1O4GkLz2DsQ9EptG1dtAA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KF/ugQ6fv274hzbEu2qZAcbV+6ZOOuAbfy/Hy5p/8VSy57TGo9Vo/9kI/r0NbEAgOluCkYxONKCQD6VFdipsYTxNIAKhuKkinYjRbHQ1IC1Td1sbsE51SyXBYfqIPE0gG3ptDvMb6xtQQMElH2NIusGPViwoL0Pt+2Rpt1OsKxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gQPZCToF; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gQPZCToF"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a9eb3794a04so102173066b.3
        for <kvmarm@lists.linux.dev>; Thu, 21 Nov 2024 04:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732193412; x=1732798212; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q1sbUFNREEYcfDxPTPKAQ5hOnZsL8UzvDCoSVBHtues=;
        b=gQPZCToFQ60P4u4A8lI/8avh+VloJerVx15/aJTh53BhZqDlQvcim7J2sqQQYw36Vz
         ir5YcY9kzvw7sFu0qGg3yoW5MKN6ptkf4oa3tPH4VIbIGL/XhZK9W2zt90nbmK4Lks0w
         qNiH05qzN9fI+QvYanRIFyNnW02H+OrticL4bv4jDe3GSUwKE/FLKWPJfSMHbXvfTcm1
         WeJgz5i7RHqWiNNBBsLoid5LveZNhtxPWmRVzLK7lfJGyB/gP9Iia04O0nlrEkzD4fpn
         2OzsWShMop1mlOe81hqNhQiKNnBqELUJl3Mzv7ufRl7vmXQRtYWyKZA19GSQIlGb5rYu
         5EAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732193412; x=1732798212;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1sbUFNREEYcfDxPTPKAQ5hOnZsL8UzvDCoSVBHtues=;
        b=ZysumzG+Zing2oN0GotxoBY4jfyhTnJlTYp10jzQOwzZhAOV9/Lyv1o1h2wDAISXNv
         91NoHUo+codaeid3zDaDLL1JljeSzlv03yo+ikBih653MszFcfqPYRCgB0epN1v+HEAO
         FZIf6oiBjemcRE3/BC8a6IF+6aYUDmq6nPDCQr8lorxJLJPAXHVZaGAV/jj2LnzCCdTB
         uNX0luXWREZ7wBC6+XGy4p7nXtS4fvqhXqCt2XuIdoPzDRLn7dgS4esUrO7I4aMY5gXJ
         eJZeomDAIq818B8h2AA4pvj/3kUmf+6c15Oh6X79lLvqEvgV9ngQo1wWgVpgdiYiKiGC
         I4uw==
X-Forwarded-Encrypted: i=1; AJvYcCVYj++a5Na65+DkXk0wont3lc1DrxqdLKlrlgrj5QstokdQulLcpN19Pbi3GxXmcDTJnlciI+g=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUdG71Xu7t8JJuv8XdrVPsubh2q/ecwqFfJjFNHXvHaO3ksLpp
	coJprHI6X6O0hvmJmihoCYGshmiol62fVFVmgAsLhuRWWfKkI1vPAqxz+uY9CGY=
X-Google-Smtp-Source: AGHT+IHTbQJaBpIdR7/dqWXIfubWZ8puALMeRYpmvuxQwnzmTNc5RlBhY2YMYVJzW6TGhTuQeB89rw==
X-Received: by 2002:a17:907:d08:b0:a9a:76d:e86c with SMTP id a640c23a62f3a-aa4dd7614famr488939766b.49.1732193412432;
        Thu, 21 Nov 2024 04:50:12 -0800 (PST)
Received: from [192.168.68.163] ([145.224.90.249])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f431a7absm77011266b.143.2024.11.21.04.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 04:50:11 -0800 (PST)
Message-ID: <5f2eb0fa-c7ca-4e25-b713-6a9bf3d355b9@linaro.org>
Date: Thu, 21 Nov 2024 12:50:10 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/12] KVM: arm64: Swap TRFCR on guest switch
To: Oliver Upton <oliver.upton@linux.dev>
Cc: suzuki.poulose@arm.com, coresight@lists.linaro.org,
 kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mike Leach <mike.leach@linaro.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Rutland <mark.rutland@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 "Rob Herring (Arm)" <robh@kernel.org>, Shiqi Liu <shiqiliu@hust.edu.cn>,
 Fuad Tabba <tabba@google.com>, James Morse <james.morse@arm.com>,
 Mark Brown <broonie@kernel.org>, Raghavendra Rao Ananta
 <rananta@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20241112103717.589952-1-james.clark@linaro.org>
 <20241112103717.589952-12-james.clark@linaro.org>
 <Zz4c5LmQnK2SD5HO@linux.dev>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <Zz4c5LmQnK2SD5HO@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 20/11/2024 5:31 pm, Oliver Upton wrote:
> On Tue, Nov 12, 2024 at 10:37:10AM +0000, James Clark wrote:
>> +void kvm_set_trfcr(u64 host_trfcr, u64 guest_trfcr)
>> +{
>> +	if (kvm_arm_skip_trace_state())
>> +		return;
>> +
>> +	if (has_vhe())
>> +		write_sysreg_s(guest_trfcr, SYS_TRFCR_EL12);
>> +	else
>> +		if (host_trfcr != guest_trfcr) {
>> +			*host_data_ptr(host_debug_state.trfcr_el1) = guest_trfcr;
> 
> Huh? That's going into host_debug_state, which is the dumping grounds
> for *host* context when entering a guest.
> 
> Not sure why we'd stick a *guest* value in there...
> 

Only to save a 3rd storage place for trfcr when just the register and 
one place is technically enough. But yes if it's more readable to have 
guest_trfcr_el1 separately then that makes sense.

>> +			host_data_set_flag(HOST_STATE_SWAP_TRFCR);
>> +		} else
>> +			host_data_clear_flag(HOST_STATE_SWAP_TRFCR);
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_set_trfcr);
> 
> I have a rather strong distaste for this interface, both with the
> coresight driver and internally with the hypervisor. It'd be better if
> the driver actually told KVM what the *intent* is rather than throwing a
> pile of bits over the fence and forcing KVM to interpret what that
> configuration means.
> 

That works, it would be nice to have it consistent and have it that way 
for filtering, like kvm_set_guest_trace_filters(bool kernel, bool user). 
But I suppose we can justify not doing it there because we're not really 
interpreting the TRFCR value just writing it whole.

>> +static void __debug_swap_trace(void)
>> +{
>> +	u64 trfcr = read_sysreg_el1(SYS_TRFCR);
>> +
>> +	write_sysreg_el1(*host_data_ptr(host_debug_state.trfcr_el1), SYS_TRFCR);
>> +	*host_data_ptr(host_debug_state.trfcr_el1) = trfcr;
>> +	host_data_set_flag(HOST_STATE_RESTORE_TRFCR);
>> +}
>> +
> 
> What if trace is disabled in the guest or in the host? Do we need to
> synchronize when transitioning from an enabled -> disabled state like we
> do today?
> 

By synchronize do you mean the tsb_csync()? I can only see it being 
necessary for the TRBE case because then writing to the buffer is fatal. 
Without TRBE the trace sinks still work and the boundary of when exactly 
tracing is disabled in the kernel isn't critical.

> I took a stab at this, completely untested of course && punts on
> protected mode. But this is _generally_ how I'd like to see everything
> fit together.
> 

Would you expect to see the protected mode stuff ignored if I sent 
another version more like yours below? Or was that just skipped to keep 
the example shorter?

I think I'm a bit uncertain on that one because removing HAS_TRBE means 
you can't check if TRBE is enabled or not in protected mode and it will 
go wrong if it is.

But other than that I think I get the general point of what you mean:

   * Add an explicit guest_trfcr variable rather than cheating and using
     the host one
   * kvm_enable_trbe() rather than interpreting the TRBLIMITR value
   * Some code reuse by calling __trace_do_switch() with flipped
     arguments on both entry and exit

And see below but I think it requires one minor change to support 
filtering without TRBE

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8bc0ec151684..b4714cece5f0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -611,7 +611,7 @@ struct cpu_sve_state {
>    */
>   struct kvm_host_data {
>   #define KVM_HOST_DATA_FLAG_HAS_SPE			0
> -#define KVM_HOST_DATA_FLAG_HAS_TRBE			1
> +#define KVM_HOST_DATA_FLAG_HOST_TRBE_ENABLED		1
>   #define KVM_HOST_DATA_FLAG_HOST_SVE_ENABLED		2
>   #define KVM_HOST_DATA_FLAG_HOST_SME_ENABLED		3
>   	unsigned long flags;
> @@ -659,6 +659,9 @@ struct kvm_host_data {
>   		u64 mdcr_el2;
>   	} host_debug_state;
>   
> +	/* Guest trace filter value */
> +	u64 guest_trfcr_el1;
> +
>   	/* Number of programmable event counters (PMCR_EL0.N) for this CPU */
>   	unsigned int nr_event_counters;
>   
> @@ -1381,6 +1384,8 @@ static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
>   void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
>   void kvm_clr_pmu_events(u64 clr);
>   bool kvm_set_pmuserenr(u64 val);
> +void kvm_enable_trbe(u64 guest_trfcr);
> +void kvm_disable_trbe(void);
>   #else
>   static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
>   static inline void kvm_clr_pmu_events(u64 clr) {}
> @@ -1388,6 +1393,8 @@ static inline bool kvm_set_pmuserenr(u64 val)
>   {
>   	return false;
>   }
> +void kvm_enable_trbe(u64 guest_trfcr) {}
> +void kvm_disable_trbe(void) {}
>   #endif
>   
>   void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 46dbeabd6833..6ef8d8f4b452 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -72,10 +72,6 @@ void kvm_init_host_debug_data(void)
>   	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_PMSVer_SHIFT) &&
>   	    !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P))
>   		host_data_set_flag(HAS_SPE);
> -
> -	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceBuffer_SHIFT) &&
> -	    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_P))
> -		host_data_set_flag(HAS_TRBE);
>   }
>   
>   /*
> @@ -215,3 +211,27 @@ void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val)
>   	kvm_arch_vcpu_load(vcpu, smp_processor_id());
>   	preempt_enable();
>   }
> +
> +void kvm_enable_trbe(u64 guest_trfcr)
> +{
> +	if (WARN_ON_ONCE(preemptible()))
> +		return;
> +
> +	if (has_vhe()) {
> +		write_sysreg_s(guest_trfcr, SYS_TRFCR_EL12);
> +		return;
> +	}
> +
> +	*host_data_ptr(guest_trfcr_el1) = guest_trfcr;
> +	host_data_set_flag(HOST_TRBE_ENABLED);

FWIW TRBE and TRF are separate features, so this wouldn't do the 
filtering correctly if TRBE wasn't in use, but I can split it out into
separate kvm_enable_trbe(void) and kvm_set_guest_filters(u64 guest_trfcr).

> +}
> +EXPORT_SYMBOL_GPL(kvm_enable_trbe);
> +
> +void kvm_disable_trbe(void)
> +{
> +	if (has_vhe() || WARN_ON_ONCE(preemptible()))
> +		return;
> +
> +	host_data_clear_flag(HOST_TRBE_ENABLED);
> +}
> +EXPORT_SYMBOL_GPL(kvm_disable_trbe);
> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> index 858bb38e273f..d36cbce75bee 100644
> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> @@ -51,32 +51,33 @@ static void __debug_restore_spe(u64 pmscr_el1)
>   	write_sysreg_el1(pmscr_el1, SYS_PMSCR);
>   }
>   
> -static void __debug_save_trace(u64 *trfcr_el1)
> +static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
>   {
> -	*trfcr_el1 = 0;
> +	*saved_trfcr = read_sysreg_el1(SYS_TRFCR);
> +	write_sysreg_el1(new_trfcr, SYS_TRFCR);
>   
> -	/* Check if the TRBE is enabled */
> -	if (!(read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E))
> +	/* Nothing left to do if going to an enabled state */
> +	if (new_trfcr)
>   		return;
> +
>   	/*
> -	 * Prohibit trace generation while we are in guest.
> -	 * Since access to TRFCR_EL1 is trapped, the guest can't
> -	 * modify the filtering set by the host.
> +	 * Switching to a context with trace generation disabled. Drain the
> +	 * trace buffer to memory.
>   	 */
> -	*trfcr_el1 = read_sysreg_el1(SYS_TRFCR);
> -	write_sysreg_el1(0, SYS_TRFCR);
>   	isb();
> -	/* Drain the trace buffer to memory */
>   	tsb_csync();
>   }
>   
> -static void __debug_restore_trace(u64 trfcr_el1)
> +static void __trace_switch_to_guest(void)
>   {
> -	if (!trfcr_el1)
> -		return;
> +	__trace_do_switch(host_data_ptr(host_debug_state.trfcr_el1),
> +			  *host_data_ptr(guest_trfcr_el1));
> +}
>   
> -	/* Restore trace filter controls */
> -	write_sysreg_el1(trfcr_el1, SYS_TRFCR);
> +static void __trace_switch_to_host(void)
> +{
> +	__trace_do_switch(host_data_ptr(guest_trfcr_el1),
> +			  *host_data_ptr(host_debug_state.trfcr_el1));
>   }
>   
>   void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
> @@ -84,9 +85,13 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>   	/* Disable and flush SPE data generation */
>   	if (host_data_test_flag(HAS_SPE))
>   		__debug_save_spe(host_data_ptr(host_debug_state.pmscr_el1));
> -	/* Disable and flush Self-Hosted Trace generation */
> -	if (host_data_test_flag(HAS_TRBE))
> -		__debug_save_trace(host_data_ptr(host_debug_state.trfcr_el1));
> +
> +	/*
> +	 * Switch the trace filter, potentially disabling and flushing trace
> +	 * data generation
> +	 */
> +	if (host_data_test_flag(HOST_TRBE_ENABLED))
> +		__trace_switch_to_guest();



>   }
>   
>   void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
> @@ -98,8 +103,8 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>   {
>   	if (host_data_test_flag(HAS_SPE))
>   		__debug_restore_spe(*host_data_ptr(host_debug_state.pmscr_el1));
> -	if (host_data_test_flag(HAS_TRBE))
> -		__debug_restore_trace(*host_data_ptr(host_debug_state.trfcr_el1));
> +	if (host_data_test_flag(HOST_TRBE_ENABLED))
> +		__trace_switch_to_host();
>   }
>   
>   void __debug_switch_to_host(struct kvm_vcpu *vcpu)
> 

