From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v7 7/10] KVM: arm/arm64: context-switch ptrauth registers
Date: Thu, 28 Mar 2019 16:59:17 +0530
Message-ID: <8c38a9fe-8310-4903-7042-e8b5eb3b5f1b@arm.com>
References: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
 <1552984243-7689-8-git-send-email-amit.kachhap@arm.com>
 <64505666-8a1f-cf64-7067-4b2dd53b0b40@arm.com>
 <da7091a9-01b2-bead-3777-972fbb293def@arm.com>
 <949327ae-081c-0964-3315-ac2695243b5f@arm.com>
 <536f518d-5425-cb94-3f64-4c56e5cd65c1@arm.com>
 <13ab02cf-db27-d604-6e5f-d276dec0779b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <13ab02cf-db27-d604-6e5f-d276dec0779b@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu


Hi James,
On 3/27/19 11:46 PM, James Morse wrote:
> Hi Amit, Kristina,
> 
> On 27/03/2019 03:21, Amit Daniel Kachhap wrote:
>> On 3/26/19 11:31 PM, Kristina Martsenko wrote:
>>> On 26/03/2019 04:03, Amit Daniel Kachhap wrote:
>>>> On 3/26/19 1:34 AM, Kristina Martsenko wrote:
>>>>> On 19/03/2019 08:30, Amit Daniel Kachhap wrote:
>>>>>> From: Mark Rutland <mark.rutland@arm.com>
>>>>>>
>>>>>> When pointer authentication is supported, a guest may wish to use it.
>>>>>> This patch adds the necessary KVM infrastructure for this to work, with
>>>>>> a semi-lazy context switch of the pointer auth state.
> 
>>>>>> +    if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
>>>>>> +        test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features)) {>>>>> +        /* Verify that KVM startup matches the conditions for ptrauth */
>>>>>> +        if (WARN_ON(!vcpu_has_ptrauth(vcpu)))
>>>>>> +            return -EINVAL;
>>>>>> +    }
> 
>>> One more thing - I think the WARN_ON() here should be removed. Otherwise
>>> if panic_on_warn is set then userspace can panic the kernel. I think
>>> WARN_ON is only for internal kernel errors (see comment in
>>> include/asm-generic/bug.h).
>>
>> The documentation makes sense so in this case a pr_err like message will suffice.
> 
> (could it be a kvm_debug() at most?)
> 
> Do we need to print anything at all? User-space asked us for something we can't do.
> Filling up the kernel log with user-space's mistakes makes it harder to debug the kernel
> when something goes wrong.
> 
> kvm_arm_pmu_v3_init() returns -ENODEV if you ask if for the PMU and the platform can't
> support it. Isn't the returned error enough?
Yes Agree that most of the time the user invoked functions are just 
returned with error value in case of failure. Thanks for the details.

Regards,
Amit D
> 
> 
>> Btw
>> there is one WARN in the function kvm_set_ipa_limit in the same file.
> 
> That is called once via kvm_arch_init(), it can't be triggered repeatedly from user-space.
> 
> 
> Thanks,
> 
> James
> 
