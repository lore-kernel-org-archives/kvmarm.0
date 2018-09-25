From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 15/18] kvm: arm64: Add 52bit support for PAR to HPFAR
 conversoin
Date: Tue, 25 Sep 2018 11:59:36 +0200
Message-ID: <b6929b5d-e797-6922-a5d2-3a1ded517e1a@redhat.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
 <20180917104144.19188-16-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180917104144.19188-16-suzuki.poulose@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, catalin.marinas@arm.com, james.morse@arm.com, dave.martin@arm.com, julien.grall@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On 9/17/18 12:41 PM, Suzuki K Poulose wrote:
> Add support for handling 52bit addresses in PAR to HPFAR
> conversion. Instead of hardcoding the address limits, we
> now use PHYS_MASK_SHIFT.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@kernel.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  arch/arm64/include/asm/kvm_arm.h | 7 +++++++
>  arch/arm64/kvm/hyp/switch.c      | 2 +-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 0a37c0513ede..241d1622fa19 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -308,6 +308,13 @@
>  
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK	(~UL(0xf))
> +/*
> + * We have
> + *	PAR	[PA_Shift - 1	: 12] = PA	[PA_Shift - 1 : 12]
> + *	HPFAR	[PA_Shift - 9	: 4]  = FIPA	[PA_Shift - 1 : 12]
> + */
> +#define PAR_TO_HPFAR(par)		\
> +	(((par) & GENMASK_ULL(PHYS_MASK_SHIFT - 1, 12)) >> 8)
>  
>  #define kvm_arm_exception_type	\
>  	{0, "IRQ" }, 		\
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 9d5ce1a3039a..7cc175c88a37 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -263,7 +263,7 @@ static bool __hyp_text __translate_far_to_hpfar(u64 far, u64 *hpfar)
>  		return false; /* Translation failed, back to guest */
>  
>  	/* Convert PAR to HPFAR format */
> -	*hpfar = ((tmp >> 12) & ((1UL << 36) - 1)) << 4;
> +	*hpfar = PAR_TO_HPFAR(tmp);
>  	return true;
>  }
>  
> 
