From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH v2 2/3] KVM: arm64: Convert lazy FPSIMD context switch
 trap to C
Date: Mon, 9 Apr 2018 11:00:40 +0100
Message-ID: <c1bbee2f-6087-c871-d68a-3d5ea84e0b8f@arm.com>
References: <1523026864-15413-1-git-send-email-Dave.Martin@arm.com>
 <1523026864-15413-3-git-send-email-Dave.Martin@arm.com>
 <5da0c912-8adb-db89-08b1-fb557b461678@arm.com>
 <20180406155151.GS16308@e103592.cambridge.arm.com>
 <20180409094433.GA10904@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180409094433.GA10904@cbox>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <cdall@kernel.org>, Dave Martin <Dave.Martin@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/04/18 10:44, Christoffer Dall wrote:
> On Fri, Apr 06, 2018 at 04:51:53PM +0100, Dave Martin wrote:
>> On Fri, Apr 06, 2018 at 04:25:57PM +0100, Marc Zyngier wrote:
>>> Hi Dave,
>>>
>>> On 06/04/18 16:01, Dave Martin wrote:
>>>> To make the lazy FPSIMD context switch trap code easier to hack on,
>>>> this patch converts it to C.
>>>>
>>>> This is not amazingly efficient, but the trap should typically only
>>>> be taken once per host context switch.
>>>>
>>>> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
>>>>
>>>> ---
>>>>
>>>> Since RFCv1:
>>>>
>>>>  * Fix indentation to be consistent with the rest of the file.
>>>>  * Add missing ! to write back to sp with attempting to push regs.
>>>> ---
>>>>  arch/arm64/kvm/hyp/entry.S  | 57 +++++++++++++++++----------------------------
>>>>  arch/arm64/kvm/hyp/switch.c | 24 +++++++++++++++++++
>>>>  2 files changed, 46 insertions(+), 35 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
>>>> index fdd1068..47c6a78 100644
>>>> --- a/arch/arm64/kvm/hyp/entry.S
>>>> +++ b/arch/arm64/kvm/hyp/entry.S
>>>> @@ -176,41 +176,28 @@ ENTRY(__fpsimd_guest_restore)
>>>>  	// x1: vcpu
>>>>  	// x2-x29,lr: vcpu regs
>>>>  	// vcpu x0-x1 on the stack
>>>> -	stp	x2, x3, [sp, #-16]!
>>>> -	stp	x4, lr, [sp, #-16]!
>>>> -
>>>> -alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
>>>> -	mrs	x2, cptr_el2
>>>> -	bic	x2, x2, #CPTR_EL2_TFP
>>>> -	msr	cptr_el2, x2
>>>> -alternative_else
>>>> -	mrs	x2, cpacr_el1
>>>> -	orr	x2, x2, #CPACR_EL1_FPEN
>>>> -	msr	cpacr_el1, x2
>>>> -alternative_endif
>>>> -	isb
>>>> -
>>>> -	mov	x3, x1
>>>> -
>>>> -	ldr	x0, [x3, #VCPU_HOST_CONTEXT]
>>>> -	kern_hyp_va x0
>>>> -	add	x0, x0, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
>>>> -	bl	__fpsimd_save_state
>>>> -
>>>> -	add	x2, x3, #VCPU_CONTEXT
>>>> -	add	x0, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
>>>> -	bl	__fpsimd_restore_state
>>>> -
>>>> -	// Skip restoring fpexc32 for AArch64 guests
>>>> -	mrs	x1, hcr_el2
>>>> -	tbnz	x1, #HCR_RW_SHIFT, 1f
>>>> -	ldr	x4, [x3, #VCPU_FPEXC32_EL2]
>>>> -	msr	fpexc32_el2, x4
>>>> -1:
>>>> -	ldp	x4, lr, [sp], #16
>>>> -	ldp	x2, x3, [sp], #16
>>>> -	ldp	x0, x1, [sp], #16
>>>> -
>>>> +	stp	x2, x3, [sp, #-144]!
>>>> +	stp	x4, x5, [sp, #16]
>>>> +	stp	x6, x7, [sp, #32]
>>>> +	stp	x8, x9, [sp, #48]
>>>> +	stp	x10, x11, [sp, #64]
>>>> +	stp	x12, x13, [sp, #80]
>>>> +	stp	x14, x15, [sp, #96]
>>>> +	stp	x16, x17, [sp, #112]
>>>> +	stp	x18, lr, [sp, #128]
>>>> +
>>>> +	bl	__hyp_switch_fpsimd
>>>> +
>>>> +	ldp	x4, x5, [sp, #16]
>>>> +	ldp	x6, x7, [sp, #32]
>>>> +	ldp	x8, x9, [sp, #48]
>>>> +	ldp	x10, x11, [sp, #64]
>>>> +	ldp	x12, x13, [sp, #80]
>>>> +	ldp	x14, x15, [sp, #96]
>>>> +	ldp	x16, x17, [sp, #112]
>>>> +	ldp	x18, lr, [sp, #128]
>>>> +	ldp	x0, x1, [sp, #144]
>>>> +	ldp	x2, x3, [sp], #160
>>>
>>> I can't say I'm overly thrilled with adding another save/restore 
>>> sequence. How about treating it like a real guest exit instead? Granted, 
>>> there is a bit more overhead to it, but as you pointed out above, this 
>>> should be pretty rare...
>>
>> I have no objection to handling this after exiting back to
>> __kvm_vcpu_run(), provided the performance is deemed acceptable.
>>
> 
> My guess is that it's going to be visible on non-VHE systems, and given
> that we're doing all of this for performance in the first place, I'm not
> exceited about that approach either.

My rational is that, as we don't disable FP access across most
exit/entry sequences, we still significantly benefit from the optimization.

> I thought it was acceptable to do another save/restore, because it was
> only the GPRs (and equivalent to what the compiler would generate for a
> function call?) and thus not susceptible to the complexities of sysreg
> save/restores.

Sysreg? That's not what I'm proposing. What I'm proposing here is that
we treat FP exception as a shallow exit that immediately returns to the
guest without touching them. The overhead is an extra save/restore of
the host's x19-x30, if I got my maths right. I agree that this is
significant, but I'd like to measure this overhead before we go one way
or the other.

> Another alternative would be to go back to Dave's original approach of
> implementing the fpsimd state update to the host's structure in assembly
> directly, but I was having a hard time understanding that.  Perhaps I
> just need to try harder.
I'd rather stick to the current C approach, no matter how we perform the
save/restore. It feels a lot more readable and maintainable in the long run.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
