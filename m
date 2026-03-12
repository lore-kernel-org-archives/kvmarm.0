Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A196038AC7B
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 22:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773353624; cv=none; b=jDokhjo5yw6IGGslu0Cqp08Txkuny9Y4kAoZB4B8RILMLaUybIrAx3sfL40kTOAG5+4zoktSiH6gkoLcwZjggzdIHiEQpuu6waEn3Zm7j17U+AysSEDsZW6ZTWe1WID/HSfhOk77kJ+kL2mpwwBjXeDcuOotxKImn4nygAh4IOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773353624; c=relaxed/simple;
	bh=NnNqngGYzOf/+4ZNbTSqtLeCtlFOkgKZlcgLwZ5WeeU=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=H7vQrFH1TU04f9iiAdBvUcU45QS2N7ds/nRcisdJAgp20Z3Q0szM2UM54gIHzlGRcqr6Z9vceiZn71SS7mWNX68wUI98UldBgQ4Qn7N4qqCcSLy/T6PxtYeIztiyEAhpV5UpToV6tDBQzQOn+s1C54pS0m7GKHOCI2IrIaaz/LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fJ2c9Gbi; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fJ2c9Gbi"
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-4170823763cso12563235fac.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 15:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773353622; x=1773958422; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OmFUz1YB2HW5cy4NJX5lfbdXHnPjDlIYv+BsMbwLiSY=;
        b=fJ2c9Gbig5tbcTrFlXxOUTktCFg4s2jjPp3Z+SY77jc2lttlyOPunRI9B/c1we9dVT
         P6ViTh9cSB82V+cOLel3Y8WqQyigYfAwyrwjJBkKRb+TQCcEAY6pjyoHj4+vqmhTJ4jO
         oRnDsGcBYZT0EG7uKhPup5y8pJ33Y9hlg/b64oDQgpaWgTxDkonFRGymMPf3Dl6ZrYA4
         hGofKekCt9kKcCOh2hq7xPDn7nqDw288W0V7CzrrQOMzPx1Cs4H4bSfX+ELSRcq1XpmZ
         qltaCDqDyLNbWetkyBtaDSwEJ8itXVblba5Jv0jPWbGWkzQ/kmyQ17eEVWadjCmetd7i
         Ht2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773353622; x=1773958422;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OmFUz1YB2HW5cy4NJX5lfbdXHnPjDlIYv+BsMbwLiSY=;
        b=PKqPfhzCARlT7rzAGYJFY/wd2ep37TsMY3Ez3ziaosxouXBrT+LtDUyKBTQ+svIfCK
         dAHT00IEmDCyW77OA1BKjhoIneu8ETGZFaXSrM3biNZrh49HFn64KAA+FW0uLGmruaR2
         YgpNJPXYtXDkZmDhlKZINK6ubfR8oweCp2Wg7ok46Gd5y2fwFDNp5mqM6TCC0zXCri+B
         KWKYWrbLZAsWPmeEQjYI1lUxec9i6XZ7ver5JGDHD44ZzAEjU88928jpi82JcYqncJP7
         nivtenDfJ8hsygq0q0r8+l3nWDIsHnjbNZ0J2ECp+g0LpEvv9Q6tccOpsOpXuVfr69Rc
         RqHg==
X-Forwarded-Encrypted: i=1; AJvYcCXYF0t4prpEGGf2prymU6xIC6QbMQaSsFkbpjR1MYl+EsRtBwRfpUvmUCmABHJgi0iIvjywaNY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRTjaGuUvAR6mGxwFuftIvqDSUWt5HrByKT3jsWwOX0vfNRQzf
	BRsguZWWJ7SkedFd5ZFrij2wpDzLYoHfPe6sN8I6W4+QeoGNYM8ZFkSYFfbKCHDws3GgRdzuRYy
	0Y9SqmGtSW/oS5JQva6QJedRPqw==
X-Received: from oacsd12.prod.google.com ([2002:a05:6871:5e8c:b0:417:8286:3260])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6871:d211:b0:409:bd2b:91a3 with SMTP id 586e51a60fabf-417b939f2d9mr605460fac.32.1773353621508;
 Thu, 12 Mar 2026 15:13:41 -0700 (PDT)
