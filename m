From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH 07/14] arm64: ssbd: Skip apply_ssbd if not using dynamic
 mitigation
Date: Wed, 23 May 2018 11:13:53 +0100
Message-ID: <6fa3a0e9-a4eb-be1d-eab9-f225641a0d3e@arm.com>
References: <20180522150648.28297-1-marc.zyngier@arm.com>
 <20180522150648.28297-8-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180522150648.28297-8-marc.zyngier@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 05/22/2018 04:06 PM, Marc Zyngier wrote:
> In order to avoid checking arm64_ssbd_callback_required on each
> kernel entry/exit even if no mitigation is required, let's
> add yet another alternative that by default jumps over the mitigation,
> and that gets nop'ed out if we're doing dynamic mitigation.
> 
> Think of it as a poor man's static key...
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Julien Grall <julien.grall@arm.com>

Cheers,


> ---
>   arch/arm64/kernel/cpu_errata.c | 14 ++++++++++++++
>   arch/arm64/kernel/entry.S      |  3 +++
>   2 files changed, 17 insertions(+)
> 
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index f1d4e75b0ddd..8f686f39b9c1 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -283,6 +283,20 @@ void __init arm64_update_smccc_conduit(struct alt_instr *alt,
>   	*updptr = cpu_to_le32(insn);
>   }
>   
> +void __init arm64_enable_wa2_handling(struct alt_instr *alt,
> +				      __le32 *origptr, __le32 *updptr,
> +				      int nr_inst)
> +{
> +	BUG_ON(nr_inst != 1);
> +	/*
> +	 * Only allow mitigation on EL1 entry/exit and guest
> +	 * ARCH_WORKAROUND_2 handling if the SSBD state allows it to
> +	 * be flipped.
> +	 */
> +	if (arm64_get_ssbd_state() == ARM64_SSBD_EL1_ENTRY)
> +		*updptr = cpu_to_le32(aarch64_insn_gen_nop());
> +}
> +
>   static void do_ssbd(bool state)
>   {
>   	switch (psci_ops.conduit) {
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 29ad672a6abd..e6f6e2339b22 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -142,6 +142,9 @@ alternative_else_nop_endif
>   	// to save/restore them if required.
>   	.macro	apply_ssbd, state, targ, tmp1, tmp2
>   #ifdef CONFIG_ARM64_SSBD
> +alternative_cb	arm64_enable_wa2_handling
> +	b	\targ
> +alternative_cb_end
>   	ldr_this_cpu	\tmp2, arm64_ssbd_callback_required, \tmp1
>   	cbz	\tmp2, \targ
>   	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_2
> 

-- 
Julien Grall
