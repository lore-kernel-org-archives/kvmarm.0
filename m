From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 4/4] arm64: Work around Falkor erratum 1009
Date: Fri, 27 Jan 2017 15:07:23 +0000
Message-ID: <20170127150722.GN21144@arm.com>
References: <20170125155232.10277-1-cov@codeaurora.org>
 <20170125155232.10277-4-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0597F4018B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Jan 2017 10:07:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WdhviiS-vCvG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Jan 2017 10:07:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EE41400E9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Jan 2017 10:07:08 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170125155232.10277-4-cov@codeaurora.org>
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
Cc: Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, timur@codeaurora.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Neil Leeder <nleeder@codeaurora.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 25, 2017 at 10:52:32AM -0500, Christopher Covington wrote:
> During a TLB invalidate sequence targeting the inner shareable domain,
> Falkor may prematurely complete the DSB before all loads and stores using
> the old translation are observed. Instruction fetches are not subject to
> the conditions of this erratum. If the original code sequence includes
> multiple TLB invalidate instructions followed by a single DSB, onle one of
> the TLB instructions needs to be repeated to work around this erratum.
> While the erratum only applies to cases in which the TLBI specifies the
> inner-shareable domain (*IS form of TLBI) and the DSB is ISH form or
> stronger (OSH, SYS), this changes applies the workaround overabundantly--
> to local TLBI, DSB NSH sequences as well--for simplicity.
> 
> Based on work by Shanker Donthineni <shankerd@codeaurora.org>
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> ---
>  Documentation/arm64/silicon-errata.txt |  1 +
>  arch/arm64/Kconfig                     | 10 ++++++++++
>  arch/arm64/include/asm/cpucaps.h       |  3 ++-
>  arch/arm64/include/asm/tlbflush.h      | 18 +++++++++++++++---
>  arch/arm64/kernel/cpu_errata.c         |  7 +++++++
>  5 files changed, 35 insertions(+), 4 deletions(-)

Thanks, this one looks good to me. It doesn't apply without the other
erratum workaround (due to conflicts), so I'll have to wait for the
discussion with Mark to each a conclusion before I can queue it.

One minor comment inline...

> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index deab52374119..fc434f421c7b 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -36,9 +36,21 @@
>   * not. The macros handles invoking the asm with or without the
>   * register argument as appropriate.
>   */
> -#define __TLBI_0(op, arg)		asm ("tlbi " #op)
> -#define __TLBI_1(op, arg)		asm ("tlbi " #op ", %0" : : "r" (arg))
> -#define __TLBI_N(op, arg, n, ...)	__TLBI_##n(op, arg)
> +#define __TLBI_0(op, arg) asm volatile ("tlbi " #op "\n"		       \
> +			    ALTERNATIVE("nop\n		nop",		       \
> +					"dsb ish\n	tlbi " #op,	       \
> +					ARM64_WORKAROUND_REPEAT_TLBI,	       \
> +					CONFIG_QCOM_FALKOR_ERRATUM_1009)       \
> +			    : : )
> +
> +#define __TLBI_1(op, arg) asm volatile ("tlbi " #op ", %0\n"		       \
> +			    ALTERNATIVE("nop\n		nop",		       \
> +					"dsb ish\n	tlbi " #op ", %0",     \
> +					ARM64_WORKAROUND_REPEAT_TLBI,	       \
> +					CONFIG_QCOM_FALKOR_ERRATUM_1009)       \
> +			    : : "r" (arg))

I don't think you need to make these volatile.

Will
