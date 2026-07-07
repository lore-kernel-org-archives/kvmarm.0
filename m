Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E563F789C
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 11:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783424228; cv=none; b=UqQD3uRq/I/odt8axhJAF1yU6jseybxNq/HS79y5DaWg8tzulqA15D4fd6FzkS5AyHZTMmxw/eQ0s48iDf85J/B0XHnNNLdQjz6rjWfjFG3Lg8VSKQgQPr62pJFtXTlOoj2H16EJeL8hPldiEUYaw4RK1E0UoI6/GYqMsLQs4ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783424228; c=relaxed/simple;
	bh=zisHKAD74OWux5/tK8lytmVqjM6h3AIY4NHgLxcwVtg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s+S0PafmQmOkiwUdmvaKStUtphWjSGt6m3FEOAEQYd21FSxGdPVilThevqGIcN2UZEUrj4m5nEfGa0XEL1vjGJyMvhTGItMjkofpqoIEdBvRMrtQTHw9QrAt9VJFuWPNyRYa7d1HfwkXA6wFYDTboUP2ZJ0usU8GOWHIwS04Z8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=TJ9+WCJu reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="TJ9+WCJu"
Received: from [133.11.54.183] (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 667BaXR6009375
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 7 Jul 2026 20:36:33 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=PC9H9+hfBUgJc1h9fKgLECYX3wbgWyiwPKt7KOMjAiE=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1783424194; v=1;
        b=TJ9+WCJuvN2HY9GfRKpGwzZshGSjYSg+ZCQPyx+qgt+W3BRyH5dvAMZNxppn7WPz
         KWg4fLBC8zWUuwbNrQrvtEciEtr3hzWw2BgyPziP7Tz9IAtBBJ96qe1kaSSZyN1a
         CtNdBeuNKcYX6EG9UT8iaiSkatol3VYDd+FkjSQqNMVCD0ajPTR8LH/cQd2teirB
         WhZc42jMhxC7y3nYH4eeUVst6bLixn5KanS+l+9ciFjtWUfnH5ZfdaGif2Sg3Z0o
         iUTu6Pc2W3lxcodV0dFvbkAQDmL18va8K84f1tATGhEOsG/TV0InJ0JkrkuR1WFR
         driv6wIpea3cPdDdCv26EA==
Message-ID: <db672f83-a6c4-4d94-a959-930a624a7915@rsg.ci.i.u-tokyo.ac.jp>
Date: Tue, 7 Jul 2026 20:36:32 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 6/7] KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu
 <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <20260706-hybrid-v8-6-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <akvsuBcqCCzlrBLk@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <akvsuBcqCCzlrBLk@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/07/07 2:58, Oliver Upton wrote:
> On Mon, Jul 06, 2026 at 07:03:29PM +0900, Akihiko Odaki wrote:
>> +1.6 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY
>> +------------------------------------------------------
>> +
>> +:Parameters: no additional parameter in kvm_device_attr.addr
>> +
>> +:Returns:
>> +
>> +	 =======  ==================================================
>> +	 -EBUSY   PMUv3 already initialized, a VCPU has already run,
>> +		  an event filter has already been set or
>> +		  a hardware PMU has already been specified
>> +	 -ENXIO   Attempted to get before setting
>> +	 -ENODEV  Attempted to set while PMUv3 not supported
>> +	 =======  ==================================================
>> +
>> +If set, KVM emulates PMUv3 without programmable event counters. Only fixed
>> +counters are exposed to the guest: the cycle counter today, and the instruction
>> +counter if support for FEAT_PMUv3_ICNTR is added.
> 
> Drop the mention of cycle counter and FEAT_PMUv3_ICNTR, I want to avoid
> the argument later down the line when ICNTR support is added to this
> mode.
> 
> The expectation is that the VMM discovers the feature set using the ID
> registers just like every other CPU feature. KVM documentation doesn't
> need to describe the architecture.
I'll drop it with the next version.

> 
>> +With programmable counters disabled, the VCPU can run on any physical CPU.
>> +This is particularly useful on heterogeneous systems where different hardware
>> +PMUs cover different physical CPUs. All VCPUs in a VM share this attribute.
> 
>    When this attribute is enabled, the vCPU can run on any physical CPU
>    that has a PMU, regardless of the underlying implementation. This
>    attribute is VM-scoped.
> 
> The documentation is focused on unambiguously representing the UAPI, not
> providing application recommendations.

I agree. I'll use your wording for the next version.

> 
>>   2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
>>   =================================
>>   
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>> index 1c13bfa2d38a..39a1a1e412e6 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -437,6 +437,7 @@ enum {
>>   #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
>>   #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
>>   #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
>> +#define   KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY	5
>>   #define KVM_ARM_VCPU_TIMER_CTRL		1
>>   #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
>>   #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index 40cad183376c..ad9ff4d0d89c 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -1149,11 +1149,13 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
>>   		arm_pmu = entry->arm_pmu;
>>   		if (arm_pmu->pmu.type == pmu_id) {
>>   			if (kvm_vm_has_ran_once(kvm) ||
>> +			    kvm_pmu_fixed_counters_only(kvm) ||
>>   			    (kvm->arch.pmu_filter && kvm->arch.arm_pmu != arm_pmu)) {
>>   				ret = -EBUSY;
>>   				break;
>>   			}
>>   
>> +			set_bit(KVM_ARCH_FLAG_PMU_V3_EXPLICIT, &kvm->arch.flags);
> 
> Why is this flag necessary? kvm->arch.arm_pmu is NULL if no PMU
> implementation was selected by userspace.

The explicit flag is there because kvm->arch.arm_pmu is also populated
by KVM_ARM_VCPU_INIT through kvm_arm_set_default_pmu(). I wanted to keep
allowing userspace to enable FIXED_COUNTERS_ONLY after that default PMU
selection, as long as PMUv3 has not been initialized and the VM has not
run, while still rejecting it after an explicit SET_PMU.

> 
>>   			kvm_arm_set_pmu(kvm, arm_pmu);
>>   			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
>>   			ret = 0;
>> @@ -1164,6 +1166,22 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
>>   	return ret;
>>   }
>>   
>> +static int kvm_arm_pmu_v3_set_pmu_fixed_counters_only(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +
>> +	lockdep_assert_held(&kvm->arch.config_lock);
>> +
>> +	if (kvm_vm_has_ran_once(kvm) || kvm->arch.pmu_filter ||
>> +	    test_bit(KVM_ARCH_FLAG_PMU_V3_EXPLICIT, &kvm->arch.flags))
>> +		return -EBUSY;
>> +
>> +	set_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags);
>> +	kvm_arm_set_nr_counters(kvm, 0);
>> +
>> +	return 0;
>> +}
>> +
>>   static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
>>   {
>>   	struct kvm *kvm = vcpu->kvm;
>> @@ -1238,7 +1256,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>>   		     filter.action != KVM_PMU_EVENT_DENY))
>>   			return -EINVAL;
>>   
>> -		if (kvm_vm_has_ran_once(kvm))
>> +		if (kvm_vm_has_ran_once(kvm) || kvm_pmu_fixed_counters_only(kvm))
> 
> There's no reason for doing this, just let userspace create an event
> filter. Even with the current PMU implementation it's possible that the
> fixed cycle counter gets filtered.

This check was added as the consequence of the discussion in the 
following thread:
https://lore.kernel.org/all/327f74e4-78b8-4629-a418-d1d3ba78859f@rsg.ci.i.u-tokyo.ac.jp/

Regards,
Akihiko Odaki
