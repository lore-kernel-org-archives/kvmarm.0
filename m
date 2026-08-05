Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4598240B0F4
	for <kvmarm@lists.linux.dev>; Wed,  5 Aug 2026 10:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785924554; cv=none; b=X/D2XMzYxLp9hIX5uCSzy+GSQXUyVD68T7C8Lk9ueo23OCPljvusI+VJ961r1iLjF/FpZCWkEa2MtPXL2m4n5xPnyIJibLBdrcVVsN0SftoTr0ETH3Grz6CtaiqNo2JrhFztzyXydsNaU57djSTMserNtOqlBDlAYcgP1bb6tWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785924554; c=relaxed/simple;
	bh=M2jF0Jt2bDRZzymZQmRY6Uui16djwBoVWK1VjhYmc30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a4npNz8ugBgV6r3vkpMBLTlYToNLgMqFRVGLL+mYuXzIq51qL4oAdqhwNgiRj7b2ZV60enIWBCLqoGBUn4TVyh2N47wdqBT9Nw0DHOmrmWKmf9Jk1ypbE/dnETO9YGZEDXp0k0h86Sw2bon2oZ2kDGxsnYHsSNhFnkXScWO1b2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yVdPzpag; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yVdPzpag"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47f7027ca11so503988f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 05 Aug 2026 03:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1785924550; x=1786529350; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XrcStaMXdkE1hM0cDDyjF0ywdDXESAjsr6s/h+tclqU=;
        b=yVdPzpagdfqL1hxjVby2nr6ivYIxNNwBJttS5Hz30Y55Qm6QI9HqsTMfI5aidbcXUl
         420QKVaCiAfavrV4EEOqMaH2rCn/t5NeLq5O30e6PGiLNTUcLUuTy/d20K1478MdFgyk
         KTCpLD2kwvJBKLyRv1HB7WQZOnnZgI5R8VEngfS/zKoQBg9C99vyqMkkn/yPzdxq5q57
         EhrOeUNZ+ixfpavdT1rLCHMDT4qMRZMjXl0VlDWa/XrfaTHgcYCe5IwxEHZyHg7sz80/
         WI0AFNfj8G1H1R6UFzpbUUKmmsBiuqZPYX9pkUj0fcZehsy4EEiUwblnDEFm/OrLLxR2
         ooMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785924550; x=1786529350;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XrcStaMXdkE1hM0cDDyjF0ywdDXESAjsr6s/h+tclqU=;
        b=Wi/ipXukMmwyBQLFfMwbUpyKJGbtRw5lG2EYgFH33RGnsaxyOhnXjwC1d8ii7Yy06X
         8onE1a2FydTM8gW08hsYi3/0ldz6gheJAwvfXDi9rVs3Des2HSG4htZOnbKu+puYXKKQ
         1oGXv/AWQALQI7+jI+Y/uZVt77gqEa7pWvX6f6TM3vGTwjyDK35YXCA9fzqDXM6quWcY
         FblIOlVFieLVQdkRHa+qtluFX99vqHo4JMRk/TZAfypqzGcAcHLSEb0kGKpl065ii5CP
         5RimehAMHJ8E2SFqraqHKlTN9rIAl1gpNXrAxel8U+s6KtR0sKo4h9oPMIrRv5R3ke+B
         nKWQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp58gmPyG5lnKRWb7ZsA4bYJfn1p4d0SsCz0XK8CQrVjiMbvwgCFxZPqJIvakOYUfDHYY9UB4M=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQYfATj4UnQJ/1ZneQMvNv7c+YKz0mzm/pT9248JZUy7wI7bAh
	VzkAsmEH/BHf4UtQl8OAA7skXYiyhl4m/Ho/TaGSv3tdlBoiOYDsZ/jD3wT1mhPahUo=
