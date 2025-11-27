Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2DF33711E
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 16:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764259570; cv=none; b=VKP0v7wDjQuL3uwR6WKWZ8cFvSxfPQj3e4fXZRdeJLqAQbr34hzazf3V83oO3+oDRXIERR/A6c3j6WHVEhl1RCxOTGl6EX/z4jftZL0NRoJ5SDwxenDlcDJSfRAhTPCo8+ZAE6t2BgyxR0HjukLAfFcC0YznOtj6ec5nmTd2J5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764259570; c=relaxed/simple;
	bh=kmahJYT/U1sUVliXuwsGWE0dWyIVH4fz8LL9/Q3fIpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZaJQykXAQ2vhecmRhLbfffumbn9AHgWSThKdBt7jjAJnpyjS0zIhsYhzTBDPBNil02PdhHUC+CNvBgGw+eXg2OnRCi0p3j8QkFKyM4U2r6necFJ1VTHKTpDQo77N5BQvlMhR1kNBJ5YuR5+KoPDoLwWPW8xx9LnabokFFPyJcio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Pu5p0aVT; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Pu5p0aVT"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4775e891b5eso4203745e9.2
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 08:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764259565; x=1764864365; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JgLhNlGBxxZ/bcP1dxKz7JY8wkd1hqfFpzF2EgicKXk=;
        b=Pu5p0aVTFOBWsCy5n30SJ/MAVnKDduArwVP8rMt3oNEOCTLQBWADLlLL21OdSGD2DO
         20LDkdpBdjwEPA40YuHLamNO4VBxgzEMev2VXWdBLuty8i4izK2ta8I2zMQmkO2u1Exj
         0FVgCsMYm7LTQHmJjt58r7EWbzI/G8uP9Id7WGUDcSyLSGVxQcfcUf+k+h3lDYEfNCUa
         5n80H0PQSWPuB2mDjcpP9S5HExy5h+GM0mP36/+ba2juUdlKKtKoA52XxaN03jcVMGBs
         E3Jpnf4GoVyFneS4Xzzw+TKq+yb3imBIVZhCc8wi4P+fBFHEe+QpKK6t2qmbxTESeEna
         Wogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764259565; x=1764864365;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JgLhNlGBxxZ/bcP1dxKz7JY8wkd1hqfFpzF2EgicKXk=;
        b=e7fpGsrlRCYY33XtTP1jH8qcPpiLV4oVDnedbbogQzOhifyaoG3cs7jgRhbP5dwaNz
         HFg+FTKsg6O3y9bKyN4EO6Go32vibt+HknV20+59wljVZwXnhbEvQpD1jHFRZS7wW9on
         y9eyTwBS8/EP4x7B1bZFZi0qJ7jdR0zZaUZXQQkWcXhXgOwwsxA6xzX3wRONpylLNMnQ
         m4j5CAHwMC7FYaHhMoWzpzteqtfb7EEaFtlLeYHFBXUs3LLS9KDZUD9YOfd30rtUCaGi
         NQxb2byHVIU0dWtYBlhDqg2fmhwachBJorZTtsyPfY81wOgmIneK+DWBZobMRaofFvYX
         6lkw==
X-Forwarded-Encrypted: i=1; AJvYcCUrr/wIL722qduKFiYBOiYo7cz2z7Yr/XJpGQo2VdNGWCEqzzpzD2aNNHzxqh7lq71AP8yOB3M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/xN0WxjDieN91c3i0+KFQdU+2TscHZMuljddXOz8rBXKvOiM5
	W8hUhzGXKRLF8zihR3vsNUzb83KA2sivNOW7v1hBEDNqMsdsyOusk3pTX6qM2HAAcEc=
X-Gm-Gg: ASbGncsp2R1MZdExzeIY5r2RHqeWjC5ZfnqkoNM7yZ+2FLbFNvKy/fZgXz7nLELqAfe
	kRmOYm9K9m/X2CXo0X5UuXezflvAMjpFSRKdCDlWmox325BR+QifcjvDQmLhMJdOhjpDu5IrpRV
	RNMJhO64L2HBmjINZ576Zv6dIoCREpp3VhiH7c2XdS3XKs7UNbOd+yf8jtUynckJ/roYlRYUwnN
	OQKo4QaI3wR/Td35bE9vg+dwjFDWPW9VzAjerq8hY2aVT6wAgIxAe7pfsgtzp1qjURGyIsy0YiW
	KXP5M6FLZneV8+SFeldu91zl+Kee7OAKtxBUWWeoV7wIGYFnqBtluuO2kFFVtsM8D9V1I3RGnks
	GjUMx7SMUJVnT0ggVzIwkmGW5MeB+ID4lYvRzXFZ2R6ggwIcHLqzgaQIB/TJZ8equL0cFbtqXBa
	oLmFNm/Nj1HT72+nLl
X-Google-Smtp-Source: AGHT+IFd9I+MmnaEMQk6demrAoVGoCPphB4zs199dHJzb+2basSo2qxFJnPsP5KLuHB7Gfc2J3XgJA==
X-Received: by 2002:a05:600c:3590:b0:471:672:3486 with SMTP id 5b1f17b1804b1-477c0184a94mr305082995e9.15.1764259564822;
        Thu, 27 Nov 2025 08:06:04 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4790ab8bb21sm107834545e9.0.2025.11.27.08.06.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 08:06:04 -0800 (PST)
