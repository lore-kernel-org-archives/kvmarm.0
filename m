Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9B1248BA7
	for <kvmarm@lists.linux.dev>; Wed, 15 Jan 2025 10:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937793; cv=none; b=P1OAgrGhLEm5gwdwMMgUuhMcP0Z6Sfc+qWX71ouY5hZuzg5WbCaDWYSlZRobR0652ROpUWCwVeA6bwCZqHlgYhwFg9nTL7WFxKA8Ju/XtJRzt+3Ervm6rPRGnudKgIOu/lA4hbw3FcW/S9LkIVTv+ourQ2jHjWRtI/wWfzwkerQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937793; c=relaxed/simple;
	bh=OKWAVRmhaf3tI7/5pG8K5jZ5soGMNLBWA5gJVGgtvcs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YHjQIibOCdMhvn+ojc2PoRlknl+QxkUPSHJk1O0O7rDvuNV1Y2YY5LKbnjID1vj/288fFiO99SsPQKcKfr1WJHDZZ5awLpEvzwSWlYAQGK7zrDTfHI2ImzgC/E0SMwB7e+h7L8xQtk0/4zbXwpM8/s0AKFqafulXcsnt6nbv7+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XgJwfl7b; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XgJwfl7b"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4362f61757fso62633885e9.2
        for <kvmarm@lists.linux.dev>; Wed, 15 Jan 2025 02:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736937789; x=1737542589; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IuwpVltn309qfmL16lWjbYMBdtIq26uOZE014kztbkU=;
        b=XgJwfl7bfpNYM8aEKU1CHJ94flxu0LAAoXB9FB9uQGBNslv0jD+1yHNnbQw5jTqafb
         RcqV+s1Uwrm1eEkDTI1voAkMTsh1WzoEWGcs28lt0hLT7uSMj42enTlB+jZ3CRFHFw2D
         47MHgp7qw5+RrPm9m/mRxc1TvwkaVIGCIegcdaXmWCVscKPSk71u1CsrT00Hw+v2bgj+
         eKWDfUC6WnowdjrHolKIhE202ZifOwatCdVoQzvsW5CqzM9vu93LeAeBGw3ge63yDBd2
         sq04NhekKbnaz24J8vzgAZyswySznxHU1RDQFsBcO9IBYnofWK2tgmWbqcZNxiuBgpon
         kJow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736937789; x=1737542589;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IuwpVltn309qfmL16lWjbYMBdtIq26uOZE014kztbkU=;
        b=cA7/C2Zj709Lj1wdBIRCojcJgjqX9DbPDejRBAoXSh2bnDQdSkxZYHwSMwBAct1S55
         UVF++uDOO5wvRlLynVe679z5q9Ek5RV4jS5MUAs90Zf8uLMN7HUozX5uhu34l5GPYBUV
         jaiTA3dNukTYZ3Hje7JU+g7KopqDKGZf2aN1FZ0ur7amGTf+rl00tlMiCY/pr9FWZiwz
         5VeWSkdFRyxeNkBr0TUVfd6ayDhtmwUa+rJaTo17rIKnNSNtum48BpIai/EFOIw7c8sZ
         anWwXbyvBaB0q1NxWkMZ97mq/p0beTxccZ0UnmltCVqUsQQmDZ4KY+nosSt1mpkCJApc
         pBzQ==
X-Gm-Message-State: AOJu0YwzCqpmp/kT3ItnbeY5dQorOXWy/Nx4VhOGuuRQEyEnmRznLzk7
	dRqVk5wTsByilRx95TLEi8fXuq7vrtZROWlb4x4/N6Pu/ewb9qAWghmgBLhPsJU=
X-Gm-Gg: ASbGncsnuw9PPzOLG2x7XH0x22ktGxwzOtPFOjNoXWB0r6p53M/Fs6ZoC2zVJEHnePy
	U6IrVcJrx2b1gjvw4hUyijiUN3hCo9Uqwi8LSnAqlnZ1UZZ3pyzQK0cKA5TCQW3uAnOkkZWcx5k
	QsRfvLuHdTNwDDUyAl8K/6rrXrV3eR1um8UwgaAKQc13T6YTU69t2FYpqH/acnVkgZ5B5gYtLq8
	F/sRHNRNTaKaXyM/fSOHCO1bpvyWqDrdUMQaL0ahFE/Wr0vJwXj4L6vdrI00f0+hg==
