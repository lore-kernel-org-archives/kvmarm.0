Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7E33164C2
	for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 15:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771254315; cv=none; b=dNRWPg7pr3xGiEheD1OFjkoeBTRkv1E0I8EMkrtEj0sSU7+6OsiCNcJ/eMwwj0yme3tQc8PtssXdm27rpSN4UhLA3BRSN2kJexbT33HtNOMbgna5iBf+Arm2AczLNac2Q4Of72rCrT2TJ8bmUNKoJvOoe6v4z2fyKOML08Jp19U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771254315; c=relaxed/simple;
	bh=n97rOY/nu46bFFS3ghFsbCJMdygfc2iUEhPc1qbo3d0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bkGG3bCeB+rUp6Lc2tW1w9Imep0iFEpgiGzBEO4Fnjos5GE2grkGHG3sznefM6+7vzJjkDXcHbp81Rq1FMF4Vz/ukwF2gOHqZaOUwpA3Mzn4EDGFh/pPfL+M17vm523VurN7rEkB4VjFQ541G8YT71huIyfQT/XQcQeVaH6HQDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=z1aZq/I/; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z1aZq/I/"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48371119eacso30383085e9.2
        for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 07:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771254312; x=1771859112; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=02WfyqRe/4/tsQg8rPoM0EAoH++yVH5XNO/2ica7SAA=;
        b=z1aZq/I/12FDoaE+ZHSaPWlEt5oBShspAIj1lhXvhxxwKanLWl95OD0wULMTwFoH0+
         x0IgXO7nxgx/VwuYX9pahQvQLc3zrs03Y91nR2AEvV/IJ9JUZICnuxZh9Kn8gwIWz+k/
         YbcUPwNvHSSMeh2fye0PmPn3ZxPHhCjEVrMqN+MLcB8HufH/KZJX2c6N0RngSYZ3oRtC
         T/OK9xhcSsint0V+ZHJiAcw0DO30rWK6h2RWIljrRvfjRD0KS2cPdqqbWrOx+DPx/ULY
         8xf18VK3ZHPM1T1U8vupUZaXTPN/UNlSj2bie3T/aAADI0bPCwkVkXdoYRhRsCn8VZy1
         6LHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771254312; x=1771859112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=02WfyqRe/4/tsQg8rPoM0EAoH++yVH5XNO/2ica7SAA=;
        b=K4G7/wo7w4gDIkePbuVOWLigzsnGIXbFzVqprROe4Nt9IPtbmWftcXqpJGGUDFLhQK
         dSHWwixt/cKaCwW60uOah3LvDZLaLMX8Dvdx00/dtNKgC/JT9XSHhLKLMWu3WE7x+Fpf
         i/vecLJCqjfgA5TE83RrOZWXRgi2Y/Ji4qCFCZBx/rQmXvm2uWrq8ZrxDYyBtTIjHj1d
         HhN6BLwu/C/6QkX0u1HGTGDeqFeHlcz0WxZBgQNsfIvu+3JS9fsbPO8I7bQ/lKSpDJhN
         dIW8blNpbCEhVA4+1kk7JrkK25j4ZNclAeazfk7cwyB95eUbXx1vroTOoFtYe0eC6LLz
         t43w==
X-Gm-Message-State: AOJu0Yyuut3L3J3YLm3uhfkGG9lCCkhnonxFhdkzOyskSBY25D97M9w4
	YFsp4qZjZ+bRkJg5tCkUWjRj5ixAQBfsQclUWIIRI2xjp1T8GsBHau6QFfHgVZcvpV0=
X-Gm-Gg: AZuq6aK4CerIqukk3rltokdlYcUw3z7W5sI3BSeyJeiIpsMGypyp/u9wUC5ybpi5nxW
	GzEYkUr0+qbcQhLgGoqJFNWPhA+Sr180yi6AsYLqfDo7OjbE98nXX1xc9HQSZt0XbG++wCWlkUh
	KuvY61gcLDF250I9gx5/dcm9mp0yQU/L/wggv+nPLLZvo7T6dBDudQssLB782DvU1RAqO67xjvP
	+xfZd0+mEARLyj/e9a3BgTjPL4oPz56O7NyuL2BIBqzmAARnFAsEA6xnF1TC+dCFCvuMMofzVgq
	ABbMKJyb3hhytbzaMiSylU+eFcqPAJhlovXKQ0SdjItxLPkU/3RIwmzSb4K77/8nb05x8il/KQJ
	omlI2k22aOrz0W0YUZBvxQXHd6M7UuMJH+6nmM0A4VAi8xYrwX24Y+eA8pisge30bb0mCdzIawj
	zABum/ws92qj3Y/ysPq3iuHu0SCuEZ
X-Received: by 2002:a05:600c:5246:b0:483:71f7:2782 with SMTP id 5b1f17b1804b1-48373a14406mr195601745e9.12.1771254312134;
        Mon, 16 Feb 2026 07:05:12 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796ac8209sm29350054f8f.30.2026.02.16.07.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 07:05:11 -0800 (PST)
Message-ID: <d2f6877a-534d-4862-a61c-fb3cb5b96618@linaro.org>
Date: Mon, 16 Feb 2026 15:05:10 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running
 in guest context
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, Oliver Upton <oupton@kernel.org>,
 Leo Yan <leo.yan@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Fuad Tabba <tabba@google.com>
References: <20260216130959.19317-1-will@kernel.org>
 <86a4x8bw38.wl-maz@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <86a4x8bw38.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 16/02/2026 2:29 pm, Marc Zyngier wrote:
