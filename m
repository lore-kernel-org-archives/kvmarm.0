Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA96357721
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 12:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768219765; cv=none; b=pyI2WH1dA1NUUOhUlQzLmDvGtXu+JdewaaASMlGDHf3t+dkqpiN7MvJPg/XkLn6SIqope5BfW40TkIoO14HAtgL5d4UHBMVWP4AhyDC4AwQA5LtuilAjosO5QWi9jHFgfHNJqP2plYbcEWTttIrR/8h/9sqcDqQbx+w3HBcHFik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768219765; c=relaxed/simple;
	bh=D+dY7N5K/TqDh41Y15Y4J9E6rqEj5T76OzifegaKev8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=naSIC/l8YGvr+WYuHp/p7xmIo3TQGi6zSE+KZjpJ5yKMYYSoUAX4Sqmd00QeBYH3uZAsXLz16YfsJ4wxuWuq/RWAaFYFqQ2Q1F8YbBdoQaQ7GYZa7KX+bKzJDEcHD62h/fes6hORCQqJaHFbUcP7FXbW8WoKvoJzGgdaAOh1mrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z9HcSeYG; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z9HcSeYG"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-477bf34f5f5so50501355e9.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 04:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768219760; x=1768824560; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QTQwB3rZvEI+7UgNbenEQSikhCpce+1ZGVw/HdNyvwI=;
        b=Z9HcSeYGz0nGX/rcKkG4rfeBlynMjDWk+vcwAve53UQpjz46kxTVmYeiyS3c3kZgRl
         iv5ZvPWgRS6L9fMsALi2nNresBevNwwp+C9LDi/v8W+ehlWg2VEtKUgrMiKsy3YUfQY5
         5g9G7xXBMrr3HAgeqTKc0NaWVeC4zBmbjLyrcE+YjdBo9GVI+xJWZ5NoPsjslhd3/Q5N
         /zv7UxCVC4VTznj38KnO3t8n73II+7mVIVpplxZmfmvjsAruagVno4Z0zG1a1Ze5+iqI
         flyHhzAJDCYPr2qNlnq2zAR+I5BSSpgdT6JDKgSB8WKymdgM5101xgPhpLBt1wroFouz
         7OJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768219760; x=1768824560;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QTQwB3rZvEI+7UgNbenEQSikhCpce+1ZGVw/HdNyvwI=;
        b=GeBptRrvpDQKknoKQT3AQBRDPUN8CXCuQh7cdRyhF1F1lNSouB4XkrnjUg72w2qIgV
         ZZq5KR7k4GUF/P8Sx2xCA0yKtA0PLSbGC41n6Ezzs3lmKjmwh03Ih6ximAVrYvQnoRAX
         cpJBz3Zhu6QlS43N39z+6J8JFDywidUWjWgRPrmk28C7o9xgEU6qlTJbGWha/fx8o/U0
         rXDlwuTmCpECMW4qFyoIsAYDDNH2ycbvLsNSeFGHmAiAjDLhbQKhzSmmbpZd49iUVGOC
         A7MBo94+k2jqUYD6WlGQpcvOPW+BkLubQ2PLzvjKKnjTv8w3wZnUibX8qqLf5Gh9YFny
         gwfg==
X-Forwarded-Encrypted: i=1; AJvYcCWLx4sQpMejcWy5P4gYVwW+0oOVoFjpy0nJ594wMhE+irhJDpGiLNybwGfn2yD9KY/HVP/QLZs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxryLakr5WiFa6bOiAFlOfADhXfJO3JiJ4Vs4Y1LVWTC2raVNfT
	YRFG9s0QqUFw3lVqFkxPi2uQztJYWpzBLYLUzFPpTjy32bs79HDNpoMfeJz7VBz116w=
X-Gm-Gg: AY/fxX7+wmXFJYs0wJVsiXgc3y7xQ9UBzN+x4/GKZhCVjrBM6Mv8BybSZEbt4+mLdd4
	NnWe9L7GD6CsGFPe1QQ1nkwp7J+xbX1xoFPHdJyD8Aq4EVao3xzmvBMv89NxNGu16nHS5vrBT0e
	VTDlKVC2Pyu2GvcomAEL7cWGq+K0VVedfAAdlJPHDgKLSkYSGvGxipORGHBTMVYLyY67Hw7A6D6
	PUM6uvF3f7PvFa/XoiBdBilr7R6dN5IPOW9Z++bnZJhZ+m76pPaEK7/q8rGj4pf0JhfaubojsKQ
	Mu9qq/qphDorW5ZPPvV+4YEXjykvGJeMJGrKD7HqXYapvFNnzSaEswNlHI9LhPBRAdgYd5W3cbv
	lKy2I6qiufKBHIUh/FVviDiprARM8BKjC+UZ2P9v9tjKnPmF96oAK1A3BzPwYiOlQSzIIhUMQaC
	fQZt7TLcAU2Fws4sJ3NXmemKGgOohVmGK0IncitA==
