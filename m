From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH 03/14] arm64: Add per-cpu infrastructure to call
 ARCH_WORKAROUND_2
Date: Wed, 23 May 2018 11:03:03 +0100
Message-ID: <ffe33a66-0979-6bfa-995e-f474a46831b6@arm.com>
References: <20180522150648.28297-1-marc.zyngier@arm.com>
 <20180522150648.28297-4-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180522150648.28297-4-marc.zyngier@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 05/22/2018 04:06 PM, Marc Zyngier wrote:
> In a heterogeneous system, we can end up with both affected and
> unaffected CPUs. Let's check their status before calling into the
> firmware.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Julien Grall <julien.grall@arm.com>

Cheers,

> ---
>   arch/arm64/kernel/cpu_errata.c |  2 ++
>   arch/arm64/kernel/entry.S      | 11 +++++++----
>   2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index 46b3aafb631a..0288d6cf560e 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -233,6 +233,8 @@ enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
>   #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
>   
>   #ifdef CONFIG_ARM64_SSBD
> +DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
> +
>   void __init arm64_update_smccc_conduit(struct alt_instr *alt,
>   				       __le32 *origptr, __le32 *updptr,
>   				       int nr_inst)
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index f33e6aed3037..29ad672a6abd 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -140,8 +140,10 @@ alternative_else_nop_endif
>   
>   	// This macro corrupts x0-x3. It is the caller's duty
>   	// to save/restore them if required.
> -	.macro	apply_ssbd, state
> +	.macro	apply_ssbd, state, targ, tmp1, tmp2
>   #ifdef CONFIG_ARM64_SSBD
> +	ldr_this_cpu	\tmp2, arm64_ssbd_callback_required, \tmp1
> +	cbz	\tmp2, \targ
>   	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_2
>   	mov	w1, #\state
>   alternative_cb	arm64_update_smccc_conduit
> @@ -176,12 +178,13 @@ alternative_cb_end
>   	ldr	x19, [tsk, #TSK_TI_FLAGS]	// since we can unmask debug
>   	disable_step_tsk x19, x20		// exceptions when scheduling.
>   
> -	apply_ssbd 1
> +	apply_ssbd 1, 1f, x22, x23
>   
>   #ifdef CONFIG_ARM64_SSBD
>   	ldp	x0, x1, [sp, #16 * 0]
>   	ldp	x2, x3, [sp, #16 * 1]
>   #endif
> +1:
>   
>   	mov	x29, xzr			// fp pointed to user-space
>   	.else
> @@ -323,8 +326,8 @@ alternative_if ARM64_WORKAROUND_845719
>   alternative_else_nop_endif
>   #endif
>   3:
> -	apply_ssbd 0
> -
> +	apply_ssbd 0, 5f, x0, x1
> +5:
>   	.endif
>   
>   	msr	elr_el1, x21			// set up the return data
> 

-- 
Julien Grall
