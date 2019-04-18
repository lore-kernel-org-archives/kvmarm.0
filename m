From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v9 1/5] KVM: arm64: Add a vcpu flag to control ptrauth for
 guest
Date: Thu, 18 Apr 2019 09:48:14 +0100
Message-ID: <bec616ee-2765-4243-2108-84f3230c6aa0@arm.com>
References: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
 <1555039236-10608-2-git-send-email-amit.kachhap@arm.com>
 <eeeebc4d-f061-42a5-954d-40161bbed23a@arm.com>
 <ef1eb326-cd3a-4033-813d-ceae262b4e23@arm.com>
 <239c5d74-221e-cf8c-2c41-80db016bdc2b@arm.com>
 <20190417145255.GB3567@e103592.cambridge.arm.com>
 <a04c6bfd-fd6a-8ff9-a66a-3391af53afb5@arm.com>
 <20190417172010.GE3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190417172010.GE3567@e103592.cambridge.arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Daniel Kachhap <amit.kachhap@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 17/04/2019 18:20, Dave Martin wrote:
> On Wed, Apr 17, 2019 at 04:54:32PM +0100, Marc Zyngier wrote:
>> On 17/04/2019 15:52, Dave Martin wrote:
>>> On Wed, Apr 17, 2019 at 03:19:11PM +0100, Marc Zyngier wrote:
>>>> On 17/04/2019 14:08, Amit Daniel Kachhap wrote:
>>>>> Hi,
>>>>>
>>>>> On 4/17/19 2:05 PM, Marc Zyngier wrote:
>>>>>> On 12/04/2019 04:20, Amit Daniel Kachhap wrote:
>>>>>>> A per vcpu flag is added to check if pointer authentication is
>>>>>>> enabled for the vcpu or not. This flag may be enabled according to
>>>>>>> the necessary user policies and host capabilities.
>>>>>>>
>>>>>>> This patch also adds a helper to check the flag.
>>>>>>>
>>>>>>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>>>>>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>>>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>>>>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>>>>>>> Cc: kvmarm@lists.cs.columbia.edu
>>>>>>> ---
>>>>>>>
>>>>>>> Changes since v8:
>>>>>>> * Added a new per vcpu flag which will store Pointer Authentication enable
>>>>>>>    status instead of checking them again. [Dave Martin]
>>>>>>>
>>>>>>>   arch/arm64/include/asm/kvm_host.h | 4 ++++
>>>>>>>   1 file changed, 4 insertions(+)
>>>>>>>
>>>>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>>>>> index 9d57cf8..31dbc7c 100644
>>>>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>>>>> @@ -355,10 +355,14 @@ struct kvm_vcpu_arch {
>>>>>>>   #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
>>>>>>>   #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
>>>>>>>   #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
>>>>>>> +#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
>>>>>>>   
>>>>>>>   #define vcpu_has_sve(vcpu) (system_supports_sve() && \
>>>>>>>   			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
>>>>>>>   
>>>>>>> +#define vcpu_has_ptrauth(vcpu)	\
>>>>>>> +			((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH)
>>>>>>> +
>>>>>>
>>>>>> Just as for SVE, please first check that the system has PTRAUTH.
>>>>>> Something like:
>>>>>>
>>>>>> 		(cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH_ARCH) && \
>>>>>> 		 ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH))
>>>>>
>>>>> In the subsequent patches, vcpu->arch.flags is only set to 
>>>>> KVM_ARM64_GUEST_HAS_PTRAUTH when all host capability check conditions 
>>>>> matches such as system_supports_address_auth(), 
>>>>> system_supports_generic_auth() so doing them again is repetitive in my view.
>>>>
>>>> It isn't the setting of the flag I care about, but the check of that
>>>> flag. Checking a flag for a feature that cannot be used on the running
>>>> system should have a zero cost, which isn't the case here.
>>>>
>>>> Granted, the impact should be minimal and it looks like it mostly happen
>>>> on the slow path, but at the very least it would be consistent. So even
>>>> if you don't buy my argument about efficiency, please change it in the
>>>> name of consistency.
>>>
>>> One of the annoyances here is there is no single static key for ptrauth.
>>>
>>> I'm assuming we don't want to check both static keys (for address and
>>> generic auth) on hot paths.
>>
>> They both just branches, so I don't see why not. Of course, for people
>> using a lesser compiler (gcc 4.8 or clang), things will suck. But they
>> got it coming anyway.
> 
> I seem to recall Christoffer expressing concerns about this at some
> point: even unconditional branches branches to a fixed address are not
> free (or even correctly predicted).

