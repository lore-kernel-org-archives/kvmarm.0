Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E567192D84
	for <kvmarm@lists.linux.dev>; Mon, 23 Dec 2024 11:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734953293; cv=none; b=NHNhHPIHpOM3rRLBtN3us1Sb9Emihbpd49zJ9Uk3Dg6bcGVOdBpzt7TzNFPs3RWOypHKc0Urto/bZ0VMocw39ld5woyt9VsnUJNj7lxnsnXEofop3mgX436F3q8OeA1cdYEyiB/g12l7oatv+OLNWc0h2YfWvjsJPjU5hHkzSuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734953293; c=relaxed/simple;
	bh=323Z4w2bQUcSRLtbflCw+USwNfTaxhPbVFQeDyKF7xQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jjQbM3nni7xgL8vgc3PusbElcaxEkn6rCZhMu9pCSDF5Tq8VAOIHfveM2LYUgyQ2zVSXsI7xxCFSwOED3KvvN0861Q/KVe46rgCJMn+zFkdmQnWTBL48aWBJp2gPYg2iFr2u1XlUGsTNmhaG469qj6vLqXURB4vXU9E6pG+7GRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PERD8ntg; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PERD8ntg"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43635796b48so24959205e9.0
        for <kvmarm@lists.linux.dev>; Mon, 23 Dec 2024 03:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734953288; x=1735558088; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wgzz0gsE3gqrFwP8Idx/74NN9Vh0nBG1Pbn09jOALdI=;
        b=PERD8ntgFtpHXv4m8QKSnPvQgDvb6X5XQXR9Lf2V3KVt8DWUYHOaLtWaQ3Wlh4y/s2
         zWXbOEgymFhjrXQztvXnQ/Fud+2PAII7zniY0Icw66oDNEK/F9W1knySAfzD39Z+VkpX
         QseS/qj4ATtulP6sVha2bKfn3XGVDGIPEb3QN6IKOM5u0xSpvJbuH+z7PdtNP+J+Is9S
         Zh4sOceumZtgZ9nIfGgdKGgRjrISWxl2bmG3CYgWlGO035I72z8SGZisxKARYpVVjza3
         Ce8ipguwQ4HG2qIvSq9WAjrEct4cj2y57knoqoh9iEEeqAjLdOubEAaHuFiJAatRa34p
         aWfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734953288; x=1735558088;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wgzz0gsE3gqrFwP8Idx/74NN9Vh0nBG1Pbn09jOALdI=;
        b=AAcMIeO0aDvxQ8xTrSCNKrNobF3pnc7mTRh8lFggulDcBSTMsZ93DLjzrdBdLuUmLz
         osmfpe4tJrAKfx5Ra+wfqM+m7fyaLJ3vc/fOXpoPi5xNcRFhlhyx4gEc8M+CW/faknyu
         1IV21NuJvLk4vARIfdHuOtcL8r+WQsOUGIj/dBnyNf59PGmzh5hcGv1H5JLsyQbtBWo9
         7hBtefnr1iAiFADUnRnyFclWFXa558blTNqzF5n8cAqXhI6muBijpDcUtDtXx/kODXr/
         NY7EDN+hyhdpKXidg5d76++pi0aJKe6jWzWzxXOFmt3sH5hHqiMgu8pcBBL/XQ9qjUhw
         2ALQ==
X-Gm-Message-State: AOJu0YxTTP5zswl8DoJ7m56UA8kMV9OrAejIN4TmSjtsz00s+kDLcgbP
	bqlecYHDz14qcv5376A6dlsZ77eIcMxAQjpmb5xgwYoGGxF8r7Q/iwqPI0S7uZk=
X-Gm-Gg: ASbGncuBqdKZoZGxuezNa8clMELrwGRhbb0ap665eAIqVGw/ApCvx1AX+NffxF2WXGA
	x6j4SKUvsevmfgyXfV7DucX5uO17ZaSeJL/Zlao1IcOTc64flJTiWDnWjOKsL6OD6Vrh/5pn1p/
	r0Uc0zsZv0tkW/y5ss92Qca9+mowXgl+AEX8tWrlc6jhb6etY6A/r+up+6dO0Z2nPk2AGLFqrG1
	rRmPpGf4M/s+4yBIxRQXGZCA20bbVoWkgZs8VLerehjaBG3l+4Z2+A5rRvif+79VA==
