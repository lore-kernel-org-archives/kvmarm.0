From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 12/18] kvm: arm64: Configure VTCR_EL2.SL0 per VM
Date: Thu, 20 Sep 2018 16:25:54 +0200
Message-ID: <dcc855e4-eb78-ea1b-9456-8efa36deda4e@redhat.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
 <20180917104144.19188-13-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180917104144.19188-13-suzuki.poulose@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, catalin.marinas@arm.com, james.morse@arm.com, dave.martin@arm.com, julien.grall@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,
On 9/17/18 12:41 PM, Suzuki K Poulose wrote:
> VTCR_EL2 holds the following key stage2 translation table
> parameters:
>   SL0  - Entry level in the page table lookup.
>   T0SZ - Denotes the size of the memory addressed by the table.
> 
> We have been using fixed values for the SL0 depending on the
> page size as we have a fixed IPA size. But since we are about
> to make it dynamic, we need to calculate the SL0 at runtime
> per VM. This patch adds a helper to compute the value of SL0
> for a VM based on the IPA size.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@kernel.org>
> Cc: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v3:
>  - Update reference to latest ARM ARM.
>  - Update per-vm VTCR value of SL0.
>  - Add helpers to decode levels from SL0.
>  - Didn't pick up Reviewed-by tag from Eric, as there
>    are some new changes in this version
> ---
>  arch/arm64/include/asm/kvm_arm.h | 51 +++++++++++++++++++++++++-------
>  arch/arm64/kvm/reset.c           |  1 +
>  2 files changed, 41 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 3fb1d440be6e..5c1487dc5dca 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -121,7 +121,6 @@
>  #define VTCR_EL2_IRGN0_WBWA	TCR_IRGN0_WBWA
>  #define VTCR_EL2_SL0_SHIFT	6
>  #define VTCR_EL2_SL0_MASK	(3 << VTCR_EL2_SL0_SHIFT)
> -#define VTCR_EL2_SL0_LVL1	(1 << VTCR_EL2_SL0_SHIFT)
>  #define VTCR_EL2_T0SZ_MASK	0x3f
>  #define VTCR_EL2_VS_SHIFT	19
>  #define VTCR_EL2_VS_8BIT	(0 << VTCR_EL2_VS_SHIFT)
> @@ -148,29 +147,59 @@
>  /*
>   * Stage2 translation configuration:
>   * 64kB pages (TG0 = 1)
> - * 2 level page tables (SL = 1)
>   */
> -#define VTCR_EL2_TGRAN_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SL0_LVL1)
> -#define VTTBR_X_TGRAN_MAGIC		38
> +#define VTCR_EL2_TGRAN			VTCR_EL2_TG0_64K
> +#define VTCR_EL2_TGRAN_SL0_BASE		3UL
the name if not obvious. I understand this is yet another magic number
used in the formulae below:
SL0(PAGE_SIZE, Entry_level) = SL0_BASE(PAGE_SIZE) - Entry_Level
I first tried to map this onto some spec fields. May be worth a comment?

Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> +
>  #elif defined(CONFIG_ARM64_16K_PAGES)
>  /*
>   * Stage2 translation configuration:
>   * 16kB pages (TG0 = 2)
> - * 2 level page tables (SL = 1)
>   */
> -#define VTCR_EL2_TGRAN_FLAGS		(VTCR_EL2_TG0_16K | VTCR_EL2_SL0_LVL1)
> -#define VTTBR_X_TGRAN_MAGIC		42
> +#define VTCR_EL2_TGRAN			VTCR_EL2_TG0_16K
> +#define VTCR_EL2_TGRAN_SL0_BASE		3UL
>  #else	/* 4K */
>  /*
>   * Stage2 translation configuration:
>   * 4kB pages (TG0 = 0)
> - * 3 level page tables (SL = 1)
>   */
> -#define VTCR_EL2_TGRAN_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SL0_LVL1)
> -#define VTTBR_X_TGRAN_MAGIC		37
> +#define VTCR_EL2_TGRAN			VTCR_EL2_TG0_4K
> +#define VTCR_EL2_TGRAN_SL0_BASE		2UL
>  #endif
>  
> -#define VTCR_EL2_FLAGS			(VTCR_EL2_COMMON_BITS | VTCR_EL2_TGRAN_FLAGS)
> +#define VTCR_EL2_FLAGS			(VTCR_EL2_COMMON_BITS | VTCR_EL2_TGRAN)
> +/*
> + * VTCR_EL2:SL0 indicates the entry level for Stage2 translation.
> + * Interestingly, it depends on the page size.
> + * See D.10.2.121, VTCR_EL2, in ARM DDI 0487C.a
> + *
> + *	-----------------------------------------
> + *	| Entry level		|  4K  | 16K/64K |
> + *	------------------------------------------
> + *	| Level: 0		|  2   |   -     |
> + *	------------------------------------------
> + *	| Level: 1		|  1   |   2     |
> + *	------------------------------------------
> + *	| Level: 2		|  0   |   1     |
> + *	------------------------------------------
> + *	| Level: 3		|  -   |   0     |
> + *	------------------------------------------
> + *
> + * That table roughly translates to :
> + *
> + *	SL0(PAGE_SIZE, Entry_level) = SL0_BASE(PAGE_SIZE) - Entry_Level
> + *
> + * Where SL0_BASE(4K) = 2 and SL0_BASE(16K) = 3, SL0_BASE(64K) = 3, provided
> + * we take care of ruling out the unsupported cases and
> + * Entry_Level = 4 - Number_of_levels.
> + *
> + */
> +#define VTCR_EL2_LVLS_TO_SL0(levels)	\
> +	((VTCR_EL2_TGRAN_SL0_BASE - (4 - (levels))) << VTCR_EL2_SL0_SHIFT)
> +#define VTCR_EL2_SL0_TO_LVLS(sl0)	\
> +	((sl0) + 4 - VTCR_EL2_TGRAN_SL0_BASE)
> +#define VTCR_EL2_LVLS(vtcr)		\
> +	VTCR_EL2_SL0_TO_LVLS(((vtcr) & VTCR_EL2_SL0_MASK) >> VTCR_EL2_SL0_SHIFT)
>  /*
>   * ARM VMSAv8-64 defines an algorithm for finding the translation table
>   * descriptors in section D4.2.8 in ARM DDI 0487C.a.
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index e0c49377b771..d9b7a00993b6 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -167,6 +167,7 @@ int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
>  	vtcr |= (kvm_get_vmid_bits() == 16) ?
>  		VTCR_EL2_VS_16BIT :
>  		VTCR_EL2_VS_8BIT;
> +	vtcr |= VTCR_EL2_LVLS_TO_SL0(kvm_stage2_levels(kvm));
>  	kvm->arch.vtcr = vtcr;
>  	return 0;
>  }
> 
