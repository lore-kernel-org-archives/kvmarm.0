Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D95275103
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 13:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585023; cv=none; b=Acu1pUScgER++DG2ay222ecxeB8PJnzHbKxTFJGRB85mjaQc5gKZ5M3SlikqNu8Q3bdVnCiGlK57W9pKQLRalwhkcvY0FM/yg9GQ0h+Ry4njJ+1/i6WZT3xwXkAdLcEbP14YT0ajdm1qWvh7SzfrfyvI/cpMy/nQH2Zy3CvW4ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585023; c=relaxed/simple;
	bh=DHGtu4HwP1LgM2IMWFzTtkDx34BllDYI/W2+QZldCzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m6S8gVf9pb9RGomTF8Eg8yvR3dyo3m8jeT+Y0fb5LdBpjr22z/Y9t4bIIba31eDzbUfazltNzgoeODEeFG60m3PnCmneX0+nwmfBT286gaTOwc5PgZE9qM3tY1cOH916Rn0XNTM/FwB8K3eMQthq7rQ6V5Kt4OfT2GFRwC4fm6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yR/zBDzp; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yR/zBDzp"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a53359dea5so2866813f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 06:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752585020; x=1753189820; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WLie5zOVyoKUjA33oPyC/WGRzvoFygYuppsebPS2FNA=;
        b=yR/zBDzpI1c+9jfngeHSDNGKEcKwdOn0AW+gze4rXcXDjK+E4aJEDAaZhCrRxISDso
         jT9Z8a0x7IORsAMAP6I41MFrzXRv49u9ikgtxl4TTyuuQ0AN56ujOWPw6oT8umeLA0n4
         Zw8bU5CmbsZGZBKtV2JVfCWbIV50hxOnjhzGrVmpNl4G+95kJP7nTvoi1rkq56SYDeRs
         eNQcbKGBvCaipdpNblHNv0iBFJdYYbMBA6f84oGsxbsSBrQd/OBnNAsVEp4A9wA/99Cg
         70ihYhE0qFc2gIsIibvPZ7uqZoy6fEjHQkmUEzEZ1tEHrl+zOrt/YG5yMHTR8Jb0zPIC
         yQ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752585020; x=1753189820;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WLie5zOVyoKUjA33oPyC/WGRzvoFygYuppsebPS2FNA=;
        b=CfeIWhKWL3TIRtQNsmoKKSIXIEq1Pwo3qeeNOJde2xrUZWMVSzAo/A0Ip0p3Og8Ntj
         jyzztYTxt4wGRipDEv6LJL/GYxYc1ObC5aRP0zFpqEDxDv4OUPiUrosVLpScoa0adCyi
         vH0PY+X4khfSkFvC7YRkzoPYA91bFJ5DP8HUjP/PRnATrPL3ZSk5acqr5ZYxuyl32Oxy
         h78ymg6sekEyeY6SYERR2x9QHhWmYMfPQN6AWgdqfGKttbs1UyVZL6SEJIzTOPDYxf16
         blhfD3jZTL99Ds/G782Ugczp0hgK+1BJQZwVGLGARyq9Dqh+TXx5jUI1DmXPZ80kqBB+
         XtGw==
X-Forwarded-Encrypted: i=1; AJvYcCWwVexKDPUTmmNi0bxfyFbxO6LP9t4hPHmJwiwEDt7XRwho9N3cosZqNRGcnRYZjcQ/b6jh194=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw03jDgCFQHkB7rGmI6Qku5VNV2yI2gDeMIIgLXHD1t1WztJtV3
	t+a1H+B38vx+GxXV/nLvzWZsqeiWVK6tVNKItrBlpeyM7CLdLgFkB5mTBk3Fu5IRv8M=
X-Gm-Gg: ASbGncszU3RK79Iyu9F3AUYxy4lOgR5RSe6HttMKXS3EkAXBp5E+8OSnvtk1+Eqov+H
	QMal7pdCmy8V+n0nPEjzj+B2IwadZLZyLN8AN0Kuxx1e/+Nx4rrmUj1tJwxUM4bOjsuct7kik1c
	jbAM5ADMxBz6twWoHvT4lrXE5y6I7rW7j5PBjybDNaDldZU+W1gf1C/zfX6RgjoiKb88gJKAk+x
	DtpAcfOP27WQnkI3zyqpMMbVZBrAGwJ+Swxn04usf1YDiDT6Sgm7/wzfJ4ZaDI70FJshplg2YZq
	19KXbCFpsWnF/sNk1u2RRi0NwMPWj6hwCrhCkU58aOLtD8qmDN+nUX+XtxPEAlrYJSBW6pC3ura
	cc2oEeZWl3AMODeGAfrmdJ3TRPO8=
X-Google-Smtp-Source: AGHT+IFe4r8KriuNAFHXNYf/4cwh/PGYuzAM7nUnVEwSGtbr0UTcF5cgzYyzCdphFsVFvt+3gZMD1g==
X-Received: by 2002:adf:9d82:0:b0:3a4:f5f6:b4ab with SMTP id ffacd0b85a97d-3b5f2dfd6f7mr10433427f8f.30.1752585020307;
        Tue, 15 Jul 2025 06:10:20 -0700 (PDT)
