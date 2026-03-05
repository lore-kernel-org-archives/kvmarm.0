Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF7E37EFE8
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 10:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772705802; cv=none; b=VMv5Stm6Xf5w51eN2u2sXjIOhPgYHGkXX6ZP6P0OyoLebSg6FamTsgjB77XQUfBe55ah021OEKJ7CotPtq4Dz1+3GRFFyryqXRCL+sxbMrv8XZ+NZvqywt00h0Jb4waqNleBGjODUkrWrJuO+2WNZDi6hUM2G0Vhseae/6xGdOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772705802; c=relaxed/simple;
	bh=P87hIUV2fu1mRR2HVk5KqWJ4gFQmCz73788pz19G1A0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W6FPqYJF6FVDubztXOMcV9UTOOulvgI2pfCgkk/lUjoaMje9ggan2yjdBiMC/oR1T1Jsmiw8EzWXFn8uSPV3eGZCmm9SN2APy/Ds3tcxfoJmm2hZrBIK9JdE3nMcEz9Gk7YkfJhx2toWdTSbzAHGoiNXxfG1CP/sEIzfmnDCx7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=N2k7K65Y; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N2k7K65Y"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b9419139eb7so14591166b.2
        for <kvmarm@lists.linux.dev>; Thu, 05 Mar 2026 02:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772705797; x=1773310597; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e5rwWGFQhdrZCpbbLr/E+X4NwG6E0LyDnEZBwSFjBRo=;
        b=N2k7K65YgpJbwqDpYl7fiC20gUIdL+oGkh9mCCblchwV1y4WfSaTxVygU+qMLZ8Tl5
         DSA7NUByKWxkLSb46TQvdh/hMd0ZM05w3g76Eioyhz5BLU6cqg+pMNVzByQLcHfDyyNF
         cFEVhEhvXOv+HZTKDs28TG0vLjLhbOXRw1ZDkFHJ9AVAtz0rX6Vxlqydbz7bN34in5cG
         YsiNFi1bGo0YDxFOk+xeN06N17LuMKPKsj6m/5dMJySCqCykFljajmlPx2hlPeTfHxgM
         9qrPyPZjtYIW2t7CHjkum1PeNmXpUEJV99yCTJ+GIOPjINPiDKwncKOA/lXHMQBEA1HJ
         ao4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772705797; x=1773310597;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e5rwWGFQhdrZCpbbLr/E+X4NwG6E0LyDnEZBwSFjBRo=;
        b=OwkpJ0+SHAihoVWY+Ss36euixaNm8B29RbX4Cz/T3pByyzZUyRAxnwVnv9pcgk6yBD
         +a8JqDr6VgqlMRNNCK4xSWbjwT3+UZoYWGxKVT+unYXO8iZvDUMPvE1MmBgrnRvqfVFN
         cl+SXHf/jMluLRmMY57JUpYmeTZtu04K/pkOwXO/mI+sizULdV4X8HukUkp13q7jmWp0
         mGQJAn34nP1npa2wZNWLwyUf9aYWSNbpwtbh6nWxYDPwM4x7DjwanUAnwPnb4AsJVa98
         +1VAAUBvwYMnSkoaNDR+cn4mJLeJY7w4ebYTady93/o5WLRfMCbxbmgizX5Nc3VPpMx4
         9cDg==
X-Forwarded-Encrypted: i=1; AJvYcCX/4hns2Ht9LaDZlFqyxODT4vwQXN3udl3vQ9zG1FO+3Fw2DZsKWmYxUz7Hr2j7GQRcBv4cwu8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMJBYJUlDdEZS0sm2Xm5nY+WLoEaK9p3YwWEXZ0Fuj3CAV0qG3
	kQjnaV69+jiay6iS+4EC8uTopAuIqWml3wyNCwHSoBKr4LNOTJIN5YGVJLh9KRBiwgA=
