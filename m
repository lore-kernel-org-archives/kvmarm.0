From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: Re: [PATCH v3 7/8] arm64: exception: handle asynchronous SError
 interrupt
Date: Fri, 21 Apr 2017 18:46:48 +0800
Message-ID: <1cf65f76-65ee-d98c-cf3e-a5e8ff63550d@huawei.com>
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

Hi XiuQi,

On 2017/3/30 18:31, Xie XiuQi wrote:
> Error Synchronization Barrier (ESB; part of the ARMv8.2 Extensions)
> is used to synchronize Unrecoverable errors. That is, containable errors
> architecturally consumed by the PE and not silently propagated.
> 
> With ESB it is generally possible to isolate an unrecoverable error
> between two ESB instructions. So, it's possible to recovery from
> unrecoverable errors reported by asynchronous SError interrupt.
> 
> If ARMv8.2 RAS Extension is not support, ESB is treated as a NOP.
> 
> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
> Signed-off-by: Wang Xiongfeng <wangxiongfengi2@huawei.com>
> ---
>  arch/arm64/Kconfig           | 16 ++++++++++
>  arch/arm64/include/asm/esr.h | 14 +++++++++
>  arch/arm64/kernel/entry.S    | 70 ++++++++++++++++++++++++++++++++++++++++++--
>  arch/arm64/kernel/traps.c    | 54 ++++++++++++++++++++++++++++++++--
>  4 files changed, 150 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 859a90e..7402175 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -911,6 +911,22 @@ endmenu
>  
>  menu "ARMv8.2 architectural features"
>  
> +config ARM64_ESB
> +	bool "Enable support for Error Synchronization Barrier (ESB)"
> +	default n
> +	help
> +	  Error Synchronization Barrier (ESB; part of the ARMv8.2 Extensions)
> +	  is used to synchronize Unrecoverable errors. That is, containable errors
> +	  architecturally consumed by the PE and not silently propagated.
> +
> +	  Without ESB it is not generally possible to isolate an Unrecoverable
> +	  error because it is not known which instruction generated the error.
> +
> +	  Selecting this option allows inject esb instruction before the exception
> +	  change. If ARMv8.2 RAS Extension is not support, ESB is treated as a NOP.
> +
> +	  Note that ESB instruction can introduce slight overhead, so say N if unsure.
> +
>  config ARM64_UAO
>  	bool "Enable support for User Access Override (UAO)"
>  	default y
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index f20c64a..22f9c90 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -106,6 +106,20 @@
>  #define ESR_ELx_AR 		(UL(1) << 14)
>  #define ESR_ELx_CM 		(UL(1) << 8)
>  
> +#define ESR_Elx_DFSC_SEI	(0x11)
> +
> +#define ESR_ELx_AET_SHIFT	(10)
> +#define ESR_ELx_AET_MAX		(7)
> +#define ESR_ELx_AET_MASK	(UL(7) << ESR_ELx_AET_SHIFT)
> +#define ESR_ELx_AET(esr)	(((esr) & ESR_ELx_AET_MASK) >> ESR_ELx_AET_SHIFT)
> +
> +#define ESR_ELx_AET_UC		(0)
> +#define ESR_ELx_AET_UEU		(1)
> +#define ESR_ELx_AET_UEO		(2)
> +#define ESR_ELx_AET_UER		(3)
> +#define ESR_ELx_AET_CE		(6)
> +
> +
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
because we also want to take SEI exception in kernel space, we may need to unmask SEI in kernel_entry.
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

for the situation 'Current EL with SPx', we also need to change the sError vector to el1_error.
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


Thanks,

Wang Xiongfeng


