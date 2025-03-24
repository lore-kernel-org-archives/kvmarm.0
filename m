Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E681DD873
	for <kvmarm@lists.linux.dev>; Mon, 24 Mar 2025 14:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742827952; cv=none; b=aPjpDbusYxULQWAEx9Pw2o9MMDrd1lGoWQ0dWvVJhHrqMnw9qaPJoj/lH9d43+yMP5R+arkgupIgEv+F18HSQYVM0YwLx6h5UJVpjLWx5Hceqs4pkX2pUUU37967127ariW9B4L1q0qj8q62hdPBI7VKsD6yhfL7IOC097cF7bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742827952; c=relaxed/simple;
	bh=nD/Dn1FXRe/gRT9ezb+krNed0FvxLmf7DtmDXLb5T7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ESSJB1+sDD5tYbkaag5ysuNIjOSCakVaScxIBK78gNiymRPCrJPoqrCVavQS1NyFeBiu6if3n21LwqTGTnN9YcisZqjilUBZySADqur+839rfl4vzjMlLGOtvQ2/eT5m+X4nOTGll92xkN9cqtY2CJ/0i5MYLH9YnOXGOlYJ1Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tSQcmVX3; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tSQcmVX3"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-39130ee05b0so4245676f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 24 Mar 2025 07:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742827949; x=1743432749; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=exBH9+0EKJsJU5vfoNtnKHgSzJ0TgqGbPxyoWRS+XAk=;
        b=tSQcmVX35T94B4dIltIKOyD3crJNoq5H3h7DHZShRcSxfui/A87tQ+KbijsbHJujDb
         brcvsZB7teavPgFlCtstRWbQbR5IbmVn9RIlz+FJGoy6e8gSwLsxoGJccJQENOHBM0YH
         5Or2ce8CraJGwxY1lZhwxc6AGvtGvYkRShu1aFlrQGTUAl9Lug0RW2VS6a41aLaCHQaq
         YL+UxTodXi/0nmMBlJh2GbV/SWOetvqoI3cj9Rc5RKZjkEp/0RvOEoROBcPPVJdwArDa
         WcXYgNEtmyvcIpE+hE/IrzC15dzZpI1nIxNiOnyYH46mXELm+hjTa6e+++17L/HJ/QPl
         Bp+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742827949; x=1743432749;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=exBH9+0EKJsJU5vfoNtnKHgSzJ0TgqGbPxyoWRS+XAk=;
        b=Q5vguugNsnfhKKOa797vel6oJZDe+SMwHGHZUHC9NL7kVlhzxkENM6aweSOEQS8HKG
         Hq44MdZcXY3jL8Y/gLKnVepd7bimmF7BNVqli2bVOPTuitsD7kcfhUZ7U6AFpW3DMejW
         fwPICEOHKFFjos7gVzXGESXorAcKanlPLmTlK4GI6mPASp0P5mxc46u5lZWMdLo2pWTd
         VNCbMluwAsqUZ/hajZgzL2IaSK70yACEHfLAGJbcOAs3/ZUa9W4jQ42laGCYyc6FKpKI
         x006Uvnn+kriirEHNd0TMgQcRDOHt0c5gwIfH0wD/JEIY6aV5X7GeyqYpi1KAD0Xj7xt
         siQw==
X-Forwarded-Encrypted: i=1; AJvYcCVo6Xhi9a6x4DN/6z/ZaArd9W9+981gmFxfLB0SQnFENWswn/seoFmQyhId1gd5KV5mO7MXNzw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2QKbc/fHt4ofgiFrwBzc5f5fhPK7KERgbD2ndyWykdV2QKVom
	ob7FFG8KQQrpOb4Zs505tmwxvOQDmnpujP8+v8tnt0ruKuwoda6iQtf7omk/FBg=
