From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 07/28] arm64: KVM: Allow the main HYP code to use the
 init hyp stub implementation
Date: Fri, 24 Mar 2017 15:33:58 +0100
Message-ID: <20170324143358.GC25903@cbox>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
 <20170321192058.9300-8-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170321192058.9300-8-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Russell King <linux@arm.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 21, 2017 at 07:20:37PM +0000, Marc Zyngier wrote:
> We now have a full hyp-stub implementation in the KVM init code,
> but the main KVM code only supports HVC_GET_VECTORS, which is not
> enough.
> 
> Instead of reinventing the wheel, let's reuse the init implementation
> by branching to the idmap page when called with a hyp-stub hypercall.
> 
> Reviewed-by: James Morse <james.morse@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/hyp-entry.S | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index d8ef788646c6..4f34c5996f86 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -87,10 +87,24 @@ alternative_endif
>  	/* Here, we're pretty sure the host called HVC. */
>  	ldp	x0, x1, [sp], #16
>  
> -	cmp	x0, #HVC_GET_VECTORS
> -	b.ne	1f
> -	mrs	x0, vbar_el2
> -	b	2f
> +	/* Check for a stub HVC call */
> +	cmp	x0, #HVC_STUB_HCALL_NR
> +	b.hs	1f
> +
> +	/*
> +	 * Compute the idmap address of __kvm_handle_stub_hvc and
> +	 * jump there. Since we use kimage_voffset, do not use the
> +	 * HYP VA for __kvm_handle_stub_hvc, but the kernel VA instead
> +	 * (by loading it from the constant pool).
> +	 *
> +	 * Preserve x0-x4, which may contain stub parameters.
> +	 */
> +	ldr	x5, =__kvm_handle_stub_hvc
> +	ldr_l	x6, kimage_voffset

Isn't it a bit dodgy to just overwrite x5 and x6 in something which is
not a function?  I know that in practice this always gets called through
a function call and we can rely on the calling convention, but this can
break if you issue a hypercall to KVM's HVC sub implementation using
inline assembly, I think.

Am I missing something here?

> +
> +	/* x5 = __pa(x5) */
> +	sub	x5, x5, x6
> +	br	x5
>  
>  1:
>  	/*
> @@ -99,7 +113,7 @@ alternative_endif
>  	kern_hyp_va	x0
>  	do_el2_call
>  
> -2:	eret
> +	eret
>  
>  el1_trap:
>  	/*
> -- 
> 2.11.0
> 

Thanks,
-Christoffer
