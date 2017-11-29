From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v5 6/8] KVM: arm/arm64: Support VGIC dist pend/active
 changes for mapped IRQs
Date: Wed, 29 Nov 2017 16:13:14 +0100
Message-ID: <20171129151314.el7ndd2czsglw7lh@kamzik.brq.redhat.com>
References: <20171120191649.17290-1-christoffer.dall@linaro.org>
 <20171120191649.17290-7-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171120191649.17290-7-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 20, 2017 at 08:16:47PM +0100, Christoffer Dall wrote:
> For mapped IRQs (with the HW bit set in the LR) we have to follow some
> rules of the architecture.  One of these rules is that VM must not be
> allowed to deactivate a virtual interrupt with the HW bit set unless the
> physical interrupt is also active.
> 
> This works fine when injecting mapped interrupts, because we leave it up
> to the injector to either set EOImode==1 or manually set the active
> state of the physical interrupt.
> 
> However, the guest can set virtual interrupt to be pending or active by
> writing to the virtual distributor, which could lead to deactivating a
> virtual interrupt with the HW bit set without the physical interrupt
> being active.
> 
> We could set the physical interrupt to active whenever we are about to
> enter the VM with a HW interrupt either pending or active, but that
> would be really slow, especially on GICv2.  So we take the long way
> around and do the hard work when needed, which is expected to be
> extremely rare.
> 
> When the VM sets the pending state for a HW interrupt on the virtual
> distributor we set the active state on the physical distributor, because
> the virtual interrupt can become active and then the guest can
> deactivate it.
> 
> When the VM clears the pending state we also clear it on the physical
> side, because the injector might otherwise raise the interrupt.  We also
> clear the physical active state when the virtual interrupt is not
> active, since otherwise a SPEND/CPEND sequence from the guest would
> prevent signaling of future interrupts.
> 
> Changing the state of mapped interrupts from userspace is not supported,
> and it's expected that userspace unmaps devices from VFIO before
> attempting to set the interrupt state, because the interrupt state is
> driven by hardware.
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic-mmio.c | 71 +++++++++++++++++++++++++++++++++++++++----
>  virt/kvm/arm/vgic/vgic.c      |  7 +++++
>  virt/kvm/arm/vgic/vgic.h      |  1 +
>  3 files changed, 73 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 6113cf850f47..294e949ece24 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -16,6 +16,7 @@
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  #include <kvm/iodev.h>
> +#include <kvm/arm_arch_timer.h>
>  #include <kvm/arm_vgic.h>
>  
>  #include "vgic.h"
> @@ -142,10 +143,22 @@ static struct kvm_vcpu *vgic_get_mmio_requester_vcpu(void)
>  	return vcpu;
>  }
>  
> +/* Must be called with irq->irq_lock held */
> +static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> +				 bool is_uaccess)
> +{
> +	if (!is_uaccess)
> +		irq->pending_latch = true;
> +
> +	if (!is_uaccess)
> +		vgic_irq_set_phys_active(irq, true);

I see this whole patch has this two 'if (!is_uaccess)' checks pattern.
Is that meant to convey something? Or is the first condition not supposed
to have the '!'? (I'm lost with regards to the state tracking differences
between the guest and userspace and just reviewing superficially...)

> +}
> +
>  void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
>  			      gpa_t addr, unsigned int len,
>  			      unsigned long val)
>  {
> +	bool is_uaccess = !vgic_get_mmio_requester_vcpu();
>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>  	int i;
>  	unsigned long flags;
> @@ -154,17 +167,45 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>  
>  		spin_lock_irqsave(&irq->irq_lock, flags);
> -		irq->pending_latch = true;
> -
> +		if (irq->hw)
> +			vgic_hw_irq_spending(vcpu, irq, is_uaccess);
> +		else
> +			irq->pending_latch = true;
>  		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
>  		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  }
>  
> +/* Must be called with irq->irq_lock held */
> +static void vgic_hw_irq_cpending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> +				 bool is_uaccess)
> +{
> +	if (!is_uaccess)
> +		irq->pending_latch = false;
> +
> +	if (!is_uaccess) {
> +		/*
> +		 * We don't want the guest to effectively mask the physical
> +		 * interrupt by doing a write to SPENDR followed by a write to
> +		 * CPENDR for HW interrupts, so we clear the active state on
> +		 * the physical side if the virtual interrupt is not active.
> +		 * This may lead to taking an additional interrupt on the
> +		 * host, but that should not be a problem as the worst that
> +		 * can happen is an additional vgic injection.  We also clear
> +		 * the pending state to maintain proper semantics for edge HW
> +		 * interrupts.
> +		 */
> +		vgic_irq_set_phys_pending(irq, false);
> +		if (!irq->active)
> +			vgic_irq_set_phys_active(irq, false);
> +	}
> +}
> +
>  void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
>  			      gpa_t addr, unsigned int len,
>  			      unsigned long val)
>  {
> +	bool is_uaccess = !vgic_get_mmio_requester_vcpu();
>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>  	int i;
>  	unsigned long flags;
> @@ -174,7 +215,10 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
>  
>  		spin_lock_irqsave(&irq->irq_lock, flags);
>  
> -		irq->pending_latch = false;
> +		if (irq->hw)
> +			vgic_hw_irq_cpending(vcpu, irq, is_uaccess);
> +		else
> +			irq->pending_latch = false;
>  
>  		spin_unlock_irqrestore(&irq->irq_lock, flags);
>  		vgic_put_irq(vcpu->kvm, irq);
> @@ -201,8 +245,19 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
>  	return value;
>  }
>  
> +/* Must be called with irq->irq_lock held */
> +static void vgic_hw_irq_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> +				      bool active, bool is_uaccess)
> +{
> +	if (!is_uaccess)
> +		irq->active = active;;
> +
> +	if (!is_uaccess)
> +		vgic_irq_set_phys_active(irq, active);
> +}
> +
>  static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> -				    bool new_active_state)
> +				    bool active)
>  {
>  	unsigned long flags;
>  	struct kvm_vcpu *requester_vcpu = vgic_get_mmio_requester_vcpu();
> @@ -230,8 +285,12 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>  	       irq->vcpu->cpu != -1) /* VCPU thread is running */
>  		cond_resched_lock(&irq->irq_lock);
>  
> -	irq->active = new_active_state;
> -	if (new_active_state)
> +	if (irq->hw)
> +		vgic_hw_irq_change_active(vcpu, irq, active, !requester_vcpu);
> +	else
> +		irq->active = active;
> +
> +	if (irq->active)
>  		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
>  	else
>  		spin_unlock_irqrestore(&irq->irq_lock, flags);
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 91266960dbd4..2d40384481d0 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -144,6 +144,13 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
>  	kfree(irq);
>  }
>  
> +void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending)
> +{
> +	WARN_ON(irq_set_irqchip_state(irq->host_irq,
> +				      IRQCHIP_STATE_PENDING,
> +				      pending));
> +}
> +
>  /* Get the input level of a mapped IRQ directly from the physical GIC */
>  bool vgic_get_phys_line_level(struct vgic_irq *irq)
>  {
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index d0787983a357..12c37b89f7a3 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -146,6 +146,7 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  			      u32 intid);
>  void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
>  bool vgic_get_phys_line_level(struct vgic_irq *irq);
> +void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending);
>  void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active);
>  bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
>  			   unsigned long flags);
> -- 
> 2.14.2
> 
