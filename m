From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Fix external abort type matching
Date: Fri, 27 Oct 2017 19:28:32 +0100
Message-ID: <86a80ca1in.fsf@arm.com>
References: <0184EA26B2509940AA629AE1405DD7F2016E999C@DGGEMA503-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0184EA26B2509940AA629AE1405DD7F2016E999C@DGGEMA503-MBS.china.huawei.com>
        (gengdongjiu@huawei.com's message of "Fri, 27 Oct 2017 15:43:26
        +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "james.morse@arm.com" <james.morse@arm.com>, "tbaicar@codeaurora.org" <tbaicar@codeaurora.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 27 2017 at  3:43:26 pm GMT, gengdongjiu <gengdongjiu@huawei.com> wrote:
>> 
>> On Thu, Oct 26 2017 at  6:07:01 pm BST, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
>> > For this matching, current code using the {I,D}FSC range to match
>> > kvm_vcpu_trap_get_fault_type() return value, but
>> > kvm_vcpu_trap_get_fault_type() only return the part {I,D}FSC instead
>> > of whole, so fix this issue
>> >
>> > Value       Type
>> > 0x10        FSC_SEA
>> > 0x14        FSC_SEA_TTW0 FSC_SEA_TTW1 FSC_SEA_TTW2 FSC_SEA_TTW3
>> > 0x18        FSC_SECC
>> > 0x1c        FSC_SECC_TTW0 FSC_SECC_TTW1 FSC_SECC_TTW2 FSC_SECC_TTW3
>> >
>> > CC: James Morse <james.morse@arm.com>
>> > CC: Tyler Baicar <tbaicar@codeaurora.org>
>> > Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>

[...]

>> > diff --git a/arch/arm64/include/asm/kvm_arm.h
>> > b/arch/arm64/include/asm/kvm_arm.h
>> > index 61d694c..c0f1798 100644
>> > --- a/arch/arm64/include/asm/kvm_arm.h
>> > +++ b/arch/arm64/include/asm/kvm_arm.h
>> > @@ -205,15 +205,9 @@
>> >  #define FSC_ACCESS	ESR_ELx_FSC_ACCESS
>> >  #define FSC_PERM	ESR_ELx_FSC_PERM
>> >  #define FSC_SEA		ESR_ELx_FSC_EXTABT
>> > -#define FSC_SEA_TTW0	(0x14)
>> > -#define FSC_SEA_TTW1	(0x15)
>> > -#define FSC_SEA_TTW2	(0x16)
>> > -#define FSC_SEA_TTW3	(0x17)
>> > +#define FSC_SEA_TTW	(0x14)
>> >  #define FSC_SECC	(0x18)
>> > -#define FSC_SECC_TTW0	(0x1c)
>> > -#define FSC_SECC_TTW1	(0x1d)
>> > -#define FSC_SECC_TTW2	(0x1e)
>> > -#define FSC_SECC_TTW3	(0x1f)
>> > +#define FSC_SECC_TTW	(0x1c)
>> >
>> >  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>> >  #define HPFAR_MASK	(~UL(0xf))
>> > diff --git a/arch/arm64/include/asm/kvm_emulate.h
>> > b/arch/arm64/include/asm/kvm_emulate.h
>> > index e5df3fc..5cde311 100644
>> > --- a/arch/arm64/include/asm/kvm_emulate.h
>> > +++ b/arch/arm64/include/asm/kvm_emulate.h
>> > @@ -239,15 +239,9 @@ static inline bool kvm_vcpu_dabt_isextabt(const
>> > struct kvm_vcpu *vcpu)  {
>> >  	switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
>> >  	case FSC_SEA:
>> > -	case FSC_SEA_TTW0:
>> > -	case FSC_SEA_TTW1:
>> > -	case FSC_SEA_TTW2:
>> > -	case FSC_SEA_TTW3:
>> > +	case FSC_SEA_TTW:
>> >  	case FSC_SECC:
>> > -	case FSC_SECC_TTW0:
>> > -	case FSC_SECC_TTW1:
>> > -	case FSC_SECC_TTW2:
>> > -	case FSC_SECC_TTW3:
>> > +	case FSC_SECC_TTW:
>> >  		return true;
>> >  	default:
>> >  		return false;
>> 
>> What is the bug you're fixing? From what I can tell, you're simply
>> removing valuable symbols from the kernel, and inventing another one
>> that doesn't exist in the architecture.
>
> Marc, I mean the "kvm_vcpu_trap_get_fault_type(vcpu))" return the
> value of fault type which is not the syndrome value {D,I}FSC.
> the case sentence matches the syndrome value instead of fault type.
> So the two are not match, I mean here has issue.
> So the FSC_SECC_TTW1/ FSC_SECC_TTW2/ FSC_SECC_TTW3 and FSC_SECC_TTW1/
> FSC_SECC_TTW2/ FSC_SECC_TTW3 are dead code.
>
> Below value are syndrome {D,I}FSC value, which is not fault type.
> FSC_SECC_TTW0:
> FSC_SECC_TTW1
> FSC_SECC_TTW2:
> FSC_SECC_TTW3:
> FSC_SEA_TTW1:
> FSC_SEA_TTW2
> FSC_SEA_TTW3:
>
> kvm_vcpu_trap_get_fault_type() will clear the low two bits to zero. So
> I use FSC_SEA_TTW represent "Synchronous external abort on translation
> table walk"

I understand that, and I certainly not keen on adding another "fault
type" for this.

> As we can see the Translation fault type "FSC_FAULT", which does not
> define the "FSC_FAULT0" "FSC_FAULT1" "FSC_FAULT2" "FSC_FAULT3".
> Because the fault type " FSC_FAULT " include the four cases. 

Indeed, and I'm still not convinced this is the best thing we have in
the code.

> static inline u8 kvm_vcpu_trap_get_fault(const struct kvm_vcpu *vcpu)
> {
> 	return kvm_vcpu_get_hsr(vcpu) & 0x3f;
> }

Here you go. This should give you a pretty good idea of how to provide a
proper fix.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
