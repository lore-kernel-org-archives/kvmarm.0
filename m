Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D30315D32
	for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 10:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764153592; cv=none; b=E7jBihznAdIfLUSybBce/j4GUmBCbHoyDK6vcQ5ZpTLfTRBlHyCVfXLpqLr4MgCFhOGDyJ6n6xMK29oWjK7kphLk0ZVsE/XzAyMCQlhBj+hr5Bolzr/nf3oyRUvwCBeeb9Sy8iFWFej50vRdwX0q1AAYpXr/pHd8vcZVW+wpkqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764153592; c=relaxed/simple;
	bh=GiBB5G+Aqnh1FDhC7QwseYL8TcaCU1oeu9wE+h0dz0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QrFIoRrQQYgWRWzziDwGrXBDwCxRg0+57AtyifLVPZgOu9oM+WaHjCpdg5DKvJYvqqR+kMYBBUy64KPD2+SKoIwTObUS/mvV5ji6SkW4P8AxrEV7Nkl6YAeyQLcQd8OWfQcU1vT6UvsXdzbjbAZM5/8JiHlqqF3Fs7ovAIYsw20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PcytcZKC; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PcytcZKC"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so53798685e9.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 02:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764153589; x=1764758389; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bxza/3SKXHd409Aa8RQXPAQ4jTblvmLnATZt2Kv56vA=;
        b=PcytcZKCste3iaaDQSYCTh+MfDmeHoAy05hygJmhr93sz59+/lZ3wh1oAo4lQgfphh
         aDenPfidMhijzI52jgrKbu45xueSu9sBdnnCu9Zx537LeWHBXnZkMAL9Ze2ZLCtEKC7/
         BEbm4dwZa/dvwnHJ4vZFhLWfUx89BooPUN8xifsX3Tw6PDgwhrmWWjE1/LFslSc+PWj+
         cg+oyrCaN7FX7gU3gWUt//Eqm27eGiZerSzdwKyh6KJkgOf3e5jibdV2UvEeXFInykUF
         2N9UAU2McPVdpJ7atn9jiHwWvTmPyxnDSEl5EtaiGiesBm5lI2qc5P+k7FicHoRsfyt2
         FGHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764153589; x=1764758389;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bxza/3SKXHd409Aa8RQXPAQ4jTblvmLnATZt2Kv56vA=;
        b=iCXiWlSwFs8Fz80ZvmJafH7I22TkF0rcyymaL61bCNz+Hpb4w56aJ4zm5KQXJAEI5M
         wyDRgRR4Lfhs6DJ/gFW5g8PcRTq6O2omzQK3I9T8Af++/qp28HS0R/4DPwCYCefySIPc
         WSQcqsuKrl09/BSrXMSsXNUAhg9oLtBF6oacR0DiHOtjVAf9EgeHCOHa3kLqGZLXXApf
         UnvJDqXRc4CqXl3sJFVkZFtmCTTqnJTbyYcC4EcHeQkkWy6jGMx4ZvLPuCtXpoQXaNr6
         bto+A9Nyhpt88QuIdobWoPaBVl+MHdrza/0dhtLhactM+zOWfsIhnI+fVogCN4YOQlaZ
         J0cA==
X-Forwarded-Encrypted: i=1; AJvYcCVAoSSAAb9lT10senTAMm6qVBKG6tX/j4pWmMzqS1QmehrSgij9GroM7q6wv3gGKgVTUd5mFCQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxko5Buh/wNwCktrpwgm3KCFt7tiZWV0hlGcuvuefsaTT+nQRRJ
	SmrXI1TlV3rjO30f47cXhdKyTNWQm8E5rO2mY07LNwMggQE3ZRFjGuXO9M8lDU5OqsU=