Message-ID: <7dadacee-b95d-49a2-88b0-73367dab25ed@linaro.org>
Date: Thu, 27 Nov 2025 16:06:03 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/9] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev,
 will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, catalin.marinas@arm.com, vladimir.murzin@arm.com
References: <20251118103807.707500-1-tabba@google.com>
 <20251118103807.707500-3-tabba@google.com> <868qftqehe.wl-maz@kernel.org>
 <CA+EHjTwHrLhdHrNSA8f-+bCZ1-QEuNocQQxeiaaost9oLwaG5A@mail.gmail.com>
 <865xaxqal2.wl-maz@kernel.org>
 <CA+EHjTxhOvu-733Z-gJgc6f_EAs-tksA6u5KuQZeimP6T6M-fQ@mail.gmail.com>
 <7f1c187b-0f94-49c5-b4c9-2f414ab0ac8a@linaro.org>
 <CA+EHjTxpTKFQwWHR6vBVxC_a6dpza_bgCmxTXSbWjT7wfJh2TA@mail.gmail.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <CA+EHjTxpTKFQwWHR6vBVxC_a6dpza_bgCmxTXSbWjT7wfJh2TA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 27/11/2025 3:38 pm, Fuad Tabba wrote:
> On Thu, 27 Nov 2025 at 15:26, James Clark <james.clark@linaro.org> wrote:
>>
>>
>>
>> On 26/11/2025 11:48 am, Fuad Tabba wrote:
>>> On Wed, 26 Nov 2025 at 11:47, Marc Zyngier <maz@kernel.org> wrote:
>>>>
>>>> On Wed, 26 Nov 2025 10:37:57 +0000,
>>>> Fuad Tabba <tabba@google.com> wrote:
>>>>>
>>>>> Hi Marc,
>>>>>
>>>>> On Wed, 26 Nov 2025 at 10:23, Marc Zyngier <maz@kernel.org> wrote:
>>>>>>
>>>>>> On Tue, 18 Nov 2025 10:37:59 +0000,
>>>>>> Fuad Tabba <tabba@google.com> wrote:
>>>>>>>
>>>>>>> The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
>>>>>>> register accesses. These accesses are trapped to EL2 when the bits are
>>>>>>> clear.
>>>>>>>
>>>>>>> The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
>>>>>>> had the polarity inverted. When a guest did not support the Trace Buffer
>>>>>>> feature, the code was setting E2TB. This incorrectly disabled the trap,
>>>>>>> potentially allowing a protected guest to access registers for a feature
>>>>>>> it was not given.
>>>>>>>
>>>>>>> Fix this by inverting the operation.
>>>>>>>
>>>>>>> Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
>>>>>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>>>>>> ---
>>>>>>>    arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
>>>>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>>>>>>> index 8d06a246dfd1..f6f8996c4f97 100644
>>>>>>> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
>>>>>>> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>>>>>>> @@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
>>>>>>>                 val |= MDCR_EL2_TTRF;
>>>>>>>
>>>>>>>         if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
>>>>>>> -             val |= MDCR_EL2_E2TB_MASK;
>>>>>>> +             val &= ~MDCR_EL2_E2TB_MASK;
>>>>>>
>>>>>> This does not only change the trapping logic (bit 24). It also change
>>>>>> the ownership of the buffer (bit 25). I wonder whether you should do
>>>>>> something for that, maybe by clearing TRBLIMITR_EL1.E, because
>>>>>> otherwise, you keep tracing, but using an EL2 VA. What could possibly
>>>>>> go wrong?
>>>>>>
>>>>>> Overall, I'm very uneasy about TRBE in the context of pKVM.
>>>>>
>>>>> So should we clear/restore TRBLIMITR_EL1.E on guest entry/exit in
>>>>> protected mode?
>>>>
>>>> I think you need something of the sort, yes. Overall, SPE and TRBE
>>>> should be aligned on what they are allowed to do, as they are two
>>>> sides of the same ugly coin.
>>>
>>> I'll fix this (or add a patch to do this, depending on how it looks)
>>> when I respin.
>>>
>>> Cheers,
>>> /fuad
>>>
>>
>> To understand this, is it just belt-and-braces because you don't trust
>> the current filter clearing in TRFCR_EL1? And to reduce the potential
>> for mistakes leading to trace leakages? I suppose even the hardware
>> itself could have some errata where it tries to access the buffer, even
>> if we've completely filtered out trace and flushed before going into the
>> guest.
> 
> Yes, we don't trust the host. The pKVM threat model is to protect
> against a malicious host.
> 
> Getting into hardware errata... that's a can of worms. I haven't
> considered that.
> 
> Cheers,
> /fuad
> 
> 

But the hypervisor already clears the filters, equivalent to clearing 
TRBLIMITR_EL1.E. Which is why I was wondering if there was something 
extra on top of the model where the host isn't trusted. I would assume 
that without anything more specific that just clearing the filters is 
enough. If we trust the hardware then it is anyway.

>> Thanks
>> James
>>
>>>>           M.
>>>>
>>>> --
>>>> Without deviation from the norm, progress is not possible.
>>>
>>

