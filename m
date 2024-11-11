Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E0D25777
	for <kvmarm@lists.linux.dev>; Mon, 11 Nov 2024 15:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731340701; cv=none; b=JPx0hAdS+oBd52UfdhsU2yB+4AcD+lHxCw4f+80qYfks9qy0ZDPyRzlQUc2+vVNWFU8PsXIOWij6YvVyx0Kio8+s7obQImMoS1yTEntkQe0lQieUqbXyZKDGpXxiHU6M4A4zut0wGq3lT5K5C3XspThADLBs/C/cJjGzKFqKGYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731340701; c=relaxed/simple;
	bh=0sphRx5Ps8yfDU0yMbsGpUkaZxlroZ618ELGs/t57hk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Eo8XEnruYYC4dXQb0Dan6G9IovqyIoeS4zhD3lad6t1r2sek2HOF0L4REAZ28Oww0YOOsjL+uD3KdkAGjOVMTpuNwmojO78I3LptRBnhoCoWBTjPKLfcquRqq6qU7UJhM+N0AJFeEyOsEsDaV5BRAGzLxfv0njsB9lXru1Cc/eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83BB01474;
	Mon, 11 Nov 2024 07:58:46 -0800 (PST)
Received: from [10.57.79.116] (unknown [10.57.79.116])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8196D3F6A8;
	Mon, 11 Nov 2024 07:58:14 -0800 (PST)
Message-ID: <80c6cafa-dc17-4a47-8fae-9eea03e69f15@arm.com>
Date: Mon, 11 Nov 2024 15:58:13 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/15] KVM: arm64: Track presence of SPE/TRBE in
 kvm_host_data instead of vCPU
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Mingwei Zhang <mizhang@google.com>,
 Colton Lewis <coltonlewis@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 James Clark <james.clark@linaro.org>, james.clark2@arm.com
References: <20241108222418.1677420-1-oliver.upton@linux.dev>
 <20241108222418.1677420-4-oliver.upton@linux.dev>
 <fac9f76d-d7e4-4a1a-844a-85c64af581b6@arm.com>
In-Reply-To: <fac9f76d-d7e4-4a1a-844a-85c64af581b6@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/11/2024 13:47, Suzuki K Poulose wrote:
> Cc: James Clark
> 
> Hi Oliver
> 
> On 08/11/2024 22:24, Oliver Upton wrote:
>> Add flags to kvm_host_data to track if SPE/TRBE is present +
>> programmable on a per-CPU basis. Set the flags up at init rather than
>> vcpu_load() as the programmability of these buffers is unlikely to
>> change.
>>
> 
> Heads up, there is a similar change from James Clark here :
> 
> https://lkml.kernel.org/r/20241101155412.1152709-6-james.clark2@arm.com

Ah, bad. That patch isn't on the public list yet. Never mind ;-). I will 
leave James to deal with this series ;-).

For context, James is trying to enable Guest filtering for CoreSight 
trace, v6 of that one is available here :

https://lkml.kernel.org/r/20240226113044.228403-1-james.clark@arm.com

Suzuki


