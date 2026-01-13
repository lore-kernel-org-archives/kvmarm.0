Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F622EA482
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 15:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768316439; cv=none; b=YP8PBYdAXRLlnKjddwro/1FHRvwNGDI3q74TD0Fz5zR+4XTVMa+pAjtk1CR8xbV0orqY8vy//njIAaFAPziedOawMXqw364kr5C5DLBBlwvcHyHyKGE1y30vhF+KS/yENOPNMcU0KlBmV5ic1xhZLMGCSIFUT/m6yYaqTTGQZSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768316439; c=relaxed/simple;
	bh=pZ4/8fdk0PZP7n83BnW9xrF/YuepBbSzInqmF+UEAdA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PmxZP+BW0k4Kul0kh6hpgth590HD3vA9Vnzv7wp53k0Oe3BE6IhNQjewNbJ/CvNd5qd+QrMMBwr8Jk0PyBELVdECtSwpkb0oOMmpodfky1VD4tav61mj86y1V0k4ifMPbqsAgr9UHFDKPzbhQe77agttirAUVBaMTh0htcSKjj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CCT/0v61; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CCT/0v61"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47796a837c7so52676965e9.0
        for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 07:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768316436; x=1768921236; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZGE9UIHVgDBqIc65rQA4U564vEu8+BlSlMVLYefNTVU=;
        b=CCT/0v61F8sKL1ks0k5U2MqPx1fcPlA8zqTU6RkgEBmw9kIi2PnJxeEuD7hxFbwD9V
         +nuSpDU9Qhuj8QU11qpZrk+qlx9G9lHHWqnUwvcLx9RtQbmbXHzzBHrgl2kj8N616ZMA
         rxfUK2UWwH2aG6Asu/HoXuvHj45VINsfcW2g7OGFjfDK4o00oesPglBHji/jS0XEipfs
         knu44MrWp5GSStdCvjga055cwvSHlEW6ojqY0vcimTztYuub3GkpcuvT649p8hyrOayt
         WcvkgQIipVTBbT1L4tk7+Vto5lePnp65oI7CiW4oTzWkey4nTL0tO47KCgXD6o/7R1b1
         dBzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768316436; x=1768921236;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZGE9UIHVgDBqIc65rQA4U564vEu8+BlSlMVLYefNTVU=;
        b=jRYPMYEU3aD3K2GmsaQozrsTMSYBqlHGjXFMdu3YisIFCvghPp6hCJT9+x89ojIX9B
         1kIp06/kLzYBX1RrzfFCzZY8Ktl6Agz3n/PJeewJNXLKiDpj7KUjM5S7DjAywFcaUR0C
         BJ8UPaCoE3DDA4zHiaVA3t9BbAJdao4hnUCrggkgOkIMVKfnD/2P4piTigh2yxt+Vnfr
         xNPzrju3FSTTvlnmBha5qaHwU2pUGcUtlKNFE144AUxNsETDDVAAex/x8O2i3fCjwt6X
         iHmeURP3/mcs4ejQgdYjZZPchPX5IG3pEGThn6gO036vceqMpPdUwOUbs54f0ewXAPgM
         oUzw==
X-Forwarded-Encrypted: i=1; AJvYcCXxYSfv+uh5/edo/0SVP4cuvMzQxuzr9XLtTlnHJu2imrLdqVhfNSZU42XKKFVPDxPlbF5mtSY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzb9QBG1ti+z/5KzS2010z3LoegBhPKn//UCn9EScxqNDVE2+7s
	gZnrGb335Cq7Bpn4kYiC11upWnGYHJpPBIatzVkAzBnbGVf5thvPeCHAEmle5Zkf0lE=
X-Gm-Gg: AY/fxX7eQwb7HKH/E+bHWnsEbqjXkZPQWF5CWHOZZWG+oOm3sGc7/BMHbszqZUCg0AJ
	CbuIC/pRhaj0D/R8za6UttWl0TnxM2ZSOpsOiuDMNzzA9NuGWQJhfElq27We1/Vd3fd54CF9WM/
	qP9wmkqKkv9yTyTmbSLThC9vNgVrzg/lTeJv49rckNXUxLU0Snf5up7eLKBik4KjnnoUF2CNrYe
	BGFGBhrmfdh0iM8+uCWf3dssEmqCNDxGz96tyWWVMkpnApS974OfLwm/9yBJ2SUaBFUZT6Gc+GT
	76l1BxYHZGqAGpki6AhFR8matgcw9uevHKY3MsjSt6JLU3SaXBA1KbpQO6EDUzCkiXrGHq8x4kL
	6D6id04hQfqwN/B7FD+sa2scfEdD4HMI/rdy8DqK80uE4MG0B9r4FUWfcg60rA/P52MV2GlUJel
	WMYakuUXYDg/PJ0hpdTZSu2HgKSFU=
X-Google-Smtp-Source: AGHT+IFbC4mPqKFKEgjK16OyZrgYzwPWew86VgIcMFrQGd72up6dSFd2v0PSZd2el7PkRQfxGmmB9g==
X-Received: by 2002:a05:600c:a314:b0:479:3876:22a8 with SMTP id 5b1f17b1804b1-47d84b2d285mr229096815e9.16.1768316435786;
        Tue, 13 Jan 2026 07:00:35 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ee119aa2asm1883695e9.4.2026.01.13.07.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 07:00:35 -0800 (PST)
