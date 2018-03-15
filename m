From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 06/26] KVM: arm/arm64: Do not use kern_hyp_va() with
 kvm_vgic_global_state
Date: Thu, 15 Mar 2018 19:16:14 +0000
Message-ID: <5AAAC67E.4010002@arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180314165049.30105-7-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180314165049.30105-7-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 14/03/18 16:50, Marc Zyngier wrote:
> kvm_vgic_global_state is part of the read-only section, and is
> usually accessed using a PC-relative address generation (adrp + add).
> 
> It is thus useless to use kern_hyp_va() on it, and actively problematic
> if kern_hyp_va() becomes non-idempotent. On the other hand, there is
> no way that the compiler is going to guarantee that such access is
> always PC relative.
> 
> So let's bite the bullet and provide our own accessor.


> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index de1b919404e4..a6808d2869f5 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -28,6 +28,13 @@
>   */
>  #define kern_hyp_va(kva)	(kva)
>  
> +/* Resolving symbol addresses in a PC-relative way is easy... */

(So this is guaranteed on 32bit? I thought this was because 32bit uses the
kernel-VA's at HYP, so any way the compiler generates the address will work.)


> +#define hyp_symbol_addr(s)						\
> +	({								\
> +		typeof(s) *addr = &(s);					\
> +		addr;							\
> +	})
> +
>  /*
>   * KVM_MMU_CACHE_MIN_PAGES is the number of stage2 page table translation levels.
>   */

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index e3bc1d0a5e93..7120bf3f22c7 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -110,6 +110,26 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
>  
>  #define kern_hyp_va(v) 	((typeof(v))(__kern_hyp_va((unsigned long)(v))))
>  
> +/*
> + * Obtain the PC-relative address of a kernel symbol
> + * s: symbol
> + *
> + * The goal of this macro is to return a symbol's address based on a
> + * PC-relative computation, as opposed to a loading the VA from a
> + * constant pool or something similar. This works well for HYP, as an
> + * absolute VA is guaranteed to be wrong. Only use this if trying to
> + * obtain the address of a symbol (i.e. not something you obtained by
> + * following a pointer).
> + */
> +#define hyp_symbol_addr(s)						\
> +	({								\
> +		typeof(s) *addr;					\
> +		asm volatile("adrp	%0, %1\n"			\
> +			     "add	%0, %0, :lo12:%1\n"		\
> +			     : "=r" (addr) : "S" (&s));			\
> +		addr;							\
> +	})

Why does this need to be volatile? I see gcc v4.9 generate this sequence twice
in __vgic_v2_save_state(). Can't it cache and reorder this sequence as it likes?

Either-way:
Reviewed-by: James Morse <james.morse@arm.com>


(I had a go at using 'Ush', to let the compiler schedule the adrp, but couldn't
get it to work.)

Thanks,

James