X-Gm-Gg: ATEYQzyfa0SmD21sVsWP9s/HRbJ3GWYYemmSQjm6bfpmGVyvfKH3t0UQ7rzNsljRCGF
	gQ97By2tYp/BDjfP77KXJz0PUXAVf+ur0KBeh9EudfiDxcLfLBZrdhCYmKEaL9JGtieJ0lbWl1Q
	UAouxHy2PMsnnO5Zv5b0ZrrUJlXzMLnHrN4E5IHCconmal3qFmzrEBHwoxdvxymR/WuESTDIPaQ
	c/2EbUprIrxQ/78ypXqidpnUUH7WELJXlDDntWXjbdrEywgEqADnGUosnsTY4mgj1jhKXWwm0eM
	gZxiRr2lM+W5RcRS6Jhul7PWSER8S81Qd/oN4zQBX3yrFO+kiBl8LdwX4+bE2NnPeYU2Gz82bHV
	KOI3lwEg3XYL+OnSxrNw1yUF5NlRDa3HlTpVNzk2twt3DNzwWyOrC31eKl/8uLB7DOpvOIYREb5
	aIHR2wcUqoc+fyjdgC9mOZvph0Am1L
X-Received: by 2002:a17:907:7b98:b0:b73:544d:b963 with SMTP id a640c23a62f3a-b93f11530ddmr332218266b.13.1772705796619;
        Thu, 05 Mar 2026 02:16:36 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935ac7371esm883072366b.24.2026.03.05.02.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2026 02:16:36 -0800 (PST)
Message-ID: <819fa670-f6f6-4251-a528-6d8264451b9f@linaro.org>
Date: Thu, 5 Mar 2026 10:16:34 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 16/19] KVM: arm64: Add vCPU device attr to partition
 the PMU
To: Colton Lewis <coltonlewis@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>,
 Shuah Khan <shuah@kernel.org>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org
References: <20260209221414.2169465-1-coltonlewis@google.com>
 <20260209221414.2169465-17-coltonlewis@google.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20260209221414.2169465-17-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 09/02/2026 10:14 pm, Colton Lewis wrote:
> Add a new PMU device attr to enable the partitioned PMU for a given
> VM. This capability can be set when the PMU is initially configured
> before the vCPU starts running and is allowed where PMUv3 and VHE are
> supported and the host driver was configured with
> arm_pmuv3.reserved_host_counters.
> 
> The enabled capability is tracked by the new flag
> KVM_ARCH_FLAG_PARTITIONED_PMU_ENABLED.

Typo, should be: KVM_ARCH_FLAG_PARTITION_PMU_ENABLED. Or maybe the 
#define should be fixed.

I couldn't see if this was discussed before, but what's the reason to 
not use the guest partition by default and make this flag control 
reverting back to use the non passed through PMU?

Seems like if you already have to enable it by creating a partition on 
the host, then you more than likely want your guests to use it. And it's 
lower overhead so it's "better". Right now it's two things that you have 
to set at the same time to do one thing.

Or does having to set it on the host go away with the dynamic approach 
here [1]?

[1]: https://lore.kernel.org/kvmarm/aWjlfl85vSd6sMwT@willie-the-truck/

> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>   arch/arm64/include/asm/kvm_host.h |  2 ++
>   arch/arm64/include/uapi/asm/kvm.h |  2 ++
>   arch/arm64/kvm/pmu-direct.c       | 35 ++++++++++++++++++++++++++++---
>   arch/arm64/kvm/pmu.c              | 14 +++++++++++++
>   include/kvm/arm_pmu.h             |  9 ++++++++
>   5 files changed, 59 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 41577ede0254f..f0b0a5edc7252 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -353,6 +353,8 @@ struct kvm_arch {
>   #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
>   	/* Unhandled SEAs are taken to userspace */
>   #define KVM_ARCH_FLAG_EXIT_SEA				11
> +	/* Partitioned PMU Enabled */
> +#define KVM_ARCH_FLAG_PARTITION_PMU_ENABLED		12
>   	unsigned long flags;
>   
>   	/* VM-wide vCPU feature set */
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index a792a599b9d68..3e0b7619f781d 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -436,6 +436,8 @@ enum {
>   #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
>   #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
>   #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
> +#define   KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION	5
> +
>   #define KVM_ARM_VCPU_TIMER_CTRL		1
>   #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
>   #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> index 6ebb59d2aa0e7..1dbf50b8891f6 100644
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c
> @@ -44,8 +44,8 @@ bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
>   }
>   
>   /**
> - * kvm_vcpu_pmu_is_partitioned() - Determine if given VCPU has a partitioned PMU
> - * @vcpu: Pointer to kvm_vcpu struct
> + * kvm_pmu_is_partitioned() - Determine if given VCPU has a partitioned PMU
> + * @kvm: Pointer to kvm_vcpu struct
>    *
>    * Determine if given VCPU has a partitioned PMU by extracting that
>    * field and passing it to :c:func:`kvm_pmu_is_partitioned`
> @@ -55,7 +55,36 @@ bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
>   bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu)
>   {
>   	return kvm_pmu_is_partitioned(vcpu->kvm->arch.arm_pmu) &&
> -		false;
> +		test_bit(KVM_ARCH_FLAG_PARTITION_PMU_ENABLED, &vcpu->kvm->arch.flags);
> +}
> +
> +/**
> + * has_kvm_pmu_partition_support() - If we can enable/disable partition
> + *
> + * Return: true if allowed, false otherwise.
> + */
> +bool has_kvm_pmu_partition_support(void)
> +{
> +	return has_host_pmu_partition_support() &&
> +		kvm_supports_guest_pmuv3() &&
> +		armv8pmu_max_guest_counters > -1;
> +}
> +
> +/**
> + * kvm_pmu_partition_enable() - Enable/disable partition flag
> + * @kvm: Pointer to vcpu
> + * @enable: Whether to enable or disable
> + *
> + * If we want to enable the partition, the guest is free to grab
> + * hardware by accessing PMU registers. Otherwise, the host maintains
> + * control.
> + */
> +void kvm_pmu_partition_enable(struct kvm *kvm, bool enable)
> +{
> +	if (enable)
> +		set_bit(KVM_ARCH_FLAG_PARTITION_PMU_ENABLED, &kvm->arch.flags);
> +	else
> +		clear_bit(KVM_ARCH_FLAG_PARTITION_PMU_ENABLED, &kvm->arch.flags);
>   }
>   
>   /**
> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> index 72d5b7cb3d93e..cdf51f24fdaf3 100644
> --- a/arch/arm64/kvm/pmu.c
> +++ b/arch/arm64/kvm/pmu.c
> @@ -759,6 +759,19 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>   
>   		return kvm_arm_pmu_v3_set_nr_counters(vcpu, n);
>   	}
> +	case KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION: {
> +		unsigned int __user *uaddr = (unsigned int __user *)(long)attr->addr;
> +		bool enable;
> +
> +		if (get_user(enable, uaddr))
> +			return -EFAULT;
> +
> +		if (!has_kvm_pmu_partition_support())
> +			return -EPERM;
> +
> +		kvm_pmu_partition_enable(kvm, enable);
> +		return 0;
> +	}
>   	case KVM_ARM_VCPU_PMU_V3_INIT:
>   		return kvm_arm_pmu_v3_init(vcpu);
>   	}
> @@ -798,6 +811,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>   	case KVM_ARM_VCPU_PMU_V3_FILTER:
>   	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
>   	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
> +	case KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION:
>   		if (kvm_vcpu_has_pmu(vcpu))
>   			return 0;
>   	}
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 93586691a2790..ff898370fa63f 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -109,6 +109,8 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu);
>   void kvm_pmu_put(struct kvm_vcpu *vcpu);
>   
>   void kvm_pmu_set_physical_access(struct kvm_vcpu *vcpu);
> +bool has_kvm_pmu_partition_support(void);
> +void kvm_pmu_partition_enable(struct kvm *kvm, bool enable);
>   
>   #if !defined(__KVM_NVHE_HYPERVISOR__)
>   bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
> @@ -311,6 +313,13 @@ static inline void kvm_pmu_host_counters_enable(void) {}
>   static inline void kvm_pmu_host_counters_disable(void) {}
>   static inline void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u64 pmovsr) {}
>   
> +static inline bool has_kvm_pmu_partition_support(void)
> +{
> +	return false;
> +}
> +
> +static inline void kvm_pmu_partition_enable(struct kvm *kvm, bool enable) {}
> +
>   #endif
>   
>   #endif

