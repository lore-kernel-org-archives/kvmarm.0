From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v1 1/3] arm64: add a macro for SError synchronization
Date: Wed, 1 Nov 2017 11:24:59 +0000
Message-ID: <6dc82768-8564-a54e-041b-3b9965fa038b@arm.com>
References: <1509563697-6359-1-git-send-email-gengdongjiu@huawei.com>
 <1509563697-6359-2-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509563697-6359-2-git-send-email-gengdongjiu@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>, catalin.marinas@arm.com, will.deacon@arm.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, james.morse@arm.com, mark.rutland@arm.com, ard.biesheuvel@linaro.org, cov@codeaurora.org, Dave.Martin@arm.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 01/11/17 19:14, Dongjiu Geng wrote:
> ARMv8.2 adds a control bit to each SCTLR_ELx to insert implicit
> Error Synchronization Barrier(IESB) operations at exception handler entry
> and exit. But not all hardware platform which support RAS Extension
> can support IESB. So for this case, software needs to manually insert
> Error Synchronization Barrier(ESB) operations.
> 
> In this macros, if system supports RAS Extensdddon instead of IESB,
> it will insert an ESB instruction.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> ---
>  arch/arm64/include/asm/assembler.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index d4c0adf..e6c79c4 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -517,4 +517,13 @@
>  #endif
>  	.endm
>  
> +	.macro	error_synchronize
> +alternative_if ARM64_HAS_IESB
> +	b	1f
> +alternative_else_nop_endif
> +alternative_if ARM64_HAS_RAS_EXTN
> +	esb
> +alternative_else_nop_endif
> +1:
> +	.endm

Having a branch in here is pretty horrible, and furthermore using label
number 1 has a pretty high chance of subtly breaking code where this
macro is inserted.

Can we not somehow nest or combine the alternative conditions here?

Robin.

>  #endif	/* __ASM_ASSEMBLER_H */
> 
