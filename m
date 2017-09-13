From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 10/28] arm64/sve: Low-level CPU setup
Date: Wed, 13 Sep 2017 20:21:11 +0100
Message-ID: <20170913192110.GE23415@e103592.cambridge.arm.com>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-11-git-send-email-Dave.Martin@arm.com>
 <20170913133206.rwobtu7ft5nrsh4p@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6C8C49C19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 15:18:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mejckPxmCy38 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Sep 2017 15:18:35 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C362F40FA5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 15:18:35 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170913133206.rwobtu7ft5nrsh4p@localhost>
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
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 13, 2017 at 06:32:06AM -0700, Catalin Marinas wrote:
> On Thu, Aug 31, 2017 at 06:00:42PM +0100, Dave P Martin wrote:
> > diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
> > index 877d42f..dd22ef2 100644
> > --- a/arch/arm64/mm/proc.S
> > +++ b/arch/arm64/mm/proc.S
> > @@ -27,6 +27,7 @@
> >  #include <asm/pgtable-hwdef.h>
> >  #include <asm/cpufeature.h>
> >  #include <asm/alternative.h>
> > +#include <asm/sysreg.h>
> >  
> >  #ifdef CONFIG_ARM64_64K_PAGES
> >  #define TCR_TG_FLAGS	TCR_TG0_64K | TCR_TG1_64K
> > @@ -186,8 +187,17 @@ ENTRY(__cpu_setup)
> >  	tlbi	vmalle1				// Invalidate local TLB
> >  	dsb	nsh
> >  
> > -	mov	x0, #3 << 20
> > -	msr	cpacr_el1, x0			// Enable FP/ASIMD
> > +	mov	x0, #3 << 20			// FEN
> > +
> > +	/* SVE */
> > +	mrs	x5, id_aa64pfr0_el1
> > +	ubfx	x5, x5, #ID_AA64PFR0_SVE_SHIFT, #4
> > +	cbz	x5, 1f
> > +
> > +	bic	x0, x0, #CPACR_EL1_ZEN
> > +	orr	x0, x0, #CPACR_EL1_ZEN_EL1EN	// SVE: trap for EL0, not EL1
> > +1:	msr	cpacr_el1, x0			// Enable FP/ASIMD
> 
> For EL1, I wonder whether we could move this later to cpufeature.c. IIRC
> I tried to do the same with FPSIMD but hit an issue with EFI run-time
> services (I may be wrong though).

I'll take a look at this -- I believe it should be safe to disable this
trap for EL1 relatively late.  This is needed before probing for
available vector lengths, but apart from that the kernel shouldn't touch
SVE until/unless some user task uses SVE.

This would change if we eventually enable kernel-mode SVE, but I wouldn't
expect that to get used in early boot before the cpufeatures code runs.

Ard may have a view on this.

Cheers
---Dave
