From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 02/17] arm64: Cleanup VTCR_EL2 and VTTBR field values
Date: Fri, 8 Apr 2016 14:43:46 +0200
Message-ID: <20160408124346.GN8961@cbox>
References: <1459787177-12767-1-git-send-email-suzuki.poulose@arm.com>
 <1459787177-12767-3-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6A1B4113E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 08:42:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2Yac80mFuCpT for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 08:42:07 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E67A540F9B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 08:42:06 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id 191so17114766wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2016 05:43:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1459787177-12767-3-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 04, 2016 at 05:26:02PM +0100, Suzuki K Poulose wrote:
> We share most of the bits for VTCR_EL2 for different page sizes,
> except for the TG0 value and the entry level value. This patch
> makes the definitions a bit more cleaner to reflect this fact.
> 
> Also cleans up the VTTBR_X calculation. No funcational changes.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h |   23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index c460cfe..d5d5fdf 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -144,32 +144,31 @@
>   * The magic numbers used for VTTBR_X in this patch can be found in Tables
>   * D4-23 and D4-25 in ARM DDI 0487A.b.
>   */
> +#define VTCR_EL2_T0SZ_IPA	VTCR_EL2_T0SZ_40B
> +#define VTCR_EL2_COMMON_BITS	(VTCR_EL2_SH0_INNER | VTCR_EL2_ORGN0_WBWA | \
> +				 VTCR_EL2_IRGN0_WBWA | VTCR_EL2_SL0_LVL1 | \
> +				 VTCR_EL2_RES1 | VTCR_EL2_T0SZ_IPA)
>  #ifdef CONFIG_ARM64_64K_PAGES
>  /*
>   * Stage2 translation configuration:
> - * 40bits input  (T0SZ = 24)
>   * 64kB pages (TG0 = 1)
>   * 2 level page tables (SL = 1)
>   */
> -#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SH0_INNER | \
> -				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
> -				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B | \
> -				 VTCR_EL2_RES1)
> -#define VTTBR_X		(38 - VTCR_EL2_T0SZ_40B)
> +#define VTCR_EL2_TGRAN_FLAGS	(VTCR_EL2_TG0_64K | VTCR_EL2_SL0_LVL1)
> +#define VTTBR_X_TGRAN_MAGIC		38
>  #else
>  /*
>   * Stage2 translation configuration:
> - * 40bits input  (T0SZ = 24)
>   * 4kB pages (TG0 = 0)
>   * 3 level page tables (SL = 1)
>   */
> -#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SH0_INNER | \
> -				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
> -				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B | \
> -				 VTCR_EL2_RES1)
> -#define VTTBR_X		(37 - VTCR_EL2_T0SZ_40B)
> +#define VTCR_EL2_TGRAN_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SL0_LVL1)
> +#define VTTBR_X_TGRAN_MAGIC		37
>  #endif

why do we add VTCR_EL2_SL0_LVL1 in both the common bits and TGRAN_FLAGS
define?

Otherwise:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

>  
> +#define VTCR_EL2_FLAGS		(VTCR_EL2_TGRAN_FLAGS | VTCR_EL2_COMMON_BITS)
> +#define VTTBR_X			(VTTBR_X_TGRAN_MAGIC - VTCR_EL2_T0SZ_IPA)
> +
>  #define VTTBR_BADDR_SHIFT (VTTBR_X - 1)
>  #define VTTBR_BADDR_MASK  (((UL(1) << (PHYS_MASK_SHIFT - VTTBR_X)) - 1) << VTTBR_BADDR_SHIFT)
>  #define VTTBR_VMID_SHIFT  (UL(48))
> -- 
> 1.7.9.5
> 
