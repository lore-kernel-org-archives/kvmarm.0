From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 07/14] arm64: ssbd: Skip apply_ssbd if not using dynamic
 mitigation
Date: Thu, 24 May 2018 12:43:30 +0100
Message-ID: <20180524114330.e2fb3edfqaqi2nvg@lakrids.cambridge.arm.com>
References: <20180522150648.28297-1-marc.zyngier@arm.com>
 <20180522150648.28297-8-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180522150648.28297-8-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 22, 2018 at 04:06:41PM +0100, Marc Zyngier wrote:
> In order to avoid checking arm64_ssbd_callback_required on each
> kernel entry/exit even if no mitigation is required, let's
> add yet another alternative that by default jumps over the mitigation,
> and that gets nop'ed out if we're doing dynamic mitigation.
> 
> Think of it as a poor man's static key...

I guess in future we can magic up a more general asm static key if we
need them elsewhere.

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/kernel/cpu_errata.c | 14 ++++++++++++++
>  arch/arm64/kernel/entry.S      |  3 +++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index f1d4e75b0ddd..8f686f39b9c1 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -283,6 +283,20 @@ void __init arm64_update_smccc_conduit(struct alt_instr *alt,
>  	*updptr = cpu_to_le32(insn);
>  }
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
>  static void do_ssbd(bool state)
>  {
>  	switch (psci_ops.conduit) {
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 29ad672a6abd..e6f6e2339b22 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -142,6 +142,9 @@ alternative_else_nop_endif
>  	// to save/restore them if required.
>  	.macro	apply_ssbd, state, targ, tmp1, tmp2
>  #ifdef CONFIG_ARM64_SSBD
> +alternative_cb	arm64_enable_wa2_handling
> +	b	\targ
> +alternative_cb_end
>  	ldr_this_cpu	\tmp2, arm64_ssbd_callback_required, \tmp1
>  	cbz	\tmp2, \targ
>  	mov	w0, #ARM_SMCCC_ARCH_WORKAROUND_2
> -- 
> 2.14.2
> 
