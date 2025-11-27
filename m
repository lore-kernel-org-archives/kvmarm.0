Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90247241679
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 15:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764257196; cv=none; b=axTbMB4anElUKh/d7OlI8q1oBmXeTCdXDfjWnwXSKUxqxekBt95kanbMNzlX27yDPD7agrJEi7wUhs46s2uIaOPMeXG5h82HuK2Ai+xJAN+IW5S6L4aU7H3VJnTUYmeEnp+Udw7em/ouALlcv5j5qrBfOVMEIYEpgnd8f9oGlEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764257196; c=relaxed/simple;
	bh=q5MQgk6x2w8quyp4nLV8UziXwgEbHHC3uNAf2WnDGkY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NSZKCUQfx4PnGf1DG1Md8dKb9bScyXNhKbaN8Wc+654cU85cKZC5OpDykhmRc3xeG97MfA9yDkc7TGOuhUogvRmXBj2lFBqJQlgi7pil8abEdW0nFLRxVNkAPnTOGbuaBizpq/vrUy95sgCn50CpCXmZw1VjBOwAQnMFQJUuDBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pXDCCVol; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pXDCCVol"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4779cc419b2so9235805e9.3
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 07:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764257193; x=1764861993; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U9Sd2Vih8qCT8Sm8DHyp6voQA1fNVa6aZXqM7Jub6wE=;
        b=pXDCCVol7aWQk8RT+ryT/aoKT/feGK+wddZjt1VelkCgqLQZC8cQD45zau4LoMUz4l
         w+O6bkH/QZYjq/p/8TbUKFPoLJCpCfCeCydgRjfEqrCZEHN3xAhA7ngrr9VE7TL+pmn4
         SFnIwtSZoTJ22ktGnN8JZUSUik7dahCybYZbk8MVucG9pT0fnqgcOjigsM8ZKAAY3VYw
         5ash2lf0PSZaf41yPKcGm3gBn2A5GNO1croZzYy2pEpYotwnE/w8y0UxV1ZHCt/hzNFD
         QpyIsX/70bghjrGNoWZK2t6nSWBr9am81SbYIentmKlDcCpy2EyXhisEpVMuauoNa87G
         0uNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764257193; x=1764861993;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U9Sd2Vih8qCT8Sm8DHyp6voQA1fNVa6aZXqM7Jub6wE=;
        b=X1SLhF7IKQbIjmDRFO2srTdP+TRYlceE2z+EBO8h/NtSg7uwm6Qo5G6ySRfyhFVuks
         /MolI4NM9CT27fbFETbDCvLKD76vptgO3pyeKembS4NkjrcC0POVD5RVo3oqly7s4HMd
         3QZh+kSPFGIhWP7akb5AnlpD7GeJ9l8n1BjX5Lm1kX2fkEstPEnRqcXHoF7ffHtudU7P
         viQA9HTrTa8UojmCtjlSgI8zVnNCagK0ZMi/ZmiifGXDXv3CV9xqNEIAkovDfK/fjx44
         os94ixW+8dxrA99hsvv+pszZTOP7M4/fxIaVrtJVjMT/g7yTkKEpH75TtjvuhiL/TAzK
         l11A==
X-Gm-Message-State: AOJu0YynoKJDzMP7OYHF4LTR2McxKLsP0Ptv0TxxO4QAZ+NmjtsF0N9m
	V7TVfdbtZk8Ya8NaC91LM80ocegjOAyC/16ONDhDEg86tYuuQqAb2fQzwbDRm6XNVIU=
X-Gm-Gg: ASbGncsFp0Wj7zY6g27sVTpanRCibAbj4B5GzpCYB4E/8WDql8fFq2Optip0F9Y28ST
	mDygACHt2JIVcuQuYX6aOutHgMwnpyE4WqNQJVVud2m83Ix4sojk9Af4OZqrICTJJwMzWH7PMfZ
	LxecCTqTUn738bTt3+L/kT2Sh5iAon4XtheoBEeDzjgFTuz50FqBJkS9D1ygargoEegk7je617b
	7kR0e1J/yXCkXwn33s523QOnDVvIChlpmeQ9KLhFyMZdJc59WonZAS+Jo8HlmZmjFskTI1+qMOU
	VdXquBuyuQ4T3m5dFFMXliREmUWcxB2xUceDV7YpC1VxT22NN1Jfh9BqWvTlEKMZqYeYdXIzVdj
	eNQjBfYuHSXLuYD8/r3k7a/E2mlzGaElSl6WeXVUWN4TATSe072F7k/kDwOAdE8dBUcKfEd9BAy
	ZzFtRzY0BgUgYrX7bBXB3akTE6x9Q=
