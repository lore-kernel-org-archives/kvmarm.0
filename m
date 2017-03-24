From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 19/28] ARM: KVM: Allow the main HYP code to use the
 init hyp stub implementation
Date: Fri, 24 Mar 2017 15:34:32 +0100
Message-ID: <20170324143432.GD25903@cbox>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
 <20170321192058.9300-20-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170321192058.9300-20-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Russell King <linux@arm.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 21, 2017 at 07:20:49PM +0000, Marc Zyngier wrote:
> We now have a full hyp-stub implementation in the KVM init code,
> but the main KVM code only supports HVC_GET_VECTORS, which is not
> enough.
> 
> Instead of reinventing the wheel, let's reuse the init implementation
> by branching to the idmap page when called with a hyp-stub hypercall.
> 
> Tested-by: Keerthy <j-keerthy@ti.com>
> Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/hyp/hyp-entry.S | 29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
> index 1f8db7d21fc5..a35baa81fd23 100644
> --- a/arch/arm/kvm/hyp/hyp-entry.S
> +++ b/arch/arm/kvm/hyp/hyp-entry.S
> @@ -126,11 +126,30 @@ hyp_hvc:
>  	 */
>  	pop	{r0, r1, r2}
>  
> -	/* Check for __hyp_get_vectors */
> -	cmp	r0, #HVC_GET_VECTORS
> -	mrceq	p15, 4, r0, c12, c0, 0	@ get HVBAR
> -	beq	1f
> +	/*
> +	 * Check if we have a kernel function, which is guaranteed to be
> +	 * bigger than the maximum hyp stub hypercall
> +	 */
> +	cmp	r0, #HVC_STUB_HCALL_NR
> +	bhs	1f
>  
> +	/*
> +	 * Not a kernel function, treat it as a stub hypercall.
> +	 * Compute the physical address for __kvm_handle_stub_hvc
> +	 * (as the code lives in the idmaped page) and branch there.
> +	 * We hijack ip (r12) as a tmp register.
> +	 */

How can we just clobber r12 and be sure we don't corrupt the caller?

> +	push	{r1}
> +	ldr	r1, =kimage_voffset
> +	ldr	r1, [r1]
> +	ldr	ip, =__kvm_handle_stub_hvc
> +	sub	ip, ip, r1
> +THUMB(	add	ip, ip, #1)
> +	pop	{r1}
> +
> +	bx	ip
> +
> +1:
>  	push	{lr}
>  
>  	mov	lr, r0
> @@ -142,7 +161,7 @@ THUMB(	orr	lr, #1)
>  	blx	lr			@ Call the HYP function
>  
>  	pop	{lr}
> -1:	eret
> +	eret
>  
>  guest_trap:
>  	load_vcpu r0			@ Load VCPU pointer to r0
> -- 
> 2.11.0
> 

Thanks,
-Christoffer
