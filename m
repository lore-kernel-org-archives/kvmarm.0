From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH V2] arm64: KVM: Configure TCR_EL2.ps at runtime
Date: Wed, 10 Feb 2016 07:31:00 +0000
Message-ID: <20160210073100.235478c7@arm.com>
References: <1455056113-25948-1-git-send-email-tchalamarla@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1455056113-25948-1-git-send-email-tchalamarla@caviumnetworks.com>
Sender: kvm-owner@vger.kernel.org
To: tchalamarla@caviumnetworks.com
Cc: christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 9 Feb 2016 14:15:13 -0800
<tchalamarla@caviumnetworks.com> wrote:

Tirumalesh,

> From: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>
> 
> Setting TCR_EL2.ps to 40 bits is wrong on systems with ps size is
> less than 40 bits. and with systems where RAM is at higher address,
> this will break KVM.
> 
> This patch sets TCR_EL2.ps at runtime similar to VTCR_EL.ps

VTCR_EL2.PS (and please use capital letters to designate a field in a
given register).

> 
> Signed-off-by: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h |  5 ++++-
>  arch/arm64/kvm/hyp-init.S        | 10 ++++++----
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 738a95f..92f2ffd 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -107,7 +107,10 @@
>  #define TCR_EL2_MASK	(TCR_EL2_TG0 | TCR_EL2_SH0 | \
>  			 TCR_EL2_ORGN0 | TCR_EL2_IRGN0 | TCR_EL2_T0SZ)
>  
> -#define TCR_EL2_FLAGS	(TCR_EL2_RES1 | TCR_EL2_PS_40B)
> +/*
> + * TCR_EL2.ps is configured at runtime similar to VTCR_EL2
> + */
> +#define TCR_EL2_FLAGS	(TCR_EL2_RES1)

Now that you've reduced the flags to be the reserved bits only, why not
clean it up for good, and directly use TCR_EL2_RES1? Also, that comment
is pretty pointless, as the whole of TCR_EL2 is now dynamically
configured, not just the PS field.

>  
>  /* VTCR_EL2 Registers bits */
>  #define VTCR_EL2_RES1		(1 << 31)
> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
> index 3e568dc..b246de1e 100644
> --- a/arch/arm64/kvm/hyp-init.S
> +++ b/arch/arm64/kvm/hyp-init.S
> @@ -85,15 +85,17 @@ __do_hyp_init:
>  	ldr_l	x5, idmap_t0sz
>  	bfi	x4, x5, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
>  #endif
> -	msr	tcr_el2, x4
> -
> -	ldr	x4, =VTCR_EL2_FLAGS
>  	/*
>  	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the PS bits in
> -	 * VTCR_EL2.
> +	 * TCR_EL2 and VTCR_EL2.
>  	 */
>  	mrs	x5, ID_AA64MMFR0_EL1
>  	bfi	x4, x5, #16, #3
> +
> +	msr	tcr_el2, x4
> +
> +	ldr	x4, =VTCR_EL2_FLAGS
> +	bfi	x4, x5, #16, #3
>  	/*
>  	 * Read the VMIDBits bits from ID_AA64MMFR1_EL1 and set the VS bit in
>  	 * VTCR_EL2.

Otherwise look OK to me.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
