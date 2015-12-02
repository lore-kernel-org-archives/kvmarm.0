From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 21/21] arm64: KVM: Remove weak attributes
Date: Wed, 2 Dec 2015 12:47:32 +0100
Message-ID: <20151202114732.GA18376@cbox>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
 <1448650215-15218-22-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFE3D49721
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 06:45:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qR3jJcP7-UQU for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2015 06:45:32 -0500 (EST)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE76741AF6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2015 06:45:32 -0500 (EST)
Received: by wmuu63 with SMTP id u63so211191698wmu.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2015 03:46:59 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1448650215-15218-22-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 27, 2015 at 06:50:15PM +0000, Marc Zyngier wrote:
> As we've now switched to the new world switch implementation,
> remove the weak attributes, as nobody is supposed to override
> it anymore.

Why not remove the aliases and change the callers?

-Christoffer

> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/debug-sr.c   |  5 ++---
>  arch/arm64/kvm/hyp/hyp-entry.S  |  3 ---
>  arch/arm64/kvm/hyp/switch.c     |  5 ++---
>  arch/arm64/kvm/hyp/tlb.c        | 16 +++++++---------
>  arch/arm64/kvm/hyp/vgic-v3-sr.c |  5 ++---
>  5 files changed, 13 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> index 774a3f69..747546b 100644
> --- a/arch/arm64/kvm/hyp/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/debug-sr.c
> @@ -125,10 +125,9 @@ void __hyp_text __debug_cond_restore_host_state(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> -u32 __hyp_text __debug_read_mdcr_el2(void)
> +static u32 __hyp_text __debug_read_mdcr_el2(void)
>  {
>  	return read_sysreg(mdcr_el2);
>  }
>  
> -__alias(__debug_read_mdcr_el2)
> -u32 __weak __kvm_get_mdcr_el2(void);
> +__alias(__debug_read_mdcr_el2) u32 __kvm_get_mdcr_el2(void);
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index ace919b..bbc0be1 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -184,9 +184,7 @@ ENDPROC(\label)
>  
>  	.align 11
>  
> -	.weak	__kvm_hyp_vector
>  ENTRY(__kvm_hyp_vector)
> -ENTRY(__hyp_vector)
>  	ventry	el2t_sync_invalid		// Synchronous EL2t
>  	ventry	el2t_irq_invalid		// IRQ EL2t
>  	ventry	el2t_fiq_invalid		// FIQ EL2t
> @@ -206,5 +204,4 @@ ENTRY(__hyp_vector)
>  	ventry	el1_irq				// IRQ 32-bit EL1
>  	ventry	el1_fiq_invalid			// FIQ 32-bit EL1
>  	ventry	el1_error_invalid		// Error 32-bit EL1
> -ENDPROC(__hyp_vector)
>  ENDPROC(__kvm_hyp_vector)
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index c8ba370..1154d66 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -84,7 +84,7 @@ static void __hyp_text __vgic_restore_state(struct kvm_vcpu *vcpu)
>  	__vgic_call_restore_state()(vcpu);
>  }
>  
> -int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
> +static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *host_ctxt;
>  	struct kvm_cpu_context *guest_ctxt;
> @@ -141,8 +141,7 @@ int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
>  	return exit_code;
>  }
>  
> -__alias(__guest_run)
> -int __weak __kvm_vcpu_run(struct kvm_vcpu *vcpu);
> +__alias(__guest_run) int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
>  
>  static const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
>  
> diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
> index 2c279a8..250e06c 100644
> --- a/arch/arm64/kvm/hyp/tlb.c
> +++ b/arch/arm64/kvm/hyp/tlb.c
> @@ -17,7 +17,7 @@
>  
>  #include "hyp.h"
>  
> -void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
> +static void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
>  {
>  	dsb(ishst);
>  
> @@ -47,10 +47,10 @@ void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
>  	write_sysreg(0, vttbr_el2);
>  }
>  
> -__alias(__tlb_flush_vmid_ipa)
> -void __weak __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
> +__alias(__tlb_flush_vmid_ipa) void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm,
> +							    phys_addr_t ipa);
>  
> -void __hyp_text __tlb_flush_vmid(struct kvm *kvm)
> +static void __hyp_text __tlb_flush_vmid(struct kvm *kvm)
>  {
>  	dsb(ishst);
>  
> @@ -66,10 +66,9 @@ void __hyp_text __tlb_flush_vmid(struct kvm *kvm)
>  	write_sysreg(0, vttbr_el2);
>  }
>  
> -__alias(__tlb_flush_vmid)
> -void __weak __kvm_tlb_flush_vmid(struct kvm *kvm);
> +__alias(__tlb_flush_vmid) void __kvm_tlb_flush_vmid(struct kvm *kvm);
>  
> -void __hyp_text __tlb_flush_vm_context(void)
> +static void __hyp_text __tlb_flush_vm_context(void)
>  {
>  	dsb(ishst);
>  	asm volatile("tlbi alle1is	\n"
> @@ -77,5 +76,4 @@ void __hyp_text __tlb_flush_vm_context(void)
>  	dsb(ish);
>  }
>  
> -__alias(__tlb_flush_vm_context)
> -void __weak __kvm_flush_vm_context(void);
> +__alias(__tlb_flush_vm_context) void __kvm_flush_vm_context(void);
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index 1b0eedb..82a4f4b 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -216,10 +216,9 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> -u64 __hyp_text __vgic_v3_read_ich_vtr_el2(void)
> +static u64 __hyp_text __vgic_v3_read_ich_vtr_el2(void)
>  {
>  	return read_gicreg(ICH_VTR_EL2);
>  }
>  
> -__alias(__vgic_v3_read_ich_vtr_el2)
> -u64 __weak __vgic_v3_get_ich_vtr_el2(void);
> +__alias(__vgic_v3_read_ich_vtr_el2) u64 __vgic_v3_get_ich_vtr_el2(void);
> -- 
> 2.1.4
> 
