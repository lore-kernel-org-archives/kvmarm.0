From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 16/45] KVM: arm/arm64: vgic-new: Add PENDING
 registers handlers
Date: Tue, 12 Apr 2016 15:10:48 +0200
Message-ID: <20160412131048.GG3039@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-17-git-send-email-andre.przywara@arm.com>
 <20160331093551.GV4126@cbox>
 <570B8B14.3050007@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570B8B14.3050007@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, j@cbox
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 11, 2016 at 12:31:32PM +0100, Andre Przywara wrote:
> On 31/03/16 10:35, Christoffer Dall wrote:
> > On Fri, Mar 25, 2016 at 02:04:39AM +0000, Andre Przywara wrote:
> >> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >> ---
> >>  virt/kvm/arm/vgic/vgic_mmio.c | 87 ++++++++++++++++++++++++++++++++++++++++++-
> >>  1 file changed, 85 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> >> index 0688a69..8514f92 100644
> >> --- a/virt/kvm/arm/vgic/vgic_mmio.c
> >> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> >> @@ -206,6 +206,89 @@ static int vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
> >>  	return 0;
> >>  }
> >>  
> >> +static int vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
> >> +				  struct kvm_io_device *this,
> >> +				  gpa_t addr, int len, void *val)
> >> +{
> >> +	struct vgic_io_device *iodev = container_of(this,
> >> +						    struct vgic_io_device, dev);
> >> +	u32 intid = (addr - iodev->base_addr) * 8;
> >> +	u32 value = 0;
> >> +	int i;
> >> +
> >> +	if (iodev->redist_vcpu)
> >> +		vcpu = iodev->redist_vcpu;
> >> +
> >> +	/* Loop over all IRQs affected by this read */
> >> +	for (i = 0; i < len * 8; i++) {
> >> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> >> +
> >> +		spin_lock(&irq->irq_lock);
> >> +		if (irq->pending)
> >> +			value |= (1U << i);
> >> +		spin_unlock(&irq->irq_lock);
> > 
> > here there clearly is no need to take the lock (because a bool read is
> > atomic), but that should be explained in a one-line comment.
> 
> Is that really true? Isn't it that another lock holder expects full
> control over the IRQ struct, including the freedom to change values at
> will without caring about other observers?

Consider the following three cases, assuming pending is clear in the
initial state:

Case 1:
	CPU A			CPU B
	-----			-----
	read pending
				lock irq
				set pending
				unlock irq

Case 2:
	CPU A			CPU B
	-----			-----
				lock irq
	read pending
				set pending
				unlock irq


Case 3:
	CPU A			CPU B
	-----			-----
				lock irq
				set pending
				unlock irq
	read pending


The only effect of adding a lock/unlock around the read_pending()
operation is to force case 2 to be equivalent to case 3, but case 1
could still happen, so this just boils down to observing the value
before or after the write, both of which are fine.

If there were weird side effect from reading this value, or even getting
to the struct would depend on other things CPU B could do while holding
the lock, it would be a different story, but here I'm faily certain you
don't need the lock.

> I might be too paranoid here, but I think I explicitly added the lock
> here for a reason (which I don't remember anymore, sadly).
> 

Can you can find an example where something breaks without holding the
lock here?

Thanks,
-Christoffer
