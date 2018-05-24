From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 08/14] arm64: ssbd: Disable mitigation on CPU resume if
 required by user
Date: Thu, 24 May 2018 12:55:38 +0100
Message-ID: <20180524115538.iq2rfntxyfqmskom@lakrids.cambridge.arm.com>
References: <20180522150648.28297-1-marc.zyngier@arm.com>
 <20180522150648.28297-9-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180522150648.28297-9-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 22, 2018 at 04:06:42PM +0100, Marc Zyngier wrote:
> On a system where firmware can dynamically change the state of the
> mitigation, the CPU will always come up with the mitigation enabled,
> including when coming back from suspend.
> 
> If the user has requested "no mitigation" via a command line option,
> let's enforce it by calling into the firmware again to disable it.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/cpufeature.h | 6 ++++++
>  arch/arm64/kernel/cpu_errata.c      | 8 ++++----
>  arch/arm64/kernel/suspend.c         | 8 ++++++++
>  3 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 1bacdf57f0af..d9dcb683259e 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -553,6 +553,12 @@ static inline int arm64_get_ssbd_state(void)
>  #endif
>  }
>  
> +#ifdef CONFIG_ARM64_SSBD
> +void arm64_set_ssbd_mitigation(bool state);
> +#else
> +static inline void arm64_set_ssbd_mitigation(bool state) {}
> +#endif
> +
>  #endif /* __ASSEMBLY__ */
>  
>  #endif
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index 8f686f39b9c1..b4c12e9140f0 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -297,7 +297,7 @@ void __init arm64_enable_wa2_handling(struct alt_instr *alt,
>  		*updptr = cpu_to_le32(aarch64_insn_gen_nop());
>  }
>  
> -static void do_ssbd(bool state)
> +void arm64_set_ssbd_mitigation(bool state)

Using this name from the outset would be nice, if you're happy to fold
that earlier in the seires. Not a big deal either way.

>  {
>  	switch (psci_ops.conduit) {
>  	case PSCI_CONDUIT_HVC:
> @@ -371,20 +371,20 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
>  	switch (ssbd_state) {
>  	case ARM64_SSBD_FORCE_DISABLE:
>  		pr_info_once("%s disabled from command-line\n", entry->desc);
> -		do_ssbd(false);
> +		arm64_set_ssbd_mitigation(false);
>  		required = false;
>  		break;
>  
>  	case ARM64_SSBD_EL1_ENTRY:
>  		if (required) {
>  			__this_cpu_write(arm64_ssbd_callback_required, 1);
> -			do_ssbd(true);
> +			arm64_set_ssbd_mitigation(true);
>  		}
>  		break;
>  
>  	case ARM64_SSBD_FORCE_ENABLE:
>  		pr_info_once("%s forced from command-line\n", entry->desc);
> -		do_ssbd(true);
> +		arm64_set_ssbd_mitigation(true);
>  		required = true;
>  		break;
>  
> diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
> index a307b9e13392..70c283368b64 100644
> --- a/arch/arm64/kernel/suspend.c
> +++ b/arch/arm64/kernel/suspend.c
> @@ -62,6 +62,14 @@ void notrace __cpu_suspend_exit(void)
>  	 */
>  	if (hw_breakpoint_restore)
>  		hw_breakpoint_restore(cpu);
> +
> +	/*
> +	 * On resume, firmware implementing dynamic mitigation will
> +	 * have turned the mitigation on. If the user has forcefully
> +	 * disabled it, make sure their wishes are obeyed.
> +	 */
> +	if (arm64_get_ssbd_state() == ARM64_SSBD_FORCE_DISABLE)
> +		arm64_set_ssbd_mitigation(false);
>  }

This looks fine for idle and suspend-to-ram, so:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

However, for suspend-to-disk (i.e hibernate), the kernel doing the
resume might have SSBD force-disabled, while this kernel (which has just
been resumed) wants it enabled.

I think we also need something in swsusp_arch_suspend(), right after the
call to __cpu_suspend_exit() to re-enable that.

Thanks,
Mark.
