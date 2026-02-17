Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB3B27B357
	for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 09:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771319888; cv=none; b=jWqT+PqzFaIr5MyEENaQ7ni1b0Qn8hzBrDe/4LXpA8IHcGAuoeM/7E2ZAikt9MDGzq9m2Z/nXoIY1R2cpEIiRHPJf0RHCAqiodGU54dl0UsyCFK7rjZew3LRBJmXOD2q+KIFxiVR6jPw5COlsMkCwok2MaW4QryRc4pGZomdrE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771319888; c=relaxed/simple;
	bh=Ma+Er1tQX/I8bX23rIKiFsOMW/WgS1+I7nArh6KA7WQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YqJsX5YhL5ZmDyV1XE6YeI8QJVt0vMOl1Zacr19S8fcXTxEcJVDRcZuYePJAJoUlO1KE7UAexBStzInIcYRozcWG8f83wa+vQbDz06fA0gqPFB48lUk9CFq8SQQJOCKOjcC1XWDAEag5gTdFk1YoyZ4GUtH+ASK3SoRPO9AagFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cxfzo4U1; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cxfzo4U1"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48379a42f76so24078695e9.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 01:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771319885; x=1771924685; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OlcXTAXHsnl/WtrFqR8o0BlGKwsZMnh0pz3tx1Nme4Q=;
        b=cxfzo4U17YMAJKPdAdCOgQQ290fRD1p8bdGCKx8S9/818PjpONZpzAA+iR3sO79WkJ
         wx0wtD30AWynj18McBsXccqCqEnXp6c5zO8XB5HHt/0Rre9ERboP8K2L6+5BpN4J5PzF
         JOeSQl68NmvfJ5vPht4UhyB3uryfiz7CTAk8P4Y267WFstKFvlNMztJYtX1RA28V+PbW
         XfHOvT6nEiX+xml2/EdRAUOpX7dqLZ8EbgFBV8YA5fPsTNig1SkRtMCdLdS6FfGP9M8u
         3jbRw7HsWJhfUfeFjwQd/SBDgqYnmvDqK8NVXIMXAseH4R3YeSYKc3e1bt4Tw2LNL/Pz
         GevQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771319885; x=1771924685;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OlcXTAXHsnl/WtrFqR8o0BlGKwsZMnh0pz3tx1Nme4Q=;
        b=FW0vy4K66wymU99UFBziIOJ7CMN0YivWprJ42ctxcLLKPDImGgtOsdbmIQIbLobHd3
         LdfO2pP/TllK3lPg2IGPiIFevq4+glhGik9seqBBclZ6r2WQI3M9kSRapdHdsZvetRyF
         JsgaJZecCQcMhXMI4LtGRjJKS7Y9fdBzAT54nF7fcRZX8NNQ6tXXpf+LNLhNdsP+irr9
         2MR1CL0OGvuHc3ZEZp8uCpMNwqj/NaWGhRRg2oy3H3mMNvotHUgl2gWDLDczHyAB6liu
         C2p76qIpKi72ffVDry3rT9IyXpHehYD2+Av/nnPwFzwkLirv6c8Zu28I0TDwBSN0W1cq
         ZlJA==
X-Gm-Message-State: AOJu0YzZ05x7fKIF0L/Wd9ocUkvX8kmjQdhZJwKHwCschEZpP+xWtHwF
	c22VfNwmsWUnfo97P5uRranEMWDo9/n4zTiJMNUD19FVD6L0CZbMIbJxpFSTfX0GE2k=
X-Gm-Gg: AZuq6aI698Qfu4QPpUGMQbXEH81h8gmecY41i3oKhaybwVrifbRqQyPWvNc5oPcZL3D
	jbP2Rm539oORErq1r7T9hheSqxWkW8uyYtRDqM5ELWyOrCnw+C451ACYJ+kyUpKiwVbvZzySzbQ
	0YemT6hYgkDb/KC5uDsrRieE/RdyAQTG743sLjMDvcl+lpFz4T6hAS80h18IcabGzgVBN4wefDq
	i1hu1I2proPOXS7CNyMMbq+tZQT/6zCkNCkzk8qZRR3fwV/0ca8GvO4XbBqeCl9VlW37fFzX9xf
	xw27H3bJlmMHCayAz101KwJW7p6nzKhtyyLT8lSG6MnE5Z62gET8VkV2lYW6QC8BPBFyqhJ9png
	E/CwOAtVk/dLzk6wl5kylG6GrEhVe0+oO9WoXw57Twy2s6DHr2vQ8+OYsgmYtBCaQfgzEktRZGU
	bztw1heYzlyykUBQb3DiQ7b+qVpqjU
X-Received: by 2002:a05:600c:46c9:b0:46e:4a13:e6c6 with SMTP id 5b1f17b1804b1-48379bfd71cmr160954025e9.19.1771319884602;
        Tue, 17 Feb 2026 01:18:04 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4836aa0847asm543941725e9.3.2026.02.17.01.18.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 01:18:04 -0800 (PST)
Message-ID: <e36150c7-9098-495a-b0f1-626b38c0c3d0@linaro.org>
Date: Tue, 17 Feb 2026 09:18:03 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Leo Yan <leo.yan@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>
References: <20260216130959.19317-1-will@kernel.org>
 <878e304e-4162-4981-8125-bd4f67ba9dd5@linaro.org>
 <aZNOcv2XxTrrrEnU@willie-the-truck>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <aZNOcv2XxTrrrEnU@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 16/02/2026 5:05 pm, Will Deacon wrote:
> On Mon, Feb 16, 2026 at 03:13:54PM +0000, James Clark wrote:
>>
>>
>> On 16/02/2026 1:09 pm, Will Deacon wrote:
>>> The nVHE world-switch code relies on zeroing TRFCR_EL1 to disable trace
>>> generation in guest context when self-hosted TRBE is in use by the host.
>>>
>>> Per D3.2.1 ("Controls to prohibit trace at Exception levels"), clearing
>>> TRFCR_EL1 means that trace generation is prohibited at EL1 and EL0 but
>>> per R_YCHKJ the Trace Buffer Unit will still be enabled if
>>> TRBLIMITR_EL1.E is set. R_SJFRQ goes on to state that, when enabled, the
>>> Trace Buffer Unit can perform address translation for the "owning
>>> exception level" even when it is out of context.
>>>
>>> Consequently, we can end up in a state where TRBE performs speculative
>>> page-table walks for a host VA/IPA in guest/hypervisor context depending
>>> on the value of MDCR_EL2.E2TB, which changes over world-switch. The
>>> result appears to be a heady mixture of data corruption and hardware
>>> lockups.
>>>
>>> Extend the TRBE world-switch code to clear TRBLIMITR_EL1.E after
>>> draining the buffer, restoring the register on return to the host.
>>>
>>> Cc: Marc Zyngier <maz@kernel.org>
>>> Cc: Oliver Upton <oupton@kernel.org>
>>> Cc: James Clark <james.clark@linaro.org>
>>> Cc: Leo Yan <leo.yan@arm.com>
>>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Cc: Fuad Tabba <tabba@google.com>
>>> Fixes: a1319260bf62 ("arm64: KVM: Enable access to TRBE support for host")
>>> Signed-off-by: Will Deacon <will@kernel.org>
>>> ---
>>>
>>> NOTE: This is *untested* as I don't have a TRBE-capable device that can
>>> run upstream but I noticed this by inspection when triaging occasional
>>> hardware lockups on systems using a 6.12-based kernel with TRBE running
>>> at the same time as a vCPU is loaded. This code has changed quite a bit
>>> over time, so stable backports are not entirely straightforward.
>>> Hopefully James/Leo/Suzuki can help us test if folks agree with the
>>> general approach taken here.
>>>
>>>    arch/arm64/include/asm/kvm_host.h  |  1 +
>>>    arch/arm64/kvm/hyp/nvhe/debug-sr.c | 36 ++++++++++++++++++++++--------
>>>    2 files changed, 28 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index ac7f970c7883..a932cf043b83 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -746,6 +746,7 @@ struct kvm_host_data {
>>>    		u64 pmscr_el1;
>>>    		/* Self-hosted trace */
>>>    		u64 trfcr_el1;
>>> +		u64 trblimitr_el1;
>>>    		/* Values of trap registers for the host before guest entry. */
>>>    		u64 mdcr_el2;
>>>    		u64 brbcr_el1;
>>> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>>> index 2a1c0f49792b..fd389a26bc59 100644
>>> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>>> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>>> @@ -57,12 +57,27 @@ static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
>>>    	write_sysreg_el1(new_trfcr, SYS_TRFCR);
>>>    }
>>> -static bool __trace_needs_drain(void)
>>> +static void __trace_drain_and_disable(void)
>>>    {
>>> -	if (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRBE))
>>> -		return read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E;
>>> +	u64 *trblimitr_el1 = host_data_ptr(host_debug_state.trblimitr_el1);
>>> -	return host_data_test_flag(TRBE_ENABLED);
>>> +	*trblimitr_el1 = 0;
>>> +
>>> +	if (is_protected_kvm_enabled()) {
>>> +		if (!host_data_test_flag(HAS_TRBE))
>>> +			return;
>>> +	} else {
>>> +		if (!host_data_test_flag(TRBE_ENABLED))
>>> +			return;
>>> +	}
>>> +
>>> +	*trblimitr_el1 = read_sysreg_s(SYS_TRBLIMITR_EL1);
>>> +	if (*trblimitr_el1 & TRBLIMITR_EL1_E) {
>>> +		isb();
>>> +		tsb_csync();
>>> +		write_sysreg_s(0, SYS_TRBLIMITR_EL1);
>>> +		isb();
>>> +	}
>>>    }
>>>    static bool __trace_needs_switch(void)
>>> @@ -79,15 +94,18 @@ static void __trace_switch_to_guest(void)
>>>    	__trace_do_switch(host_data_ptr(host_debug_state.trfcr_el1),
>>>    			  *host_data_ptr(trfcr_while_in_guest));
>>> -
>>> -	if (__trace_needs_drain()) {
>>> -		isb();
>>> -		tsb_csync();
>>> -	}
>>> +	__trace_drain_and_disable();
>>>    }
>>>    static void __trace_switch_to_host(void)
>>>    {
>>> +	u64 trblimitr_el1 = *host_data_ptr(host_debug_state.trblimitr_el1);
>>> +
>>> +	if (trblimitr_el1 & TRBLIMITR_EL1_E) {
>>> +		write_sysreg_s(trblimitr_el1, SYS_TRBLIMITR_EL1);
>>
>> Will this restore a stale value if you do kvm_enable_trbe() then later
>> kvm_disable_trbe()? Looks like the read and save will be skipped unless
>> host_data_test_flag(TRBE_ENABLED) is true, so it will never save a disabled
>> value.
> 
> __trace_drain_and_disable() sets the saved limit to 0 if TRBE_ENABLE is
> not set, so this shouldn't do anything in that case. Or did I
> misunderstand your scenario?
> 

No you're right. I saw the early return for !TRBE_ENABLED and thought 
things only happened after that. But the zeroing is before, so it's ok.

>> kvm_disable_trbe() might need to clear host_debug_state.trblimitr_el1.
> 
> pKVM can't rely on that thing being called, so the context switch still
> needs to be self-contained there.
> 
> Will