Date: Thu, 12 Mar 2026 22:13:40 +0000
In-Reply-To: <819fa670-f6f6-4251-a528-6d8264451b9f@linaro.org> (message from
 James Clark on Thu, 5 Mar 2026 10:16:34 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntms0cofvv.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v6 16/19] KVM: arm64: Add vCPU device attr to partition
 the PMU
From: Colton Lewis <coltonlewis@google.com>
To: James Clark <james.clark@linaro.org>
Cc: alexandru.elisei@arm.com, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Thanks James for the review.

James Clark <james.clark@linaro.org> writes:

> On 09/02/2026 10:14 pm, Colton Lewis wrote:
>> Add a new PMU device attr to enable the partitioned PMU for a given
>> VM. This capability can be set when the PMU is initially configured
>> before the vCPU starts running and is allowed where PMUv3 and VHE are
>> supported and the host driver was configured with
>> arm_pmuv3.reserved_host_counters.

>> The enabled capability is tracked by the new flag
>> KVM_ARCH_FLAG_PARTITIONED_PMU_ENABLED.

> Typo, should be: KVM_ARCH_FLAG_PARTITION_PMU_ENABLED. Or maybe the
> #define should be fixed.

Stale commit message. I will fix.


> I couldn't see if this was discussed before, but what's the reason to
> not use the guest partition by default and make this flag control
> reverting back to use the non passed through PMU?

> Seems like if you already have to enable it by creating a partition on
> the host, then you more than likely want your guests to use it. And it's
> lower overhead so it's "better". Right now it's two things that you have
> to set at the same time to do one thing.

> Or does having to set it on the host go away with the dynamic approach
> here [1]?

Yes, the plan is to have it go away on the host with a dynamic approach.


> [1]: https://lore.kernel.org/kvmarm/aWjlfl85vSd6sMwT@willie-the-truck/


>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>    arch/arm64/include/asm/kvm_host.h |  2 ++
>>    arch/arm64/include/uapi/asm/kvm.h |  2 ++
>>    arch/arm64/kvm/pmu-direct.c       | 35 ++++++++++++++++++++++++++++---
>>    arch/arm64/kvm/pmu.c              | 14 +++++++++++++
>>    include/kvm/arm_pmu.h             |  9 ++++++++
>>    5 files changed, 59 insertions(+), 3 deletions(-)