X-Google-Smtp-Source: AGHT+IEVxqtmZ8Iypu6KLmzuavgzaMjHW05m9rZ/bXcJq5/QJRKZ+HKa1MwjTddrSFEfzenNCE6K9w==
X-Received: by 2002:a05:600c:500d:b0:477:b642:9dc1 with SMTP id 5b1f17b1804b1-47d84b3baa1mr144825325e9.20.1768219760432;
        Mon, 12 Jan 2026 04:09:20 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d8702534dsm144173975e9.2.2026.01.12.04.09.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 04:09:20 -0800 (PST)
Message-ID: <d7db9f17-012e-43d7-a0a5-58b254dd7e33@linaro.org>
Date: Mon, 12 Jan 2026 12:09:19 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 03/35] KVM: arm64: Add CONFIG_KVM_ARM_SPE Kconfig
 option
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: mark.rutland@arm.com, james.morse@arm.com, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-4-alexandru.elisei@arm.com>
 <1aaffbcd-ba0c-4371-80d7-ce59ac7f13a9@linaro.org> <aWTaXBse_R_LjJE-@raptor>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <aWTaXBse_R_LjJE-@raptor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/01/2026 11:26 am, Alexandru Elisei wrote:
> Hi James,
> 
> On Fri, Jan 09, 2026 at 04:29:50PM +0000, James Clark wrote:
>>
>>
>> On 14/11/2025 4:06 pm, Alexandru Elisei wrote:
>>> Add a new configuration option that will be used for KVM SPE emulation.
>>> CONFIG_KVM_ARM_SPE depends on the SPE driver being builtin because:
>>>
>>> 1. The SPE driver maintains a cpumask of physical CPUs that support SPE,
>>>      and that will be used by KVM to emulate SPE on heterogeneous systems.
>>>
>>> 2. KVM will rely on the SPE driver enabling the SPE interrupt at the GIC
>>>      level.
>>>
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>>    arch/arm64/kvm/Kconfig | 8 ++++++++
>>>    1 file changed, 8 insertions(+)
>>>
>>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>>> index 4f803fd1c99a..31388b5b2655 100644
>>> --- a/arch/arm64/kvm/Kconfig
>>> +++ b/arch/arm64/kvm/Kconfig
>>> @@ -83,4 +83,12 @@ config PTDUMP_STAGE2_DEBUGFS
>>>    	  If in doubt, say N.
>>> +config KVM_ARM_SPE
>>> +	bool
>>> +	depends on KVM && ARM_SPE_PMU=y
>>
>> I think the most common configuration is module, so requiring built-in isn't
>> great. If there's any way of avoiding it, even if it costs a little bit of
>> pain, it would be good for adoption.
> 
> I'm not sure how that could be done. You need the buffer maintenance interrupt
> to do a VM exit so KVM can inject the virtual interrupt back into the guest,
> otherwise there's a possibility of a large blackout window when the buffer is
> full.

Without expanding more I don't see how injecting an interrupt is 
strongly related to the way it's compiled.

> 
> The code also relies on the SPE driver to probe all the SPUs in the system.
> 

I don't think that's a hard requirement either, the KVM code could 
fairly easily do this itself. Inline the common code and put it in a 
shared header etc. I'm sure there are lots of creative ways to flip the 
dependencies that might not be "proper" software engineering. But like I 
said a bit of pain here might be beneficial overall.

>>
>> It was basically the first thing I got stuck on trying to get it to work. Or
>> if it really can't be done, maybe some kind of debug message to say why
>> enabling failed.
> 
> When you search for the symbol in menuconfig you get a list of the symbols it
> depends on.

Right, but that doesn't address the problems of adoption at all.

Having it on by default when SPE and KVM are already enabled in their 
default configs is the difference between people being able to use this 
with zero friction vs 200 people all getting stuck and then coming to 
ask me why it's not working and distros having to update SPE from being 
a module to static.

> 
> Thanks,
> Alex


