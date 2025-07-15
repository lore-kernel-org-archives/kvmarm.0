Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D60C2E7BDA
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 13:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586105; cv=none; b=KK2Ny1WQyCEWw9RRGWMW++f00sYJnhGU4VlQSSfXMO06j6tkcZ9bIrrGAFskYZObNmorVn56ZuP3JYnlJKHLiQ3FM80cCLdtakxQXMai0FJKQ9KqKpJT4+uv04uRpf25/l2GdrZYaG4nOrC7/PXF/5tOf72BaEQEMDgsNFv8NMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586105; c=relaxed/simple;
	bh=YvW4jirI2u/zHSYKM94R24WsGr7Kz4QvYaY5H8NCEfc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=LzQJZ3Uss6TArAm3CSpyfLvDTsdkHplfd+p5LSiR7i/A1rPxBz3p9tTIDmXBzJ4Ne0xT0UnP/B4YUUviO8TchNbyBDHSsgc1LQuoS4daIZSkcp58XdCygo4+V/shikj6xt1ajLE1IvBaEXxdFLBjogPmtpiBkgQazHeI73nvVp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pddBujVX; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pddBujVX"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4550709f2c1so27209335e9.3
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 06:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752586101; x=1753190901; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zw74VlTE+k1LGKzfAzB+538GU13x3ojR1l0lw7GXER0=;
        b=pddBujVXmhkdD9YJ2GLV4au3wBYXw9BS61cKZLT3tYGUaHmYlTz+zMUjWkuIBrujQH
         W46iniye2Pk25oyA5VibDeSZHTr/paERS4njJepQgkyDBf4R8hzsJGgbbfvzqlTkZM2I
         ExfN4vnFkJa2gaz4Mo1GsZsasHBMUMLUdGepkjHgv9pQmoWcV9Xr5IbzJv3mGNdCser8
         Om9ZMPG8wwjwL/45B90UNRWEiDz85lHcVJMStdGpohW3uc8NJs4tpDeHPZV4Mzo0I1M3
         V0mWuP8uK/7kLA0S+JhcEiTWADBNwZxUiRScFHtYJAsjRNsFxRig5hf1HhiGayRkT5GF
         EkLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752586101; x=1753190901;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zw74VlTE+k1LGKzfAzB+538GU13x3ojR1l0lw7GXER0=;
        b=OuSLBnSmV8JbTqwIv6J7ZuSrHgbGvup5JqhJxVQ3QXTIoHLHi8Rku0e+LMDh2jMOnr
         vMoovukaXQiFnf705iPM7H9QvjN3bScqVPVROPwMOxh50GyDOVBCunN5ZiXQq8MU3mPJ
         wX9iLaFzZkIIG9WJr/voB0ctX12GuZhXABg6PADULpmTsz5NM3FV1wHNaqXZHMK1KSTu
         0ALyXg2yoJfm0Azfv6YlDq+tia4WcB+sxAs8GVdTshaGz9pkXfKa2EfQYDyH9kCfFMqN
         Uzw4pPOJj87YZFTK/omLY7HiABL4joqUiMAJLhbFrxBfKuRcHn0Smg1ra0xBJWHO4XNh
         97Ug==
X-Forwarded-Encrypted: i=1; AJvYcCXroKIW1TYHHaSP5eodWJwvKc/7A6KyZiLpZ+5+bsjoeEeHTb01PnvYMy2lgmXgHqjcOd04zec=@lists.linux.dev
X-Gm-Message-State: AOJu0YyW3qTeYZzxng6C1y00eziYscIxe9VFT5A5F4OqNZTqXN5Ff5xO
	XSIVGc/yq3d/22PprXTS1v0hhYBIdknJxhZOyqU6LfhDVASt7VL+bu9T01kXfYhFQHs=
X-Gm-Gg: ASbGnctsek7cH/A39Zc8HU7tlSviFwvzXDRncbdPtAYTb1lPa7xI87qYY2doupI4swz
	t2yFVVQFwZ3PFbDyY1qvTvdGU51o+F14KqYkx5SUzZLx0JElMia9Pp+coch0kQbCsfO/bZS+5fh
	7XmMc/gpajTlaTlixCzBgnki3rchd0A5nnqscMlbfJIpTwKR8E6SmnRoR+6+S99SnLyo3oDpaNZ
	ElnHQ9DdEjwlmo2mXFOlAC31syFZl0KUwjZesxuPRJXIIQYQE925mSg4d8Mqs8LnpSQ0owlkMQH
	SPPAYIeYPRDsiD8sm2nyyySiacAKwWOzMjjfLKOMxnBBAWCSsgnFy95jxMwpBAuKr4+piPzPeUb
	M9RsettKzFRzGql4dZeA9QTQTpiM=
X-Google-Smtp-Source: AGHT+IEwYlVhkOTzgfZvBe2oJ6/DRqksM/2DDeWWAHWtXNUNAJyWtZXeDWpFZAMAarhRitTCjZMLeA==
X-Received: by 2002:a05:600c:4695:b0:450:d4a6:799e with SMTP id 5b1f17b1804b1-454f4259c7cmr140093315e9.20.1752586100864;
        Tue, 15 Jul 2025 06:28:20 -0700 (PDT)
Received: from [192.168.1.3] ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454dd540b52sm161683955e9.28.2025.07.15.06.28.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 06:28:20 -0700 (PDT)
Message-ID: <80b7c29e-83b9-46a4-826e-d252ad425d4d@linaro.org>
Date: Tue, 15 Jul 2025 14:28:19 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] arm64/boot: Enable EL2 requirements for
 SPE_FEAT_FDS
