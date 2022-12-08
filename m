Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651723217
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 17:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1D9C433D2;
	Thu,  8 Dec 2022 17:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670519948;
	bh=I1CSpUBU7BxOxxi2wTdea/eH35Ygu6IV9K5QyEvzVDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kWZlSQFFbUzA10IYH5DEiIFoNl45je2eMZBXWPJTYHtvhgfXJps5MTLqHTziEIjRu
	 /G/dkckIuOMsGcsfUXwNTmAdDY4FnqmwGrHTUn9zaPBOAp6yE8YqGkX50ZsJRPatn+
	 ozcOR9gfseOIpRIdOQGyGKR8PxBIi/97bQHHI7vVLiSNitEuSQCFVqNDsKQHkpG9zH
	 Zaz/Q9h9hJ2jwddBwN6fsSWkg8JU0/Gziuu0wCROjMuvu4JvuHWTIDkFgk2WbDsIV1
	 eUH86NrKPJr5qmLxQlFCSsDmyVUMV5w6rP3SZGqhaf3jufe+0EbX3Y2rOR0uLu/C3f
	 BXdwORdBIsc5w==
Date: Thu, 8 Dec 2022 18:19:02 +0100
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 10/14] arm64/nmi: Manage masking for superpriority
 interrupts along with DAIF
Message-ID: <Y5IchpFrIB3y8575@lpieralisi>
References: <20221112151708.175147-1-broonie@kernel.org>
 <20221112151708.175147-11-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112151708.175147-11-broonie@kernel.org>

On Sat, Nov 12, 2022 at 03:17:04PM +0000, Mark Brown wrote:
> As we do for pseudo NMIs add code to our DAIF management which keeps
> superpriority interrupts unmasked when we have asynchronous exceptions
> enabled. Since superpriority interrupts are not masked through DAIF like
> pseduo NMIs are we also need to modify the assembler macros for managing
> DAIF to ensure that the masking is done in the assembly code. At present
> users of the assembly macros always mask pseudo NMIs.
> 
> There is a difference to the actual handling between pseudo NMIs
> and superpriority interrupts in the assembly save_and_disable_irq and
> restore_irq macros, these cover both interrupts and FIQs using DAIF
> without regard for the use of pseudo NMIs so also mask those but are not
> updated here to mask superpriority interrupts. Given the names it is not
> clear that the behaviour with pseudo NMIs is particularly intentional,
> and in any case these macros are only used in the implementation of
> alternatives for software PAN while hardware PAN has been mandatory
> since v8.1 so it is not anticipated that practical systems with support
> for FEAT_NMI will ever execute the affected code.
> 
> This should be a conservative set of masked regions, we may be able to
> relax this in future, but this should represent a good starting point.

I think I found a nasty spot. We are currently not handling ALLINT in
arch_local_irq_enable/disable(). The issue I am facing is that we might
end up preempting in IRQ context with ALLINT set in the exception path
- arm64_preempt_schedule_irq() - which means we are running with all
IRQs masked (that's normal; what's not normal is that local_irq_enable()
does not clear ALLINT, see below).

When we schedule (preempt_schedule_irq()) we do require a
local_irq_enable() to enable IRQs; ALLINT is still set, so
local_irq_enable() does not do what is expected so we are calling
__schedule() with IRQs disabled, which does not seem right.

Now we need to debate what the fix for this can be but nonetheless
it is something to be addressed.

Clearing and setting ALLINT in arch_local_irq_enable()/disable()
seems to solve the issue (now I moved on to debugging something
else, will post the outcome here because this fix does not seem
to fix the issue completely or I am hitting another bug).

Lorenzo

> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/assembler.h | 11 +++++++++++
>  arch/arm64/include/asm/daifflags.h | 18 ++++++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index 88d9779a83c0..e85a7e9af9ae 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -52,19 +52,30 @@ alternative_else_nop_endif
>  
>  	.macro save_and_disable_daif, flags
>  	mrs	\flags, daif
> +        disable_allint
>  	msr	daifset, #0xf
>  	.endm
>  
>  	.macro disable_daif
> +        disable_allint
>  	msr	daifset, #0xf
>  	.endm
>  
>  	.macro enable_daif
>  	msr	daifclr, #0xf
> +	enable_allint
>  	.endm
>  
>  	.macro	restore_daif, flags:req
>  	msr	daif, \flags
> +#ifdef CONFIG_ARM64_NMI
> +alternative_if ARM64_HAS_NMI
> +	/* If async exceptions are unmasked we can take NMIs */
> +	tbnz	\flags, #8, 2004f
> +	msr_s	SYS_ALLINT_CLR, xzr
> +2004:
> +alternative_else_nop_endif
> +#endif
>  	.endm
>  
>  	/* IRQ/FIQ are the lowest priority flags, unconditionally unmask the rest. */
> diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
> index b3bed2004342..fda73976068f 100644
> --- a/arch/arm64/include/asm/daifflags.h
> +++ b/arch/arm64/include/asm/daifflags.h
> @@ -10,6 +10,7 @@
>  #include <asm/arch_gicv3.h>
>  #include <asm/barrier.h>
>  #include <asm/cpufeature.h>
> +#include <asm/nmi.h>
>  #include <asm/ptrace.h>
>  
>  #define DAIF_PROCCTX		0
> @@ -35,6 +36,9 @@ static inline void local_daif_mask(void)
>  	if (system_uses_irq_prio_masking())
>  		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
>  
> +	if (system_uses_nmi())
> +		_allint_set();
> +
>  	trace_hardirqs_off();
>  }
>  
> @@ -50,6 +54,12 @@ static inline unsigned long local_daif_save_flags(void)
>  			flags |= PSR_I_BIT | PSR_F_BIT;
>  	}
>  
> +	if (system_uses_nmi()) {
> +		/* If IRQs are masked with ALLINT, reflect in in the flags */
> +		if (read_sysreg_s(SYS_ALLINT) & ALLINT_ALLINT)
> +			flags |= PSR_I_BIT | PSR_F_BIT;
> +	}
> +
>  	return flags;
>  }
>  
> @@ -114,6 +124,10 @@ static inline void local_daif_restore(unsigned long flags)
>  		gic_write_pmr(pmr);
>  	}
>  
> +	/* If we can take asynchronous errors we can take NMIs */
> +	if (system_uses_nmi() && !(flags & PSR_A_BIT))
> +		_allint_clear();
> +
>  	write_sysreg(flags, daif);
>  
>  	if (irq_disabled)
> @@ -131,6 +145,10 @@ static inline void local_daif_inherit(struct pt_regs *regs)
>  	if (interrupts_enabled(regs))
>  		trace_hardirqs_on();
>  
> +	/* If we can take asynchronous errors we can take NMIs */
> +	if (system_uses_nmi() && !(flags & PSR_A_BIT))
> +		_allint_clear();
> +
>  	if (system_uses_irq_prio_masking())
>  		gic_write_pmr(regs->pmr_save);
>  
> -- 
> 2.30.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
