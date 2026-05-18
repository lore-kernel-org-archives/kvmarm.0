Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90123313272
	for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 15:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779117694; cv=none; b=ng42GCdJoFVGlrQgkNnT2P8pMGepE5DBQNTRCwytBYlkHaNT0r+qBK7OKskihpbkJprIN81c9ZBlA6qzWNho0IkkIGpO8zfny1YQVZDbxmBpxQkOjRr0IYLUz3lC70R0ri0F5jdMyF5SwDM+PxxLaYvjnU02XUhkkhGVokClzC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779117694; c=relaxed/simple;
	bh=W3vI8jSoLlk17jwO8jYjzwJ4qaX7gY4AN/gCAwQmQJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jLEBgE7J5Hnt3sLcqTP1Q65wTcGCQTXLZzVA2sdAOiwntn2MTvFAhYJ0CbICGw5baDgD3tWkyXtm9Jj3t8/7rWo1spyHIL6liRYdN+UC7zYd0DpDSJnNKO3dbvimm6rj+lAzmqPt97sSkHgh6wjP0F1g3lm7h640gQBHwSpjgkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kd8ZHOit; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kd8ZHOit"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779117691;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C1bFUpduXqNFXVInpMskz8flfKqQxqeF4wLqRJiwQpg=;
	b=Kd8ZHOit5QqpOd2TMqH05gMm7xISyOgrVD8+mAM6WjRQYSjaHLU9BWjttE2fNJJGRANT7d
	2K1NIM2YNpY/YnpLoGB7bMZ1mt65zbI+F1VKR1myBjbkmUWhAvPOh7dngXG7ja2crPv4Hn
	UHdXYV1+xVnAaOuQWeMpUEP8JatRFkA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-247-2EtUdkr7MHeCJ3eCa_PTWQ-1; Mon, 18 May 2026 11:21:28 -0400
X-MC-Unique: 2EtUdkr7MHeCJ3eCa_PTWQ-1
X-Mimecast-MFC-AGG-ID: 2EtUdkr7MHeCJ3eCa_PTWQ_1779117687
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48fe3e73da6so11643665e9.2
        for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 08:21:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779117687; x=1779722487;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C1bFUpduXqNFXVInpMskz8flfKqQxqeF4wLqRJiwQpg=;
        b=L83IkBBmep8gwfkpcD76Rpl35gZOdxVKkVVqaVG9w8uCxWLdhg6ki75SJF6sZpaq6D
         AUYU06P0tYi2811zo1oWWgQM3Yix5zKM3y9Y6EiOw0+W8eUop+bWxteoYGJmmGYBJv4K
         NuuBK04tHB3Vz6ux/BnFyxu0k6LUfedheObSFojA9KVnsUj04BXKYmrft6XRBZRLyMjx
         TDilKqF7X/kI0/iGUL43m7O/0RU1qMTl9xQ9RxB2VMSMxz11tr2YSJQCHaLe0ABdPW8O
         kPF7mONRVM5bZ8BwAXs9QSkwzzJO387EANHL8Z/SchOoPtRgq81LZ1l3v/bvLdIcX7Vs
         /uFA==
X-Forwarded-Encrypted: i=1; AFNElJ/8HI62zfAEsOKizthw5eX9RrNMWBi/DEjFC39wOSK32AIQ87WY38MxnLaQJ2s2LH35uxyhEog=@lists.linux.dev
X-Gm-Message-State: AOJu0YwtoGd+69TGy2bSOdrl2j6F+YDtw10DhgtsA9TrGx7931POi4dL
	y+iXtaTiRMztD95hwpj3syclbTc20gAgfFADdl1PUzMSzlidQPL7S6P8joyDyeWTdjN4/xM2Rt8
	qkmIgSvil4USokQ1nCg8+Mc8fxit7kZlIY5JohYG0Nsx1tt1hIpiZtjVyyA==
X-Gm-Gg: Acq92OF4P96mJBmeD2kqKjYW/4vhC2aGEslDUF/mxSlQe30ii+YMtI1l5tSFVYVOPiz
	aSCKACtcyC4ADT49GAxNKkfIFVZw6LSbCG3GaegfIGDt4ogjvRw7rP2xlEpS5j3EKX0/mqz7PeA
	BvuRNzlrJhRXGnJ1t11xzio4JPI+kXXuHyzm4bpkDjuBySEtWvwVnWTDhLr9AEkH3IKvXx5cSFn
	DnbkWheDVRNvR3lCOtwSwqFtZWp+KX9vfNjHhsAyt9E0sh+ibNQlA5SIABe2LbDVaGVzvsB5B1L
	KNoTCWYHHheAxhHys58XjVz9SIMvo53zdNa7V6eZgGGiiLQfd28uAElJXWq7M8tOnfOHXjzyjHl
	bH5JaASHQ8eWWIAabEocgjvk0t7T6tAkE96n2YNLmOg1qaw1KKQ/eB/ie9WJ5M3V1ut+vzKcJWD
	5mBWKL
X-Received: by 2002:a05:600c:6995:b0:489:1f97:6b1d with SMTP id 5b1f17b1804b1-48fe6322219mr241867935e9.28.1779117687071;
        Mon, 18 May 2026 08:21:27 -0700 (PDT)
X-Received: by 2002:a05:600c:6995:b0:489:1f97:6b1d with SMTP id 5b1f17b1804b1-48fe6322219mr241867385e9.28.1779117686687;
        Mon, 18 May 2026 08:21:26 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4862209sm262808055e9.0.2026.05.18.08.21.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 08:21:26 -0700 (PDT)
Message-ID: <1d8a86aa-d43e-4e4c-ae5c-7cb392d93471@redhat.com>
Date: Mon, 18 May 2026 17:21:24 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 15/17] arm/cpu: Expose writable ID reg field properties
 on the kvm host vcpu model
