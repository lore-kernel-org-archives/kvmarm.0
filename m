From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 01/36] KVM: arm64: Avoid storing the vcpu pointer on
 the stack
Date: Mon, 11 Dec 2017 09:35:35 +0000
Message-ID: <7cc8d962-fd4b-30da-a311-ef464e8e1182@arm.com>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-2-christoffer.dall@linaro.org>
 <868tebstsi.wl-marc.zyngier@arm.com> <20171211093031.GF910@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171211093031.GF910@cbox>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 11/12/17 09:30, Christoffer Dall wrote:
> On Sat, Dec 09, 2017 at 05:19:41PM +0000, Marc Zyngier wrote:
>> On Thu, 07 Dec 2017 17:05:55 +0000,
>> Christoffer Dall wrote:
>>>
>>> We already have the percpu area for the host cpu state, which points to
>>> the VCPU, so there's no need to store the VCPU pointer on the stack on
>>> every context switch.  We can be a little more clever and just use
>>> tpidr_el2 for the percpu offset and load the VCPU pointer from the host
>>> context.
>>>
>>> This does require us to calculate the percpu offset without including
>>> the offset from the kernel mapping of the percpu array to the linaro
>>
>> "linaro"?
>>
> 
> *linear* - spell check must have played a trick on me.
> 
>>> mapping of the array (which is what we store in tpidr_el1), because a
>>> PC-relative generated address in EL2 is already giving us the hyp alias
>>> of the linear mapping of a kernel address.  We do this in
>>> __cpu_init_hyp_mode() by using kvm_ksym_ref().
>>>
>>> This change also requires us to have a scratch register, so we take the
>>> chance to rearrange some of the el1_sync code to only look at the
>>> vttbr_el2 to determine if this is a trap from the guest or an HVC from
>>> the host.  We do add an extra check to call the panic code if the kernel
>>> is configured with debugging enabled and we saw a trap from the host
>>> which wasn't an HVC, indicating that we left some EL2 trap configured by
>>> mistake.
>>>
>>> The code that accesses ESR_EL2 was previously using an alternative to
>>> use the _EL1 accessor on VHE systems, but this was actually unnecessary
>>> as the _EL1 accessor aliases the ESR_EL2 register on VHE, and the _EL2
>>> accessor does the same thing on both systems.
>>>
>>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>> ---
>>>
>>> Notes:
>>>     Changes since v1:
>>>      - Use PC-relative addressing to access per-cpu variables instead of
>>>        using a load from the literal pool.
>>>      - Remove stale comments as pointed out by Marc
>>>      - Reworded the commit message as suggested by Drew
>>>
>>>  arch/arm64/include/asm/kvm_asm.h  | 15 ++++++++++++++
>>>  arch/arm64/include/asm/kvm_host.h | 15 ++++++++++++++
>>>  arch/arm64/kernel/asm-offsets.c   |  1 +
>>>  arch/arm64/kvm/hyp/entry.S        |  6 +-----
>>>  arch/arm64/kvm/hyp/hyp-entry.S    | 41 ++++++++++++++++++---------------------
>>>  arch/arm64/kvm/hyp/switch.c       |  5 +----
>>>  arch/arm64/kvm/hyp/sysreg-sr.c    |  5 +++++
>>>  7 files changed, 57 insertions(+), 31 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
>>> index ab4d0a926043..33e0edc6f8be 100644
>>> --- a/arch/arm64/include/asm/kvm_asm.h
>>> +++ b/arch/arm64/include/asm/kvm_asm.h
>>> @@ -33,6 +33,7 @@
>>>  #define KVM_ARM64_DEBUG_DIRTY_SHIFT	0
>>>  #define KVM_ARM64_DEBUG_DIRTY		(1 << KVM_ARM64_DEBUG_DIRTY_SHIFT)
>>>  
>>> +/* Translate a kernel address of @sym into its equivalent linear mapping */
>>>  #define kvm_ksym_ref(sym)						\
>>>  	({								\
>>>  		void *val = &sym;					\
>>> @@ -70,4 +71,18 @@ extern u32 __init_stage2_translation(void);
>>>  
>>>  #endif
>>>  
>>> +#ifdef __ASSEMBLY__
>>
>> You could turn this and the previous #endif into a simple #else.
>>
> 
> yup
> 
>>> +.macro get_host_ctxt reg, tmp
>>> +	adr_l	\reg, kvm_host_cpu_state
>>> +	mrs	\tmp, tpidr_el2
>>> +	add	\reg, \reg, \tmp
>>> +.endm
>>> +
>>> +.macro get_vcpu vcpu, ctxt
>>> +	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
>>> +	kern_hyp_va	\vcpu
>>> +.endm
>>> +
>>> +#endif
>>> +
>>>  #endif /* __ARM_KVM_ASM_H__ */
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index 7ee72b402907..af58deb6ec3c 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -348,10 +348,15 @@ int kvm_perf_teardown(void);
>>>  
>>>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
>>>  
>>> +extern void __kvm_set_tpidr_el2(u64 tpidr_el2);
>>
>> Is there any advantage in having this prototype in kvm_host.h, instead
>> of putting it in kvm_hyp.h (which feels more appropriate)?
>>
> 
> asm-offsets.c pukes all over the place and I can't include asm/kvm_hyp.h
> from kvm_host.h, because it depends on kvm_host.h, and I can't include
> asm/kvm_hyp.h easily in asm-offsets.c because it pukes again from all
> sorts of other missing things.
> 
> If you care strongly about this point, I can try to dig deeper in this
> or refactor this somehow more substantially.  Ideas?

Yeah. I've fixed a couple of the asm-offsets crap (see my randomization
series), but it is really not worth adding a dependency on that. Forget
about it for now, we'll address it at a later time, if ever.

Thanks,

	M./
-- 
Jazz is not dead. It just smells funny...
