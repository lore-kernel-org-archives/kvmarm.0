Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135EA253346
	for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 11:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742385088; cv=none; b=f9fjCXJF7pKNZ39mNQtyohQ3jVYHyeHcmkydsjQfV+KATM+KF60qeg27fZ2u0RRQbF3v5oaEQHzDGQ6UQ/H7Q861tml2Xwa23KCorFk57WbWrLWTTyf/V1PgTjSEJ5mTlCqoBH7PupoORTUu9On4btWuySZ0iPx130OQrtMzZhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742385088; c=relaxed/simple;
	bh=/l612sg75Uja1o1NjiZ0/+cOeL1Yx5rIICdOKYCvLtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S9vEzQ+tdoUS6WK5G+U3Y8rKpLpcBD8sC7mDHG0lZ/n3AWcFqkGSjZRp98GQtpLQKh+5aVme0BaG1Qnl/o4LIFd4o7fV5RcoolAkcAPCL3BgsVUSJZJRQex4QOJASDNiv1wvbAWafKoZIYvc1GPDACfazTqRSJ0z5o1WRX5U3H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=WAzub/zQ; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="WAzub/zQ"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2ff4a4f901fso7417393a91.2
        for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 04:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742385086; x=1742989886; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2XjuEqbxb70zWO25+d3tN3N8uLlo3z0B0itj0TevOYE=;
        b=WAzub/zQK9r3DFttFSJpXGfR/llsKG0shi090kQvdjuHG6SecTDitPBhNOv4na8Evo
         5dayIO6FMQEgUuD+Zhuvg94nJig9/VD+0zgisiI4K3fT2pNIcKNk9udjBWwXNkhwCfUd
         YiadA/r/s1XuACBfSIV38Dsp0G4MG7mh6Is3ziZII2Jitz9YdzA6xh1kwLKzTRh32aX6
         1a8fcwcbc5E8jfbQn+8hpE/sBK8tuKXikou1WjxuhMZ4KBj2Y7FU+qiPQ6vJGURzpjhZ
         yfCRbiR7K+DEz6Y2Jjsjune+VEagabD/WC4Cy8EPj4OfxHpQ/+QQkN6lSMYN70fhS/Sl
         2Lrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742385086; x=1742989886;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2XjuEqbxb70zWO25+d3tN3N8uLlo3z0B0itj0TevOYE=;
        b=q5xBg8FTEUBqcCDBxyGzkBi9j5gq1ntZ/eBQVis1IqFKCWTByW4Jwr+4BhA9G4pi3C
         TQ//Fm6Fw9I13wCVpH/1a8jjKEcUn10jZEyHXEfGW9V4+kphx4LGEbqTWK80N/GCWbFo
         w6qpSK0sWVD2PW/XJiAgl+VbBNJsnzKjBCPQ0JE/ZvrkvxiT6DN58w1kIK2OTFJ6pZNi
         +kcSAXpCYF534Rw8t8vFzsIhQ2hIf59xxrArcGW0e8SDiqdIOQ6SrZ0k6CyhYxY3Y+mB
         Y843cd4pKbGDy5iCMVfAYWxhi2xDm6sVCi4dbPuSKyym9CHqESSJfyxDLidRmFVKHAXR
         5BuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAnD80h/CRp2b3ZKqo0MMav2y/CfTA7d/2jk0/W6fzjQVivrkvmhVm/7Ud49hLH1SEqWxwT+g=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+g2Dzb14BCZSkAzzZCXmFAfttodcY+evYhnSWWMrOYWEciKcG
	YRMBuNomRv4YmOx2te/sndAYx1B4ozlxCRoPqpJrqvvyjTlt08DKHAmywyyAxZYKpoWkFzV/Ea6
	3cv8=
