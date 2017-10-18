From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 09/13] arm64: kernel: Add arch-specific SDEI entry
 code and CPU masking
Date: Wed, 18 Oct 2017 12:18:02 +0100
Message-ID: <20171018111801.cz6wkhfnpifj4bnl@armageddon.cambridge.arm.com>
References: <20171017174432.1684-1-james.morse@arm.com>
 <20171017174432.1684-10-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171017174432.1684-10-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 17, 2017 at 06:44:28PM +0100, James Morse wrote:
> The Software Delegated Exception Interface (SDEI) is an ARM standard
> for registering callbacks from the platform firmware into the OS.
> This is typically used to implement RAS notifications.
> 
> Such notifications enter the kernel at the registered entry-point
> with the register values of the interrupted CPU context. Because this
> is not a CPU exception, it cannot reuse the existing entry code.
> (crucially we don't implicitly know which exception level we interrupted),
> 
> Add an sdei-entry.S asm file to set us up for calling into C code. If
> the event interrupted code that had interrupts masked, we always return
> to that location. Otherwise we pretend this was an IRQ, and use SDEI's
> complete_and_resume call to return to vbar_el1 + offset.
> 
> This allows the kernel to deliver signals to user space processes. For
> KVM this triggers the world switch, a quick spin round vcpu_run, then
> back into the guest, unless there are pending signals.
> 
> Add sdei_mask_local_cpu() calls to the smp_send_stop() code, this covers
> the panic() code-path, which doesn't invoke cpuhotplug notifiers.
> 
> Because we can interrupt entry-from/exit-to another EL, we can't trust the
> value in sp_el0 or x29, even if we interrupted the kernel, in this case
> the code in entry.S will save/restore sp_el0 and use the value in
> __entry_task.
> 
> When we have VMAP stacks we can interrupt the stack-overflow test, which
> stirs x0 into sp, meaning we have to have our own VMAP stack.
> 
> Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>

Reviewed-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>

> +static __kprobes unsigned long _sdei_handler(struct pt_regs *regs,
> +					     struct sdei_registered_event *arg)
> +{
> +	u32 mode;
> +	int i, err = 0;
> +	const int clobbered_registers = 4;
> +	u64 elr = read_sysreg(elr_el1);
> +	u32 kernel_mode = read_sysreg(CurrentEL) | 1;	/* +SPSel */
> +	unsigned long vbar = read_sysreg(vbar_el1);
> +
> +	/* Retrieve the missing registers values */
> +	for (i = 0; i < clobbered_registers; i++) {
> +		/* from within the handler, this call always succeeds */
> +		sdei_api_event_context(i, &regs->regs[i]);
> +	}
> +
> +	/*
> +	 * We didn't take an exception to get here, set PAN. UAO will be cleared
> +	 * by sdei_event_handler()s set_fs(USER_DS) call.
> +	 */
> +	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,
> +			CONFIG_ARM64_PAN));

We have a similar asm in __cpu_suspend_exit(), so there's precedent. As
a separate patch (not part of this series), we should move them into
a macro, e.g. __uaccess_disable_hw_pan() (enabling as well for
consistency).

-- 
Catalin
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
