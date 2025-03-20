Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CA11A072A
	for <kvmarm@lists.linux.dev>; Thu, 20 Mar 2025 09:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742464385; cv=none; b=c7Vu7yusMKy+nZNGWBsO/QJvzHqkOCzKjqnRl5P6S9vNl9DJ3jIo/j3zItU3OuDy1NlPqK7293YzkyBapttK1c960oQJf/giryJNbS72CW+PjIiQZKQGaB9m8ET14vq4vWyi2bkN6TMIY5wuJcwDMpDI4N7UGPqNDD7jeBo2vFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742464385; c=relaxed/simple;
	bh=eCS46a9D6IsT0VB7R2DUK7ltce4HrARlbC83vt2uUpI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bGhnCqwQlPiM4b3rv4j8w1/PA+Bn/pL/Aq39Ffn6pLSMMzz8TXorTEVNFhwMbmKvbaZAIa1VAC9IBWGhR64oMFkN69HQjqXVX66x9bf9hjU6YoQiUQPohA5A/2ZDWbT1Tv6qsPB2IT+KrCBIubJJE31DBhFlPoQQQd7uFpthqUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=1jJxMfQS; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="1jJxMfQS"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2239c066347so9908945ad.2
        for <kvmarm@lists.linux.dev>; Thu, 20 Mar 2025 02:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742464383; x=1743069183; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m7D4rqlmtfwr1EgAb/lUYH/aHJeqF4FrFxKoiXcpfuI=;
        b=1jJxMfQSs8iHnjQE1j1xgtFxOlmWMOGNoeMW242hCiQjCFreU9bFzgJJQ2DLRsZLsx
         OEElrl6ZYKK+Odwo84h8ee+a+e+gf1vC4EjUVw31vpcwMbFZobVjC7gXLfkYikgZDt3i
         /N0HOhRegch+noZ0tBZA1wBEyqDbauYiNkdKUVD905EtOUfm59e4OIf3F3F1Nxa9Mo73
         1anpRtPabxOtD5ndja0lUFczqb+yLG+glBCu7IqUldnOWPTbGSPnM+Kpl+q5RbclJ5tk
         OgqKtGHpGFaXdCcXS+p34K0e1lzq8Tc2Iyt7rQvTfKfYBhKiKsiu3AaNVcbAi9LhPo0V
         lzsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742464383; x=1743069183;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m7D4rqlmtfwr1EgAb/lUYH/aHJeqF4FrFxKoiXcpfuI=;
        b=Qytq0jRcCkJsQ+4EWTMa6eIcVgUcywAXueM+fn7h0QOSUxsYLQytvL8ggo2DLfPsaA
         gu6vvIudCGQpsUTww3rBX84ptf8XTP0EjHla77u298fD4tTODRBnC8Qdqgo+7f0ixCyS
         z+eco9yEPByAo60PqajN9kUBU47wK7N/qtAIimwD1+UoXW+dsOQ9vfprpFOE9fC9+E9/
         22fDtTuKOMQhdClNAj+1nKFA5rlTzbWbs30egIIngAfxm2nIi5LYCl2YDKjYmoUbtizL
         UqksU4j2UzIGDeFgOzb1/bkEzuCS1UlTCb6fYQHuSr5x0jFRfeY6T53oS7fsA0uSOIqn
         zMKg==
X-Forwarded-Encrypted: i=1; AJvYcCXf8yR9xghGzbRu4pR+i21QSHrmhRHA1miyp6uJQZUKh4/Pbfhs2yNvRnMA9DlqLg6bUhpnp1Y=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8casGICuFAIiN3Tb44d5TOdGn1a+UZtA3NoEx1e8U+yAxDgZ6
	ZF8gomnQ+0uPk/5DAHbcmfwMSzpsfxvDlwXA19YBiwnopW2385Sn7erW9oHM1LI=
