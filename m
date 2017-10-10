From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 7/7] KVM: arm/arm64: Support VGIC dist pend/active changes for mapped IRQs
Date: Tue, 10 Oct 2017 11:49:35 +0100
Message-ID: <87fuaruvk0.fsf@on-the-bus.cambridge.arm.com>
References: <1505513994-77939-1-git-send-email-christoffer.dall@linaro.org>
        <1505513994-77939-8-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1505513994-77939-8-git-send-email-christoffer.dall@linaro.org>
        (Christoffer Dall's message of "Fri, 15 Sep 2017 15:19:54 -0700")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 15 2017 at  3:19:54 pm BST, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> From: Christoffer Dall <cdall@linaro.org>
>
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
> driven by hardware.  One annoying exception with this is the arch timer,
> which is mapped directly from the kernel without userspace knowing when
> that happens.  Since we already support saving/restoring the timer IRQ
> state while it is mapped, and we rely on the timer code to set the
> physical active state on VCPU entry, we have to preserve this behavior
> and specifically check if the interrupt is for the timer.  Oh well.
>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic-mmio.c | 79 ++++++++++++++++++++++++++++++++++++++-----
>  virt/kvm/arm/vgic/vgic.c      |  7 ++++
>  virt/kvm/arm/vgic/vgic.h      |  1 +
>  3 files changed, 79 insertions(+), 8 deletions(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index f3087f6..3a8c7ae 100644
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
> @@ -140,10 +141,24 @@ static struct kvm_vcpu *vgic_get_mmio_requester_vcpu(void)
>  	return vcpu;
>  }
>  
> +/* Must be called with irq->irq_lock held */
> +static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> +				 bool is_uaccess)
> +{
> +	bool is_timer = irq->get_input_level == kvm_arch_timer_get_input_level;
> +
> +	if (!is_uaccess || is_timer)
> +		irq->pending_latch = true;
> +
> +	if (!is_uaccess)
> +		vgic_irq_set_phys_active(irq, true);
> +}
> +
>  void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
>  			      gpa_t addr, unsigned int len,
>  			      unsigned long val)
>  {
> +	bool is_uaccess = !vgic_get_mmio_requester_vcpu();
>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>  	int i;
>  
> @@ -151,17 +166,47 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>  
>  		spin_lock(&irq->irq_lock);
> -		irq->pending_latch = true;
> -
> +		if (irq->hw)
> +			vgic_hw_irq_spending(vcpu, irq, is_uaccess);
> +		else
> +			irq->pending_latch = true;
>  		vgic_queue_irq_unlock(vcpu->kvm, irq);
>  		vgic_put_irq(vcpu->kvm, irq);
>  	}
>  }
>  
> +/* Must be called with irq->irq_lock held */
> +static void vgic_hw_irq_cpending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> +				 bool is_uaccess)
> +{
> +	bool is_timer = irq->get_input_level == kvm_arch_timer_get_input_level;
> +
> +	if (!is_uaccess || is_timer)
> +		irq->pending_latch = false;;

Extra ;

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
>  
> @@ -169,9 +214,10 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
>  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>  
>  		spin_lock(&irq->irq_lock);
> -
> -		irq->pending_latch = false;
> -
> +		if (irq->hw)
> +			vgic_hw_irq_cpending(vcpu, irq, is_uaccess);
> +		else
> +			irq->pending_latch = false;
>  		spin_unlock(&irq->irq_lock);
>  		vgic_put_irq(vcpu->kvm, irq);
>  	}
> @@ -197,8 +243,21 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
>  	return value;
>  }
>  
> +/* Must be called with irq->irq_lock held */
> +static void vgic_hw_irq_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> +				      bool active, bool is_uaccess)
> +{
> +	bool is_timer = irq->get_input_level == kvm_arch_timer_get_input_level;
> +
> +	if (!is_uaccess || is_timer)
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
>  	struct kvm_vcpu *requester_vcpu = vgic_get_mmio_requester_vcpu();
>  
> @@ -225,8 +284,12 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
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
>  		vgic_queue_irq_unlock(vcpu->kvm, irq);
>  	else
>  		spin_unlock(&irq->irq_lock);
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index af0de3d..0ca2b3d 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -140,6 +140,13 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
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
> index 7bdcda2..498ee05 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -146,6 +146,7 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  			      u32 intid);
>  void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
>  bool vgic_get_phys_line_level(struct vgic_irq *irq);
> +void vgic_irq_set_phys_pending(struct vgic_irq *irq, bool pending);
>  void vgic_irq_set_phys_active(struct vgic_irq *irq, bool active);
>  bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
>  void vgic_kick_vcpus(struct kvm *kvm);

Otherwise:

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead, it just smell funny.
