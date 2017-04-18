From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: Re: [PATCH v3 7/8] arm64: exception: handle asynchronous SError
 interrupt
Date: Tue, 18 Apr 2017 09:09:14 +0800
Message-ID: <d7a8884d-f6b7-69d0-2438-83c202926000@huawei.com>
References: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
 <1490869877-118713-8-git-send-email-xiexiuqi@huawei.com>
 <20170413105131.GD24027@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170413105131.GD24027@leverpostej>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Rutland <mark.rutland@arm.com>, Xie XiuQi <xiexiuqi@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, wuquanming@huawei.com, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, rostedt@goodmis.org, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, james.morse@arm.com, christoffer.dall@linaro.org, Wang Xiongfeng <wangxiongfengi2@huawei.com>, shiju.jose@huawei.com, zhengqiang10@huawei.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, hanjun.guo@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mark,

I have some confusion about the RAS feature when VHE is enabled. Does RAS spec support
the situation when VHE is enabled. When VHE is disabled, the hyperviosr delegates the error
exception to EL1 by setting HCR_EL2.VSE to 1, and this will inject a virtual SEI into OS.
My understanding is that HCR_EL2.VSE is only used to inject a virtual SEI into EL1.
But when VHE is enabled, the host OS will run at EL2. We can't inject a virtual SEI into
host OS. I don't know if RAS spec can handle this situation.

Thanks,
Wang Xiongfeng

