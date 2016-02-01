From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 06/21] arm64: KVM: VHE: Patch out use of HVC
Date: Mon, 1 Feb 2016 14:16:34 +0100
Message-ID: <20160201131634.GI1478@cbox>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-7-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453737235-16522-7-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 25, 2016 at 03:53:40PM +0000, Marc Zyngier wrote:
> With VHE, the host never issues an HVC instruction to get into the
> KVM code, as we can simply branch there.
> 
> Use runtime code patching to simplify things a bit.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp.S           |  7 +++++++
>  arch/arm64/kvm/hyp/hyp-entry.S | 38 +++++++++++++++++++++++++++++---------
>  2 files changed, 36 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index 0ccdcbb..0689a74 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -17,7 +17,9 @@
>  
>  #include <linux/linkage.h>
>  
> +#include <asm/alternative.h>
>  #include <asm/assembler.h>
> +#include <asm/cpufeature.h>
>  
>  /*
>   * u64 kvm_call_hyp(void *hypfn, ...);
> @@ -38,6 +40,11 @@
>   * arch/arm64/kernel/hyp_stub.S.
>   */
>  ENTRY(kvm_call_hyp)
> +alternative_if_not ARM64_HAS_VIRT_HOST_EXTN	
>  	hvc	#0
>  	ret
> +alternative_else
> +	b	__vhe_hyp_call
> +	nop
> +alternative_endif
>  ENDPROC(kvm_call_hyp)
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index 93e8d983..9e0683f 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -38,6 +38,32 @@
>  	ldp	x0, x1, [sp], #16
>  .endm
>  
> +.macro do_el2_call
> +	/*
> +	 * Shuffle the parameters before calling the function
> +	 * pointed to in x0. Assumes parameters in x[1,2,3].
> +	 */
> +	stp	lr, xzr, [sp, #-16]!

remind me why this pair isn't just doing "str" instead of "stp" with the
xzr ?

> +	mov	lr, x0
> +	mov	x0, x1
> +	mov	x1, x2
> +	mov	x2, x3
> +	blr	lr
> +	ldp	lr, xzr, [sp], #16
> +.endm
> +
> +ENTRY(__vhe_hyp_call)
> +	do_el2_call
> +	/*
> +	 * We used to rely on having an exception return to get
> +	 * an implicit isb. In the E2H case, we don't have it anymore.
> +	 * rather than changing all the leaf functions, just do it here
> +	 * before returning to the rest of the kernel.
> +	 */

why is this not the case with an ISB before do_el2_call then?

> +	isb
> +	ret
> +ENDPROC(__vhe_hyp_call)
> +	
>  el1_sync:				// Guest trapped into EL2
>  	save_x0_to_x3
>  
> @@ -58,19 +84,13 @@ el1_sync:				// Guest trapped into EL2
>  	mrs	x0, vbar_el2
>  	b	2f
>  
> -1:	stp	lr, xzr, [sp, #-16]!
> -
> +1:
>  	/*
> -	 * Compute the function address in EL2, and shuffle the parameters.
> +	 * Perform the EL2 call
>  	 */
>  	kern_hyp_va	x0
> -	mov	lr, x0
> -	mov	x0, x1
> -	mov	x1, x2
> -	mov	x2, x3
> -	blr	lr
> +	do_el2_call
>  
> -	ldp	lr, xzr, [sp], #16
>  2:	eret
>  
>  el1_trap:
> -- 
> 2.1.4
> 