Certainly not free, but likely less expensive than a load followed by a
conditional branch. And actually, this is not a comparison against a branch,
but against a nop.

> I don't think any compiler can elide static key checks of merge them
> together.

It is not about eliding them, it is about having a cheap fast path.

Compiling this:

bool kvm_hack_test_static_key(struct kvm_vcpu *vcpu)
{
	return ((system_supports_address_auth() ||
		 system_supports_generic_auth()) &&
		vcpu->arch.flags & (1 << 6));

}

I get:

[...]
ffff0000100db5c8:       1400000c        b       ffff0000100db5f8 <kvm_hack_test_static_key+0x48>
ffff0000100db5cc:       d503201f        nop
ffff0000100db5d0:       14000012        b       ffff0000100db618 <kvm_hack_test_static_key+0x68>
ffff0000100db5d4:       d503201f        nop
ffff0000100db5d8:       14000014        b       ffff0000100db628 <kvm_hack_test_static_key+0x78>
ffff0000100db5dc:       d503201f        nop
ffff0000100db5e0:       14000017        b       ffff0000100db63c <kvm_hack_test_static_key+0x8c>
ffff0000100db5e4:       d503201f        nop
ffff0000100db5e8:       52800000        mov     w0, #0x0                        // #0
ffff0000100db5ec:       f9400bf3        ldr     x19, [sp, #16]
ffff0000100db5f0:       a8c27bfd        ldp     x29, x30, [sp], #32
ffff0000100db5f4:       d65f03c0        ret
ffff0000100db5f8:       b000ac40        adrp    x0, ffff000011664000 <reset_devices>
ffff0000100db5fc:       f942a400        ldr     x0, [x0, #1352]
ffff0000100db600:       b637fe80        tbz     x0, #38, ffff0000100db5d0 <kvm_hack_test_static_key+0x20>
ffff0000100db604:       f9441660        ldr     x0, [x19, #2088]
ffff0000100db608:       f9400bf3        ldr     x19, [sp, #16]
ffff0000100db60c:       53061800        ubfx    w0, w0, #6, #1
ffff0000100db610:       a8c27bfd        ldp     x29, x30, [sp], #32
ffff0000100db614:       d65f03c0        ret
ffff0000100db618:       b000ac40        adrp    x0, ffff000011664000 <reset_devices>
ffff0000100db61c:       f942a400        ldr     x0, [x0, #1352]
ffff0000100db620:       b73fff20        tbnz    x0, #39, ffff0000100db604 <kvm_hack_test_static_key+0x54>
ffff0000100db624:       17ffffed        b       ffff0000100db5d8 <kvm_hack_test_static_key+0x28>
ffff0000100db628:       b000ac40        adrp    x0, ffff000011664000 <reset_devices>
ffff0000100db62c:       f942a400        ldr     x0, [x0, #1352]
ffff0000100db630:       b747fea0        tbnz    x0, #40, ffff0000100db604 <kvm_hack_test_static_key+0x54>
ffff0000100db634:       14000002        b       ffff0000100db63c <kvm_hack_test_static_key+0x8c>
ffff0000100db638:       17ffffeb        b       ffff0000100db5e4 <kvm_hack_test_static_key+0x34>
ffff0000100db63c:       b000ac40        adrp    x0, ffff000011664000 <reset_devices>
ffff0000100db640:       f942a400        ldr     x0, [x0, #1352]
ffff0000100db644:       b74ffe00        tbnz    x0, #41, ffff0000100db604 <kvm_hack_test_static_key+0x54>
ffff0000100db648:       52800000        mov     w0, #0x0                        // #0
ffff0000100db64c:       17ffffe8        b       ffff0000100db5ec <kvm_hack_test_static_key+0x3c>

Once the initial 4 branches that are there to deal with the pre static 
keys checks are nop-ed, everything is controlled by the remaining 4
nops which are turned into branches to ffff0000100db604 if any of the 
conditions become true.

Which is exactly what we want: a fall through to returning zero without
doing anything else.

Thanks,

	M.

> Maybe I am misremembering.
> 
> Cheers
> ---Dave
> 


-- 
Jazz is not dead. It just smells funny...
