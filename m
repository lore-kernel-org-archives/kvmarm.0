From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 3/5] arm64: KVM: vgic-v2: Add the GICV emulation
 infrastructure
Date: Thu, 1 Sep 2016 14:46:29 +0200
Message-ID: <20160901124629.GF10162@cbox>
References: <1471610295-1456-1-git-send-email-marc.zyngier@arm.com>
 <1471610295-1456-4-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87D8E40BDA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 08:36:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w57MBvKDySzP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2016 08:35:59 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A4C740B58
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 08:35:58 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id v143so19858616wmv.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Sep 2016 05:44:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1471610295-1456-4-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Aug 19, 2016 at 01:38:13PM +0100, Marc Zyngier wrote:
> In order to efficiently perform the GICV access on behalf of the
> guest, we need to be able to do avoid going back all the way to

s/do//

> the host kernel.
> 
> For this, we introduce a new hook in the world switch code,
> conveniently placed just after populating the fault info.
> At that point, we only have saved/restored the GP registers,
> and we can quickly perform all the required checks (data abort,
> translation fault, valid faulting syndrome, not an external
> abort, not a PTW).
> 
> Coming back from the emulation code, we need to skip the emulated
> instruction. This involves an additional bit of save/restore in
> order to be able to access the guest's PC (and possibly CPSR if
> this is a 32bit guest).
> 
> At this stage, no emulation code is provided.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/kvm_hyp.h |  1 +
>  arch/arm64/kvm/hyp/switch.c      | 32 ++++++++++++++++++++++++++++++++
>  include/kvm/arm_vgic.h           |  3 +++
>  virt/kvm/arm/hyp/vgic-v2-sr.c    |  7 +++++++
>  virt/kvm/arm/vgic/vgic-v2.c      |  2 ++
>  5 files changed, 45 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index cff5105..88ec3ac 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -123,6 +123,7 @@ typeof(orig) * __hyp_text fname(void)					\
>  
>  void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
>  void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
> +bool __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
>  
>  void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
>  void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index ae7855f..0be1594 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -17,6 +17,7 @@
>  
>  #include <linux/types.h>
>  #include <asm/kvm_asm.h>
> +#include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
>  
>  static bool __hyp_text __fpsimd_enabled_nvhe(void)
> @@ -232,6 +233,21 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +static void __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.ctxt.gp_regs.regs.pc	= read_sysreg_el2(elr);
> +
> +	if (vcpu_mode_is_32bit(vcpu)) {
> +		vcpu->arch.ctxt.gp_regs.regs.pstate = read_sysreg_el2(spsr);
> +		kvm_skip_aarch32_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> +		write_sysreg_el2(vcpu->arch.ctxt.gp_regs.regs.pstate, spsr);
> +	} else {
> +		*vcpu_pc(vcpu) += 4;
> +	}
> +
> +	write_sysreg_el2(vcpu->arch.ctxt.gp_regs.regs.pc, elr);
> +}
> +
>  static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *host_ctxt;
> @@ -270,6 +286,22 @@ again:
>  	if (exit_code == ARM_EXCEPTION_TRAP && !__populate_fault_info(vcpu))
>  		goto again;
>  
> +	if (static_branch_unlikely(&vgic_v2_cpuif_trap) &&
> +	    exit_code == ARM_EXCEPTION_TRAP) {

do you get the static branch benefit when the test contains an &&
clause?  (I haven't looked at the generated assembly, no)

Also, if you flip this static branch for code both mapped in EL1 and
EL2, would you potentially need some form of additional icache
maintenance here?

Or are you relying on the static branch being set at boot time and hold
forever true/false?

> +		bool valid;
> +
> +		valid = kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_DABT_LOW &&
> +			kvm_vcpu_trap_get_fault_type(vcpu) == FSC_FAULT &&
> +			kvm_vcpu_dabt_isvalid(vcpu) &&
> +			!kvm_vcpu_dabt_isextabt(vcpu) &&
> +			!kvm_vcpu_dabt_iss1tw(vcpu);
> +
> +		if (valid &&  __vgic_v2_perform_cpuif_access(vcpu)) {

extra whitespace

> +			__skip_instr(vcpu);

does this interact in any amusing way with single-step guest debugging?

> +			goto again;
> +		}
> +	}
> +
>  	fp_enabled = __fpsimd_enabled();
>  
>  	__sysreg_save_guest_state(guest_ctxt);
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 19b698e..8eb1501 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -20,6 +20,7 @@
>  #include <linux/kvm.h>
>  #include <linux/irqreturn.h>
>  #include <linux/spinlock.h>
> +#include <linux/static_key.h>
>  #include <linux/types.h>
>  #include <kvm/iodev.h>
>  #include <linux/list.h>
> @@ -265,6 +266,8 @@ struct vgic_cpu {
>  	bool lpis_enabled;
>  };
>  
> +extern struct static_key_false vgic_v2_cpuif_trap;
> +
>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
>  void kvm_vgic_early_init(struct kvm *kvm);
>  int kvm_vgic_create(struct kvm *kvm, u32 type);
> diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
> index 7cffd93..3e2a62e 100644
> --- a/virt/kvm/arm/hyp/vgic-v2-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
> @@ -167,3 +167,10 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
>  	writel_relaxed(cpu_if->vgic_vmcr, base + GICH_VMCR);
>  	vcpu->arch.vgic_cpu.live_lrs = live_lrs;
>  }
> +
> +#ifdef CONFIG_ARM64
> +bool __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
> +{
> +		return false;
> +}
> +#endif
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index 0bf6709..b8da901 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -294,6 +294,8 @@ out:
>  	return ret;
>  }
>  
> +DEFINE_STATIC_KEY_FALSE(vgic_v2_cpuif_trap);
> +
>  /**
>   * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
>   * @node:	pointer to the DT node
> -- 
> 2.1.4
> 

Thanks,
-Christoffer
