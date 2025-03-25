Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3F31A3154
	for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 18:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742928763; cv=none; b=ps4+PC/0p0uD8ucfCswRnd/HOw9zU869ge3RI541uK12Bp/dPKHZLumYma7zsSZTcGoC8H8udivk1CloOxQHO4T3P9vnlwS5SS5sV8GTUOShNNwGONJ4CiL8HnTea7ee63/N/1pEYmRwoCARr029pmrbZvn6yMa7G2CXxgQljVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742928763; c=relaxed/simple;
	bh=mjUlY3jFSJjaOKRM/bqH7VbePb3z1ii+rpI0lBwhP68=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=e54I5UnbmSjS3APWd52p0jfJZFly9LYrZhmzpLSnfhQs5HnK3hJFX3SiRWXVYX48/g430/eLo0KoK+bPEi0jS3xJvuuobNeu3nO4N36v8x6RbTppKJgSM0/2SFGuv/cWxCaVBVfLzRCNWJnmR7suhTtJoXhrUbglOpMP3QHexYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ehBbryIc; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ehBbryIc"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3d438be189bso59665085ab.3
        for <kvmarm@lists.linux.dev>; Tue, 25 Mar 2025 11:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742928759; x=1743533559; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nH4P9eJG9ixX5QbX8zMqKoULuBPy5l5wVy3PBOk0b0g=;
        b=ehBbryIcKdh3CeYtwKbL30BFCuaEUSiPhnfVzrJc811d8gyjqq8gSi3gWnqoP0VhWF
         b8iDpXeFRo2BUs6/HNgvOD7km/0Cf2TfBhIkmWP0utY6Yqu2DpqDtLs7Zfh1awSDDLDg
         JWJyb0I5+r//p461T62q32T8uILrH7r0zzvJ2HXY1dFSmFL3BAj+O507t5FBbK/lI0Qn
         5KRminWa55FqAPwB/6+K3KW8PPu0S03eVm8iSCXnKIpVIM+80LYirw23QZCHdhRtwHDI
         DyCkr4gB6Y4zCS2NFo0WyhXxFeCMTTHUORiqsLdK6GFYqvAAebjbziC5yjsejijEAGe0
         ozrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742928759; x=1743533559;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nH4P9eJG9ixX5QbX8zMqKoULuBPy5l5wVy3PBOk0b0g=;
        b=YPiOdv4S48UCs4zGf3EqxOVFsay4MiLX0JcujGbiY7ZkjIT2Sv1mhH8YR7ADfLFeHz
         LDwERW5d9O9tQ3qMXvCLp08+9pjfZHuZ6QDa7/KhE4S8JAC4ebvI4AWro4JXF99GC4ud
         5xrjKl2M9afcf33mbliWio9iHQpmvYDuqACGTqsu0AXgT2v6YsqXMZSgkSEulZ2OE6QR
         SZ3/fc8LRaPZeqAkju/Eq7wAYkqfSnNyLaennsbea2/6cNR1FoT2wB3y2aFx8ca4aNKW
         idZbyOuvfsmdnti6PTMQJzmYkEjs+i/b5+YBmREIuQZYvSH/p9IyIGyF+kxotd8IMImk
         nIig==
X-Forwarded-Encrypted: i=1; AJvYcCUYAMq2wrlmJ95P42+tVjDlBpCOf9zhTG6A5VgdgambkjCg1uI5TnL6JptwB4evaXbKBuYALws=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPJyVWrCzSXjz+ZsKAg1yTRfKqprea9yQHfrUhdlwgm3asyaaG
	/zZM6VEgyyILrSzPCyqWPrwxRYGP77OzcUuKyjRmCYYRdVjBreI/qT9JoY+YZOxBJepRBsp+WN8
	NQzJzYHAxsD3Na4MUP8DIsg==
