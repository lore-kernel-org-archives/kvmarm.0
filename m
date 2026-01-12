Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CC73563E7
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 12:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768220046; cv=none; b=krXDurQgRt8FO48BLSNhem09vinHLqduyn9/DwPb7He0v2zzprx+Oiah5OOvlySMSKveVigvInLc3Bu4KDjA0tbIkEiQBNtKyZpl4aTVUWw5MR5dUZFunsTCcz4WBHODFIRCoX9rW8ZNJj3N9kRPAUtMXRq80UcHj0ALO5YWikw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768220046; c=relaxed/simple;
	bh=QmYlGaujFEsE9XLmHDyT0RbhVJRLgGd9k1Ng3vTOcB8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Hb5IADQo7WV36BMko3AhSiCjUd3wkDoKj7eFprfPe2VcBdcbs/WMafc2OJ8tBeXHBwi19cnr6SgHo//bAj8tJ3L9VzzUhcKMbIxB54EhKXwTe0gHT7//v80sBy9mosaflBLHG+rGQFS0cFy/YK+xT2QhyhrvOSSl8VvjGZ+SELU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hTP96GhC; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hTP96GhC"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42fb6ce71c7so5336844f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 04:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768220043; x=1768824843; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m5vBcByaSbLsGX5Zr65hjskcoFy3cdK9/53jX67HxjI=;
        b=hTP96GhCcA41kufj6kMnYJCgjhB/GzBO81eqyayRySAuBlYpLAivJiophBiS5yKNpQ
         EMWUWKqtmHnFi7ronvRtQeTOL6SvDgzSaDLcpsmNkOthxUxXzHIRhoeDE0Mz4S4AjsQf
         /rST5Weazn7vZkv3p85ViSg4RPNuw9QfFnJYlJngX5D9T2QAI9lQa/D3sFM0L61XlHKp
         h5KWOQOdQsL4si2UsybcjBg1u8r163OLpxrV5UrGkgTrpZiSjWCvijcRVkarBH3RZCZz
         PRhdOf98qFqLTSGG6yhLcik3xzZ5lv3n44c77yVrTVU8I8Xgw7nIzxSNYRfiZcB8zoFP
         8dow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768220043; x=1768824843;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m5vBcByaSbLsGX5Zr65hjskcoFy3cdK9/53jX67HxjI=;
        b=V2fG542yzFoM2pv8zf0YvNF3k5YuL50LJqoUE8CqSjWGuTk3wuTJOIr2QD97b1zHQo
         oTZXD8jq1srTcXlXXPk0xBZkmWIYQQHK2B9O17FtgPZkObEXL9X0joEa5S3RfaLJpDhS
         fMS0NR1iO4P9cMF91Q67AcTRIEkELZfFnhZpF8DY161ZdTqI/rxd3zhiNca4WWo1mxpI
         fizBQZ0lDnMTRssWDobbkwL32N/ARLssYcGMq0HxU2t2BboohfdIFEDv1YQM+a8P3bya
         xS82B/tW9xihEIB++dS92U+Eo4CDSmjMLszg+lA5e/H6MTnHzKAXa7kF2qdfZMA47gJg
         QqOw==
X-Forwarded-Encrypted: i=1; AJvYcCUwnPRZ0ZuKhzvf6JNxLl7EiYwsbsMKsH2K2suVxwMjZ8lzOZMwEGXYRpW5U+DUO3j2qJF+EHI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyuaoQEPp3Xt177PPaB+6foan/l1MbhD8tlDruQkL3A5+jKisGe
	5kb5HKpLMVc3/SzAG54oxlNA81tFhIHgoS8+p9+fmUfKQtOdgrzhywg5aseyn1SctOA=
X-Gm-Gg: AY/fxX5e5LURypLsZY88QNzBQBW0xK0rrDDSmdo42KeIb95yOH1Yi5bi/jyzA2T3HHR
	eJpk4+Z7grBiX8OqUtC6+r/HDmi/exiAiGpfDcAg3pK6TmCrS1NXbm7QLb8RKO7LdWUSwT1/7DY
	sU93ByN//RuBjQZMnznJc/w8Ew3ojCEetn+czPEe2oGKYIfC4qcVTCgPCVD245ztiOIDlhhzWR/
	+HFI/ObnsM3I/xIyAmwnGjQogv2tXSvSdW1QTYDnYuhoHRiR5687bXTE+viYIU2kL6eBpoy3v2c
	2F2tGVd/JtCvw5fBuYlzKTJ03sm4gTRJBEv7jPl/3sO/+tke5h5LfqVGHhNxRXTudKJ8WWFnE78
	xk2Puv79TdV4jPOTqfPDyvFEusC8CYqSCG6RNiLn440xG8huRLVou56LEAzLEfYPIhvH4zRffWl
	V/c+/jA3o8Vq/v1D7xnUxpj6ohrJo=