X-Gm-Gg: ASbGncuQr1qb0smpjRSozYsKwxbpF5FBDH3q6V4FozleLPGLAp2BSN15a5SOyuiP8H3
	BNAyIMF1khom2Iz86rPbEhhH06MMwxk5qPhyq2EiQjJox0msdRfC/Fc/Wg0E4LJlJd34vlArqvZ
	0T/+ltB7ydVZSMBX9vgodjEDJIKNl8qE190XBIhcDhM2iDEVcS7W4DLQwL/JIPYR149gXfGTLZM
	FJ6ybHWFdhml9HisHTNNff/NBmfIhFKswIEHSDx+Wb8QSFn2IbAUakso398QXCZze8WXszXfj5+
	6Y0rSH+++FKMbwq8wtL8n39/JMfdKiEU4jGb8TQGYebepo7FCnfnNF9/GfHpYXRLWqydqOGl2SE
	BfNNmLBcXQT8Jf9IbL0NYqZnKhsphGk8uRSZPXTEp4xyxvODBmPZZXJKZ1YMpSTjT0ULBec/0f9
	84mb6KW5lH5QFOPJut
X-Google-Smtp-Source: AGHT+IGKtExUbJnxcGGKvR36YLY3OWpg08hT9iriQX5fOK8lXGwfEtyh/qpXmy0knkF82WWk+yo2sw==
X-Received: by 2002:a05:600c:3112:b0:475:e09c:960e with SMTP id 5b1f17b1804b1-47904b2c36emr61263295e9.32.1764153589036;
        Wed, 26 Nov 2025 02:39:49 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fd8baesm40011380f8f.39.2025.11.26.02.39.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 02:39:48 -0800 (PST)
Message-ID: <2809e0bd-59ce-4b80-b8ce-d1c1c9234b81@linaro.org>
Date: Wed, 26 Nov 2025 10:39:47 +0000
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
 <d94e17d3-41db-42f8-8039-e1d6a694788c@linaro.org>
 <CA+EHjTzizVuHXeULzyiV8cetcGMXHro=-UeqWb=cFKf1tR0aZw@mail.gmail.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <CA+EHjTzizVuHXeULzyiV8cetcGMXHro=-UeqWb=cFKf1tR0aZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 26/11/2025 10:36 am, Fuad Tabba wrote:
> Hi James,
> 
> On Wed, 26 Nov 2025 at 10:29, James Clark <james.clark@linaro.org> wrote:
>>
>>
>>
>> On 26/11/2025 10:23 am, Marc Zyngier wrote:
>>> On Tue, 18 Nov 2025 10:37:59 +0000,
>>> Fuad Tabba <tabba@google.com> wrote:
>>>>
>>>> The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
>>>> register accesses. These accesses are trapped to EL2 when the bits are
>>>> clear.
>>>>
>>>> The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
>>>> had the polarity inverted. When a guest did not support the Trace Buffer
>>>> feature, the code was setting E2TB. This incorrectly disabled the trap,
>>>> potentially allowing a protected guest to access registers for a feature
>>>> it was not given.
>>>>
>>>> Fix this by inverting the operation.
>>>>
>>>> Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
>>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>>> ---
>>>>    arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>>>> index 8d06a246dfd1..f6f8996c4f97 100644
>>>> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
>>>> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>>>> @@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
>>>>               val |= MDCR_EL2_TTRF;
>>>>
>>>>       if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
>>>> -            val |= MDCR_EL2_E2TB_MASK;
>>>> +            val &= ~MDCR_EL2_E2TB_MASK;
>>>
>>> This does not only change the trapping logic (bit 24). It also change
>>> the ownership of the buffer (bit 25). I wonder whether you should do
>>> something for that, maybe by clearing TRBLIMITR_EL1.E, because
>>> otherwise, you keep tracing, but using an EL2 VA. What could possibly
>>> go wrong?
>>>
>>> Overall, I'm very uneasy about TRBE in the context of pKVM.
>>>
>>> Thanks,
>>>
>>>        M.
>>>
>>
>> Don't we already clear TRBLIMITR_EL1.E in __trace_needs_drain() for pKVM
>> when switching to the guest?
> 
> I don't think so:
> https://elixir.bootlin.com/linux/v6.18-rc7/source/arch/arm64/kvm/hyp/nvhe/debug-sr.c#L60
> 
> Cheers,
> /fuad
>> James
>>

Oh yeah I glanced over the TRBLIMITR_EL1_E and thought that was clearing 
it, but it's just checking if it's enabled or not.

We actually disable trace by setting the filters to 0 in 
__trace_do_switch() and leave TRBLIMITR_EL1.E enabled.