X-Google-Smtp-Source: AGHT+IFihTn29mkx1GCcsdzB1BWaATm719zstIXb77dxFcanWyTVCgHo5XFcuAcWL7Ck6Mq9GEViCbd4LSLj7nsAJQ==
X-Received: from ilbcp4.prod.google.com ([2002:a05:6e02:3984:b0:3d2:ad2f:c829])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:3d86:b0:3d0:443d:a5c3 with SMTP id e9e14a558f8ab-3d5960c1226mr193021365ab.3.1742928759319;
 Tue, 25 Mar 2025 11:52:39 -0700 (PDT)
Date: Tue, 25 Mar 2025 18:52:38 +0000
In-Reply-To: <8450a182-5c62-4546-ab91-5d39eb252254@linaro.org> (message from
 James Clark on Mon, 24 Mar 2025 14:52:26 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnty0wtlz7t.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [RFC PATCH v3 7/8] perf: arm_pmuv3: Keep out of guest counter partition
From: Colton Lewis <coltonlewis@google.com>
To: James Clark <james.clark@linaro.org>
Cc: kvm@vger.kernel.org, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	pbonzini@redhat.com, shuah@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

James Clark <james.clark@linaro.org> writes:

> On 13/02/2025 6:03 pm, Colton Lewis wrote:
>> If the PMU is partitioned, keep the driver out of the guest counter
>> partition and only use the host counter partition. Partitioning is
>> defined by the MDCR_EL2.HPMN register field and saved in
>> cpu_pmu->hpmn. The range 0..HPMN-1 is accessible by EL1 and EL0 while
>> HPMN..PMCR.N is reserved for EL2.

>> Define some macros that take HPMN as an argument and construct
>> mutually exclusive bitmaps for testing which partition a particular
>> counter is in. Note that despite their different position in the
>> bitmap, the cycle and instruction counters are always in the guest
>> partition.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>    arch/arm/include/asm/arm_pmuv3.h |  2 +
>>    arch/arm64/include/asm/kvm_pmu.h |  5 +++
>>    arch/arm64/kvm/pmu-part.c        | 16 +++++++
>>    drivers/perf/arm_pmuv3.c         | 73 +++++++++++++++++++++++++++-----
>>    include/linux/perf/arm_pmuv3.h   |  8 ++++
>>    5 files changed, 94 insertions(+), 10 deletions(-)

>> diff --git a/arch/arm/include/asm/arm_pmuv3.h  
>> b/arch/arm/include/asm/arm_pmuv3.h
>> index 2ec0e5e83fc9..dadd4ddf51af 100644
>> --- a/arch/arm/include/asm/arm_pmuv3.h
>> +++ b/arch/arm/include/asm/arm_pmuv3.h
>> @@ -227,6 +227,8 @@ static inline bool kvm_set_pmuserenr(u64 val)
>>    }

>>    static inline void kvm_vcpu_pmu_resync_el0(void) {}
>> +static inline void kvm_pmu_host_counters_enable(void) {}
>> +static inline void kvm_pmu_host_counters_disable(void) {}

>>    /* PMU Version in DFR Register */
>>    #define ARMV8_PMU_DFR_VER_NI        0
>> diff --git a/arch/arm64/include/asm/kvm_pmu.h  
>> b/arch/arm64/include/asm/kvm_pmu.h
>> index 174b7f376d95..8f25754fde47 100644
>> --- a/arch/arm64/include/asm/kvm_pmu.h
>> +++ b/arch/arm64/include/asm/kvm_pmu.h
>> @@ -25,6 +25,8 @@ void kvm_host_pmu_init(struct arm_pmu *pmu);
>>    u8 kvm_pmu_get_reserved_counters(void);
>>    u8 kvm_pmu_hpmn(u8 nr_counters);
>>    void kvm_pmu_partition(struct arm_pmu *pmu);
>> +void kvm_pmu_host_counters_enable(void);
>> +void kvm_pmu_host_counters_disable(void);

>>    #else

>> @@ -37,6 +39,9 @@ static inline bool kvm_set_pmuserenr(u64 val)
>>    static inline void kvm_vcpu_pmu_resync_el0(void) {}
>>    static inline void kvm_host_pmu_init(struct arm_pmu *pmu) {}