> 
> This change as such looks good to me.
> 
> Suzuki
> 
>> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>> ---
>>   arch/arm64/include/asm/kvm_host.h  | 18 ++++++++-------
>>   arch/arm64/kvm/arm.c               |  3 ---
>>   arch/arm64/kvm/debug.c             | 36 ++++++++----------------------
>>   arch/arm64/kvm/hyp/nvhe/debug-sr.c |  8 +++----
>>   4 files changed, 23 insertions(+), 42 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/ 
>> asm/kvm_host.h
>> index ad514434f3fe..07da4129f1d1 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -610,6 +610,10 @@ struct cpu_sve_state {
>>    * field.
>>    */
>>   struct kvm_host_data {
>> +#define KVM_HOST_DATA_FLAG_HAS_SPE    0
>> +#define KVM_HOST_DATA_FLAG_HAS_TRBE    1
>> +    unsigned long flags;
>> +
>>       struct kvm_cpu_context host_ctxt;
>>       /*
>> @@ -911,10 +915,6 @@ struct kvm_vcpu_arch {
>>   #define EXCEPT_AA64_EL2_SERR    __vcpu_except_flags(7)
>>   /* Guest debug is live */
>>   #define DEBUG_DIRTY        __vcpu_single_flag(iflags, BIT(4))
>> -/* Save SPE context if active  */
>> -#define DEBUG_STATE_SAVE_SPE    __vcpu_single_flag(iflags, BIT(5))
>> -/* Save TRBE context if active  */
>> -#define DEBUG_STATE_SAVE_TRBE    __vcpu_single_flag(iflags, BIT(6))
>>   /* SVE enabled for host EL0 */
>>   #define HOST_SVE_ENABLED    __vcpu_single_flag(sflags, BIT(0))
>> @@ -1310,6 +1310,12 @@ DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, 
>> kvm_host_data);
>>        &this_cpu_ptr_hyp_sym(kvm_host_data)->f)
>>   #endif
>> +#define host_data_test_flag(flag)                    \
>> +    (test_bit(KVM_HOST_DATA_FLAG_##flag, host_data_ptr(flags)))
>> +#define host_data_set_flag(flag)                    \
>> +    (set_bit(KVM_HOST_DATA_FLAG_##flag, host_data_ptr(flags)))
>> +
>> +
>>   /* Check whether the FP regs are owned by the guest */
>>   static inline bool guest_owns_fp_regs(void)
>>   {
>> @@ -1370,10 +1376,6 @@ static inline bool 
>> kvm_pmu_counter_deferred(struct perf_event_attr *attr)
>>       return (!has_vhe() && attr->exclude_host);
>>   }
>> -/* Flags for host debug state */
>> -void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu);
>> -void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
>> -
>>   #ifdef CONFIG_KVM
>>   void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
>>   void kvm_clr_pmu_events(u64 clr);
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index ab1bf9ccf385..3822774840e1 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -617,15 +617,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, 
>> int cpu)
>>       vcpu_set_pauth_traps(vcpu);
>> -    kvm_arch_vcpu_load_debug_state_flags(vcpu);
>> -
>>       if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
>>           vcpu_set_on_unsupported_cpu(vcpu);
>>   }
>>   void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>   {
>> -    kvm_arch_vcpu_put_debug_state_flags(vcpu);
>>       kvm_arch_vcpu_put_fp(vcpu);
>>       if (has_vhe())
>>           kvm_vcpu_put_vhe(vcpu);
>> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
>> index 90ecf1210bd0..97d0c6fd5f61 100644
>> --- a/arch/arm64/kvm/debug.c
>> +++ b/arch/arm64/kvm/debug.c
>> @@ -294,40 +294,22 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
>>       }
>>   }
>> -void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu)
>> +void kvm_init_host_debug_data(void)
>>   {
>> -    u64 dfr0;
>> +    u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
>> +
>> +    if (cpuid_feature_extract_signed_field(dfr0, 
>> ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
>> +        *host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
>> +                                  read_sysreg(pmcr_el0));
>> -    /* For VHE, there is nothing to do */
>>       if (has_vhe())
>>           return;
>> -    dfr0 = read_sysreg(id_aa64dfr0_el1);
>> -    /*
>> -     * If SPE is present on this CPU and is available at current EL,
>> -     * we may need to check if the host state needs to be saved.
>> -     */
>>       if (cpuid_feature_extract_unsigned_field(dfr0, 
>> ID_AA64DFR0_EL1_PMSVer_SHIFT) &&
>> -        !(read_sysreg_s(SYS_PMBIDR_EL1) & BIT(PMBIDR_EL1_P_SHIFT)))
>> -        vcpu_set_flag(vcpu, DEBUG_STATE_SAVE_SPE);
>> +        !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P))
>> +        host_data_set_flag(HAS_SPE);
>> -    /* Check if we have TRBE implemented and available at the host */
>>       if (cpuid_feature_extract_unsigned_field(dfr0, 
>> ID_AA64DFR0_EL1_TraceBuffer_SHIFT) &&
>>           !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_P))
>> -        vcpu_set_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
>> -}
>> -
>> -void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu)
>> -{
>> -    vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_SPE);
>> -    vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
>> -}
>> -
>> -void kvm_init_host_debug_data(void)
>> -{
>> -    u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
>> -
>> -    if (cpuid_feature_extract_signed_field(dfr0, 
>> ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
>> -        *host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
>> -                                  read_sysreg(pmcr_el0));
>> +        host_data_set_flag(HAS_TRBE);
>>   }
>> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/ 
>> nvhe/debug-sr.c
>> index 1e2a26d0196e..858bb38e273f 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
>> @@ -82,10 +82,10 @@ static void __debug_restore_trace(u64 trfcr_el1)
>>   void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>>   {
>>       /* Disable and flush SPE data generation */
>> -    if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_SPE))
>> +    if (host_data_test_flag(HAS_SPE))
>>           __debug_save_spe(host_data_ptr(host_debug_state.pmscr_el1));
>>       /* Disable and flush Self-Hosted Trace generation */
>> -    if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE))
>> +    if (host_data_test_flag(HAS_TRBE))
>>           __debug_save_trace(host_data_ptr(host_debug_state.trfcr_el1));
>>   }
>> @@ -96,9 +96,9 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
>>   void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>>   {
>> -    if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_SPE))
>> +    if (host_data_test_flag(HAS_SPE))
>>           
>> __debug_restore_spe(*host_data_ptr(host_debug_state.pmscr_el1));
>> -    if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE))
>> +    if (host_data_test_flag(HAS_TRBE))
>>           
>> __debug_restore_trace(*host_data_ptr(host_debug_state.trfcr_el1));
>>   }
> 
> 

