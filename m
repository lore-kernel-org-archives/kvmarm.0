From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 16/21] arm64: KVM: Add compatibility aliases
Date: Wed, 2 Dec 2015 12:49:20 +0100
Message-ID: <20151202114920.GB18376@cbox>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
 <1448650215-15218-17-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448650215-15218-17-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 27, 2015 at 06:50:10PM +0000, Marc Zyngier wrote:
> So far, we've implemented the new world switch with a completely
> different namespace, so that we could have both implementation
> compiled in.
> 
> Let's take things one step further by adding weak aliases that
> have the same names as the original implementation. The weak
> attributes allows the new implementation to be overriden by the
> old one, and everything still work.

Do I understand correctly that the whole point of this is to keep
everything compiling nicely while at the same time being able to split
the patches so that you can have an isolated "remove old code" patch
that doesn't have to change the callers?

If so, I think explaining this rationale would be helpful in the commit
message in case we have to go back and track these changes in connection
with a regression and don't remember why we did things this way.

Maybe I'm being over-cautious though...

Otherwise:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/debug-sr.c   | 3 +++
>  arch/arm64/kvm/hyp/hyp-entry.S  | 3 +++
>  arch/arm64/kvm/hyp/switch.c     | 3 +++
>  arch/arm64/kvm/hyp/tlb.c        | 9 +++++++++
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 3 +++
>  5 files changed, 21 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> index a0b2b99..afd0a53 100644
> --- a/arch/arm64/kvm/hyp/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/debug-sr.c
> @@ -128,3 +128,6 @@ u32 __hyp_text __debug_read_mdcr_el2(void)
>  {
>  	return read_sysreg(mdcr_el2);
>  }
> +
> +__alias(__debug_read_mdcr_el2)
> +u32 __weak __kvm_get_mdcr_el2(void);
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index 39d6935..ace919b 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -184,6 +184,8 @@ ENDPROC(\label)
>  
>  	.align 11
>  
> +	.weak	__kvm_hyp_vector
> +ENTRY(__kvm_hyp_vector)
>  ENTRY(__hyp_vector)
>  	ventry	el2t_sync_invalid		// Synchronous EL2t
>  	ventry	el2t_irq_invalid		// IRQ EL2t
> @@ -205,3 +207,4 @@ ENTRY(__hyp_vector)
>  	ventry	el1_fiq_invalid			// FIQ 32-bit EL1
>  	ventry	el1_error_invalid		// Error 32-bit EL1
>  ENDPROC(__hyp_vector)
> +ENDPROC(__kvm_hyp_vector)
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 7b81089..c8ba370 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -141,6 +141,9 @@ int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
>  	return exit_code;
>  }
>  
> +__alias(__guest_run)
> +int __weak __kvm_vcpu_run(struct kvm_vcpu *vcpu);
> +
>  static const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
>  
>  void __hyp_text __noreturn __hyp_panic(void)
> diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
> index d4a07d0..2c279a8 100644
> --- a/arch/arm64/kvm/hyp/tlb.c
> +++ b/arch/arm64/kvm/hyp/tlb.c
> @@ -47,6 +47,9 @@ void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
>  	write_sysreg(0, vttbr_el2);
>  }
>  
> +__alias(__tlb_flush_vmid_ipa)
> +void __weak __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
> +
>  void __hyp_text __tlb_flush_vmid(struct kvm *kvm)
>  {
>  	dsb(ishst);
> @@ -63,6 +66,9 @@ void __hyp_text __tlb_flush_vmid(struct kvm *kvm)
>  	write_sysreg(0, vttbr_el2);
>  }
>  
> +__alias(__tlb_flush_vmid)
> +void __weak __kvm_tlb_flush_vmid(struct kvm *kvm);
> +
>  void __hyp_text __tlb_flush_vm_context(void)
>  {
>  	dsb(ishst);
> @@ -70,3 +76,6 @@ void __hyp_text __tlb_flush_vm_context(void)
>  		     "ic ialluis	  ": : );
>  	dsb(ish);
>  }
> +
> +__alias(__tlb_flush_vm_context)
> +void __weak __kvm_flush_vm_context(void);
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index b490db5..1b0eedb 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -220,3 +220,6 @@ u64 __hyp_text __vgic_v3_read_ich_vtr_el2(void)
>  {
>  	return read_gicreg(ICH_VTR_EL2);
>  }
> +
> +__alias(__vgic_v3_read_ich_vtr_el2)
> +u64 __weak __vgic_v3_get_ich_vtr_el2(void);
> -- 
> 2.1.4
> 