To: Shameer Kolothum Thodi <skolothumtho@nvidia.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>
Cc: "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-16-eric.auger@redhat.com>
 <CH3PR12MB7548D4829306C3B8E9612FD9AB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CH3PR12MB7548D4829306C3B8E9612FD9AB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lq5YCWTLDVslsW1FFjMQvBAuqtADsRSRd9_nUWY1muI_1779117687
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/7/26 9:22 PM, Shameer Kolothum Thodi wrote:
>
>> -----Original Message-----
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: 03 May 2026 08:34
>> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
>> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
>> peter.maydell@linaro.org; richard.henderson@linaro.org;
>> cohuck@redhat.com; sebott@redhat.com; Shameer Kolothum Thodi
>> <skolothumtho@nvidia.com>; philmd@linaro.org
>> Cc: maz@kernel.org; oliver.upton@linux.dev; pbonzini@redhat.com;
>> armbru@redhat.com; berrange@redhat.com; abologna@redhat.com;
>> jdenemar@redhat.com
>> Subject: [PATCH v4 15/17] arm/cpu: Expose writable ID reg field properties on
>> the kvm host vcpu model
>>
>> External email: Use caution opening links or attachments
>>
>>
>> If the host supports KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES and
>> KVM_ARM_GET_REG_WRITABLE_MASKS ioctl successfully retrieved the mask
>> of writable fields for all ID regs, expose uint64 SYSREG properties
>> for all the writable ID reg fields exposed by the host kernel which
>> can be matched in target/arm/cpu-sysreg-properties.c.
>>
>> Properties are named  SYSREG_<REG>_<FIELD> with REG and FIELD
>> being those used in linux arch/arm64/tools/sysreg or in the AARCHMRS
>> Registers.json.
>>
>> This is achieved by matching the writable fields retrieved from the
>> host kernel against the generated description of ID regs and their
>> fields in target/arm/cpu-sysreg-properties.c.
>>
>> An example of invocation is:
>> -cpu host,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
>> which sets DP field of ID_AA64ISAR0_EL1 to 0.
>>
>> [CH: add properties to the host model instead of introducing a new
>> "custom" model]
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  target/arm/cpu.c   | 12 ++++++++++++
>>  target/arm/cpu64.c | 23 ++++++++++++++++++++++-
>>  2 files changed, 34 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
>> index 10feb639c4..10ce4eb0cb 100644
>> --- a/target/arm/cpu.c
>> +++ b/target/arm/cpu.c
>> @@ -1824,6 +1824,18 @@ static void arm_cpu_realizefn(DeviceState *dev,
>> Error **errp)
>>          return;
>>      }
>>
>> +    /*
>> +     * If we failed to retrieve the set of writable ID registers for the "host"
>> +     * CPU model, report it here. No error if the interface for discovering
>> +     * writable ID registers is not available.
>> +     * In case we did get the set of writable ID registers, set the features to
>> +     * the configured values here and perform some sanity checks.
>> +     */
>> +    if (cpu->writable_id_regs_status == WRITABLE_ID_REGS_FAILED) {
>> +        error_setg(errp, "Failed to discover writable id registers");
>> +        return;
>> +    }
>> +
>>      if (!cpu->gt_cntfrq_hz) {
>>          /*
>>           * 0 means "the board didn't set a value, use the default". (We also
>> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
>> index 1b3d3fb245..d66cb00a21 100644
>> --- a/target/arm/cpu64.c
>> +++ b/target/arm/cpu64.c
>> @@ -852,6 +852,8 @@ static void
>> kvm_arm_set_cpreg_mig_tolerances(ARMCPU *cpu)
>>  static void aarch64_host_initfn(Object *obj)
>>  {
>>      ARMCPU *cpu = ARM_CPU(obj);
>> +    bool expose_id_regs = true;
>> +    int ret;
> The above will be unused for non KVM builds.
removed
>
>>  #if defined(CONFIG_NITRO)
>>      if (nitro_enabled()) {
>> @@ -862,8 +864,27 @@ static void aarch64_host_initfn(Object *obj)
>>
>>  #if defined(CONFIG_KVM)
>>      kvm_arm_set_cpreg_mig_tolerances(cpu);
>> -    kvm_arm_set_cpu_features_from_host(cpu, false);
>> +
>> +    cpu->writable_map = g_malloc(sizeof(IdRegMap));
> Does kernel clear the buffer before setting writable mask?

yes it does:
        /* Wipe the whole thing first */
        if (clear_user(masks, KVM_ARM_FEATURE_ID_RANGE_SIZE *
sizeof(__u64)))
                return -EFAULT;

>
>> +    /* discover via KVM_ARM_GET_REG_WRITABLE_MASKS */
>> +    ret = kvm_arm_get_writable_id_regs(cpu, cpu->writable_map);
>> +    if (ret == -ENOSYS) {
>> +        /* legacy: continue without writable id regs */
>> +        expose_id_regs = false;
>> +    } else if (ret) {
>> +        /* function will have marked an error */
>> +        return;
>> +    }
> Should free and NULL writable_map for both error paths above.
sure

Eric
>
> Thanks,
> Shameer
>
>> +
>> +    kvm_arm_set_cpu_features_from_host(cpu, expose_id_regs);
>>      aarch64_add_sve_properties(obj);
>> +
>> +    if (expose_id_regs) {
>> +        /* generate SYSREG properties according to writable masks */
>> +        kvm_arm_expose_idreg_properties(cpu, arm64_id_regs);
>> +    }
>> +
>>  #elif defined(CONFIG_HVF)
>>      hvf_arm_set_cpu_features_from_host(cpu);
>>  #elif defined(CONFIG_WHPX)
>> --
>> 2.53.0

