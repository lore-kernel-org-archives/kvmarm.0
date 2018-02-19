From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm64: Add support for new control bits CTR_EL0.IDC and
 CTR_EL0.IDC
Date: Mon, 19 Feb 2018 14:43:46 +0000
Message-ID: <20180219144346.GF30394@arm.com>
References: <1518829066-3558-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3308E402B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Feb 2018 09:37:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tcuwI+D7LsIO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Feb 2018 09:37:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7524640259
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Feb 2018 09:37:06 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1518829066-3558-1-git-send-email-shankerd@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Philip Elcan <pelcan@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Shanker,

On Fri, Feb 16, 2018 at 06:57:46PM -0600, Shanker Donthineni wrote:
> Two point of unification cache maintenance operations 'DC CVAU' and
> 'IC IVAU' are optional for implementors as per ARMv8 specification.
> This patch parses the updated CTR_EL0 register definition and adds
> the required changes to skip POU operations if the hardware reports
> CTR_EL0.IDC and/or CTR_EL0.IDC.
> 
> CTR_EL0.DIC: Instruction cache invalidation requirements for
>  instruction to data coherence. The meaning of this bit[29].
>   0: Instruction cache invalidation to the point of unification
>      is required for instruction to data coherence.
>   1: Instruction cache cleaning to the point of unification is
>       not required for instruction to data coherence.
> 
> CTR_EL0.IDC: Data cache clean requirements for instruction to data
>  coherence. The meaning of this bit[28].
>   0: Data cache clean to the point of unification is required for
>      instruction to data coherence, unless CLIDR_EL1.LoC == 0b000
>      or (CLIDR_EL1.LoUIS == 0b000 && CLIDR_EL1.LoUU == 0b000).
>   1: Data cache clean to the point of unification is not required
>      for instruction to data coherence.
> 
> Signed-off-by: Philip Elcan <pelcan@codeaurora.org>
> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
> ---
>  arch/arm64/include/asm/assembler.h | 48 ++++++++++++++++++++++++--------------
>  arch/arm64/include/asm/cache.h     |  2 ++
>  arch/arm64/kernel/cpufeature.c     |  2 ++
>  arch/arm64/mm/cache.S              | 26 ++++++++++++++-------
>  4 files changed, 51 insertions(+), 27 deletions(-)

I was looking at our CTR_EL0 code last week but forgot to post the patch I
wrote fixing up some of the fields. I just send it now, so please can
you rebase on top of:

http://lists.infradead.org/pipermail/linux-arm-kernel/2018-February/560488.html

Also:

> diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
> index ea9bb4e..aea533b 100644
> --- a/arch/arm64/include/asm/cache.h
> +++ b/arch/arm64/include/asm/cache.h
> @@ -22,6 +22,8 @@
>  #define CTR_L1IP_MASK		3
>  #define CTR_CWG_SHIFT		24
>  #define CTR_CWG_MASK		15
> +#define CTR_IDC_SHIFT		28
> +#define CTR_DIC_SHIFT		29
>  
>  #define CTR_L1IP(ctr)		(((ctr) >> CTR_L1IP_SHIFT) & CTR_L1IP_MASK)
>  
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 29b1f87..f42bb5a 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -200,6 +200,8 @@ static int __init register_cpu_hwcaps_dumper(void)
>  
>  static const struct arm64_ftr_bits ftr_ctr[] = {
>  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, 31, 1, 1),	/* RAO */
> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_DIC_SHIFT, 1, 0),	/* DIC */
> +	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_IDC_SHIFT, 1, 0),	/* IDC */
>  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, 24, 4, 0),	/* CWG */
>  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 20, 4, 0),	/* ERG */
>  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 16, 4, 1),	/* DminLine */

Could you update the other table entries here to use the CTR_*_SHIFT values
as well?

Thanks,

Will
