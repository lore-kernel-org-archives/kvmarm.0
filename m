From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 09/13] arm64: kernel: Add arch-specific SDEI entry
 code and CPU masking
Date: Wed, 18 Oct 2017 11:54:23 +0100
Message-ID: <20171018105422.53lnvivuq37e2oy4@armageddon.cambridge.arm.com>
References: <20170922182614.27885-1-james.morse@arm.com>
 <20170922182614.27885-10-james.morse@arm.com>
 <20171016134139.sqe6xabdson2d5rd@armageddon.cambridge.arm.com>
 <59E63105.9080804@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <59E63105.9080804-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 17, 2017 at 05:34:13PM +0100, James Morse wrote:
> On 16/10/17 14:41, Catalin Marinas wrote:
> > On Fri, Sep 22, 2017 at 07:26:10PM +0100, James Morse wrote:
> >> +	u64 elr = read_sysreg(elr_el1);
> >> +	u32 kernel_mode = read_sysreg(CurrentEL) | 1;	/* +SPSel */
> >> +	unsigned long vbar = read_sysreg(vbar_el1);
> >> +
> >> +	/* Retrieve the missing registers values */
> >> +	for (i = 0; i < clobbered_registers; i++) {
> >> +		/* from within the handler, this call always succeeds */
> >> +		sdei_api_event_context(i, &regs->regs[i]);
> >> +	}
> >> +
> >> +	/*
> >> +	 * We didn't take an exception to get here, set PAN. UAO will be cleared
> >> +	 * by sdei_event_handler()s set_fs(USER_DS) call.
> >> +	 */
> >> +	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,
> >> +			CONFIG_ARM64_PAN));
> 
> > Can you use uaccess_disable() directly?
> 
> Wouldn't this invoke sw-pan's __uaccess_ttbr0_disable():
> > write_sysreg(ttbr, ttbr0_el1);
> 
> Probing depends on VHE if booted at EL2, can we guarantee to have PAN (and
> therefore not-SW-PAN) too?
> 
> (otherwise I can add 'depends on !ARM64_SW_TTBR0_PAN' to the Kconfig)

We want the Kconfig to be able to include all features. What you can do
though is:

	select ARM64_PAN if ARM64_SW_TTBR0_PAN

With VHE (ARMv8.2) we can guarantee that hardware PAN is around.

-- 
Catalin
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
