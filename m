From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH] arm64: KVM: Optimize arm64 guest exit VFP/SIMD register
 save/restore
Date: Mon, 15 Jun 2015 11:04:21 -0700
Message-ID: <557F13A5.9030603@samsung.com>
References: <557CACC4.8040405@samsung.com> <557EA23D.4090200@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <557EA23D.4090200@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/15/2015 03:00 AM, Marc Zyngier wrote:
> Hi Mario,
> 
> I was working on a more ambitious patch series, 
> but we probably ought to
> start small, and this looks fairly sensible to me.

Hi Marc,
   thanks for reviewing, I was thinking to post this
first and next iteration on guest access switch
back to host registers only upon  return to user space or
vCPU context switch. This should save more cycles for
various exits.

Were you thinking along the same lines or something
altogether different?

> 
> A few minor comments below.
> 
> On 13/06/15 23:20, Mario Smarduch wrote:
>> Currently VFP/SIMD registers are always saved and restored
>> on Guest entry and exit.
>>
>> This patch only saves and restores VFP/SIMD registers on
>> Guest access. To do this cptr_el2 VFP/SIMD trap is set
>> on Guest entry and later checked on exit. This follows
>> the ARMv7 VFPv3 implementation. Running an informal test
>> there are high number of exits that don't access VFP/SIMD
>> registers.
> 
> It would be good to add some numbers here. How often do we exit without
> having touched the FPSIMD regs? For which workload?

Lmbench is what I typically use, with ssh server, i.e., cause page
faults and interrupts - usually registers are not touched.
I'll run the tests again and define usually.

Any other loads you had in mind?

