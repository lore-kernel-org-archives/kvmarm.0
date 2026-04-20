Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DBB288C08
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 08:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776674218; cv=none; b=OmmqVHyx+cLMhUy1lPJhngTnm8CGm34KE6BHhnP19BVOSwVtlS11lkgh0f5KRGg9mu3oJsGnThaLPb063GJI+dXgRyYIJ6Phr7CsFlHM7Zrs37GW7IvBZ7gfeydI1arAokoa56fRs3U+2HBuV7CZ2D4teG+LGdQ5oemYYbbjssk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776674218; c=relaxed/simple;
	bh=IBs7rg5dViW/m7pLXOnHLWp6rbQG+MAPPN63L1MW+cI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B+xfk/8F2CGOMLOCOP1PA0LcQUWw4hHV/p7/NrbScxSSL4PV3FOF3Sy9i6WZN466wxLILG/esnChHqAd1fY/hCsLfL/+x7KFPdElq9BGH6JrgUaYfPXy+lm0HQMdvXDnIwXsnogSozjGkvNhL+TjmrqOvUpTuKvxy3MMpKYsdBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=f7MqT0Yf reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="f7MqT0Yf"
Received: from [133.11.54.205] (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 63K8aGlf032186
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 20 Apr 2026 17:36:16 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=A79bWE/x5/xyJk29KX3gVbVjAPmoXpm9/Q6RLn39CnY=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1776674177; v=1;
        b=f7MqT0YfSaBpAuOzN0va4bg80z0HCBkNsmYAyL3EKHuTercFixKHciZdkP22+FrY
         67SnN3xAML8AdiUrKMWpQRI+Zc8gIcQRC6MQk+B/I5Uc6eZWHUuZBxZakiLLGZgv
         vn3cpHh9WfG4b998QMN4ZD4vEdyqUOQfhb0H82SMmCv9HyH69Tum8D7zHT8O2abj
         4x4F5G1NCWmv+uuJHcF8PbvlMlp4C36FxRSJWRnE9hGs3uTjLwPx3OuGRd4ZGQKp
         0uGCwfZBr1iL4HJIIYHzYLKlhRxrSZchJ20zJAbqbgLotW93Escqu6ccr8JAMZCv
         bDO6Gp3u1PrZ4b+nEyhO1Q==
Message-ID: <06c6664c-7f0c-47b2-babf-ba2a541fd9f2@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 20 Apr 2026 17:36:16 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/4] KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu
 <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, devel@daynix.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260418-hybrid-v7-0-2bf39ad009bf@rsg.ci.i.u-tokyo.ac.jp>
 <20260418-hybrid-v7-3-2bf39ad009bf@rsg.ci.i.u-tokyo.ac.jp>
 <87ldeic1gk.wl-maz@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <87ldeic1gk.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/04/20 2:19, Marc Zyngier wrote:
> On Sat, 18 Apr 2026 09:14:25 +0100,
> Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>>
>> On a heterogeneous arm64 system, KVM's PMU emulation is based on the
>> features of a single host PMU instance. When a vCPU is migrated to a
>> pCPU with an incompatible PMU, counters such as PMCCNTR_EL0 stop
>> incrementing.
>>
>> Although this behavior is permitted by the architecture, Windows does
>> not handle it gracefully and may crash with a division-by-zero error.
>>
>> The current workaround requires VMMs to pin vCPUs to a set of pCPUs
>> that share a compatible PMU. This is difficult to implement correctly in
>> QEMU/libvirt, where pinning occurs after vCPU initialization, and it
>> also restricts the guest to a subset of available pCPUs.
>>
>> Introduce the KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY attribute to
>> create a "fixed-counters-only" PMU. When set, KVM exposes a PMU that is
>> compatible with all pCPUs but that does not support programmable
>> event counters which may have different feature sets on different PMUs.
>>
>> This allows Windows guests to run reliably on heterogeneous systems
>> without crashing, even without vCPU pinning, and enables VMMs to
>> schedule vCPUs across all available pCPUs, making full use of the host
>> hardware.
>>
>> Much like KVM_ARM_VCPU_PMU_V3_IRQ and other read-write attributes, this
>> attribute provides a getter that facilitates kernel and userspace
>> debugging/testing.
> 
> OK, so that's the sales pitch. But how is it implemented? I would like
> to be able to read a high-level description of the implementation
> trade-offs.

