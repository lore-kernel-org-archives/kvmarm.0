From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] arm64: Work around Falkor erratum 1009
Date: Thu, 8 Dec 2016 11:45:12 +0000
Message-ID: <20161208114511.GC9768@leverpostej>
References: <20161207200028.4420-1-cov@codeaurora.org>
 <20161207200431.4587-1-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161207200431.4587-1-cov@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Covington <cov@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 07, 2016 at 03:04:31PM -0500, Christopher Covington wrote:
> From: Shanker Donthineni <shankerd@codeaurora.org>
> 
> During a TLB invalidate sequence targeting the inner shareable
> domain, Falkor may prematurely complete the DSB before all loads
> and stores using the old translation are observed; instruction
> fetches are not subject to the conditions of this erratum.
> 
> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> ---
>  arch/arm64/Kconfig                | 10 +++++++++
>  arch/arm64/include/asm/cpucaps.h  |  3 ++-
>  arch/arm64/include/asm/tlbflush.h | 43 +++++++++++++++++++++++++++++++++++++++
>  arch/arm64/kernel/cpu_errata.c    |  7 +++++++
>  arch/arm64/kvm/hyp/tlb.c          | 39 ++++++++++++++++++++++++++++++-----
>  5 files changed, 96 insertions(+), 6 deletions(-)

Please update Documentation/arm64/silicon-errata.txt respectively.

[...]

>  #include <linux/sched.h>
>  #include <asm/cputype.h>
> +#include <asm/alternative.h>

Nit: please keep includes (alphabetically) ordered (at least below the
linux/ or asm/ level).

[...]

> +	asm volatile(ALTERNATIVE(
> +		     "nop \n"
> +		     "nop \n",
> +		     "tlbi vmalle1is \n"
> +		     "dsb ish \n",

As a general note, perhaps we want a C compatible NOP_ALTERNATIVE() so
that the nop case can be implicitly generated for sequences like this.

Thanks,
Mark.