> On Mon, 16 Feb 2026 13:09:59 +0000,
> Will Deacon <will@kernel.org> wrote:
>>
>> The nVHE world-switch code relies on zeroing TRFCR_EL1 to disable trace
>> generation in guest context when self-hosted TRBE is in use by the host.
>>
>> Per D3.2.1 ("Controls to prohibit trace at Exception levels"), clearing
>> TRFCR_EL1 means that trace generation is prohibited at EL1 and EL0 but
>> per R_YCHKJ the Trace Buffer Unit will still be enabled if
>> TRBLIMITR_EL1.E is set. R_SJFRQ goes on to state that, when enabled, the
>> Trace Buffer Unit can perform address translation for the "owning
>> exception level" even when it is out of context.
> 
> Great. So TRBE violates all the principles that we hold true in the
> architecture. Does SPE suffer from the same level of brokenness?
> 
>> Consequently, we can end up in a state where TRBE performs speculative
>> page-table walks for a host VA/IPA in guest/hypervisor context depending
>> on the value of MDCR_EL2.E2TB, which changes over world-switch. The
>> result appears to be a heady mixture of data corruption and hardware
>> lockups.
>>
>> Extend the TRBE world-switch code to clear TRBLIMITR_EL1.E after
>> draining the buffer, restoring the register on return to the host.
>>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Oliver Upton <oupton@kernel.org>
>> Cc: James Clark <james.clark@linaro.org>
>> Cc: Leo Yan <leo.yan@arm.com>
>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Cc: Fuad Tabba <tabba@google.com>
>> Fixes: a1319260bf62 ("arm64: KVM: Enable access to TRBE support for host")
>> Signed-off-by: Will Deacon <will@kernel.org>
>> ---
>>
>> NOTE: This is *untested* as I don't have a TRBE-capable device that can
>> run upstream but I noticed this by inspection when triaging occasional
>> hardware lockups on systems using a 6.12-based kernel with TRBE running
>> at the same time as a vCPU is loaded. This code has changed quite a bit
>> over time, so stable backports are not entirely straightforward.
>> Hopefully James/Leo/Suzuki can help us test if folks agree with the
>> general approach taken here.
>>
>>   arch/arm64/include/asm/kvm_host.h  |  1 +
>>   arch/arm64/kvm/hyp/nvhe/debug-sr.c | 36 ++++++++++++++++++++++--------
>>   2 files changed, 28 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index ac7f970c7883..a932cf043b83 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -746,6 +746,7 @@ struct kvm_host_data {
>>   		u64 pmscr_el1;
>>   		/* Self-hosted trace */
>>   		u64 trfcr_el1;
>> +		u64 trblimitr_el1;
>>   		/* Values of trap registers for the host before guest entry. */
>>   		u64 mdcr_el2;
>>   		u64 brbcr_el1;
>> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>> index 2a1c0f49792b..fd389a26bc59 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>> @@ -57,12 +57,27 @@ static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
>>   	write_sysreg_el1(new_trfcr, SYS_TRFCR);
>>   }
>>   
>> -static bool __trace_needs_drain(void)
>> +static void __trace_drain_and_disable(void)
>>   {
>> -	if (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRBE))
>> -		return read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E;
>> +	u64 *trblimitr_el1 = host_data_ptr(host_debug_state.trblimitr_el1);
>>   
>> -	return host_data_test_flag(TRBE_ENABLED);
>> +	*trblimitr_el1 = 0;
>> +
>> +	if (is_protected_kvm_enabled()) {
>> +		if (!host_data_test_flag(HAS_TRBE))
>> +			return;
>> +	} else {
>> +		if (!host_data_test_flag(TRBE_ENABLED))
>> +			return;
>> +	}
>> +
>> +	*trblimitr_el1 = read_sysreg_s(SYS_TRBLIMITR_EL1);
>> +	if (*trblimitr_el1 & TRBLIMITR_EL1_E) {
>> +		isb();
>> +		tsb_csync();
>> +		write_sysreg_s(0, SYS_TRBLIMITR_EL1);
>> +		isb();

The TRBE driver might do an extra drain here as a workaround. Hard to 
tell if it's actually required in this case (seems like probably not) 
but it might be worth doing it anyway to avoid hitting the issue. 
Especially if we add guest support later where some of the affected 
registers might start being used. See:

     if (trbe_needs_drain_after_disable(cpudata))
         trbe_drain_buffer();


>> +	}
> 
> Doesn't this mean we should be able to get rid of most of the TRFCR
> messing about that litters the entry/exit code and leave that to VHE

Technically you could have ETMs that and are connected to sinks other 
than TRBE. Unless you somehow switch off those sinks you still need to 
do the TRFCR switching stuff.

> only? And even then, I'm tempted to simply get rid of any sort of
> guest-only tracing, given that TRBE is not capable of representing
> exceptions that are synthesised by the host, making it the resulting
> traces useless.

I haven't heard of anyone tracing a guest from the host, but until we 
add support for guests to be able to trace themselves it's the only way 
of doing it, so it could be useful. Although all the messing around with 
TRFCR before was from a request to disable guest trace rather than 
enable it, as it was always on in nVHE.

> 
> I'm still trying to get my hands on a TRBE-enabled system that has
> some actual firmware tables (my O6 seems to have the HW, but no
> description of the required coresight infra).

Leo has a guide, I haven't tried it myself yet but it should be working. 
I'll send it to you.

James

> 
> Thanks,
> 
> 	M.
> 

