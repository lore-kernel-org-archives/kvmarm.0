From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 1/2] arm64: KVM: Optimize arm64 skip 30-50% vfp/simd
 save/restore on exits
Date: Thu, 6 Aug 2015 13:54:36 +0200
Message-ID: <20150806115436.GC4657@cbox>
References: <1437082178-11039-1-git-send-email-m.smarduch@samsung.com>
 <1437082178-11039-2-git-send-email-m.smarduch@samsung.com>
 <55C235B9.3000800@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55C235B9.3000800@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mario Smarduch <m.smarduch@samsung.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 05, 2015 at 05:11:37PM +0100, Marc Zyngier wrote:
> On 16/07/15 22:29, Mario Smarduch wrote:
> > This patch only saves and restores FP/SIMD registers on Guest access. To do
> > this cptr_el2 FP/SIMD trap is set on Guest entry and later checked on exit.
> > lmbench, hackbench show significant improvements, for 30-50% exits FP/SIMD
> > context is not saved/restored
> > 
> > Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
> 
> So this patch seems to break 32bit guests on arm64.  I've had a look,
> squashed a few bugs that I dangerously overlooked during the review, but
> it still doesn't work (it doesn't crash anymore, but I get random
> illegal VFP instructions in 32bit guests).
> 
> I'd be glad if someone could eyeball the following patch and tell me
> what's going wrong. If we don't find the root cause quickly enough, I'll
> have to drop the series from -next, and that'd be a real shame.
> 
> Thanks,
> 
> 	M.
> 
> commit 5777dc55fbc170426a85e00c26002dd5a795cfa5
> Author: Marc Zyngier <marc.zyngier@arm.com>
> Date:   Wed Aug 5 16:53:01 2015 +0100
> 
>     KVM: arm64: NOTAFIX: Prevent crash when 32bit guest uses VFP
> 
>     Since we switch FPSIMD in a lazy way, access to FPEXC32_EL2
>     must be guarded by skip_fpsimd_state. Otherwise, all hell
>     break loose.
> 
>     Also, FPEXC32_EL2 must be restored when we trap to EL2 to
>     enable floating point.
> 
>     Note that while it prevents the host from catching fire, the
>     guest still doesn't work properly, and I don't understand why just
>     yet.
> 
>     Not-really-signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index c8e0c70..b53ec5d 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -431,10 +431,12 @@
>  	add	x3, x2, #CPU_SYSREG_OFFSET(DACR32_EL2)
>  	mrs	x4, dacr32_el2
>  	mrs	x5, ifsr32_el2
> -	mrs	x6, fpexc32_el2
>  	stp	x4, x5, [x3]
> -	str	x6, [x3, #16]
> 
> +	skip_fpsimd_state x8, 3f
> +	mrs	x6, fpexc32_el2
> +	str	x6, [x3, #16]
> +3:
>  	skip_debug_state x8, 2f
>  	mrs	x7, dbgvcr32_el2
>  	str	x7, [x3, #24]
> @@ -461,10 +463,8 @@
> 
>  	add	x3, x2, #CPU_SYSREG_OFFSET(DACR32_EL2)
>  	ldp	x4, x5, [x3]
> -	ldr	x6, [x3, #16]
>  	msr	dacr32_el2, x4
>  	msr	ifsr32_el2, x5
> -	msr	fpexc32_el2, x6
> 
>  	skip_debug_state x8, 2f
>  	ldr	x7, [x3, #24]
> @@ -669,12 +669,14 @@ __restore_debug:
>  	ret
> 
>  __save_fpsimd:
> +	skip_fpsimd_state x3, 1f
>  	save_fpsimd
> -	ret
> +1:	ret
> 
>  __restore_fpsimd:
> +	skip_fpsimd_state x3, 1f
>  	restore_fpsimd
> -	ret
> +1:	ret
> 
>  switch_to_guest_fpsimd:
>  	push	x4, lr
> @@ -682,6 +684,7 @@ switch_to_guest_fpsimd:
>  	mrs	x2, cptr_el2
>  	bic	x2, x2, #CPTR_EL2_TFP
>  	msr	cptr_el2, x2
> +	isb

ah, EL2 accesses themselves trap too, ouch.

> 
>  	mrs	x0, tpidr_el2
> 
> @@ -692,6 +695,10 @@ switch_to_guest_fpsimd:
>  	add	x2, x0, #VCPU_CONTEXT
>  	bl __restore_fpsimd
> 
> +	skip_32bit_state x3, 1f
> +	ldr	x4, [x2, #CPU_SYSREG_OFFSET(FPEXC32_EL2)]
> +	msr	fpexc32_el2, x4
> +1:

wait, it looks like you're missing a store of the host fpsimd state in
the switch_to_guest_fpsimd situation.

It think this would be easier to follow if the aarch32 FP registers were
handled as part of the __save_fpsimd  and __restore_fpsimd routines
instead.


Does this help anything?

Otherwise, I assume you've tested thoroughly between something like
v4.2-rc2 and this patch, so that you're sure we didn't have the 32-bit
processed crash before?

Thanks,
-Christoffer

>  	pop	x4, lr
>  	pop	x2, x3
>  	pop	x0, x1
> @@ -754,9 +761,7 @@ __kvm_vcpu_return:
>  	add	x2, x0, #VCPU_CONTEXT
> 
>  	save_guest_regs
> -	skip_fpsimd_state x3, 1f
>  	bl __save_fpsimd
> -1:
>  	bl __save_sysregs
> 
>  	skip_debug_state x3, 1f
> @@ -777,9 +782,7 @@ __kvm_vcpu_return:
>  	kern_hyp_va x2
> 
>  	bl __restore_sysregs
> -	skip_fpsimd_state x3, 1f
>  	bl __restore_fpsimd
> -1:
>  	/* Clear FPSIMD and Trace trapping */
>  	msr     cptr_el2, xzr
> 
> 
> -- 
> Jazz is not dead. It just smells funny...
