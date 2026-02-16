Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B755327C06
	for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 16:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771258219; cv=none; b=GFuQN4CV2XoHZpFt0v+505A5Ot5HhMcq8oyRxOmobtmmLo71+ULnLRYziTjwLvRQRpw90vA6VQXOxwAk7UXV8bevvVGaUYV3nZzRs1AeBQRA8V1ksyuODe7CIkrKfpos4I/otNEQ4TFV0PgFUzyxoX8ZUZatOFV6iV8cYjlEjd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771258219; c=relaxed/simple;
	bh=GzTVVMCoEpvXxO4L+MTEkuPpuSQQiCrkZE1icJffQ3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQSWS3/9CbxAIciv2eTl+I5MLQYKeaXwluzkExOwXTmIpbe1h0kC331EeCk/gvCeqJwD+KtQLO4LIb0CIrk5v2xgUid7I6m2XLxCXmGzgXGa/0Eg8g9CCal146a0XAhMwhz6WKgw5IpBJd8rg1zZxZriXeByKvNBoC76Ee1gB3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oq2keM2z; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oq2keM2z"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4362507f396so3244348f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 08:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771258216; x=1771863016; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p0os1I3D0nQneQNh6nW04sjPFr1Z4Anzp2eQ7qnvXCg=;
        b=oq2keM2zZuUho4GtcMDi5cwcqYjW4yoMj8st/3ovyP9rA0w/TlKEfwUGwfPDdWvL0/
         RVsr6WyRFJBao1iSQpTGO2rJ9pHEygFI/mTV6y+V7FzdjnYHhsGARutrYSW4zT5RP2th
         wckR9zmeon742Nq2GSSTuamzdZk2UFw+MzEtXgyZ//BUOVzivssB+IgGunl6d5qZTkAu
         JQjzd9lVqZQAH39RPW4DSXEH/CEn3876CYD0lgv1lykXtrJJiuxWAQlvKTmBf7q/Gtk9
         JZKrLNTsrWKSUedqbR1GAxCDrb+9Upmvo4z5i1ZmGbnRSpvLuB8IsBLoiS1uQDf2eeQw
         9U3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771258216; x=1771863016;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p0os1I3D0nQneQNh6nW04sjPFr1Z4Anzp2eQ7qnvXCg=;
        b=pGSR598nV8bUKE8cXf5o7xMetGK0uCPZKjxdtQpv1CLglEjD3T61GP9k3VnEotGaG4
         Tz4NoB1Ud0gagoK2Gnd+jEycNOf1xiu/2FGYdoT3A4ghqzm4t4yZEItUsUYTI24uU9Zo
         mvtoque8Ym++Rce8jTgtCFPCOJxOY/deGGFn9kzzehFzOhGsu17SA+qz7b6yfbczCCXc
         eu3hNHy9cAh2BVKgGkq+8LW1Chr1O1vTNaInp+RWSURCIZm2vTQEUUT3J5dPBdfBJhZP
         vmOktB0jlU+9Uza4f3xnmkrrT591zdSLBfDV6Z2wsIZkPNNlqGT7B3zx3WQkSEZmSIuC
         c/Yg==
X-Forwarded-Encrypted: i=1; AJvYcCXHSjeENPYHc8mvgxOo0Wx06lDxc9UyeO5PyFCHq532OGOOV5vWSzvH0SiYgTzLOWs4wsfaxY8=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywgp4A2x2O7S0exD82GToHyW8GbPJqL/TPNa4bpbKFc76aT+xyI
	hHBxERhLglKXttOMq+4E5E8bwd8u+aZSAmaoGzdToVlZ8fM2AOJqhv0O4gk7yszspaA=
X-Gm-Gg: AZuq6aJq3J/gi0bQDSC0GG68znyc2CvP7CNGqs/qxUgclFlC9GNDGX0Nark4eVhNloO
	Ui6uO2snstkNzf/N/DvJoTt/rUugHG9vZmFatOvA5hXVPSa6PRnWDcwt6kVl+z/C9lkGmtNp/wk
	aKXSBIaDwIyKyvvZ86GkW4zmKhvy8U1NdGJ00u8JNGsHYP74dV89yR1BqALAE1JUAJ+mKx5nx3b
	puxj5qmMlj+U1o9EGOp6BH53Tg2nMblrNsdx/yTINyoPU5jMTei7k7nTzaw6dfZGRrc9PGO1wki
	yIhzxHNLugyVpyqN+J5Sd1iC/6N0xw/ND2FKuWea5+1eQnfSABRdcaFpfPfHmKqDJGpMxKwgVgs
	GheEGzM1eOwdPuK8fG3L9T+zY61eXHR91v/4MD1hHc1MYFLhgcR6XS3YpK5w+v6qKvKADf4DdEH
	9UvVj/tJQQWisTljtH4CHAGEbW2l1HoOAr1YE5Lww=
