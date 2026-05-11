Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3753FB7F6
	for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 14:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778510983; cv=none; b=dC4at+eDvaPhcsVs1EoPOvc7gg3aazJRvjebi68eqlXP7IPSmbbsiCr+aRGWh1ATn4FPdlAD7WsgalmWsPOxEUZIogAzg5y9S/YSM1oNT0rIPOL1k9R8aC7N6s5WZBeG2YwB9KXziIelKK9RGKI+xkIhjFDjkQ38vTt+AxAarfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778510983; c=relaxed/simple;
	bh=gMZcBmHoLH5063KYF9NKsy9Tpdrk0FyoPinO83KeiGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cfK1ZkzaoSnP/weDNGbORhKnak6gh6wtf7zx8B9nYSWUPEig146svAOMVlkN171sKWkU8MV91wu3ToYjtIzokOhZA8JEkadSRVJh7pQL/t0yyJN7FGdBv63U3EnMZ2z4mKDZWYuMN5seTXc2LPp8mUEyA8W0daTLAU+Im7hCLiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=j69QhZP6; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j69QhZP6"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488ad135063so35867015e9.0
        for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 07:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1778510979; x=1779115779; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6uflrulgEFIn9x44XDb2ne6l2kjOQ5bKLrwMyk01QUg=;
        b=j69QhZP6MUgHwLm4/kgBp/iA33xg//RV2seVHCHs07ub5Epq/LpG825waysY27H6Cj
         kUVmZoKjvvNqMApMufAAR10cjskgfBGsoyYdq7hm13ys5ViVix9NjZdmxImDeJ5D6YGB
         RGdYZoV33ugsJLviLpaderdsxn7vHKfQ8i1Db1iHAd/OE0Zagj8ilmQ0xzxcol4Mg+mU
         eDdCb9PZbnlnYtkJZm7apNiOxBGDYBKeZsxyaqG2nNZMJUlATmRwh0XBqHym/FbKyZUC
         +7xwyLGpIxOKIqXbSuy+b+N7ipLwvRlAr/H86YbRbCLzSnhibzNSJaFBqULjYz0fN8nV
         yHOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778510979; x=1779115779;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6uflrulgEFIn9x44XDb2ne6l2kjOQ5bKLrwMyk01QUg=;
        b=pVi3ZO/4Ah8PVjfrF5A7Tqq3AvpTu43BqlkwQfO/aDbPJWJEA6CIYkZw8Yzt3H3z3a
         9SVjyG8LdooLD4SDhDVSceQ/1QWMm6DXcFSJzjVhJfFZsDRjBLOtHa1MwQe/jIGOQdQ/
         AgVkFwANIrx0cGejcmmq8gQTZ4mVm+I+v/yF1U0nfC5Y6RzE4RsO/8Y0GeiNlMnfHroz
         4dd5LPYp16Sefokuta+zkQwVDNc7o3ZbHhX1pQEJCxgA9BPfC5Ssj0eSVCL1j2qxfPij
         o7OOYjPDhgN3S4OBDMogXpgOZx12CxUuGZtV/G6cH4ftVtPv66moSPteoE2EF9bCN1sn
         EZjQ==
X-Forwarded-Encrypted: i=1; AFNElJ9bKg43kZAzehni7fXJm1CgTH6y7hDgS/sPEcW/6RZNHeKGMnyV0WjWCqv2lY3fz/67/dqZhHY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0ByiyRye5Cy2BVjbusEqNd9c6nZ3pVsXvzR3NaQv5AieAk4Xv
	Gm3VRw0bUVSFYV7XeRobua3xxJT1jxN1zHOVOFPqWH0DQzHp8NQDof/ZeYZ28F2ChIs=
X-Gm-Gg: Acq92OFfUq5YCFQUwagpKs2hkzfej8SurHCBSzk166tGOUnuGSxm+xXHNGIQID3zapr
	xrqVeBfGs5zLMuRrL4J2e4qs4IpjAz0pRjvWEXsOgaBgwx4fAwzgFGr5WaMgKzT8LltxJOgtc/4
	S23S52NCvvonWT3Em2BIfGaeS6h222zEYDattA0+HLoxpq1yiYGiUlhv8LA98qhYTKAd9Z82oA8
	xnUwdjaSgrwhX863vHiM6l9WZwoRr2vtyV26yqhCFbnLOdklu5+zAMd2Xe+qqVZhuxK1oYcGlRR
	dpOqkLz3cwb5S4kPMfA65XeeJsZdYAvJYL/+Y5LQSP/Xcy7ev0e8UB16ngWsbkDYlivWeTkhjWG
	MsmLQbO3IWp2lIcfePmMZk282hr9xqKHhxDjQdA0j/31Wq9Jyo8OCP3xtg4OwEuZYBCXLJC5xzW
	2qjfVyXXyICGFdlzCHouKmmq9O1iKOJtUvwIH+/SlPEbooDiMjGA==
