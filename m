Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5F717A306
	for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 11:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742383584; cv=none; b=BvhG463wzUTfhmrqSuNDTX9GRdafpV/6ZYG1RPWsDgOPZSHgmGXWL7KpUo/GwQtUiIcbQ5mxsoIDkxID42OpdCAi3dze3XcKPsiDG6TS3/s87F5oGTLTiW6922lDLHHQHfnjHPOQ+GnYn3a+SAJRvGbKLo7Nr10ceUFntqSFoE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742383584; c=relaxed/simple;
	bh=y+dIPWIfwKVAL/oo14ew2WBtJcHAtp0+oSdbLwz1FyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cSH8/Cg2MwvD00l7dxqk6TFvwUMssFZTWBvZcSH5FwQwgyPllS0ubEXrzk88wEipzrpIqSfO6tH0AVVqBOaSzu69m8P9dScIxc8HvEM5I9r9MgO7vtHNtjsQgPftjT/4PF6Gdb7YEqI0i/tRsZrYHvIxUA9honZBa78LkQz/HHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=O2olSIGb; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="O2olSIGb"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22548a28d0cso29542695ad.3
        for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 04:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742383582; x=1742988382; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gvHNVZyKR2DtKBoW11M6k8zN4d/kmrkOW2ikjxRgacU=;
        b=O2olSIGbY1SoxujWQgaBqGTiJwAKdYGHZLNalEXRsREOJFymtfyp1Aur3l9cMPfddk
         Ui16UeGe5MC0cun4J874JUvMi+/stPzstiulR8oc0L8t5Roko6XrZM47DhpYb5VF/OOA
         HVMuqpYfuVJaE6R76jpo51mI/JxQEtsEDTS+ygb9/hUzvk01zPcOJezhZIvirrcQVE9W
         TW3Q3ye8iZKJK5R1zexLXytMxZTi6xVNVJLxUszylTUFjBBQ1qsKbXRNzISazLFOU7DP
         am+8EaZRWgIceQue14bF/tQf4JobuKGGemcZSWaLgLSiCWTGGbYfRRl2mlxHh5yvVqhI
         qXqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742383582; x=1742988382;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gvHNVZyKR2DtKBoW11M6k8zN4d/kmrkOW2ikjxRgacU=;
        b=XnW/cXSr2y8rvFSvWpKjKfpvjeRdeztDfId6sbrIiBRew0Q1fGDjmLbNqK7txvll+i
         KrO/iFRCuEUTv5gYDSNGbnfG7v1ZqbhWwljzEU985tTsGX1VZ78hVxpSwWb7OFX29jAS
         NQRi/2znCh6qrZn70oVA5eRDQL7oURGkCuhE+a17rKigkvJew0BApRX5myPrdDESlkpr
         Gppjdzf2kokQc7QOAG+GKIecIV1lKAdcfuDzEvNfe+HOO4EbQPeCmPZ2qA8tUV4WHqDJ
         O5+kfPT3phLm7XhwThhyJ3ehcVZdRbz2/n8g4aI07sJ3mgo5it0CayeTjV+N/g5RskMu
         EEyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZ27OZctxDkgbN+nGqR8Jc3MfxZTZAXno6vQUmMnCTeuObmvfkAHQW/B4LtPf26nehzz0u//A=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9gXmIpNiIWeFXb5785lOTz/LrgpDBd6NYmZXA+Qq3K9IrhzJT
	Od233fUrYr1lZXv8ed1zfphBe3c0XRyD8uK7Hqg+oytAeZkq4aQIaACW8LVynII=
X-Gm-Gg: ASbGncscO/IRROCl+kmDjzz/wbR2frUeRf0xFPlGSjibtjCfUsAQ2CMzl0+a1TVpUet
	do8Rq2+SwoH3vszvhYsE599j5g0Br7yEpQjG5FIPDoODpynhXQgOwG7l6KeUUNhPX7aSM0O+ckS
	atjuyQwQnqym3RW17/cv4wKmoenB7HeKNRJHc/J005pEE0mB015hHS0oFsrtfc/ClkTaC9Zt5kJ
	fRi7Sp5UPbsIIbCL5bwMe8X/S4UGcPTWUH569+JF66XqxP/0VLFJ9sfSXxqlhP2d7mbn6OAIXca
	cC7EWxHt0nvZZuF15o4U3EFoojJqsydcwvEK/41hy7Jag/popcecaxSOeA==
X-Google-Smtp-Source: AGHT+IHYI4Zbz8LC6Q+OTsZJdgqJkzYI1MdKioTutHwbHR0I7glDazEa7IUKMxIdUxtXsKc3B5OuKg==
X-Received: by 2002:a05:6a21:3a48:b0:1ee:63d7:1d32 with SMTP id adf61e73a8af0-1fbe8334084mr4316868637.0.1742383582502;
        Wed, 19 Mar 2025 04:26:22 -0700 (PDT)
