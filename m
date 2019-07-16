Return-Path: <SRS0=eCDF=VN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34879C76192
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jul 2019 16:35:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B3F94206C2
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jul 2019 16:35:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3F94206C2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A7E14A539;
	Tue, 16 Jul 2019 12:35:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6oN7kpvgWpDz; Tue, 16 Jul 2019 12:35:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A56D54A53F;
	Tue, 16 Jul 2019 12:35:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 160364A533
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jul 2019 12:35:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1roTAWAoL97c for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jul 2019 12:35:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61AEA4A51F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jul 2019 12:35:21 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7BB02B;
 Tue, 16 Jul 2019 09:35:20 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E02943F71A;
 Tue, 16 Jul 2019 09:35:19 -0700 (PDT)
Subject: Re: [PATCH 53/59] KVM: arm64: nv: Implement maintenance interrupt
 forwarding
To: Marc Zyngier <marc.zyngier@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-54-marc.zyngier@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <432dedcf-620e-4de1-3d22-9527665276b2@arm.com>
Date: Tue, 16 Jul 2019 17:35:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-54-marc.zyngier@arm.com>
Content-Language: en-US
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 6/21/19 10:38 AM, Marc Zyngier wrote:
> When we take a maintenance interrupt, we need to decide whether
> it is generated on an action from the guest, or if it is something
> that needs to be forwarded to the guest hypervisor.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/nested.c            |  2 +-
>  virt/kvm/arm/vgic/vgic-init.c      | 30 ++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v3-nested.c | 25 +++++++++++++++++++++----
>  3 files changed, 52 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index df2db9ab7cfb..ab61f0f30ee6 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -545,7 +545,7 @@ bool vgic_state_is_nested(struct kvm_vcpu *vcpu)
>  	bool imo = __vcpu_sys_reg(vcpu, HCR_EL2) & HCR_IMO;
>  	bool fmo = __vcpu_sys_reg(vcpu, HCR_EL2) & HCR_FMO;
>  
> -	WARN(imo != fmo, "Separate virtual IRQ/FIQ settings not supported\n");
> +	WARN_ONCE(imo != fmo, "Separate virtual IRQ/FIQ settings not supported\n");
>  
>  	return nested_virt_in_use(vcpu) && imo && fmo && !is_hyp_ctxt(vcpu);
>  }
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 3bdb31eaed64..ec54bc8d5126 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -17,9 +17,11 @@
>  #include <linux/uaccess.h>
>  #include <linux/interrupt.h>
>  #include <linux/cpu.h>
> +#include <linux/irq.h>
>  #include <linux/kvm_host.h>
>  #include <kvm/arm_vgic.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_nested.h>
>  #include "vgic.h"
>  
>  /*
> @@ -240,6 +242,16 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
>  	if (!irqchip_in_kernel(vcpu->kvm))
>  		return 0;
>  
> +	if (nested_virt_in_use(vcpu)) {
> +		/* FIXME: remove this hack */
> +		if (vcpu->kvm->arch.vgic.maint_irq == 0)
> +			vcpu->kvm->arch.vgic.maint_irq = kvm_vgic_global_state.maint_irq;
> +		ret = kvm_vgic_set_owner(vcpu, vcpu->kvm->arch.vgic.maint_irq,
> +					 vcpu);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	/*
>  	 * If we are creating a VCPU with a GICv3 we must also register the
>  	 * KVM io device for the redistributor that belongs to this VCPU.
> @@ -455,12 +467,23 @@ static int vgic_init_cpu_dying(unsigned int cpu)
>  
>  static irqreturn_t vgic_maintenance_handler(int irq, void *data)
>  {
> +	struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)data;
> +
>  	/*
>  	 * We cannot rely on the vgic maintenance interrupt to be
>  	 * delivered synchronously. This means we can only use it to
>  	 * exit the VM, and we perform the handling of EOIed
>  	 * interrupts on the exit path (see vgic_fold_lr_state).
>  	 */
> +
> +	/* If not nested, deactivate */
> +	if (!vcpu || !vgic_state_is_nested(vcpu)) {
> +		irq_set_irqchip_state(irq, IRQCHIP_STATE_ACTIVE, false);
> +		return IRQ_HANDLED;
> +	}
> +
> +	/* Assume nested from now */
> +	vgic_v3_handle_nested_maint_irq(vcpu);
>  	return IRQ_HANDLED;
>  }
>  
> @@ -531,6 +554,13 @@ int kvm_vgic_hyp_init(void)
>  		return ret;
>  	}
>  
> +	ret = irq_set_vcpu_affinity(kvm_vgic_global_state.maint_irq,
> +				    kvm_get_running_vcpus());
> +	if (ret) {
> +		kvm_err("Error setting vcpu affinity\n");
> +		goto out_free_irq;
> +	}
> +
>  	ret = cpuhp_setup_state(CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
>  				"kvm/arm/vgic:starting",
>  				vgic_init_cpu_starting, vgic_init_cpu_dying);
> diff --git a/virt/kvm/arm/vgic/vgic-v3-nested.c b/virt/kvm/arm/vgic/vgic-v3-nested.c
> index c917d49e4a14..7c5f82ae68e0 100644
> --- a/virt/kvm/arm/vgic/vgic-v3-nested.c
> +++ b/virt/kvm/arm/vgic/vgic-v3-nested.c
> @@ -172,10 +172,20 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
>  void vgic_v3_load_nested(struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	struct vgic_irq *irq;
> +	unsigned long flags;
>  
>  	vgic_cpu->shadow_vgic_v3 = vgic_cpu->nested_vgic_v3;
>  	vgic_v3_create_shadow_lr(vcpu);
>  	__vgic_v3_restore_state(vcpu_shadow_if(vcpu));
> +
> +	irq = vgic_get_irq(vcpu->kvm, vcpu, vcpu->kvm->arch.vgic.maint_irq);
> +	raw_spin_lock_irqsave(&irq->irq_lock, flags);
> +	if (irq->line_level || irq->active)
> +		irq_set_irqchip_state(kvm_vgic_global_state.maint_irq,
> +				      IRQCHIP_STATE_ACTIVE, true);
> +	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +	vgic_put_irq(vcpu->kvm, irq);
>  }
>  
>  void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
> @@ -190,11 +200,14 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
>  	 */
>  	vgic_v3_fixup_shadow_lr_state(vcpu);
>  	vgic_cpu->nested_vgic_v3 = vgic_cpu->shadow_vgic_v3;
> +	irq_set_irqchip_state(kvm_vgic_global_state.maint_irq,
> +			      IRQCHIP_STATE_ACTIVE, false);
>  }
>  
>  void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
> +	bool state;
>  
>  	/*
>  	 * If we exit a nested VM with a pending maintenance interrupt from the
> @@ -202,8 +215,12 @@ void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
>  	 * can re-sync the appropriate LRs and sample level triggered interrupts
>  	 * again.
>  	 */
> -	if (vgic_state_is_nested(vcpu) &&
> -	    (cpu_if->vgic_hcr & ICH_HCR_EN) &&
> -	    vgic_v3_get_misr(vcpu))
> -		kvm_inject_nested_irq(vcpu);
> +	if (!vgic_state_is_nested(vcpu))
> +		return;

Isn't this redundant with the same check in vgic_maintenance_handler?

Thanks,
Alex
> +
> +	state  = cpu_if->vgic_hcr & ICH_HCR_EN;
> +	state &= vgic_v3_get_misr(vcpu);
> +
> +	kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
> +			    vcpu->kvm->arch.vgic.maint_irq, state, vcpu);
>  }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
