Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828A2337BB3
	for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 11:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771587737; cv=none; b=HM91ZWhSGnR/yaQ4qYuBbD3Wl7mXcPywkDd8SiG1hIM16VGsEfY+Dc0gaW4c5aDLGcvozJPOhM1Hz8C5T2MObWGVvp2zzXpHPi4O1GEPW8vyRplgduqqvAIAkRFes2P16c47jJVSpRz2pGZTjkNiiKkGNKFyj3RtOf4KPmnrdmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771587737; c=relaxed/simple;
	bh=S0OGi7FU8nzAw2MV0odrYBKOe8HcvXR6TSCDmIie5uQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hhOjtC0FFZxf5clY8Xu6LoLx3HGSYLPpZIT8s+oX34+AXZb60VZBhomVQQsKgwfe/luW4bU3ycTZLW+Tkr1JumqtSWUcvSfceAn4lmRxNiD2i5nE0DdQ0YvzdJHOrrSF4kVDzw5WQQ3usjwDDK5HmQIUQIT+5GuCUIs5L4YigKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Pg8znanb; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Pg8znanb"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4359a16a400so1776083f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 03:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771587734; x=1772192534; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d++cm3zDVsP1AhhvUlfKtz1rPN4rkrCy4TnbVllN/NA=;
        b=Pg8znanbDrExD8/yKluskCKn1n+0hfT/6gNv4ArkpCBO0CfHTPMO3WlsNMsmdlAkzR
         VclLOy7R/Vt414cNlJfGlPOax5ATEeuqJkKmVjXtP0jwqzFyT4NN5mXaCYmM79dnRI5d
         UfVtfQYvjAIuFN8QbQxM5iCKQFo3rInu8Uw2y+yfl4GhB5kwlPIvk3sxsDf8t2DRf+K8
         Tsvo3wQHSgXAzJWpFNrYOVMWAheV1V9j5pdpe0ZMKyLx01BJovHWqLVWaCxY3WsywFDV
         YuJZLFOSD+IE+5dasc/Zi8/+6RA8o80jgMfQ5q0/MX7IZUTe2WhEul3YtvYIBAiygej2
         8EXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771587734; x=1772192534;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d++cm3zDVsP1AhhvUlfKtz1rPN4rkrCy4TnbVllN/NA=;
        b=K2hfVVWto8L3wyKfGHISM2GagIb/s8yWz45QjvL6POQ/Px0khnAM0Mpr4kLN4kJycT
         A3OxFMjlwTjLKKi3lqhDWf50tv4Fm3Lxgr5haXJHh9zUTyBvwfF33Guy6I1IEbxvAIe/
         nUkg/Mb5lV4QygPMv+wmX4tv7iq4pjkfWdvfbR1cqgftm9ICD/DWixMLuprKJWVNagQo
         +oEuXPKQf9rAJzB9VDt7/M0M4+XzykbVbWJey9rYQyTTlZV1jquXdRvDfEtDa9rFE7nQ
         KeJ9QyYYhvKfwiXtu0g3qNFXX9NyFZklJtUvU+RvgsVNxp9H6PJmAQ6OwNuYm/RmfyEv
         J6Zw==
X-Forwarded-Encrypted: i=1; AJvYcCVtO0OzSfjKE6YxwqnfTwAcheAPpSQPNB3iw9vFebX2TpkprV/tit6DU7rL3p4wJQClcz0OZEE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzFlHakUZ+/7c9CV3yBOSjpIvLQD1ULiA8/wTPHWDAyaMtCPX45
	i0KbkA4DpHTefoOBpQbTV3+qa/EuyP9/GdJZzszyg8Q4F9FVkZuQT3NfJo/FgkVIKco=