X-Gm-Gg: ASbGncsu/5H3vp+hKSBlxRm2o0BbNzefTjWHuRg87EguUF0CWnc2XhpEJr+4RpqiY2U
	EBUZtKn3ucUC2rhEO6wC82BsjCsqBa8KXwjp8JIOlYM6lLMCBcvjtpnpml2ITkZD2aJhKYML4a6
	mCE6v9vrx17VXefuW5/RaNMHmTxXRcHgxUJ3I90MzazIKuoRqsZIflgXXtFP/tAg+jv63CkBbWh
	aQtHbsPCsXxNG4iRJd6s8ush5fuO+9rSrCntQT63vQo+fEoBUtJoD8sxDOd/SKpkqi2eWI7Nrk6
	DRdAtFZPoHNq3vpsbtpzpKgmW+SjLITi3DQzOxGnHQpEYhdSXSqv0m8V9g==
X-Google-Smtp-Source: AGHT+IE3mIGDRFikUIqZ1qqXpt2WAHzRmavgaURSEY1rWIOdBI4jZWh2D1HIB2Ty4Cr8ew7b4T+ofQ==
X-Received: by 2002:a17:902:e810:b0:223:88af:2c30 with SMTP id d9443c01a7336-22649a30485mr90872845ad.16.1742464383534;
        Thu, 20 Mar 2025 02:53:03 -0700 (PDT)
Received: from [157.82.207.107] ([157.82.207.107])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6ba6d52sm130630135ad.116.2025.03.20.02.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 02:53:03 -0700 (PDT)
Message-ID: <ba9cd6d2-1ee5-478a-8102-42b4dac411ce@daynix.com>
Date: Thu, 20 Mar 2025 18:52:59 +0900
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
 <cd7b4528-34a3-4d87-9711-acc2c2e6f6e1@daynix.com>
 <86ldt0n9w1.wl-maz@kernel.org> <Z9sSMJAlf7cQ5viu@linux.dev>
 <0d84bc94-1c65-4737-a2eb-aa7f96a7d1e0@daynix.com>
 <86iko4m5i4.wl-maz@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <86iko4m5i4.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/03/20 18:10, Marc Zyngier wrote:
> On Thu, 20 Mar 2025 06:03:35 +0000,
> Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> On 2025/03/20 3:51, Oliver Upton wrote:
>>> On Wed, Mar 19, 2025 at 06:38:38PM +0000, Marc Zyngier wrote:
>>>> On Wed, 19 Mar 2025 11:51:21 +0000, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>>>> What about setting the flag automatically when a user fails to pin
>>>>> vCPUs to CPUs that are covered by one PMU? There would be no change if
>>>>> a user correctly pins vCPUs as it is. Otherwise, they will see a
>>>>> correct feature set advertised to the guest and the cycle counter
>>>>> working.
>>>>
>>>> How do you know that the affinity is "correct"? VCPU affinity can be
>>>> changed at any time. I, for one, do not want my VMs to change
>>>> behaviour because I let the vcpus bounce around as the scheduler sees
>>>> fit.
>>
>> Checking the affinity when picking the default PMU; the vCPU affinity
>> is the only thing that rules the choice of the default PMU even now.
>>
>> Perhaps we may model the API as follows: introduce another "composite"
>> PMU that works on any core but only exposes the cycle counter. Robust
>> VMMs will choose it or one of hardware PMUs with
>> KVM_ARM_VCPU_PMU_V3_SET_PMU. KVM will choose the default PMU according
>> to the vCPU affinity at the point of KVM_ARM_VCPU_INIT otherwise. If
>> the affinity is covered by one hardware PMU, that PMU will be chosen
>> as the default. The "composite" PMU will be the default otherwise.
> 
> This makes no sense to me. A VCPU is always affine to a PMU, because
> we do not support configurations where only some CPUs have a PMU. This
> is an all-or-nothing situation.

At least isn't it fine to have the composite PMU with a new value for 
KVM_ARM_VCPU_PMU_V3_SET_PMU?

> 
> More importantly, you keep suggesting the same "new default", and I
> keep saying NO.
> 
> My position is clear: if you want a *new* behaviour, you *must* add a
> new flag that the VMM explicitly provides to enable this CC-only PMU.
> No change in default behaviour at all.
> 
> I'm not going to move from that.

Why not? It will not break anything guaranteed to work in the past.

Currently KVM only guarantees that the emulated PMU correctly counts 
only when
1) the vCPU affinity is contained by one PMU and
2) it will not expand

Breaking these conditions will make the behavior of the emulated PMU 
undefined. Now I'm proposing to remove 1).

Regards,
Akihiko Odaki

> 
> 	M.
> 

