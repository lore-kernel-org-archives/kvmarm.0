Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5D517A305
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 12:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776686883; cv=none; b=kDBuwS6vqAlvZp+C0jTpqHmKD5whzMeYBW8CsuKQsM/7fmlj49fnnsJiqTXKxek2rgbOEFVcq+3dnGS4qR71TeQwOGgArS5nFRzIDJOED/pXy3Iocs+AtdkMk90+T0fviqAoxoQcTavz0qjHNMBcZKRrAbNyUduyefwfAjXG0zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776686883; c=relaxed/simple;
	bh=dIbC/SDZoQjLyj3i5wL+OjmBtDXFYM6j1mSBuSXj66A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QiFdILwUD+pwOl/82U1sJO3hmJUHmolcyzOTDFPgUixSO3e1zFCwZ3YbwUWkDZR6ZPINoZdci5bNOauBlNf5a2zGXhd0043b7vSGBAE6TrHSCL+YLfZfnUxC2ygwcDKZH7zwlk/tT+UFoGSSMBrFgUkGULxdtu0que9cHd5rS4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=j5w++ARO reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="j5w++ARO"
Received: from [133.11.54.205] (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 63KC7Hq6039258
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 20 Apr 2026 21:07:17 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=X3xyOUVDZuLC/5XI0816FBtwBZa8y8tYdcbO0N0eS3I=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1776686837; v=1;
        b=j5w++AROJFK9hvfK610kpcnBX0FZ+xiqACla7A2e6jZXphC4kXBfSLhwnTBm3Sw+
         Xxv9jBN7EPrpmtjSN6jOAC+kQWRnPG08iINzA0Ya5MotAzZP49vynlibgpIIiwSl
         JG8h8i7L2nRX8Gae88bAZm5lB1JXMDvjqLPypecbGJekzyUNfMW/MShpDLCUBq/B
         T47j8mZJB+SyAN4fymNnD3sOfXVXaMr1ecCcoQCTdn6SSuuALjysdMPSKcttizwT
         r0hm0nNZNkVUD3lRuWwK8n7ViQ6+6jdvT/PJwblabq5qhA91C19uNPLF2+hEVxqX
         /0EeQWKF2839cd1ZAJEyFw==
Message-ID: <ad44c69e-2f99-4f31-81b4-faae52eea080@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 20 Apr 2026 21:07:15 +0900
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
 <06c6664c-7f0c-47b2-babf-ba2a541fd9f2@rsg.ci.i.u-tokyo.ac.jp>
 <86qzoa0xj6.wl-maz@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <86qzoa0xj6.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/04/20 18:51, Marc Zyngier wrote:
> On Mon, 20 Apr 2026 09:36:16 +0100,
> Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>>
>> On 2026/04/20 2:19, Marc Zyngier wrote:
>>> On Sat, 18 Apr 2026 09:14:25 +0100,
>>> Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>>>>
>>>> On a heterogeneous arm64 system, KVM's PMU emulation is based on the
>>>> features of a single host PMU instance. When a vCPU is migrated to a
>>>> pCPU with an incompatible PMU, counters such as PMCCNTR_EL0 stop
>>>> incrementing.
>>>>
>>>> Although this behavior is permitted by the architecture, Windows does
>>>> not handle it gracefully and may crash with a division-by-zero error.
>>>>
>>>> The current workaround requires VMMs to pin vCPUs to a set of pCPUs
>>>> that share a compatible PMU. This is difficult to implement correctly in
>>>> QEMU/libvirt, where pinning occurs after vCPU initialization, and it
>>>> also restricts the guest to a subset of available pCPUs.
>>>>
>>>> Introduce the KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY attribute to
>>>> create a "fixed-counters-only" PMU. When set, KVM exposes a PMU that is
>>>> compatible with all pCPUs but that does not support programmable
>>>> event counters which may have different feature sets on different PMUs.
>>>>
>>>> This allows Windows guests to run reliably on heterogeneous systems
>>>> without crashing, even without vCPU pinning, and enables VMMs to
>>>> schedule vCPUs across all available pCPUs, making full use of the host
>>>> hardware.
>>>>
>>>> Much like KVM_ARM_VCPU_PMU_V3_IRQ and other read-write attributes, this
>>>> attribute provides a getter that facilitates kernel and userspace
>>>> debugging/testing.
>>>
>>> OK, so that's the sales pitch. But how is it implemented? I would like
>>> to be able to read a high-level description of the implementation
>>> trade-offs.
>>
>> Implementation-wise it is very trivial. Essentially the following
>> addition in kvm_arm_pmu_v3_get_attr() is the entire implementation:
>> +	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
>> +		if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY,
>> &vcpu->kvm->arch.flags))
>> +			return 0;
>>
>> Both its functionality and code complexity is trivial. So we can argue that:
>> - the functionality is too trivial to be useful or
>> - the interface/implementation complexity is so trivial that it does not
>>    incur maintenance burden
>>
>> In this case the selftest uses the getter so I was more inclined to
>> have it, but adding one just for the selftest sounds too ad-hoc, so
>> here I looked into other attributes to ensure that it was not
>> introducing inconsistency with existing interfaces.
>>
>> As the result, I found there are other read-write attributes; in fact
>> there are more read-write attributes than write-only ones.
> 
> You're completely missing the point. I'm referring to the whole of the
> commit message, which is more of a marketing slide than a technical
> description.

