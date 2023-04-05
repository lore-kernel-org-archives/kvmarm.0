Received: from out-57.mta0.migadu.com (out-57.mta0.migadu.com [91.218.175.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AE563AE
	for <kvmarm@lists.linux.dev>; Wed,  5 Apr 2023 15:30:49 +0000 (UTC)
Date: Wed, 5 Apr 2023 15:30:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680708646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9E5OY1K4w45DWf573FPZ+2UbjmJk7huX/eo3Pr5CduI=;
	b=HR7E0IwqAIlq+8vjV2SEXl2q5CluHxEy6WnHMznnXgGCA3nwCgw019fxvP0+BKVXLLfjSR
	6G67Ag5YWsVkVTYdh/3j4ci0TDtDjjXqZRhc3+1p/+UH9Enu0iAGIlnO7Xrf8J6ImWV7jb
	qE1xQDKG7VW21FcQTq7l1QOq888XQmg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [PATCH v3 08/13] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Message-ID: <ZC2UIWa4huuiE0ZD@linux.dev>
References: <20230404154050.2270077-1-oliver.upton@linux.dev>
 <20230404154050.2270077-9-oliver.upton@linux.dev>
 <87o7o26aty.wl-maz@kernel.org>
 <86pm8iv8tj.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86pm8iv8tj.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Marc,

On Wed, Apr 05, 2023 at 12:59:20PM +0100, Marc Zyngier wrote:

[...]

> > > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > > index 68f95dcd41a1..3f43e20c48b6 100644
> > > --- a/arch/arm64/kvm/handle_exit.c
> > > +++ b/arch/arm64/kvm/handle_exit.c
> > > @@ -71,7 +71,9 @@ static int handle_smc(struct kvm_vcpu *vcpu)
> > >  	 * Trap exception, not a Secure Monitor Call exception [...]"
> > >  	 *
> > >  	 * We need to advance the PC after the trap, as it would
> > > -	 * otherwise return to the same address...
> > > +	 * otherwise return to the same address. Furthermore, pre-incrementing
> > > +	 * the PC before potentially exiting to userspace maintains the same
> > > +	 * abstraction for both SMCs and HVCs.
> > 
> > nit: this comment really needs to find its way in the documentation so
> > that a VMM author can determine the PC of the SMC/HVC. This is
> > specially important for 32bit, which has a 16bit encodings for
> > SMC/HVC.
> > 
> > And thinking of it, this outlines a small flaw in this API. If
> > luserspace needs to find out about the address of the HVC/SMC, it
> > needs to know the *size* of the instruction. But we don't propagate
> > the ESR value. I think this still works by construction (userspace can
> > check PSTATE and work out whether we're in ARM or Thumb mode), but
> > this feels fragile.
> > 
> > Should we expose the ESR, or at least ESR_EL2.IL as an additional
> > flag?
> 
> Just to make this a quicker round trip, I hacked the following
> together. If you agree with it, I'll stick it on top and get the ball
> rolling.

Less work for me? How could I say no :)

> From 9b830e7a3819c2771074bebe66c1d5f20394e3cc Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Wed, 5 Apr 2023 12:48:58 +0100
> Subject: [PATCH] KVM: arm64: Expose SMC/HVC width to userspace
> 
> When returning to userspace to handle a SMCCC call, we consistently
> set PC to point to the instruction immediately after the HVC/SMC.
> 
> However, should userspace need to know the exact address of the
> trapping instruction, it needs to know about the *size* of that
> instruction. For AArch64, this is pretty easy. For AArch32, this
> is a bit more funky, as Thumb has 16bit encodings for both HVC
> and SMC.
> 
> Expose this to userspace with a new flag that directly derives
> from ESR_EL2.IL. Also update the documentation to reflect the PC
> state at the point of exit.
> 
> Finally, this fixes a small buglet where the hypercall.{args,ret}
> fields would not be cleared on exit, and could contain some
> random junk.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  Documentation/virt/kvm/api.rst    |  8 ++++++++
>  arch/arm64/include/uapi/asm/kvm.h |  3 ++-
>  arch/arm64/kvm/hypercalls.c       | 16 +++++++++++-----
>  3 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index c8ab2f730945..103f945959ed 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6244,6 +6244,14 @@ Definition of ``flags``:
>     conduit to initiate the SMCCC call. If this bit is 0 then the guest
>     used the HVC conduit for the SMCCC call.
>  
> + - ``KVM_HYPERCALL_EXIT_16BIT``: Indicates that the guest used a 16bit
> +   instruction to initiate the SMCCC call. If this bit is 0 then the
> +   guest used a 32bit instruction. An AArch64 guest always has this
> +   bit set to 0.
> +
> +At the point of exit, PC points to the instruction immediately following
> +the trapping instruction.
> +
>  ::
>  
>  		/* KVM_EXIT_TPR_ACCESS */
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 3dcfa4bfdf83..b1c1edf85480 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -491,7 +491,8 @@ struct kvm_smccc_filter {
>  };
>  
>  /* arm64-specific KVM_EXIT_HYPERCALL flags */
> -#define KVM_HYPERCALL_EXIT_SMC	(1U << 0)
> +#define KVM_HYPERCALL_EXIT_SMC		(1U << 0)
> +#define KVM_HYPERCALL_EXIT_16BIT	(1U << 1)
>  
>  #endif
>  
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 9a35d6d18193..3b6523f25afc 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -222,13 +222,19 @@ static void kvm_prepare_hypercall_exit(struct kvm_vcpu *vcpu, u32 func_id)
>  {
>  	u8 ec = ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
>  	struct kvm_run *run = vcpu->run;
> -
> -	run->exit_reason = KVM_EXIT_HYPERCALL;
> -	run->hypercall.nr = func_id;
> -	run->hypercall.flags = 0;
> +	u64 flags = 0;
>  
>  	if (ec == ESR_ELx_EC_SMC32 || ec == ESR_ELx_EC_SMC64)
> -		run->hypercall.flags |= KVM_HYPERCALL_EXIT_SMC;
> +		flags |= KVM_HYPERCALL_EXIT_SMC;
> +
> +	if (!kvm_vcpu_trap_il_is32bit(vcpu))
> +		flags |= KVM_HYPERCALL_EXIT_16BIT;
> +
> +	run->exit_reason = KVM_EXIT_HYPERCALL;
> +	run->hypercall = (typeof(run->hypercall)) {
> +		.nr	= func_id,
> +		.flags	= flags,
> +	};
>  }
>  
>  int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
> -- 
> 2.34.1
> 
> 
> -- 
> Without deviation from the norm, progress is not possible.

-- 
Thanks,
Oliver