Implementation-wise it is very trivial. Essentially the following 
addition in kvm_arm_pmu_v3_get_attr() is the entire implementation:
+	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
+		if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, 
&vcpu->kvm->arch.flags))
+			return 0;

Both its functionality and code complexity is trivial. So we can argue that:
- the functionality is too trivial to be useful or
- the interface/implementation complexity is so trivial that it does not
   incur maintenance burden

In this case the selftest uses the getter so I was more inclined to have 
it, but adding one just for the selftest sounds too ad-hoc, so here I 
looked into other attributes to ensure that it was not introducing 
inconsistency with existing interfaces.

As the result, I found there are other read-write attributes; in fact 
there are more read-write attributes than write-only ones.

> 
>>
>> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
>> ---
>>   Documentation/virt/kvm/devices/vcpu.rst |  29 ++++++
>>   arch/arm64/include/asm/kvm_host.h       |   2 +
>>   arch/arm64/include/uapi/asm/kvm.h       |   1 +
>>   arch/arm64/kvm/arm.c                    |   1 +
>>   arch/arm64/kvm/pmu-emul.c               | 155 +++++++++++++++++++++++---------
>>   include/kvm/arm_pmu.h                   |   2 +
>>   6 files changed, 147 insertions(+), 43 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
>> index 60bf205cb373..e0aeb1897d77 100644
>> --- a/Documentation/virt/kvm/devices/vcpu.rst
>> +++ b/Documentation/virt/kvm/devices/vcpu.rst
>> @@ -161,6 +161,35 @@ explicitly selected, or the number of counters is out of range for the
>>   selected PMU. Selecting a new PMU cancels the effect of setting this
>>   attribute.
>>   
>> +1.6 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY
>> +------------------------------------------------------
>> +
>> +:Parameters: no additional parameter in kvm_device_attr.addr
>> +
>> +:Returns:
>> +
>> +	 =======  =====================================================
>> +	 -EBUSY   Attempted to set after initializing PMUv3 or running
>> +		  VCPU, or attempted to set for the first time after
>> +		  setting an event filter
>> +	 -ENXIO   Attempted to get before setting
>> +	 -ENODEV  Attempted to set while PMUv3 not supported
>> +	 =======  =====================================================
>> +
>> +If set, PMUv3 will be emulated without programmable event counters. The VCPU
>> +will use any compatible hardware PMU. This attribute is particularly useful on
> 
> Not quite "any PMU". It will use *the* PMU of the physical CPU,
> irrespective of the implementation.

I think:

- this comment
- one on the KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED note
- one on kvm_pmu_create_perf_event()
- and one on kvm_arm_pmu_v3_set_pmu_fixed_counters_only()

All boil down into one question: will it support all possible CPUs, or 
will it support a subset? Let me answer here:

This patch is written to support a subset instead of all possible CPUs. 
If a pCPU does not have a compatible PMU, the pCPU will not be supported 
and cause KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED.

This patch does not enforce all possible CPUs are covered by the 
compatible PMUs. Theoretically speaking, kvm_arm_pmu_get_pmuver_limit() 
enables the PMU emulation when real PMUv3 hardware covers all possible 
CPUs *or* the relevant registers can be trapped with IMPDEF, so some 
pCPU may not have a compatible PMU and only provide the IMPDEF trapping.

Practically, I don't think any sane configuration will ever have such a 
subset support, so we can explicitly enforce all possible CPUs are 
covered by the compatible PMUs if desired.

> 
>> +heterogeneous systems where different hardware PMUs cover different physical
>> +CPUs. The compatibility of hardware PMUs can be checked with
>> +KVM_ARM_VCPU_PMU_V3_SET_PMU. All VCPUs in a VM share this attribute. It isn't
>> +possible to set it for the first time if a PMU event filter is already present.
> 
> "for the first time" gives the impression that it will work if you try
> again. I'd rather we say that "This feature is incompatible with the
> existence of a PMU event filter".

The following sequence will work:
1. Set KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY
2. Set KVM_ARM_VCPU_PMU_V3_FILTER
3. Set KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY

