From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 08/37] KVM: arm64: Defer restoring host VFP state to
 vcpu_put
Date: Thu, 30 Nov 2017 19:07:36 +0000
Message-ID: <9c050311-16dc-7459-6c87-76400c6997e4@arm.com>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-9-christoffer.dall@linaro.org>
 <20171125075221.oj5euwo7hnktxxsj@yury-thinkpad> <20171126161716.GK28855@cbox>
 <20171126185852.bjte7raycorctft2@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171126185852.bjte7raycorctft2@yury-thinkpad>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Yury Norov <ynorov@caviumnetworks.com>, Christoffer Dall <cdall@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 26/11/17 18:58, Yury Norov wrote:
> On Sun, Nov 26, 2017 at 05:17:16PM +0100, Christoffer Dall wrote:
>> Hi Yury,
>>
>> On Sat, Nov 25, 2017 at 10:52:21AM +0300, Yury Norov wrote:
>>>
>>> On Thu, Oct 12, 2017 at 12:41:12PM +0200, Christoffer Dall wrote:
>>>> Avoid saving the guest VFP registers and restoring the host VFP
>>>> registers on every exit from the VM.  Only when we're about to run
>>>> userspace or other threads in the kernel do we really have to switch the
>>>> state back to the host state.
>>>>
>>>> We still initially configure the VFP registers to trap when entering the
>>>> VM, but the difference is that we now leave the guest state in the
>>>> hardware registers while running the VM.
>>>>
>>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>>> ---
>>>>  arch/arm64/include/asm/kvm_emulate.h |  5 ++++
>>>>  arch/arm64/include/asm/kvm_host.h    |  3 +++
>>>>  arch/arm64/kernel/asm-offsets.c      |  1 +
>>>>  arch/arm64/kvm/hyp/entry.S           |  3 +++
>>>>  arch/arm64/kvm/hyp/switch.c          | 47 +++++++++++-------------------------
>>>>  arch/arm64/kvm/hyp/sysreg-sr.c       | 21 +++++++++++++---
>>>>  6 files changed, 44 insertions(+), 36 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>>>> index 1fbfe96..630dd60 100644
>>>> --- a/arch/arm64/include/asm/kvm_emulate.h
>>>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>>>> @@ -56,6 +56,11 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
>>>>  	return (unsigned long *)&vcpu->arch.hcr_el2;
>>>>  }
>>>>  
>>>> +static inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	return (!(vcpu->arch.hcr_el2 & HCR_RW));
>>>> +}
>>>> +
>>>>  static inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
>>>>  {
>>>>  	return (unsigned long *)&vcpu_gp_regs(vcpu)->regs.pc;
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>> index 7d3bfa7..5e09eb9 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -210,6 +210,9 @@ struct kvm_vcpu_arch {
>>>>  	/* Guest debug state */
>>>>  	u64 debug_flags;
>>>>  
>>>> +	/* 1 if the guest VFP state is loaded into the hardware */
>>>> +	u64 guest_vfp_loaded;
>>>
>>> May it be just u8/bool?
>>>
>> This particular field is accessed from assembly code, and I'm not sure
>> what guarantees the compiler makes in terms of how a u8/bool is
>> allocated with respect to padding and alignment, and I think that's why
>> we've been using u64 fields in the past.
>>
>> I don't actually remember the details, but I'd rather err on the side of
>> caution than trying to save a few bytes.  However, if someone can
>> convince me there's a completely safe way to do this, then I'm happy to
>> change it.
> 
> 'strb     w0, [x3, #VCPU_GUEST_VFP_LOADED]' would work. See
> C6.6.181 STRB (register) in ARM64 ARM.
> 
> The only thing I would recommend is to reorder fields in kvm_vcpu_arch
> to avoid unneeded holes in the structure. It already spend 10 bytes for
> nothing in 3 holes.

Terrifying. How many vcpu are you going to run before this becomes a
real bottleneck? KVM on a 6502? ;-)

Now, when it comes to reordering fields, please keep in mind that the
order of the fields in the structure does matter. We want the hottest
fields grouped together so that they are fetched in the same cache line.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