In terms of implementation, the obvious tradeoff is that it adds more 
code to implement the feature. One thing to note is that 
kvm_vcpu_load_pmu() is added and is called each time a vCPU migrates 
across pCPUs. The heavy part, making the KVM_REQ_RELOAD_PMU request, 
only happens when the feature is enabled.

> 
> I really don't care about the getter at this stage, which while
> pointless, does not make things more awful than they already are.
> 
>>
>>>
>>>>
>>>> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
>>>> ---
>>>>    Documentation/virt/kvm/devices/vcpu.rst |  29 ++++++
>>>>    arch/arm64/include/asm/kvm_host.h       |   2 +
>>>>    arch/arm64/include/uapi/asm/kvm.h       |   1 +
>>>>    arch/arm64/kvm/arm.c                    |   1 +
>>>>    arch/arm64/kvm/pmu-emul.c               | 155 +++++++++++++++++++++++---------
>>>>    include/kvm/arm_pmu.h                   |   2 +
>>>>    6 files changed, 147 insertions(+), 43 deletions(-)
>>>>
>>>> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
>>>> index 60bf205cb373..e0aeb1897d77 100644
>>>> --- a/Documentation/virt/kvm/devices/vcpu.rst
>>>> +++ b/Documentation/virt/kvm/devices/vcpu.rst
>>>> @@ -161,6 +161,35 @@ explicitly selected, or the number of counters is out of range for the
>>>>    selected PMU. Selecting a new PMU cancels the effect of setting this
>>>>    attribute.
>>>>    +1.6 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY
>>>> +------------------------------------------------------
>>>> +
>>>> +:Parameters: no additional parameter in kvm_device_attr.addr
>>>> +
>>>> +:Returns:
>>>> +
>>>> +	 =======  =====================================================
>>>> +	 -EBUSY   Attempted to set after initializing PMUv3 or running
>>>> +		  VCPU, or attempted to set for the first time after
>>>> +		  setting an event filter
>>>> +	 -ENXIO   Attempted to get before setting
>>>> +	 -ENODEV  Attempted to set while PMUv3 not supported
>>>> +	 =======  =====================================================
>>>> +
>>>> +If set, PMUv3 will be emulated without programmable event counters. The VCPU
>>>> +will use any compatible hardware PMU. This attribute is particularly useful on
>>>
>>> Not quite "any PMU". It will use *the* PMU of the physical CPU,
>>> irrespective of the implementation.
>>
>> I think:
>>
>> - this comment
>> - one on the KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED note
>> - one on kvm_pmu_create_perf_event()
>> - and one on kvm_arm_pmu_v3_set_pmu_fixed_counters_only()
>>
>> All boil down into one question: will it support all possible CPUs, or
>> will it support a subset? Let me answer here:
>>
>> This patch is written to support a subset instead of all possible
>> CPUs. If a pCPU does not have a compatible PMU, the pCPU will not be
>> supported and cause KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED.
> 
> This is not a thing. Either *all* the CPUs have a PMU that can be used
> for KVM, or PMU support is not offered to guests. That's a hard line
> in the sand. And the code already upholds this by checking the
> sanitised PMUVer field.
> 
>>
>> This patch does not enforce all possible CPUs are covered by the
>> compatible PMUs. Theoretically speaking,
>> kvm_arm_pmu_get_pmuver_limit() enables the PMU emulation when real
>> PMUv3 hardware covers all possible CPUs *or* the relevant registers
>> can be trapped with IMPDEF, so some pCPU may not have a compatible PMU
>> and only provide the IMPDEF trapping.
> 
> How is that possible? Please describe the case where that can happen,
> and I will make sure that such a system stops booting. The intent is
> definitely that that:
> 
> - for early CPUs, we take the minimal capability of all CPUs
> 
> - for late CPUs, either they match at least the capability recorded by
>    early CPUs, or they don't boot.

