From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCHv2] ARM64: KVM: use lm_alias() for kvm_ksym_ref()
Date: Fri, 25 May 2018 11:50:10 +0100
Message-ID: <20180525105010.qswcppfkybznmzka@lakrids.cambridge.arm.com>
References: <20180510111347.32253-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 039014070F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 06:39:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wlOqs47h9omz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 May 2018 06:39:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CCA340683
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 06:39:32 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180510111347.32253-1-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 10, 2018 at 12:13:47PM +0100, Mark Rutland wrote:
> For historical reasons, we open-code lm_alias() in kvm_ksym_ref().
> 
> Let's use lm_alias() to avoid duplication and make things clearer.
> 
> As we have to pull this from <linux/mm.h> (which is not safe for
> inclusion in assembly), we may as well move the kvm_ksym_ref()
> definition into the existing !__ASSEMBLY__ block.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
>  arch/arm64/include/asm/kvm_asm.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Marc, Christoffer, are you happy to pick this up?

Mark.

> Since v1 [1]:
> * Rebase to v4.17-rc4
> * Fix typo in commit message
> 
> Mark.
> 
> [1] https://lkml.kernel.org/r/20180406151909.57197-1-mark.rutland@arm.com
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index f6648a3e4152..a9ceeec5a76f 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -33,16 +33,19 @@
>  #define KVM_ARM64_DEBUG_DIRTY_SHIFT	0
>  #define KVM_ARM64_DEBUG_DIRTY		(1 << KVM_ARM64_DEBUG_DIRTY_SHIFT)
>  
> +#ifndef __ASSEMBLY__
> +
> +#include <linux/mm.h>
> +
>  /* Translate a kernel address of @sym into its equivalent linear mapping */
>  #define kvm_ksym_ref(sym)						\
>  	({								\
>  		void *val = &sym;					\
>  		if (!is_kernel_in_hyp_mode())				\
> -			val = phys_to_virt((u64)&sym - kimage_voffset);	\
> +			val = lm_alias(&sym);				\
>  		val;							\
>  	 })
>  
> -#ifndef __ASSEMBLY__
>  struct kvm;
>  struct kvm_vcpu;
>  
> -- 
> 2.11.0
> 
