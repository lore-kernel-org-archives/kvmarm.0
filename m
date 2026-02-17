Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E50333291D
	for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 12:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771330819; cv=none; b=jy5pnoou7dppScEGIyxkeN6T0uWcItdYAkzjxUkwVjD5TZ0sFDdTcImRNZrTk7WN/cDspN7LIODKze7N4M+5EwmltLKYevRBRAENtrF5xjH1F9btTQFgnrnH3pTzuRoWPgrKXwTAkYwnyOmQX64/WXM6BA3oLsebU/Ji7M7u6i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771330819; c=relaxed/simple;
	bh=OtbSnA4gH1uBOR5MWVtToTNE8zdn6NpMSHY9VVt/83Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k+Vtb+3qXZ9NFGcCc7scAlBOOWsfNjW48e+BAxfgfWOnRd9vm5l3e4qENtd/VKJqHp5AgwAhLB0nlPPEVKYaBQH4C9PflNIuBRhXOdemPcqbLW61qSTlKuH6SlIuc2+6fLgdexGbjlBV8591g+B5ioZugVmV17fdv7vGtMfxpVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q+i84jXm; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q+i84jXm"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48374014a77so36195085e9.3
        for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 04:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771330816; x=1771935616; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aOe3kSGGnfmWMYMCFtCCbPJWh6hysTa5iqIZJm9rsGE=;
        b=q+i84jXmpsCDPGISwyV3IER9CpyJrt50sY61Ofu2piCbUdzrAD1w3PwDEa1EUO3ZWn
         hRFeIJ0TqXsN+h8azt7S3dcjlpUju0zVzeeknIPcc01KS25YHvjWR0sqZJnoe2ifrea3
         ufXU0LuLQZSv1Rv05sgb9a1mTXntLnaZyhrdVOpWgPTIVENV4J5jHHZxWWLOlSZMRccb
         UqHlOpu4v2T0nKODiuREdD8iaZYLlxDFcNkgANv0GS1NWP6cUaSil/IyCjFRGV0hp0el
         V82ZE6ZBHv8MmsYHjTwWMcoe4TdkZ8AKRR+4B9skIdBYEU2sIDbC144FA1hhJSQIxDh7
         0QVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771330816; x=1771935616;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aOe3kSGGnfmWMYMCFtCCbPJWh6hysTa5iqIZJm9rsGE=;
        b=MUx9KGWok9F9WdI/PLSFtNtDZUfBkkCCKQNnqAskGjD/O8HpudD52mKTlFaiO6m51C
         cxNxFmldIpyPqL2Xi8+DdREcte5jJYqoqUouHExii64bLBREE3WtvMwRSuqHDzuJQ5gU
         KIdx6ldgHsaImBJ9kH+zpGjLz1GxR6IGHJi7imqOI/B9UnfDLenImwSuSGi+dAkke+HY
         KS8GIHYRp0L4JGSIPfFo0AR5K9mIR6jiHwnOdiQu+iNnjMBkU9QgOG/nKKYrTiehlt4G
         g8KF0VXrR6I69Q9uRGvnP2Uv19Z7EmW0t+Dtxt8kGWAT0paPE4fY2NSqT4A5TyGyDW2f
         hE5w==
X-Gm-Message-State: AOJu0YyeqfNc0DvonHCmbt+bSdoruexBl/rMft/MAZDJEn3LlaT4SEO8
	r2kyKTwT51U9WMA033r1d/cmLpsLPSkSshT1laYDqHnyf4thwfSv2ouoB9slzg76+hI=
X-Gm-Gg: AZuq6aLV3ohv2EbQKWVJ1in6nx0q5KWoCGxWUWOlOzH5j586YTf4bVQtknYwvgSI/Ru
	T4UHo67N5ONZRECfgvr8jPATAtmjOmV8bBBFXXLSNQ6n5Xt1mq4IyCSrmZwCGuFC4J948WDAxu3
	wG0JT+tUotASiwXl5DlJkwEIbCyYDERRJ0h8on05ZgKg1XndBsP9eLffQfNtXAIc/Rqmt6CdokT
	u/AGMGJ273ZP9Uzu7xPPhF6h6poALL8YP3SpAt/IG/hn7I/yGjcdggXhf+YbiXYZdvlDJvoXOYZ
	rgRxGD1yHesNQYg20OHfQS3owk+jAPy3yHmdqnHIIk7qGWVvFtaYYySH0hJc3W1BPvKQpS+1nsY
	ttJfn8b1BhWTu/OOxmF1Y/oAai0rLqfVkq90HncVErbipOYE78KyF0u5paUraLrCzIvb5Rk0ecx
	BWLK+wRDz7DDn7XivR4vTAYAiFlT5G
