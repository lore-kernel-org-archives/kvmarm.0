Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EE12417E4
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 13:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747747321; cv=none; b=GN07h9NfuelauIYW+CNJu3FnEUA+jVerJK8I3PyRuytoINksMTT+atl0oV2X8yEZ69nCJ1oNs4utiSzVhEYcKSbBjiChcoU+qB4CxH/47+FFi9kpsAWcCXbL8CIy+mYWQmHmhQhMs/05UOrWeMB2WD/I/pHbQv9r3/Y3Ss9UHOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747747321; c=relaxed/simple;
	bh=j8nOo9ZgCK2DEIuwn9V867mNRDlvnz48elcUZW9APXA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NeYPCqeblEuLI9ghfqgXgrCf8qenFp719mThaz2EMmYZJ951X73rXBSmCHGgnJU7ygsa3Sb5gEshel99OZzwUTqBWBLJdZjPsWqTu+fRKDMsoMqUwfjShXsqySMVAR2jBYxg/QH2AY88R5FSDRvq9NrlF7OVAdhpKp/pFZFGdA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EYtFQU5N; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EYtFQU5N"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-442f4a3a4d6so36413835e9.0
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 06:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747747318; x=1748352118; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WjE9NuES4ZYHcQwH+LLDtRp5dcXqipSvO8/PRsW1OSk=;
        b=EYtFQU5N8uVMAUQJBzbRh9cb8pwGoResF0DA6hl270l6YEEHc4Uj9o3Hs69FAvN4VI
         L6PSxMpVND6YN3DxVx4e4XU22Dq64w5J6L1SmE/zG9EstQuuFze9pyPChVjYz48x/1/I
         NaHCX0BcBcnbGUMruT5VeIwxYPaGl7Sxxiawus9/C+eXQ3nzclN2Cij4UjlLaBZ/nRE6
         gHyilV4/6rJn4kpUTr90AC1j7RT4eAXb8fiszdasytOjf2eer+Nq1DvyzW2NaK2pSvdu
         EgQzDKMp9/EShWPXoo+U0Ck1dzztGT4bDTky7hkzsqMYegESl5glf9A2lluvcSbCHlNb
         GFFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747747318; x=1748352118;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WjE9NuES4ZYHcQwH+LLDtRp5dcXqipSvO8/PRsW1OSk=;
        b=Ic/0bAeFgQkWvoiNzUAuz2Lh2czHokMAak8cOFGRx77MpKzDxSuk4iMkEzigYxXgJB
         met17pBNKt7AgvW/rZMluVkrJpOJUdG3DBrlEpz8mDQl966JoBJOuQgjM1UY1NotUl/t
         zR7WjmaoomxCCwyNZv55pXY7qBn0luTDXIhaMAXpZ0j5J44CKo704k1Opmh/u63y0vSe
         +zkKFOB8nRQSZ+SGzBeOwNOZKws9aa0rwgAw7vmJ6ZTDw1Jml7/hIi/Plz2b1g0wN7yM
         AOdYXIEsB2y37MuFgqn8yv4dVhQUmNhZy4BC6cwElBeG5atX97OfG2yUfFOLI9pZ2TcN
         VpcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTk+Se8eKtsuuyZLSSlygP+rXypigZyQ2Jm9HMqQDtJqHF2/Sg8vyc1mMDSABg2+Zlm5Oj+/0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzOlsyz4G6b9TajjiB2QnCdgQ/jLnG9pmEZoShKjsnHUvCuLnH1
	oCsilOOh3a945HajoFfLEbX4YQ5+i4ChyaBC6aVYYja6R8+zkIn61CfBd3RIDNhrbfE=
X-Gm-Gg: ASbGncv1Q3dd+kngYOLlN1wGviPxwC7X482JW6gMJ2yiR8CULmVsycTvhCJn9r2qq/w
	AQa9KCoRaAZSxjJ689t3olSdyQ2ug4DJP+ZC0TRxZMViRbIf5MmQf+kKYd2YCq+dSYRR4TdhHQb
	I1ZrVRzV6L4xe4SyyVkOW9Uy+dKMHkzHaCScCtWcNFjwUE6XbJE87OMj3yAOXBNrlbPicjV/n0u
	WxYL556XS+/rdB+Qb/qGWZ+X6HFK2fyhtgVfSqPcFPLKyxb3eBe4n2zqUB758s6skIX9rNc2d4S
	FKJjsTT4eOgfcZmEjlbWuw79lxs3cY0Wq60p9728Wdj1elJyLBcS1m3M
