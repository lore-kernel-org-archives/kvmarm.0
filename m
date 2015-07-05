From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/3] arm: KVM: define headers and offsets to mange VFP
 state
Date: Sun, 5 Jul 2015 21:27:59 +0200
Message-ID: <20150705192759.GA3869@cbox>
References: <1435203028-23142-1-git-send-email-m.smarduch@samsung.com>
 <1435203028-23142-2-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C1F157A12
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2015 15:16:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 27WKBAFCkfH5 for <kvmarm@lists.cs.columbia.edu>;
 Sun,  5 Jul 2015 15:16:36 -0400 (EDT)
Received: from mail-la0-f53.google.com (mail-la0-f53.google.com
 [209.85.215.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1B0A57A11
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2015 15:16:35 -0400 (EDT)
Received: by lagc2 with SMTP id c2so132051854lag.3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 05 Jul 2015 12:28:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1435203028-23142-2-git-send-email-m.smarduch@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jun 24, 2015 at 08:30:26PM -0700, Mario Smarduch wrote:
> Define the required kvm_vcpu_arch fields, and offsets to manage VFP state. And
> declary Hyp interface function to switch VFP registers.
> 
> 
> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
> ---
>  arch/arm/include/asm/kvm_asm.h  |    1 +
>  arch/arm/include/asm/kvm_host.h |    3 +++
>  arch/arm/kernel/asm-offsets.c   |    1 +
>  3 files changed, 5 insertions(+)
> 
> diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
> index 25410b2..08dda8c 100644
> --- a/arch/arm/include/asm/kvm_asm.h
> +++ b/arch/arm/include/asm/kvm_asm.h
> @@ -97,6 +97,7 @@ extern char __kvm_hyp_code_end[];
>  extern void __kvm_flush_vm_context(void);
>  extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
>  extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
> +extern void __kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu);
>  
>  extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
>  #endif
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index d71607c..22cea72 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -111,6 +111,9 @@ struct kvm_vcpu_arch {
>  	/* Interrupt related fields */
>  	u32 irq_lines;		/* IRQ and FIQ levels */
>  
> +	/* Track if VFP registers are occupied by Guest while in KVM host mode*/

why capitalize guest?

missing space at the end of the line.

I don't really understand what the semantics of this field is by just
lookint at this patch.  I would probably define a u32 flags field in
stead and define a patch akin to what we do for the debug registers and
call it 'vfp_dirty', and in a comment for the flag offset define say
something like:

The vfp_dirty flag must be set if the host VFP register state is
modified.

> +	u32 vfp_guest_saved;
> +
>  	/* Exception Information */
>  	struct kvm_vcpu_fault_info fault;
>  
> diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
> index 871b826..35093d0 100644
> --- a/arch/arm/kernel/asm-offsets.c
> +++ b/arch/arm/kernel/asm-offsets.c
> @@ -191,6 +191,7 @@ int main(void)
>    DEFINE(VCPU_HPFAR,		offsetof(struct kvm_vcpu, arch.fault.hpfar));
>    DEFINE(VCPU_HYP_PC,		offsetof(struct kvm_vcpu, arch.fault.hyp_pc));
>    DEFINE(VCPU_VGIC_CPU,		offsetof(struct kvm_vcpu, arch.vgic_cpu));
> +  DEFINE(VCPU_VFP_SAVED,	offsetof(struct kvm_vcpu, arch.vfp_guest_saved));
>    DEFINE(VGIC_V2_CPU_HCR,	offsetof(struct vgic_cpu, vgic_v2.vgic_hcr));
>    DEFINE(VGIC_V2_CPU_VMCR,	offsetof(struct vgic_cpu, vgic_v2.vgic_vmcr));
>    DEFINE(VGIC_V2_CPU_MISR,	offsetof(struct vgic_cpu, vgic_v2.vgic_misr));
> -- 
> 1.7.9.5
> 
