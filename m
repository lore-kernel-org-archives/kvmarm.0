From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 10/31] KVM: arm64: vgic-v3: Add hook to handle guest GICv3
 sysreg accesses at EL2
Date: Wed, 17 May 2017 11:54:07 +0200
Message-ID: <0572476a-b61f-3c00-00ac-a06aebdbaf9b@redhat.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-11-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F225740B8C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 May 2017 05:50:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2xqiC+2Ls2Ky for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 May 2017 05:50:44 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 81B72400E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 May 2017 05:50:44 -0400 (EDT)
In-Reply-To: <20170503104606.19342-11-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,
On 03/05/2017 12:45, Marc Zyngier wrote:
> In order to start handling guest access to GICv3 system registers,
> let's add a hook that will get called when we trap a system register
> access. This is gated by a new static key (vgic_v3_cpuif_trap).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  arch/arm64/include/asm/kvm_hyp.h |  1 +
>  arch/arm64/kvm/hyp/switch.c      | 14 ++++++++++++++
>  include/kvm/arm_vgic.h           |  1 +
>  virt/kvm/arm/hyp/vgic-v3-sr.c    | 27 +++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v3.c      |  2 ++
>  5 files changed, 45 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index b18e852d27e8..4572a9b560fa 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -127,6 +127,7 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
>  
>  void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
>  void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
> +int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
>  
>  void __timer_save_state(struct kvm_vcpu *vcpu);
>  void __timer_restore_state(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index aede1658aeda..dfd8ca16601b 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -350,6 +350,20 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  		}
>  	}
>  
> +	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
> +	    exit_code == ARM_EXCEPTION_TRAP &&
> +	    (kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 ||
> +	     kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_CP15_32)) {
> +		int ret = __vgic_v3_perform_cpuif_access(vcpu);
> +
> +		if (ret == 1) {
> +			__skip_instr(vcpu);
> +			goto again;
> +		}
> +
> +		/* 0 falls through to be handled out of EL2 */
> +	}
> +
>  	fp_enabled = __fpsimd_enabled();
>  
>  	__sysreg_save_guest_state(guest_ctxt);
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 581a59ea7e34..ddfa11b713bf 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -280,6 +280,7 @@ struct vgic_cpu {
>  };
>  
>  extern struct static_key_false vgic_v2_cpuif_trap;
> +extern struct static_key_false vgic_v3_cpuif_trap;
>  
>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
>  void kvm_vgic_early_init(struct kvm *kvm);
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 990d9d1e85d0..435787a93c6c 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -19,6 +19,7 @@
>  #include <linux/irqchip/arm-gic-v3.h>
>  #include <linux/kvm_host.h>
>  
> +#include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
>  
>  #define vtr_to_max_lr_idx(v)		((v) & 0xf)
> @@ -371,3 +372,29 @@ void __hyp_text __vgic_v3_write_vmcr(u32 vmcr)
>  {
>  	write_gicreg(vmcr, ICH_VMCR_EL2);
>  }
> +
> +#ifdef CONFIG_ARM64
> +
> +int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
> +{
> +	u32 esr = kvm_vcpu_get_hsr(vcpu);
> +	u32 sysreg;
> +
> +	if (vcpu_mode_is_32bit(vcpu)) {
> +		if (!kvm_condition_valid(vcpu))
> +			return 1;
> +
> +		sysreg = esr_cp15_to_sysreg(esr);
> +	} else {
> +		sysreg = esr_sys64_to_sysreg(esr);
> +	}
> +
> +	switch (sysreg) {
> +	default:
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
> +#endif
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 393779ebe87c..063526443781 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -318,6 +318,8 @@ int vgic_v3_map_resources(struct kvm *kvm)
>  	return ret;
>  }
>  
> +DEFINE_STATIC_KEY_FALSE(vgic_v3_cpuif_trap);
> +
>  /**
>   * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
>   * @node:	pointer to the DT node
> 
