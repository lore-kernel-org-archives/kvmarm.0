From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: Re: [PATCH v7 7/10] KVM: arm/arm64: context-switch ptrauth registers
Date: Tue, 26 Mar 2019 18:01:44 +0000
Message-ID: <949327ae-081c-0964-3315-ac2695243b5f@arm.com>
References: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
 <1552984243-7689-8-git-send-email-amit.kachhap@arm.com>
 <64505666-8a1f-cf64-7067-4b2dd53b0b40@arm.com>
 <da7091a9-01b2-bead-3777-972fbb293def@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <da7091a9-01b2-bead-3777-972fbb293def@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 26/03/2019 04:03, Amit Daniel Kachhap wrote:
> Hi,
> 
> On 3/26/19 1:34 AM, Kristina Martsenko wrote:
>> On 19/03/2019 08:30, Amit Daniel Kachhap wrote:
>>> From: Mark Rutland <mark.rutland@arm.com>
>>>
>>> When pointer authentication is supported, a guest may wish to use it.
>>> This patch adds the necessary KVM infrastructure for this to work, with
>>> a semi-lazy context switch of the pointer auth state.
>>
>> [...]
>>
>>> +    if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
>>> +        test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features)) {
>>> +        /* Verify that KVM startup matches the conditions for ptrauth */
>>> +        if (WARN_ON(!vcpu_has_ptrauth(vcpu)))
>>> +            return -EINVAL;
>>> +    }
>>
>> I think this now needs to have "goto out;" instead of "return -EINVAL;",
>> since 5.1-rcX contains commit e761a927bc9a ("KVM: arm/arm64: Reset the
>> VCPU without preemption and vcpu state loaded") which changed some of
>> this code.
> ok missed the changes for this commit.

One more thing - I think the WARN_ON() here should be removed. Otherwise
if panic_on_warn is set then userspace can panic the kernel. I think
WARN_ON is only for internal kernel errors (see comment in
include/asm-generic/bug.h).

Thanks,
Kristina
