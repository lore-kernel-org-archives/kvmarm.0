Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF85227978C
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 01:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763430464; cv=none; b=HCt7JgioseQWt6OI3ki1c33+PTbjgITLBP4BZrzu2G9SvLcrBP1KJrl6BtEhMwplYMi2BD/7hS+J0Rb4/ge7ew0c0PIdwl9+Xlyeid7C9l2wEz5bd0ayRZYZJeiK7j/yaD8UpXC53U68gV+NgvdkeWSeiR/hBBwP/udq91ftqtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763430464; c=relaxed/simple;
	bh=PcFLraAzaSuScHsWdw52NGGkd4NF4SIlfh6tbOQN74g=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Q/7d9y/tEQ1GsyNkxls0MIVATjury2n6XJdC5nATpoQtUOGR80T7jp0VAFtPq7mA8HFqFSO8KjokKuDQhDWUQHHLehFYBTQiXfcfjedc6AFP4qQ20cIbu8R+/fjlRHPIGhTRibRTfBtKuD265GhnSUdgPaT45quKuv52zBLVAaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=sKklkkff; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="sKklkkff"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8b144ec3aa8so502482985a.2
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 17:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763430462; x=1764035262; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ANmR5R95YIg3oicNxWokN5OI3LFn4zAy1RzaFgznCXk=;
        b=sKklkkffvApa9GkxEkHby2OGzEolat8RFB0ZYJ++hyZjbqyOiw1n4JSi7thb21Xod9
         +D3nuDoN1pFZWOY5KfNnioG/qzXlZAvQRmq0avPSLwltoLY0tPXngQUE25njSNnRYnlR
         d5kv9hBn5ogby3N2UJjiieB08W+ODbEZ69i0PAYiXWqlHAoBLd/vNv88GfCot3p33zCs
         SqbqfgeE6arbELSgKa/I7M1CLEq86YCAKFurfX9DtUD8nztlm/B0Ywd1nky8qV2X+AgA
         rdYoD+xhjUwQ4lARrTZFdS7ls6DnapsusVuwYaC8PXSvoSXJxgXl7EBfTv6jUJNFf8Mz
         2Mgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763430462; x=1764035262;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ANmR5R95YIg3oicNxWokN5OI3LFn4zAy1RzaFgznCXk=;
        b=YwugQlaiglykTb/MXHqUq0JLAyVyqm7t4vLqh08g7OJVunxgf+uMicob3subbcIMFV
         q7lq7akIaUH9x8JkteySREEQ94R75JvN1n2oa33UWnhqZhSmort0R4sJE+Qc6J+tGpFD
         SFP5vvqP9Fss5ekqX16F2O0u6h4SgpJPkIsB39inWwfDhfOJHH+8uCJrgVFfxmoSEjzp
         PHvlI/CMtGTnu7L3vUA2t+VZ9CDlyzmVD8BcGqfPQuZvfwN1C795Rhlq7etphzN2/n7N
         cF2jtPcw6KV/MQwk0IFDbXL2120O+ywmVmuB4KfOJQPpSZlEQXrtpLvDoOF2qAzlgHtj
         sP6g==
X-Forwarded-Encrypted: i=1; AJvYcCUkjMBfzFbZD8Au28TV6DTDBvh11vDglRgUEwUkk1PP21s+eWG6lpm+yfy+y9Iqdim5NRqkJQY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzwcq+SwWj6A+8RhUPwf0+tEazxmvIqlTx+xIu9i3ngW1qnr75+
	Gtkvd6VZ5dgs8MqQ9eKJFCQchaPJibgBVthWvY0ssEgWNzb08HPPCDuL8spPV9YyNmA=
