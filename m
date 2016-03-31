From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 19/45] KVM: arm/arm64: vgic-new: Add CONFIG registers
 handlers
Date: Thu, 31 Mar 2016 12:07:27 +0200
Message-ID: <20160331100727.GY4126@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-20-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADEF840F77
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 06:06:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tlFZa3bw5b8T for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Mar 2016 06:06:22 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F3C340C9D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 06:06:22 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id 191so120387652wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 03:07:26 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1458871508-17279-20-git-send-email-andre.przywara@arm.com>
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

On Fri, Mar 25, 2016 at 02:04:42AM +0000, Andre Przywara wrote:
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic_mmio.c | 63 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 62 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> index bfc530c..76657ce 100644
> --- a/virt/kvm/arm/vgic/vgic_mmio.c
> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> @@ -410,6 +410,67 @@ static int vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static int vgic_mmio_read_config(struct kvm_vcpu *vcpu,
> +				 struct kvm_io_device *this,
> +				 gpa_t addr, int len, void *val)
> +{
> +	struct vgic_io_device *iodev = container_of(this,
> +						    struct vgic_io_device, dev);
> +	u32 intid = (addr - iodev->base_addr) * 4;
> +	u32 value = 0;
> +	int i;
> +
> +	if (iodev->redist_vcpu)
> +		vcpu = iodev->redist_vcpu;
> +
> +	for (i = 0; i < len * 4; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		if (irq->config == VGIC_CONFIG_EDGE)
> +			value |= (2U << (i * 2));
> +	}
> +
> +	write_mask32(value, addr & 3, len, val);
> +	return 0;
> +}
> +
> +static int vgic_mmio_write_config(struct kvm_vcpu *vcpu,
> +				  struct kvm_io_device *this,
> +				  gpa_t addr, int len, const void *val)
> +{
> +	struct vgic_io_device *iodev = container_of(this,
> +						    struct vgic_io_device, dev);
> +	u32 intid = (addr - iodev->base_addr) * 4;
> +	int i;
> +
> +	if (iodev->redist_vcpu)
> +		vcpu = iodev->redist_vcpu;
> +
> +	for (i = 0; i < len * 4; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		if (intid + i < 16)
> +			continue;
> +
> +		/*
> +		 * The spec says that interrupts must be disabled before
> +		 * changing the configuration to avoid UNDEFINED behaviour.
> +		 * Is this sufficient in our case? Do we quickly enough remove
> +		 * the IRQ from the ap_list to safely do the config change?

I don't understand the question about 'quickly enough' here.

> +		 * Will even a disabled interrupt in an ap_list cause us
> +		 * headaches if we change the configuration?
> +		 */

I don't think there's any particular problem here, except for my
comments below:

(there may be some super weirdness if a VCPU is running with some bits
of this IRQ in a LR while changing it, but I think we can ignore this
case for now - or we can do like with the active state and force an
exit).

> +		spin_lock(&irq->irq_lock);
> +		if (test_bit(i * 2 + 1, val))
> +			irq->config = VGIC_CONFIG_EDGE;
> +		else
> +			irq->config = VGIC_CONFIG_LEVEL;

I think here you have to sync pending to level | soft_pending, that's a
rule we enforce for level triggered interrupts.

> +		spin_unlock(&irq->irq_lock);
> +	}
> +
> +	return 0;
> +}
> +
>  struct vgic_register_region vgic_v2_dist_registers[] = {
>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
>  		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12),
> @@ -432,7 +493,7 @@ struct vgic_register_region vgic_v2_dist_registers[] = {
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
>  		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 8),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
> -		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 8),
> +		vgic_mmio_read_config, vgic_mmio_write_config, 2),
>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
>  		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 4),
>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR,
> -- 
> 2.7.3
> 
