From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm64: Work around Falkor erratum 1009
Date: Thu, 8 Dec 2016 11:20:43 +0000
Message-ID: <20161208112042.GB706@arm.com>
References: <20161207200028.4420-1-cov@codeaurora.org>
 <20161207200431.4587-1-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE82640419
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2016 06:19:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NpCU0w6tmlvs for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2016 06:19:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A19E401BF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2016 06:19:41 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161207200431.4587-1-cov@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 1004a3d..125440f 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -485,6 +485,16 @@ config QCOM_FALKOR_ERRATUM_E1003
>  
>  	  If unsure, say Y.
>  
> +config QCOM_FALKOR_ERRATUM_E1009
> +	bool "Falkor E1009: Prematurely complete a DSB after a TLBI"
> +	default y
> +	help
> +	  Falkor CPU may prematurely complete a DSB following a TLBI xxIS
> +	  invalidate maintenance operations. Repeat the TLBI operation one
> +	  more time to fix the issue.
> +
> +	  If unsure, say Y.

Call me perverse, but I like this workaround. People often tend to screw
up TLBI and DVM sync, but the IPI-based workaround is horribly invasive
and fragile. Simply repeating the operation tends to be enough to make
the chance of failure small enough to be acceptable.

> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index cb6a8c2..5357d7f 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -35,7 +35,8 @@
>  #define ARM64_HYP_OFFSET_LOW			14
>  #define ARM64_MISMATCHED_CACHE_LINE_SIZE	15
>  #define ARM64_WORKAROUND_QCOM_FALKOR_E1003	16
> +#define ARM64_WORKAROUND_QCOM_FALKOR_E1009	17

Could you rename this to something like ARM64_WORKAROUND_REPEAT_TLBI, so
that it could potentially be used by others?

>  
> -#define ARM64_NCAPS				17
> +#define ARM64_NCAPS				18
>  
>  #endif /* __ASM_CPUCAPS_H */
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index deab523..03bafc5 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -23,6 +23,7 @@
>  
>  #include <linux/sched.h>
>  #include <asm/cputype.h>
> +#include <asm/alternative.h>
>  
>  /*
>   * Raw TLBI operations.
> @@ -94,6 +95,13 @@ static inline void flush_tlb_all(void)
>  	dsb(ishst);
>  	__tlbi(vmalle1is);
>  	dsb(ish);
> +	asm volatile(ALTERNATIVE(
> +		     "nop \n"
> +		     "nop \n",
> +		     "tlbi vmalle1is \n"
> +		     "dsb ish \n",
> +		     ARM64_WORKAROUND_QCOM_FALKOR_E1009)
> +		     : :);

I'd much rather this was part of the __tlbi macro, which would hopefully
restrict this to one place in the code.

Will
