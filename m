From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH v2 25/38] KVM: arm64: Respect virtual CPTR_EL2.TFP
 setting
Date: Sun, 30 Jul 2017 22:00:29 +0200
Message-ID: <20170730200029.GN5176@cbox>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-26-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F076D49C12
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jul 2017 15:59:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fc0fFu0CL75A for <kvmarm@lists.cs.columbia.edu>;
 Sun, 30 Jul 2017 15:59:20 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E706840D44
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jul 2017 15:59:19 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id m85so154176273wma.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jul 2017 13:00:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1500397144-16232-26-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack.lim@linaro.org>
Cc: kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, marc.zyngier@arm.com, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 11:58:51AM -0500, Jintack Lim wrote:
> Forward traps due to FP/ASIMD register accesses to the virtual EL2 if
> virtual CPTR_EL2.TFP is set. Note that if TFP bit is set, then even
> accesses to FP/ASIMD register from EL2 as well as NS EL0/1 will trap to
> EL2. So, we don't check the VM's exception level.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> ---
>  arch/arm64/kernel/asm-offsets.c |  1 +
>  arch/arm64/kvm/handle_exit.c    | 15 +++++++++++----
>  arch/arm64/kvm/hyp/entry.S      | 13 +++++++++++++
>  arch/arm64/kvm/hyp/hyp-entry.S  |  2 +-
>  4 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index b3bb7ef..f5117a3 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -134,6 +134,7 @@ int main(void)
>    DEFINE(CPU_FP_REGS,		offsetof(struct kvm_regs, fp_regs));
>    DEFINE(VCPU_FPEXC32_EL2,	offsetof(struct kvm_vcpu, arch.ctxt.sys_regs[FPEXC32_EL2]));
>    DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
> +  DEFINE(VIRTUAL_CPTR_EL2,	offsetof(struct kvm_vcpu, arch.ctxt.sys_regs[CPTR_EL2]));
>  #endif
>  #ifdef CONFIG_CPU_PM
>    DEFINE(CPU_SUSPEND_SZ,	sizeof(struct cpu_suspend_ctx));
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 25ec824..d4e7b2b 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -84,11 +84,18 @@ static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  }
>  
>  /*
> - * Guest access to FP/ASIMD registers are routed to this handler only
> - * when the system doesn't support FP/ASIMD.
> + * When the system supports FP/ASMID and we are NOT running nested
> + * virtualization, FP/ASMID traps are handled in EL2 directly.
> + * This handler handles the cases those are not belong to the above case.

The parser parses the cases where the sentence are not belong to the
above sentence, and then my head exploted ;)

>   */
> -static int handle_no_fpsimd(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +static int kvm_handle_fpasimd(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
> +
> +	/* This is for nested virtualization */
> +	if (vcpu_sys_reg(vcpu, CPTR_EL2) & CPTR_EL2_TFP)
> +		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> +
> +	/* This is the case when the system doesn't support FP/ASIMD. */
>  	kvm_inject_undefined(vcpu);
>  	return 1;
>  }
> @@ -220,7 +227,7 @@ static int kvm_handle_eret(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	[ESR_ELx_EC_BREAKPT_LOW]= kvm_handle_guest_debug,
>  	[ESR_ELx_EC_BKPT32]	= kvm_handle_guest_debug,
>  	[ESR_ELx_EC_BRK64]	= kvm_handle_guest_debug,
> -	[ESR_ELx_EC_FP_ASIMD]	= handle_no_fpsimd,
> +	[ESR_ELx_EC_FP_ASIMD]	= kvm_handle_fpasimd,
>  };
>  
>  static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index 12ee62d..95af673 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -158,6 +158,19 @@ abort_guest_exit_end:
>  1:	ret
>  ENDPROC(__guest_exit)
>  
> +ENTRY(__fpsimd_guest_trap)
> +	// If virtual CPTR_EL2.TFP is set, then forward the trap to the
> +	// virtual EL2. For the non-nested case, this bit is always 0.
> +	mrs	x1, tpidr_el2
> +	ldr	x0, [x1, #VIRTUAL_CPTR_EL2]
> +	and 	x0, x0, #CPTR_EL2_TFP
> +	cbnz	x0, 1f
> +	b	__fpsimd_guest_restore
> +1:
> +	mov	x0, #ARM_EXCEPTION_TRAP
> +	b	__guest_exit
> +ENDPROC(__fpsimd_guest_trap)
> +
>  ENTRY(__fpsimd_guest_restore)
>  	stp	x2, x3, [sp, #-16]!
>  	stp	x4, lr, [sp, #-16]!
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index 5170ce1..ab169fd 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -113,7 +113,7 @@ el1_trap:
>  	 */
>  alternative_if_not ARM64_HAS_NO_FPSIMD
>  	cmp	x0, #ESR_ELx_EC_FP_ASIMD
> -	b.eq	__fpsimd_guest_restore
> +	b.eq	__fpsimd_guest_trap
>  alternative_else_nop_endif
>  
>  	mrs	x1, tpidr_el2
> -- 
> 1.9.1
> 
Otherwise, I think this is correct.

Have you subjected your L1 and L2 VMs to a nice round of paranoia FP
testing?

Thanks,
-Christoffer