Received: from [157.82.207.107] ([157.82.207.107])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711529526sm11302182b3a.24.2025.03.19.04.26.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 04:26:22 -0700 (PDT)
Message-ID: <aabd71eb-286b-475c-a30e-d5cf5c4f2769@daynix.com>
Date: Wed, 19 Mar 2025 20:26:18 +0900
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
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <86o6xxmg87.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/03/19 20:07, Marc Zyngier wrote:
> On Wed, 19 Mar 2025 10:26:57 +0000,
> Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>>>> It should also be the reason why the perf program creates an event for
>>>> each PMU. tools/perf/Documentation/intel-hybrid.txt has more
>>>> descriptions.
>>>
>>> But perf on non-Intel behaves pretty differently. ARM PMUs behaves
>>> pretty differently, because there is no guarantee of homogeneous
>>> events.
>>
>> It works in the same manner in this particular aspect (i.e., "perf
>> stat -e cycles -a" creates events for all PMUs).
> 
> But it then becomes a system-wide counter, and that's not what KVM
> needs to do.

There is also an example of program profiling:
"perf stat -e cycles \-- taskset -c 16 ./triad_loop"

This also creates events for all PMUs.

> 
>>>> Allowing to enable more than one counter and/or an event type other
>>>> than the cycle counter is not the goal. Enabling another event type
>>>> may result in a garbage value, but I don't think it's worse than the
>>>> current situation where the count stays zero; please tell me if I miss
>>>> something.
>>>>
>>>> There is still room for improvement. Returning a garbage value may not
>>>> be worse than returning zero, but counters and event types not
>>>> supported by some cores shouldn't be advertised as available in the
>>>> first place. More concretely:
>>>>
>>>> - The vCPU should be limited to run only on cores covered by PMUs when
>>>> KVM_ARM_VCPU_PMU_V3 is set.
>>>
>>> That's userspace's job. Bind to the desired PMU, and run. KVM will
>>> actively prevent you from running on the wrong CPU.
>>>
>>>> - PMCR_EL0.N advertised to the guest should be the minimum of ones of
>>>> host PMUs.
>>>
>>> How do you find out? CPUs can be hot-plugged on long after a VM has
>>> started, bringing in a new PMU, with a different number of counters.
>>>
>>>> - PMCEID0_EL0 and PMCEID1_EL0 advertised to the guest should be the
>>>> result of the AND operations of ones of host PMUs.
>>>
>>> Same problem.
>>
>> I guess special-casing the cycle counter is the only option if the
>> kernel is going to deal with this.
> 
> Indeed. I think Oliver's idea is the least bad of them all, but man,
> this is really ugly.
> 
>>>> Special-casing the cycle counter may make sense if we are going to fix
>>>> the advertised values of PMCR_EL0.N, PMCEID0_EL0, and
>>>> PMCEID1_EL0. PMCR_EL0.N as we can simply return zero for these
>>>> registers. We can also prevent enabling a counter that returns zero or
>>>> a garbage value.
>>>>
>>>> Do you think it's worth fixing these registers? If so, I'll do that by
>>>> special-casing the cycle counter.
>>>
>>> I think this is really going in the wrong direction.
>>>
>>> The whole design of the PMU emulation is that we expose a single,
>>> architecturally correct PMU implementation. This is clearly
>>> documented.
>>>
>>> Furthermore, userspace is being given all the relevant information to
>>> place vcpus on the correct physical CPUs. Why should we add this sort
>>> of hack in the kernel, creating a new userspace ABI that we will have
>>> to support forever, when usespace can do the correct thing right now?
>>>
>>> Worse case, this is just a 'taskset' away, and everything will work.
>>
>> It's surprisingly difficult to do that with libvirt; of course it is a
>> userspace problem though.
> 
> Sorry, I must admit I'm completely ignorant of libvirt. I tried it
> years ago, and concluded that 95% of what I needed was adequately done
> with a shell script...
> 
>>> Frankly, I'm not prepared to add more hacks to KVM for the sake of the
>>> combination of broken userspace and broken guest.
>>
>> The only counter argument I have in this regard is that some change is
>> also needed to expose all CPUs to Windows guest even when the
>> userspace does its best. It may result in odd scheduling, but still
>> gives the best throughput.
> 
> But that'd be a new ABI, which again would require buy-in from
> userspace.  Maybe there is scope for an all CPUs, cycle-counter only
> PMUv3 exposed to the guest, but that cannot be set automatically, as
> we would otherwise regress existing setups.
> 
> At this stage, and given that you need to change userspace, I'm not
> sure what the best course of action is.

Having an explicit flag for the userspace is fine for QEMU, which I 
care. It can flip the flag if and only if threads are not pinned to one 
PMU and the machine is a new setup.

I also wonder what regression you think setting it automatically causes.

Regards,
Akihiko Odaki

> 
> Thanks,
> 
> 	M.
> 

