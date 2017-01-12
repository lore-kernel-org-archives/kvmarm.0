From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 2/5] arm64: Work around Falkor erratum 1003
Date: Thu, 12 Jan 2017 15:55:58 +0000
Message-ID: <20170112155558.ud4ln3lk5lpwxrq3@localhost>
References: <20170111144118.17062-1-cov@codeaurora.org>
 <20170111144118.17062-2-cov@codeaurora.org>
 <20170111180627.GG20288@e104818-lin.cambridge.arm.com>
 <278a45c0-bd49-b8a2-63ae-80ad851bab9b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <278a45c0-bd49-b8a2-63ae-80ad851bab9b@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christopher Covington <cov@codeaurora.org>, Mark Langsdorf <mlangsdo@redhat.com>, linux-doc@vger.kernel.org, kvm@vger.kernel.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Jon Masters <jcm@redhat.com>, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, Christoffer Dall <christoffer.dall@linaro.org>, Mark Salter <msalter@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

It may actually be needed in entry.S as well. With SW PAN, we move the
context switching from cpu_do_switch_mm to the kernel_exit macro when
returning to user. In this case we are switching from the reserved ASID
0 and reserved TTBR0_EL1 (pointing to a zeroed page) to the user's
TTBR0_EL1 and ASID. If the ASID switch isn't taken into account, we may
end up with new TLB entries being tagged with the reserved ASID. Apart
from a potential loss of protection with TTBR0 PAN, is there anything
else that could go wrong? Maybe a TLB conflict if we mix TLBs from
multiple address spaces tagged with the same reserved ASID.

If the above is an issue, we would need to patch
__uaccess_ttbr0_enable() as well, though I'm more inclined to make this
erratum not selectable when TTBR0 PAN is enabled.

-- 
Catalin
