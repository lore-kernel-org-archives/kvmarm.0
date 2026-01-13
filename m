Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABE1288522
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 14:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768314148; cv=none; b=rx/AXhp2WSlY7PKLQVGmU2YeY0BU4nAAA+u8nAhFe0VyFKlQ96n0mP4Tjumdced3s5gCi5MHp4SBM4GKC2skc94YBW761niYlK5D6hegWlxxmiJVONuBZzEinNW6VuWJEhwPouyL5JENk4e0/+T7N/yf8vQVx6+sI3Y7nZJh/Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768314148; c=relaxed/simple;
	bh=7tX/vbACPJ7pzorsq2MdDG57vTVs4hU8qAqqUqvVUNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VkcDmhPd5tf8r3ESCkoVptRDUa1dc3pCFC9nbFc5NTomoOYQvf7m6e1wJGv/EmSJz7YXq6Ddn3TFWtKkGT9j/oJMboopq0VHOkqt3cLlEPWvykXeDOt4fIfdSle6tH6rMD9Az5UME20frNYZdBUsd470mvceZQ71edptYRo2eS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ucoII76b; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ucoII76b"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47edd6111b4so4865835e9.1
        for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 06:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768314145; x=1768918945; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kOcc0KRBXay6wWD+u9p0xoC86rnX88DOcRXGUN9LsyM=;
        b=ucoII76bXFrA5DQoewmGHr3EHAy6VXHj3RxG0wVzwQ9+CJ2wl4velgrHHC2j+xCy5S
         Q9s9o02yB4wyU+76cLC4LFziDQJLQJTw7KzHt6st2fAGwiqxEz4KtFXRA9XKiwJtFZJs
         2WqOBGgmB2zMMk8Vz7ucsKWIuFVY+vaRRLS58ybgG4hSe3xeIAiQ1NGxWMbPeOSidq4Q
         7cx3pJkTpl/fAzdcG2yG+SQPiYv05lbTWLeHeHSbmhPj3lIcPLC+q32NJZa6abuVwGdA
         st4Jv706RC+SPEDsPqCNNYiMF5v6cBr9CsG5XxFV1skodwsyV7J426RfDyAruy4JyRWr
         Va0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768314145; x=1768918945;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kOcc0KRBXay6wWD+u9p0xoC86rnX88DOcRXGUN9LsyM=;
        b=YmFwhdZPDXIngGOD6WVywYtRxWpUAevI9ekK5xzxcA8W6xsCo/yKeFWXQn2CuSiGPs
         s9ssOsgPAio5EUA9DH5t7dfAknpRR60OfMpFFbc/3ZNRTWGpcp+sLyzo7vnqXxopvKZg
         TlPBRwn6ck2NUtaLYw0SHstBPLX9Gou9zmAHpDBeQhQ2OindVVbQUT/SsTvwrzy3wpkY
         KfX+WpXIj4NtQn24kQW7GTsiR4cjERb+0WiHaEibWELPC0ebNHm5xumbJvI2QNIBYbRW
         G4ArIFVWjLw876FsgbS8CwLOkCo9uBtm5CNzomSKZPG5KbOUnwgRG3jUi7tyAhomBdUS
         TgoA==
X-Forwarded-Encrypted: i=1; AJvYcCWANB4VQ6zrc1CmOMAuaVj4AJ8NqWuLf463d03aZpFilvbwcm20aP02EbW5wl5s4V77eRBUCSg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6TXMnWGHyQA+VOwedvROk4RrHe1j0xt4wqvQ83d142FKhaglD
	W5CmMFMGwo74Qg7WiUV42WsWOwPa6Lh5IkMqbQrSnun282RT78edZXI9MtMpBsRiEg4=
X-Gm-Gg: AY/fxX7a5s9RvzlZeT3RmQ149xvN2vjC8Pjwkdze7RGB2UKgwEeXjzsl+wAFj1nmej8
	MExNz9N9t41bYwzZ/UsXdeZhIBX1eFXpOnf4zFgJSqebszh3MQ3R13hEEmACzujtXO2I1iy+MG0
	SWCC5W7j9leosfCm25BEwKn37Kriy6fHBBoZ5PLHlpWdt/hRlfjfw/NJfqKPvSJkWIQYLvZMupf
	t+78xrwFsee6lzKfQ8yOG3djtuO5zvYkqBXuEjsnMlAohP+4T1hs8vT1tu38+FOkG3D3AWEZKpT
	UhluEy/KJpI63fNDyoOl9IjPs7JVE7Ml4iwpft3geri6eYQOEEkc4FhK+f2VYXUTRmUXqt0xrsD
	l/5gYRg4T82WE+CUpW/iXnx+IeohYXobx73kCC4CZ0fbA+7EtJiFn0OeVGlfiQg7BwcdQchkoDg
	2X98AqNyN2pJRTJ8hu