Received: from [192.168.1.3] ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4560733e736sm104730995e9.29.2025.07.15.06.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 06:10:19 -0700 (PDT)
Message-ID: <e1210c84-69d1-4fb2-88c2-a6a1bcb179c5@linaro.org>
Date: Tue, 15 Jul 2025 14:10:18 +0100
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
 <04d52182-6043-4eaf-a898-9f8ccc893e5f@linaro.org>
 <aHZQH7QGhi5pbXU8@willie-the-truck>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <aHZQH7QGhi5pbXU8@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 15/07/2025 1:57 pm, Will Deacon wrote:
> On Tue, Jul 15, 2025 at 01:48:03PM +0100, James Clark wrote:
>>
>>
>> On 14/07/2025 2:54 pm, Will Deacon wrote:
>>> On Thu, Jun 05, 2025 at 11:49:02AM +0100, James Clark wrote:
>>>> SPE data source filtering (optional from Armv8.8) requires that traps to
>>>> the filter register PMSDSFR be disabled. Document the requirements and
>>>> disable the traps if the feature is present.
>>>>
>>>> Tested-by: Leo Yan <leo.yan@arm.com>
>>>> Signed-off-by: James Clark <james.clark@linaro.org>
>>>> ---
>>>>    Documentation/arch/arm64/booting.rst | 11 +++++++++++
>>>>    arch/arm64/include/asm/el2_setup.h   | 14 ++++++++++++++
>>>>    2 files changed, 25 insertions(+)
>>>>
>>>> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
>>>> index dee7b6de864f..abd75085a239 100644
>>>> --- a/Documentation/arch/arm64/booting.rst
>>>> +++ b/Documentation/arch/arm64/booting.rst
>>>> @@ -404,6 +404,17 @@ Before jumping into the kernel, the following conditions must be met:
>>>>        - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
>>>>        - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
>>>> +  For CPUs with SPE data source filtering (FEAT_SPE_FDS):
>>>> +
>>>> +  - If EL3 is present:
>>>> +
>>>> +    - MDCR_EL3.EnPMS3 (bit 42) must be initialised to 0b1.
>>>> +
>>>> +  - If the kernel is entered at EL1 and EL2 is present:
>>>> +
>>>> +    - HDFGRTR2_EL2.nPMSDSFR_EL1 (bit 19) must be initialised to 0b1.
>>>> +    - HDFGWTR2_EL2.nPMSDSFR_EL1 (bit 19) must be initialised to 0b1.
>>>> +
>>>>      For CPUs with Memory Copy and Memory Set instructions (FEAT_MOPS):
>>>>      - If the kernel is entered at EL1 and EL2 is present:
>>>> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
>>>> index 1e7c7475e43f..02b4a7fc016e 100644
>>>> --- a/arch/arm64/include/asm/el2_setup.h
>>>> +++ b/arch/arm64/include/asm/el2_setup.h
>>>> @@ -279,6 +279,20 @@
>>>>    	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
>>>>    	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
>>>>    .Lskip_pmuv3p9_\@:
>>>> +	mrs	x1, id_aa64dfr0_el1
>>>> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
>>>> +	/* If SPE is implemented, */
>>>> +	cmp	x1, #ID_AA64DFR0_EL1_PMSVer_IMP
>>>> +	b.lt	.Lskip_spefds_\@
>>>> +	/* we can read PMSIDR and */
>>>> +	mrs_s	x1, SYS_PMSIDR_EL1
>>>> +	and	x1, x1,  #PMSIDR_EL1_FDS
>>>> +	/* if FEAT_SPE_FDS is implemented, */
>>>> +	cbz	x1, .Lskip_spefds_\@
>>>> +	/* disable traps to PMSDSFR. */
>>>> +	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
>>>
>>> Why is this being done here rather than alongside the existing SPE
>>> configuration of HDFGRTR_EL2 and HDFGWTR_EL2 near the start of
>>> __init_el2_fgt?
>>>
>> I thought everything was separated by which trap configs it writes to,
>> rather than the feature. This SPE feature is in HDFGRTR2 so I put it in
>> __init_el2_fgt2 rather than __init_el2_fgt.
> 
> That's fair; __init_el2_fgt isn't the right place. But the redundancy of
> re-reading PMSVer from DFR0 is a little jarring.
> 
>> I suppose we could have a single __init_el2_spe that writes to both HDFGRTR
>> and HDFGRTR2 but we'd have to be careful to not overwrite what was already
>> done in the other sections.
> 
> Right, perhaps it would be clearer to have trap-preserving macros for
> features in a specific ID register rather than per-trap configuration
> register macros.
> 
> In other words, we have something like __init_fgt_aa64dfr0 which would
> configure the FGT and FGT2 registers based on features in aa64dfr0. I
> think you'd need to have a play to see how it ends up looking but the
> main thing to avoid is having duplicate ID register parsing code for
> setting up FGT and FGT2 traps.
> 
> Will

I'll give it a go but that could end up being fragile to something that 
is dependent on two different ID registers in the future. Then we'd end 
up in the same situation for a different reason.

