From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 01/22] arm64: Add macros to read/write system registers
Date: Mon, 7 Dec 2015 17:35:20 +0000
Message-ID: <20151207173520.GJ7083@e104818-lin.cambridge.arm.com>
References: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com>
 <1449485618-9443-2-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449485618-9443-2-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Steve Capper <Steve.Capper@linaro.org>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 07, 2015 at 10:53:17AM +0000, Marc Zyngier wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> Rather than crafting custom macros for reading/writing each system
> register provide generics accessors, read_sysreg and write_sysreg, for
> this purpose.
> 
> Unlike read_cpuid, calls to read_exception_reg are never expected
> to be optimized away or replaced with synthetic values.

What's read_exception_reg? Is it a macro somewhere?

> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index d48ab5b..c9c283a 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -20,6 +20,8 @@
>  #ifndef __ASM_SYSREG_H
>  #define __ASM_SYSREG_H
>  
> +#include <linux/stringify.h>
> +
>  #include <asm/opcodes.h>
>  
>  /*
> @@ -208,6 +210,8 @@
>  
>  #else
>  
> +#include <linux/types.h>
> +
>  asm(
>  "	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n"
>  "	.equ	__reg_num_x\\num, \\num\n"
> @@ -232,6 +236,19 @@ static inline void config_sctlr_el1(u32 clear, u32 set)
>  	val |= set;
>  	asm volatile("msr sctlr_el1, %0" : : "r" (val));
>  }
> +
> +#define read_sysreg(r) ({					\
> +	u64 __val;						\
> +	asm volatile("mrs %0, " __stringify(r) : "=r" (__val));	\
> +	__val;							\
> +})

And maybe a comment here on why this is always volatile.

Otherwise:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

-- 
Catalin
