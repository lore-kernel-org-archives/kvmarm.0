From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 09/45] KVM: arm/arm64: vgic-new: Add GICv2 IRQ
 sync/flush
Date: Tue, 12 Apr 2016 14:25:41 +0200
Message-ID: <20160412122541.GC3039@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-10-git-send-email-andre.przywara@arm.com>
 <20160331094715.GA20251@cbox>
 <570B8D11.20404@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570B8D11.20404@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 11, 2016 at 12:40:01PM +0100, Andre Przywara wrote:
> On 31/03/16 10:47, Christoffer Dall wrote:
> > On Fri, Mar 25, 2016 at 02:04:32AM +0000, Andre Przywara wrote:
> >> From: Marc Zyngier <marc.zyngier@arm.com>
> >>
> >> Implement the functionality for syncing IRQs between our emulation
> >> and the list registers, which represent the guest's view of IRQs.
> >> This is done in kvm_vgic_flush_hwstate and kvm_vgic_sync_hwstate,
> >> which gets called on guest entry and exit.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >>  include/kvm/vgic/vgic.h     |   4 +
> >>  virt/kvm/arm/vgic/vgic-v2.c | 161 ++++++++++++++++++++++++++++++++++
> >>  virt/kvm/arm/vgic/vgic.c    | 204 ++++++++++++++++++++++++++++++++++++++++++++
> >>  virt/kvm/arm/vgic/vgic.h    |   4 +
> >>  4 files changed, 373 insertions(+)
> >>
> >> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> >> index f32b284..986f23f 100644
> >> --- a/include/kvm/vgic/vgic.h
> >> +++ b/include/kvm/vgic/vgic.h
> >> @@ -187,6 +187,10 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
> >>  #define vgic_valid_spi(k,i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
> >>  			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
> >>  
> >> +bool kvm_vcpu_has_pending_irqs(struct kvm_vcpu *vcpu);
> >> +void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
> >> +void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
> >> +
> >>  /**
> >>   * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
> >>   *
> >> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> >> index 0bf6f27..1cec423 100644
> >> --- a/virt/kvm/arm/vgic/vgic-v2.c
> >> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> >> @@ -14,11 +14,172 @@
> >>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> >>   */
> >>  
> >> +#include <linux/irqchip/arm-gic.h>
> >>  #include <linux/kvm.h>
> >>  #include <linux/kvm_host.h>
> >>  
> >>  #include "vgic.h"
> >>  
> >> +/*
> >> + * Call this function to convert a u64 value to an unsigned long * bitmask
> >> + * in a way that works on both 32-bit and 64-bit LE and BE platforms.
> >> + *
> >> + * Warning: Calling this function may modify *val.
> >> + */
> >> +static unsigned long *u64_to_bitmask(u64 *val)
> >> +{
> >> +#if defined(CONFIG_CPU_BIG_ENDIAN) && BITS_PER_LONG == 32
> >> +	*val = (*val >> 32) | (*val << 32);
> >> +#endif
> >> +	return (unsigned long *)val;
> >> +}
> >> +
> >> +void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu)
> >> +{
> >> +	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
> >> +
> >> +	if (cpuif->vgic_misr & GICH_MISR_EOI) {
> >> +		u64 eisr = cpuif->vgic_eisr;
> >> +		unsigned long *eisr_bmap = u64_to_bitmask(&eisr);
> >> +		int lr;
> >> +
> >> +		for_each_set_bit(lr, eisr_bmap, vcpu->arch.vgic_cpu.nr_lr) {
> >> +			struct vgic_irq *irq;
> >> +			u32 intid = cpuif->vgic_lr[lr] & GICH_LR_VIRTUALID;
> >> +
> >> +			irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
> >> +
> >> +			WARN_ON(irq->config == VGIC_CONFIG_EDGE);
> >> +			WARN_ON(cpuif->vgic_lr[lr] & GICH_LR_STATE);
> >> +
> >> +			kvm_notify_acked_irq(vcpu->kvm, 0,
> >> +					     intid - VGIC_NR_PRIVATE_IRQS);
> >> +
> >> +			cpuif->vgic_lr[lr] &= ~GICH_LR_STATE; /* Useful?? */
> >> +			cpuif->vgic_elrsr |= 1ULL << lr;
> >> +		}
> >> +	}
> >> +
> >> +	/* check and disable underflow maintenance IRQ */
> >> +	cpuif->vgic_hcr &= ~GICH_HCR_UIE;
> >> +
> >> +	/*
> >> +	 * In the next iterations of the vcpu loop, if we sync the
> >> +	 * vgic state after flushing it, but before entering the guest
> >> +	 * (this happens for pending signals and vmid rollovers), then
> >> +	 * make sure we don't pick up any old maintenance interrupts
> >> +	 * here.
> >> +	 */
> >> +	cpuif->vgic_eisr = 0;
> >> +}
> >> +
> >> +void vgic_v2_set_underflow(struct kvm_vcpu *vcpu)
> >> +{
> >> +	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
> >> +
> >> +	cpuif->vgic_hcr |= GICH_HCR_UIE;
> >> +}
> >> +
> >> +/*
> >> + * transfer the content of the LRs back into the corresponding ap_list:
> >> + * - active bit is transferred as is
> >> + * - pending bit is
> >> + *   - transferred as is in case of edge sensitive IRQs
> >> + *   - set to the line-level (resample time) for level sensitive IRQs
> >> + */
> >> +void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
> >> +{
> >> +	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
> >> +	int lr;
> >> +
> >> +	for (lr = 0; lr < vcpu->arch.vgic_cpu.used_lrs; lr++) {
> >> +		u32 val = cpuif->vgic_lr[lr];
> >> +		u32 intid = val & GICH_LR_VIRTUALID;
> >> +		struct vgic_irq *irq;
> >> +
> >> +		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
> >> +
> >> +		spin_lock(&irq->irq_lock);
> >> +
> >> +		/* Always preserve the active bit */
> >> +		irq->active = !!(val & GICH_LR_ACTIVE_BIT);
> >> +
> >> +		/* Edge is the only case where we preserve the pending bit */
> >> +		if (irq->config == VGIC_CONFIG_EDGE &&
> >> +		    (val & GICH_LR_PENDING_BIT)) {
> >> +			irq->pending = true;
> >> +
> >> +			if (intid < VGIC_NR_SGIS) {
> >> +				u32 cpuid = val & GICH_LR_PHYSID_CPUID;
> >> +
> >> +				cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
> >> +				irq->source |= (1 << cpuid);
> >> +			}
> >> +		}
> >> +
> >> +		/* Clear soft pending state when level IRQs have been acked */
> >> +		if (irq->config == VGIC_CONFIG_LEVEL &&
> >> +		    !(val & GICH_LR_PENDING_BIT)) {
> >> +			irq->soft_pending = false;
> >> +			irq->pending = irq->line_level;
> >> +		}
> >> +
> >> +		spin_unlock(&irq->irq_lock);
> >> +	}
> >> +}
> >> +
> >> +/*
> >> + * Populates the particular LR with the state of a given IRQ:
> >> + * - for an edge sensitive IRQ the pending state is reset in the struct
> >> + * - for a level sensitive IRQ the pending state value is unchanged;
> >> + *   it will be resampled on deactivation
> >> + *
> >> + * If irq is not NULL, the irq_lock must be hold already by the caller.
> >> + * If irq is NULL, the respective LR gets cleared.
> >> + */
> >> +void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
> >> +{
> >> +	u32 val;
> >> +
> >> +	if (!irq) {
> >> +		val = 0;
> >> +		goto out;
> >> +	}
> >> +
> >> +	val = irq->intid;
> >> +
> >> +	if (irq->pending) {
> >> +		val |= GICH_LR_PENDING_BIT;
> >> +
> >> +		if (irq->config == VGIC_CONFIG_EDGE)
> >> +			irq->pending = false;
> >> +
> >> +		if (irq->intid < VGIC_NR_SGIS) {
> >> +			u32 src = ffs(irq->source);
> >> +
> >> +			BUG_ON(!src);
> >> +			val |= (src - 1) << GICH_LR_PHYSID_CPUID_SHIFT;
> >> +			irq->source &= ~(1 << (src - 1));
> >> +			if (irq->source)
> >> +				irq->pending = true;
> >> +		}
> >> +	}
> >> +
> >> +	if (irq->active)
> >> +		val |= GICH_LR_ACTIVE_BIT;
> >> +
> >> +	if (irq->hw) {
> >> +		val |= GICH_LR_HW;
> >> +		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
> >> +	} else {
> >> +		if (irq->config == VGIC_CONFIG_LEVEL)
> >> +			val |= GICH_LR_EOI;
> >> +	}
> > 
> > shouldn't we start writing the priority here (and in the GICv3 version)?
> > 
> > (which has the fun consequence of having to compare priorities against
> > the virtual priority filter in PATCH 11).
> 
> This is probably true.
> 
> I just feel I am getting overwhelmed with the change requests, can one
> of you (Marc, Christoffer) fix this? Just use the existing code base, I
> can rebase any change into the new tree.

Sure, I'll send patches based on your next iteration of this series.
Can you add a TODO: Christoffer to implement this here?

> 
> The priority field in the v2 LR is only 5 bits long, is that covered by
> the virtual priority filter you mentioned?
> 
Not sure what you're asking, but I think we can deal with this once I
send my patches and you review them ;)

-Christoffer