X-Google-Smtp-Source: AGHT+IEfO+pch615avxbBD4lcuwANYfZy4jBF+ULIb5f9fJUkNFZOMIfa+edi4Ii8A7sRlYdjSjFnA==
X-Received: by 2002:a05:600d:19:b0:442:7c40:fda4 with SMTP id 5b1f17b1804b1-442f84c209dmr181938415e9.1.1747747317684;
        Tue, 20 May 2025 06:21:57 -0700 (PDT)
Received: from [192.168.1.3] ([37.18.136.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f78aeb7fsm29898455e9.26.2025.05.20.06.21.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 06:21:57 -0700 (PDT)
Message-ID: <4b57da72-7f30-48f7-8458-d1f1e27a28f5@linaro.org>
Date: Tue, 20 May 2025 14:21:55 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/10] arm64/boot: Enable EL2 requirements for
 SPE_FEAT_FDS
To: Leo Yan <leo.yan@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
References: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
 <20250506-james-perf-feat_spe_eft-v1-4-dd480e8e4851@linaro.org>
 <20250520110450.GN412060@e132581.arm.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20250520110450.GN412060@e132581.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 20/05/2025 12:04 pm, Leo Yan wrote:
> On Tue, May 06, 2025 at 12:41:36PM +0100, James Clark wrote:
>> SPE data source filtering (optional from Armv8.8) requires that traps to
>> the filter register PMSDSFR be disabled. Document the requirements and
>> disable the traps if the feature is present.
>>
>> Signed-off-by: James Clark <james.clark@linaro.org>
>> ---
>>   Documentation/arch/arm64/booting.rst | 11 +++++++++++
>>   arch/arm64/include/asm/el2_setup.h   | 14 ++++++++++++++
>>   2 files changed, 25 insertions(+)
>>
>> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
>> index dee7b6de864f..8da6801da9a0 100644
>> --- a/Documentation/arch/arm64/booting.rst
>> +++ b/Documentation/arch/arm64/booting.rst
>> @@ -404,6 +404,17 @@ Before jumping into the kernel, the following conditions must be met:
>>       - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
>>       - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
>>   
>> +  For CPUs with SPE data source filtering (SPE_FEAT_FDS):
> 
> For alignment with Arm ARM:
> 
> s/SPE_FEAT_FDS/FEAT_SPE_FDS
> 
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
>> index ebceaae3c749..155b45092f5e 100644
>> --- a/arch/arm64/include/asm/el2_setup.h
>> +++ b/arch/arm64/include/asm/el2_setup.h
>> @@ -275,6 +275,20 @@
>>   	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
>>   	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
>>   .Lskip_pmuv3p9_\@:
>> +	mrs	x1, id_aa64dfr0_el1
>> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
>> +	/* If SPE is implemented, we can read PMSIDR and */
>> +	cmp	x1, #ID_AA64DFR0_EL1_PMSVer_IMP
>> +	b.lt	.Lskip_spefds_\@
>> +
>> +	mrs_s	x1, SYS_PMSIDR_EL1
>> +	and	x1, x1, PMSIDR_EL1_FDS_SHIFT
> 
> Should be:
> 
>          and     x1, x1, #(1 << PMSIDR_EL1_FDS_SHIFT)
> 

Nice catch. It was probably always true so I didn't notice it not working.

>> +	/* if FEAT_SPE_FDS is implemented, */
>> +	cbz	x1, .Lskip_spefds_\@
>> +	/* disable traps to PMSDSFR. */
>> +	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
>> +
>> +.Lskip_spefds_\@:
>>   	msr_s   SYS_HDFGRTR2_EL2, x0
>>   	msr_s   SYS_HDFGWTR2_EL2, x0
>>   	msr_s   SYS_HFGRTR2_EL2, xzr
>>
>> -- 
>> 2.34.1
>>