Message-ID: <43ec5e82-88a6-4c7b-983a-b5aa32673913@linaro.org>
Date: Tue, 13 Jan 2026 15:00:34 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 03/35] KVM: arm64: Add CONFIG_KVM_ARM_SPE Kconfig
 option
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: mark.rutland@arm.com, james.morse@arm.com, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-4-alexandru.elisei@arm.com>
 <1aaffbcd-ba0c-4371-80d7-ce59ac7f13a9@linaro.org> <aWTaXBse_R_LjJE-@raptor>
 <d7db9f17-012e-43d7-a0a5-58b254dd7e33@linaro.org> <aWUQ3bYuxpMEWTUk@raptor>
 <aWYdob5IfyOQcu6I@raptor>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <aWYdob5IfyOQcu6I@raptor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 13/01/2026 10:25 am, Alexandru Elisei wrote:
> Hi James,
> 
> On Mon, Jan 12, 2026 at 03:18:53PM +0000, Alexandru Elisei wrote:
>> Hi James,
>>
>> On Mon, Jan 12, 2026 at 12:09:19PM +0000, James Clark wrote:
>>>
>>>
>>> On 12/01/2026 11:26 am, Alexandru Elisei wrote:
>>>> Hi James,
>>>>
>>>> On Fri, Jan 09, 2026 at 04:29:50PM +0000, James Clark wrote:
>>>>>
>>>>>
>>>>> On 14/11/2025 4:06 pm, Alexandru Elisei wrote:
>>>>>> Add a new configuration option that will be used for KVM SPE emulation.
>>>>>> CONFIG_KVM_ARM_SPE depends on the SPE driver being builtin because:
>>>>>>
>>>>>> 1. The SPE driver maintains a cpumask of physical CPUs that support SPE,
>>>>>>       and that will be used by KVM to emulate SPE on heterogeneous systems.
>>>>>>
>>>>>> 2. KVM will rely on the SPE driver enabling the SPE interrupt at the GIC
>>>>>>       level.
>>>>>>
>>>>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>>>>> ---
>>>>>>     arch/arm64/kvm/Kconfig | 8 ++++++++
>>>>>>     1 file changed, 8 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>>>>>> index 4f803fd1c99a..31388b5b2655 100644
>>>>>> --- a/arch/arm64/kvm/Kconfig
>>>>>> +++ b/arch/arm64/kvm/Kconfig
>>>>>> @@ -83,4 +83,12 @@ config PTDUMP_STAGE2_DEBUGFS
>>>>>>     	  If in doubt, say N.
>>>>>> +config KVM_ARM_SPE
>>>>>> +	bool
>>>>>> +	depends on KVM && ARM_SPE_PMU=y
>>>>>
>>>>> I think the most common configuration is module, so requiring built-in isn't
>>>>> great. If there's any way of avoiding it, even if it costs a little bit of
>>>>> pain, it would be good for adoption.
>>>>
>>>> I'm not sure how that could be done. You need the buffer maintenance interrupt
>>>> to do a VM exit so KVM can inject the virtual interrupt back into the guest,
>>>> otherwise there's a possibility of a large blackout window when the buffer is
>>>> full.
>>>
>>> Without expanding more I don't see how injecting an interrupt is strongly
>>> related to the way it's compiled.
>>
>> It's the SPE driver that enables the hardware interrupt in the GIC.
>>
>>>
>>>>
>>>> The code also relies on the SPE driver to probe all the SPUs in the system.
>>>>
>>>
>>> I don't think that's a hard requirement either, the KVM code could fairly
>>> easily do this itself. Inline the common code and put it in a shared header
>>> etc. I'm sure there are lots of creative ways to flip the dependencies that
>>> might not be "proper" software engineering. But like I said a bit of pain
>>> here might be beneficial overall.
>>
>> Userspace gets the maximum buffer size and the SPE instance id from the sysfs
>> files.
>>
>> So KVM would have to parse the DTB, read PMBIDR_EL1 and PMSIDR_EL1 on each
>> physical CPU in the system, create the sysfs files (at least 'type', 'cpumask'
>> and 'max_buffer_size' or whatever that ends up being named) and install a dummy
>> IRQ handler before the SPE driver is loaded.
>>
>> Then when the SPE driver is loaded, the driver would have to remove the IRQ
>> handler and install its own, and create the rest of the sysfs files.
>>
>> That's assuming that the SPE driver is loaded after KVM. I think it's possible
>> for the SPE driver to be loaded first. So both KVM and SPE would have be able to
>> communicate with one other in case the other probed first.
>>
>> Is having to change the symbol ARM_SPE_PMU from 'm' to 'y' worth this? I am not
>> convinced and I don't see much use for going down this rabbit hole at this stage
>> of the series.

No, definitely not something that needs to be done at this point.

>>
>> Also, since KVM would partially populate the sysfs directory for each SPE
>> instance, would it be reasonable for software to assume that the SPE driver is
>> loaded based on this and start using it? For example, how does perf detect the
>> presence of the arm_spe event?
> 
> Coming back to this, I do understand and agree with your concerns, so after
> talking in private I came up with exporting the symbol kvm_host_spe_init() -
> that's the function which adds the SPE instance to the list of SPUs.
> 
> With this change the SPE driver can be built as a module, but SPE for a VM is
> available only as long as the driver is loaded.
> 
> I hope that improves the adoption story :)
> 
> Thanks,
> Alex

Nice, if it's not too horrible we should try it. If it turns out to be 
horrible then yes we'll have to ask people to change their configs.

