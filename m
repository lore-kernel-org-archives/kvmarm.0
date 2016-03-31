From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 22/45] KVM: arm/arm64: vgic-new: Add SGIPENDR
 register handlers
Date: Thu, 31 Mar 2016 13:37:58 +0200
Message-ID: <20160331113758.GB4126@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-23-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458871508-17279-23-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 25, 2016 at 02:04:45AM +0000, Andre Przywara wrote:
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 
> ---
>  virt/kvm/arm/vgic/vgic_mmio.c | 79 ++++++++++++++++++++++++++++++++-----------
>  1 file changed, 59 insertions(+), 20 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> index a49726f..2ab8961 100644
> --- a/virt/kvm/arm/vgic/vgic_mmio.c
> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> @@ -64,24 +64,6 @@ int vgic_mmio_write_wi(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
>  	return 0;
>  }
>  
> -static int vgic_mmio_read_nyi(struct kvm_vcpu *vcpu,
> -			      struct kvm_io_device *this,
> -			      gpa_t addr, int len, void *val)
> -{
> -	pr_warn("KVM: handling unimplemented VGIC MMIO read: VCPU %d, address: 0x%llx\n",
> -		vcpu->vcpu_id, (unsigned long long)addr);
> -	return 0;
> -}
> -
> -static int vgic_mmio_write_nyi(struct kvm_vcpu *vcpu,
> -			       struct kvm_io_device *this,
> -			       gpa_t addr, int len, const void *val)
> -{
> -	pr_warn("KVM: handling unimplemented VGIC MMIO write: VCPU %d, address: 0x%llx\n",
> -		vcpu->vcpu_id, (unsigned long long)addr);
> -	return 0;
> -}
> -
>  static int vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
>  				  struct kvm_io_device *this,
>  				  gpa_t addr, int len, void *val)
> @@ -556,6 +538,63 @@ static int vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
>  	return 0;
>  }
>  
> +static int vgic_mmio_read_sgipend(struct kvm_vcpu *vcpu,
> +				  struct kvm_io_device *this,
> +				  gpa_t addr, int len, void *val)
> +{
> +	struct vgic_io_device *iodev = container_of(this,
> +						    struct vgic_io_device, dev);
> +	u32 intid = (addr - iodev->base_addr);
> +	int i;
> +
> +	for (i = 0; i < len; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		spin_lock(&irq->irq_lock);
> +		((u8 *)val)[i] = irq->source;
> +		spin_unlock(&irq->irq_lock);

you don't need the spinlock here

> +	}
> +	return 0;
> +}
> +
> +static int vgic_mmio_write_sgipendc(struct kvm_vcpu *vcpu,
> +				    struct kvm_io_device *this,
> +				    gpa_t addr, int len, const void *val)
> +{
> +	struct vgic_io_device *iodev = container_of(this,
> +						    struct vgic_io_device, dev);
> +	u32 intid = (addr - iodev->base_addr);
> +	int i;
> +
> +	for (i = 0; i < len; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		spin_lock(&irq->irq_lock);
> +		irq->source &= ~((u8 *)val)[i];

don't you also need to check if source == 0 and lower pending in this
case?

> +		spin_unlock(&irq->irq_lock);
> +	}
> +	return 0;
> +}
> +
> +static int vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
> +				    struct kvm_io_device *this,
> +				    gpa_t addr, int len, const void *val)
> +{
> +	struct vgic_io_device *iodev = container_of(this,
> +						    struct vgic_io_device, dev);
> +	u32 intid = (addr - iodev->base_addr);
> +	int i;
> +
> +	for (i = 0; i < len; i++) {
> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> +
> +		spin_lock(&irq->irq_lock);
> +		irq->source |= ((u8 *)val)[i];

don't you need to set pending and queue in this case?

> +		spin_unlock(&irq->irq_lock);
> +	}
> +	return 0;
> +}
> +
>  struct vgic_register_region vgic_v2_dist_registers[] = {
>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
>  		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12),
> @@ -582,9 +621,9 @@ struct vgic_register_region vgic_v2_dist_registers[] = {
>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
>  		vgic_mmio_read_raz, vgic_mmio_write_sgir, 4),
>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR,
> -		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 16),
> +		vgic_mmio_read_sgipend, vgic_mmio_write_sgipendc, 16),
>  	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_SET,
> -		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 16),
> +		vgic_mmio_read_sgipend, vgic_mmio_write_sgipends, 16),
>  };
>  
>  /*
> -- 
> 2.7.3
> 