All CPUs may trap the relevant registers with IMPDEF but some of them 
may not have compatible PMUs. As I wrote in the previous email, I don't 
think it will happen in practice.

> 
>> Practically, I don't think any sane configuration will ever have such
>> a subset support, so we can explicitly enforce all possible CPUs are
>> covered by the compatible PMUs if desired.
> 
> That's not just desired. This is a requirement. And it is already
> enforced AFAICS.
> 
>>
>>>
>>>> +heterogeneous systems where different hardware PMUs cover different physical
>>>> +CPUs. The compatibility of hardware PMUs can be checked with
>>>> +KVM_ARM_VCPU_PMU_V3_SET_PMU. All VCPUs in a VM share this attribute. It isn't
>>>> +possible to set it for the first time if a PMU event filter is already present.
>>>
>>> "for the first time" gives the impression that it will work if you try
>>> again. I'd rather we say that "This feature is incompatible with the
>>> existence of a PMU event filter".
>>
>> The following sequence will work:
>> 1. Set KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY
>> 2. Set KVM_ARM_VCPU_PMU_V3_FILTER
>> 3. Set KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY
>>
>> This is to make the behavior conistent with KVM_ARM_VCPU_PMU_V3_SET_PMU.
> 
> I don't think this is correct. Filtering is completely at odds with
> this patch, and I don't want to have to reason about the combination.

kvm_arm_pmu_v3_set_pmu() has the following condition:

if (kvm_vm_has_ran_once(kvm) ||
     (kvm->arch.pmu_filter && kvm->arch.arm_pmu != arm_pmu)) {
	ret = -EBUSY;
	break;
}

kvm_arm_pmu_v3_set_pmu_fixed_counters_only() has the corresponding 
condition for consistency:

if (kvm_vm_has_ran_once(kvm) ||
     (kvm->arch.pmu_filter &&
      !test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY,
	       &kvm->arch.flags)))
	return -EBUSY;

We can of course kill the PMU event filter for FIXED_COUNTERS_ONLY. The 
filter is effectively no-op with FIXED_COUNTERS_ONLY and I don't think 
that consistency matters much.

> 
> [...]
> 
>>>> +	int i;
>>>> +
>>>> +	for_each_set_bit(i, &mask, 32) {
>>>> +		pmc = kvm_vcpu_idx_to_pmc(vcpu, i);
>>>> +		if (!pmc->perf_event)
>>>> +			continue;
>>>> +
>>>> +		cpu_pmu = to_arm_pmu(pmc->perf_event->pmu);
>>>> +		if (!cpumask_test_cpu(vcpu->cpu, &cpu_pmu->supported_cpus)) {
>>>> +			kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
>>>> +			break;
>>>> +		}
>>>> +	}
>>>> +}
>>>> +
>>>
>>> Why do we need to inflict this on VMs that do not have the fixed
>>> counter restriction?
>>
>> This function is to re-create the perf_event in case the current
>> perf_event does not support the pCPU because e.g., the pCPU is a
>> E-core while the perf_event only covers the P-cores.
> 
> That's not what I meant. This code is only here to support the
> fixed-function feature. It makes no sense outside of it, because *we
> don't support counter migration across implementations*.
> 
> So what's the purpose of this stuff for the normal KVM setup?