X-Gm-Gg: AZuq6aJ21COu5ZXZD5+ynxdm9W6g26v9lgT6+muSmL459ommFft5R+8ModIVhFm3n1Z
	vc6xfQv4CoCp62zaVUSTxFXyhlRSpY/2FdrWxfOHlqzQWO8Zey2jC/aC4RULrOAbkXNlAwshyWR
	v9s76ujhYVjgLCxS2rde2Qak8RVXaR4qVcmTsb7nab0sAFNt3p2nV2r2zh9YH5c23/FVlyTGK2E
	/cFmOxwq9Vqj+klMk8XU1LaUSweOvmcZ6aPCRd1QnvLLXgBrIu/kZ/W0ph7ckq3vwy2ZrvEIqoD
	D0k6ELFzgUp0+wDXi82NSbQxhMtPD9U/ZHR7WXx/iB/lyBuwdo8fm1UFfJgU1JCAJTimlrZD0TL
	8YIgjXwt50MfVH+ybAEV398ynLreKwNnYNi6bjEuNvbd8/7/dgKKAeqI7uRez2N/LS0/+3eezL5
	cmZdbdkv8zJoFmy50arQakza0c5MLO
X-Received: by 2002:a5d:64e9:0:b0:432:5b81:483 with SMTP id ffacd0b85a97d-43958e0a920mr15216873f8f.24.1771587733424;
        Fri, 20 Feb 2026 03:42:13 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796abe3b3sm62999985f8f.18.2026.02.20.03.42.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Feb 2026 03:42:13 -0800 (PST)
Message-ID: <22de3d44-b266-4ba3-af3a-67159c9742d1@linaro.org>
Date: Fri, 20 Feb 2026 11:42:11 +0000
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
 <076e013a-b66d-4985-9709-734d7184ad72@linaro.org>
 <867bscbpmp.wl-maz@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <867bscbpmp.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 16/02/2026 4:49 pm, Marc Zyngier wrote:
> On Mon, 16 Feb 2026 16:10:14 +0000,
> James Clark <james.clark@linaro.org> wrote:
>>
>>
>>
>> On 16/02/2026 3:51 pm, Marc Zyngier wrote:
>>> On Mon, 16 Feb 2026 15:05:10 +0000,
>>> James Clark <james.clark@linaro.org> wrote:
>>>>
>>>>
>>>>
>>>> On 16/02/2026 2:29 pm, Marc Zyngier wrote:
>>>>> On Mon, 16 Feb 2026 13:09:59 +0000,
>>>>> Will Deacon <will@kernel.org> wrote:
>>>>>>
>>>>>> The nVHE world-switch code relies on zeroing TRFCR_EL1 to disable trace
>>>>>> generation in guest context when self-hosted TRBE is in use by the host.
>>>>>>
>>>>>> Per D3.2.1 ("Controls to prohibit trace at Exception levels"), clearing
>>>>>> TRFCR_EL1 means that trace generation is prohibited at EL1 and EL0 but
>>>>>> per R_YCHKJ the Trace Buffer Unit will still be enabled if
>>>>>> TRBLIMITR_EL1.E is set. R_SJFRQ goes on to state that, when enabled, the
>>>>>> Trace Buffer Unit can perform address translation for the "owning
>>>>>> exception level" even when it is out of context.
>>>>>
>>>>> Great. So TRBE violates all the principles that we hold true in the
>>>>> architecture. Does SPE suffer from the same level of brokenness?
>>>>>
>>>>>> Consequently, we can end up in a state where TRBE performs speculative
>>>>>> page-table walks for a host VA/IPA in guest/hypervisor context depending
>>>>>> on the value of MDCR_EL2.E2TB, which changes over world-switch. The
>>>>>> result appears to be a heady mixture of data corruption and hardware
>>>>>> lockups.
>>>>>>
>>>>>> Extend the TRBE world-switch code to clear TRBLIMITR_EL1.E after
>>>>>> draining the buffer, restoring the register on return to the host.
>>>>>>
>>>>>> Cc: Marc Zyngier <maz@kernel.org>
>>>>>> Cc: Oliver Upton <oupton@kernel.org>
>>>>>> Cc: James Clark <james.clark@linaro.org>
>>>>>> Cc: Leo Yan <leo.yan@arm.com>
>>>>>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>>>> Cc: Fuad Tabba <tabba@google.com>
>>>>>> Fixes: a1319260bf62 ("arm64: KVM: Enable access to TRBE support for host")
>>>>>> Signed-off-by: Will Deacon <will@kernel.org>
>>>>>> ---
>>>>>>
>>>>>> NOTE: This is *untested* as I don't have a TRBE-capable device that can
>>>>>> run upstream but I noticed this by inspection when triaging occasional
>>>>>> hardware lockups on systems using a 6.12-based kernel with TRBE running
>>>>>> at the same time as a vCPU is loaded. This code has changed quite a bit
>>>>>> over time, so stable backports are not entirely straightforward.
>>>>>> Hopefully James/Leo/Suzuki can help us test if folks agree with the
>>>>>> general approach taken here.
>>>>>>
>>>>>>     arch/arm64/include/asm/kvm_host.h  |  1 +
>>>>>>     arch/arm64/kvm/hyp/nvhe/debug-sr.c | 36 ++++++++++++++++++++++--------
>>>>>>     2 files changed, 28 insertions(+), 9 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>>>> index ac7f970c7883..a932cf043b83 100644
>>>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>>>> @@ -746,6 +746,7 @@ struct kvm_host_data {
>>>>>>     		u64 pmscr_el1;
>>>>>>     		/* Self-hosted trace */
>>>>>>     		u64 trfcr_el1;
>>>>>> +		u64 trblimitr_el1;
>>>>>>     		/* Values of trap registers for the host before guest entry. */
>>>>>>     		u64 mdcr_el2;
>>>>>>     		u64 brbcr_el1;
>>>>>> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>>>>>> index 2a1c0f49792b..fd389a26bc59 100644
>>>>>> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>>>>>> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>>>>>> @@ -57,12 +57,27 @@ static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
>>>>>>     	write_sysreg_el1(new_trfcr, SYS_TRFCR);
>>>>>>     }
>>>>>>     -static bool __trace_needs_drain(void)
>>>>>> +static void __trace_drain_and_disable(void)
>>>>>>     {
>>>>>> -	if (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRBE))
>>>>>> -		return read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E;
>>>>>> +	u64 *trblimitr_el1 = host_data_ptr(host_debug_state.trblimitr_el1);
>>>>>>     -	return host_data_test_flag(TRBE_ENABLED);
>>>>>> +	*trblimitr_el1 = 0;
>>>>>> +
>>>>>> +	if (is_protected_kvm_enabled()) {
>>>>>> +		if (!host_data_test_flag(HAS_TRBE))
>>>>>> +			return;
>>>>>> +	} else {
>>>>>> +		if (!host_data_test_flag(TRBE_ENABLED))
>>>>>> +			return;
>>>>>> +	}
>>>>>> +
>>>>>> +	*trblimitr_el1 = read_sysreg_s(SYS_TRBLIMITR_EL1);
>>>>>> +	if (*trblimitr_el1 & TRBLIMITR_EL1_E) {
>>>>>> +		isb();
>>>>>> +		tsb_csync();
>>>>>> +		write_sysreg_s(0, SYS_TRBLIMITR_EL1);
>>>>>> +		isb();
>>>>
>>>> The TRBE driver might do an extra drain here as a workaround. Hard to
>>>> tell if it's actually required in this case (seems like probably not)
>>>> but it might be worth doing it anyway to avoid hitting the
>>>> issue. Especially if we add guest support later where some of the
>>>> affected registers might start being used.
>>>
>>> Just to set the expectations: guest TRBE support is not happening
>>> until the architecture is fixed. It cannot reliably give a trace that
>>> includes emulated exceptions, and until then, no TRBE for you.
>>>
>>>> See:
>>>>
>>>>       if (trbe_needs_drain_after_disable(cpudata))
>>>>           trbe_drain_buffer();
>>>>
>>>>
>>>>>> +	}
>>>>>
>>>>> Doesn't this mean we should be able to get rid of most of the TRFCR
>>>>> messing about that litters the entry/exit code and leave that to VHE
>>>>
>>>> Technically you could have ETMs that and are connected to sinks other
>>>> than TRBE. Unless you somehow switch off those sinks you still need to
>>>> do the TRFCR switching stuff.
>>>>
>>>>> only? And even then, I'm tempted to simply get rid of any sort of
>>>>> guest-only tracing, given that TRBE is not capable of representing
>>>>> exceptions that are synthesised by the host, making it the resulting
>>>>> traces useless.
>>>>
>>>> I haven't heard of anyone tracing a guest from the host, but until we
>>>> add support for guests to be able to trace themselves it's the only
>>>> way of doing it, so it could be useful.
>>>
>>> But that's *not* working. If you trace EL1 only, even with a VHE host,
>>> the result is not usable.
>>>
>>
>> Do you mean not working because of the missing exceptions? I did a bit
>> of testing before and the trace did seem somewhat usable to me. It had
>> EL1 and EL0 atoms in there.
> 
> Sure. Now try to look at what that means for NV, where all the
> EL1->EL2 exceptions are emulated, where all the EL2->EL1 exception
> returns are emulated.
> 
> What does it give you? A bag of nonsense.
> 
> Same thing for EL2->EL0, by the way, so you can't even correctly
> profile an EL0 program that performs a syscall, or that gets
> interrupted. And while without NV, these exceptions are rare, having a
> trace that is unreliable has the potential of being worse than no
> trace at all.