X-Received: by 2002:a05:600c:6211:b0:477:93f7:bbc5 with SMTP id 5b1f17b1804b1-48373a09741mr246802455e9.10.1771330816424;
        Tue, 17 Feb 2026 04:20:16 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835dd0deeasm468949755e9.12.2026.02.17.04.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 04:20:15 -0800 (PST)
Message-ID: <cda4e111-29cc-481c-aee2-811f4178f54b@linaro.org>
Date: Tue, 17 Feb 2026 12:20:14 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
To: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, Oliver Upton <oupton@kernel.org>,
 Leo Yan <leo.yan@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Fuad Tabba <tabba@google.com>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org> <aZNUqONyOUVd0opW@willie-the-truck>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <aZNUqONyOUVd0opW@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 16/02/2026 5:32 pm, Will Deacon wrote:
> On Mon, Feb 16, 2026 at 02:29:31PM +0000, Marc Zyngier wrote:
>> On Mon, 16 Feb 2026 13:09:59 +0000,
>> Will Deacon <will@kernel.org> wrote:
>>>
>>> The nVHE world-switch code relies on zeroing TRFCR_EL1 to disable trace
>>> generation in guest context when self-hosted TRBE is in use by the host.
>>>
>>> Per D3.2.1 ("Controls to prohibit trace at Exception levels"), clearing
>>> TRFCR_EL1 means that trace generation is prohibited at EL1 and EL0 but
>>> per R_YCHKJ the Trace Buffer Unit will still be enabled if
>>> TRBLIMITR_EL1.E is set. R_SJFRQ goes on to state that, when enabled, the
>>> Trace Buffer Unit can perform address translation for the "owning
>>> exception level" even when it is out of context.
>>
>> Great. So TRBE violates all the principles that we hold true in the
>> architecture. Does SPE suffer from the same level of brokenness?
>>
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
>>>   arch/arm64/include/asm/kvm_host.h  |  1 +
>>>   arch/arm64/kvm/hyp/nvhe/debug-sr.c | 36 ++++++++++++++++++++++--------
>>>   2 files changed, 28 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index ac7f970c7883..a932cf043b83 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -746,6 +746,7 @@ struct kvm_host_data {
>>>   		u64 pmscr_el1;
>>>   		/* Self-hosted trace */
>>>   		u64 trfcr_el1;
>>> +		u64 trblimitr_el1;
>>>   		/* Values of trap registers for the host before guest entry. */
>>>   		u64 mdcr_el2;
>>>   		u64 brbcr_el1;
>>> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>>> index 2a1c0f49792b..fd389a26bc59 100644
>>> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>>> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>>> @@ -57,12 +57,27 @@ static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
>>>   	write_sysreg_el1(new_trfcr, SYS_TRFCR);
>>>   }
>>>   
>>> -static bool __trace_needs_drain(void)
>>> +static void __trace_drain_and_disable(void)
>>>   {
>>> -	if (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRBE))
>>> -		return read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E;
>>> +	u64 *trblimitr_el1 = host_data_ptr(host_debug_state.trblimitr_el1);
>>>   
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
>>
>> Doesn't this mean we should be able to get rid of most of the TRFCR
>> messing about that litters the entry/exit code and leave that to VHE
>> only?
> 
> I'm not sure we can get rid of an awful lot: if the host is using TRBE,
> then we still need to stop trace generation, drain the buffer and
> disable the buffer. Or are you thinking of some other TRFCR accesses?
> 
> Looking at the TRBE driver, I _think_ the idea is that the trace
> hardware can generate trace to ETM/Coresight instead of memory in some
> cases and so you can enable it at boot time or via sysfs and then
> profile the whole machine, presumably using an expensive external box +
> cable or via some other coresight "sink" component. But I'm really
> guessing based on the driver; James and Leo will know for sure.

Exactly, there are other sink types. For example ETF has SRAM or ETR 
uses physical addresses.

> 
> I've tried (and failed) to reconcile the above with what is written in
> the Arm ARM regarding self-hosted trace with TRBE.
> 
>> And even then, I'm tempted to simply get rid of any sort of
>> guest-only tracing, given that TRBE is not capable of representing
>> exceptions that are synthesised by the host, making it the resulting
>> traces useless.
> 
> I think that effectively means reverting the series merged from here:
> 
> https://lore.kernel.org/all/20250106142446.628923-1-james.clark@linaro.org/
> 
> but then we still need to clear TRBLIMITR_EL1.E.
> 
> Will

Removing that series would actually have the effect of turning guest 
trace on in nVHE for non-TRBE sinks. The reason for implementing the 
filtering was to turn guest trace off because a user didn't want to see it.

