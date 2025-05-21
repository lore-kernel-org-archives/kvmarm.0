Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EC427CCE4
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 15:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747843128; cv=none; b=WWTRdp0MobkWK78Thl2ZhWFlqGEZv2DIIKErNJpg5cKpF4dpI0yJlIoitrlVWNlqmIhnExOP5DCpmpPw9p2KMaxio9bYKpmexyKlRj+2R4qUgqjhbUDeVdkAdlU64pS8N8bjb+ho+vsM/L88Zduj7QejHx8WDO6YEIVi7zH4UNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747843128; c=relaxed/simple;
	bh=I9VBBxVFYOrWsTK7GjRldDLctXPPzg+fbuHoTp+4SCk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sB2jgvk8mYgMgcLDSBw21avZMa1i5ja7VE9RpRPTEL2+v5jZKJdY4hkMX4Ox8br1hO3CbKg+JCBafdE1Vq28UNLY32ae4dOq7KRXsvuThjjbDApnhE+HYDtaKZlohcLMvHdMBhyblWaspigjqKS4Rh5gBRB/Q87p5CDMr7GcEmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JCUwghKq; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JCUwghKq"
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-43cec5cd73bso48357175e9.3
        for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 08:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747843124; x=1748447924; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7jGMaRN9DTvk91Wh6QyGZY6sK/KJmkltlvMirfVWYJg=;
        b=JCUwghKq21MOywsGQ+isFmOD2RT2/UMvqPyd95ZxN6BA8V8ji7kdV2zhgeG0fKEHTt
         faf9khRwPUEJJUTxFi9HV65wZIsed13jhKISTF0bwuu7gzvtOI/vMxqT1GzmbYdQUUFh
         spyDqUvU37gQ18Sm6aocfJEAQNwG7nHeuZ5DJ/eoJbXjdpSoM6OJNPB474QnbZ3tXtUO
         iLXds0CHnQNSxcDe0V3EmRy76IbCVYZmz3ZpCQdCbpw28/7+sCOOeZDaz5P5cX6sy8HU
         eOsiLLDYpjn0M+3rnNWaiugp88WAGqXG0JUqhsUg/XOJGESiNPqEx12mD5kP9FCYa8Az
         hvJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747843124; x=1748447924;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7jGMaRN9DTvk91Wh6QyGZY6sK/KJmkltlvMirfVWYJg=;
        b=DP48TuYSmN8u+F+mSagx87gARzTCdXPYYZulZsLYR8H2E2M4ju5hVICUFoOTwzbY/g
         L6TAp0DEhbthkwc8vmy2exgLQ2eyNp1qKE/7cpYI/pJTucwkqEmaNJLTELydafAnFjcV
         BPiXyxu4uJi3X2Jwpvbn60vzp7dIA8EXPyVwElfSFTUa8sfMH7TVFDeXXFoqwbfnsMk0
         krAwPtgwXGNms3vc6vj0DGMAilKKzWPntbfzVMBzNMp3/LiXBBIkr3FRcTiCKfAmnfnY
         Iak8ovTSz7LCBiQynk32cuwhec/UXE9updVN1KJyAKczgB+1t7SyhEPBx3SXOVRGlSHj
         6Gmg==
X-Forwarded-Encrypted: i=1; AJvYcCV4hx4pEFjch870aTrsTZzyeZ5t+sOmI5tX6KZ8GiWFQb5r+2RWWl7MpRZYWZTpN8zotizFGTg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyE/M2kl9g9lzXXd7DawZdIm+3HBLrc+zsxH5XbNz8wCIy4pf0
	534NTaYzahNc6lOGR89wo+07NJY3PgoN2KqeE8VJ90YPbPCKp+bRnKyLO0nGGM+ovg0=