X-Google-Smtp-Source: AGHT+IEhLNzlzezmO94C9Di983Zw5BpIJOch/75pRQUe03HO2q7PgBEqy8xZhLdl4DPED2OEci+CzQ==
X-Received: by 2002:a05:600c:1e1c:b0:47d:5e02:14e5 with SMTP id 5b1f17b1804b1-47d84b0a8d1mr222924975e9.5.1768314144942;
        Tue, 13 Jan 2026 06:22:24 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47edfd5cfd5sm15667235e9.8.2026.01.13.06.22.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 06:22:24 -0800 (PST)
Message-ID: <a3c54401-707a-472f-a3e2-62cb9b70020f@linaro.org>
Date: Tue, 13 Jan 2026 14:22:23 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 19/35] KVM: arm64: Trap PMBIDR_EL1 and PMSIDR_EL1
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: mark.rutland@arm.com, james.morse@arm.com, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-20-alexandru.elisei@arm.com>
 <f7d73dc3-aa4a-4c32-aabb-21a61a2f773f@linaro.org> <aWTa76KXpIwzPh4k@raptor>
 <adacaff6-c6c7-47a5-993a-29f006fe1b86@linaro.org> <aWY_GGzNW85ZR7dP@raptor>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <aWY_GGzNW85ZR7dP@raptor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 13/01/2026 12:48 pm, Alexandru Elisei wrote:
