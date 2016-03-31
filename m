From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 17/45] KVM: arm/arm64: vgic-new: Add PRIORITY
 registers handlers
Date: Thu, 31 Mar 2016 11:50:22 +0200
Message-ID: <20160331095022.GW4126@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-18-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458871508-17279-18-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 25, 2016 at 02:04:40AM +0000, Andre Przywara wrote:
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic_mmio.c | 46 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> index 8514f92..788e186 100644
> --- a/virt/kvm/arm/vgic/vgic_mmio.c
> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> @@ -289,6 +289,50 @@ static int vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static int vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
> +				   struct kvm_io_device *this,
> +				   gpa_t addr, int len, void *val)
> +{
> +	struct vgic_io_device *iodev = container_of(this,
> +						    struct vgic_io_device, dev);
> +	u32 intid = (addr - iodev->base_addr);
> +	int i;
> +
> +	if (iodev->redist_vcpu)
> +		vcpu = iodev->redist_vcpu;
> +
> +	for (i = 0; i < len; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		((u8 *)val)[i] = irq->priority;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
> +				    struct kvm_io_device *this,
> +				    gpa_t addr, int len, const void *val)
> +{
> +	struct vgic_io_device *iodev = container_of(this,
> +						    struct vgic_io_device, dev);
> +	u32 intid = (addr - iodev->base_addr);
> +	int i;
> +
> +	if (iodev->redist_vcpu)
> +		vcpu = iodev->redist_vcpu;
> +
> +	for (i = 0; i < len; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		spin_lock(&irq->irq_lock);
> +		irq->priority = ((u8 *)val)[i];
> +		spin_unlock(&irq->irq_lock);

if we add the priority check in PATCH 11 you have to kick the vcpu here
irq->vcpu is set.  (and possibly even without a change to PATCH 11 in
case the VCPU is running with a bund of now lower-priority interrupts in
the LRs).

> +	}
> +
> +	return 0;
> +}
> +
>  struct vgic_register_region vgic_v2_dist_registers[] = {
>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
>  		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12),
> @@ -307,7 +351,7 @@ struct vgic_register_region vgic_v2_dist_registers[] = {
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
>  		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
> -		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 8),
> +		vgic_mmio_read_priority, vgic_mmio_write_priority, 8),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
>  		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 8),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
> -- 
> 2.7.3
> 
