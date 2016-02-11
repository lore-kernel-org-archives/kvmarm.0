From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Configure TCR_EL2.PS at runtime
Date: Thu, 11 Feb 2016 14:27:08 +0100
Message-ID: <20160211132708.GU5171@cbox>
References: <1455130013-28644-1-git-send-email-tchalamarla@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C9C549B8F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 08:20:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qrLXth60FxIe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 08:20:34 -0500 (EST)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7B6349B6D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 08:20:33 -0500 (EST)
Received: by mail-wm0-f44.google.com with SMTP id g62so68832598wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 05:26:28 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1455130013-28644-1-git-send-email-tchalamarla@caviumnetworks.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: tchalamarla@caviumnetworks.com
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 10, 2016 at 10:46:53AM -0800, tchalamarla@caviumnetworks.com wrote:
> From: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>
> 
> Setting TCR_EL2.PS to 40 bits is wrong on systems with PS size is
> less than 40 bits. and with systems where RAM is at higher address,
> this will break KVM.
> 
> This patch sets TCR_EL2.PS at runtime similar to VTCR_EL2.PS
> 
> changes form V2:
> 	- Modified subject line and commit message.
> 	- Removed TCR_EL2_FLAGS.
> 
> changes from V1:
>         - Moved to dynamic configuration.
> 
> Signed-off-by: Tirumalesh Chalamarla <tchalamarla@caviumnetworks.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h |  2 --
>  arch/arm64/kvm/hyp-init.S        | 12 +++++++-----
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 738a95f..3776db0 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -107,8 +107,6 @@
>  #define TCR_EL2_MASK	(TCR_EL2_TG0 | TCR_EL2_SH0 | \
>  			 TCR_EL2_ORGN0 | TCR_EL2_IRGN0 | TCR_EL2_T0SZ)
>  
> -#define TCR_EL2_FLAGS	(TCR_EL2_RES1 | TCR_EL2_PS_40B)
> -
>  /* VTCR_EL2 Registers bits */
>  #define VTCR_EL2_RES1		(1 << 31)
>  #define VTCR_EL2_PS_MASK	(7 << 16)
> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
> index 3e568dc..b5ab1b0 100644
> --- a/arch/arm64/kvm/hyp-init.S
> +++ b/arch/arm64/kvm/hyp-init.S
> @@ -64,7 +64,7 @@ __do_hyp_init:
>  	mrs	x4, tcr_el1
>  	ldr	x5, =TCR_EL2_MASK
>  	and	x4, x4, x5
> -	ldr	x5, =TCR_EL2_FLAGS
> +	ldr	x5, =TCR_EL2_RES1
>  	orr	x4, x4, x5
>  
>  #ifndef CONFIG_ARM64_VA_BITS_48
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
> -- 
> 2.1.0
> 

This looks reasonable enough for me.  Did we limit Linux to PS=40 bits
in the past and have lifted this restriction, or why did we have this
limitation for EL2 translations in the past?

Thanks,
-Christoffer
