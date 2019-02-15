From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v5 4/5] arm64/kvm: add a userspace option to enable
 pointer authentication
Date: Fri, 15 Feb 2019 10:19:38 +0530
Message-ID: <6f341bd4-299b-8cc5-2509-f3598a78e4c6@arm.com>
References: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
 <1548658727-14271-5-git-send-email-amit.kachhap@arm.com>
 <a9b22dcf-2238-344f-0b7b-b4a9de7c562c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B49AF4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Feb 2019 23:49:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VrWgd6lXNR2f for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Feb 2019 23:49:44 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 893E64A1DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Feb 2019 23:49:44 -0500 (EST)
In-Reply-To: <a9b22dcf-2238-344f-0b7b-b4a9de7c562c@arm.com>
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
To: Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 2/13/19 11:05 PM, Kristina Martsenko wrote:
> On 28/01/2019 06:58, Amit Daniel Kachhap wrote:
>> This feature will allow the KVM guest to allow the handling of
>> pointer authentication instructions or to treat them as undefined
>> if not set. It uses the existing vcpu API KVM_ARM_VCPU_INIT to
>> supply this parameter instead of creating a new API.
>>
>> A new register is not created to pass this parameter via
>> SET/GET_ONE_REG interface as just a flag (KVM_ARM_VCPU_PTRAUTH)
>> supplied is enough to enable this feature.
> 
> [...]
> 
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index b200c14..b6950df 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -346,6 +346,10 @@ static inline int kvm_arm_have_ssbd(void)
>>   static inline void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu) {}
>>   static inline void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu) {}
>>   static inline void kvm_arm_vcpu_ptrauth_reset(struct kvm_vcpu *vcpu) {}
>> +static inline bool kvm_arm_vcpu_ptrauth_allowed(struct kvm_vcpu *vcpu)
>> +{
>> +	return false;
>> +}
> 
> It seems like this is only ever called from arm64 code, so do we need an
> arch/arm/ definition?
Yes not required. Nice catch.
> 
>> +/**
>> + * kvm_arm_vcpu_ptrauth_allowed - checks if ptrauth feature is present in vcpu
>> + *
>> + * @vcpu: The VCPU pointer
>> + *
>> + * This function will be used to enable/disable ptrauth in guest as configured
>> + * by the KVM userspace API.
>> + */
>> +bool kvm_arm_vcpu_ptrauth_allowed(struct kvm_vcpu *vcpu)
>> +{
>> +	return test_bit(KVM_ARM_VCPU_PTRAUTH, vcpu->arch.features);
>> +}
> 
> I'm not sure, but should there also be something like
> 
> if (test_bit(KVM_ARM_VCPU_PTRAUTH, vcpu->arch.features) &&
>      !kvm_supports_ptrauth())
> 	return -EINVAL;
> 
> in kvm_reset_vcpu?
Yes makes sense. I missed it and with Dave martin patch this may be done 
cleanly.

Thanks,
Amit D

> 
> Thanks,
> Kristina
> 
