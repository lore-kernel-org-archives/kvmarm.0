From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH v2 20/38] KVM: arm64: Handle eret instruction traps
Date: Sun, 30 Jul 2017 22:00:10 +0200
Message-ID: <20170730200010.GJ5176@cbox>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-21-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1500397144-16232-21-git-send-email-jintack.lim@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jintack Lim <jintack.lim@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, corbet@lwn.net, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, akpm@linux-foundation.org, mchehab@kernel.org, cov@codeaurora.org, daniel.lezcano@linaro.org, david.daney@cavium.com, mark.rutland@arm.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, andy.gross@linaro.org, wcohen@redhat.com, ard.biesheuvel@linaro.org, shankerd@codeaurora.org, vladimir.murzin@arm.com, james.morse@arm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 11:58:46AM -0500, Jintack Lim wrote:
> When HCR.NV bit is set, eret instructions trap to EL2 with EC code 0x1A.
> Emulate eret instructions by setting pc and pstate.

It may be worth noting in the commit message that this is all we have to
do, because the rest of the logic will then discover that the mode could
change from virtual EL2 to EL1 and will setup the hw registers etc. when
changing modes.

> 
> Note that the current exception level is always the virtual EL2, since
> we set HCR_EL2.NV bit only when entering the virtual EL2. So, we take
> spsr and elr states from the virtual _EL2 registers.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> ---
>  arch/arm64/include/asm/esr.h |  1 +
>  arch/arm64/kvm/handle_exit.c | 16 ++++++++++++++++
>  arch/arm64/kvm/trace.h       | 21 +++++++++++++++++++++
>  3 files changed, 38 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index e7d8e28..210fde6 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -43,6 +43,7 @@
>  #define ESR_ELx_EC_HVC64	(0x16)
>  #define ESR_ELx_EC_SMC64	(0x17)
>  #define ESR_ELx_EC_SYS64	(0x18)
> +#define ESR_ELx_EC_ERET		(0x1A)
>  /* Unallocated EC: 0x19 - 0x1E */
>  #define ESR_ELx_EC_IMP_DEF	(0x1f)
>  #define ESR_ELx_EC_IABT_LOW	(0x20)
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 17d8a16..9259881 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -147,6 +147,21 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	return 1;
>  }
>  
> +static int kvm_handle_eret(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	trace_kvm_nested_eret(vcpu, vcpu_el2_sreg(vcpu, ELR_EL2),
> +			      vcpu_el2_sreg(vcpu, SPSR_EL2));
> +
> +	/*
> +	 * Note that the current exception level is always the virtual EL2,
> +	 * since we set HCR_EL2.NV bit only when entering the virtual EL2.
> +	 */
> +	*vcpu_pc(vcpu) = vcpu_el2_sreg(vcpu, ELR_EL2);
> +	*vcpu_cpsr(vcpu) = vcpu_el2_sreg(vcpu, SPSR_EL2);
> +
> +	return 1;
> +}
> +
>  static exit_handle_fn arm_exit_handlers[] = {
>  	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
>  	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
> @@ -160,6 +175,7 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	[ESR_ELx_EC_HVC64]	= handle_hvc,
>  	[ESR_ELx_EC_SMC64]	= handle_smc,
>  	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
> +	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
>  	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
>  	[ESR_ELx_EC_DABT_LOW]	= kvm_handle_guest_abort,
>  	[ESR_ELx_EC_SOFTSTP_LOW]= kvm_handle_guest_debug,
> diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
> index 7c86cfb..5f40987 100644
> --- a/arch/arm64/kvm/trace.h
> +++ b/arch/arm64/kvm/trace.h
> @@ -187,6 +187,27 @@
>  	TP_printk("vcpu: %p, inject exception to vEL2: ESR_EL2 0x%lx, vector: 0x%016lx",
>  		  __entry->vcpu, __entry->esr_el2, __entry->pc)
>  );
> +
> +TRACE_EVENT(kvm_nested_eret,
> +	TP_PROTO(struct kvm_vcpu *vcpu, unsigned long elr_el2,
> +		 unsigned long spsr_el2),
> +	TP_ARGS(vcpu, elr_el2, spsr_el2),
> +
> +	TP_STRUCT__entry(
> +		__field(struct kvm_vcpu *,	vcpu)
> +		__field(unsigned long,		elr_el2)
> +		__field(unsigned long,		spsr_el2)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->vcpu = vcpu;
> +		__entry->elr_el2 = elr_el2;
> +		__entry->spsr_el2 = spsr_el2;
> +	),
> +
> +	TP_printk("vcpu: %p, eret to elr_el2: 0x%016lx, with spsr_el2: 0x%08lx",
> +		  __entry->vcpu, __entry->elr_el2, __entry->spsr_el2)
> +);
>  #endif /* _TRACE_ARM64_KVM_H */
>  
>  #undef TRACE_INCLUDE_PATH
> -- 
> 1.9.1
> 

Otherwise this patch looks good.

Thanks,
-Christoffer