On 2017/4/13 18:51, Mark Rutland wrote:
> Hi,
> 
> On Thu, Mar 30, 2017 at 06:31:07PM +0800, Xie XiuQi wrote:
>> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
>> index f20c64a..22f9c90 100644
>> --- a/arch/arm64/include/asm/esr.h
>> +++ b/arch/arm64/include/asm/esr.h
>> @@ -106,6 +106,20 @@
>>  #define ESR_ELx_AR 		(UL(1) << 14)
>>  #define ESR_ELx_CM 		(UL(1) << 8)
>>  
>> +#define ESR_Elx_DFSC_SEI	(0x11)
> 
> We should probably have a definition for the uncategorized DFSC value,
> too.
> 
> [...]
> 
>> index 43512d4..d8a7306 100644
>> --- a/arch/arm64/kernel/entry.S
>> +++ b/arch/arm64/kernel/entry.S
>> @@ -69,7 +69,14 @@
>>  #define BAD_FIQ		2
>>  #define BAD_ERROR	3
>>  
>> +	.arch_extension ras
> 
> Generally, arch_extension is a warning sign that code isn't going to
> work with contemporary assemblers, which we likely need to support.
> 
>> +
>>  	.macro	kernel_entry, el, regsize = 64
>> +#ifdef CONFIG_ARM64_ESB
>> +	.if	\el == 0
>> +	esb
> 
> Here, I think that we'll need to macro this such that we can build with
> existing toolchains.
> 
> e.g. in <asm/assembler.h> we need something like:
> 
> 	#define HINT_IMM_ESB	16
> 
> 	.macro ESB
> 	hint	#HINT_IMM_ESB
> 	.endm
> 
>> +	.endif
>> +#endif
>>  	sub	sp, sp, #S_FRAME_SIZE
>>  	.if	\regsize == 32
>>  	mov	w0, w0				// zero upper 32 bits of x0
>> @@ -208,6 +215,7 @@ alternative_else_nop_endif
>>  #endif
>>  
>>  	.if	\el == 0
>> +	msr	daifset, #0xF			// Set flags
> 
> Elsewhere in head.S we use helpers to fiddle with DAIF bits.
> 
> Please be consistent with that. Add an enable_all macro if we need one.
> 
>>  	ldr	x23, [sp, #S_SP]		// load return stack pointer
>>  	msr	sp_el0, x23
>>  #ifdef CONFIG_ARM64_ERRATUM_845719
>> @@ -226,6 +234,15 @@ alternative_else_nop_endif
>>  
>>  	msr	elr_el1, x21			// set up the return data
>>  	msr	spsr_el1, x22
>> +
>> +#ifdef CONFIG_ARM64_ESB
>> +	.if \el == 0
>> +	esb					// Error Synchronization Barrier
>> +	mrs	x21, disr_el1			// Check for deferred error
> 
> We'll need an <asm/sysreg.h> definition for this register. With that, we
> can use mrs_s here.
> 
>> +	tbnz	x21, #31, el1_sei
>> +	.endif
>> +#endif
>> +
>>  	ldp	x0, x1, [sp, #16 * 0]
>>  	ldp	x2, x3, [sp, #16 * 1]
>>  	ldp	x4, x5, [sp, #16 * 2]
>> @@ -318,7 +335,7 @@ ENTRY(vectors)
>>  	ventry	el1_sync_invalid		// Synchronous EL1t
>>  	ventry	el1_irq_invalid			// IRQ EL1t
>>  	ventry	el1_fiq_invalid			// FIQ EL1t
>> -	ventry	el1_error_invalid		// Error EL1t
>> +	ventry	el1_error			// Error EL1t
>>  
>>  	ventry	el1_sync			// Synchronous EL1h
>>  	ventry	el1_irq				// IRQ EL1h
>> @@ -328,7 +345,7 @@ ENTRY(vectors)
>>  	ventry	el0_sync			// Synchronous 64-bit EL0
>>  	ventry	el0_irq				// IRQ 64-bit EL0
>>  	ventry	el0_fiq_invalid			// FIQ 64-bit EL0
>> -	ventry	el0_error_invalid		// Error 64-bit EL0
>> +	ventry	el0_error			// Error 64-bit EL0
>>  
>>  #ifdef CONFIG_COMPAT
>>  	ventry	el0_sync_compat			// Synchronous 32-bit EL0
>> @@ -508,12 +525,31 @@ el1_preempt:
>>  	ret	x24
>>  #endif
>>  
>> +	.align	6
>> +el1_error:
>> +	kernel_entry 1
>> +el1_sei:
>> +	/*
>> +	 * asynchronous SError interrupt from kernel
>> +	 */
>> +	mov	x0, sp
>> +	mrs	x1, esr_el1
> 
> I don't think this is correct if we branched here from kernel_exit.
> Surely we want the DISR_EL1 value, and ESR_EL1 is unrelated?
> 
>> +	mov	x2, #1				// exception level of SEI generated
>> +	b	do_sei
> 
> You don't need to figure out the EL here. In do_sei() we can determine
> the exception level from the regs (e.g. using user_mode(regs)).
> 
>> +ENDPROC(el1_error)
>> +
>> +
>>  /*
>>   * EL0 mode handlers.
>>   */
>>  	.align	6
>>  el0_sync:
>>  	kernel_entry 0
>> +#ifdef CONFIG_ARM64_ESB
>> +	mrs     x26, disr_el1
>> +	tbnz    x26, #31, el0_sei		// check DISR.A
>> +	msr	daifclr, #0x4			// unmask SEI
>> +#endif
> 
> Why do we duplicate this across the EL0 handlers, rather than making it
> common in the el0 kernel_entry code?
> 
>>  	mrs	x25, esr_el1			// read the syndrome register
>>  	lsr	x24, x25, #ESR_ELx_EC_SHIFT	// exception class
>>  	cmp	x24, #ESR_ELx_EC_SVC64		// SVC in 64-bit state
>> @@ -688,8 +724,38 @@ el0_inv:
>>  ENDPROC(el0_sync)
>>  
>>  	.align	6
>> +el0_error:
>> +	kernel_entry 0
>> +el0_sei:
>> +	/*
>> +	 * asynchronous SError interrupt from userspace
>> +	 */
>> +	ct_user_exit
>> +	mov	x0, sp
>> +	mrs	x1, esr_el1
> 
> As with el1_sei, I don't think this is correct if we branched to
> el0_sei. As far as I am aware, ESR_EL1 will contain whatever exception
> we took, and the value we want is in DISR_EL1.
> 
>> +	mov	x2, #0
> 
> This EL parameter can go.
> 
>> +	bl	do_sei
>> +	b	ret_to_user
>> +ENDPROC(el0_error)
>> +
>> +	.align	6
>>  el0_irq:
>>  	kernel_entry 0
>> +#ifdef CONFIG_ARM64_ESB
>> +	mrs     x26, disr_el1
>> +	tbz     x26, #31, el0_irq_naked          // check DISR.A
>> +
>> +	mov	x0, sp
>> +	mrs	x1, esr_el1
>> +	mov	x2, 0
>> +
>> +	/*
>> +	 * The SEI generated at EL0 is not affect this irq context,
>> +	 * so after sei handler, we continue process this irq.
>> +	 */
>> +	bl	do_sei
>> +	msr     daifclr, #0x4                   // unmask SEI
> 
> This rough pattern is duplicated several times across the EL0 entry
> paths. I think it should be made common.
> 
>> +#endif
>>  el0_irq_naked:
>>  	enable_dbg
>>  #ifdef CONFIG_TRACE_IRQFLAGS
>> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
>> index b6d6727..99be6d8 100644
>> --- a/arch/arm64/kernel/traps.c
>> +++ b/arch/arm64/kernel/traps.c
>> @@ -643,6 +643,34 @@ asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
>>  		handler[reason], smp_processor_id(), esr,
>>  		esr_get_class_string(esr));
>>  
>> +	die("Oops - bad mode", regs, 0);
>> +	local_irq_disable();
>> +	panic("bad mode");
>> +}
>> +
>> +static const char *sei_context[] = {
>> +	"userspace",			/* EL0 */
>> +	"kernel",			/* EL1 */
>> +};
> 
> This should go. It's only used in one place, and would be clearer with
> the strings inline. More on that below.
> 
>> +
>> +static const char *sei_severity[] = {
> 
> Please name this for what it actually represents:
> 
> static const char *esr_aet_str[] = {
> 
>> +	[0 ... ESR_ELx_AET_MAX] =	"Unknown",
> 
> For consistency with esr_class_str, please make this:
> 
> 	[0 ... ESR_ELx_AET_MAX] =	"UNRECOGNIZED AET",
> 
> ... which makes it clear that this isn't some AET value which reports an
> "Unknown" status.
> 
>> +	[ESR_ELx_AET_UC]	=	"Uncontainable",
>> +	[ESR_ELx_AET_UEU]	=	"Unrecoverable",
>> +	[ESR_ELx_AET_UEO]	=	"Restartable",
>> +	[ESR_ELx_AET_UER]	=	"Recoverable",
>> +	[ESR_ELx_AET_CE]	=	"Corrected",
>> +};
>> +
>> +DEFINE_PER_CPU(int, sei_in_process);
> 
> A previous patch added definition of this.
> 
>> +asmlinkage void do_sei(struct pt_regs *regs, unsigned int esr, int el)
>> +{
>> +	int aet = ESR_ELx_AET(esr);
> 
> The AET field is only valid when the DFSC is 0b010001, so we need to
> check that before we interpret AET.
> 
>> +	console_verbose();
>> +
>> +	pr_crit("Asynchronous SError interrupt detected on CPU%d, %s, %s\n",
>> +		smp_processor_id(), sei_context[el], sei_severity[aet]);
> 
> We should dump the full ESR_ELx value, regardless of what automated
> decoding we do, so that we have a chance of debugging issues in the
> field.
> 
> It would also be nice to align with how bad_mode reports this today.
> Please make this:
> 
> 	pr_crit("SError detected on CPU%d while in %s mode: code: 0x%08x -- %s\n",
> 		smp_processor_id(), user_mode(regs) ? "user" : "kernel",
> 		esr, esr_aet_str[aet]);
> 
> ... though it might be best to dump the raw SPSR rather than trying to
> say user/kernel, so that we can distinguish EL1/EL2 with VHE, etc.
> 
>> +
>>  	/*
>>  	 * In firmware first mode, we could assume firmware will only generate one
>>  	 * of cper records at a time. There is no risk for one cpu to parse ghes table.
>> @@ -653,9 +681,31 @@ asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
>>  		this_cpu_dec(sei_in_process);
>>  	}
>>  
>> -	die("Oops - bad mode", regs, 0);
>> +	if (el == 0 && IS_ENABLED(CONFIG_ARM64_ESB) &&
> 
> Please use user_mode(regs), and get rid of the el parameter to this
> function entirely.
> 
>> +	    cpus_have_cap(ARM64_HAS_RAS_EXTN)) {
>> +		siginfo_t info;
>> +		void __user *pc = (void __user *)instruction_pointer(regs);
>> +
>> +		if (aet >= ESR_ELx_AET_UEO)
>> +			return;
> 
> We need to check the DFSC first, and 0b111 is a reserved value (which
> the ARM ARM doesn't define the recoverability of), so I don't think this
> is correct.
> 
> We should probably test the DSFC, then switch on the AET value, so as to
> handle only the cases we are aware of.
> 
>> +
>> +		if (aet == ESR_ELx_AET_UEU) {
>> +			info.si_signo = SIGILL;
>> +			info.si_errno = 0;
>> +			info.si_code  = ILL_ILLOPC;
>> +			info.si_addr  = pc;
> 
> An unrecoverable error is not necessarily a particular bad instruction,
> so I'm not sure this makes sense.
> 
> Thanks,
> Mark.
> 
> .
> 
