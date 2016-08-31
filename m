From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3] arm64: KVM: Optimize __guest_enter/exit() to save a
 few instructions
Date: Wed, 31 Aug 2016 12:11:34 +0200
Message-ID: <20160831101134.GN10162@cbox>
References: <1472609312-569-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1925449B42
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Aug 2016 06:01:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BvzFnjtJfCP2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Aug 2016 06:01:08 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5408E49B32
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Aug 2016 06:01:08 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id i5so80276271wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Aug 2016 03:09:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1472609312-569-1-git-send-email-shankerd@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 30, 2016 at 09:08:32PM -0500, Shanker Donthineni wrote:
> We are doing an unnecessary stack push/pop operation when restoring
> the guest registers x0-x18 in __guest_enter(). This patch saves the
> two instructions by using x18 as a base register. No need to store
> the vcpu context pointer in stack because it is redundant, the same
> information is available in tpidr_el2. The function __guest_exit()
> calling convention is slightly modified, caller only pushes the regs
> x0-x1 to stack instead of regs x0-x3.
> 
> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Applied, thanks.

-Christoffer


> ---
> Tested this patch using the Qualcomm QDF24XXX platform.
> 
> Changes since v2:
>   Removed macros save_x0_to_x3/restore_x0_to_x3.
>   Modified el1_sync() to use regs x0 and x1.
>   Edited commit text.
> 
> Changes since v1:
>   Incorporated Cristoffer suggestions.
>   __guest_exit prototype is changed to 'void __guest_exit(u64 reason, struct kvm_vcpu *vcpu)'.
> 
>  arch/arm64/kvm/hyp/entry.S     | 101 ++++++++++++++++++++---------------------
>  arch/arm64/kvm/hyp/hyp-entry.S |  37 ++++++---------
>  2 files changed, 63 insertions(+), 75 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index ce9e5e5..3967c231 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -55,79 +55,78 @@
>   */
>  ENTRY(__guest_enter)
>  	// x0: vcpu
> -	// x1: host/guest context
> -	// x2-x18: clobbered by macros
> +	// x1: host context
> +	// x2-x17: clobbered by macros
> +	// x18: guest context
>  
>  	// Store the host regs
>  	save_callee_saved_regs x1
>  
> -	// Preserve vcpu & host_ctxt for use at exit time
> -	stp	x0, x1, [sp, #-16]!
> +	// Store the host_ctxt for use at exit time
> +	str	x1, [sp, #-16]!
>  
> -	add	x1, x0, #VCPU_CONTEXT
> +	add	x18, x0, #VCPU_CONTEXT
>  
> -	// Prepare x0-x1 for later restore by pushing them onto the stack
> -	ldp	x2, x3, [x1, #CPU_XREG_OFFSET(0)]
> -	stp	x2, x3, [sp, #-16]!
> +	// Restore guest regs x0-x17
> +	ldp	x0, x1,   [x18, #CPU_XREG_OFFSET(0)]
> +	ldp	x2, x3,   [x18, #CPU_XREG_OFFSET(2)]
> +	ldp	x4, x5,   [x18, #CPU_XREG_OFFSET(4)]
> +	ldp	x6, x7,   [x18, #CPU_XREG_OFFSET(6)]
> +	ldp	x8, x9,   [x18, #CPU_XREG_OFFSET(8)]
> +	ldp	x10, x11, [x18, #CPU_XREG_OFFSET(10)]
> +	ldp	x12, x13, [x18, #CPU_XREG_OFFSET(12)]
> +	ldp	x14, x15, [x18, #CPU_XREG_OFFSET(14)]
> +	ldp	x16, x17, [x18, #CPU_XREG_OFFSET(16)]
>  
> -	// x2-x18
> -	ldp	x2, x3,   [x1, #CPU_XREG_OFFSET(2)]
> -	ldp	x4, x5,   [x1, #CPU_XREG_OFFSET(4)]
> -	ldp	x6, x7,   [x1, #CPU_XREG_OFFSET(6)]
> -	ldp	x8, x9,   [x1, #CPU_XREG_OFFSET(8)]
> -	ldp	x10, x11, [x1, #CPU_XREG_OFFSET(10)]
> -	ldp	x12, x13, [x1, #CPU_XREG_OFFSET(12)]
> -	ldp	x14, x15, [x1, #CPU_XREG_OFFSET(14)]
> -	ldp	x16, x17, [x1, #CPU_XREG_OFFSET(16)]
> -	ldr	x18,      [x1, #CPU_XREG_OFFSET(18)]
> -
> -	// x19-x29, lr
> -	restore_callee_saved_regs x1
> -
> -	// Last bits of the 64bit state
> -	ldp	x0, x1, [sp], #16
> +	// Restore guest regs x19-x29, lr
> +	restore_callee_saved_regs x18
> +
> +	// Restore guest reg x18
> +	ldr	x18,      [x18, #CPU_XREG_OFFSET(18)]
>  
>  	// Do not touch any register after this!
>  	eret
>  ENDPROC(__guest_enter)
>  
>  ENTRY(__guest_exit)
> -	// x0: vcpu
> -	// x1: return code
> -	// x2-x3: free
> -	// x4-x29,lr: vcpu regs
> -	// vcpu x0-x3 on the stack
> -
> -	add	x2, x0, #VCPU_CONTEXT
> -
> -	stp	x4, x5,   [x2, #CPU_XREG_OFFSET(4)]
> -	stp	x6, x7,   [x2, #CPU_XREG_OFFSET(6)]
> -	stp	x8, x9,   [x2, #CPU_XREG_OFFSET(8)]
> -	stp	x10, x11, [x2, #CPU_XREG_OFFSET(10)]
> -	stp	x12, x13, [x2, #CPU_XREG_OFFSET(12)]
> -	stp	x14, x15, [x2, #CPU_XREG_OFFSET(14)]
> -	stp	x16, x17, [x2, #CPU_XREG_OFFSET(16)]
> -	str	x18,      [x2, #CPU_XREG_OFFSET(18)]
> -
> -	ldp	x6, x7, [sp], #16	// x2, x3
> -	ldp	x4, x5, [sp], #16	// x0, x1
> -
> -	stp	x4, x5, [x2, #CPU_XREG_OFFSET(0)]
> -	stp	x6, x7, [x2, #CPU_XREG_OFFSET(2)]
> +	// x0: return code
> +	// x1: vcpu
> +	// x2-x29,lr: vcpu regs
> +	// vcpu x0-x1 on the stack
> +
> +	add	x1, x1, #VCPU_CONTEXT
> +
> +	// Store the guest regs x2 and x3
> +	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(2)]
> +
> +	// Retrieve the guest regs x0-x1 from the stack
> +	ldp	x2, x3, [sp], #16	// x0, x1
> +
> +	// Store the guest regs x0-x1 and x4-x18
> +	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(0)]
> +	stp	x4, x5,   [x1, #CPU_XREG_OFFSET(4)]
> +	stp	x6, x7,   [x1, #CPU_XREG_OFFSET(6)]
> +	stp	x8, x9,   [x1, #CPU_XREG_OFFSET(8)]
> +	stp	x10, x11, [x1, #CPU_XREG_OFFSET(10)]
> +	stp	x12, x13, [x1, #CPU_XREG_OFFSET(12)]
> +	stp	x14, x15, [x1, #CPU_XREG_OFFSET(14)]
> +	stp	x16, x17, [x1, #CPU_XREG_OFFSET(16)]
> +	str	x18,      [x1, #CPU_XREG_OFFSET(18)]
> +
> +	// Store the guest regs x19-x29, lr
> +	save_callee_saved_regs x1
>  
> -	save_callee_saved_regs x2
> +	// Restore the host_ctxt from the stack
> +	ldr	x2, [sp], #16
>  
> -	// Restore vcpu & host_ctxt from the stack
> -	// (preserving return code in x1)
> -	ldp	x0, x2, [sp], #16
>  	// Now restore the host regs
>  	restore_callee_saved_regs x2
>  
> -	mov	x0, x1
>  	ret
>  ENDPROC(__guest_exit)
>  
>  ENTRY(__fpsimd_guest_restore)
> +	stp	x2, x3, [sp, #-16]!
>  	stp	x4, lr, [sp, #-16]!
>  
>  alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index f6d9694..d6cae542 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -27,16 +27,6 @@
>  	.text
>  	.pushsection	.hyp.text, "ax"
>  
> -.macro	save_x0_to_x3
> -	stp	x0, x1, [sp, #-16]!
> -	stp	x2, x3, [sp, #-16]!
> -.endm
> -
> -.macro	restore_x0_to_x3
> -	ldp	x2, x3, [sp], #16
> -	ldp	x0, x1, [sp], #16
> -.endm
> -
>  .macro do_el2_call
>  	/*
>  	 * Shuffle the parameters before calling the function
> @@ -79,23 +69,23 @@ ENTRY(__kvm_hyp_teardown)
>  ENDPROC(__kvm_hyp_teardown)
>  	
>  el1_sync:				// Guest trapped into EL2
> -	save_x0_to_x3
> +	stp	x0, x1, [sp, #-16]!
>  
>  alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
>  	mrs	x1, esr_el2
>  alternative_else
>  	mrs	x1, esr_el1
>  alternative_endif
> -	lsr	x2, x1, #ESR_ELx_EC_SHIFT
> +	lsr	x0, x1, #ESR_ELx_EC_SHIFT
>  
> -	cmp	x2, #ESR_ELx_EC_HVC64
> +	cmp	x0, #ESR_ELx_EC_HVC64
>  	b.ne	el1_trap
>  
> -	mrs	x3, vttbr_el2		// If vttbr is valid, the 64bit guest
> -	cbnz	x3, el1_trap		// called HVC
> +	mrs	x1, vttbr_el2		// If vttbr is valid, the 64bit guest
> +	cbnz	x1, el1_trap		// called HVC
>  
>  	/* Here, we're pretty sure the host called HVC. */
> -	restore_x0_to_x3
> +	ldp	x0, x1, [sp], #16
>  
>  	cmp	x0, #HVC_GET_VECTORS
>  	b.ne	1f
> @@ -113,22 +103,21 @@ alternative_endif
>  
>  el1_trap:
>  	/*
> -	 * x1: ESR
> -	 * x2: ESR_EC
> +	 * x0: ESR_EC
>  	 */
>  
>  	/* Guest accessed VFP/SIMD registers, save host, restore Guest */
> -	cmp	x2, #ESR_ELx_EC_FP_ASIMD
> +	cmp	x0, #ESR_ELx_EC_FP_ASIMD
>  	b.eq	__fpsimd_guest_restore
>  
> -	mrs	x0, tpidr_el2
> -	mov	x1, #ARM_EXCEPTION_TRAP
> +	mrs	x1, tpidr_el2
> +	mov	x0, #ARM_EXCEPTION_TRAP
>  	b	__guest_exit
>  
>  el1_irq:
> -	save_x0_to_x3
> -	mrs	x0, tpidr_el2
> -	mov	x1, #ARM_EXCEPTION_IRQ
> +	stp     x0, x1, [sp, #-16]!
> +	mrs	x1, tpidr_el2
> +	mov	x0, #ARM_EXCEPTION_IRQ
>  	b	__guest_exit
>  
>  ENTRY(__hyp_do_panic)
> -- 
> Qualcomm Datacenter Technologies, Inc. on behalf of the Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
> 
