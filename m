From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v7 3/10] KVM: arm64: Move hyp_symbol_addr to fix
 dependency
Date: Wed, 20 Mar 2019 08:49:02 +0000
Message-ID: <aca8f96c-8f38-8688-f6e2-a50c0a79f4ae@arm.com>
References: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
 <1552984243-7689-4-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1552984243-7689-4-git-send-email-amit.kachhap@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Amit,

On 19/03/2019 08:30, Amit Daniel Kachhap wrote:
> Currently hyp_symbol_addr is palced in kvm_mmu.h which is mostly
> used by __hyp_this_cpu_ptr in kvm_asm.h but it cannot include
> kvm_mmu.h directly as kvm_mmu.h uses kvm_ksym_ref which is
> defined inside kvm_asm.h. Hence, hyp_symbol_addr is moved inside
> kvm_asm.h to fix this dependency on each other.
> 
> Also kvm_ksym_ref is corresponding counterpart of hyp_symbol_addr
> so should be ideally placed inside kvm_asm.h.
> 

This part is a bit confusing, it lead me to think that kvm_ksym_ref was
in kvm_mmu.h and should moved to kvm_asm.h as well. I'd suggest
rephrasing it with something along the lines:

"Also, hyp_symbol_addr corresponding counterpart, kvm_ksym_ref, is
already in kvm_asm.h, making it more sensible to move kvm_symbol_addr to
the same file."

Otherwise:

Reviewed-by: Julien Thierry <julien.thierry@arm.com>

Cheers,

Julien

> Suggested by: James Morse <james.morse@arm.com>
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
>  arch/arm64/include/asm/kvm_asm.h | 20 ++++++++++++++++++++
>  arch/arm64/include/asm/kvm_mmu.h | 20 --------------------
>  2 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index f5b79e9..57a07e8 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -80,6 +80,26 @@ extern void __vgic_v3_init_lrs(void);
>  
>  extern u32 __kvm_get_mdcr_el2(void);
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
> +		asm("adrp	%0, %1\n"				\
> +		    "add	%0, %0, :lo12:%1\n"			\
> +		    : "=r" (addr) : "S" (&s));				\
> +		addr;							\
> +	})
> +
>  /* Home-grown __this_cpu_{ptr,read} variants that always work at HYP */
>  #define __hyp_this_cpu_ptr(sym)						\
>  	({								\
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index b0742a1..3dea6af 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -118,26 +118,6 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
>  #define kern_hyp_va(v) 	((typeof(v))(__kern_hyp_va((unsigned long)(v))))
>  
>  /*
> - * Obtain the PC-relative address of a kernel symbol
> - * s: symbol
> - *
> - * The goal of this macro is to return a symbol's address based on a
> - * PC-relative computation, as opposed to a loading the VA from a
> - * constant pool or something similar. This works well for HYP, as an
> - * absolute VA is guaranteed to be wrong. Only use this if trying to
> - * obtain the address of a symbol (i.e. not something you obtained by
> - * following a pointer).
> - */
> -#define hyp_symbol_addr(s)						\
> -	({								\
> -		typeof(s) *addr;					\
> -		asm("adrp	%0, %1\n"				\
> -		    "add	%0, %0, :lo12:%1\n"			\
> -		    : "=r" (addr) : "S" (&s));				\
> -		addr;							\
> -	})
> -
> -/*
>   * We currently support using a VM-specified IPA size. For backward
>   * compatibility, the default IPA size is fixed to 40bits.
>   */
> 

-- 
Julien Thierry