This is to make the behavior conistent with KVM_ARM_VCPU_PMU_V3_SET_PMU.

> 
> Furthermore, the architecture currently describes *two* fixed-function
> counters (cycles and instructions), while KVM only expose the cycle
> counter. I'm all for the extra abstraction, but what does it mean for
> migration if we enable FEAT_PMUv3_ICNTR?

I'll answe this at the end of this email.

> 
>> +
>> +Note that KVM will not make any attempts to run the VCPU on the physical CPUs
>> +with compatible hardware PMUs. This is entirely left to userspace. However,
>> +attempting to run the VCPU on an unsupported CPU will fail and KVM_RUN will
>> +return with exit_reason = KVM_EXIT_FAIL_ENTRY and populate the fail_entry struct
>> +by setting hardware_entry_failure_reason field to
>> +KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED and the cpu field to the processor id.
>> +
> 
> This is mostly a copy-paste of the previous section. How relevant is
> this to the fixed-counters-only feature? If the whole point of this
> stuff is to ensure compatibility across CPUs with different PMU
> implementations, surely what you describe here is the opposite of what
> you want.

Please see the earlier discussion of supported pCPUs.

> 
> My preference would be to move this to a separate patch in any case,
> more on that below.

I will do so with the next version.

> 
>>   2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
>>   =================================
>>   
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 59f25b85be2b..b59e0182472c 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -353,6 +353,8 @@ struct kvm_arch {
>>   #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
>>   	/* Unhandled SEAs are taken to userspace */
>>   #define KVM_ARCH_FLAG_EXIT_SEA				11
>> +	/* PMUv3 is emulated without progammable event counters */
>> +#define KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY	12
>>   	unsigned long flags;
>>   
>>   	/* VM-wide vCPU feature set */
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>> index a792a599b9d6..474c84fa757f 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -436,6 +436,7 @@ enum {
>>   #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
>>   #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
>>   #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
>> +#define   KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY	5
>>   #define KVM_ARM_VCPU_TIMER_CTRL		1
>>   #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
>>   #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 620a465248d1..dca16ca26d32 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -634,6 +634,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>   	if (has_vhe())
>>   		kvm_vcpu_load_vhe(vcpu);
>>   	kvm_arch_vcpu_load_fp(vcpu);
>> +	kvm_vcpu_load_pmu(vcpu);
>>   	kvm_vcpu_pmu_restore_guest(vcpu);
>>   	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
>>   		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index ef5140bbfe28..d1009c144581 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -326,7 +326,10 @@ u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
>>   
>>   static void kvm_pmc_enable_perf_event(struct kvm_pmc *pmc)
>>   {
>> -	if (!pmc->perf_event) {
>> +	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
>> +
>> +	if (!pmc->perf_event ||
>> +	    !cpumask_test_cpu(vcpu->cpu, &to_arm_pmu(pmc->perf_event->pmu)->supported_cpus)) {
>>   		kvm_pmu_create_perf_event(pmc);
>>   		return;
>>   	}
>> @@ -667,10 +670,8 @@ static bool kvm_pmc_counts_at_el2(struct kvm_pmc *pmc)
>>   	return kvm_pmc_read_evtreg(pmc) & ARMV8_PMU_INCLUDE_EL2;
>>   }
>>   
>> -static int kvm_map_pmu_event(struct kvm *kvm, unsigned int eventsel)
>> +static int kvm_map_pmu_event(struct arm_pmu *pmu, unsigned int eventsel)
>>   {
>> -	struct arm_pmu *pmu = kvm->arch.arm_pmu;
>> -
>>   	/*
>>   	 * The CPU PMU likely isn't PMUv3; let the driver provide a mapping
>>   	 * for the guest's PMUv3 event ID.
> 
> This refactor should be in its own patch. This sort of minor change is
> adding noise to the mean of the patch, for no good reason.

I'll make that change with the next version too.

> 
>> @@ -681,6 +682,23 @@ static int kvm_map_pmu_event(struct kvm *kvm, unsigned int eventsel)
>>   	return eventsel;
>>   }
>>   
>> +static struct arm_pmu *kvm_pmu_probe_armpmu(int cpu)
>> +{
>> +	struct arm_pmu_entry *entry;
>> +	struct arm_pmu *pmu;
>> +
>> +	guard(rcu)();
>> +
>> +	list_for_each_entry_rcu(entry, &arm_pmus, entry) {
>> +		pmu = entry->arm_pmu;
>> +
>> +		if (cpumask_test_cpu(cpu, &pmu->supported_cpus))
>> +			return pmu;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>>   /**
>>    * kvm_pmu_create_perf_event - create a perf event for a counter
>>    * @pmc: Counter context
>> @@ -694,6 +712,12 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
>>   	int eventsel;
>>   	u64 evtreg;
>>   
>> +	if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &vcpu->kvm->arch.flags)) {
>> +		arm_pmu = kvm_pmu_probe_armpmu(vcpu->cpu);
>> +		if (!arm_pmu)
>> +			return;
> 
> How is it possible to not get a PMU here? We don't expose the PMU to a
> guest at all if there are CPUs without PMUs, see the comment in
> kvm_host_pmu_init(). So I'd expect this to never fail.

Please see the earlier comment.

> 
>> +	}
>> +
>>   	evtreg = kvm_pmc_read_evtreg(pmc);
>>   
>>   	kvm_pmu_stop_counter(pmc);
>> @@ -722,7 +746,7 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
>>   	 * Don't create an event if we're running on hardware that requires
>>   	 * PMUv3 event translation and we couldn't find a valid mapping.
>>   	 */
>> -	eventsel = kvm_map_pmu_event(vcpu->kvm, eventsel);
>> +	eventsel = kvm_map_pmu_event(arm_pmu, eventsel);
>>   	if (eventsel < 0)
>>   		return;
>>   
>> @@ -810,42 +834,6 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
>>   	list_add_tail_rcu(&entry->entry, &arm_pmus);
>>   }
>>   
>> -static struct arm_pmu *kvm_pmu_probe_armpmu(void)
>> -{
>> -	struct arm_pmu_entry *entry;
>> -	struct arm_pmu *pmu;
>> -	int cpu;
>> -
>> -	guard(rcu)();
>> -
>> -	/*
>> -	 * It is safe to use a stale cpu to iterate the list of PMUs so long as
>> -	 * the same value is used for the entirety of the loop. Given this, and
>> -	 * the fact that no percpu data is used for the lookup there is no need
>> -	 * to disable preemption.
>> -	 *
>> -	 * It is still necessary to get a valid cpu, though, to probe for the
>> -	 * default PMU instance as userspace is not required to specify a PMU
>> -	 * type. In order to uphold the preexisting behavior KVM selects the
>> -	 * PMU instance for the core during vcpu init. A dependent use
>> -	 * case would be a user with disdain of all things big.LITTLE that
>> -	 * affines the VMM to a particular cluster of cores.
>> -	 *
>> -	 * In any case, userspace should just do the sane thing and use the UAPI
>> -	 * to select a PMU type directly. But, be wary of the baggage being
>> -	 * carried here.
>> -	 */
>> -	cpu = raw_smp_processor_id();
>> -	list_for_each_entry_rcu(entry, &arm_pmus, entry) {
>> -		pmu = entry->arm_pmu;
>> -
>> -		if (cpumask_test_cpu(cpu, &pmu->supported_cpus))
>> -			return pmu;
>> -	}
>> -
>> -	return NULL;
>> -}
>> -
> 
> Same thing for the refactoring of this function. Moving it, changing
> the signature and moving the comment somewhere else would be better
> placed on its own.

This will be in a separate patch with the next version.

> 
>>   static u64 __compute_pmceid(struct arm_pmu *pmu, bool pmceid1)
>>   {
>>   	u32 hi[2], lo[2];
>> @@ -888,6 +876,9 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
>>   	u64 val, mask = 0;
>>   	int base, i, nr_events;
>>   
>> +	if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &vcpu->kvm->arch.flags))
>> +		return 0;
>> +
>>   	if (!pmceid1) {
>>   		val = compute_pmceid0(cpu_pmu);
>>   		base = 0;
>> @@ -915,6 +906,26 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
>>   	return val & mask;
>>   }
>>   
>> +void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu)
>> +{
>> +	unsigned long mask = kvm_pmu_enabled_counter_mask(vcpu);
>> +	struct kvm_pmc *pmc;
>> +	struct arm_pmu *cpu_pmu;
> 
> Move these to be inside the loop.

I followed the pattern of other functions, but I agree this new code can 
follow a more modern style. It will be done with the next version.

> 
>> +	int i;
>> +
>> +	for_each_set_bit(i, &mask, 32) {
>> +		pmc = kvm_vcpu_idx_to_pmc(vcpu, i);
>> +		if (!pmc->perf_event)
>> +			continue;
>> +
>> +		cpu_pmu = to_arm_pmu(pmc->perf_event->pmu);
>> +		if (!cpumask_test_cpu(vcpu->cpu, &cpu_pmu->supported_cpus)) {
>> +			kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
>> +			break;
>> +		}
>> +	}
>> +}
>> +
> 
> Why do we need to inflict this on VMs that do not have the fixed
> counter restriction?

This function is to re-create the perf_event in case the current 
perf_event does not support the pCPU because e.g., the pCPU is a E-core 
while the perf_event only covers the P-cores.

> 
> And even then, all you have to reconfigure is the cycle counter. So
> why the loop? All we want to find out is whether the cycle counter is
> instantiated on the PMU that matches the current CPU.

I just wanted to avoid hardcoding assumptions on the fixed counter(s). 
FEAT_PMUv3_ICNTR will be naturaly handled with a loop, for example.

> 
>>   void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
>>   {
>>   	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
>> @@ -1016,6 +1027,9 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
>>   {
>>   	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
>>   
>> +	if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags))
>> +		return 0;
>> +
>>   	/*
>>   	 * PMUv3 requires that all event counters are capable of counting any
>>   	 * event, though the same may not be true of non-PMUv3 hardware.
>> @@ -1070,7 +1084,24 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
>>    */
>>   int kvm_arm_set_default_pmu(struct kvm *kvm)
>>   {
>> -	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();
>> +	/*
>> +	 * It is safe to use a stale cpu to iterate the list of PMUs so long as
>> +	 * the same value is used for the entirety of the loop. Given this, and
>> +	 * the fact that no percpu data is used for the lookup there is no need
>> +	 * to disable preemption.
>> +	 *
>> +	 * It is still necessary to get a valid cpu, though, to probe for the
>> +	 * default PMU instance as userspace is not required to specify a PMU
>> +	 * type. In order to uphold the preexisting behavior KVM selects the
>> +	 * PMU instance for the core during vcpu init. A dependent use
>> +	 * case would be a user with disdain of all things big.LITTLE that
>> +	 * affines the VMM to a particular cluster of cores.
>> +	 *
>> +	 * In any case, userspace should just do the sane thing and use the UAPI
>> +	 * to select a PMU type directly. But, be wary of the baggage being
>> +	 * carried here.
>> +	 */
>> +	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu(raw_smp_processor_id());
>>   
>>   	if (!arm_pmu)
>>   		return -ENODEV;
>> @@ -1098,6 +1129,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
>>   				break;
>>   			}
>>   
>> +			clear_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags);
> 
> Why does this need to be cleared? I'd rather we make sure it is never
> set the first place.

