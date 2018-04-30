From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v2 10/17] kvm: arm64: Dynamic configuration of VTCR and
 VTTBR mask
Date: Mon, 30 Apr 2018 12:14:04 +0100
Message-ID: <1c7cca39-ab37-711a-85af-7bd2162ae8ec@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
 <1522156531-28348-11-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522156531-28348-11-git-send-email-suzuki.poulose@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

The algos in this patch looks good to me. A couple of NIT below.

On 27/03/18 14:15, Suzuki K Poulose wrote:
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index b0c8417..176551c 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -124,6 +124,8 @@
>   #define VTCR_EL2_VS_8BIT	(0 << VTCR_EL2_VS_SHIFT)
>   #define VTCR_EL2_VS_16BIT	(1 << VTCR_EL2_VS_SHIFT)
>   
> +#define VTCR_EL2_T0SZ(x)	TCR_T0SZ((x))

NIT: The inner parentheses should not be necessary.

[...]

> +/*
> + * VTCR_EL2:SL0 indicates the entry level for Stage2 translation.
> + * Interestingly, it depends on the page size.
> + * See D.10.2.110, VTCR_EL2, in ARM DDI 0487B.b
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
> +#define VTCR_EL2_SL0(levels) \
> +	((VTCR_EL2_TGRAN_SL0_BASE - (4 - (levels))) << VTCR_EL2_SL0_SHIFT)
> +/*
> + * ARM VMSAv8-64 defines an algorithm for finding the translation table
> + * descriptors in section D4.2.8 in ARM DDI 0487B.b.
> + *
> + * The algorithm defines the expectaions on the BaseAddress (for the page

NIT: s/expectaions/expectations/

Cheers,


-- 
Julien Grall
