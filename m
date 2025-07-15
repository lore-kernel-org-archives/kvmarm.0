Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C48230BC6
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 12:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752583690; cv=none; b=P0eT3CwvmPyS1C4SS4q6suywTPoykBkXRk5J00Hq91WkGHB9oMJDaKRQrfeWoBsHJbkV/GaQupncFaN8VpCAfnq/KvU3U2h/byxYn3n80Jfuk0953f5mDJjaNYE+P0PJioteOOLfOwZo+3vr2do3i2B+DpzGncM5TwHXp6Zq07M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752583690; c=relaxed/simple;
	bh=EPw4dQ8dfonq0P3aVNF8vSgP2GKEr/WhL3SjzkV20GA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tk6AmnesA2lqAkVgfiCC+uyR+e1ZtGGJsifyiVXOFIjUE7eHnUWkCwUZzy5OO5hRvoGBvd/wF8TJjivK2tVEk9BqFJDcQyN/nvR5i2ENNaH9Qm4S/PYP2yrjfxi5GDMtopoQ5kT3XEmPXzMXeFh0/QSHt58eKf44myiA33Etgp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eTvEzN9X; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eTvEzN9X"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4561ca74829so18691655e9.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 05:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752583686; x=1753188486; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Iqo4mhXycGD6rw4UTAUbadK3TxDOKrzOub9ByVVv0xc=;
        b=eTvEzN9XBRU0DkPcUTC0TX6F81AAnBzejLlGcnKXsueAa+FCCZ1OXv8HacTcyNBV/1
         NiLk4uQlewdYvtX5tgwYOH7AdWNhVyDkNbU2orR7WUkc6INaSFaIwJYH/y+ZuD41Ui+1
         kMOSxFuTXiSAdwPTsCYEeN0VGfE7hSxF6PXhxPhIFBD98JotvnCLQ+/KnFwouGYw3JxK
         zScPdh0R8yP7DxV1SMGb64K4lWxoVlK6oLKzWwZEt7YRehLaE9sBHIzn1Q4GvHMEYKvG
         ik8VR8XKkOeX5aB+Cg2Z23T3rk3iUTZlS5jLrKBWAPQhuLRiYf5L/nIoZIURQOUfiBni
         DO6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752583686; x=1753188486;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iqo4mhXycGD6rw4UTAUbadK3TxDOKrzOub9ByVVv0xc=;
        b=l9LL3aVWhG5JLCf2KPePqZe9utvGLFLo/g1e+296XxE2TWQTiKAhmktNa1bRl8M0Ks
         1Nz5uQgIAy/UpPX7/fbjBkri84Z9iG0GeEyXNZ6cgf94cmRYAGcpdUWa/qaeBoj83BY7
         wNhE1DX9EYo+EXnRNUAbLMHbkVKOtag7avTSnigaE4OE2EfRHgeb0Te5KMZ2BtD/Od8j
         Xlfw6ZDDfHdfTAXHPZkET7aBrFuspYXvohfiY352zV3S6fHXU/uQEBrpByLpu0Tp6DmM
         pmFvu2oZE12hXJnQCOOzUfwABU/6mGJNUNr1GpkFW1J4T+lOfrAof349pPx9p9b5yN3N
         lOGA==
X-Forwarded-Encrypted: i=1; AJvYcCWgWpis3+ZgbqeeY2V+zId8z2KkhGPeam48YXhmaijjt5UN1uidNLWfELbGHml3dYnhjciKPSQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMqj8g02PEPaYQhnGmLp+/AoFWWEeA2yUBqh0O1GFdyC3sZvij
	8p62eDH7NtpcY9pFuKocVJzA4L55QroiMQeP+PBWnbI0iX18CfvxEfuIDno7hfgkW30=
X-Gm-Gg: ASbGncsBgchWSYQVcm7H/FSrv9x8hUcvo46RLuaKGqoW/0dBIAcmfzGbS5lmczBIP67
	o2kU4Xm6x010y+MaZEq3PysrAUWCjBrZxv/Fy6JCBlS+e6XMbYJSwLnzmu/OkF2I1rgPFmOCejW
	k88GXSTE3zPHkuy2oR2+Co5vREoZIQ6hA9gwhFqmd+YO7VhvYk7QEdMhJWsuoFQSrWEtN4ATEkg
	4Ju5rMRmqT5D1CtOnyoi/wHESYE6x/IGmrzElBoU/S9jToMYZtUD+pSJ6bbljgqzJcRPgXhhxGq
	aMj+cwX3a+nG7lFc6L5PWOanRScvk2TRuI/RA/mqrC4onJKccFsMvrjZBjOVwo3VxXUXQyRZc4H
	GWjbO5V6ff+jRcEZPE3diMnTc8S4=