X-Gm-Gg: ASbGncsh+uqJ5sDIk7pq3ln4/Ggd3/976hqs6oWGFuAInbneqFbULUzbZ+76bUve2I/
	o0uV5WmcRH7gza049asIXwbU6W1o8DWL70YrLf+t8wv8U9WT/r0aHOuLUkKSayJi9W25pkoOnBp
	EpIZ01K9Jur8YlksqBf1ip0P47g+6PqgIBHBKpSyzoWtkS7/in3mQJABuKm0FI9jruo6MkxfHmZ
	hsf5VaYgxX94zV04t2tRGD6KDc4Fsy8upvaWHK5VMi0nr8NBHiO/P03+mlqnsivScfI3ywrEFYt
	tmsBwJGeqFH3xZkT1h8ZuuMDQG/AWl6Jh27flDH+dwlVDIDpnyDbWw==
X-Google-Smtp-Source: AGHT+IFTBMeJe4wjjtoaON7OuOYX1jtnqozAP2nBEU07iBzqR9DmsR32rxUII8xRcaN91P8qiaEz3g==
X-Received: by 2002:a5d:5f96:0:b0:391:fcc:9ee8 with SMTP id ffacd0b85a97d-3997f912529mr11083564f8f.23.1742827948855;
        Mon, 24 Mar 2025 07:52:28 -0700 (PDT)
Received: from [192.168.1.247] ([145.224.90.136])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9957c3sm11448421f8f.18.2025.03.24.07.52.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Mar 2025 07:52:28 -0700 (PDT)
Message-ID: <8450a182-5c62-4546-ab91-5d39eb252254@linaro.org>
Date: Mon, 24 Mar 2025 14:52:26 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 7/8] perf: arm_pmuv3: Keep out of guest counter
 partition
To: Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20250213180317.3205285-1-coltonlewis@google.com>
 <20250213180317.3205285-8-coltonlewis@google.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20250213180317.3205285-8-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 13/02/2025 6:03 pm, Colton Lewis wrote:
> If the PMU is partitioned, keep the driver out of the guest counter
> partition and only use the host counter partition. Partitioning is
> defined by the MDCR_EL2.HPMN register field and saved in
> cpu_pmu->hpmn. The range 0..HPMN-1 is accessible by EL1 and EL0 while
> HPMN..PMCR.N is reserved for EL2.
> 
> Define some macros that take HPMN as an argument and construct
> mutually exclusive bitmaps for testing which partition a particular
> counter is in. Note that despite their different position in the
> bitmap, the cycle and instruction counters are always in the guest
> partition.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>   arch/arm/include/asm/arm_pmuv3.h |  2 +
>   arch/arm64/include/asm/kvm_pmu.h |  5 +++
>   arch/arm64/kvm/pmu-part.c        | 16 +++++++
>   drivers/perf/arm_pmuv3.c         | 73 +++++++++++++++++++++++++++-----
>   include/linux/perf/arm_pmuv3.h   |  8 ++++
>   5 files changed, 94 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
> index 2ec0e5e83fc9..dadd4ddf51af 100644
> --- a/arch/arm/include/asm/arm_pmuv3.h
> +++ b/arch/arm/include/asm/arm_pmuv3.h
> @@ -227,6 +227,8 @@ static inline bool kvm_set_pmuserenr(u64 val)
>   }
>   
>   static inline void kvm_vcpu_pmu_resync_el0(void) {}
> +static inline void kvm_pmu_host_counters_enable(void) {}
> +static inline void kvm_pmu_host_counters_disable(void) {}
>   
>   /* PMU Version in DFR Register */
>   #define ARMV8_PMU_DFR_VER_NI        0
> diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
> index 174b7f376d95..8f25754fde47 100644
> --- a/arch/arm64/include/asm/kvm_pmu.h
> +++ b/arch/arm64/include/asm/kvm_pmu.h
> @@ -25,6 +25,8 @@ void kvm_host_pmu_init(struct arm_pmu *pmu);
>   u8 kvm_pmu_get_reserved_counters(void);
>   u8 kvm_pmu_hpmn(u8 nr_counters);
>   void kvm_pmu_partition(struct arm_pmu *pmu);
> +void kvm_pmu_host_counters_enable(void);
> +void kvm_pmu_host_counters_disable(void);
>   
>   #else
>   
> @@ -37,6 +39,9 @@ static inline bool kvm_set_pmuserenr(u64 val)
>   static inline void kvm_vcpu_pmu_resync_el0(void) {}
>   static inline void kvm_host_pmu_init(struct arm_pmu *pmu) {}
>   
> +static inline void kvm_pmu_host_counters_enable(void) {}
> +static inline void kvm_pmu_host_counters_disable(void) {}
> +
>   #endif
>   
>   #endif
> diff --git a/arch/arm64/kvm/pmu-part.c b/arch/arm64/kvm/pmu-part.c
> index e74fecc67e37..51da65c678f9 100644
> --- a/arch/arm64/kvm/pmu-part.c
> +++ b/arch/arm64/kvm/pmu-part.c
> @@ -45,3 +45,19 @@ void kvm_pmu_partition(struct arm_pmu *pmu)
>   		pmu->partitioned = false;
>   	}
>   }
> +
> +void kvm_pmu_host_counters_enable(void)
> +{
> +	u64 mdcr = read_sysreg(mdcr_el2);
> +
> +	mdcr |= MDCR_EL2_HPME;
> +	write_sysreg(mdcr, mdcr_el2);
> +}
> +
> +void kvm_pmu_host_counters_disable(void)
> +{
> +	u64 mdcr = read_sysreg(mdcr_el2);
> +
> +	mdcr &= ~MDCR_EL2_HPME;
> +	write_sysreg(mdcr, mdcr_el2);
> +}
> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index 0e360feb3432..442dcff56d5b 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -730,15 +730,19 @@ static void armv8pmu_disable_event_irq(struct perf_event *event)
>   	armv8pmu_disable_intens(BIT(event->hw.idx));
>   }
>   
> -static u64 armv8pmu_getreset_flags(void)
> +static u64 armv8pmu_getreset_flags(struct arm_pmu *cpu_pmu)
>   {
>   	u64 value;
>   
>   	/* Read */
>   	value = read_pmovsclr();
>   
> +	if (cpu_pmu->partitioned)
> +		value &= ARMV8_PMU_HOST_CNT_PART(cpu_pmu->hpmn);
> +	else
> +		value &= ARMV8_PMU_OVERFLOWED_MASK;
> +
>   	/* Write to clear flags */
> -	value &= ARMV8_PMU_OVERFLOWED_MASK;
>   	write_pmovsclr(value);
>   
>   	return value;
> @@ -765,6 +769,18 @@ static void armv8pmu_disable_user_access(void)
>   	update_pmuserenr(0);
>   }
>   
> +static bool armv8pmu_is_guest_part(struct arm_pmu *cpu_pmu, u8 idx)
> +{
> +	return cpu_pmu->partitioned &&
> +		(BIT(idx) & ARMV8_PMU_GUEST_CNT_PART(cpu_pmu->hpmn));
> +}
> +
> +static bool armv8pmu_is_host_part(struct arm_pmu *cpu_pmu, u8 idx)
> +{
> +	return !cpu_pmu->partitioned ||
> +		(BIT(idx) & ARMV8_PMU_HOST_CNT_PART(cpu_pmu->hpmn));
> +}
> +
>   static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
>   {
>   	int i;
> @@ -773,6 +789,8 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
>   	if (is_pmuv3p9(cpu_pmu->pmuver)) {
>   		u64 mask = 0;
>   		for_each_set_bit(i, cpuc->used_mask, ARMPMU_MAX_HWEVENTS) {
> +			if (armv8pmu_is_guest_part(cpu_pmu, i))
> +				continue;

Hi Colton,

Is it possible to keep the guest bits out of used_mask and cntr_mask in 
the first place? Then all these loops don't need to have the logic for 
is_guest_part()/is_host_part().

That leads me to wonder about updating the printout:

  hw perfevents: enabled with armv8_pmuv3_0 PMU driver, 7 (0,8000003f)
    counters available

It might be a bit confusing if that doesn't quite reflect reality anymore.

Thanks
James