> 
>> Tested on FVP Model, executed threads on host and
>> Guest accessing VFP/SIMD registers resulting in consistent
>> results.
>>
>>
>> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
>> ---
>>  arch/arm64/include/asm/kvm_arm.h |  5 +++-
>>  arch/arm64/kvm/hyp.S             | 57
>> +++++++++++++++++++++++++++++++++++++---
>>  2 files changed, 57 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_arm.h
>> b/arch/arm64/include/asm/kvm_arm.h
>> index ac6fafb..7605e09 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -171,10 +171,13 @@
>>  #define HSTR_EL2_TTEE	(1 << 16)
>>  #define HSTR_EL2_T(x)	(1 << x)
>>
>> +/* Hyp Coproccessor Trap Register Shifts */
>> +#define CPTR_EL2_TFP_SHIFT 10
>> +
>>  /* Hyp Coprocessor Trap Register */
>>  #define CPTR_EL2_TCPAC	(1 << 31)
>>  #define CPTR_EL2_TTA	(1 << 20)
>> -#define CPTR_EL2_TFP	(1 << 10)
>> +#define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)
>>
>>  /* Hyp Debug Configuration Register bits */
>>  #define MDCR_EL2_TDRA		(1 << 11)
>> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
>> index 5befd01..b3044b4 100644
>> --- a/arch/arm64/kvm/hyp.S
>> +++ b/arch/arm64/kvm/hyp.S
>> @@ -673,6 +673,24 @@
>>  	tbz	\tmp, #KVM_ARM64_DEBUG_DIRTY_SHIFT, \target
>>  .endm
>>
>> +/*
>> + * Check cptr VFP/SIMD accessed bit, if set VFP/SIMD not accessed by guest.
>> + */
>> +.macro skip_fpsimd_state tmp, target
>> +	mrs	\tmp, cptr_el2
>> +	tbnz	\tmp, #CPTR_EL2_TFP_SHIFT, \target
>> +.endm
>> +
>> +/*
>> + * Check cptr VFP/SIMD accessed bit if set, VFP/SIMD not accessed by guest.
>> + * Also disable all cptr traps on return to host.
>> + */
>> +.macro skip_fpsimd_state_reset tmp, target
>> +	mrs	\tmp, cptr_el2
>> +	msr	cptr_el2, xzr
>> +	tbnz	\tmp, #CPTR_EL2_TFP_SHIFT, \target
>> +.endm
>> +
>>  .macro compute_debug_state target
>>  	// Compute debug state: If any of KDE, MDE or KVM_ARM64_DEBUG_DIRTY
>>  	// is set, we do a full save/restore cycle and disable trapping.
>> @@ -763,6 +781,7 @@
>>  	ldr     x2, [x0, #VCPU_HCR_EL2]
>>  	msr     hcr_el2, x2
>>  	mov	x2, #CPTR_EL2_TTA
>> +	orr	x2, x2, #CPTR_EL2_TFP
>>  	msr	cptr_el2, x2
>>
>>  	mov	x2, #(1 << 15)	// Trap CP15 Cr=15
>> @@ -785,7 +804,6 @@
>>  .macro deactivate_traps
>>  	mov	x2, #HCR_RW
>>  	msr	hcr_el2, x2
>> -	msr	cptr_el2, xzr
>>  	msr	hstr_el2, xzr
>>
>>  	mrs	x2, mdcr_el2
>> @@ -911,6 +929,30 @@ __save_fpsimd:
>>  __restore_fpsimd:
>>  	restore_fpsimd
>>  	ret
>> +/*
>> + * On Guest VFP/SIMD access, switch Guest/Host registers and reset cptr
>> access
>> + * bit to disable trapping.
>> + */
>> +switch_to_guest_vfp:
> 
> Consider renaming this to "switch_to_guest_fpsimd" for consistency.
> 
>> +	ldr	x2, =(CPTR_EL2_TTA)
>> +	msr	cptr_el2, x2
> 
> I'd feel more comfortable if you read cptr_el2, cleared the TFP bit, and
> wrote the result back. Loading an arbitrary value is likely to cause
> bugs in the long run.
Yep will do.
> 
>> +
>> +	mrs	x0, tpidr_el2
>> +
>> +	ldr	x2, [x0, #VCPU_HOST_CONTEXT]
>> +	kern_hyp_va x2
>> +
>> +	add	x3, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
>> +	fpsimd_save x3, 1
>> +
>> +	add	x2, x0, #VCPU_CONTEXT
>> +	add	x3, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
>> +	fpsimd_restore x3, 1
> 
> That's quite a lot of code expansion (fpsimd_{save,restore} are macros).
> 
> How about saving x4 and lr on the stack, and doing a a bl in each case?
> That would be consistent with the rest of the code (well, what's left of
> it).

Yeah, will change needed help/feedback on this.
> 
>> +
>> +	pop	x2, x3
>> +	pop	x0, x1
>> +
>> +	eret
>>
>>  /*
>>   * u64 __kvm_vcpu_run(struct kvm_vcpu *vcpu);
>> @@ -932,7 +974,6 @@ ENTRY(__kvm_vcpu_run)
>>  	kern_hyp_va x2
>>
>>  	save_host_regs
>> -	bl __save_fpsimd
>>  	bl __save_sysregs
>>
>>  	compute_debug_state 1f
>> @@ -948,7 +989,6 @@ ENTRY(__kvm_vcpu_run)
>>  	add	x2, x0, #VCPU_CONTEXT
>>
>>  	bl __restore_sysregs
>> -	bl __restore_fpsimd
>>
>>  	skip_debug_state x3, 1f
>>  	bl	__restore_debug
>> @@ -967,7 +1007,9 @@ __kvm_vcpu_return:
>>  	add	x2, x0, #VCPU_CONTEXT
>>
>>  	save_guest_regs
>> +	skip_fpsimd_state x3, 1f
>>  	bl __save_fpsimd
>> +1:
>>  	bl __save_sysregs
>>
>>  	skip_debug_state x3, 1f
>> @@ -986,8 +1028,11 @@ __kvm_vcpu_return:
>>  	kern_hyp_va x2
>>
>>  	bl __restore_sysregs
>> -	bl __restore_fpsimd
>>
>> +	/* Disable cptr VFP/SIMD access bit, skip restore if VFP not accessed */
>> +	skip_fpsimd_state_reset x3, 1f
>> +	bl __restore_fpsimd
>> +1:
> 
> Neither the macro name (skip_fpsimd_state_reset) nor the comment make it
> clear that it is also re-enabling access to the trace registers.
> 
> I'd rather see:
> 
> 	skip_fpsimd_state x3, 1f
> 	bl __restore_fpsimd
> 1:
> 	/* Clear FPSIMD and Trace trapping */
> 	msr	cptr_el2, xzr

Will do.

> 
>>  	skip_debug_state x3, 1f
>>  	// Clear the dirty flag for the next run, as all the state has
>>  	// already been saved. Note that we nuke the whole 64bit word.
>> @@ -1166,6 +1211,10 @@ el1_sync:					// Guest trapped into EL2
>>  	mrs	x1, esr_el2
>>  	lsr	x2, x1, #ESR_ELx_EC_SHIFT
>>
>> +	/* Guest accessed VFP/SIMD registers, save host, restore Guest */
>> +	cmp	x2, #ESR_ELx_EC_FP_ASIMD
>> +	b.eq	switch_to_guest_vfp
>> +
> 
> I'd prefer you moved that hunk to el1_trap, where we handle all the
> traps coming from the guest.

I'm thinking would it make sense to update the armv7 side as
well. When reading both exit handlers the flow mirrors
each other.

Thanks,
   Mario
> 
>>  	cmp	x2, #ESR_ELx_EC_HVC64
>>  	b.ne	el1_trap
>>
> 
> Thanks,
> 
> 	M.
> 