X-Gm-Gg: ASbGncu+RlWSSDgwGro3m7yuIRYVNzn5HmoOgCz7md4PW+eiW4MjhNIbnPDn09kzv4p
	pnNmnA66K66hqK0ykuTR5axRYXQERjc7nd3hwSMkX4yVo06VEXhvUHaSSljZnuYiMf/aCROvTUY
	DDyYW3xQxW2dHFkC9T68ayj4XNCdhlTK4aAeBM3gRO3kVGQ3tUBCr7MpWwtiYPQF/GVqQgx7do8
	Yzr++aXSIaXflWgXQ5L2XyJ+jlaBOYP8vo6nIGshh1PSSoM2gxH42qYqWCqpnemljWfShimBeOm
	SheC0zVA8vtvNX4C8PenlodFtDxAcYOFMiZpY2stKtQ5AtxH4U+ebugqr2SsZmwjht4=
X-Google-Smtp-Source: AGHT+IE94Qc/sbvf18GBZCQv3ZQ8s8ZqdtBvtnfrv3gSKGcbnewhx8YlU5QP8S7QSIUDnlJDrBopzQ==
X-Received: by 2002:a05:600c:34c4:b0:43c:ee62:33f5 with SMTP id 5b1f17b1804b1-442fd6752e7mr217340645e9.27.1747843124389;
        Wed, 21 May 2025 08:58:44 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca4d2ddsm19933864f8f.7.2025.05.21.08.58.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 08:58:44 -0700 (PDT)
Message-ID: <119c9a70-6ea8-46f0-b877-8a433d97ce84@linaro.org>
Date: Wed, 21 May 2025 16:58:42 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 4/4] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
To: Rob Herring <robh@kernel.org>, Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Leo Yan <leo.yan@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20250407-arm-brbe-v19-v21-0-ff187ff6c928@kernel.org>
 <20250407-arm-brbe-v19-v21-4-ff187ff6c928@kernel.org>
 <20250519150621.GA17177@willie-the-truck>
 <20250519215651.GB2650608-robh@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20250519215651.GB2650608-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 19/05/2025 10:56 pm, Rob Herring wrote:
> On Mon, May 19, 2025 at 04:06:22PM +0100, Will Deacon wrote:
>> Hey Rob,
>>
>> On Mon, Apr 07, 2025 at 12:41:33PM -0500, Rob Herring (Arm) wrote:
>>> From: Anshuman Khandual <anshuman.khandual@arm.com>
>>>
>>> The ARMv9.2 architecture introduces the optional Branch Record Buffer
>>> Extension (BRBE), which records information about branches as they are
>>> executed into set of branch record registers. BRBE is similar to x86's
>>> Last Branch Record (LBR) and PowerPC's Branch History Rolling Buffer
>>> (BHRB).
>>
>> Since you picked this up from v19, the driver has changed considerably
>> and I presume you will be continuing to extend it in future as the
>> architecture progresses. Perhaps having you listed as Author (and
>> crucially, in git blame :p) with Anshuman as a Co-developed-by: would be
>> more appropriate?
> 
> Shrug.
> 
>>> ---
>>>   drivers/perf/Kconfig         |  11 +
>>>   drivers/perf/Makefile        |   1 +
>>>   drivers/perf/arm_brbe.c      | 802 +++++++++++++++++++++++++++++++++++++++++++
>>>   drivers/perf/arm_brbe.h      |  47 +++
>>>   drivers/perf/arm_pmu.c       |  15 +-
>>>   drivers/perf/arm_pmuv3.c     | 129 ++++++-
>>>   include/linux/perf/arm_pmu.h |   8 +
>>>   7 files changed, 1006 insertions(+), 7 deletions(-)
>>
>> Do you know if James Clark's tests [1] are going to be respun for the
>> perf tool? It would be handy to have some way to test this new
>> functionality.
> 
> Yes. I dropped them here because I've been told by Arnaldo in the past
> to send userspace stuff separately.
> 

That version of the test was out of date so I've pushed the new version 
here: 
https://git.linaro.org/plugins/gitiles/people/james.clark/linux.git/+/16e4a18c2d5fc53736f05c9052b1d11d74909707

But I'll wait for the driver changes to be finalised before posting it. 
Or Rob can take it back into the patchset.