X-Google-Smtp-Source: AGHT+IFyLJu85DhzDzB9NUkNFHVuGwdXkS6SskSTBpWBs4uFpxP0oRfyAXxIBuq4lyp+uGbpQRo27A==
X-Received: by 2002:a05:6000:22c7:b0:430:f6bc:2f8b with SMTP id ffacd0b85a97d-432c37d2faemr19857760f8f.45.1768220042989;
        Mon, 12 Jan 2026 04:14:02 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ee870sm38632600f8f.36.2026.01.12.04.14.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 04:14:02 -0800 (PST)
Message-ID: <24dbbfea-f068-4352-9212-30821feed796@linaro.org>
Date: Mon, 12 Jan 2026 12:14:01 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 03/35] KVM: arm64: Add CONFIG_KVM_ARM_SPE Kconfig
 option
From: James Clark <james.clark@linaro.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: mark.rutland@arm.com, james.morse@arm.com, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-4-alexandru.elisei@arm.com>
 <1aaffbcd-ba0c-4371-80d7-ce59ac7f13a9@linaro.org> <aWTaXBse_R_LjJE-@raptor>
 <d7db9f17-012e-43d7-a0a5-58b254dd7e33@linaro.org>
Content-Language: en-US
In-Reply-To: <d7db9f17-012e-43d7-a0a5-58b254dd7e33@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 12/01/2026 12:09 pm, James Clark wrote:
> 
> 
> On 12/01/2026 11:26 am, Alexandru Elisei wrote:
>> Hi James,
>>
>> On Fri, Jan 09, 2026 at 04:29:50PM +0000, James Clark wrote:
>>>
>>>
>>> On 14/11/2025 4:06 pm, Alexandru Elisei wrote:
>>>> Add a new configuration option that will be used for KVM SPE emulation.
>>>> CONFIG_KVM_ARM_SPE depends on the SPE driver being builtin because:
>>>>
>>>> 1. The SPE driver maintains a cpumask of physical CPUs that support 
>>>> SPE,
>>>>      and that will be used by KVM to emulate SPE on heterogeneous 
>>>> systems.
>>>>
>>>> 2. KVM will rely on the SPE driver enabling the SPE interrupt at the 
>>>> GIC
>>>>      level.
>>>>
>>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>>> ---
>>>>    arch/arm64/kvm/Kconfig | 8 ++++++++
>>>>    1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>>>> index 4f803fd1c99a..31388b5b2655 100644
>>>> --- a/arch/arm64/kvm/Kconfig
>>>> +++ b/arch/arm64/kvm/Kconfig
>>>> @@ -83,4 +83,12 @@ config PTDUMP_STAGE2_DEBUGFS
>>>>          If in doubt, say N.
>>>> +config KVM_ARM_SPE
>>>> +    bool
>>>> +    depends on KVM && ARM_SPE_PMU=y
>>>
>>> I think the most common configuration is module, so requiring built- 
>>> in isn't
>>> great. If there's any way of avoiding it, even if it costs a little 
>>> bit of
>>> pain, it would be good for adoption.
>>
>> I'm not sure how that could be done. You need the buffer maintenance 
>> interrupt
>> to do a VM exit so KVM can inject the virtual interrupt back into the 
>> guest,
>> otherwise there's a possibility of a large blackout window when the 
>> buffer is
>> full.
> 
> Without expanding more I don't see how injecting an interrupt is 
> strongly related to the way it's compiled.
> 
>>
>> The code also relies on the SPE driver to probe all the SPUs in the 
>> system.
>>
> 
> I don't think that's a hard requirement either, the KVM code could 
> fairly easily do this itself. Inline the common code and put it in a 
> shared header etc. I'm sure there are lots of creative ways to flip the 
> dependencies that might not be "proper" software engineering. But like I 
> said a bit of pain here might be beneficial overall.
> 
>>>
>>> It was basically the first thing I got stuck on trying to get it to 
>>> work. Or
>>> if it really can't be done, maybe some kind of debug message to say why
>>> enabling failed.
>>
>> When you search for the symbol in menuconfig you get a list of the 
>> symbols it
>> depends on.

Also, it wasn't easy for me to find this either. I had to read the code 
and debug it. I find it hard to believe that other people won't get 
stuck here without a warning. It will be "I've got SPE, I've got KVM but 
it's just not working and there's no warning".

> 
> Right, but that doesn't address the problems of adoption at all.
> 
> Having it on by default when SPE and KVM are already enabled in their 
> default configs is the difference between people being able to use this 
> with zero friction vs 200 people all getting stuck and then coming to 
> ask me why it's not working and distros having to update SPE from being 
> a module to static.
> 
>>
>> Thanks,
>> Alex
> 
> 

