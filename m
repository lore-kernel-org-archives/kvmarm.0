Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7F823E242
	for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 17:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743010720; cv=none; b=YE5DeGydMSa2WR3J1kkUYQkFZKDfLrJoKSEYskDkN2tUaWmQCzs4Efo1qvXWvXd0o9ZzmF1+2CSLc1sXQYgw7zJ529vthCQwI8Vu8lIVF+WbodxF3LvZsvXX8MmGhuGp/wZmg8AelfjTHJIhvIIY18bH/9CW46ajzAOEDhD2lCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743010720; c=relaxed/simple;
	bh=2oIE0G5XW4T1LPwCREw3CNOAFjNp0UmQyd+rq0p3SvM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tuGEM5oby90YMubdOEOkuGINiPxRMXZbFecnZAQOYBlLCIIUqoSjDHfCZLgnnO60I79QBvPx8Ajj2RqnEw6X6T4tDOxlauDbF5cNwCw9LREz/OdII4zhLtYn+XUhZWejvRZJPs9mW/n1a87UCSg9ErT+qQU9GhjW+9Woon0rtmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=brsL867P; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="brsL867P"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43d04ea9d9aso529845e9.3
        for <kvmarm@lists.linux.dev>; Wed, 26 Mar 2025 10:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743010716; x=1743615516; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8qVND4tenJBQx/xK/Ve6LMeZrg3oeI6UK9LzOuingT0=;
        b=brsL867PvFf0KIFG2oS6cBv1/z/UsQOfrxkeXPzrc3zordo+3r7GdM9eGk1jwL7RfN
         5xZHEQ9FOvLR4fyeEp1l3FNzs2oh3ZqLwIno64FhWKbBEPyskKXCex70RUiih7NCy6Dc
         3v7WQMXh6j0cODg83zJMz8ioKk3zm20fxcAaL7XKxjUu/7mP9bdpYUZKEmiekoAACy+J
         TZ8yp1MsIPwFaPbdAr7MLpn750V5e8dYEF/GQQ4ild6/qSNmxWmhJ8DovsZte76Ne/Om
         g7dG5p8806Rv524TcIA2g3n+mTbUXsFO3cCmQ03d5wMCutEGPDFRxS40RAJxDRG5Ky9g
         XWmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743010716; x=1743615516;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8qVND4tenJBQx/xK/Ve6LMeZrg3oeI6UK9LzOuingT0=;
        b=G4JP85alB16vXilKzqvcHMKxX2kkRmWFzmHPacuQAHKzig8A0k/wtsaQKdcbE11WYd
         64ICc4oaRbMfFzRQWug6FvK+ZERGoANr5ytPmo+hO0gOVdc9Pj+wg0xk8VZCldMdk5x6
         koqzXX/8W3fcJS/xwyzmXuRnHTimpRFfIeZHwxfPgYkzFdoP5SKKwimslNz1Mx5PVGHp
         ptYcI3hFbhMh5JrC3qt7Z8/Ig2HbHCDxiDQyB8Wv94PTNSJNeuPSviZZIjPckbbkl3z7
         cWwtA6P6Fs8Bsd3LuKJxPRoqDj/VObHl5se5kZR3AYnvuoiQ1rxbgbUidZeCa+T39qhK
         lMUA==
X-Forwarded-Encrypted: i=1; AJvYcCVaVsLQ5bjHffeJrDMUONWC7tR9C0Tk5GY4cDfmX15NmDZa+PvNPqFCpxvz2MCgYUnQs8JOET8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzOSOAdFw3+N5lirfZPfszT5sNQAC8tg9/OQO4coToMFGE2cKGM
	0vQn1zSfu98J3rJaG4WWbeD/eFWAn3mMifEHHPbjgre49ZMXXAaM4TLJdoOgGKg=
X-Gm-Gg: ASbGncvwv8u7mpfXYzGwhj610FKp9mJxuXbCL4+S+19jXt5C5thrbMEFVxNaE8VlQkm
	csvbxO5uu1nPtjrI957elS2LFbWq8sHEoOgaCrPNhBSNVCkwJtjpHJSY6udWhlnaURExtalWDQ4
	yHohD+aQO3fa0pvIRkzKoO3QMkEHeE2ka9hwY+en87Amq2iZUv2W3RSLUzgnDOcpBIavG69Pa18
	+6WFvCUc09orWWcxtunm5Vzsj12qtNmEjDdFbEWxH0mSXvKciNfS2qhVZWOou1C57Rh+8Na+VGx
	4VRC9SVJWjVXLy9UY533yHC7nVS1zTzD49h2x6dJr5dO0S27FA==
X-Google-Smtp-Source: AGHT+IFWImSgAxE2tnY9m2ZViZ+epH+rNo6E42n/cKyi3Pxy880VgCejpCzrgRBe13sBLMsd3ILXAQ==
X-Received: by 2002:a05:600c:1e0d:b0:43d:10c:2f60 with SMTP id 5b1f17b1804b1-43d8524f43cmr2296105e9.24.1743010716400;
        Wed, 26 Mar 2025 10:38:36 -0700 (PDT)