KVM_ARM_VCPU_PMU_V3_SET_PMU and KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY 
can be set on the same VCPU. The last KVM_ARM_VCPU_PMU_V3_SET_PMU or 
KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY setting will be effective.

A VMM may try set these attributes to check if the setting is supported. 
For example, the RFC QEMU patch first uses KVM_ARM_VCPU_PMU_V3_SET_PMU 
to find a compatible PMU that covers all pCPUs, and then falls back to 
KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY. The order of such probing is up 
to the VMM.

This rationale applies also to the next comment.

> 
>>   			kvm_arm_set_pmu(kvm, arm_pmu);
>>   			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
>>   			ret = 0;
>> @@ -1108,11 +1140,42 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
>>   	return ret;
>>   }
>>   
>> +static int kvm_arm_pmu_v3_set_pmu_fixed_counters_only(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	struct arm_pmu_entry *entry;
>> +	struct arm_pmu *arm_pmu;
>> +	struct cpumask *supported_cpus = kvm->arch.supported_cpus;
>> +
>> +	lockdep_assert_held(&kvm->arch.config_lock);
>> +
>> +	if (kvm_vm_has_ran_once(kvm) ||
>> +	    (kvm->arch.pmu_filter &&
>> +	     !test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags)))
>> +		return -EBUSY;
>> +
>> +	set_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags);
>> +	kvm_arm_set_nr_counters(kvm, 0);
>> +	cpumask_clear(supported_cpus);
> 
> What is the purpose of this cpumask_clear()? Under what conditions can
> you have something else?
> 
>> +
>> +	guard(rcu)();
>> +
>> +	list_for_each_entry_rcu(entry, &arm_pmus, entry) {
>> +		arm_pmu = entry->arm_pmu;
>> +		cpumask_or(supported_cpus, supported_cpus, &arm_pmu->supported_cpus);
> 
> Why isn't supported_cpus directly set to possible_cpus? Isn't that the
> base requirement that you can run on any CPU at all?

Please see the earlier discussion of supported pCPUs.

> 
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
>>   {
>>   	struct kvm *kvm = vcpu->kvm;
>>   
>> -	if (!kvm->arch.arm_pmu)
>> +	lockdep_assert_held(&kvm->arch.config_lock);
>> +
>> +	if (!kvm->arch.arm_pmu &&
>> +	    !test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags))
>>   		return -EINVAL;
>>   
>>   	if (n > kvm_arm_pmu_get_max_counters(kvm))
>> @@ -1227,6 +1290,8 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>>   
>>   		return kvm_arm_pmu_v3_set_nr_counters(vcpu, n);
>>   	}
>> +	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
>> +		return kvm_arm_pmu_v3_set_pmu_fixed_counters_only(vcpu);
>>   	case KVM_ARM_VCPU_PMU_V3_INIT:
>>   		return kvm_arm_pmu_v3_init(vcpu);
>>   	}
>> @@ -1253,6 +1318,9 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>>   		irq = vcpu->arch.pmu.irq_num;
>>   		return put_user(irq, uaddr);
>>   	}
>> +	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
>> +		if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &vcpu->kvm->arch.flags))
> 
> With 6 occurrences of this test_bit(), it feels like it'd be valuable
> to have a dedicate predicate to help with readability.