>> +static inline void kvm_pmu_host_counters_enable(void) {}
>> +static inline void kvm_pmu_host_counters_disable(void) {}
>> +
>>    #endif

>>    #endif
>> diff --git a/arch/arm64/kvm/pmu-part.c b/arch/arm64/kvm/pmu-part.c
>> index e74fecc67e37..51da65c678f9 100644
>> --- a/arch/arm64/kvm/pmu-part.c
>> +++ b/arch/arm64/kvm/pmu-part.c
>> @@ -45,3 +45,19 @@ void kvm_pmu_partition(struct arm_pmu *pmu)
>>    		pmu->partitioned = false;
>>    	}
>>    }
>> +
>> +void kvm_pmu_host_counters_enable(void)
>> +{
>> +	u64 mdcr = read_sysreg(mdcr_el2);
>> +
>> +	mdcr |= MDCR_EL2_HPME;
>> +	write_sysreg(mdcr, mdcr_el2);
>> +}
>> +
>> +void kvm_pmu_host_counters_disable(void)
>> +{
>> +	u64 mdcr = read_sysreg(mdcr_el2);
>> +
>> +	mdcr &= ~MDCR_EL2_HPME;
>> +	write_sysreg(mdcr, mdcr_el2);
>> +}
>> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
>> index 0e360feb3432..442dcff56d5b 100644
>> --- a/drivers/perf/arm_pmuv3.c
>> +++ b/drivers/perf/arm_pmuv3.c
>> @@ -730,15 +730,19 @@ static void armv8pmu_disable_event_irq(struct  
>> perf_event *event)
>>    	armv8pmu_disable_intens(BIT(event->hw.idx));
>>    }

>> -static u64 armv8pmu_getreset_flags(void)
>> +static u64 armv8pmu_getreset_flags(struct arm_pmu *cpu_pmu)
>>    {
>>    	u64 value;

>>    	/* Read */
>>    	value = read_pmovsclr();

>> +	if (cpu_pmu->partitioned)
>> +		value &= ARMV8_PMU_HOST_CNT_PART(cpu_pmu->hpmn);
>> +	else
>> +		value &= ARMV8_PMU_OVERFLOWED_MASK;
>> +
>>    	/* Write to clear flags */
>> -	value &= ARMV8_PMU_OVERFLOWED_MASK;
>>    	write_pmovsclr(value);

>>    	return value;
>> @@ -765,6 +769,18 @@ static void armv8pmu_disable_user_access(void)
>>    	update_pmuserenr(0);
>>    }

>> +static bool armv8pmu_is_guest_part(struct arm_pmu *cpu_pmu, u8 idx)
>> +{
>> +	return cpu_pmu->partitioned &&
>> +		(BIT(idx) & ARMV8_PMU_GUEST_CNT_PART(cpu_pmu->hpmn));
>> +}
>> +
>> +static bool armv8pmu_is_host_part(struct arm_pmu *cpu_pmu, u8 idx)
>> +{
>> +	return !cpu_pmu->partitioned ||
>> +		(BIT(idx) & ARMV8_PMU_HOST_CNT_PART(cpu_pmu->hpmn));
>> +}
>> +
>>    static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
>>    {
>>    	int i;
>> @@ -773,6 +789,8 @@ static void armv8pmu_enable_user_access(struct  
>> arm_pmu *cpu_pmu)
>>    	if (is_pmuv3p9(cpu_pmu->pmuver)) {
>>    		u64 mask = 0;
>>    		for_each_set_bit(i, cpuc->used_mask, ARMPMU_MAX_HWEVENTS) {
>> +			if (armv8pmu_is_guest_part(cpu_pmu, i))
>> +				continue;

> Hi Colton,

> Is it possible to keep the guest bits out of used_mask and cntr_mask in
> the first place? Then all these loops don't need to have the logic for
> is_guest_part()/is_host_part().

It should be possible.

> That leads me to wonder about updating the printout:

>    hw perfevents: enabled with armv8_pmuv3_0 PMU driver, 7 (0,8000003f)
>      counters available

> It might be a bit confusing if that doesn't quite reflect reality anymore.

Good point.
