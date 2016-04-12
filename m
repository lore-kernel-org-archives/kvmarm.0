From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 10/45] KVM: arm/arm64: vgic-new: Add GICv3 world
 switch backend
Date: Tue, 12 Apr 2016 17:02:14 +0200
Message-ID: <20160412150214.GL3039@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-11-git-send-email-andre.przywara@arm.com>
 <20160330204012.GN4126@cbox>
 <570CFF28.1080808@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570CFF28.1080808@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 12, 2016 at 02:59:04PM +0100, Andre Przywara wrote:
> Hi,
> 
> On 30/03/16 21:40, Christoffer Dall wrote:
> > On Fri, Mar 25, 2016 at 02:04:33AM +0000, Andre Przywara wrote:
> >> From: Marc Zyngier <marc.zyngier@arm.com>
> >>
> >> As the GICv3 virtual interface registers differ from their GICv2
> >> siblings, we need different handlers for processing maintenance
> >> interrupts and reading/writing to the LRs.
> >> Also as we store an IRQ's affinity directly as a MPIDR, we need a
> >> separate change_affinity() implementation too.
> > 
> > not sure why we embed the vgic_v3_irq_change_affinity in this patch here
> > and had a stand-alone patch for v2?
> > 
> > I think it would be better to split them up and again have one patch to
> > introduce the infrastructure for some piece of functionality, followed
> > by 2 patches, one plugging in the v2 part, the other plugging in the v3
> > part.
> 
> Agreed. I now have:
> 
> KVM: arm/arm64: vgic-new: Add IRQ sorting
> KVM: arm/arm64: vgic-new: Add IRQ sync/flush framework
> KVM: arm/arm64: vgic-new: Add GICv2 world switch backend
> KVM: arm/arm64: vgic-new: Add GICv3 world switch backend
> KVM: arm/arm64: vgic-new: Implement kvm_vgic_vcpu_pending_irq
> 
> The second patch contains the common code and some empty stub functions,
> that the following two patches fill with calls to their respective
> implementations. I found this nicer than the other way around.
> Still not sure whether IRQ sorting or kvm_vgic_vcpu_pending_irq really
> deserve a separate patch, but it makes it easier to review, I guess.
> 
> >> Implement the respective handler functions and connect them to
> >> existing code to be called if the host is using a GICv3.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >>  virt/kvm/arm/vgic/vgic-v3.c | 191 ++++++++++++++++++++++++++++++++++++++++++++
> >>  virt/kvm/arm/vgic/vgic.c    |   8 +-
> >>  virt/kvm/arm/vgic/vgic.h    |  30 +++++++
> >>  3 files changed, 225 insertions(+), 4 deletions(-)
> >>  create mode 100644 virt/kvm/arm/vgic/vgic-v3.c
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> >> new file mode 100644
> >> index 0000000..71b4bad
> >> --- /dev/null
> >> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> >> @@ -0,0 +1,191 @@
> >> +/*
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + *
> >> + * You should have received a copy of the GNU General Public License
> >> + * along with this program. If not, see <http://www.gnu.org/licenses/>.
> >> + */
> >> +
> >> +#include <linux/irqchip/arm-gic-v3.h>
> >> +#include <linux/kvm.h>
> >> +#include <linux/kvm_host.h>
> >> +#include <linux/irqchip/arm-gic.h>
> >> +
> >> +#include "vgic.h"
> >> +
> >> +void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
> >> +{
> >> +	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
> >> +	u32 model = vcpu->kvm->arch.vgic.vgic_model;
> >> +
> >> +	if (cpuif->vgic_misr & ICH_MISR_EOI) {
> >> +		unsigned long eisr_bmap = cpuif->vgic_eisr;
> >> +		int lr;
> >> +
> >> +		for_each_set_bit(lr, &eisr_bmap, vcpu->arch.vgic_cpu.nr_lr) {
> >> +			u32 intid;
> >> +			u64 val = cpuif->vgic_lr[lr];
> >> +
> >> +			if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
> >> +				intid = val & ICH_LR_VIRTUAL_ID_MASK;
> >> +			else
> >> +				intid = val & GICH_LR_VIRTUALID;
> >> +
> >> +			/*
> >> +			 * kvm_notify_acked_irq calls kvm_set_irq()
> >> +			 * to reset the IRQ level, which grabs the dist->lock
> >> +			 * so we call this before taking the dist->lock.
> >> +			 */
> > 
> > this comment clearly doesn't apply anymore.
> > 
> > also, looking at the similarities here with the v2 code, we should
> > probably have another look at sharing some more code between v2 and v3.
> 
> Admittedly the code _looks_ similar, but in fact it isn't.
> The variable names are mostly the same, but many types (both the members
> of struct vgic_v3_cpu_if and the actual LR register itself, for
> instance) are different. Also the EISR bitmap is handled slightly
> differently.
> So merging this looks like it will become messy.
> 
> > 
> >> +			kvm_notify_acked_irq(vcpu->kvm, 0,
> >> +					     intid - VGIC_NR_PRIVATE_IRQS);
> >> +
> >> +			cpuif->vgic_lr[lr] &= ~ICH_LR_STATE; /* Useful?? */
> > 
> > here you don't have the WARN that you had in v2, so does this mean we
> > can actually come here with the LR state field having some value?
> 
> I don't have a real clue here, I guess the semantics are the same and
> the missing WARN_ON is just an implementation detail.
> 

I think the two implementations should be similar in that sense.
Differences like this in sych symmetric code tend to be confusing later
on.

> >> +			cpuif->vgic_elrsr |= 1ULL << lr;
> >> +		}
> >> +
> >> +		/*
> >> +		 * In the next iterations of the vcpu loop, if we sync
> >> +		 * the vgic state after flushing it, but before
> >> +		 * entering the guest (this happens for pending
> >> +		 * signals and vmid rollovers), then make sure we
> >> +		 * don't pick up any old maintenance interrupts here.
> >> +		 */
> >> +		cpuif->vgic_eisr = 0;
> >> +	}
> >> +
> >> +	cpuif->vgic_hcr &= ~ICH_HCR_UIE;
> > 
> > like in the v2 case, I think this should be moved out of the process
> > maintenance function.
> 
> I am not sure about this one (since this function deals with exactly
> this maintenance interrupt), but moved it anyway.
> 

ah, I was thinking of this function as dealing with EOI interrupts only,
but you're right.  The confusing part though is that this bit is cleared
regardless of whether or not there was a maintenance interrupt.

So, it's up to you.


> >> +}
> >> +
> >> +void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
> >> +{
> >> +	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
> >> +
> >> +	cpuif->vgic_hcr |= ICH_HCR_UIE;
> >> +}
> >> +
> >> +void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> >> +{
> >> +	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
> >> +	u32 model = vcpu->kvm->arch.vgic.vgic_model;
> >> +	int lr;
> >> +
> >> +	/* Assumes ap_list_lock held */
> >> +
> >> +	for (lr = 0; lr < vcpu->arch.vgic_cpu.used_lrs; lr++) {
> >> +		u64 val = cpuif->vgic_lr[lr];
> >> +		u32 intid;
> >> +		struct vgic_irq *irq;
> >> +
> >> +		if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
> >> +			intid = val & ICH_LR_VIRTUAL_ID_MASK;
> >> +		else
> >> +			intid = val & GICH_LR_VIRTUALID;
> >> +		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
> >> +
> >> +		spin_lock(&irq->irq_lock);
> >> +
> >> +		/* Always preserve the active bit */
> >> +		irq->active = !!(val & ICH_LR_ACTIVE_BIT);
> >> +
> >> +		/* Edge is the only case where we preserve the pending bit */
> >> +		if (irq->config == VGIC_CONFIG_EDGE &&
> >> +		    (val & ICH_LR_PENDING_BIT)) {
> >> +			irq->pending = true;
> >> +
> >> +			if (intid < VGIC_NR_SGIS &&
> >> +			    model == KVM_DEV_TYPE_ARM_VGIC_V2) {
> >> +				u32 cpuid = val & GICH_LR_PHYSID_CPUID;
> >> +
> >> +				cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
> >> +				irq->source |= (1 << cpuid);
> >> +			}
> >> +		}
> >> +
> >> +		/* Clear soft pending state when level irqs have been acked */
> >> +		if (irq->config == VGIC_CONFIG_LEVEL &&
> >> +		    !(val & ICH_LR_PENDING_BIT)) {
> >> +			irq->soft_pending = false;
> >> +			irq->pending = irq->line_level;
> >> +		}
> >> +
> >> +		spin_unlock(&irq->irq_lock);
> >> +	}
> >> +}
> >> +
> >> +/* Requires the irq to be locked already */
> >> +void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
> >> +{
> >> +	u32 model = vcpu->kvm->arch.vgic.vgic_model;
> >> +	u64 val;
> >> +
> >> +	if (!irq) {
> >> +		val = 0;
> >> +		goto out;
> >> +	}
> >> +
> >> +	val = irq->intid;
> >> +
> >> +	if (irq->pending) {
> >> +		val |= ICH_LR_PENDING_BIT;
> >> +
> >> +		if (irq->config == VGIC_CONFIG_EDGE)
> >> +			irq->pending = false;
> >> +
> >> +		if (irq->intid < VGIC_NR_SGIS &&
> >> +		    model == KVM_DEV_TYPE_ARM_VGIC_V2) {
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
> >> +		val |= ICH_LR_ACTIVE_BIT;
> >> +
> >> +	if (irq->hw) {
> >> +		val |= ICH_LR_HW;
> >> +		val |= ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
> >> +	} else {
> >> +		if (irq->config == VGIC_CONFIG_LEVEL)
> >> +			val |= ICH_LR_EOI;
> >> +	}
> > 
> > indeed this code looks very much like the v2 code, so maybe Marc had a
> > point when he argued for this being more shared between v2 and v3.  Is
> > there a nice way to do that without an intermediate LR representation?
> 
> The same arguments as above for the process_maintenance() function:
> The types and bit offsets are all different. In the end the actual LR
> definition is quite different between v2 and v3, so IMHO separate
> functions are justified.
> The similarity is the v2 multi-source SGI handling, which could be moved
> into a separate function, maybe.
> 
> Anyway we should aim at streamlining both versions, though, for having
> the same functionality and checks in both.
> 
> So for the next version I will keep both process_maintenance() and
> populate_lr() separate. Feel free to insist on a merge or even come up
> with patches afterwards ;-)
> 

That's fine.  You're probably a better judge of this having fiddled
around with the code so much.  If it feels cleaner to you to keep them
separate for now, let's do that, and we can play with a cleanup later if
we feel like it.

> > 
> >> +
> >> +	/*
> >> +	 * Currently all guest IRQs are Group1, as Group0 would result
> >> +	 * in a FIQ in the guest, which it wouldn't expect.
> >> +	 * Eventually we want to make this configurable, so we may
> >> +	 * revisit this in the future.
> > 
> > I know we have something similar in the current code, but I actually
> > don't understand this.  If the IRQ is programmed to be group0, then the
> > guest *would* expect an FIQ, or?
> > 
> > Why is this not a matter of reading which group this IRQ is configured
> > to be?
> 
> Because we don't implement IGROUPR setting atm, neither for the old nor
> the new VGIC. If I now start thinking about CTLR.DS and its
> implications, my brain will overrun, I am afraid.
> So I'd love to move an addition of this feature to a later point in time.
> 

That's fine, but can we tweak the comment then, because I still don't
understand the bit about what the guest expects vs. IRQs and FIQs.

If the guest programs an interrupt to Group0, wouldn't it expect to see
an FIQ, but even in this case we inject it as IRQs?  Maybe there's some
complexity here that I don't see.

I would phrase it something like:

/*
 * We don't support grouping yet and therefore hard code all interrupts
 * to be Group1 interrupts and signal IRQs (not FIQs) to the guest.
 */

But as I said, maybe I'm not getting it.

-Christoffer