X-Google-Smtp-Source: AGHT+IFE9u2XY1HoDD/zsyLLeGS8NDSHbZP5RWiZbNOjKUta7mf7Tb07oyyYOwPyJfOjFkNhODLj5g==
X-Received: by 2002:a05:600c:35cf:b0:46e:4a13:e6c6 with SMTP id 5b1f17b1804b1-477c114476fmr266244525e9.19.1764257192799;
        Thu, 27 Nov 2025 07:26:32 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5d607csm4470702f8f.15.2025.11.27.07.26.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 07:26:32 -0800 (PST)
Message-ID: <7f1c187b-0f94-49c5-b4c9-2f414ab0ac8a@linaro.org>
Date: Thu, 27 Nov 2025 15:26:31 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/9] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
To: Fuad Tabba <tabba@google.com>, Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
 vladimir.murzin@arm.com
References: <20251118103807.707500-1-tabba@google.com>
 <20251118103807.707500-3-tabba@google.com> <868qftqehe.wl-maz@kernel.org>
 <CA+EHjTwHrLhdHrNSA8f-+bCZ1-QEuNocQQxeiaaost9oLwaG5A@mail.gmail.com>
 <865xaxqal2.wl-maz@kernel.org>
 <CA+EHjTxhOvu-733Z-gJgc6f_EAs-tksA6u5KuQZeimP6T6M-fQ@mail.gmail.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <CA+EHjTxhOvu-733Z-gJgc6f_EAs-tksA6u5KuQZeimP6T6M-fQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 26/11/2025 11:48 am, Fuad Tabba wrote:
> On Wed, 26 Nov 2025 at 11:47, Marc Zyngier <maz@kernel.org> wrote:
>>
>> On Wed, 26 Nov 2025 10:37:57 +0000,
>> Fuad Tabba <tabba@google.com> wrote:
>>>
>>> Hi Marc,
>>>
>>> On Wed, 26 Nov 2025 at 10:23, Marc Zyngier <maz@kernel.org> wrote:
>>>>
>>>> On Tue, 18 Nov 2025 10:37:59 +0000,
>>>> Fuad Tabba <tabba@google.com> wrote:
>>>>>
>>>>> The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
>>>>> register accesses. These accesses are trapped to EL2 when the bits are
>>>>> clear.
>>>>>
>>>>> The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
>>>>> had the polarity inverted. When a guest did not support the Trace Buffer
>>>>> feature, the code was setting E2TB. This incorrectly disabled the trap,
>>>>> potentially allowing a protected guest to access registers for a feature
>>>>> it was not given.
>>>>>
>>>>> Fix this by inverting the operation.
>>>>>
>>>>> Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
>>>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>>>> ---
>>>>>   arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
>>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>>>>> index 8d06a246dfd1..f6f8996c4f97 100644
>>>>> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
>>>>> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>>>>> @@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
>>>>>                val |= MDCR_EL2_TTRF;
>>>>>
>>>>>        if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
>>>>> -             val |= MDCR_EL2_E2TB_MASK;
>>>>> +             val &= ~MDCR_EL2_E2TB_MASK;
>>>>
>>>> This does not only change the trapping logic (bit 24). It also change
>>>> the ownership of the buffer (bit 25). I wonder whether you should do
>>>> something for that, maybe by clearing TRBLIMITR_EL1.E, because
>>>> otherwise, you keep tracing, but using an EL2 VA. What could possibly
>>>> go wrong?
>>>>
>>>> Overall, I'm very uneasy about TRBE in the context of pKVM.
>>>
>>> So should we clear/restore TRBLIMITR_EL1.E on guest entry/exit in
>>> protected mode?
>>
>> I think you need something of the sort, yes. Overall, SPE and TRBE
>> should be aligned on what they are allowed to do, as they are two
>> sides of the same ugly coin.
> 
> I'll fix this (or add a patch to do this, depending on how it looks)
> when I respin.
> 
> Cheers,
> /fuad
> 

To understand this, is it just belt-and-braces because you don't trust 
the current filter clearing in TRFCR_EL1? And to reduce the potential 
for mistakes leading to trace leakages? I suppose even the hardware 
itself could have some errata where it tries to access the buffer, even 
if we've completely filtered out trace and flushed before going into the 
guest.

Thanks
James

>>          M.
>>
>> --
>> Without deviation from the norm, progress is not possible.
> 

