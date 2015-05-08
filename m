From: Dave P Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 1/2] ARM: kvm: fix a bad BSYM() usage
Date: Fri, 8 May 2015 17:31:08 +0100
Message-ID: <20150508163107.GB17900@e103592.cambridge.arm.com>
References: <E1YqkpO-0006zB-QJ@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <E1YqkpO-0006zB-QJ@rmk-PC.arm.linux.org.uk>
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 08, 2015 at 05:08:42PM +0100, Russell King wrote:
> BSYM() should only be used when refering to local symbols in the same
> assembly file which are resolved by the assembler, and not for
> linker-fixed up symbols.  The use of BSYM() with panic is incorrect as
> the linker is involved in fixing up this relocation, and it knows
> whether panic() is ARM or Thumb.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Acked-by: Dave Martin <Dave.Martin@arm.com>

> ---
>  arch/arm/kvm/interrupts.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
> index 79caf79b304a..87847d2c5f99 100644
> --- a/arch/arm/kvm/interrupts.S
> +++ b/arch/arm/kvm/interrupts.S
> @@ -309,7 +309,7 @@ ENTRY(kvm_call_hyp)
>  THUMB(	orr	r2, r2, #PSR_T_BIT	)
>  	msr	spsr_cxsf, r2
>  	mrs	r1, ELR_hyp
> -	ldr	r2, =BSYM(panic)
> +	ldr	r2, =panic
>  	msr	ELR_hyp, r2
>  	ldr	r0, =\panic_str
>  	clrex				@ Clear exclusive monitor
> -- 
> 1.8.3.1
> 

