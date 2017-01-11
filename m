From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 2/5] arm64: Work around Falkor erratum 1003
Date: Wed, 11 Jan 2017 18:40:52 +0000
Message-ID: <20170111184052.GE29247@leverpostej>
References: <20170111144118.17062-1-cov@codeaurora.org>
 <20170111144118.17062-2-cov@codeaurora.org>
 <20170111180627.GG20288@e104818-lin.cambridge.arm.com>
 <278a45c0-bd49-b8a2-63ae-80ad851bab9b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <278a45c0-bd49-b8a2-63ae-80ad851bab9b@arm.com>
Sender: linux-doc-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Christopher Covington <cov@codeaurora.org>, Mark Langsdorf <mlangsdo@redhat.com>, linux-doc@vger.kernel.org, kvm@vger.kernel.org, Jon Masters <jcm@redhat.com>, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 11, 2017 at 06:22:08PM +0000, Marc Zyngier wrote:
> On 11/01/17 18:06, Catalin Marinas wrote:
> > On Wed, Jan 11, 2017 at 09:41:15AM -0500, Christopher Covington wrote:
> >> diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
> >> index 32682be..9ee46df 100644
> >> --- a/arch/arm64/mm/proc.S
> >> +++ b/arch/arm64/mm/proc.S
> >> @@ -23,6 +23,7 @@
> >>  #include <asm/assembler.h>
> >>  #include <asm/asm-offsets.h>
> >>  #include <asm/hwcap.h>
> >> +#include <asm/mmu_context.h>
> >>  #include <asm/pgtable.h>
> >>  #include <asm/pgtable-hwdef.h>
> >>  #include <asm/cpufeature.h>
> >> @@ -140,6 +141,18 @@ ENDPROC(cpu_do_resume)
> >>  ENTRY(cpu_do_switch_mm)
> >>  	mmid	x1, x1				// get mm->context.id
> >>  	bfi	x0, x1, #48, #16		// set the ASID
> >> +#ifdef CONFIG_QCOM_FALKOR_ERRATUM_1003
> >> +alternative_if ARM64_WORKAROUND_QCOM_FALKOR_E1003
> >> +	mrs     x2, ttbr0_el1
> >> +	mov     x3, #FALKOR_RESERVED_ASID
> >> +	bfi     x2, x3, #48, #16                // reserved ASID + old BADDR
> >> +	msr     ttbr0_el1, x2
> >> +	isb
> >> +	bfi     x2, x0, #0, #48                 // reserved ASID + new BADDR
> >> +	msr     ttbr0_el1, x2
> >> +	isb
> >> +alternative_else_nop_endif
> >> +#endif
> >>  	msr	ttbr0_el1, x0			// set TTBR0
> >>  	isb
> >>  	post_ttbr0_update_workaround
> > 
> > Please move the above hunk to a pre_ttbr0_update_workaround macro for
> > consistency with post_ttbr0_update_workaround.
> 
> In which case (and also for consistency), should we add that pre_ttbr0
> macro to entry.S, just before __uaccess_ttbr0_enable? It may not be
> needed in the SW pan case, but it is probably worth entertaining the
> idea that there may be something to do there...

Likewise, I beleive we may need to modify cpu_set_reserved_ttbr0().

Thanks,
Mark.
