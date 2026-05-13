Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D587D4D8D8D
	for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 16:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778690354; cv=none; b=gnBRn0rIuJapigNm8nY4IvyxFKJESydExokKi0i99cBbxIVY3iA9SDQP6BgVlkBjndNVKHLvTuU/QQpUVmB2zX+BisnLtOCV4zdfHhRhWAuh4TZWmSzv/bZT/sy7KsNAWOxujKAcRjI9hkMgXNu0aywOZIoUI0f41UIyoMyBSpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778690354; c=relaxed/simple;
	bh=61JSb7D+n0/K2dVnQ2T+HaSA+uFZ/UdY5hnYLiMgBy4=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=FjZA7YzR5KgjF/Dz8dznmtnjjVwioXIrtxffMUGe6Z9OAUxfCzgyg5pKPb/zAcI9a60SpQDwHMUHZiphh7+WnEg+7qnXv2tTkfrW//TUS5t2QfxCsWxgNrME740KiUAFUFVDjivU6M6Ht6PTchrFqrPbIjzuJLpptFtFjY4wWnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mimC9eav; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mimC9eav"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-6961e8fa90bso13346859eaf.0
        for <kvmarm@lists.linux.dev>; Wed, 13 May 2026 09:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778690351; x=1779295151; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vOSSQNbTKfOf2TGLzCUkqwpB1cEjCNpCYDqaTZDjYhU=;
        b=mimC9eavau45wU3Si04J3pu+JY/1stqiz3+BKmjVUQsCBiHO1WF7iAJkpsveMNJ8Ta
         gts+1apxIo9/9DPDc6lqOK4AEG36lEOlg9tKU6CtGlEnxedr5ChnO9SS4bJrJ1WNzKkK
         fvKTkhnfx+/IOmw3QSzwLFO+q4PJWBjKvNW300kbzJUt9ix40rHz0v5cyzlzlWQ8GFFl
         voYT1lYP0NkYwwe+B+AlFQHEwsIt8VHV4B5wSGdA7WJI7Z3c1klSPCewF7/qDZ+j2Hy2
         rKofIMCBdS0bg4UCCO9ZD+X2dQk7APtZxgA09QJUC3ajzPfBMa03IJD2Yg7EUahJDY2K
         mGmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778690351; x=1779295151;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vOSSQNbTKfOf2TGLzCUkqwpB1cEjCNpCYDqaTZDjYhU=;
        b=W3Wu0kl6MaOpVvjA/9ko9z8SKESvMXBrGGgX1Uy21ARqrYONIQ8UZgzV7m5TCuLkXz
         biZQenQAbrWn1sktk2FfArhjsSH5+JJLf60chUw5G8ncF1pYS6P53qMhpeLlGb8yb42u
         TTrYi+VegtU/B8URNnzn9Kxat/Se52+03SGzSPCDH5FO7fW3/KY3mCfT2PqTCO3CChu8
         X50soUB3fNQeT7IbfhFD7pVGu9MKo1j5q9qVADa+7Nb+he6peGJ4EAV7Uz5YKuEL+roq
         DB5sKxQ8w8p9vq6xvE5Bjy0ms8X9FqhAsQL6PGW+E0nm91d/694kEntnZrsoQ6H4CXAL
         TZjQ==
X-Forwarded-Encrypted: i=1; AFNElJ/UDD8cfPme3muDQ/5YQ5kxpeB2hRO1pes5sfazfUHOZ6fbE7pHLXeOGG2X2UlhkL0jLHCDMxQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZ8YzbjXAg86oehtOHIpZbf7r0cF+SON4ERUBgM1zNuI0xyCBw
	yh/sPE7bTLSzQKgAe9aPYPiuGGgLtpVnylsPzkSd03atx+fmJ13L0tA5VNsN6sR9SlxabdY7RYc
	GG1MTE1vfUMTrqyAgXk3VPKterg==
X-Received: from jatn7.prod.google.com ([2002:a05:6638:2647:b0:5d1:d9e5:ccbd])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:4c02:b0:69b:56e5:cd6b with SMTP id 006d021491bc7-69b7a9d2905mr1848851eaf.11.1778690350606;
 Wed, 13 May 2026 09:39:10 -0700 (PDT)
Date: Wed, 13 May 2026 16:38:46 +0000
In-Reply-To: <ad02327b-01b6-4ed9-b9bb-e2c6ed4b2890@linaro.org> (message from
 James Clark on Mon, 11 May 2026 15:49:37 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt33zvclih.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v7 10/20] KVM: arm64: Context swap Partitioned PMU guest registers
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

James Clark <james.clark@linaro.org> writes:

> On 04/05/2026 10:18 pm, Colton Lewis wrote:
>> Save and restore newly untrapped registers that can be directly
>> accessed by the guest when the PMU is partitioned.

