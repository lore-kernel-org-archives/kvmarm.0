From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm64: stop propagating DAIF flags between kernel
 and VHE's world switch
Date: Thu, 24 Aug 2017 08:23:04 -0700
Message-ID: <20170824152304.GB2150@lvm>
References: <20170810113021.1110-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B14BE40FAF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Aug 2017 11:21:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FKgabMgmuiPK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Aug 2017 11:21:07 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3273740D8B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Aug 2017 11:21:07 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id a70so7657806wmd.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Aug 2017 08:23:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170810113021.1110-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On Thu, Aug 10, 2017 at 12:30:21PM +0100, James Morse wrote:
> KVM calls __kvm_vcpu_run() in a loop with interrupts masked for the
> duration of the call. On a non-vhe system we HVC to EL2 and the
> host DAIF flags are save/restored via the SPSR.
> 
> On a system with vhe, we branch to the EL2 code because the kernel
> also runs at EL2. This means the other kernel DAIF flags propagate into
> KVMs EL2 code.
> 
> The same happens in reverse, we take an exception to exit the guest
> and all the flags are masked. __guest_exit() unmasks SError, and we
> return with these flags through world switch and back into the host
> kernel. KVM unmasks interrupts as part of its __kvm_vcpu_run(), but

when does KVM unmask interrupts as part of the __kvm_vcpu_run()?  Do you
mean kvm_arch_vcpu_ioctl_run() ?

> debug exceptions remain disabled due to the guest exit exception,
> (as does SError: today this is the only time SError is unmasked in the
> kernel). The flags stay in this state until we return to userspace.
> 
> We have a __vhe_hyp_call() function that does the isb that we implicitly
> have on non-vhe systems, add the DAIF save/restore here, instead of in
> __sysreg_{save,restore}_host_state() which would require an extra isb()
> between the hosts VBAR_EL1 being restored and DAIF being restored.

This also means that anyone else calling kvm_call_hyp(), which we are
beginning to do more often, would also do this save/restore which
shouldn't really be necessary, doesn't it?

Also, I can't really see why we need to save/restore this.  We are
'entering the kernel' similarly to entering the kernel from user space.
Does the kernel/userspace boundry preserve kernel state or can we simply
set what the wanted state of the flags should be upon having entered the
kernel from EL2?

Thanks,
-Christoffer

> 
> Signed-off-by: James Morse <james.morse@arm.com>
> 
> ---
> I don't like the host DAIF context being stored on the stack instead of
> kvm_host_cpu_state, but this should only be a problem for returns that
> don't go through __vhe_hyp_call(). That should just be hyp_panic() where we
> want to change DAIF anyway.
> 
> If you want a fixes tag for this, I think its:
> Fixes: b81125c791a2 ("arm64: KVM: VHE: Patch out use of HVC")
> 
> 
> While this won't conflict with v3 of the RAS+IESB series, it will depend on
> this patches behaviour: Without this patch you will have SError unmasked
> on host->guest world switch, a v8.2 RAS error arriving during this window
> will HYP panic, but this is already the case today for guest->host.
> 
> 
>  arch/arm64/kvm/hyp/hyp-entry.S | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index 5170ce1021da..5eaa336e5dd9 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -42,6 +42,11 @@
>  .endm
>  
>  ENTRY(__vhe_hyp_call)
> +	/* HVC->ERET implicitly save/restore DAIF, we do it manually here. */
> +	mrs	x9, daif
> +	str	x9, [sp, #-16]!
> +	msr	daifset, #0xf
> +
>  	do_el2_call
>  	/*
>  	 * We used to rely on having an exception return to get
> @@ -50,6 +55,14 @@ ENTRY(__vhe_hyp_call)
>  	 * before returning to the rest of the kernel.
>  	 */
>  	isb
> +
> +	/*
> +	 * World-switch changes VBAR_EL1, we can only restore DAIF after
> +	 * the hosts value has been synchronised by the above isb.
> +	 */
> +	ldr	x9, [sp], #16
> +	msr	daif, x9
> +
>  	ret
>  ENDPROC(__vhe_hyp_call)
>  
> -- 
> 2.13.3
> 