X-Gm-Gg: AR+sD13CoW5cy/GLo2XG1IADWnYxz8iVfdoWWQsnvBLHZyRh57axUe7jrQfIFmSwydz
	J080OpIBBZVAniRG1oiQ6xRfE5xlKoS8xLIC3g9aK8H4rpVdOF1ZQmhQqBsZcxgbLw2t0vsVntw
	pi5bzueze85fil/egJ+vTLRaILObwuNHmisRaDDtrUpK0phZqYwyeVnDcdpqmSiEGMEFI07oVo1
	GzH2SFszAn67WIYPT2rAkbP0AdLmEf5E5+DLORmBaZIx3H9McPMh9jCJJTj/p6xFQCZ/U1fhOxJ
	yEuEgTzodWTIsLg/kdgIKRsEct6a/ElXsxqb6u/bMzelMVYHMPoDLSQreAcZjA9iNrdAvNW5hvN
	GpSN8CXHOcyXwZqCSPX/NRDI2REoMvd38nJAdagMtyQdIgbFK+HGplzp235LYbfcKl3kisDw8hB
	UnlQfvD/LXCOPT75jOUiZtNED9mcq/0jh5dLFBGYc3331BWWBoNFaXBm8L2sH0NbUOZ4U=
X-Received: by 2002:a5d:5291:0:b0:47f:d072:87d7 with SMTP id ffacd0b85a97d-47fec4f663fmr7081483f8f.9.1785924550297;
        Wed, 05 Aug 2026 03:09:10 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.141.193])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47febfda0cbsm7427247f8f.6.2026.08.05.03.09.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 03:09:09 -0700 (PDT)
Message-ID: <ebb8a1b7-d5c8-4be0-af64-1496a7fd29d0@linaro.org>
Date: Wed, 5 Aug 2026 11:09:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/21] ARM64 PMU Partitioning
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, pbonzini@redhat.com,
 corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com,
 will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <gsntse4tvbn2.fsf@coltonlewis-kvm.c.googlers.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <gsntse4tvbn2.fsf@coltonlewis-kvm.c.googlers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 04/08/2026 10:06 pm, Colton Lewis wrote:
> James Clark <james.clark@linaro.org> writes:
> 
>> On 23/07/2026 9:57 pm, Colton Lewis wrote:
>>> James Clark <james.clark@linaro.org> writes:
>>>>>> When running the guest on a single CPU I get different counts for the
>>>>>> same event for a single process, although this never happens on a 
>>>>>> host.
>>>>>> I think there might even be some Perf tests which expect them to 
>>>>>> be the
>>>>>> same, and this doesn't depend on whether any events are running on 
>>>>>> the
>>>>>> host or not. Not sure if you ran all the Perf selftests in a guest or
>>>>>> not?
> 
>>>>> I'll investigate but I'm not sure perf is intended to guarantee
>>>>> that. perf stat just runs the event counters but may not write or read
>>>>> them at exactly the same time.
> 
> 
>>>> Is that true? The perf core calls perf_pmu_disable() when a process is
>>>> scheduled out before reading the count of each event of that process in
>>>> an inner loop. The perf_pmu_disable() clears PMCR_EL0.E which freezes
>>>> all of the counters so they can be read out in a consistent state.
> 
>>>> It's important that they're all stopped at the same time because
>>>> counters might be used in metrics as ratios of each other. So I think
>>>> it's deliberately designed that way and appears to not be working in a
>>>> guest now.
> 
>>> By default I think perf assumes events can be measured independently, If
>>> you want to guarantee events are scheduled together to avoid measurement
>>> skew you need to make sure the events are grouped.
> 
>>> The common way to do that is with {} around the event list:
> 
>>> perf stat -e {branches,branches}
> 
>>> Please see if that resolves the issue.
> 
> 
>> Groups only change how the events are scheduled, not how the driver
>> starts or stops multiple events running on the same PMU (grouped or
>> ungrouped). In my repro I had less events than counters in HW, so they
>> will always be scheduled at the same time regardless of grouping.
> 
>> I did notice something extra though, you have to first open some amount
>> of counters, and then open more than that. Then the second time the ones
>> with different counts will be however many were opened first time, as if
>> some state has stuck.
> 
>> For example if I open two counters then 6, the first two always have
>> different counts the second time:
> 
>>     $ perf stat -e branches,branches true
> 
>>     Performance counter stats for 'true':
> 
>>               106129      branches
> 
>>               106129      branches
> 
> 
> 
>>     $ perf stat -e
>> '{branches,branches,branches,branches,branches,branches}' true
> 
>>     Performance counter stats for 'true':
> 
>>               117013      branches
> 
>>               117013      branches
> 
>>               110364      branches
> 
>>               110364      branches
> 
>>               110364      branches
> 
>>               110364      branches
> 
> 
>> After opening 6 again a third time they'll all have the same counts.
> 
> Interesting. Thanks. To clarify, is this happening in the host or VM?

This is in the VM