If there are issues with NV perhaps we can skip it for the initial trace 
virtualisation implementation? I'm not familiar with it but isn't NV 
still an experimental feature anyway? I can't imagine actual users who 
want to do tracing in guests would accept that they can't do tracing on 
a non-NV guest because there is something that doesn't work in NV.

Also do you have an example of these exceptions that you mean without NV 
so I can have a look? I have a hack that allows basic use of ETE/TRBE in 
VHE mode and did some recordings of syscalls and they end up looking ok 
in the decoded trace:

  $ perf record -e cs_etm/timestamp=0/u -C 0 perf bench syscall basic
  $ perf script

Results in:

bench_syscall_common+0xb4 => aaaaaffcafe0 getppid@plt+0x0
getppid@plt+0xc           => ffffa78980c0 getppid+0x0 (libc.so.6)
getppid+0x8 (libc.so.6)   =>           0 [unknown] ([unknown])
[unknown] ([unknown])     => ffffa78980cc getppid+0xc (libc.so.6)
getppid+0xc (libc.so.6)   => aaaab0076564 bench_syscall_common+0xb8
bench_syscall_common+0xb8 => aaaab00765d8 bench_syscall_common+0x12c

Which shows jumping from the bench function to getppid(), then doing the 
syscall into the kernel which is "0 [unknown]" because I recorded with 
/u. Then back to the bench loop again.

> 
> Until the architecture grows a way for KVM to inject the missing
> information into the trace, TRBE support for guest will stay out.
> 
>> All you need is the mmap records from the
>> guest which you can get by running Perf in the guest and it's possible
>> to decode it. Maybe it's not complete but I don't think all use cases
>> require complete trace. AutoFDO for example just needs lots of small
>> snippets of execution history.
> 
> I don't think it is OK to feed an FDO with traces that are known to be
> incomplete. Maybe that goes under the radar today, but my crystal ball
> is telling me things could be very different in the future, and I'm
> not going to take any bet.

The preset we added for AutoFDO 
(drivers/hwtracing/coresight/coresight-cfg-afdo.c) specifically turns 
tracing on and off to give small incomplete snippets distributed across 
the whole process but while reducing the total amount of trace. I think 
that is one way to do AutoFDO and the compiler can handle it. Anyway, 
AutoFDO is just one use case for trace, and an example that incomplete 
is better than nothing.

In addition to that, the way the ETR and TRBE buffers are currently used 
they're pretty bad at actually recording everything without gaps. 
Although in theory with TRBE it's possible record everything without 
dropping anything, it's still something Leo is working on.

> 
> Thanks,
> 
> 	M.
> 

