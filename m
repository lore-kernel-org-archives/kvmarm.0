From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v1 02/16] irqchip: gicv3-its: Add helpers for handling
 52bit address
Date: Wed, 7 Feb 2018 16:10:23 +0100
Message-ID: <20180207151023.GD29286@cbox>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-3-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180109190414.4017-3-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On Tue, Jan 09, 2018 at 07:03:57PM +0000, Suzuki K Poulose wrote:
> Add helpers for encoding/decoding 52bit address in GICv3 ITS BASER
> register. When ITS uses 64K page size, the 52bits of physical address
> are encoded in BASER[47:12] as follows :
> 
>  Bits[47:16] of the register => bits[47:16] of the physical address
>  Bits[15:12] of the register => bits[51:48] of the physical address
>                                 bits[15:0] of the physical address are 0.
> 
> Also adds a mask for CBASER address. This will be used for adding 52bit
> support for VGIC ITS. More importantly ignore the upper bits if 52bit
> support is not enabled.
> 
> Cc: Shanker Donthineni <shankerd@codeaurora.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  drivers/irqchip/irq-gic-v3-its.c   |  2 +-
>  include/linux/irqchip/arm-gic-v3.h | 32 ++++++++++++++++++++++++++++++--
>  2 files changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 4039e64cd342..e6aa84f806f7 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -1615,7 +1615,7 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
>  		}
>  
>  		/* Convert 52bit PA to 48bit field */
> -		baser_phys = GITS_BASER_PHYS_52_to_48(baser_phys);
> +		baser_phys = GITS_BASER_ADDR64K_FROM_PHYS(baser_phys);
>  	}
>  
>  retry_baser:
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index c00c4c33e432..b880b6682fa6 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -320,6 +320,15 @@
>  #define GITS_IIDR_REV(r)		(((r) >> GITS_IIDR_REV_SHIFT) & 0xf)
>  #define GITS_IIDR_PRODUCTID_SHIFT	24
>  
> +#ifdef CONFIG_ARM64_PA_BITS_52
> +#define GITS_PA_HI_MASK			(0xfULL)
> +#define GITS_PA_SHIFT			52
> +#else
> +/* Do not use the bits [51-48] if we don't support 52bit */
> +#define GITS_PA_HI_MASK			0
> +#define GITS_PA_SHIFT			48
> +#endif
> +
>  #define GITS_CBASER_VALID			(1ULL << 63)
>  #define GITS_CBASER_SHAREABILITY_SHIFT		(10)
>  #define GITS_CBASER_INNER_CACHEABILITY_SHIFT	(59)
> @@ -343,6 +352,7 @@
>  #define GITS_CBASER_WaWb	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, WaWb)
>  #define GITS_CBASER_RaWaWt	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWt)
>  #define GITS_CBASER_RaWaWb	GIC_BASER_CACHEABILITY(GITS_CBASER, INNER, RaWaWb)
> +#define GITS_CBASER_ADDRESS(x)	((x) & GENMASK_ULL(GITS_PA_SHIFT, 12))
>  
>  #define GITS_BASER_NR_REGS		8
>  
> @@ -373,8 +383,26 @@
>  #define GITS_BASER_ENTRY_SIZE_SHIFT		(48)
>  #define GITS_BASER_ENTRY_SIZE(r)	((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) & 0x1f) + 1)
>  #define GITS_BASER_ENTRY_SIZE_MASK	GENMASK_ULL(52, 48)
> -#define GITS_BASER_PHYS_52_to_48(phys)					\
> -	(((phys) & GENMASK_ULL(47, 16)) | (((phys) >> 48) & 0xf) << 12)
> +
> +/*
> + * With 64K page size, the physical address can be upto 52bit and
> + * uses the following encoding in the GITS_BASER[47:12]:
> + *
> + * Bits[47:16] of the register => bits[47:16] of the base physical address.
> + * Bits[15:12] of the register => bits[51:48] of the base physical address.
> + *                                bits[15:0] of the base physical address are 0.
> + * Clear the upper bits if the kernel doesn't support 52bits.
> + */
> +#define GITS_BASER_ADDR64K_LO_MASK	GENMASK_ULL(47, 16)
> +#define GITS_BASER_ADDR64K_HI_SHIFT	12
> +#define GITS_BASER_ADDR64K_HI_MOVE	(48 - GITS_BASER_ADDR64K_HI_SHIFT)
> +#define GITS_BASER_ADDR64K_HI_MASK	(GITS_PA_HI_MASK << GITS_BASER_ADDR64K_HI_SHIFT)
> +#define GITS_BASER_ADDR64K_TO_PHYS(x)					\
> +	(((x) & GITS_BASER_ADDR64K_LO_MASK) | 				\
> +	 (((x) & GITS_BASER_ADDR64K_HI_MASK) << GITS_BASER_ADDR64K_HI_MOVE))
> +#define GITS_BASER_ADDR64K_FROM_PHYS(p)					\
> +	(((p) & GITS_BASER_ADDR64K_LO_MASK) | 				\
> +	 (((p) >> GITS_BASER_ADDR64K_HI_MOVE) & GITS_BASER_ADDR64K_HI_MASK))

I don't understand why you need this masking logic embedded in these
macros?  Isn't it strictly an error if anyone passes a physical address
with any of bits [51:48] set to the ITS on a system that doesn't support
52 bit PAs, and just silently masking off those bits could lead to some
interesting cases.

This is also notably more difficult to read than the existing macro.

If anything, I think it would be more useful to have
GITS_BASER_TO_PHYS(x) and GITS_PHYS_TO_BASER(x) which takes into account
CONFIG_ARM64_64K_PAGES.

>  #define GITS_BASER_SHAREABILITY_SHIFT	(10)
>  #define GITS_BASER_InnerShareable					\
>  	GIC_BASER_SHAREABILITY(GITS_BASER, InnerShareable)
> -- 
> 2.13.6
> 

Thanks,
-Christoffer
