From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 26/55] KVM: arm/arm64: vgic-new: Add ACTIVE registers
 handlers
Date: Tue, 10 May 2016 15:12:59 +0200
Message-ID: <20160510131259.GA20499@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-27-git-send-email-andre.przywara@arm.com>
 <5731D0B5.9060605@arm.com>
 <5731DC60.40809@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5731DC60.40809@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 10, 2016 at 02:04:32PM +0100, Andre Przywara wrote:
> Hi Marc,
> 
> On 10/05/16 13:14, Marc Zyngier wrote:
> > On 06/05/16 11:45, Andre Przywara wrote:
> >> The active register handlers are shared between the v2 and v3
> >> emulation, so their implementation goes into vgic-mmio.c, to be
> >> easily referenced from the v3 emulation as well later.
> >> Since activation/deactivation of an interrupt may happen entirely
> >> in the guest without it ever exiting, we need some extra logic to
> >> properly track the active state.
> >> Putting it on an ap_list on activation is similar to the normal case
> >> handled by vgic_queue_irq_unlock(), but differs in some details that
> >> make a separate implementation worthwhile.
> >>
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >> Changelog RFC..v1:
> >> - handling queueing in write handler
> >> - remove IRQ lock from read handler
> >>
> >> Changelog v1 .. v2:
> >> - adapt to new MMIO framework
> >>
> >>  virt/kvm/arm/vgic/vgic-mmio-v2.c |   4 +-
> >>  virt/kvm/arm/vgic/vgic-mmio.c    | 120 +++++++++++++++++++++++++++++++++++++++
> >>  virt/kvm/arm/vgic/vgic-mmio.h    |  10 ++++
> >>  3 files changed, 132 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >> index 4b87e0a..054b52d 100644
> >> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >> @@ -80,9 +80,9 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
> >>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
> >>  		vgic_mmio_read_pending, vgic_mmio_write_cpending, 1),
> >>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
> >> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
> >> +		vgic_mmio_read_active, vgic_mmio_write_sactive, 1),
> >>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
> >> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
> >> +		vgic_mmio_read_active, vgic_mmio_write_cactive, 1),
> >>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
> >>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
> >>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
> >> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> >> index 4df1af7..dbf683e 100644
> >> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> >> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> >> @@ -162,6 +162,126 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
> >>  	}
> >>  }
> >>  
> >> +unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
> >> +				    gpa_t addr, unsigned int len)
> >> +{
> >> +	u32 intid = (addr & 0x7f) * 8;
> >> +	u32 value = 0;
> >> +	int i;
> >> +
> >> +	/* Loop over all IRQs affected by this read */
> >> +	for (i = 0; i < len * 8; i++) {
> >> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> >> +
> >> +		if (irq->active)
> >> +			value |= (1U << i);
> >> +	}
> >> +
> >> +	return extract_bytes(value, addr & 3, len);
> >> +}
> >> +
> >> +void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
> >> +			     gpa_t addr, unsigned int len,
> >> +			     unsigned long val)
> >> +{
> >> +	u32 intid = (addr & 0x7f) * 8;
> >> +	int i;
> >> +
> >> +	for_each_set_bit(i, &val, len * 8) {
> >> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> >> +
> >> +		spin_lock(&irq->irq_lock);
> >> +
> >> +		irq->active = false;
> >> +
> >> +		/*
> >> +		 * Christoffer wrote:
> >> +		 * The question is what to do if the vcpu for this irq is
> >> +		 * running and the LR there has the active bit set, then we'll
> >> +		 * overwrite this change when we fold the LR state back into
> >> +		 * the vgic_irq struct.
> >> +		 *
> >> +		 * Since I expect this to be extremely rare, one option is to
> >> +		 * force irq->vcpu to exit (if non-null) and then do you
> >> +		 * thing here after you've confirm it has exited while holding
> >> +		 * some lock preventing it from re-entering again.
> >> +		 * Slightly crazy.
> >> +		 *
> >> +		 * The alternative is to put a big fat comment nothing that
> >> +		 * this is non-supported bad race, and wait until someone
> >> +		 * submits a bug report relating to this...
> >> +		 */
> > 
> > Don't we have a patch by Christoffer that addresses this exact issue?
> 
> Yes, and if I am not mistaken you said last week that we put this patch
> and the firmware-independent probing on top of the queue, so I didn't
> merge it.
> 
> >> +
> >> +		spin_unlock(&irq->irq_lock);
> >> +	}
> >> +}
> >> +
> >> +void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
> >> +			     gpa_t addr, unsigned int len,
> >> +			     unsigned long val)
> >> +{
> >> +	u32 intid = (addr & 0x7f) * 8;
> >> +	int i;
> >> +
> >> +	for_each_set_bit(i, &val, len * 8) {
> >> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> >> +
> >> +		spin_lock(&irq->irq_lock);
> >> +
> >> +		/* As this is a special case, we can't use the
> >> +		 * vgic_queue_irq_unlock() function to put this on a VCPU.
> >> +		 * So deal with this here explicitly unless the IRQs was
> >> +		 * already active, it was on a VCPU before or there is no
> >> +		 * target VCPU assigned at the moment.
> >> +		 */
> >> +		if (irq->active || irq->vcpu || !irq->target_vcpu) {
> >> +			irq->active = true;
> >> +
> >> +			spin_unlock(&irq->irq_lock);
> >> +			continue;
> >> +		}
> >> +
> >> +		spin_unlock(&irq->irq_lock);
> >> +retry:
> >> +		vcpu = irq->target_vcpu;
> >> +
> >> +		spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
> >> +		spin_lock(&irq->irq_lock);
> >> +
> >> +		/*
> >> +		 * Recheck after dropping the IRQ lock to see if we should
> >> +		 * still care about queueing it.
> >> +		 */
> >> +		if (irq->active || irq->vcpu) {
> >> +			irq->active = true;
> >> +
> >> +			spin_unlock(&irq->irq_lock);
> >> +			spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
> >> +
> >> +			continue;
> >> +		}
> >> +
> >> +		/* Did the target VCPU change while we had the lock dropped? */
> >> +		if (vcpu != irq->target_vcpu) {
> >> +			spin_unlock(&irq->irq_lock);
> >> +			spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
> >> +
> >> +			goto retry;
> >> +		}
> >> +
> >> +		/* Now queue the IRQ to the VCPU's ap_list. */
> >> +		list_add_tail(&irq->ap_list, &vcpu->arch.vgic_cpu.ap_list_head);
> >> +		irq->vcpu = vcpu;
> >> +
> >> +		irq->active = true;
> >> +
> >> +		spin_unlock(&irq->irq_lock);
> >> +		spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
> >> +
> >> +		kvm_vcpu_kick(vcpu);
> >> +	}
> > 
> > This is annoyingly close to vgic_queue_irq_unlock()... Maybe switching
> > this to some form of preprocessor template. Or not.
> 
> I think we had this discussion with Christoffer before. There are subtle
> differences and the impression was that unifying the two would make them
> basically unreadable because of all this special handling.
> Not sure if the preprocessor would help here.
> 
If we changed the queue function slightly as I suggested, I haven't been
able to come up with a case were we can't do:

spin_lock(&irq->irq_lock);
vgic_queue_irq_unlock(irq);

but I need to look at it more carefully.

-Christoffer
