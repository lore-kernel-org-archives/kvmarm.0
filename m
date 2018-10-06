From: Amit Kachhap <amit.kachhap@arm.com>
Subject: Re: [RFC 16/17] arm64: initialize and switch ptrauth kernel keys
Date: Sat, 6 Oct 2018 18:26:50 +0530
Message-ID: <ad797ff9-d9c1-1424-fa1b-3886943e14b6@arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
 <20181005084754.20950-17-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005084754.20950-17-kristina.martsenko@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 10/05/2018 02:17 PM, Kristina Martsenko wrote:
> Set up keys to use pointer auth in the kernel. Each task has its own
> APIAKey, which is initialized during fork. The key is changed during
> context switch and on kernel entry from EL0.
> 
> A function that changes the key cannot return, so inline such functions.


For all the RFC patches in this series,
Reviewed-by: Amit Daniel Kachhap <amit.kachhap@arm.com>

> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
> ---
>   arch/arm64/include/asm/pointer_auth.h |  9 ++++++++-
>   arch/arm64/include/asm/ptrauth-asm.h  | 13 +++++++++++++
>   arch/arm64/include/asm/thread_info.h  |  1 +
>   arch/arm64/kernel/asm-offsets.c       |  1 +
>   arch/arm64/kernel/entry.S             |  4 ++++
>   arch/arm64/kernel/process.c           |  3 +++
>   arch/arm64/kernel/smp.c               |  3 +++
>   7 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
> index 0634f06c3af2..e94ca7df8dab 100644
> --- a/arch/arm64/include/asm/pointer_auth.h
> +++ b/arch/arm64/include/asm/pointer_auth.h
> @@ -50,12 +50,13 @@ do {								\
>   	write_sysreg_s(__pki_v.hi, SYS_ ## k ## KEYHI_EL1);	\
>   } while (0)
>   
> -static inline void ptrauth_keys_switch(struct ptrauth_keys *keys)
> +static __always_inline void ptrauth_keys_switch(struct ptrauth_keys *keys)
>   {
>   	if (!cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH))
>   		return;
>   
>   	__ptrauth_key_install(APIA, keys->apia);
> +	isb();
>   }
>   
>   static __always_inline void ptrauth_cpu_enable(void)
> @@ -85,11 +86,17 @@ static inline unsigned long ptrauth_strip_insn_pac(unsigned long ptr)
>   
>   #define ptrauth_task_init_user(tsk)	\
>   	ptrauth_keys_init(&(tsk)->thread_info.keys_user)
> +#define ptrauth_task_init_kernel(tsk)	\
> +	ptrauth_keys_init(&(tsk)->thread_info.keys_kernel)
> +#define ptrauth_task_switch(tsk)	\
> +	ptrauth_keys_switch(&(tsk)->thread_info.keys_kernel)
>   
>   #else /* CONFIG_ARM64_PTR_AUTH */
>   #define __no_ptrauth
>   #define ptrauth_strip_insn_pac(lr)	(lr)
>   #define ptrauth_task_init_user(tsk)
> +#define ptrauth_task_init_kernel(tsk)
> +#define ptrauth_task_switch(tsk)
>   #define ptrauth_cpu_enable(tsk)
>   #endif /* CONFIG_ARM64_PTR_AUTH */
>   
> diff --git a/arch/arm64/include/asm/ptrauth-asm.h b/arch/arm64/include/asm/ptrauth-asm.h
> index f50bdfc4046c..3ef1cc8903d5 100644
> --- a/arch/arm64/include/asm/ptrauth-asm.h
> +++ b/arch/arm64/include/asm/ptrauth-asm.h
> @@ -16,11 +16,24 @@ alternative_if ARM64_HAS_ADDRESS_AUTH
>   alternative_else_nop_endif
>   	.endm
>   
> +	.macro ptrauth_keys_install_kernel tsk, tmp
> +alternative_if ARM64_HAS_ADDRESS_AUTH
> +	ldr	\tmp, [\tsk, #(TSK_TI_KEYS_KERNEL + PTRAUTH_KEY_APIALO)]
> +	msr_s	SYS_APIAKEYLO_EL1, \tmp
> +	ldr	\tmp, [\tsk, #(TSK_TI_KEYS_KERNEL + PTRAUTH_KEY_APIAHI)]
> +	msr_s	SYS_APIAKEYHI_EL1, \tmp
> +	isb
> +alternative_else_nop_endif
> +	.endm
> +
>   #else /* CONFIG_ARM64_PTR_AUTH */
>   
>   	.macro ptrauth_keys_install_user tsk, tmp
>   	.endm
>   
> +	.macro ptrauth_keys_install_kernel tsk, tmp
> +	.endm
> +
>   #endif /* CONFIG_ARM64_PTR_AUTH */
>   
>   #endif /* __ASM_PTRAUTH_ASM_H */
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index ea9272fb52d4..e3ec5345addc 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -46,6 +46,7 @@ struct thread_info {
>   	int			preempt_count;	/* 0 => preemptable, <0 => bug */
>   #ifdef CONFIG_ARM64_PTR_AUTH
>   	struct ptrauth_keys	keys_user;
> +	struct ptrauth_keys	keys_kernel;
>   #endif
>   };
>   
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index b6be0dd037fd..6c61c9722b47 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -47,6 +47,7 @@ int main(void)
>   #endif
>   #ifdef CONFIG_ARM64_PTR_AUTH
>     DEFINE(TSK_TI_KEYS_USER, 	offsetof(struct task_struct, thread_info.keys_user));
> +  DEFINE(TSK_TI_KEYS_KERNEL, 	offsetof(struct task_struct, thread_info.keys_kernel));
>   #endif
>     DEFINE(TSK_STACK,		offsetof(struct task_struct, stack));
>     BLANK();
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 1e925f6d2978..a4503da445f7 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -250,6 +250,10 @@ alternative_else_nop_endif
>   	msr	sp_el0, tsk
>   	.endif
>   
> +	.if	\el == 0
> +	ptrauth_keys_install_kernel tsk, x20

There is 1 function before "__uaccess_ttbr0_disable" for which
__always_inline attribute can be set instead of just inline.

> +	.endif
> +
>   	/*
>   	 * Registers that may be useful after this macro is invoked:
>   	 *
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 857ae05cd04c..a866996610de 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -330,6 +330,8 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
>   	 */
>   	fpsimd_flush_task_state(p);
>   
> +	ptrauth_task_init_kernel(p);
> +
>   	if (likely(!(p->flags & PF_KTHREAD))) {
>   		*childregs = *current_pt_regs();
>   		childregs->regs[0] = 0;
> @@ -426,6 +428,7 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
>   	contextidr_thread_switch(next);
>   	entry_task_switch(next);
>   	uao_thread_switch(next);
> +	ptrauth_task_switch(next);
>   
>   	/*
>   	 * Complete any pending TLB or cache maintenance on this CPU in case
> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index 09690024dce8..d952dd62c780 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -212,6 +212,7 @@ asmlinkage notrace void secondary_start_kernel(void)
>   	 */
>   	check_local_cpu_capabilities();
>   
> +	ptrauth_task_switch(current);
>   	ptrauth_cpu_enable();
>   
>   	if (cpu_ops[cpu]->cpu_postboot)
> @@ -418,6 +419,8 @@ void __init __no_ptrauth smp_prepare_boot_cpu(void)
>   	jump_label_init();
>   	cpuinfo_store_boot_cpu();
>   
> +	ptrauth_task_init_kernel(current);
> +	ptrauth_task_switch(current);
>   	ptrauth_cpu_enable();
>   }
>   
> 
