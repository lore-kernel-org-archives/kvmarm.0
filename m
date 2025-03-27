Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAF01BE23F
	for <kvmarm@lists.linux.dev>; Thu, 27 Mar 2025 09:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743067092; cv=none; b=H8WVegyC69y+MGAirQqCGi9K/pKP59HptF7xB4h3xRh3Jlf3KbTN5dNG+fXty85t7AkHQe0ERX/EXCH7han6xjJFIc4U4WX7iRTHR8zgSnJZPOq3REFa4yJupcMgFM2OA4/iWgvNZPtNMyD5j/5SNeQBdj/VYzGCQ/wDnPgSAXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743067092; c=relaxed/simple;
	bh=Ev6op6sM15VCGysaQs2NpJ70AHSnjZnuHWVUWKJfAlQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A+2FoR1ATlKQ7/9ToE9cmg4A2Wi4WIZmhbAYUpsEmwtXjLzqLaSgRc2+dh7yS9qOifr5vOInH8IJmXMBZtCL7ALXhJyMWnM4HD21Md/sB7Lbhywmc5zsP318+N1dMW69qyfu45qdvKmOHzqMKnpzWaxnuoEegpe/ItjJGeDKLpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GmavMxDe; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GmavMxDe"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43d04dc73b7so8046875e9.3
        for <kvmarm@lists.linux.dev>; Thu, 27 Mar 2025 02:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743067088; x=1743671888; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AdqOBa0Y+4+hMz6T43UiEMBnLkl2i23ABjw2IJz/f/k=;
        b=GmavMxDeiO8HSLHgDUYHITPNg+sMDuOj8GoGsnuaN5J1stDssKyrKJe6vIXw9z/lfx
         KRpRPjXXqPCgAz+qAEhdBia+WZvqQTbGpCI4jYZHKTdLgGgI6QEqLHJt0MjanM6liBnV
         Gzg37kB/3X+X3IDdFRswTMOGtmYbWkEoNi3JMvnqri5xvtN6dwg8bYzMW5xLBRWlmEjT
         D/xtGwmYgMAhbqxgzBb+M0K1E1wWMVM+h2Bcz1Yi8zWeYcjtvc8kgcgjbA6g1vWnDtHm
         P88jjTL5gAlVm1fkthlSnOnnQPfKzQ+SK1gxViwDoduDOHJHAY9wiusrscBwMQEs6CPc
         Aq7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743067088; x=1743671888;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AdqOBa0Y+4+hMz6T43UiEMBnLkl2i23ABjw2IJz/f/k=;
        b=ado2DnTudFkOBmYttt7E+Q0xFRKXqkudzOfcffY7QElQqZmsTZxHpQVrIHfhgUw7jc
         t/05FFxRexQ9YzvPBdw1CaYzOU3T7sslgDlwKU+iWTpgB6vPcN0gUhyeTwNpa09YZGJQ
         cZWs99dVTL6mkB0dHnSoSSGUDw1qR7bK8m4y7BIaY5YoUdfToXsV6P8iaVP3H5kv9Df9
         299BvHMv9pNCDWNV17l6tBcAO2zdQ7/VNG2Y+SAe4NgdCcNtKryICyuoQ8SQrJPTXE+l
         MCE9Ccidh8EjKLCKScenJyjYf0XpMrqVup8fHDH9PdcN3niJrplPMX81QlM7Tw5NiC12
         bksQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmSpDKWQU13zyh9zF4v/SJPuHc+bfNSHSAgXy6xG5OHsHgNEwOB4vgVepsgI7kqCPvIey6PyY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+41sW8UvdUkZevDgVR2VOC5v81X+1dF+nXchyHu/yMI1Ne0so
	vBPEBavdlNpi27rBgD8vb13vWJoKzTZ6gocWyb9HL7189cU6nXMYOBnSZxT+cx0=
X-Gm-Gg: ASbGncsKQblA/y4ghcGKIK1vWaZNA+zaUjeXUIBlN4Uy2Z3dbec0bSEmSjcK7av8sBL
	VdFQftSTjfjusw48RMGvgqN+NxG1J7bgUBqloupRhDMRtooxa9K7o37J5i3lF90pqWNxW8Xcwht
	4sQ0jo587gjvsLlPFYgjoMp/H4uPaEIQ75kEvnzfhVw4bKmLNLNwOiE/fvcLz4obwSIHyTlZEDU
	aUc2ZcKsD8mVNMGoYY3XYl3rWANctTdye31TkaQ39TgAZocurVMzyL9BUWx0rUeiLqD4u7oHgAL
	gf8dEHFm1KEi64MTOE2SPrIVCbS8jEZOhTEHl/RtrZAk/xThVA==