X-Google-Smtp-Source: AGHT+IHm0ZFL9nIVAaexFN4PWOjn7+ySvP/pC4MHFJJmDVZySNdmlh63s633dEeCGONBXuT62LRO2Q==
X-Received: by 2002:a05:600c:35c8:b0:434:e892:1033 with SMTP id 5b1f17b1804b1-4365c763d24mr135710245e9.2.1734953288409;
        Mon, 23 Dec 2024 03:28:08 -0800 (PST)
Received: from [192.168.68.163] ([145.224.66.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b119ccsm167419945e9.24.2024.12.23.03.28.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2024 03:28:08 -0800 (PST)
Message-ID: <0cfda877-7c3d-4e59-a1b1-fe245f7298f0@linaro.org>
Date: Mon, 23 Dec 2024 11:28:06 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 7/8] KVM: arm64: Support trace filtering for guests
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, suzuki.poulose@arm.com,
 coresight@lists.linaro.org, Joey Gouly <joey.gouly@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mike Leach <mike.leach@linaro.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 James Morse <james.morse@arm.com>, "Rob Herring (Arm)" <robh@kernel.org>,
 Shiqi Liu <shiqiliu@hust.edu.cn>, Fuad Tabba <tabba@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20241127100130.1162639-1-james.clark@linaro.org>
 <20241127100130.1162639-8-james.clark@linaro.org>
 <86r061p63b.wl-maz@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <86r061p63b.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 21/12/2024 12:34 pm, Marc Zyngier wrote:
> On Wed, 27 Nov 2024 10:01:24 +0000,
> James Clark <james.clark@linaro.org> wrote:
>>
>> For nVHE, switch the filter value in and out if the Coresight driver
>> asks for it. This will support filters for guests when sinks other than
>> TRBE are used.
>>
>> For VHE, just write the filter directly to TRFCR_EL1 where trace can be
>> used even with TRBE sinks.
>>
>> Signed-off-by: James Clark <james.clark@linaro.org>
>> ---
>>   arch/arm64/include/asm/kvm_host.h  |  5 +++++
>>   arch/arm64/kvm/debug.c             | 28 ++++++++++++++++++++++++++++
>>   arch/arm64/kvm/hyp/nvhe/debug-sr.c |  1 +
>>   3 files changed, 34 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index ba251caa593b..cce07887551b 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -613,6 +613,7 @@ struct kvm_host_data {
>>   #define KVM_HOST_DATA_FLAG_HAS_SPE	0
>>   #define KVM_HOST_DATA_FLAG_HAS_TRF	1
>>   #define KVM_HOST_DATA_FLAG_TRBE_ENABLED	2
>> +#define KVM_HOST_DATA_FLAG_GUEST_FILTER	3
> 
> Guest filter what? This is meaningless.
> 

KVM_HOST_DATA_FLAG_SWAP_TRFCR maybe?

>>   	unsigned long flags;
>>   
>>   	struct kvm_cpu_context host_ctxt;
>> @@ -1387,6 +1388,8 @@ void kvm_clr_pmu_events(u64 clr);
>>   bool kvm_set_pmuserenr(u64 val);
>>   void kvm_enable_trbe(void);
>>   void kvm_disable_trbe(void);
>> +void kvm_set_trfcr(u64 guest_trfcr);
>> +void kvm_clear_trfcr(void);
>>   #else
>>   static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
>>   static inline void kvm_clr_pmu_events(u64 clr) {}
>> @@ -1396,6 +1399,8 @@ static inline bool kvm_set_pmuserenr(u64 val)
>>   }
>>   static inline void kvm_enable_trbe(void) {}
>>   static inline void kvm_disable_trbe(void) {}
>> +static inline void kvm_set_trfcr(u64 guest_trfcr) {}
>> +static inline void kvm_clear_trfcr(void) {}
>>   #endif
>>   
>>   void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
>> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
>> index 0c340ae7b5d1..9266f2776991 100644
>> --- a/arch/arm64/kvm/debug.c
>> +++ b/arch/arm64/kvm/debug.c
>> @@ -337,3 +337,31 @@ void kvm_disable_trbe(void)
>>   	host_data_clear_flag(TRBE_ENABLED);
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_disable_trbe);
>> +
>> +void kvm_set_trfcr(u64 guest_trfcr)
> 
> Again. Is this the guest's view? or the host view while running the
> guest? I asked the question on the previous patch, and you didn't
> reply.
> 

