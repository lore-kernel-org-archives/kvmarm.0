From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: Re: [PATCH v3 7/8] arm64: exception: handle asynchronous SError
 interrupt
Date: Thu, 13 Apr 2017 16:44:27 +0800
Message-ID: <2b7dc4a7-9fe8-0a6e-46b6-dc75ab3d0e87@huawei.com>
References: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
 <1490869877-118713-8-git-send-email-xiexiuqi@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1490869877-118713-8-git-send-email-xiexiuqi@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Xie XiuQi <xiexiuqi@huawei.com>, christoffer.dall@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, fu.wei@linaro.org, rostedt@goodmis.org, hanjun.guo@linaro.org, shiju.jose@huawei.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, gengdongjiu@huawei.com, zhengqiang10@huawei.com, wuquanming@huawei.com, Wang Xiongfeng <wangxiongfengi2@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Xiuqi,

On 2017/3/30 18:31, Xie XiuQi wrote:
> Error Synchronization Barrier (ESB; part of the ARMv8.2 Extensions)
> is used to synchronize Unrecoverable errors. That is, containable errors
> architecturally consumed by the PE and not silently propagated.
> 
> With ESB it is generally possible to isolate an unrecoverable error
> between two ESB instructions. So, it's possible to recovery from

>  /* ISS field definitions for exceptions taken in to Hyp */
>  #define ESR_ELx_CV		(UL(1) << 24)
>  #define ESR_ELx_COND_SHIFT	(20)
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 43512d4..d8a7306 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -69,7 +69,14 @@
>  #define BAD_FIQ		2
>  #define BAD_ERROR	3
>  
> +	.arch_extension ras
> +
>  	.macro	kernel_entry, el, regsize = 64
> +#ifdef CONFIG_ARM64_ESB
> +	.if	\el == 0
> +	esb
> +	.endif
> +#endif
>  	sub	sp, sp, #S_FRAME_SIZE
>  	.if	\regsize == 32
>  	mov	w0, w0				// zero upper 32 bits of x0
> @@ -208,6 +215,7 @@ alternative_else_nop_endif
>  #endif
>  
>  	.if	\el == 0
> +	msr	daifset, #0xF			// Set flags
>  	ldr	x23, [sp, #S_SP]		// load return stack pointer
>  	msr	sp_el0, x23
>  #ifdef CONFIG_ARM64_ERRATUM_845719
> @@ -226,6 +234,15 @@ alternative_else_nop_endif
>  
>  	msr	elr_el1, x21			// set up the return data
>  	msr	spsr_el1, x22
> +
> +#ifdef CONFIG_ARM64_ESB
> +	.if \el == 0
> +	esb					// Error Synchronization Barrier
> +	mrs	x21, disr_el1			// Check for deferred error
> +	tbnz	x21, #31, el1_sei

We may need to clear disr_el1.A after reading it because the hardware won't clear it.

> +	.endif
> +#endif
> +
>  	ldp	x0, x1, [sp, #16 * 0]
>  	ldp	x2, x3, [sp, #16 * 1]
>  	ldp	x4, x5, [sp, #16 * 2]
> @@ -318,7 +335,7 @@ ENTRY(vectors)
>  	ventry	el1_sync_invalid		// Synchronous EL1t
>  	ventry	el1_irq_invalid			// IRQ EL1t
>  	ventry	el1_fiq_invalid			// FIQ EL1t
> -	ventry	el1_error_invalid		// Error EL1t
> +	ventry	el1_error			// Error EL1t
>  
>  	ventry	el1_sync			// Synchronous EL1h
>  	ventry	el1_irq				// IRQ EL1h
> @@ -328,7 +345,7 @@ ENTRY(vectors)
>  	ventry	el0_sync			// Synchronous 64-bit EL0
>  	ventry	el0_irq				// IRQ 64-bit EL0
>  	ventry	el0_fiq_invalid			// FIQ 64-bit EL0
> -	ventry	el0_error_invalid		// Error 64-bit EL0
> +	ventry	el0_error			// Error 64-bit EL0
>  
>  #ifdef CONFIG_COMPAT
>  	ventry	el0_sync_compat			// Synchronous 32-bit EL0
> @@ -508,12 +525,31 @@ el1_preempt:
>  	ret	x24
>  #endif
>  
> +	.align	6
> +el1_error:
> +	kernel_entry 1
> +el1_sei:
> +	/*
> +	 * asynchronous SError interrupt from kernel
> +	 */
> +	mov	x0, sp
> +	mrs	x1, esr_el1
> +	mov	x2, #1				// exception level of SEI generated
> +	b	do_sei
> +ENDPROC(el1_error)
> +
> +
>  /*
>   * EL0 mode handlers.
>   */
>  	.align	6
>  el0_sync:
>  	kernel_entry 0
> +#ifdef CONFIG_ARM64_ESB
> +	mrs     x26, disr_el1
> +	tbnz    x26, #31, el0_sei		// check DISR.A
> +	msr	daifclr, #0x4			// unmask SEI
> +#endif
>  	mrs	x25, esr_el1			// read the syndrome register
>  	lsr	x24, x25, #ESR_ELx_EC_SHIFT	// exception class
>  	cmp	x24, #ESR_ELx_EC_SVC64		// SVC in 64-bit state
> @@ -688,8 +724,38 @@ el0_inv:
>  ENDPROC(el0_sync)
>  
>  	.align	6
> +el0_error:
> +	kernel_entry 0
> +el0_sei:
> +	/*
> +	 * asynchronous SError interrupt from userspace
> +	 */
> +	ct_user_exit
> +	mov	x0, sp
> +	mrs	x1, esr_el1
> +	mov	x2, #0
> +	bl	do_sei
> +	b	ret_to_user
> +ENDPROC(el0_error)
> +
> +	.align	6
>  el0_irq:
>  	kernel_entry 0
> +#ifdef CONFIG_ARM64_ESB
> +	mrs     x26, disr_el1
> +	tbz     x26, #31, el0_irq_naked          // check DISR.A
> +
> +	mov	x0, sp
> +	mrs	x1, esr_el1
> +	mov	x2, 0
> +
> +	/*
> +	 * The SEI generated at EL0 is not affect this irq context,
> +	 * so after sei handler, we continue process this irq.
> +	 */
> +	bl	do_sei
> +	msr     daifclr, #0x4                   // unmask SEI
> +#endif
>  el0_irq_naked:
>  	enable_dbg
>  #ifdef CONFIG_TRACE_IRQFLAGS

Thanks,
Wang Xiongfeng