>> * PMEVCNTRn_EL0
>> * PMCCNTR_EL0
>> * PMSELR_EL0
>> * PMCR_EL0
>> * PMCNTEN_EL0
>> * PMINTEN_EL1

>> If we know we are not partitioned (that is, using the emulated vPMU),
>> then return immediately. A later patch will make this lazy so the
>> context swaps don't happen unless the guest has accessed the PMU.

>> PMEVTYPER is handled in a following patch since we must apply the KVM
>> event filter before writing values to hardware.

>> PMOVS guest counters are cleared to avoid the possibility of
>> generating spurious interrupts when PMINTEN is written. This is fine
>> because the virtual register for PMOVS is always the canonical value.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>    arch/arm/include/asm/arm_pmuv3.h |   4 +
>>    arch/arm64/kvm/arm.c             |   2 +
>>    arch/arm64/kvm/pmu-direct.c      | 169 +++++++++++++++++++++++++++++++
>>    include/kvm/arm_pmu.h            |  16 +++
>>    4 files changed, 191 insertions(+)

>> diff --git a/arch/arm/include/asm/arm_pmuv3.h  
>> b/arch/arm/include/asm/arm_pmuv3.h
>> index 42d62aa48d0a6..eebc89bdab7a1 100644
>> --- a/arch/arm/include/asm/arm_pmuv3.h
>> +++ b/arch/arm/include/asm/arm_pmuv3.h
>> @@ -235,6 +235,10 @@ static inline bool kvm_pmu_is_partitioned(struct  
>> arm_pmu *pmu)
>>    {
>>    	return false;
>>    }
>> +static inline u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu)
>> +{
>> +	return ~0;
>> +}

>>    /* PMU Version in DFR Register */
>>    #define ARMV8_PMU_DFR_VER_NI        0
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 410ffd41fd73a..a942f2bc13fc4 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -680,6 +680,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int  
>> cpu)
>>    		kvm_vcpu_load_vhe(vcpu);
>>    	kvm_arch_vcpu_load_fp(vcpu);
>>    	kvm_vcpu_pmu_restore_guest(vcpu);
>> +	kvm_pmu_load(vcpu);
>>    	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
>>    		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);

>> @@ -721,6 +722,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>    	kvm_timer_vcpu_put(vcpu);
>>    	kvm_vgic_put(vcpu);
>>    	kvm_vcpu_pmu_restore_host(vcpu);
>> +	kvm_pmu_put(vcpu);
>>    	if (vcpu_has_nv(vcpu))
>>    		kvm_vcpu_put_hw_mmu(vcpu);
>>    	kvm_arm_vmid_clear_active();
>> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
>> index 63ac72910e4b5..360d022d918d5 100644
>> --- a/arch/arm64/kvm/pmu-direct.c
>> +++ b/arch/arm64/kvm/pmu-direct.c
>> @@ -9,6 +9,7 @@
>>    #include <linux/perf/arm_pmuv3.h>

>>    #include <asm/arm_pmuv3.h>
>> +#include <asm/kvm_emulate.h>

>>    /**
>>     * has_host_pmu_partition_support() - Determine if partitioning is  
>> possible
>> @@ -98,3 +99,171 @@ u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)

>>    	return *host_data_ptr(nr_event_counters);
>>    }
>> +
>> +/**
>> + * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved  
>> counters
>> + * @pmu: Pointer to arm_pmu struct
>> + *
>> + * Compute the bitmask that selects the host-reserved counters in the
>> + * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers. These are the counters
>> + * in HPMN..N
>> + *
>> + * Return: Bitmask
>> + */
>> +u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu)
>> +{
>> +	u8 nr_counters = *host_data_ptr(nr_event_counters);
>> +
>> +	if (kvm_pmu_is_partitioned(pmu))
>> +		return GENMASK(nr_counters - 1, pmu->max_guest_counters);
>> +
>> +	return ARMV8_PMU_CNT_MASK_ALL;
>> +}
>> +
>> +/**
>> + * kvm_pmu_guest_counter_mask() - Compute bitmask of guest-reserved  
>> counters
>> + * @pmu: Pointer to arm_pmu struct
>> + *
>> + * Compute the bitmask that selects the guest-reserved counters in the
>> + * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers. These are the counters
>> + * in 0..HPMN and the cycle and instruction counters.
>> + *
>> + * Return: Bitmask
>> + */
>> +u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
>> +{
>> +	if (kvm_pmu_is_partitioned(pmu))
>> +		return ARMV8_PMU_CNT_MASK_C | GENMASK(pmu->max_guest_counters - 1, 0);
>> +
>> +	return 0;
>> +}

> Minor nit: slightly inconsistent use of types. Returns a u64 but doesn't
> use GENMASK_ULL and is also usually saved into a long when it's called.

Will fix
