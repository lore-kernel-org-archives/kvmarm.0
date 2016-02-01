From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 05/21] arm64: KVM: VHE: Turn VTCR_EL2 setup into a
 reusable macro
Date: Mon, 1 Feb 2016 14:13:00 +0100
Message-ID: <20160201131300.GH1478@cbox>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-6-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BC9E40FA2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 08:07:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OkNAbs9FpJnN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2016 08:07:17 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5AA4940BDA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 08:07:17 -0500 (EST)
Received: by mail-wm0-f41.google.com with SMTP id l66so69600495wml.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Feb 2016 05:12:34 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1453737235-16522-6-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 25, 2016 at 03:53:39PM +0000, Marc Zyngier wrote:
> On a VHE-capable system, there is no point in setting VTCR_EL2
> at KVM init time. We can perfectly set it up when the kernel
> boots, removing the need for a more complicated configuration.

what's the complicated configuration which is avoided?

> 
> In order to allow this, turn VTCR_EL2 setup into a macro that
> we'll be able to reuse at boot time.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h | 23 +++++++++++++++++++++++
>  arch/arm64/kvm/hyp-init.S        | 18 +-----------------
>  2 files changed, 24 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 7364339..d3e6d7b 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -56,6 +56,29 @@
>  
>  #ifdef __ASSEMBLY__
>  
> +#include <asm/kvm_arm.h>
> +
> +.macro setup_vtcr tmp1, tmp2
> +	mov	\tmp1, #(VTCR_EL2_FLAGS & 0xffff)
> +	movk	\tmp1, #(VTCR_EL2_FLAGS >> 16), lsl #16
> +	/*
> +	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the PS bits in
> +	 * VTCR_EL2.
> +	 */
> +	mrs	\tmp2, id_aa64mmfr0_el1
> +	bfi	\tmp1, \tmp2, #16, #3
> +	/*
> +	 * Read the VMIDBits bits from ID_AA64MMFR1_EL1 and set the VS bit in
> +	 * VTCR_EL2.
> +	 */
> +	mrs	\tmp2, ID_AA64MMFR1_EL1
> +	ubfx	\tmp2, \tmp2, #5, #1
> +	lsl	\tmp2, \tmp2, #VTCR_EL2_VS
> +	orr	\tmp1, \tmp1, \tmp2
> +
> +	msr	vtcr_el2, \tmp1
> +	isb
> +.endm

this feels like an awful lot of code in a header file.

Is it crazy to imagine wanting to have different T0SZ for different VMs
in the future?  In that case, the T0SZ stuff should stay in KVM...

Thanks,
-Christoffer

>  /*
>   * Convert a kernel VA into a HYP VA.
>   * reg: VA to be converted.
> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
> index 3e568dc..4143e2c 100644
> --- a/arch/arm64/kvm/hyp-init.S
> +++ b/arch/arm64/kvm/hyp-init.S
> @@ -87,23 +87,7 @@ __do_hyp_init:
>  #endif
>  	msr	tcr_el2, x4
>  
> -	ldr	x4, =VTCR_EL2_FLAGS
> -	/*
> -	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the PS bits in
> -	 * VTCR_EL2.
> -	 */
> -	mrs	x5, ID_AA64MMFR0_EL1
> -	bfi	x4, x5, #16, #3
> -	/*
> -	 * Read the VMIDBits bits from ID_AA64MMFR1_EL1 and set the VS bit in
> -	 * VTCR_EL2.
> -	 */
> -	mrs	x5, ID_AA64MMFR1_EL1
> -	ubfx	x5, x5, #5, #1
> -	lsl	x5, x5, #VTCR_EL2_VS
> -	orr	x4, x4, x5
> -
> -	msr	vtcr_el2, x4
> +	setup_vtcr x4, x5
>  
>  	mrs	x4, mair_el1
>  	msr	mair_el2, x4
> -- 
> 2.1.4
> 