X-Google-Smtp-Source: AGHT+IH3uacZBQlbJPYFrF7NDg04bYz2rstXelNvRE0i6b50wPcyzW0FqOTBm1F5gkICT1asCeDs4A==
X-Received: by 2002:a05:600c:4e8c:b0:434:f5c0:3288 with SMTP id 5b1f17b1804b1-436e271d355mr261062685e9.29.1736937789135;
        Wed, 15 Jan 2025 02:43:09 -0800 (PST)
Received: from [192.168.68.163] ([145.224.90.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38be2b0bf2esm3908161f8f.57.2025.01.15.02.43.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 02:43:08 -0800 (PST)
Message-ID: <b4082b98-e234-4825-9935-971a630f438b@linaro.org>
Date: Wed, 15 Jan 2025 10:43:07 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 04/10] arm64/sysreg: Add a comment that the sysreg
 file should be sorted
To: Rob Herring <robh@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 coresight@lists.linaro.org, James Clark <james.clark@arm.com>,
 Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mike Leach <mike.leach@linaro.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Rutland <mark.rutland@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Shiqi Liu <shiqiliu@hust.edu.cn>, James Morse <james.morse@arm.com>,
 Fuad Tabba <tabba@google.com>, Raghavendra Rao Ananta <rananta@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250107113252.260631-1-james.clark@linaro.org>
 <20250107113252.260631-5-james.clark@linaro.org>
 <87frloqjso.wl-maz@kernel.org>
 <760969b6-18b7-42ac-9524-2f1f845b3703@linaro.org>
 <86jzaywtea.wl-maz@kernel.org>
 <CAL_JsqJFgunOVqpXnj+0HQ_HYbbVrtjCTJ25KzJHhjay-0i5tQ@mail.gmail.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <CAL_JsqJFgunOVqpXnj+0HQ_HYbbVrtjCTJ25KzJHhjay-0i5tQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 14/01/2025 6:16 pm, Rob Herring wrote:
> On Mon, Jan 13, 2025 at 10:49 AM Marc Zyngier <maz@kernel.org> wrote:
>>
>> On Mon, 13 Jan 2025 15:43:39 +0000,
>> James Clark <james.clark@linaro.org> wrote:
>>>
>>>
>>>
>>> On 12/01/2025 12:49 pm, Marc Zyngier wrote:
>>>> On Tue, 07 Jan 2025 11:32:41 +0000,
>>>> James Clark <james.clark@linaro.org> wrote:
>>>>>
>>>>> From: James Clark <james.clark@arm.com>
>>>>>
>>>>> There are a few entries particularly at the end of the file that aren't
>>>>> in order. To avoid confusion, add a comment that might help new entries
>>>>> to be added in the right place.
>>>>>
>>>>> Reviewed-by: Mark Brown <broonie@kernel.org>
>>>>> Signed-off-by: James Clark <james.clark@arm.com>
>>>>> Signed-off-by: James Clark <james.clark@linaro.org>
>>>>> ---
>>>>>    arch/arm64/tools/sysreg | 2 ++
>>>>>    1 file changed, 2 insertions(+)
>>>>>
>>>>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>>>>> index b081b54d6d22..4ba167089e2a 100644
>>>>> --- a/arch/arm64/tools/sysreg
>>>>> +++ b/arch/arm64/tools/sysreg
>>>>> @@ -48,6 +48,8 @@
>>>>>    # feature that introduces them (eg, FEAT_LS64_ACCDATA introduces enumeration
>>>>>    # item ACCDATA) though it may be more taseful to do something else.
>>>>>    +# Please try to keep entries in this file sorted by sysreg
>>>>> encoding.
>>>>> +
>>>>>    Sysreg   OSDTRRX_EL1     2       0       0       0       2
>>>>>    Res0     63:32
>>>>>    Field    31:0    DTRRX
>>>>
>>>> "Do as I say, don't do as I do".
>>>>
>>>> I don't think this makes any sense if we don't actually sort the file
>>>> the first place.
>>>>
>>>>      M.
>>>>
>>>
>>> I think it's ok if it avoids review comments that new entries should
>>> be sorted. Or maybe we do the opposite and the comment should say this
>>> file is allowed to be unsorted...
>>
>> The better option would be to add the comment *and* sort the file.
>> Leading by example has some value, it seems.
> 
> IME, it's better if documentation just states what the tools enforce.
> 
> Can't we add something like this to the header generation:
> 
> $ grep '^Sysreg\s' arch/arm64/tools/sysreg | sort -n -k3 -k4 -k5 -k6 -k7 -c
> sort: -:22: disorder: Sysreg ID_MMFR4_EL1       3       0       0
>   2       6
> 
> Rob

Actually I updated gen-sysreg.awk to fail the build if it's not sorted, 
was just about to post it. I don't know if a build failure or a warning 
is preferred but I can do either.

James

