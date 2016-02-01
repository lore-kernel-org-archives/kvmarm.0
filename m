From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 07/21] arm64: KVM: VHE: Patch out kern_hyp_va
Date: Mon, 1 Feb 2016 16:40:52 +0100
Message-ID: <20160201154052.GE1478@cbox>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-8-git-send-email-marc.zyngier@arm.com>
 <20160201132042.GJ1478@cbox> <56AF5FF1.4010701@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 565AC40FA6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 10:35:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id utvVuRtoaWTP for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2016 10:35:09 -0500 (EST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3230740BDA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 10:35:08 -0500 (EST)
Received: by mail-wm0-f46.google.com with SMTP id l66so77250680wml.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Feb 2016 07:40:27 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <56AF5FF1.4010701@arm.com>
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

On Mon, Feb 01, 2016 at 01:38:57PM +0000, Marc Zyngier wrote:
> On 01/02/16 13:20, Christoffer Dall wrote:
> > On Mon, Jan 25, 2016 at 03:53:41PM +0000, Marc Zyngier wrote:
> >> The kern_hyp_va macro is pretty meaninless with VHE, as there is
> >> only one mapping - the kernel one.
> >>
> >> In order to keep the code readable and efficient, use runtime
> >> patching to replace the 'and' instruction used to compute the VA
> >> with a 'nop'.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm64/include/asm/kvm_mmu.h | 11 ++++++++++-
> >>  arch/arm64/kvm/hyp/hyp.h         | 25 ++++++++++++++++++++++---
> >>  2 files changed, 32 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> >> index d3e6d7b..62f0d14 100644
> >> --- a/arch/arm64/include/asm/kvm_mmu.h
> >> +++ b/arch/arm64/include/asm/kvm_mmu.h
> >> @@ -23,13 +23,16 @@
> >>  #include <asm/cpufeature.h>
> >>  
> >>  /*
> >> - * As we only have the TTBR0_EL2 register, we cannot express
> >> + * As ARMv8.0 only has the TTBR0_EL2 register, we cannot express
> >>   * "negative" addresses. This makes it impossible to directly share
> >>   * mappings with the kernel.
> >>   *
> >>   * Instead, give the HYP mode its own VA region at a fixed offset from
> >>   * the kernel by just masking the top bits (which are all ones for a
> >>   * kernel address).
> >> + *
> >> + * ARMv8.1 (using VHE) does have a TTBR1_EL2, and doesn't use these
> >> + * macros (the entire kernel runs at EL2).
> >>   */
> >>  #define HYP_PAGE_OFFSET_SHIFT	VA_BITS
> >>  #define HYP_PAGE_OFFSET_MASK	((UL(1) << HYP_PAGE_OFFSET_SHIFT) - 1)
> >> @@ -56,6 +59,8 @@
> >>  
> >>  #ifdef __ASSEMBLY__
> >>  
> >> +#include <asm/alternative.h>
> >> +#include <asm/cpufeature.h>
> >>  #include <asm/kvm_arm.h>
> >>  
> >>  .macro setup_vtcr tmp1, tmp2
> >> @@ -84,7 +89,11 @@
> >>   * reg: VA to be converted.
> >>   */
> >>  .macro kern_hyp_va	reg
> >> +alternative_if_not ARM64_HAS_VIRT_HOST_EXTN	
> >>  	and	\reg, \reg, #HYP_PAGE_OFFSET_MASK
> >> +alternative_else
> >> +	nop
> >> +alternative_endif
> >>  .endm
> >>  
> >>  #else
> >> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
> >> index fb27517..fc502f3 100644
> >> --- a/arch/arm64/kvm/hyp/hyp.h
> >> +++ b/arch/arm64/kvm/hyp/hyp.h
> >> @@ -25,9 +25,28 @@
> >>  
> >>  #define __hyp_text __section(.hyp.text) notrace
> >>  
> >> -#define kern_hyp_va(v) (typeof(v))((unsigned long)(v) & HYP_PAGE_OFFSET_MASK)
> >> -#define hyp_kern_va(v) (typeof(v))((unsigned long)(v) - HYP_PAGE_OFFSET \
> >> -						      + PAGE_OFFSET)
> >> +static inline unsigned long __kern_hyp_va(unsigned long v)
> >> +{
> >> +	asm volatile(ALTERNATIVE("and %0, %0, %1",
> >> +				 "nop",
> >> +				 ARM64_HAS_VIRT_HOST_EXTN)
> >> +		     : "+r" (v) : "i" (HYP_PAGE_OFFSET_MASK));
> >> +	return v;
> >> +}
> >> +
> >> +#define kern_hyp_va(v) (typeof(v))(__kern_hyp_va((unsigned long)(v)))
> >> +
> >> +static inline unsigned long __hyp_kern_va(unsigned long v)
> >> +{
> >> +	u64 offset = PAGE_OFFSET - HYP_PAGE_OFFSET;
> >> +	asm volatile(ALTERNATIVE("add %0, %0, %1",
> >> +				 "nop",
> >> +				 ARM64_HAS_VIRT_HOST_EXTN)
> >> +		     : "+r" (v) : "r" (offset));
> >> +	return v;
> >> +}
> >> +
> >> +#define hyp_kern_va(v) (typeof(v))(__hyp_kern_va((unsigned long)(v)))
> > 
> > why do we need this casting of values instead of just defining these
> > inlines and calling them directly with proper typing?
> 
> We commonly pass both pointers and unsigned long to this helper. Do you
> really want a separate helper for each type instead of one that does it all?
> 

no, what I was suggesting was to always take a specific type and change
the callers that don't match to use a specific cast so you give the
compiler a chance to scream at you when writing new code.

But I don't feel strongly about it.

Thanks,
-Christoffer