X-Gm-Gg: ASbGncvdSnL/iUqCM/5vkDa8ZEaY6KX2woGb3xa2OOYUokuQiPYEy+BBrY72iQpJGyd
	qlXiHlaXsLfV5HjKJrfSLTg12sfFyfL0fzM25ZC0J41E3K19TpMYMyoHD9zEYJp+pSbCcbHO5zF
	LxnApcdL0IFcXq8q4SxEpytN3ezm3Q7GDS7qD9GN5HEwdooD1joXMjI87j7c+p2GUjl6RnxrVDw
	vdWEv7211c4tVvMtesAi35J9drONTRKacjO9ALQSvp2uVutIRpVnWG3KE1ehaIHcb6mZoFzsS4+
	I4c8zxSzzhOMnhgIL83nBQV8jrZ4JQrf7SURHxfZJn2Et2kMzvMG9YVIq9fp/1kawedo
X-Google-Smtp-Source: AGHT+IGhjZrvNsCHZE3eGjx1ElWi189KImICdnFKn/7uc1+V/eDwoskYfYeRmlItwFCzuuJKYXSmdQ==
X-Received: by 2002:a17:90b:4a47:b0:2fe:84d6:cdf9 with SMTP id 98e67ed59e1d1-301be200c7bmr3227168a91.26.1742385086353;
        Wed, 19 Mar 2025 04:51:26 -0700 (PDT)
Received: from [157.82.207.107] ([157.82.207.107])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf5b799dsm1336508a91.31.2025.03.19.04.51.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 04:51:25 -0700 (PDT)
Message-ID: <cd7b4528-34a3-4d87-9711-acc2c2e6f6e1@daynix.com>
Date: Wed, 19 Mar 2025 20:51:21 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] KVM: arm64: PMU: Use multiple host PMUs
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 devel@daynix.com
References: <20250319-hybrid-v1-1-4d1ada10e705@daynix.com>
 <Z9pze3J2_zrTk_yC@linux.dev>
 <e8324d9d-3756-41cf-a102-28572e302368@daynix.com>
 <86plidmjwh.wl-maz@kernel.org>
 <bd681ec6-0b4c-47d9-8a4a-b7324c0883a6@daynix.com>
 <86o6xxmg87.wl-maz@kernel.org>
 <aabd71eb-286b-475c-a30e-d5cf5c4f2769@daynix.com>
 <86msdhmemw.wl-maz@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <86msdhmemw.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/03/19 20:41, Marc Zyngier wrote:
> On Wed, 19 Mar 2025 11:26:18 +0000,
> Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> On 2025/03/19 20:07, Marc Zyngier wrote:
>>> On Wed, 19 Mar 2025 10:26:57 +0000,
>>>>
>>> But that'd be a new ABI, which again would require buy-in from
>>> userspace.  Maybe there is scope for an all CPUs, cycle-counter only
>>> PMUv3 exposed to the guest, but that cannot be set automatically, as
>>> we would otherwise regress existing setups.
>>>
>>> At this stage, and given that you need to change userspace, I'm not
>>> sure what the best course of action is.
>>
>> Having an explicit flag for the userspace is fine for QEMU, which I
>> care. It can flip the flag if and only if threads are not pinned to
>> one PMU and the machine is a new setup.
>>
>> I also wonder what regression you think setting it automatically causes.
> 
> The current behaviour is that if you don't specify anything other than
> creating a PMUv3 (without KVM_ARM_VCPU_PMU_V3_SET_PMU), you get *some*
> PMU, and userspace is responsible for running the vcpu on CPUs that
> will implement that PMU. When if does, all the counters, all the
> events are valid. If it doesn't, nothing counts, but the
> counters/events are still valid.
> 
> If you now add this flag automatically, the guest doesn't see the full
> PMU anymore. Only the cycle counter. That's the regression.

What about setting the flag automatically when a user fails to pin vCPUs 
to CPUs that are covered by one PMU? There would be no change if a user 
correctly pins vCPUs as it is. Otherwise, they will see a correct 
feature set advertised to the guest and the cycle counter working.

Regards,
Akihiko Odaki

> 
> Thanks,
> 
> 	M.
> 

