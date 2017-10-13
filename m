From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 04/13] arm64: alternatives: use tpidr_el2 on VHE hosts
Date: Fri, 13 Oct 2017 16:31:48 +0100
Message-ID: <20171013153148.dnejsvhxeui6opfw@armageddon.cambridge.arm.com>
References: <20170922182614.27885-1-james.morse@arm.com>
 <20170922182614.27885-5-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170922182614.27885-5-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 22, 2017 at 07:26:05PM +0100, James Morse wrote:
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index cd52d365d1f0..8e4c7da2b126 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -865,6 +865,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.capability = ARM64_HAS_VIRT_HOST_EXTN,
>  		.def_scope = SCOPE_SYSTEM,
>  		.matches = runs_at_el2,
> +		.enable = cpu_copy_el2regs,
>  	},
>  	{
>  		.desc = "32-bit EL0 Support",
> @@ -1308,3 +1309,25 @@ static int __init enable_mrs_emulation(void)
>  }
>  
>  late_initcall(enable_mrs_emulation);
> +
> +int cpu_copy_el2regs(void *__unused)
> +{
> +	int do_copyregs = 0;
> +
> +	/*
> +	 * Copy register values that aren't redirected by hardware.
> +	 *
> +	 * Before code patching, we only set tpidr_el1, all CPUs need to copy
> +	 * this value to tpidr_el2 before we patch the code. Once we've done
> +	 * that, freshly-onlined CPUs will set tpidr_el2, so we don't need to
> +	 * do anything here.
> +	 */
> +	asm volatile(ALTERNATIVE("mov %0, #1", "mov %0, #0",
> +				 ARM64_HAS_VIRT_HOST_EXTN)
> +		    : "=r" (do_copyregs) : : );

Can you just do:

	if (cpu_have_const_cap(ARM64_HAS_VIRT_HOST_EXTN))
		write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);

At this point the capability bits should be set and the jump labels
enabled.

Otherwise:

Reviewed-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