X-Google-Smtp-Source: AGHT+IF9q6whwwkhqGN2Pk+AEph3LrTbbtoFFPYNJTAshCFIqJMIeQt7KSSkyJwJU5Ap2Rh/HnzcAg==
X-Received: by 2002:a05:6000:2cb:b0:39a:c8a8:4fdc with SMTP id ffacd0b85a97d-39ad175c052mr2069156f8f.16.1743067088494;
        Thu, 27 Mar 2025 02:18:08 -0700 (PDT)
Received: from [192.168.1.247] ([77.81.75.81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d7ae6a319sm30665955e9.0.2025.03.27.02.18.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Mar 2025 02:18:07 -0700 (PDT)
Message-ID: <ba2c38f1-d686-45dc-ae47-924cc11d15f6@linaro.org>
Date: Thu, 27 Mar 2025 09:18:06 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 5/8] KVM: arm64: Introduce module param to
 partition the PMU
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Colton Lewis <coltonlewis@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
 robh@kernel.org, linux@armlinux.org.uk, catalin.marinas@arm.com,
 will@kernel.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, mark.rutland@arm.com, pbonzini@redhat.com,
 shuah@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <gsnt1pulnepv.fsf@coltonlewis-kvm.c.googlers.com>
 <f7d543f6-2660-460f-88ac-741dd47ed440@linaro.org>
 <Z-RmMLkTuwsea7Uk@linux.dev>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <Z-RmMLkTuwsea7Uk@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 26/03/2025 8:40 pm, Oliver Upton wrote:
> On Wed, Mar 26, 2025 at 05:38:34PM +0000, James Clark wrote:
>> On 25/03/2025 6:32 pm, Colton Lewis wrote:
>>>> I don't know if this is a stupid idea, but instead of having a fixed
>>>> number for the partition, wouldn't it be nice if we could trap and
>>>> increment HPMN on the first guest use of a counter, then decrement it on
>>>> guest exit depending on what's still in use? The host would always
>>>> assign its counters from the top down, and guests go bottom up if they
>>>> want PMU passthrough. Maybe it's too complicated or won't work for
>>>> various reasons, but because of BRBE the counter partitioning changes go
>>>> from an optimization to almost a necessity.
>>>
>>> This is a cool idea that would enable useful things. I can think of a
>>> few potential problems.
>>>
>>> 1. Partitioning will give guests direct access to some PMU counter
>>> registers. There is no reliable way for KVM to determine what is in use
>>> from that state. A counter that is disabled guest at exit might only be
>>> so temporarily, which could lead to a lot of thrashing allocating and
>>> deallocating counters.
> 
> KVM must always have a reliable way to determine if the PMU is in use.
> If there's any counter in the vPMU for which kvm_pmu_counter_is_enabled()
> is true would do the trick...
> 
> Generally speaking, I would like to see the guest/host context switch in
> KVM modeled in a way similar to the debug registers, where the vPMU
> registers are loaded onto hardware lazily if either:
> 
>    1) The above definition of an in-use PMU is satisfied
> 
>    2) The guest accessed a PMU register since the last vcpu_load()
> 
>>> 2. HPMN affects reads of PMCR_EL0.N, which is the standard way to
>>> determine how many counters there are. If HPMN starts as a low number,
>>> guests have no way of knowing there are more counters
>>> available. Dynamically changing the counters available could be
>>> confusing for guests.
>>>
>>
>> Yes I was expecting that PMCR would have to be trapped and N reported to be
>> the number of physical counters rather than how many are in the guest
>> partition.
> 
> I'm not sure this is aligned with the spirit of the feature.
> 
> Colton's aim is to minimize the overheads of trapping the PMU *and*
> relying on the perf subsystem for event scheduling. To do dynamic
> partitioning as you've described, KVM would need to unconditionally trap
> the PMU registers so it can pack the guest counters into the guest
> partition. We cannot assume the VM will allocate counters sequentially.

Yeah I agree, requiring cooperation from the guest probably makes it a 
non starter.

> 
> Dynamic counter allocation can be had with the existing PMU
> implementation. The partitioned PMU is an alternative userspace can
> select, not a replacement for what we already have.
> 
> Thanks,
> Oliver


It's just a shame that it doesn't look like there's a way to make BRBE 
work properly in guests with the existing implementation. Maybe we're 
stuck with only allowing it in a partition for now.

Thanks
James