I'll add one with the next version.

> 
>> +			return 0;
>>   	}
>>   
>>   	return -ENXIO;
>> @@ -1266,6 +1334,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>>   	case KVM_ARM_VCPU_PMU_V3_FILTER:
>>   	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
>>   	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
>> +	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
>>   		if (kvm_vcpu_has_pmu(vcpu))
>>   			return 0;
>>   	}
>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> index 96754b51b411..1375cbaf97b2 100644
>> --- a/include/kvm/arm_pmu.h
>> +++ b/include/kvm/arm_pmu.h
>> @@ -56,6 +56,7 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
>>   void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
>>   void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>>   				    u64 select_idx);
>> +void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu);
>>   void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu);
>>   int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu,
>>   			    struct kvm_device_attr *attr);
>> @@ -161,6 +162,7 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
>>   static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
>>   static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
>>   static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
>> +static inline void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu) {}
>>   static inline void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu) {}
>>   static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
>>   {
>>
> 
> In conclusion, I find this patch to be rather messy. For a start, it
> needs to be split in at least 5 patches:
> 
> - at least two for the refactoring
> - one for the PMU core changes
> - one for the UAPI
> - one for documentation

That clarifies the expected granurarity of patches. The next version 
will be in that layout, perhaps with more patches if an additional 
change. Thanks for the guidance.

> 
> I'd also like some clarification on how this is intended to work if we
> enable FEAT_PMUv3_ICNTR, because the definition seems to be designed
> to encompass all fixed-function counters, and I expect this to grow
> over time.

Indeed the UAPI was designed to encompass all fixed-function counters as 
suggested by Oliver.

To support the UAPI, the implementation avoids hardcoding the assumption 
on the fixed counter(s). FEAT_PMUv3_INCTR will be naturaly supported 
once the common code is properly updated (i.e., the size of the event 
counter bitmask is grown the corresponding registers are wired up with a 
proper check of the feature.)

I expect migration will be handled with the conventional register 
getters and setters, but please share if you have a concern.

> 
> I'm also not planning to look at the selftest at this stage.

That is completely understandable; I'll focus on refining the design and 
implementation for the next version first.

Regards,
Akihiko Odaki