Ah sorry missed that one:

 > Guest value? Or host state while running the guest? If the former,
 > then this has nothing to do here. If the latter, this should be
 > spelled out (trfcr_in_guest?), and the comment amended.

Yes, the latter, guest TRFCR reads are undef anyway. I can rename this 
and the host_data variable to be trfcr_in_guest.

>> +{
>> +	if (is_protected_kvm_enabled() || WARN_ON_ONCE(preemptible()))
>> +		return;
>> +
>> +	if (has_vhe())
>> +		write_sysreg_s(guest_trfcr, SYS_TRFCR_EL12);
>> +	else {
>> +		*host_data_ptr(guest_trfcr_el1) = guest_trfcr;
>> +		host_data_set_flag(GUEST_FILTER);
>> +	}
> 
> Oh come on. This is basic coding style, see section 3 in
> Documentation/process/coding-style.rst.
> 

Oops, I'd have thought checkpatch could catch something like that. Will fix.

>> +}
>> +EXPORT_SYMBOL_GPL(kvm_set_trfcr);
>> +
>> +void kvm_clear_trfcr(void)
>> +{
>> +	if (is_protected_kvm_enabled() || WARN_ON_ONCE(preemptible()))
>> +		return;
>> +
>> +	if (has_vhe())
>> +		write_sysreg_s(0, SYS_TRFCR_EL12);
>> +	else {
>> +		*host_data_ptr(guest_trfcr_el1) = 0;
>> +		host_data_clear_flag(GUEST_FILTER);
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_clear_trfcr);
> 
> Why do we have two helpers? Clearly, calling kvm_set_trfcr() with
> E{1,0}TRE=={0,0} should result in *disabling* things.  Except it
 > doesn't, and you should fix it. Once that is fixed, it becomes 
obvious> that kvm_clear_trfcr() serves no purpose.
> 

With only one kvm_set_trfcr() there's no way to distinguish swapping in 
a 0 value or stopping swapping altogether. I thought we wanted a single 
flag that gated the register accesses so the hyp mostly does nothing? 
With only kvm_set_trfcr() you first need to check FEAT_TRF then you need 
to compare the real register with trfcr_in_guest to know whether to swap 
or not every time.

Actually I think some of the previous versions had something like this 
but it was a bit more complicated.

Maybe set/clear_trfcr() aren't great names. Perhaps 
kvm_set_trfcr_in_guest() and kvm_disable_trfcr_in_guest()? With the 
second one hinting that it stops the swapping regardless of what the 
values are.

I don't think calling kvm_set_trfcr() with E{1,0}TRE=={0,0} is actually 
broken in this version, it means that the Coresight driver wants that 
value to be installed for guests. So it should actually _enable_ 
swapping in the value of 0, not disable anything.

> To sum it up, KVM's API should reflect the architecture instead of
> making things up.
> 

We had kvm_set_trfcr(u64 host_trfcr, u64 guest_trfcr) on the last 
version, which also serves the same purpose I mentioned above because 
you can check if they're the same or not and disable swapping. I don't 
know if that counts as reflecting the architecture better. But Oliver 
mentioned he preferred it more "intent" based which is why I added the 
clear_trfcr().

>> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>> index 9479bee41801..7edee7ace433 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>> @@ -67,6 +67,7 @@ static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
>>   static bool __trace_needs_switch(void)
>>   {
>>   	return host_data_test_flag(TRBE_ENABLED) ||
>> +	       host_data_test_flag(GUEST_FILTER) ||
>>   	       (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRF));
> 
> Wouldn't it make more sense to just force the "GUEST_FILTER" flag in
> the pKVM case, and drop the 3rd term altogether?
> 
> 	M.
> 

Yep we can set GUEST_FILTER once at startup and it gets dropped along 
with HAS_TRF. That's a lot simpler.

Thanks
James

