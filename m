From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 27/56] KVM: arm/arm64: vgic-new: Add ACTIVE registers
 handlers
Date: Wed, 18 May 2016 15:01:39 +0200
Message-ID: <20160518130139.GG3827@cbox>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-28-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1463392481-26583-28-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 16, 2016 at 10:53:15AM +0100, Andre Przywara wrote:
> The active register handlers are shared between the v2 and v3
> emulation, so their implementation goes into vgic-mmio.c, to be
> easily referenced from the v3 emulation as well later.
> Since activation/deactivation of an interrupt may happen entirely
> in the guest without it ever exiting, we need some extra logic to
> properly track the active state.

-- cut --

> Putting it on an ap_list on activation is similar to the normal case
> handled by vgic_queue_irq_unlock(), but differs in some details that
> make a separate implementation worthwhile.

-- cut --

this bit is no longer correct.


> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog RFC..v1:
> - handling queueing in write handler
> - remove IRQ lock from read handler
> 
> Changelog v1 .. v2:
> - adapt to new MMIO framework
> 
> Changelog v3 .. v4:
> - specify accessor width
> - use IRQ number accessor macro
> - drop elaborate write_sactive handler and use new vgic_queue_irq_unlock()
> - properly emulate clear active by halting the guest (Christoffer)
> - replace extract_bytes() with simple return
> 
>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  4 +-
>  virt/kvm/arm/vgic/vgic-mmio.c    | 82 ++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.h    | 10 +++++
>  3 files changed, 94 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index c13a708..12e101b 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -84,10 +84,10 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
>  		vgic_mmio_read_pending, vgic_mmio_write_cpending, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
> +		vgic_mmio_read_active, vgic_mmio_write_sactive, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
> +		vgic_mmio_read_active, vgic_mmio_write_cactive, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index d8dc8f6..74d140e 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -155,6 +155,88 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
> +				    gpa_t addr, unsigned int len)
> +{
> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> +	u32 value = 0;
> +	int i;
> +
> +	/* Loop over all IRQs affected by this read */
> +	for (i = 0; i < len * 8; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		if (irq->active)
> +			value |= (1U << i);
> +	}
> +
> +	return value;
> +}
> +
> +void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
> +			     gpa_t addr, unsigned int len,
> +			     unsigned long val)
> +{
> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> +	int i;
> +
> +	kvm_arm_halt_guest(vcpu->kvm);
> +	for_each_set_bit(i, &val, len * 8) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		spin_lock(&irq->irq_lock);
> +		/*
> +		 * If this virtual IRQ was written into a list register, we
> +		 * have to make sure the CPU that runs the VCPU thread has
> +		 * synced back LR state to the struct vgic_irq.  We can only
> +		 * know this for sure, when either this irq is not assigned to
> +		 * anyone's AP list anymore, or the VCPU thread is not
> +		 * running on any CPUs.
> +		 *
> +		 * In the opposite case, we know the VCPU thread may be on its
> +		 * way back from the guest and still has to sync back this
> +		 * IRQ, so we release and re-acquire the spin_lock to let the
> +		 * other thread sync back the IRQ.
> +		 */
> +		while (irq->vcpu && /* IRQ may have state in an LR somewhere */
> +		       irq->vcpu->cpu != -1) /* VCPU thread is running */
> +			cond_resched_lock(&irq->irq_lock);
> +
> +		irq->active = false;
> +		spin_unlock(&irq->irq_lock);
> +	}
> +	kvm_arm_resume_guest(vcpu->kvm);
> +}
> +
> +void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
> +			     gpa_t addr, unsigned int len,
> +			     unsigned long val)
> +{
> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> +	int i;
> +
> +	for_each_set_bit(i, &val, len * 8) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		spin_lock(&irq->irq_lock);
> +
> +		/*
> +		 * If the IRQ was already active or it was on a VCPU before
> +		 * or there is no target VCPU assigned at the moment, then
> +		 * just proceed.
> +		 */
> +		if (irq->active || irq->vcpu || !irq->target_vcpu) {

why is it that we don't care if this IRQ is on a LR, for example being
just pending and not active, and we thereby loose this active state when
the vcpu syncs back the state?

We care for the case where we clear the active state, but not when we
set it.  Perhaps we discussed this in the past, but now I've forgotten,
so that should at least be documented somehow.

> +			irq->active = true;
> +
> +			spin_unlock(&irq->irq_lock);
> +			continue;
> +		}
> +
> +		irq->active = true;
> +		vgic_queue_irq_unlock(vcpu->kvm, irq);

this won't work just yet, but I think all that's needed to make it work
is this patchlet:

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index c22f7e2..27204f22 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -81,7 +81,7 @@ static struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
 
 	/* If the interrupt is active, it must stay on the current vcpu */
 	if (irq->active)
-		return irq->vcpu;
+		return irq->vcpu ? : irq->target_vcpu;
 
 	/*
 	 * If the IRQ is not active but enabled and pending, we should direct


Thanks,
-Christoffer
