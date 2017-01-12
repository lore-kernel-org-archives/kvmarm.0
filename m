From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 2/5] arm64: Work around Falkor erratum 1003
Date: Thu, 12 Jan 2017 16:07:34 +0000
Message-ID: <20170112160733.GG13843@arm.com>
References: <20170111144118.17062-1-cov@codeaurora.org>
 <20170111144118.17062-2-cov@codeaurora.org>
 <20170111180627.GG20288@e104818-lin.cambridge.arm.com>
 <278a45c0-bd49-b8a2-63ae-80ad851bab9b@arm.com>
 <20170112155558.ud4ln3lk5lpwxrq3@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32B0540423
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 11:05:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vAD5D6QW1r-3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 11:05:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C8C940284
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 11:05:46 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170112155558.ud4ln3lk5lpwxrq3@localhost>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Jonathan Corbet <corbet@lwn.net>, Mark Langsdorf <mlangsdo@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>, timur@codeaurora.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 12, 2017 at 03:55:58PM +0000, Catalin Marinas wrote:
> On Wed, Jan 11, 2017 at 06:22:08PM +0000, Marc Zyngier wrote:
> > On 11/01/17 18:06, Catalin Marinas wrote:
> > > On Wed, Jan 11, 2017 at 09:41:15AM -0500, Christopher Covington wrote:
> > >> diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
> > >> index 32682be..9ee46df 100644
> > >> --- a/arch/arm64/mm/proc.S
> > >> +++ b/arch/arm64/mm/proc.S
> > >> @@ -23,6 +23,7 @@
> > >>  #include <asm/assembler.h>
> > >>  #include <asm/asm-offsets.h>
> > >>  #include <asm/hwcap.h>
> > >> +#include <asm/mmu_context.h>
> > >>  #include <asm/pgtable.h>
> > >>  #include <asm/pgtable-hwdef.h>
> > >>  #include <asm/cpufeature.h>
> > >> @@ -140,6 +141,18 @@ ENDPROC(cpu_do_resume)
> > >>  ENTRY(cpu_do_switch_mm)
> > >>  	mmid	x1, x1				// get mm->context.id
> > >>  	bfi	x0, x1, #48, #16		// set the ASID
> > >> +#ifdef CONFIG_QCOM_FALKOR_ERRATUM_1003
> > >> +alternative_if ARM64_WORKAROUND_QCOM_FALKOR_E1003
> > >> +	mrs     x2, ttbr0_el1
> > >> +	mov     x3, #FALKOR_RESERVED_ASID
> > >> +	bfi     x2, x3, #48, #16                // reserved ASID + old BADDR
> > >> +	msr     ttbr0_el1, x2
> > >> +	isb
> > >> +	bfi     x2, x0, #0, #48                 // reserved ASID + new BADDR
> > >> +	msr     ttbr0_el1, x2
> > >> +	isb
> > >> +alternative_else_nop_endif
> > >> +#endif
> > >>  	msr	ttbr0_el1, x0			// set TTBR0
> > >>  	isb
> > >>  	post_ttbr0_update_workaround
> > > 
> > > Please move the above hunk to a pre_ttbr0_update_workaround macro for
> > > consistency with post_ttbr0_update_workaround.
> > 
> > In which case (and also for consistency), should we add that pre_ttbr0
> > macro to entry.S, just before __uaccess_ttbr0_enable? It may not be
> > needed in the SW pan case, but it is probably worth entertaining the
> > idea that there may be something to do there...
> 
> It may actually be needed in entry.S as well. With SW PAN, we move the
> context switching from cpu_do_switch_mm to the kernel_exit macro when
> returning to user. In this case we are switching from the reserved ASID
> 0 and reserved TTBR0_EL1 (pointing to a zeroed page) to the user's
> TTBR0_EL1 and ASID. If the ASID switch isn't taken into account, we may
> end up with new TLB entries being tagged with the reserved ASID. Apart
> from a potential loss of protection with TTBR0 PAN, is there anything
> else that could go wrong? Maybe a TLB conflict if we mix TLBs from
> multiple address spaces tagged with the same reserved ASID.
> 
> If the above is an issue, we would need to patch
> __uaccess_ttbr0_enable() as well, though I'm more inclined to make this
> erratum not selectable when TTBR0 PAN is enabled.

I don't think that's a reasonable approach. By all means change the
default, but we need to support kernel images with both of these kconfig
options enabled.

Will