X-Gm-Gg: ASbGncsDyFNoc1afCVF7SFEOb6Eci9Dz6vh0PRHyaVkQgmrcv69YKAqWfLjNorWELFd
	+e1jKDUEaoEK6XBM6WentNok99gSWQzXnoJ9vhDw9aV3D5UGrw0yI4XRuygzbkc+5B/33pT41xT
	w7skjWdIE2uUMOCM7ACPCm87qLpE2setmPVIQMlSJxARuCURLZ+v+MBZI4p/I/U2t+g40Ntr0//
	gGNHXn/6o5kMxxAyzLUwvznJbkzkFrox/Ugz8uY3dEZY99XIdyLjp6lUgJ0AwK1oQtlkeseET3C
	8uivR8yVUnAsjpip4jWmtx4xFXTscZkbkuToACSo3QaRXB5r4+2VsLa2+kOgYDvAiDIz6Gaul6c
	o8Mo1pwYYi4OgxRyKKWVCG9MbQ2Fek1sxy/KrlvISnYBrH69f+LEzhbiZS8Uyre3xxJv0m1gb2k
	lwMWtlOIaBzBXdUPlKuSMGeIAXtz6Nk7M82IX4zQ8ECufQUe5X2tA9IoaLn8Joy3v3JGGSD3ywC
	o8snFEYTV8mi/dzq5lStEP8nfuc/aN3P6LUU0t+ouRdePlkE1eM6yIJ
X-Google-Smtp-Source: AGHT+IF1rrSKti2yalLsD2GeMGxfpK466BKmI1nDbWTxmkWAWUCzyX85ZbouAm2vMzc+ZtrwHT3LSg==
X-Received: by 2002:a05:620a:700c:b0:8b2:e4f0:74d0 with SMTP id af79cd13be357-8b2e4f0797bmr1161133085a.63.1763430461779;
        Mon, 17 Nov 2025 17:47:41 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2fbc6f264sm192017985a.36.2025.11.17.17.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Nov 2025 17:47:41 -0800 (PST)
Message-ID: <0274322e-e28c-4511-a565-6bb85bfade8b@grsecurity.net>
Date: Tue, 18 Nov 2025 02:47:38 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
From: Mathias Krause <minipli@grsecurity.net>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Eric Auger <eric.auger@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com>
 <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
 <aRufV8mPlW3uKMo4@google.com>
 <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net>
Content-Language: en-US, de-DE
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18.11.25 02:33, Mathias Krause wrote:
> On 17.11.25 23:19, Sean Christopherson wrote:
>> On Sat, Nov 15, 2025, Mathias Krause wrote:
>>> On 14.11.25 19:25, Sean Christopherson wrote:
>>>> On Mon, 15 Sep 2025 23:54:28 +0200, Mathias Krause wrote:
>>>>> This is v2 of [1], trying to enhance backtraces involving leaf
>>>>> functions.
>>>>>
>>>>> This version fixes backtraces on ARM and ARM64 as well, as ARM currently
>>>>> fails hard for leaf functions lacking a proper stack frame setup, making
>>>>> it dereference invalid pointers. ARM64 just skips frames, much like x86
>>>>> does.
>>>>>
>>>>> [...]
>>>>
>>>> Applied to kvm-x86 next, thanks!
>>>
>>> Thanks a lot, Sean!
>>>
>>>> P.S. This also prompted me to get pretty_print_stacks.py working in my
>>>>      environment, so double thanks!
>>>
>>> Haha, you're welcome! :D
>>>
>>>>
>>>> [1/4] Makefile: Provide a concept of late CFLAGS
>>>>       https://github.com/kvm-x86/kvm-unit-tests/commit/816fe2d45aed
>>>> [2/4] x86: Better backtraces for leaf functions
>>>>       https://github.com/kvm-x86/kvm-unit-tests/commit/f01ea38a385a
>>
>> Spoke too soon :-(
>>
>> The x86 change breaks the realmode test.  I didn't try hard to debug, as that
>> test is brittle, e.g. see https://lore.kernel.org/all/20240604143507.1041901-1-pbonzini@redhat.com.

Bleh, I just noticed, f01ea38a385a ("x86: Better backtraces for leaf
functions") broke vmx_sipi_signal_test too :(

Looking into it!

Mathias
