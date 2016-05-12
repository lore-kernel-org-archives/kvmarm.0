From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 54/55] KVM: arm/arm64: vgic-new: implement mapped IRQ
 handling
Date: Thu, 12 May 2016 21:36:28 +0200
Message-ID: <20160512193628.GU27623@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-55-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462531568-9799-55-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 06, 2016 at 11:46:07AM +0100, Andre Przywara wrote:
> We now store the mapped hardware IRQ number in our struct, so we
> don't need the irq_phys_map for the new VGIC.
> Implement the hardware IRQ mapping on top of the reworked arch
> timer interface.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog RFC..v1:
> - adapt to new arch_timer mapped IRQ interface
> - implement inject_mapped_irq() as a macro (since it is identical to
>   the "un-mapped" IRQ implementation)
> 
> Changelog v1 .. v2:
> - replace inject_mapped_irq() macro with a separate implementation,
>   which only allows mapped IRQs to be injected via this interface
> 
>  include/kvm/vgic/vgic.h  |  5 +++++
>  virt/kvm/arm/vgic/vgic.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+)
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 07c3011..64aca0c 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -213,6 +213,11 @@ int kvm_vgic_hyp_init(void);
>  
>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  			bool level);
> +int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
> +			       bool level);
> +int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq);
> +int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
> +bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
>  
>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
>  
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 068389a..3f854c5 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -310,6 +310,44 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  	return vgic_update_irq_pending(kvm, cpuid, intid, level, false);
>  }
>  
> +int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
> +			       bool level)
> +{
> +	return vgic_update_irq_pending(kvm, cpuid, intid, level, true);
> +}
> +
> +int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq)
> +{
> +	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
> +
> +	BUG_ON(!irq);
> +
> +	spin_lock(&irq->irq_lock);
> +
> +	irq->hw = true;
> +	irq->hwintid = phys_irq;
> +
> +	spin_unlock(&irq->irq_lock);
> +
> +	return 0;
> +}
> +
> +int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq)
> +{
> +	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
> +
> +	BUG_ON(!irq);
> +
> +	spin_lock(&irq->irq_lock);
> +
> +	irq->hw = false;
> +	irq->hwintid = 0;
> +
> +	spin_unlock(&irq->irq_lock);
> +
> +	return 0;
> +}
> +
>  /**
>   * vgic_prune_ap_list - Remove non-relevant interrupts from the list
>   *
> @@ -563,3 +601,15 @@ void vgic_kick_vcpus(struct kvm *kvm)
>  			kvm_vcpu_kick(vcpu);
>  	}
>  }
> +
> +bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
> +{
> +	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, virt_irq);
> +	bool map_is_active;
> +
> +	spin_lock(&irq->irq_lock);
> +	map_is_active = irq->hw && irq->active;
> +	spin_unlock(&irq->irq_lock);
> +
> +	return map_is_active;
> +}
> -- 
> 2.7.3
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