X-Google-Smtp-Source: AGHT+IHksQQexPF9xeIAPmAN5RQVQtwJAwRE0OCzaS0bMryNoBsPAdHpgVxKs40ogsxaKO2X4QSDVw==
X-Received: by 2002:a05:600c:8483:b0:440:6a1a:d89f with SMTP id 5b1f17b1804b1-455bd87a4a2mr140606855e9.4.1752583685607;
        Tue, 15 Jul 2025 05:48:05 -0700 (PDT)
Received: from [192.168.1.3] ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45610c518e9sm84882505e9.17.2025.07.15.05.48.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 05:48:05 -0700 (PDT)
Message-ID: <04d52182-6043-4eaf-a898-9f8ccc893e5f@linaro.org>
Date: Tue, 15 Jul 2025 13:48:03 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] arm64/boot: Enable EL2 requirements for
 SPE_FEAT_FDS
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, leo.yan@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
 <20250605-james-perf-feat_spe_eft-v3-4-71b0c9f98093@linaro.org>
 <aHUMMk9JUdK6luLN@willie-the-truck>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <aHUMMk9JUdK6luLN@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 14/07/2025 2:54 pm, Will Deacon wrote:
> On Thu, Jun 05, 2025 at 11:49:02AM +0100, James Clark wrote:
>> SPE data source filtering (optional from Armv8.8) requires that traps to
>> the filter register PMSDSFR be disabled. Document the requirements and
>> disable the traps if the feature is present.
>>
>> Tested-by: Leo Yan <leo.yan@arm.com>
>> Signed-off-by: James Clark <james.clark@linaro.org>
>> ---
>>   Documentation/arch/arm64/booting.rst | 11 +++++++++++
>>   arch/arm64/include/asm/el2_setup.h   | 14 ++++++++++++++
>>   2 files changed, 25 insertions(+)
>>
>> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
>> index dee7b6de864f..abd75085a239 100644
>> --- a/Documentation/arch/arm64/booting.rst
>> +++ b/Documentation/arch/arm64/booting.rst
>> @@ -404,6 +404,17 @@ Before jumping into the kernel, the following conditions must be met:
>>       - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
>>       - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
>>   
>> +  For CPUs with SPE data source filtering (FEAT_SPE_FDS):
>> +
>> +  - If EL3 is present:
>> +
>> +    - MDCR_EL3.EnPMS3 (bit 42) must be initialised to 0b1.
>> +
>> +  - If the kernel is entered at EL1 and EL2 is present:
>> +
>> +    - HDFGRTR2_EL2.nPMSDSFR_EL1 (bit 19) must be initialised to 0b1.
>> +    - HDFGWTR2_EL2.nPMSDSFR_EL1 (bit 19) must be initialised to 0b1.
>> +
>>     For CPUs with Memory Copy and Memory Set instructions (FEAT_MOPS):
>>   
>>     - If the kernel is entered at EL1 and EL2 is present:
>> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
>> index 1e7c7475e43f..02b4a7fc016e 100644
>> --- a/arch/arm64/include/asm/el2_setup.h
>> +++ b/arch/arm64/include/asm/el2_setup.h
>> @@ -279,6 +279,20 @@
>>   	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
>>   	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
>>   .Lskip_pmuv3p9_\@:
>> +	mrs	x1, id_aa64dfr0_el1
>> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
>> +	/* If SPE is implemented, */
>> +	cmp	x1, #ID_AA64DFR0_EL1_PMSVer_IMP
>> +	b.lt	.Lskip_spefds_\@
>> +	/* we can read PMSIDR and */
>> +	mrs_s	x1, SYS_PMSIDR_EL1
>> +	and	x1, x1,  #PMSIDR_EL1_FDS
>> +	/* if FEAT_SPE_FDS is implemented, */
>> +	cbz	x1, .Lskip_spefds_\@
>> +	/* disable traps to PMSDSFR. */
>> +	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
> 
> Why is this being done here rather than alongside the existing SPE
> configuration of HDFGRTR_EL2 and HDFGWTR_EL2 near the start of
> __init_el2_fgt?
> 
> Will

I thought everything was separated by which trap configs it writes to, 
rather than the feature. This SPE feature is in HDFGRTR2 so I put it in 
__init_el2_fgt2 rather than __init_el2_fgt.

I suppose we could have a single __init_el2_spe that writes to both 
HDFGRTR and HDFGRTR2 but we'd have to be careful to not overwrite what 
was already done in the other sections.