X-Received: by 2002:a05:600c:33a9:b0:487:2439:b7c8 with SMTP id 5b1f17b1804b1-48e51e0bb9amr250632005e9.1.1778510979404;
        Mon, 11 May 2026 07:49:39 -0700 (PDT)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e702e5516sm293146665e9.7.2026.05.11.07.49.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2026 07:49:38 -0700 (PDT)
Message-ID: <ad02327b-01b6-4ed9-b9bb-e2c6ed4b2890@linaro.org>
Date: Mon, 11 May 2026 15:49:37 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/20] KVM: arm64: Context swap Partitioned PMU guest
 registers
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
References: <20260504211813.1804997-1-coltonlewis@google.com>
 <20260504211813.1804997-11-coltonlewis@google.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20260504211813.1804997-11-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 04/05/2026 10:18 pm, Colton Lewis wrote:
> Save and restore newly untrapped registers that can be directly
> accessed by the guest when the PMU is partitioned.
> 
> * PMEVCNTRn_EL0
> * PMCCNTR_EL0
> * PMSELR_EL0
> * PMCR_EL0
> * PMCNTEN_EL0
> * PMINTEN_EL1
> 
> If we know we are not partitioned (that is, using the emulated vPMU),
> then return immediately. A later patch will make this lazy so the
> context swaps don't happen unless the guest has accessed the PMU.
> 
> PMEVTYPER is handled in a following patch since we must apply the KVM
> event filter before writing values to hardware.
> 
> PMOVS guest counters are cleared to avoid the possibility of
> generating spurious interrupts when PMINTEN is written. This is fine
> because the virtual register for PMOVS is always the canonical value.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>   arch/arm/include/asm/arm_pmuv3.h |   4 +
>   arch/arm64/kvm/arm.c             |   2 +
>   arch/arm64/kvm/pmu-direct.c      | 169 +++++++++++++++++++++++++++++++
>   include/kvm/arm_pmu.h            |  16 +++
>   4 files changed, 191 insertions(+)
> 
> diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
> index 42d62aa48d0a6..eebc89bdab7a1 100644
> --- a/arch/arm/include/asm/arm_pmuv3.h
> +++ b/arch/arm/include/asm/arm_pmuv3.h
> @@ -235,6 +235,10 @@ static inline bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
>   {
>   	return false;
>   }
> +static inline u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu)
> +{
> +	return ~0;
> +}
>   
>   /* PMU Version in DFR Register */
>   #define ARMV8_PMU_DFR_VER_NI        0
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 410ffd41fd73a..a942f2bc13fc4 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -680,6 +680,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   		kvm_vcpu_load_vhe(vcpu);
>   	kvm_arch_vcpu_load_fp(vcpu);
>   	kvm_vcpu_pmu_restore_guest(vcpu);
> +	kvm_pmu_load(vcpu);
>   	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
>   		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
>   
> @@ -721,6 +722,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   	kvm_timer_vcpu_put(vcpu);
>   	kvm_vgic_put(vcpu);
>   	kvm_vcpu_pmu_restore_host(vcpu);
> +	kvm_pmu_put(vcpu);
>   	if (vcpu_has_nv(vcpu))
>   		kvm_vcpu_put_hw_mmu(vcpu);
>   	kvm_arm_vmid_clear_active();
> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> index 63ac72910e4b5..360d022d918d5 100644
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c
> @@ -9,6 +9,7 @@
>   #include <linux/perf/arm_pmuv3.h>
>   
>   #include <asm/arm_pmuv3.h>
> +#include <asm/kvm_emulate.h>
>   
>   /**
>    * has_host_pmu_partition_support() - Determine if partitioning is possible
> @@ -98,3 +99,171 @@ u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
>   
>   	return *host_data_ptr(nr_event_counters);
>   }
> +
> +/**
> + * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved counters
> + * @pmu: Pointer to arm_pmu struct
> + *
> + * Compute the bitmask that selects the host-reserved counters in the
> + * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers. These are the counters
> + * in HPMN..N
> + *
> + * Return: Bitmask
> + */
> +u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu)
> +{
> +	u8 nr_counters = *host_data_ptr(nr_event_counters);
> +
> +	if (kvm_pmu_is_partitioned(pmu))
> +		return GENMASK(nr_counters - 1, pmu->max_guest_counters);
> +
> +	return ARMV8_PMU_CNT_MASK_ALL;
> +}
> +
> +/**
> + * kvm_pmu_guest_counter_mask() - Compute bitmask of guest-reserved counters
> + * @pmu: Pointer to arm_pmu struct
> + *
> + * Compute the bitmask that selects the guest-reserved counters in the
> + * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers. These are the counters
> + * in 0..HPMN and the cycle and instruction counters.
> + *
> + * Return: Bitmask
> + */
> +u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
> +{
> +	if (kvm_pmu_is_partitioned(pmu))
> +		return ARMV8_PMU_CNT_MASK_C | GENMASK(pmu->max_guest_counters - 1, 0);
> +
> +	return 0;
> +}

Minor nit: slightly inconsistent use of types. Returns a u64 but doesn't 
use GENMASK_ULL and is also usually saved into a long when it's called.

