From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 15/45] KVM: arm/arm64: vgic-new: Add ENABLE registers
 handlers
Date: Thu, 31 Mar 2016 11:33:02 +0200
Message-ID: <20160331093302.GU4126@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-16-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80F0540C9D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 05:31:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5v75YpYelLra for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Mar 2016 05:31:58 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25A9240C9A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 05:31:57 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id 191so119328553wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 02:33:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1458871508-17279-16-git-send-email-andre.przywara@arm.com>
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

On Fri, Mar 25, 2016 at 02:04:38AM +0000, Andre Przywara wrote:
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic_mmio.c | 81 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 79 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> index e62366e..0688a69 100644
> --- a/virt/kvm/arm/vgic/vgic_mmio.c
> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> @@ -129,15 +129,92 @@ static int vgic_mmio_write_v2_misc(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +/*
> + * Read accesses to both GICD_ICENABLER and GICD_ISENABLER return the value
> + * of the enabled bit, so there is only one function for both here.
> + */
> +static int vgic_mmio_read_enable(struct kvm_vcpu *vcpu,
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
> +		if (irq->enabled)
> +			value |= (1U << i);
> +	}
> +
> +	write_mask32(value, addr & 3, len, val);
> +	return 0;
> +}
> +
> +static int vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
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
> +		irq->enabled = true;
> +		vgic_queue_irq(vcpu->kvm, irq);

this makes me feel like we should rename this to vgic_queue_irq_unlock

> +	}
> +
> +	return 0;
> +}
> +
> +static int vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
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
> +		irq->enabled = false;
> +		/* TODO: Does the exit/entry code take care of "unqueuing"? */

yes it does, the sync calls prune_ap_list, which calls the Oracle, which
returns null if the IRQ is no longer enabled, so the prune function
removes the IRQ from the list.

> +
> +		spin_unlock(&irq->irq_lock);
> +	}
> +	return 0;
> +}
> +
>  struct vgic_register_region vgic_v2_dist_registers[] = {
>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
>  		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
>  		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
> -		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
> +		vgic_mmio_read_enable, vgic_mmio_write_senable, 1),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_CLEAR,
> -		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
> +		vgic_mmio_read_enable, vgic_mmio_write_cenable, 1),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
>  		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
> -- 
> 2.7.3
> 
