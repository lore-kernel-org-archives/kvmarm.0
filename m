Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1782FD1C2
	for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764152995; cv=none; b=Vh7dL0bixTwair7p3zFi7QQr6kTqleP7AmD6FG4dejy3I0UR+ly3cTlz/ZC5Qcb7/Zhdeyg5LjYD3qz5ZLXV/T8NEYQmEFvIeHpf6OerAp5EDqG7DGuxc9nXCuhLh9bPAcVu48f+c4E/49BFBofvcdHJLXIKYDw3QKVYZYh1bpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764152995; c=relaxed/simple;
	bh=u5ssJtANHxM/PAZHMdsD3toUNDDIgQ6L7HNKSHn63kY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=omdoMXXE6ROmRDkRUBVximQHXhYoAnUcT5aBxs6pXkErDh1C/Usc2lJ2WlsWB/R+TKI0oWCfDWklo0LckFMyNcrP794faaGtBR8DmyXx9dZ7DUA4BR+oUoqKsddTQ7bzLRMv08J36QYoSG48crIBNGvBn4QlTcd2VyUl+7BjqN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sELks6mm; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sELks6mm"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477563e28a3so4956805e9.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 02:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764152992; x=1764757792; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nqXXBAAUKdwSAUjfq+x6n5cNsQrS4X3kIhKEGzMVOJw=;
        b=sELks6mmC49Ze+8xfu2TCyd94mBwS2d/+fKsbJ9Nxzv7KVlokALDJPq3ro/aMkB93s
         PX+enyBchOjYG56LAgPpqIL4qpWU1cLU3NQdBu75Sq7GQKwIdbqbNBlY1XuQziL6XCTs
         fz7hp3X2dNqqIQVwBmbnhT9JfAFcu7qkYzljIjpKn6fW37NySwsVzKL7FNIDQrluMW5B
         7e2S+xNz6RjPqACfe9ecMANrNobOlUe+GE8gTnWh55d7+gg7rfdGwHus7XSNbOdScEw9
         in16enK+P/OaBexkzL3gxnjTx0u5V0FMgAxv8F8QVKc6UtU8SuvZs2QtgW6jEnSwcBY/
         icuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764152992; x=1764757792;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nqXXBAAUKdwSAUjfq+x6n5cNsQrS4X3kIhKEGzMVOJw=;
        b=e4nG2jrGrS1X+IOWJP08Jv23NKU+leqjCtlA4xRmJLjWwFz+76+J7VY3w5Cmu6zCHh
         lIEsIceIy6bBXCAHY9MQIKyrRy9gdCqN7Y97oDBKAMt8ocQ7DCaf+zZy+o5f6nYrsk4T
         33aJIGEd8o8S6Eb4ri+6dQxv+YtVVpydRCHyB6iaXUFXU8nPLkIl30asr28D4V5f89Aa
         LMxnHTz2JO2e9D3/Pit9AUWc7CzrFr0hVw7MogPoWcrN8c0DgpY7FrgqTuVncE0b7wIY
         ZNVBT9pdSGHrJbkqtPEHu0nq4HqWkW2afMQXwMa1zd5vnd9IVWcEruh8yQ5HJBjYBj62
         Yivw==
X-Gm-Message-State: AOJu0YytEtzzCNacLVeIaW4GDwEDOxZ2sIkeeaaKN5JZI63m/jNMDK7h
	KRHCW3mLEzmqTkHv626lFL/alBQiacmzG0MYD8QK1FbahnEWZuSP7tgBV11F95DKpSI=
X-Gm-Gg: ASbGncvdmYEW4pEvnbLKHjDzmtX1hnltJYMY3rN2XinWYnGngiA9XcCvJsNzmU7vZPk
	0hwnFMwI/j7/vzbKfiS6weosWyQ2Z/gowdPnKXkzXySgaQ0K5j1LrT8MNMjgaoyUjAtBQ2udsWM
	GQXPhkmLEunX/DILCLG66ho4DcshfiB/oU4cYPY06iJNFGV6pGUO3cmB+VWre4eeYiq0+FFSmZ/
	nmD93cNo9HPlhykgGNAkLEg394ERNWksl6xdaV+oYko9KRy3kShOP/qIRHzY2OE/X6yCyW9pTHq
	w5RQN34LtPLaLNQ+HGPwA2uU8gQl725gSy+9g8qSK5cMwke/7iil1XnztkvloPJhgo3NkK68w2R
	vR26jT2JbJkvQRdlJCY/L1QOZ1mSBV57IZdoJxLIPYQLQ7wlHd+89Xg3dhHIIay+Nx+WIcFeYRs
	Y0/oPBy4etcLHiP2IH6Prs6/KTokE=
X-Google-Smtp-Source: AGHT+IG2IZKv123EVs8kI5aI78wn3FAXbfwHqvjiNrCaHccsQTuoIt0ndnqH5ZptLtGnsp5kH6xE1Q==
X-Received: by 2002:a05:600c:4746:b0:477:a289:d854 with SMTP id 5b1f17b1804b1-477c04cfa31mr194777345e9.5.1764152991840;
        Wed, 26 Nov 2025 02:29:51 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4790add5b80sm37746505e9.6.2025.11.26.02.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 02:29:51 -0800 (PST)
Message-ID: <d94e17d3-41db-42f8-8039-e1d6a694788c@linaro.org>
Date: Wed, 26 Nov 2025 10:29:50 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/9] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
To: Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
 vladimir.murzin@arm.com
References: <20251118103807.707500-1-tabba@google.com>
 <20251118103807.707500-3-tabba@google.com> <868qftqehe.wl-maz@kernel.org>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <868qftqehe.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 26/11/2025 10:23 am, Marc Zyngier wrote:
> On Tue, 18 Nov 2025 10:37:59 +0000,
> Fuad Tabba <tabba@google.com> wrote:
>>
>> The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
>> register accesses. These accesses are trapped to EL2 when the bits are
>> clear.
>>
>> The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
>> had the polarity inverted. When a guest did not support the Trace Buffer
>> feature, the code was setting E2TB. This incorrectly disabled the trap,
>> potentially allowing a protected guest to access registers for a feature
>> it was not given.
>>
>> Fix this by inverting the operation.
>>
>> Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>> ---
>>   arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>> index 8d06a246dfd1..f6f8996c4f97 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>> @@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
>>   		val |= MDCR_EL2_TTRF;
>>   
>>   	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
>> -		val |= MDCR_EL2_E2TB_MASK;
>> +		val &= ~MDCR_EL2_E2TB_MASK;
> 
> This does not only change the trapping logic (bit 24). It also change
> the ownership of the buffer (bit 25). I wonder whether you should do
> something for that, maybe by clearing TRBLIMITR_EL1.E, because
> otherwise, you keep tracing, but using an EL2 VA. What could possibly
> go wrong?
> 
> Overall, I'm very uneasy about TRBE in the context of pKVM.
> 
> Thanks,
> 
> 	M.
> 

Don't we already clear TRBLIMITR_EL1.E in __trace_needs_drain() for pKVM 
when switching to the guest?

James