From: James Clark <james.clark@linaro.org>
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
 <e1210c84-69d1-4fb2-88c2-a6a1bcb179c5@linaro.org>
Content-Language: en-US
In-Reply-To: <e1210c84-69d1-4fb2-88c2-a6a1bcb179c5@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 15/07/2025 2:10 pm, James Clark wrote:
> 
> 
> On 15/07/2025 1:57 pm, Will Deacon wrote:
>> On Tue, Jul 15, 2025 at 01:48:03PM +0100, James Clark wrote:
>>>
>>>
>>> On 14/07/2025 2:54 pm, Will Deacon wrote:
>>>> On Thu, Jun 05, 2025 at 11:49:02AM +0100, James Clark wrote:
>>>>> SPE data source filtering (optional from Armv8.8) requires that 
>>>>> traps to
>>>>> the filter register PMSDSFR be disabled. Document the requirements and
>>>>> disable the traps if the feature is present.
>>>>>
>>>>> Tested-by: Leo Yan <leo.yan@arm.com>
>>>>> Signed-off-by: James Clark <james.clark@linaro.org>
>>>>> ---
>>>>>    Documentation/arch/arm64/booting.rst | 11 +++++++++++
>>>>>    arch/arm64/include/asm/el2_setup.h   | 14 ++++++++++++++
>>>>>    2 files changed, 25 insertions(+)
>>>>>
>>>>> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/ 
>>>>> arch/arm64/booting.rst
>>>>> index dee7b6de864f..abd75085a239 100644
>>>>> --- a/Documentation/arch/arm64/booting.rst
>>>>> +++ b/Documentation/arch/arm64/booting.rst
>>>>> @@ -404,6 +404,17 @@ Before jumping into the kernel, the following 
>>>>> conditions must be met:
>>>>>        - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 
>>>>> 0b1.
>>>>>        - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
>>>>> +  For CPUs with SPE data source filtering (FEAT_SPE_FDS):
>>>>> +
>>>>> +  - If EL3 is present:
>>>>> +
>>>>> +    - MDCR_EL3.EnPMS3 (bit 42) must be initialised to 0b1.
>>>>> +
>>>>> +  - If the kernel is entered at EL1 and EL2 is present:
>>>>> +
>>>>> +    - HDFGRTR2_EL2.nPMSDSFR_EL1 (bit 19) must be initialised to 0b1.
>>>>> +    - HDFGWTR2_EL2.nPMSDSFR_EL1 (bit 19) must be initialised to 0b1.
>>>>> +
>>>>>      For CPUs with Memory Copy and Memory Set instructions 
>>>>> (FEAT_MOPS):
>>>>>      - If the kernel is entered at EL1 and EL2 is present:
>>>>> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/ 
>>>>> include/asm/el2_setup.h
>>>>> index 1e7c7475e43f..02b4a7fc016e 100644
>>>>> --- a/arch/arm64/include/asm/el2_setup.h
>>>>> +++ b/arch/arm64/include/asm/el2_setup.h
>>>>> @@ -279,6 +279,20 @@
>>>>>        orr    x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
>>>>>        orr    x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
>>>>>    .Lskip_pmuv3p9_\@:
>>>>> +    mrs    x1, id_aa64dfr0_el1
>>>>> +    ubfx    x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
>>>>> +    /* If SPE is implemented, */
>>>>> +    cmp    x1, #ID_AA64DFR0_EL1_PMSVer_IMP
>>>>> +    b.lt    .Lskip_spefds_\@
>>>>> +    /* we can read PMSIDR and */
>>>>> +    mrs_s    x1, SYS_PMSIDR_EL1
>>>>> +    and    x1, x1,  #PMSIDR_EL1_FDS
>>>>> +    /* if FEAT_SPE_FDS is implemented, */
>>>>> +    cbz    x1, .Lskip_spefds_\@
>>>>> +    /* disable traps to PMSDSFR. */
>>>>> +    orr    x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
>>>>
>>>> Why is this being done here rather than alongside the existing SPE
>>>> configuration of HDFGRTR_EL2 and HDFGWTR_EL2 near the start of
>>>> __init_el2_fgt?
>>>>
>>> I thought everything was separated by which trap configs it writes to,
>>> rather than the feature. This SPE feature is in HDFGRTR2 so I put it in
>>> __init_el2_fgt2 rather than __init_el2_fgt.
>>
>> That's fair; __init_el2_fgt isn't the right place. But the redundancy of
>> re-reading PMSVer from DFR0 is a little jarring.
>>
>>> I suppose we could have a single __init_el2_spe that writes to both 
>>> HDFGRTR
>>> and HDFGRTR2 but we'd have to be careful to not overwrite what was 
>>> already
>>> done in the other sections.
>>
>> Right, perhaps it would be clearer to have trap-preserving macros for
>> features in a specific ID register rather than per-trap configuration
>> register macros.
>>
>> In other words, we have something like __init_fgt_aa64dfr0 which would
>> configure the FGT and FGT2 registers based on features in aa64dfr0. I
>> think you'd need to have a play to see how it ends up looking but the
>> main thing to avoid is having duplicate ID register parsing code for
>> setting up FGT and FGT2 traps.
>>
>> Will
> 
> I'll give it a go but that could end up being fragile to something that 
> is dependent on two different ID registers in the future. Then we'd end 
> up in the same situation for a different reason.
> 

I think I've run into it already. Wouldn't checking for FGT and FGT2 
have to be repeated when doing each ID register? Now we only do that 
once at the start of __init_el2_fgt and __init_el2_fgt2, even if we 
might sometimes check a different ID register twice. But if we flipped 
it we'd always have to repeat those.

