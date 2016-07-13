From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v9 07/17] irqchip: refactor and add GICv3 definitions
Date: Wed, 13 Jul 2016 13:28:12 +0100
Message-ID: <578633DC.4070806@arm.com>
References: <20160713015909.28793-1-andre.przywara@arm.com>
 <20160713015909.28793-8-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 789A949B2C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 08:22:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FDgEVDqzyVzq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jul 2016 08:22:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5732449B1D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 08:22:23 -0400 (EDT)
In-Reply-To: <20160713015909.28793-8-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 13/07/16 02:58, Andre Przywara wrote:
> arm-gic-v3.h contains bit and register definitions for the GICv3 and ITS,
> at least for the bits the we currently care about.
> The ITS emulation needs more definitions, so add them and refactor
> the memory attribute #defines to be more universally usable.
> To avoid changing all users, we still provide some of the old definitons
> defined with the help of the new macros.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/linux/irqchip/arm-gic-v3.h | 174 ++++++++++++++++++++++++-------------
>  1 file changed, 114 insertions(+), 60 deletions(-)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index bfbd707..ed61647 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -112,34 +112,58 @@
>  #define GICR_WAKER_ProcessorSleep	(1U << 1)
>  #define GICR_WAKER_ChildrenAsleep	(1U << 2)
>  
> -#define GICR_PROPBASER_NonShareable	(0U << 10)
> -#define GICR_PROPBASER_InnerShareable	(1U << 10)
> -#define GICR_PROPBASER_OuterShareable	(2U << 10)
> -#define GICR_PROPBASER_SHAREABILITY_MASK (3UL << 10)
> -#define GICR_PROPBASER_nCnB		(0U << 7)
> -#define GICR_PROPBASER_nC		(1U << 7)
> -#define GICR_PROPBASER_RaWt		(2U << 7)
> -#define GICR_PROPBASER_RaWb		(3U << 7)
> -#define GICR_PROPBASER_WaWt		(4U << 7)
> -#define GICR_PROPBASER_WaWb		(5U << 7)
> -#define GICR_PROPBASER_RaWaWt		(6U << 7)
> -#define GICR_PROPBASER_RaWaWb		(7U << 7)
> -#define GICR_PROPBASER_CACHEABILITY_MASK (7U << 7)
> -#define GICR_PROPBASER_IDBITS_MASK	(0x1f)
> -
> -#define GICR_PENDBASER_NonShareable	(0U << 10)
> -#define GICR_PENDBASER_InnerShareable	(1U << 10)
> -#define GICR_PENDBASER_OuterShareable	(2U << 10)
> -#define GICR_PENDBASER_SHAREABILITY_MASK (3UL << 10)
> -#define GICR_PENDBASER_nCnB		(0U << 7)
> -#define GICR_PENDBASER_nC		(1U << 7)
> -#define GICR_PENDBASER_RaWt		(2U << 7)
> -#define GICR_PENDBASER_RaWb		(3U << 7)
> -#define GICR_PENDBASER_WaWt		(4U << 7)
> -#define GICR_PENDBASER_WaWb		(5U << 7)
> -#define GICR_PENDBASER_RaWaWt		(6U << 7)
> -#define GICR_PENDBASER_RaWaWb		(7U << 7)
> -#define GICR_PENDBASER_CACHEABILITY_MASK (7U << 7)
> +#define GIC_BASER_CACHE_nCnB		0ULL
> +#define GIC_BASER_CACHE_SameAsInner	0ULL
> +#define GIC_BASER_CACHE_nC		1ULL
> +#define GIC_BASER_CACHE_RaWt		2ULL
> +#define GIC_BASER_CACHE_RaWb		3ULL
> +#define GIC_BASER_CACHE_WaWt		4ULL
> +#define GIC_BASER_CACHE_WaWb		5ULL
> +#define GIC_BASER_CACHE_RaWaWt		6ULL
> +#define GIC_BASER_CACHE_RaWaWb		7ULL
> +#define GIC_BASER_CACHE_MASK		7ULL
> +#define GIC_BASER_NonShareable		0ULL
> +#define GIC_BASER_InnerShareable	1ULL
> +#define GIC_BASER_OuterShareable	2ULL
> +#define GIC_BASER_SHAREABILITY_MASK	3ULL
> +
> +#define GIC_BASER_CACHEABILITY(reg, inner_outer, type)			\
> +	(GIC_BASER_CACHE_##type << reg##_##inner_outer##_CACHEABILITY_SHIFT)
> +
> +#define GIC_BASER_SHAREABILITY(reg, type)				\
> +	(GIC_BASER_##type << reg##_SHAREABILITY_SHIFT)
> +
> +#define GICR_PROPBASER_SHAREABILITY_SHIFT		(10)
> +#define GICR_PROPBASER_INNER_CACHEABILITY_SHIFT		(7)
> +#define GICR_PROPBASER_OUTER_CACHEABILITY_SHIFT		(56)
> +#define GICR_PROPBASER_SHAREABILITY_MASK				\
> +	GIC_BASER_SHAREABILITY(GICR_PROPBASER, SHAREABILITY_MASK)
> +#define GICR_PROPBASER_CACHEABILITY_MASK				\
> +	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, MASK)
> +#define GICR_PROPBASER_OUTER_CACHEABILITY_MASK				\
> +	GIC_BASER_CACHEABILITY(GICR_PROPBASER, OUTER, MASK)

Inner Cacheability : GICR_PROPBASER_CACHEABILITY_MASK
Outer Cacheability : GICR_PROPBASER_OUTER_CACHEABILITY_MASK

Why don't we have a symmetric naming (GICR_PROPBASER_INNER_CACHEABILITY_MASK)?

I'm all for having some backward compatibility, but given
that you're adding a lot of those, you should make sure that
the new stuff is not ambiguous.

This applies throughout the file.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
