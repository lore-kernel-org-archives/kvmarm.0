From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/3] arm: KVM: Implement lazy VFP switching outside of
 Hyp Mode
Date: Sun, 5 Jul 2015 21:34:40 +0200
Message-ID: <20150705193440.GB3869@cbox>
References: <1435203028-23142-1-git-send-email-m.smarduch@samsung.com>
 <1435203028-23142-3-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1435203028-23142-3-git-send-email-m.smarduch@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, pbonzini@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jun 24, 2015 at 08:30:27PM -0700, Mario Smarduch wrote:
> This patch implements the VFP context switch code called from vcpu_put in
> Host KVM. In addition it implements the logic to skip setting a VFP trap if one
> is not needed. Also resets the flag if Host KVM switched registers to trap new
> guest vfp accesses.
> 
> 
> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
> ---
>  arch/arm/kvm/interrupts.S |   49 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 31 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
> index 79caf79..0912edd 100644
> --- a/arch/arm/kvm/interrupts.S
> +++ b/arch/arm/kvm/interrupts.S
> @@ -96,6 +96,21 @@ ENTRY(__kvm_flush_vm_context)
>  	bx	lr
>  ENDPROC(__kvm_flush_vm_context)
>  
> +ENTRY(__kvm_restore_host_vfp_state)
> +	push    {r3-r7}
> +
> +	mov     r1, #0
> +	str     r1, [r0, #VCPU_VFP_SAVED]
> +
> +	add     r7, r0, #VCPU_VFP_GUEST
> +	store_vfp_state r7
> +	add     r7, r0, #VCPU_VFP_HOST
> +	ldr     r7, [r7]
> +	restore_vfp_state r7
> +
> +	pop     {r3-r7}
> +	bx      lr
> +ENDPROC(__kvm_restore_host_vfp_state)

it feels a bit strange to introduce this function here when I cannot see
how it's called.

At the very least, could you provide the C equivalent prototype in a
comment or specify what the input registers are?  E.g.

/*
 * void __kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu);
 */

>  
>  /********************************************************************
>   *  Hypervisor world-switch code
> @@ -131,7 +146,13 @@ ENTRY(__kvm_vcpu_run)
>  
>  	@ Trap coprocessor CRx accesses
>  	set_hstr vmentry
> +
> +	ldr	r1, [vcpu, #VCPU_VFP_SAVED]
> +	cmp	r1, #1
> +	beq     skip_guest_vfp_trap
>  	set_hcptr vmentry, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
> +skip_guest_vfp_trap:
> +
>  	set_hdcr vmentry
>  
>  	@ Write configured ID register into MIDR alias
> @@ -173,18 +194,6 @@ __kvm_vcpu_return:
>  	set_hcptr vmexit, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
>  
>  #ifdef CONFIG_VFPv3
> -	@ Save floating point registers we if let guest use them.
> -	tst	r2, #(HCPTR_TCP(10) | HCPTR_TCP(11))
> -	bne	after_vfp_restore
> -
> -	@ Switch VFP/NEON hardware state to the host's
> -	add	r7, vcpu, #VCPU_VFP_GUEST
> -	store_vfp_state r7
> -	add	r7, vcpu, #VCPU_VFP_HOST
> -	ldr	r7, [r7]
> -	restore_vfp_state r7
> -
> -after_vfp_restore:
>  	@ Restore FPEXC_EN which we clobbered on entry
>  	pop	{r2}
>  	VFPFMXR FPEXC, r2
> @@ -363,10 +372,6 @@ hyp_hvc:
>  	@ Check syndrome register
>  	mrc	p15, 4, r1, c5, c2, 0	@ HSR
>  	lsr	r0, r1, #HSR_EC_SHIFT
> -#ifdef CONFIG_VFPv3
> -	cmp	r0, #HSR_EC_CP_0_13
> -	beq	switch_to_guest_vfp
> -#endif
>  	cmp	r0, #HSR_EC_HVC
>  	bne	guest_trap		@ Not HVC instr.
>  
> @@ -380,7 +385,10 @@ hyp_hvc:
>  	cmp     r2, #0
>  	bne	guest_trap		@ Guest called HVC
>  
> -host_switch_to_hyp:
> +	/*
> +	 * Getting here means host called HVC, we shift parameters and branch
> +	 * to Hyp function.
> +	 */

not sure this comment change belongs in this patch (but the comment is
well-written).

>  	pop	{r0, r1, r2}
>  
>  	/* Check for __hyp_get_vectors */
> @@ -411,6 +419,10 @@ guest_trap:
>  
>  	@ Check if we need the fault information
>  	lsr	r1, r1, #HSR_EC_SHIFT
> +#ifdef CONFIG_VFPv3
> +	cmp	r1, #HSR_EC_CP_0_13
> +	beq	switch_to_guest_vfp
> +#endif
>  	cmp	r1, #HSR_EC_IABT
>  	mrceq	p15, 4, r2, c6, c0, 2	@ HIFAR
>  	beq	2f
> @@ -479,11 +491,12 @@ guest_trap:
>   */
>  #ifdef CONFIG_VFPv3
>  switch_to_guest_vfp:
> -	load_vcpu			@ Load VCPU pointer to r0
>  	push	{r3-r7}
>  
>  	@ NEON/VFP used.  Turn on VFP access.
>  	set_hcptr vmexit, (HCPTR_TCP(10) | HCPTR_TCP(11))
> +	mov	r1, #1
> +	str	r1, [vcpu, #VCPU_VFP_SAVED]
>  
>  	@ Switch VFP/NEON hardware state to the guest's
>  	add	r7, r0, #VCPU_VFP_HOST
> -- 
> 1.7.9.5
> 
It would probably be easier to just rebase this on the previous series
and refer to that in the cover letter, but the approach here looks
otherwise right to me.

-Christoffer