>> diff --git a/arch/arm64/include/asm/kvm_host.h  
>> b/arch/arm64/include/asm/kvm_host.h
>> index 41577ede0254f..f0b0a5edc7252 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -353,6 +353,8 @@ struct kvm_arch {
>>    #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
>>    	/* Unhandled SEAs are taken to userspace */
>>    #define KVM_ARCH_FLAG_EXIT_SEA				11
>> +	/* Partitioned PMU Enabled */
>> +#define KVM_ARCH_FLAG_PARTITION_PMU_ENABLED		12
>>    	unsigned long flags;

>>    	/* VM-wide vCPU feature set */
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h  
>> b/arch/arm64/include/uapi/asm/kvm.h
>> index a792a599b9d68..3e0b7619f781d 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -436,6 +436,8 @@ enum {
>>    #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
>>    #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
>>    #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
>> +#define   KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION	5
>> +
>>    #define KVM_ARM_VCPU_TIMER_CTRL		1
>>    #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
>>    #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
>> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
>> index 6ebb59d2aa0e7..1dbf50b8891f6 100644
>> --- a/arch/arm64/kvm/pmu-direct.c
>> +++ b/arch/arm64/kvm/pmu-direct.c
>> @@ -44,8 +44,8 @@ bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
>>    }

>>    /**
>> - * kvm_vcpu_pmu_is_partitioned() - Determine if given VCPU has a  
>> partitioned PMU
>> - * @vcpu: Pointer to kvm_vcpu struct
>> + * kvm_pmu_is_partitioned() - Determine if given VCPU has a partitioned  
>> PMU
>> + * @kvm: Pointer to kvm_vcpu struct
>>     *
>>     * Determine if given VCPU has a partitioned PMU by extracting that
>>     * field and passing it to :c:func:`kvm_pmu_is_partitioned`
>> @@ -55,7 +55,36 @@ bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
>>    bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu)
>>    {
>>    	return kvm_pmu_is_partitioned(vcpu->kvm->arch.arm_pmu) &&
>> -		false;
>> +		test_bit(KVM_ARCH_FLAG_PARTITION_PMU_ENABLED, &vcpu->kvm->arch.flags);
>> +}
>> +
>> +/**
>> + * has_kvm_pmu_partition_support() - If we can enable/disable partition
>> + *
>> + * Return: true if allowed, false otherwise.
>> + */
>> +bool has_kvm_pmu_partition_support(void)
>> +{
>> +	return has_host_pmu_partition_support() &&
>> +		kvm_supports_guest_pmuv3() &&
>> +		armv8pmu_max_guest_counters > -1;
>> +}
>> +
>> +/**
>> + * kvm_pmu_partition_enable() - Enable/disable partition flag
>> + * @kvm: Pointer to vcpu
>> + * @enable: Whether to enable or disable
>> + *
>> + * If we want to enable the partition, the guest is free to grab
>> + * hardware by accessing PMU registers. Otherwise, the host maintains
>> + * control.
>> + */
>> +void kvm_pmu_partition_enable(struct kvm *kvm, bool enable)
>> +{
>> +	if (enable)
>> +		set_bit(KVM_ARCH_FLAG_PARTITION_PMU_ENABLED, &kvm->arch.flags);
>> +	else
>> +		clear_bit(KVM_ARCH_FLAG_PARTITION_PMU_ENABLED, &kvm->arch.flags);
>>    }

>>    /**
>> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
>> index 72d5b7cb3d93e..cdf51f24fdaf3 100644
>> --- a/arch/arm64/kvm/pmu.c
>> +++ b/arch/arm64/kvm/pmu.c
>> @@ -759,6 +759,19 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu,  
>> struct kvm_device_attr *attr)

>>    		return kvm_arm_pmu_v3_set_nr_counters(vcpu, n);
>>    	}
>> +	case KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION: {
>> +		unsigned int __user *uaddr = (unsigned int __user *)(long)attr->addr;
>> +		bool enable;
>> +
>> +		if (get_user(enable, uaddr))
>> +			return -EFAULT;
>> +
>> +		if (!has_kvm_pmu_partition_support())
>> +			return -EPERM;
>> +
>> +		kvm_pmu_partition_enable(kvm, enable);
>> +		return 0;
>> +	}
>>    	case KVM_ARM_VCPU_PMU_V3_INIT:
>>    		return kvm_arm_pmu_v3_init(vcpu);
>>    	}
>> @@ -798,6 +811,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu,  
>> struct kvm_device_attr *attr)
>>    	case KVM_ARM_VCPU_PMU_V3_FILTER:
>>    	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
>>    	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
>> +	case KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION:
>>    		if (kvm_vcpu_has_pmu(vcpu))
>>    			return 0;
>>    	}
>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> index 93586691a2790..ff898370fa63f 100644
>> --- a/include/kvm/arm_pmu.h
>> +++ b/include/kvm/arm_pmu.h
>> @@ -109,6 +109,8 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu);
>>    void kvm_pmu_put(struct kvm_vcpu *vcpu);

>>    void kvm_pmu_set_physical_access(struct kvm_vcpu *vcpu);
>> +bool has_kvm_pmu_partition_support(void);
>> +void kvm_pmu_partition_enable(struct kvm *kvm, bool enable);

>>    #if !defined(__KVM_NVHE_HYPERVISOR__)
>>    bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
>> @@ -311,6 +313,13 @@ static inline void  
>> kvm_pmu_host_counters_enable(void) {}
>>    static inline void kvm_pmu_host_counters_disable(void) {}
>>    static inline void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u64  
>> pmovsr) {}

>> +static inline bool has_kvm_pmu_partition_support(void)
>> +{
>> +	return false;
>> +}
>> +
>> +static inline void kvm_pmu_partition_enable(struct kvm *kvm, bool  
>> enable) {}
>> +
>>    #endif

>>    #endif
