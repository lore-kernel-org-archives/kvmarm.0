From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v8 3/9] KVM: arm64: Move hyp_symbol_addr to fix dependency
Date: Fri, 5 Apr 2019 12:02:19 +0100
Message-ID: <20190405110219.GQ3567@e103592.cambridge.arm.com>
References: <1554172037-4516-1-git-send-email-amit.kachhap@arm.com>
 <1554172037-4516-4-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1554172037-4516-4-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 02, 2019 at 07:57:11AM +0530, Amit Daniel Kachhap wrote:
> Currently hyp_symbol_addr is placed in kvm_mmu.h which is mostly
> used by __hyp_this_cpu_ptr in kvm_asm.h but it cannot include
> kvm_mmu.h directly as kvm_mmu.h uses kvm_ksym_ref which is
> defined inside kvm_asm.h. Hence, hyp_symbol_addr is moved inside
> kvm_asm.h to fix this dependency on each other.
> 
> Also, hyp_symbol_addr corresponding counterpart, kvm_ksym_ref,
> is already in kvm_asm.h, making it more sensible to move
> kvm_symbol_addr to the same file.
> 
> Suggested by: James Morse <james.morse@arm.com>
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
> 
> Changes since v7:
> * Slight change in commit message [Julien Thierry].
> 
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

Do we need to include <asm/kvm_asm.h> in vgic-v2-cpuif-proxy.c now?

Otherwise,

Reviewed-by: Dave Martin <Dave.Martin@arm.com>