X-Received: by 2002:a05:6000:4383:b0:432:5b81:483 with SMTP id ffacd0b85a97d-437978dda3fmr20801082f8f.24.1771258215791;
        Mon, 16 Feb 2026 08:10:15 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a5b4cdsm30760760f8f.8.2026.02.16.08.10.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 08:10:15 -0800 (PST)
Message-ID: <076e013a-b66d-4985-9709-734d7184ad72@linaro.org>
Date: Mon, 16 Feb 2026 16:10:14 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
 Oliver Upton <oupton@kernel.org>, Leo Yan <leo.yan@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org>
 <d2f6877a-534d-4862-a61c-fb3cb5b96618@linaro.org>
 <868qcsbsbd.wl-maz@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <868qcsbsbd.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 16/02/2026 3:51 pm, Marc Zyngier wrote:
> On Mon, 16 Feb 2026 15:05:10 +0000,
> James Clark <james.clark@linaro.org> wrote:
>>
>>
>>
>> On 16/02/2026 2:29 pm, Marc Zyngier wrote:
>>> On Mon, 16 Feb 2026 13:09:59 +0000,
>>> Will Deacon <will@kernel.org> wrote:
>>>>
>>>> The nVHE world-switch code relies on zeroing TRFCR_EL1 to disable trace
>>>> generation in guest context when self-hosted TRBE is in use by the host.
>>>>
>>>> Per D3.2.1 ("Controls to prohibit trace at Exception levels"), clearing
>>>> TRFCR_EL1 means that trace generation is prohibited at EL1 and EL0 but
>>>> per R_YCHKJ the Trace Buffer Unit will still be enabled if
>>>> TRBLIMITR_EL1.E is set. R_SJFRQ goes on to state that, when enabled, the
>>>> Trace Buffer Unit can perform address translation for the "owning
>>>> exception level" even when it is out of context.
>>>
>>> Great. So TRBE violates all the principles that we hold true in the
>>> architecture. Does SPE suffer from the same level of brokenness?
>>>
>>>> Consequently, we can end up in a state where TRBE performs speculative
>>>> page-table walks for a host VA/IPA in guest/hypervisor context depending
>>>> on the value of MDCR_EL2.E2TB, which changes over world-switch. The
>>>> result appears to be a heady mixture of data corruption and hardware
>>>> lockups.
>>>>
>>>> Extend the TRBE world-switch code to clear TRBLIMITR_EL1.E after
>>>> draining the buffer, restoring the register on return to the host.
>>>>
>>>> Cc: Marc Zyngier <maz@kernel.org>
>>>> Cc: Oliver Upton <oupton@kernel.org>
>>>> Cc: James Clark <james.clark@linaro.org>
>>>> Cc: Leo Yan <leo.yan@arm.com>
>>>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>> Cc: Fuad Tabba <tabba@google.com>
>>>> Fixes: a1319260bf62 ("arm64: KVM: Enable access to TRBE support for host")
>>>> Signed-off-by: Will Deacon <will@kernel.org>
>>>> ---
>>>>
>>>> NOTE: This is *untested* as I don't have a TRBE-capable device that can
>>>> run upstream but I noticed this by inspection when triaging occasional
>>>> hardware lockups on systems using a 6.12-based kernel with TRBE running
>>>> at the same time as a vCPU is loaded. This code has changed quite a bit
>>>> over time, so stable backports are not entirely straightforward.
>>>> Hopefully James/Leo/Suzuki can help us test if folks agree with the
>>>> general approach taken here.
>>>>
>>>>    arch/arm64/include/asm/kvm_host.h  |  1 +
>>>>    arch/arm64/kvm/hyp/nvhe/debug-sr.c | 36 ++++++++++++++++++++++--------
>>>>    2 files changed, 28 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>> index ac7f970c7883..a932cf043b83 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -746,6 +746,7 @@ struct kvm_host_data {
>>>>    		u64 pmscr_el1;
>>>>    		/* Self-hosted trace */
>>>>    		u64 trfcr_el1;
>>>> +		u64 trblimitr_el1;
>>>>    		/* Values of trap registers for the host before guest entry. */
>>>>    		u64 mdcr_el2;
>>>>    		u64 brbcr_el1;
>>>> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>>>> index 2a1c0f49792b..fd389a26bc59 100644
>>>> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>>>> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>>>> @@ -57,12 +57,27 @@ static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
>>>>    	write_sysreg_el1(new_trfcr, SYS_TRFCR);
>>>>    }
>>>>    -static bool __trace_needs_drain(void)
>>>> +static void __trace_drain_and_disable(void)
>>>>    {
>>>> -	if (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRBE))
>>>> -		return read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E;
>>>> +	u64 *trblimitr_el1 = host_data_ptr(host_debug_state.trblimitr_el1);
>>>>    -	return host_data_test_flag(TRBE_ENABLED);
>>>> +	*trblimitr_el1 = 0;
>>>> +
>>>> +	if (is_protected_kvm_enabled()) {
>>>> +		if (!host_data_test_flag(HAS_TRBE))
>>>> +			return;
>>>> +	} else {
>>>> +		if (!host_data_test_flag(TRBE_ENABLED))
>>>> +			return;
>>>> +	}
>>>> +
>>>> +	*trblimitr_el1 = read_sysreg_s(SYS_TRBLIMITR_EL1);
>>>> +	if (*trblimitr_el1 & TRBLIMITR_EL1_E) {
>>>> +		isb();
>>>> +		tsb_csync();
>>>> +		write_sysreg_s(0, SYS_TRBLIMITR_EL1);
>>>> +		isb();
>>
>> The TRBE driver might do an extra drain here as a workaround. Hard to
>> tell if it's actually required in this case (seems like probably not)
>> but it might be worth doing it anyway to avoid hitting the
>> issue. Especially if we add guest support later where some of the
>> affected registers might start being used.
> 
> Just to set the expectations: guest TRBE support is not happening
> until the architecture is fixed. It cannot reliably give a trace that
> includes emulated exceptions, and until then, no TRBE for you.
> 
>> See:
>>
>>      if (trbe_needs_drain_after_disable(cpudata))
>>          trbe_drain_buffer();
>>
>>
>>>> +	}
>>>
>>> Doesn't this mean we should be able to get rid of most of the TRFCR
>>> messing about that litters the entry/exit code and leave that to VHE
>>
>> Technically you could have ETMs that and are connected to sinks other
>> than TRBE. Unless you somehow switch off those sinks you still need to
>> do the TRFCR switching stuff.
>>
>>> only? And even then, I'm tempted to simply get rid of any sort of
>>> guest-only tracing, given that TRBE is not capable of representing
>>> exceptions that are synthesised by the host, making it the resulting
>>> traces useless.
>>
>> I haven't heard of anyone tracing a guest from the host, but until we
>> add support for guests to be able to trace themselves it's the only
>> way of doing it, so it could be useful.
> 
> But that's *not* working. If you trace EL1 only, even with a VHE host,
> the result is not usable.
> 

Do you mean not working because of the missing exceptions? I did a bit 
of testing before and the trace did seem somewhat usable to me. It had 
EL1 and EL0 atoms in there. All you need is the mmap records from the 
guest which you can get by running Perf in the guest and it's possible 
to decode it. Maybe it's not complete but I don't think all use cases 
require complete trace. AutoFDO for example just needs lots of small 
snippets of execution history.

>> Although all the messing
>> around with TRFCR before was from a request to disable guest trace
>> rather than enable it, as it was always on in nVHE.
> 
> I can't see how it could ever be "always on", unless you were happy to
> randomly corrupt memory?
> 

It was, and it was specifically the reason to add the TRFCR switching 
stuff. With a non-TRBE sink in nVHE mode.

VHE was always off and nVHE was always on. So we fixed both at the same 
time and made the include/exclude settings of the event respected 
wherever possible.

>>> I'm still trying to get my hands on a TRBE-enabled system that has
>>> some actual firmware tables (my O6 seems to have the HW, but no
>>> description of the required coresight infra).
>>
>> Leo has a guide, I haven't tried it myself yet but it should be
>> working. I'll send it to you.
> 
> Thanks. But why isn't that stuff publicly documented? Sight...
> 
> 	M.
> 

