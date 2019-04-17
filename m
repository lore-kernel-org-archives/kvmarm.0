From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v9 1/5] KVM: arm64: Add a vcpu flag to control ptrauth for
 guest
Date: Wed, 17 Apr 2019 16:54:32 +0100
Message-ID: <a04c6bfd-fd6a-8ff9-a66a-3391af53afb5@arm.com>
References: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
 <1555039236-10608-2-git-send-email-amit.kachhap@arm.com>
 <eeeebc4d-f061-42a5-954d-40161bbed23a@arm.com>
 <ef1eb326-cd3a-4033-813d-ceae262b4e23@arm.com>
 <239c5d74-221e-cf8c-2c41-80db016bdc2b@arm.com>
 <20190417145255.GB3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190417145255.GB3567@e103592.cambridge.arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 17/04/2019 15:52, Dave Martin wrote:
> On Wed, Apr 17, 2019 at 03:19:11PM +0100, Marc Zyngier wrote:
>> On 17/04/2019 14:08, Amit Daniel Kachhap wrote:
>>> Hi,
>>>
>>> On 4/17/19 2:05 PM, Marc Zyngier wrote:
>>>> On 12/04/2019 04:20, Amit Daniel Kachhap wrote:
>>>>> A per vcpu flag is added to check if pointer authentication is
>>>>> enabled for the vcpu or not. This flag may be enabled according to
>>>>> the necessary user policies and host capabilities.
>>>>>
>>>>> This patch also adds a helper to check the flag.
>>>>>
>>>>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>>>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>>>>> Cc: kvmarm@lists.cs.columbia.edu
>>>>> ---
>>>>>
>>>>> Changes since v8:
>>>>> * Added a new per vcpu flag which will store Pointer Authentication enable
>>>>>    status instead of checking them again. [Dave Martin]
>>>>>
>>>>>   arch/arm64/include/asm/kvm_host.h | 4 ++++
>>>>>   1 file changed, 4 insertions(+)
>>>>>
>>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>>> index 9d57cf8..31dbc7c 100644
>>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>>> @@ -355,10 +355,14 @@ struct kvm_vcpu_arch {
>>>>>   #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
>>>>>   #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
>>>>>   #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
>>>>> +#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
>>>>>   
>>>>>   #define vcpu_has_sve(vcpu) (system_supports_sve() && \
>>>>>   			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
>>>>>   
>>>>> +#define vcpu_has_ptrauth(vcpu)	\
>>>>> +			((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH)
>>>>> +
>>>>
>>>> Just as for SVE, please first check that the system has PTRAUTH.
>>>> Something like:
>>>>
>>>> 		(cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH_ARCH) && \
>>>> 		 ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH))
>>>
>>> In the subsequent patches, vcpu->arch.flags is only set to 
>>> KVM_ARM64_GUEST_HAS_PTRAUTH when all host capability check conditions 
>>> matches such as system_supports_address_auth(), 
>>> system_supports_generic_auth() so doing them again is repetitive in my view.
>>
>> It isn't the setting of the flag I care about, but the check of that
>> flag. Checking a flag for a feature that cannot be used on the running
>> system should have a zero cost, which isn't the case here.
>>
>> Granted, the impact should be minimal and it looks like it mostly happen
>> on the slow path, but at the very least it would be consistent. So even
>> if you don't buy my argument about efficiency, please change it in the
>> name of consistency.
> 
> One of the annoyances here is there is no single static key for ptrauth.
> 
> I'm assuming we don't want to check both static keys (for address and
> generic auth) on hot paths.

They both just branches, so I don't see why not. Of course, for people
using a lesser compiler (gcc 4.8 or clang), things will suck. But they
got it coming anyway.

Thanks,

	M.

> Checking just one of the two possibilities is OK for now, but we need
> to comment clearly somewhere that that will break if KVM is changed
> later to expose ptrauth to guests when the host doesn't support both
> types.
> 
> Cheers
> ---Dave
> 


-- 
Jazz is not dead. It just smells funny...