> Hi James,
> 
> On Mon, Jan 12, 2026 at 11:54:05AM +0000, James Clark wrote:
>>
>>
>> On 12/01/2026 11:28 am, Alexandru Elisei wrote:
>>> Hi James,
>>>
>>> On Fri, Jan 09, 2026 at 04:29:37PM +0000, James Clark wrote:
>>>>
>>>>
>>>> On 14/11/2025 4:07 pm, Alexandru Elisei wrote:
>>>>> PMBIDR_EL1 and PMSIDR_EL1 are read-only registers that describe the SPE
>>>>> implementation. Trap reads to allow KVM to control how SPE is described to
>>>>> a virtual machine. In particular, this is needed to:
>>>>>
>>>>> - Advertise the maximum buffer size set by userspace in
>>>>>      PMBIDR_EL1.MaxBuffSize.
>>>>> - Hide in PMSIDR_EL1, if necessary, the presence of FEAT_SPE_FDS and
>>>>>      FEAT_SPE_FnE, both of which add new registers which are already
>>>>>      trapped via the FGU mechanism.
>>>>>
>>>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>>>> ---
>>>>>     arch/arm64/include/asm/kvm_spe.h |  4 +-
>>>>>     arch/arm64/kvm/config.c          | 13 ++++-
>>>>>     arch/arm64/kvm/spe.c             | 82 +++++++++++++++++++++++++++++++-
>>>>>     arch/arm64/kvm/sys_regs.c        | 13 +++--
>>>>>     4 files changed, 103 insertions(+), 9 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
>>>>> index 3506d8c4c661..47b94794cc5f 100644
>>>>> --- a/arch/arm64/include/asm/kvm_spe.h
>>>>> +++ b/arch/arm64/include/asm/kvm_spe.h
>>>>> @@ -40,7 +40,7 @@ int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>>>>>     int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>>>>>     bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val);
>>>>> -u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg);
>>>>> +u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg, u32 encoding);
>>>>>     #else
>>>>>     struct kvm_spe {
>>>>>     };
>>>>> @@ -78,7 +78,7 @@ static inline bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
>>>>>     {
>>>>>     	return true;
>>>>>     }
>>>>> -static inline u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
>>>>> +static inline u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg, u32 encoding)
>>>>>     {
>>>>>     	return 0;
>>>>>     }
>>>>> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
>>>>> index 24bb3f36e9d5..ed6b167b7aa8 100644
>>>>> --- a/arch/arm64/kvm/config.c
>>>>> +++ b/arch/arm64/kvm/config.c
>>>>> @@ -6,6 +6,7 @@
>>>>>     #include <linux/kvm_host.h>
>>>>>     #include <asm/kvm_emulate.h>
>>>>> +#include <asm/kvm_spe.h>
>>>>>     #include <asm/kvm_nested.h>
>>>>>     #include <asm/sysreg.h>
>>>>> @@ -1489,6 +1490,16 @@ static void __compute_hfgwtr(struct kvm_vcpu *vcpu)
>>>>>     		*vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
>>>>>     }
>>>>> +static void __compute_hdfgrtr(struct kvm_vcpu *vcpu)
>>>>> +{
>>>>> +	__compute_fgt(vcpu, HDFGRTR_EL2);
>>>>> +
>>>>> +	if (vcpu_has_spe(vcpu)) {
>>>>> +		*vcpu_fgt(vcpu, HDFGRTR_EL2) |= HDFGRTR_EL2_PMBIDR_EL1;
>>>>> +		*vcpu_fgt(vcpu, HDFGRTR_EL2) |= HDFGRTR_EL2_PMSIDR_EL1;
>>>>> +	}
>>>>> +}
>>>>> +
>>>>>     static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
>>>>>     {
>>>>>     	__compute_fgt(vcpu, HDFGWTR_EL2);
>>>>> @@ -1505,7 +1516,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
>>>>>     	__compute_fgt(vcpu, HFGRTR_EL2);
>>>>>     	__compute_hfgwtr(vcpu);
>>>>>     	__compute_fgt(vcpu, HFGITR_EL2);
>>>>> -	__compute_fgt(vcpu, HDFGRTR_EL2);
>>>>> +	__compute_hdfgrtr(vcpu);
>>>>>     	__compute_hdfgwtr(vcpu);
>>>>>     	__compute_fgt(vcpu, HAFGRTR_EL2);
>>>>> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
>>>>> index 5b3dc622cf82..92eb46276c71 100644
>>>>> --- a/arch/arm64/kvm/spe.c
>>>>> +++ b/arch/arm64/kvm/spe.c
>>>>> @@ -22,10 +22,16 @@ struct arm_spu_entry {
>>>>>     	struct arm_spe_pmu *arm_spu;
>>>>>     };
>>>>> +static u64 max_buffer_size_to_pmbidr_el1(u64 size);
>>>>> +
>>>>>     void kvm_host_spe_init(struct arm_spe_pmu *arm_spu)
>>>>>     {
>>>>>     	struct arm_spu_entry *entry;
>>>>> +	/* PMBIDR_EL1 cannot be trapped without FEAT_FGT. */
>>>>> +	if (!cpus_have_final_cap(ARM64_HAS_FGT))
>>>>> +		return;
>>>>> +
>>>>
>>>> Isn't this only required if you want to report a different PMBIDR value? If
>>>> the value in hardware is already what you want to give to guests then it's
>>>> not strictly required. Maybe it's something we can do as an addition later
>>>> to make it usable in more places.
>>>
>>> The maximum buffer size is advertised in PMBIDR_EL1.
>>>
>>> Thanks,
>>> Alex
>>>
>>
>> I know, but 0 "unlimited" is a valid value, and that's what's already in
>> PMBIDR. You only need to trap if the value doesn't match what's already
>> there.
>>
>> You can also "probe" the maximum buffer size without this by attempting to
>> set the limit pointer and looking at the buffer management error code.
>>
>> The first thing I did when I went to use this was comment this out because
>> my hardware doesn't support FGT. But the rest of it works fine without,
>> maybe other people could benefit in the future too.
> 
> I could add a new capability for setting the maximum buffer size (or to set a
> buffer size different than what the hardware advertises), enabled when FEAT_FGT
> is implement by the hardware. But that means not allowing KVM SPE on Neoverse
> because of erratum 3023823 [1]. So I don't think you would be able to use KVM
> SPE out of the box on your hardware anyway (if I understood correctly that
> you've been using a Neoverse CPU to test the series).
> 
> [1] https://developer.arm.com/documentation/SDEN-885747/34-0
> 
> Thanks,
> Alex

Hmm ok, not sure if there are any other systems with working SPE but no 
FGT? Maybe we can wait to see if anyone asks and think about it more at 
that time. I was just thinking out loud anyway.


