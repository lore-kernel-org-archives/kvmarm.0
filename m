From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v3 03/41] KVM: arm64: Avoid storing the vcpu pointer on
 the stack
Date: Mon, 5 Feb 2018 17:14:02 +0000
Message-ID: <04c3b1a1-56dc-1f2b-6312-4d99178dd8eb@arm.com>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-4-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180112120747.27999-4-christoffer.dall@linaro.org>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 12/01/18 12:07, Christoffer Dall wrote:
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 048f5db120f3..6ce0b428a4db 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -350,10 +350,15 @@ int kvm_perf_teardown(void);
>   
>   struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
>   
> +extern void __kvm_set_tpidr_el2(u64 tpidr_el2);

NIT: The rest of the file seem to declare prototype without extern.

[...]

> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index 71bf088f1e4b..612021dce84f 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -135,6 +135,7 @@ int main(void)
>     DEFINE(CPU_FP_REGS,		offsetof(struct kvm_regs, fp_regs));
>     DEFINE(VCPU_FPEXC32_EL2,	offsetof(struct kvm_vcpu, arch.ctxt.sys_regs[FPEXC32_EL2]));
>     DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
> +  DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
>   #endif
>   #ifdef CONFIG_CPU_PM
>     DEFINE(CPU_SUSPEND_SZ,	sizeof(struct cpu_suspend_ctx));
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index 9a8ab5dddd9e..a360ac6e89e9 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -62,9 +62,6 @@ ENTRY(__guest_enter)
>   	// Store the host regs
>   	save_callee_saved_regs x1
>   
> -	// Store host_ctxt and vcpu for use at exit time
> -	stp	x1, x0, [sp, #-16]!
> -
>   	add	x18, x0, #VCPU_CONTEXT
>   
>   	// Restore guest regs x0-x17
> @@ -118,8 +115,7 @@ ENTRY(__guest_exit)
>   	// Store the guest regs x19-x29, lr
>   	save_callee_saved_regs x1
>   
> -	// Restore the host_ctxt from the stack
> -	ldr	x2, [sp], #16
> +	get_host_ctxt	x2, x3
>   
>   	// Now restore the host regs
>   	restore_callee_saved_regs x2
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index e4f37b9dd47c..71b4cc92895e 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -56,18 +56,15 @@ ENDPROC(__vhe_hyp_call)
>   el1_sync:				// Guest trapped into EL2
>   	stp	x0, x1, [sp, #-16]!
>   
> -alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
> -	mrs	x1, esr_el2
> -alternative_else
> -	mrs	x1, esr_el1
> -alternative_endif
> -	lsr	x0, x1, #ESR_ELx_EC_SHIFT
> +	mrs	x1, vttbr_el2		// If vttbr is valid, this is a trap
> +	cbnz	x1, el1_trap		// from the guest
>   
> -	cmp	x0, #ESR_ELx_EC_HVC64
> -	b.ne	el1_trap
> -
> -	mrs	x1, vttbr_el2		// If vttbr is valid, the 64bit guest
> -	cbnz	x1, el1_trap		// called HVC
> +#ifdef CONFIG_DEBUG
> +	mrs	x0, esr_el2
> +	lsr	x0, x0, #ESR_ELx_EC_SHIFT
> +	cmp     x0, #ESR_ELx_EC_HVC64
> +	b.ne    __hyp_panic
> +#endif

FWIW, I noticed that Mark's series about Spectre is also touching this 
code (see https://patchwork.kernel.org/patch/10190297/).

Cheers,

-- 
Julien Grall
