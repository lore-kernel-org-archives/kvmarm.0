From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 05/15] arm64: KVM: Refactor kern_hyp_va/hyp_kern_va to
 deal with multiple offsets
Date: Tue, 28 Jun 2016 14:42:10 +0200
Message-ID: <20160628124210.GP26498@cbox>
References: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
 <1465297115-13091-6-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7A7149B32
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 08:36:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oU0aEzPWNejh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jun 2016 08:36:12 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6889449B2C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 08:36:12 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id r190so27027272wmr.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 05:41:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1465297115-13091-6-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jun 07, 2016 at 11:58:25AM +0100, Marc Zyngier wrote:
> As we move towards a selectable HYP VA range, it is obvious that
> we don't want to test a variable to find out if we need to use
> the bottom VA range, the top VA range, or use the address as is
> (for VHE).
> 
> Instead, we can expand our current helpers to generate the right
> mask or nop with code patching. We default to using the top VA
> space, with alternatives to switch to the bottom one or to nop
> out the instructions.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/kvm_hyp.h | 27 ++++++++++++--------------
>  arch/arm64/include/asm/kvm_mmu.h | 42 +++++++++++++++++++++++++++++++++++++---
>  2 files changed, 51 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 61d01a9..dd4904b 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -25,24 +25,21 @@
>  
>  #define __hyp_text __section(.hyp.text) notrace
>  
> -static inline unsigned long __kern_hyp_va(unsigned long v)
> -{
> -	asm volatile(ALTERNATIVE("and %0, %0, %1",
> -				 "nop",
> -				 ARM64_HAS_VIRT_HOST_EXTN)
> -		     : "+r" (v) : "i" (HYP_PAGE_OFFSET_MASK));
> -	return v;
> -}
> -
> -#define kern_hyp_va(v) (typeof(v))(__kern_hyp_va((unsigned long)(v)))
> -
>  static inline unsigned long __hyp_kern_va(unsigned long v)
>  {
> -	asm volatile(ALTERNATIVE("orr %0, %0, %1",
> -				 "nop",
> +	u64 mask;
> +
> +	asm volatile(ALTERNATIVE("mov %0, %1",
> +				 "mov %0, %2",
> +				 ARM64_HYP_OFFSET_LOW)
> +		     : "=r" (mask)
> +		     : "i" (~HYP_PAGE_OFFSET_HIGH_MASK),
> +		       "i" (~HYP_PAGE_OFFSET_LOW_MASK));
> +	asm volatile(ALTERNATIVE("nop",
> +				 "mov %0, xzr",
>  				 ARM64_HAS_VIRT_HOST_EXTN)
> -		     : "+r" (v) : "i" (~HYP_PAGE_OFFSET_MASK));
> -	return v;
> +		     : "+r" (mask));
> +	return v | mask;

If mask is ~HYP_PAGE_OFFSET_LOW_MASK how can you be sure that setting
bit (VA_BITS - 1) is always the right thing to do to generate a kernel
address?

This is kind of what I asked before only now there's an extra bit not
guaranteed by the architecture to be set for the kernel range, I
think.

>  }
>  
>  #define hyp_kern_va(v) (typeof(v))(__hyp_kern_va((unsigned long)(v)))
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index e45df1b..889330b 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -95,13 +95,33 @@
>  /*
>   * Convert a kernel VA into a HYP VA.
>   * reg: VA to be converted.
> + *
> + * This generates the following sequences:
> + * - High mask:
> + *		and x0, x0, #HYP_PAGE_OFFSET_HIGH_MASK
> + *		nop
> + * - Low mask:
> + *		and x0, x0, #HYP_PAGE_OFFSET_HIGH_MASK
> + *		and x0, x0, #HYP_PAGE_OFFSET_LOW_MASK
> + * - VHE:
> + *		nop
> + *		nop
> + *
> + * The "low mask" version works because the mask is a strict subset of
> + * the "high mask", hence performing the first mask for nothing.
> + * Should be completely invisible on any viable CPU.
>   */
>  .macro kern_hyp_va	reg
> -alternative_if_not ARM64_HAS_VIRT_HOST_EXTN	
> -	and	\reg, \reg, #HYP_PAGE_OFFSET_MASK
> +alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
> +	and     \reg, \reg, #HYP_PAGE_OFFSET_HIGH_MASK
>  alternative_else
>  	nop
>  alternative_endif
> +alternative_if_not ARM64_HYP_OFFSET_LOW
> +	nop
> +alternative_else
> +	and     \reg, \reg, #HYP_PAGE_OFFSET_LOW_MASK
> +alternative_endif
>  .endm
>  
>  #else
> @@ -112,7 +132,23 @@ alternative_endif
>  #include <asm/mmu_context.h>
>  #include <asm/pgtable.h>
>  
> -#define KERN_TO_HYP(kva)	((unsigned long)kva & HYP_PAGE_OFFSET_MASK)
> +static inline unsigned long __kern_hyp_va(unsigned long v)
> +{
> +	asm volatile(ALTERNATIVE("and %0, %0, %1",
> +				 "nop",
> +				 ARM64_HAS_VIRT_HOST_EXTN)
> +		     : "+r" (v)
> +		     : "i" (HYP_PAGE_OFFSET_HIGH_MASK));
> +	asm volatile(ALTERNATIVE("nop",
> +				 "and %0, %0, %1",
> +				 ARM64_HYP_OFFSET_LOW)
> +		     : "+r" (v)
> +		     : "i" (HYP_PAGE_OFFSET_LOW_MASK));

how is the second operation a nop for VHE? Is this because
ARM64_HYP_OFFSET_LOW will never be set for VHE?

> +	return v;
> +}
> +
> +#define kern_hyp_va(v) 	(typeof(v))(__kern_hyp_va((unsigned long)(v)))
> +#define KERN_TO_HYP(v)	kern_hyp_va(v)

looks like there's room for some unification/cleanup here as well.

>  
>  /*
>   * We currently only support a 40bit IPA.
> -- 
> 2.1.4
> 

Thanks,
-Christoffer
