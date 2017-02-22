From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC 08/55] KVM: arm64: Set virtual EL2 context depending on the
 guest exception level
Date: Wed, 22 Feb 2017 12:14:45 +0100
Message-ID: <20170222111445.GD26976@cbox>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-9-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA16340C49
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 06:14:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Kvysmwgw+d2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Feb 2017 06:14:00 -0500 (EST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC46A40BE3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 06:14:00 -0500 (EST)
Received: by mail-wm0-f49.google.com with SMTP id v77so8522503wmv.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Feb 2017 03:14:59 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1483943091-1364-9-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, shihwei@cs.columbia.edu, lorenzo.pieralisi@arm.com, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, andre.przywara@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, anna-maria@linutronix.de, geoff@infradead.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 09, 2017 at 01:24:04AM -0500, Jintack Lim wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Set up virutal EL2 context to hardware if the guest exception level is
> EL2.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
>  arch/arm64/kvm/context.c | 32 ++++++++++++++++++++++++++------
>  1 file changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
> index 320afc6..acb4b1e 100644
> --- a/arch/arm64/kvm/context.c
> +++ b/arch/arm64/kvm/context.c
> @@ -25,10 +25,25 @@
>  void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
> +	if (unlikely(vcpu_mode_el2(vcpu))) {
> +		ctxt->hw_pstate = *vcpu_cpsr(vcpu) & ~PSR_MODE_MASK;
>  
> -	ctxt->hw_pstate = *vcpu_cpsr(vcpu);
> -	ctxt->hw_sys_regs = ctxt->sys_regs;
> -	ctxt->hw_sp_el1 = ctxt->gp_regs.sp_el1;
> +		/*
> +		 * We emulate virtual EL2 mode in hardware EL1 mode using the
> +		 * same stack pointer mode as the guest expects.
> +		 */

I think this comment should either be deleted or explain why this works
as opposed to stating the obvious.  How about:

		/*
		 * We can emulate the guest's configuration of which
		 * stack pointer to use when executing in virtual EL2 by
		 * using the equivalent feature in EL1 to point to
		 * either the EL1 or EL0 stack pointer.
		 */

> +		if ((*vcpu_cpsr(vcpu) & PSR_MODE_MASK) == PSR_MODE_EL2h)
> +			ctxt->hw_pstate |= PSR_MODE_EL1h;
> +		else
> +			ctxt->hw_pstate |= PSR_MODE_EL1t;
> +
> +		ctxt->hw_sys_regs = ctxt->shadow_sys_regs;
> +		ctxt->hw_sp_el1 = ctxt->el2_regs[SP_EL2];
> +	} else {
> +		ctxt->hw_pstate = *vcpu_cpsr(vcpu);
> +		ctxt->hw_sys_regs = ctxt->sys_regs;
> +		ctxt->hw_sp_el1 = ctxt->gp_regs.sp_el1;
> +	}
>  }
>  
>  /**
> @@ -38,9 +53,14 @@ void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
>  void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
> -
> -	*vcpu_cpsr(vcpu) = ctxt->hw_pstate;
> -	ctxt->gp_regs.sp_el1 = ctxt->hw_sp_el1;
> +	if (unlikely(vcpu_mode_el2(vcpu))) {
> +		*vcpu_cpsr(vcpu) &= PSR_MODE_MASK;
> +		*vcpu_cpsr(vcpu) |= ctxt->hw_pstate & ~PSR_MODE_MASK;
> +		ctxt->el2_regs[SP_EL2] = ctxt->hw_sp_el1;
> +	} else {
> +		*vcpu_cpsr(vcpu) = ctxt->hw_pstate;
> +		ctxt->gp_regs.sp_el1 = ctxt->hw_sp_el1;
> +	}
>  }
>  
>  void kvm_arm_init_cpu_context(kvm_cpu_context_t *cpu_ctxt)
> -- 
> 1.9.1
> 
> 
