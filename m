From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Save two instructions in __guest_enter()
Date: Mon, 29 Aug 2016 20:13:55 +0200
Message-ID: <20160829181355.GB10162@cbox>
References: <1470791736-13949-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C8A84113E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2016 14:03:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H1v63PjkyrKK for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Aug 2016 14:03:39 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5BF2A40FA2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2016 14:03:39 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id i5so105016264wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Aug 2016 11:11:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1470791736-13949-1-git-send-email-shankerd@codeaurora.org>
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

On Tue, Aug 09, 2016 at 08:15:36PM -0500, Shanker Donthineni wrote:
> We are doing an unnecessary stack push/pop operation when restoring
> the guest registers x0-x18 in __guest_enter(). This patch saves the
> two instructions by using x18 as a base register. No need to store
> the vcpu context pointer in stack because it is redundant and not
> being used anywhere, the same information is available in tpidr_el2.
> 
> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
> ---
>  arch/arm64/kvm/hyp/entry.S | 66 ++++++++++++++++++++++------------------------
>  1 file changed, 32 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index ce9e5e5..d2e09a1 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -55,37 +55,32 @@
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
> +	// Preserve the host_ctxt for use at exit time
> +	str	x1, [sp, #-16]!
>  
> -	add	x1, x0, #VCPU_CONTEXT
> +	add	x18, x0, #VCPU_CONTEXT
>  
> -	// Prepare x0-x1 for later restore by pushing them onto the stack
> -	ldp	x2, x3, [x1, #CPU_XREG_OFFSET(0)]
> -	stp	x2, x3, [sp, #-16]!
> +	// Restore guest regs x19-x29, lr
> +	restore_callee_saved_regs x18

couldn't moving this load here be bad for prefetching?

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
> +	// Restore guest regs x0-x18
> +	ldp	x0, x1,   [x18, #CPU_XREG_OFFSET(0)]
> +	ldp	x2, x3,   [x18, #CPU_XREG_OFFSET(2)]
> +	ldp	x4, x5,   [x18, #CPU_XREG_OFFSET(4)]
> +	ldp	x6, x7,   [x18, #CPU_XREG_OFFSET(6)]
> +	ldp	x8, x9,   [x18, #CPU_XREG_OFFSET(8)]
> +	ldp	x10, x11, [x18, #CPU_XREG_OFFSET(10)]
> +	ldp	x12, x13, [x18, #CPU_XREG_OFFSET(12)]
> +	ldp	x14, x15, [x18, #CPU_XREG_OFFSET(14)]
> +	ldp	x16, x17, [x18, #CPU_XREG_OFFSET(16)]
> +	ldr	x18,      [x18, #CPU_XREG_OFFSET(18)]
>  
>  	// Do not touch any register after this!
>  	eret
> @@ -100,6 +95,16 @@ ENTRY(__guest_exit)
>  
>  	add	x2, x0, #VCPU_CONTEXT
>  
> +	// Store the guest regs x19-x29, lr
> +	save_callee_saved_regs x2

same question here (although with a different weight as we were already
'jumping back' with the memory address in our store sequence.

If this is a real concern, a better approach would be to override x0
with the vcpu context pointer, do two pairs of load/stores using x2,x3
for the vcpu x0-x3, and then proceed with the rest of the registers.

> +
> +	// Retrieve the guest regs x0-x3 from the stack
> +	ldp	x21, x22, [sp], #16	// x2, x3
> +	ldp	x19, x20, [sp], #16	// x0, x1
> +
> +	// Store the guest regs x0-x18
> +	stp	x19, x20, [x2, #CPU_XREG_OFFSET(0)]
> +	stp	x21, x22, [x2, #CPU_XREG_OFFSET(2)]
>  	stp	x4, x5,   [x2, #CPU_XREG_OFFSET(4)]
>  	stp	x6, x7,   [x2, #CPU_XREG_OFFSET(6)]
>  	stp	x8, x9,   [x2, #CPU_XREG_OFFSET(8)]
> @@ -109,20 +114,13 @@ ENTRY(__guest_exit)
>  	stp	x16, x17, [x2, #CPU_XREG_OFFSET(16)]
>  	str	x18,      [x2, #CPU_XREG_OFFSET(18)]
>  
> -	ldp	x6, x7, [sp], #16	// x2, x3
> -	ldp	x4, x5, [sp], #16	// x0, x1
> +	// Restore the host_ctxt from the stack
> +	ldr	x2, [sp], #16
>  
> -	stp	x4, x5, [x2, #CPU_XREG_OFFSET(0)]
> -	stp	x6, x7, [x2, #CPU_XREG_OFFSET(2)]
> -
> -	save_callee_saved_regs x2
> -
> -	// Restore vcpu & host_ctxt from the stack
> -	// (preserving return code in x1)
> -	ldp	x0, x2, [sp], #16
>  	// Now restore the host regs
>  	restore_callee_saved_regs x2
>  
> +	// Preserving return code (x1)

nit: preserve is a strange word to choose to describe what you do here.

if you want to do what I suggested above, you could change the two
callers to return the return code in x0, and the vcpu pointer in x1 and
then you can save this instruction as well.

>  	mov	x0, x1
>  	ret
>  ENDPROC(__guest_exit)
> -- 

Thanks,
-Christoffer
