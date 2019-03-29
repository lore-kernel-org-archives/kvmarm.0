From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v7 7/10] KVM: arm/arm64: context-switch ptrauth registers
Date: Fri, 29 Mar 2019 11:24:52 +0530
Message-ID: <6208fe17-5a75-92d6-a27d-32a63f5e3bfd@arm.com>
References: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
 <1552984243-7689-8-git-send-email-amit.kachhap@arm.com>
 <9d929db6-2a24-b356-6c76-8f58341db4bc@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68CA14A3FE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 01:55:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jAaMHlFWl7cr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Mar 2019 01:55:00 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A75D54A1FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 01:55:00 -0400 (EDT)
In-Reply-To: <9d929db6-2a24-b356-6c76-8f58341db4bc@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 3/29/19 12:21 AM, James Morse wrote:
> Hi Amit,
> 
> On 19/03/2019 08:30, Amit Daniel Kachhap wrote:
>> From: Mark Rutland <mark.rutland@arm.com>
>>
>> When pointer authentication is supported, a guest may wish to use it.
>> This patch adds the necessary KVM infrastructure for this to work, with
>> a semi-lazy context switch of the pointer auth state.
>>
>> Pointer authentication feature is only enabled when VHE is built
>> in the kernel and present in the CPU implementation so only VHE code
>> paths are modified.
>>
>> When we schedule a vcpu, we disable guest usage of pointer
>> authentication instructions and accesses to the keys. While these are
>> disabled, we avoid context-switching the keys. When we trap the guest
>> trying to use pointer authentication functionality, we change to eagerly
>> context-switching the keys, and enable the feature. The next time the
>> vcpu is scheduled out/in, we start again. However the host key save is
>> optimized and implemented inside ptrauth instruction/register access
>> trap.
>>
>> Pointer authentication consists of address authentication and generic
>> authentication, and CPUs in a system might have varied support for
>> either. Where support for either feature is not uniform, it is hidden
>> from guests via ID register emulation, as a result of the cpufeature
>> framework in the host.
>>
>> Unfortunately, address authentication and generic authentication cannot
>> be trapped separately, as the architecture provides a single EL2 trap
>> covering both. If we wish to expose one without the other, we cannot
>> prevent a (badly-written) guest from intermittently using a feature
>> which is not uniformly supported (when scheduled on a physical CPU which
>> supports the relevant feature). Hence, this patch expects both type of
>> authentication to be present in a cpu.
>>
>> This switch of key is done from guest enter/exit assembly as preperation
>> for the upcoming in-kernel pointer authentication support. Hence, these
>> key switching routines are not implemented in C code as they may cause
>> pointer authentication key signing error in some situations.
> 
> 
>> diff --git a/arch/arm64/include/asm/kvm_ptrauth_asm.h b/arch/arm64/include/asm/kvm_ptrauth_asm.h
>> new file mode 100644
>> index 0000000..97bb040
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/kvm_ptrauth_asm.h
> 
>> +.macro	ptrauth_save_state base, reg1, reg2
>> +	mrs_s	\reg1, SYS_APIAKEYLO_EL1
>> +	mrs_s	\reg2, SYS_APIAKEYHI_EL1
>> +	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APIAKEYLO_EL1)]
> 
> A nice-to-have:
> Because you only use the 'LO' asm-offset definitions here, we have to just assume that the
> 'HI' ones are adjacent. Is it possible to add a BUILD_BUG() somewhere (probably in
> asm-offsets.c) to check this? As its just an enum we'd expect the order to be arbitrary,
> and asm-offsets to take care of any re-ordering... (struct randomisation may one day come
> to enums!)
Yes, seems this logic will fail with enum randomization. Adding any BUG 
in asm-offsets.c is not picked by the build system. I guess another 
approach would be to disable randomization for each key and define the 
enums as like below,
      enum vcpu_sysreg {
      ...
      APIAKEYLO_EL1,
      APIAKEYHI_EL1 = APIAKEYLO_EL1 + 1,
      APIBKEYLO_EL1,
      APIBKEYHI_EL1 = APIBKEYLO_EL1 + 1,
      ...
      }
This should be fine as each key size is 128 bit so LOW/HI key is placed 
together to access it as a unit.
> 
> 
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index e2f0268..9f591ad 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -544,3 +544,17 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>>   
>>   	return ret;
>>   }
>> +
>> +/**
>> + * kvm_arm_vcpu_ptrauth_setup_lazy - setup lazy ptrauth for vcpu schedule
>> + *
>> + * @vcpu: The VCPU pointer
>> + *
>> + * This function may be used to disable ptrauth and use it in a lazy context
>> + * via traps.
>> + */
>> +void kvm_arm_vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu)
>> +{
>> +	if (vcpu_has_ptrauth(vcpu))
>> +		kvm_arm_vcpu_ptrauth_disable(vcpu);
>> +}
> 
> Can you check my reasoning here, to make sure I've understood this properly?!:
> 
> This clears the API/APK bits to enable the traps, if the system supports ptrauth, and if
> Qemu requested it for this vcpu. If any of those things aren't true, the guest gets
> HCR_GUEST_FLAGS, which also has the API/APK bits clear...
> 
> What this is doing is clearing the API/APK bits that may have been left set by a previous
> run of a ptrauth-enabled vcpu.
Yes your description looks fine. Mark mentioned the benefit of this 
approach in earlier thread [1].

[1]: 
https://lore.kernel.org/lkml/20180309142838.uvcv3mhvqqlprktt@lakrids.cambridge.arm.com/
> 
> 
> 
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index f16a5f8..00f0639 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -128,6 +128,13 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>   	if (loaded)
>>   		kvm_arch_vcpu_put(vcpu);
>>
>> +	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
>> +		test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features)) {
>> +		/* Verify that KVM startup matches the conditions for ptrauth */
>> +		if (WARN_ON(!vcpu_has_ptrauth(vcpu)))
>> +			return -EINVAL;
>> +	}
> 
> Could this hunk go in the previous patch that added the vcpu definitions?
> It would be good if the uapi defines, the documentation and this validation logic came as
> one patch, it makes future archaeology easier!
ok it makes sense. I will update it in the next patch series.

Thanks,
Amit Daniel
> 
> 
> Looks good!
> 
> Thanks,
> 
> James
> 
