From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 18/45] KVM: arm/arm64: vgic-new: Add ACTIVE registers
 handlers
Date: Thu, 31 Mar 2016 11:58:41 +0200
Message-ID: <20160331095841.GX4126@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-19-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F50040F77
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 05:57:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5c4jhvKwkDIu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Mar 2016 05:57:36 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 81D9C40C9D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 05:57:36 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id 127so127941665wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 02:58:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1458871508-17279-19-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 25, 2016 at 02:04:41AM +0000, Andre Przywara wrote:
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic_mmio.c | 81 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 79 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> index 788e186..bfc530c 100644
> --- a/virt/kvm/arm/vgic/vgic_mmio.c
> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> @@ -289,6 +289,83 @@ static int vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static int vgic_mmio_read_active(struct kvm_vcpu *vcpu,
> +				 struct kvm_io_device *this,
> +				 gpa_t addr, int len, void *val)
> +{
> +	struct vgic_io_device *iodev = container_of(this,
> +						    struct vgic_io_device, dev);
> +	u32 intid = (addr - iodev->base_addr) * 8;
> +	u32 value = 0;
> +	int i;
> +
> +	if (iodev->redist_vcpu)
> +		vcpu = iodev->redist_vcpu;
> +
> +	/* Loop over all IRQs affected by this read */
> +	for (i = 0; i < len * 8; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		spin_lock(&irq->irq_lock);
> +		if (irq->active)
> +			value |= (1U << i);
> +		spin_unlock(&irq->irq_lock);

you don't need the spinlock here (for the same reason you didn't grab it
in the last patch, consistency above all on this matter, please).

> +	}
> +
> +	write_mask32(value, addr & 3, len, val);
> +	return 0;
> +}
> +
> +static int vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
> +				   struct kvm_io_device *this,
> +				   gpa_t addr, int len, const void *val)
> +{
> +	struct vgic_io_device *iodev = container_of(this,
> +						    struct vgic_io_device, dev);
> +	u32 intid = (addr - iodev->base_addr) * 8;
> +	int i;
> +
> +	if (iodev->redist_vcpu)
> +		vcpu = iodev->redist_vcpu;
> +
> +	for_each_set_bit(i, val, len * 8) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		spin_lock(&irq->irq_lock);
> +
> +		irq->active = false;
> +		/* TODO: Anything more to do? Does flush/sync cover this? */

so prune will remove this from the AP list if it's no longer
pending/enabled as well.

the question is what to do if the vcpu for this irq is running and the
LR there has the active bit set, then we'll overwrite this change when
we fold the LR state back into the vgic_irq struct.

since I expect this to be extremely rare, one option is to force
irq->vcpu to exit (if non-null) and then do you thing here after you've
confirm it has exited while holding some lock preventing it from
re-entering again.  Slightly crazy.

The alternative is to put a big fat comment nothing that this is
non-supported bad race, and wait until someone submits a bug report
relating to this...

> +
> +		spin_unlock(&irq->irq_lock);
> +	}
> +	return 0;
> +}
> +
> +static int vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
> +				   struct kvm_io_device *this,
> +				   gpa_t addr, int len, const void *val)
> +{
> +	struct vgic_io_device *iodev = container_of(this,
> +						    struct vgic_io_device, dev);
> +	u32 intid = (addr - iodev->base_addr) * 8;
> +	int i;
> +
> +	if (iodev->redist_vcpu)
> +		vcpu = iodev->redist_vcpu;
> +
> +	for_each_set_bit(i, val, len * 8) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		spin_lock(&irq->irq_lock);
> +
> +		irq->active = true;
> +		/* TODO: Anything more to do? Does flush/sync cover this? */

you need to add it to the ap_list of irq->target_vcpu if irq->vcpu is
not already set.

an alternative is to expand the queue function to handle the active
case, but I'm not sure which one is cleaner.  I think we have to try it
to be able to tell, but my gut feeling is that implementing it here is
better, because it's a one-off.

> +
> +		spin_unlock(&irq->irq_lock);
> +	}
> +	return 0;
> +}
> +
>  static int vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
>  				   struct kvm_io_device *this,
>  				   gpa_t addr, int len, void *val)
> @@ -347,9 +424,9 @@ struct vgic_register_region vgic_v2_dist_registers[] = {
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
>  		vgic_mmio_read_pending, vgic_mmio_write_cpending, 1),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
> -		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
> +		vgic_mmio_read_active, vgic_mmio_write_sactive, 1),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
> -		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
> +		vgic_mmio_read_active, vgic_mmio_write_cactive, 1),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
>  		vgic_mmio_read_priority, vgic_mmio_write_priority, 8),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
> -- 
> 2.7.3
> 