Received: from [192.168.1.247] ([77.81.75.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9a6326sm17050515f8f.29.2025.03.26.10.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 10:38:36 -0700 (PDT)
Message-ID: <f7d543f6-2660-460f-88ac-741dd47ed440@linaro.org>
Date: Wed, 26 Mar 2025 17:38:34 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 5/8] KVM: arm64: Introduce module param to
 partition the PMU
To: Colton Lewis <coltonlewis@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, robh@kernel.org, linux@armlinux.org.uk,
 catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, mark.rutland@arm.com, pbonzini@redhat.com,
 shuah@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <gsnt1pulnepv.fsf@coltonlewis-kvm.c.googlers.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <gsnt1pulnepv.fsf@coltonlewis-kvm.c.googlers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 25/03/2025 6:32 pm, Colton Lewis wrote:
> Hi James,
> 
> Thanks for the review.
> 
> James Clark <james.clark@linaro.org> writes:
> 
>> On 13/02/2025 6:03 pm, Colton Lewis wrote:
>>> For PMUv3, the register MDCR_EL2.HPMN partitiones the PMU counters
>>> into two ranges where counters 0..HPMN-1 are accessible by EL1 and, if
>>> allowed, EL0 while counters HPMN..N are only accessible by EL2.
> 
>>> Introduce a module parameter in KVM to set this register. The name
>>> reserved_host_counters reflects the intent to reserve some counters
>>> for the host so the guest may eventually be allowed direct access to a
>>> subset of PMU functionality for increased performance.
> 
>>> Track HPMN and whether the pmu is partitioned in struct arm_pmu
>>> because both KVM and the PMUv3 driver will need to know that to handle
>>> guests correctly.
> 
>>> Due to the difficulty this feature would create for the driver running
>>> at EL1 on the host, partitioning is only allowed in VHE mode. Working
>>> on nVHE mode would require a hypercall for every register access
>>> because the counters reserved for the host by HPMN are now only
>>> accessible to EL2.
> 
>>> The parameter is only configurable at boot time. Making the parameter
>>> configurable on a running system is dangerous due to the difficulty of
>>> knowing for sure no counters are in use anywhere so it is safe to
>>> reporgram HPMN.
> 
> 
>> Hi Colton,
> 
>> For some high level feedback for the RFC, it probably makes sense to
>> include the other half of the feature at the same time. I think there is
>> a risk that it requires something slightly different than what's here
>> and there ends up being some churn.
> 
> I agree. That's what I'm working on now. I justed wanted an iteration or
> two in public so I'm not building on something that needs drastic change
> later.
> 
>> Other than that I think it looks ok apart from some minor code review 
>> nits.
> 
> Thank you
> 
>> I was also thinking about how BRBE interacts with this. Alex has done
>> some analysis that finds that it's difficult to use BRBE in guests with
>> virtualized counters due to the fact that BRBE freezes on any counter
>> overflow, rather than just guest ones. That leaves the guest with branch
>> blackout windows in the delay between a host counter overflowing and the
>> interrupt being taken and BRBE being restarted.
> 
>> But with HPMN, BRBE does allow freeze on overflow of only one partition
>> or the other (or both, but I don't think we'd want that) e.g.:
> 
>>    RNXCWF: If EL2 is implemented, a BRBE freeze event occurs when all of
>>    the following are true:
> 
>>    * BRBCR_EL1.FZP is 1.
>>    * Generation of Branch records is not paused.
>>    * PMOVSCLR_EL0[(MDCR_EL2.HPMN-1):0] is nonzero.
>>    * The PE is in a BRBE Non-prohibited region.
> 
>> Unfortunately that means we could only let guests use BRBE with a
>> partitioned PMU, which would massively reduce flexibility if hosts have
>> to lose counters just so the guest can use BRBE.
> 
>> I don't know if this is a stupid idea, but instead of having a fixed
>> number for the partition, wouldn't it be nice if we could trap and
>> increment HPMN on the first guest use of a counter, then decrement it on
>> guest exit depending on what's still in use? The host would always
>> assign its counters from the top down, and guests go bottom up if they
>> want PMU passthrough. Maybe it's too complicated or won't work for
>> various reasons, but because of BRBE the counter partitioning changes go
>> from an optimization to almost a necessity.
> 
> This is a cool idea that would enable useful things. I can think of a
> few potential problems.
> 
> 1. Partitioning will give guests direct access to some PMU counter
> registers. There is no reliable way for KVM to determine what is in use
> from that state. A counter that is disabled guest at exit might only be
> so temporarily, which could lead to a lot of thrashing allocating and
> deallocating counters.
> 
> 2. HPMN affects reads of PMCR_EL0.N, which is the standard way to
> determine how many counters there are. If HPMN starts as a low number,
> guests have no way of knowing there are more counters
> available. Dynamically changing the counters available could be
> confusing for guests.
> 

Yes I was expecting that PMCR would have to be trapped and N reported to 
be the number of physical counters rather than how many are in the guest 
partition.

> 3. If guests were aware they could write beyond HPMN and get the
> counters allocated to them, nothing stops them from writing at counter
> N and taking as many counters as possible to starve the host.
> 

Is that much different than how it is now with virtualized PMUs? As in, 
the guest can use all of the counters and the host's events will have to 
contend with them.

You can still have a module param, except it's more of a limit to the 
size of the partition rather than fixing it upfront. The default value 
would be the max number of counters, allowing the most flexibility for 
the common use case where it's unlikely that both host and guests are 
contending for all counters. But if you really want to make sure the 
host doesn't get starved you can set it to a lower value.

All this does sound a bit like it could be done on top of the simple 
partitioning though. And it's mainly for making BRBE more accessible, 
which I'm not 100% convinced that the blackout windows are that big of a 
problem. We could say BRBE may have some holes if the host happens to be 
using counters at the same time, and if you want to be certain of no 
holes, use a host with partitioned counters.

James

