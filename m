From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 03/12] arm64: kvm: Cleanup VTCR_EL2/VTTBR computation
Date: Wed, 16 Mar 2016 15:01:48 +0000
Message-ID: <56E9755C.9090701@arm.com>
References: <1457974391-28456-1-git-send-email-suzuki.poulose@arm.com>
 <1457974391-28456-4-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457974391-28456-4-git-send-email-suzuki.poulose@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, christoffer.dall@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, kvm@vger.kernel.org, will.deacon@arm.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 14/03/16 16:53, Suzuki K Poulose wrote:
> No functional changes. Group the common bits for VCTR_EL2
> initialisation for better readability. The granule size
> and the entry level are controlled by the page size.
> 
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h |   22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index b7d61e4..d49dd50 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -139,32 +139,30 @@
>   * The magic numbers used for VTTBR_X in this patch can be found in Tables
>   * D4-23 and D4-25 in ARM DDI 0487A.b.
>   */
> +#define VTCR_EL2_COMMON_BITS	(VTCR_EL2_SH0_INNER | VTCR_EL2_ORGN0_WBWA | \
> +				 VTCR_EL2_IRGN0_WBWA | VTCR_EL2_SL0_LVL1 | \
> +				 VTCR_EL2_RES1 | VTCR_EL2_T0SZ_40B)
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
>  
> +#define VTCR_EL2_FLAGS		(VTCR_EL2_TGRAN_FLAGS | VTCR_EL2_COMMON_BITS)
> +#define VTTBR_X			((VTTBR_X_TGRAN_MAGIC) - VTCR_EL2_T0SZ_40B)

Nit: spurious brackets.

It would be nice to add an ARMv8 ARM reference to where the "magic"
value is coming from.

> +
>  #define VTTBR_BADDR_SHIFT (VTTBR_X - 1)
>  #define VTTBR_BADDR_MASK  (((UL(1) << (PHYS_MASK_SHIFT - VTTBR_X)) - 1) << VTTBR_BADDR_SHIFT)
>  #define VTTBR_VMID_SHIFT  (UL(48))
> 

Otherwise:

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