None. It's only for this feature. We can add a check of the feature flag 
at the beginning of the function to avoid that loop.

> 
>>
>>>
>>> And even then, all you have to reconfigure is the cycle counter. So
>>> why the loop? All we want to find out is whether the cycle counter is
>>> instantiated on the PMU that matches the current CPU.
>>
>> I just wanted to avoid hardcoding assumptions on the fixed
>> counter(s). FEAT_PMUv3_ICNTR will be naturaly handled with a loop, for
>> example.
> 
> Well, not that loop, since ICNTR is counter 32. So please let's stop
> the nonsense and only add what is required?
> 
> [...]
> 
>>>>    +
>>>> clear_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY,
>>>> &kvm->arch.flags);
>>>
>>> Why does this need to be cleared? I'd rather we make sure it is never
>>> set the first place.
>>
>> KVM_ARM_VCPU_PMU_V3_SET_PMU and
>> KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY can be set on the same
>> VCPU. The last KVM_ARM_VCPU_PMU_V3_SET_PMU or
>> KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY setting will be effective.
>>
>> A VMM may try set these attributes to check if the setting is
>> supported. For example, the RFC QEMU patch first uses
>> KVM_ARM_VCPU_PMU_V3_SET_PMU to find a compatible PMU that covers all
>> pCPUs, and then falls back to
>> KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY. The order of such probing is
>> up to the VMM.
> 
> KVM_ARM_VCPU_PMU_V3_SET_PMU is not a probing mechanism. You must probe
> the PMUs by looking in /sys/bus/event_source/devices/, like kvmtool
> does.
> 
> So there is no reason to support this stuff, and the two flags should
> be made mutually exclusive.

Thanks for the pointer. I'll make a change to make the flags mutually 
exclusive and test it with an amended QEMU patch that follows what 
kvmtool does.

> 
> [...]
> 
>>>>
>>>
>>> In conclusion, I find this patch to be rather messy. For a start, it
>>> needs to be split in at least 5 patches:
>>>
>>> - at least two for the refactoring
>>> - one for the PMU core changes
>>> - one for the UAPI
>>> - one for documentation
>>
>> That clarifies the expected granurarity of patches. The next version
>> will be in that layout, perhaps with more patches if an additional
>> change. Thanks for the guidance.
>>
>>>
>>> I'd also like some clarification on how this is intended to work if we
>>> enable FEAT_PMUv3_ICNTR, because the definition seems to be designed
>>> to encompass all fixed-function counters, and I expect this to grow
>>> over time.
>>
>> Indeed the UAPI was designed to encompass all fixed-function counters
>> as suggested by Oliver.
>>
>> To support the UAPI, the implementation avoids hardcoding the
>> assumption on the fixed counter(s). FEAT_PMUv3_INCTR will be naturaly
>> supported once the common code is properly updated (i.e., the size of
>> the event counter bitmask is grown the corresponding registers are
>> wired up with a proper check of the feature.)
>>
>> I expect migration will be handled with the conventional register
>> getters and setters, but please share if you have a concern.
> 
> At the very least I want to see some documentation explaining that.

What kind of documentation do you expect? If we change 
kvm_vcpu_load_pmu() to avoid for_each_set_bit(), there would be a good 
chance to forget updating it when mechanically updating existing 
for_each_set_bit() instances, so it is a candidate for documentation. 
But I don't have a good idea where to place it either.

Regards,
Akihiko Odaki
