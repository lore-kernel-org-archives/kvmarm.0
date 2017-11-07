From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 06/26] KVM: arm/arm64: vITS: Add MSI translation
 helpers
Date: Tue, 7 Nov 2017 21:34:11 +0100
Message-ID: <1eaa86dc-145f-509a-e637-5d89debe37e0@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-7-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171027142855.21584-7-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 27/10/2017 16:28, Marc Zyngier wrote:
> The whole MSI injection process is fairly monolithic. An MSI write
> gets turned into an injected LPI in one swift go. But this is actually
> a more fine-grained process:
> 
> - First, a virtual ITS gets selected using the doorbell address
> - Then the DevID/EventID pair gets translated into an LPI
> - Finally the LPI is injected
> 
> Since the GICv4 code needs the first two steps in order to match
> an IRQ routing entry to an LPI, let's expose them as helpers,
> and refactor the existing code to use them
> 
> Reviewed-by: Christoffer Dall <cdall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 93 +++++++++++++++++++++++++-------------------
>  virt/kvm/arm/vgic/vgic.h     |  4 ++
>  2 files changed, 57 insertions(+), 40 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index f51c1e1b3f70..475dffd0a44c 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -503,15 +503,8 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
>  	return 0;
>  }
>  
> -/*
> - * Find the target VCPU and the LPI number for a given devid/eventid pair
> - * and make this IRQ pending, possibly injecting it.
> - * Must be called with the its_lock mutex held.
> - * Returns 0 on success, a positive error value for any ITS mapping
> - * related errors and negative error values for generic errors.
> - */
> -static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
> -				u32 devid, u32 eventid)
> +int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
> +			 u32 devid, u32 eventid, struct vgic_irq **irq)
>  {
>  	struct kvm_vcpu *vcpu;
>  	struct its_ite *ite;
> @@ -530,26 +523,60 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
>  	if (!vcpu->arch.vgic_cpu.lpis_enabled)
>  		return -EBUSY;
>  
> -	spin_lock(&ite->irq->irq_lock);
> -	ite->irq->pending_latch = true;
> -	vgic_queue_irq_unlock(kvm, ite->irq);
> -
> +	*irq = ite->irq;
>  	return 0;
>  }
>  
> -static struct vgic_io_device *vgic_get_its_iodev(struct kvm_io_device *dev)
> +struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi)
>  {
> +	u64 address;
> +	struct kvm_io_device *kvm_io_dev;
>  	struct vgic_io_device *iodev;
>  
> -	if (dev->ops != &kvm_io_gic_ops)
> -		return NULL;
> +	if (!vgic_has_its(kvm))
> +		return ERR_PTR(-ENODEV);
>  
> -	iodev = container_of(dev, struct vgic_io_device, dev);
> +	if (!(msi->flags & KVM_MSI_VALID_DEVID))
> +		return ERR_PTR(-EINVAL);
> +
> +	address = (u64)msi->address_hi << 32 | msi->address_lo;
> +
> +	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, address);
> +	if (!kvm_io_dev)
> +		return ERR_PTR(-EINVAL);
>  
> +	if (kvm_io_dev->ops != &kvm_io_gic_ops)
> +		return ERR_PTR(-EINVAL);
> +
> +	iodev = container_of(kvm_io_dev, struct vgic_io_device, dev);
>  	if (iodev->iodev_type != IODEV_ITS)
> -		return NULL;
> +		return ERR_PTR(-EINVAL);
>  
> -	return iodev;
> +	return iodev->its;
> +}
> +
> +/*
> + * Find the target VCPU and the LPI number for a given devid/eventid pair
> + * and make this IRQ pending, possibly injecting it.
> + * Must be called with the its_lock mutex held.
> + * Returns 0 on success, a positive error value for any ITS mapping
> + * related errors and negative error values for generic errors.
> + */
> +static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
> +				u32 devid, u32 eventid)
> +{
> +	struct vgic_irq *irq = NULL;
> +	int err;
> +
> +	err = vgic_its_resolve_lpi(kvm, its, devid, eventid, &irq);
> +	if (err)
> +		return err;
> +
> +	spin_lock(&irq->irq_lock);
> +	irq->pending_latch = true;
> +	vgic_queue_irq_unlock(kvm, irq);
> +
> +	return 0;
>  }
>  
>  /*
> @@ -560,30 +587,16 @@ static struct vgic_io_device *vgic_get_its_iodev(struct kvm_io_device *dev)
>   */
>  int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
>  {
> -	u64 address;
> -	struct kvm_io_device *kvm_io_dev;
> -	struct vgic_io_device *iodev;
> +	struct vgic_its *its;
>  	int ret;
>  
> -	if (!vgic_has_its(kvm))
> -		return -ENODEV;
> -
> -	if (!(msi->flags & KVM_MSI_VALID_DEVID))
> -		return -EINVAL;
> -
> -	address = (u64)msi->address_hi << 32 | msi->address_lo;
> -
> -	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, address);
> -	if (!kvm_io_dev)
> -		return -EINVAL;
> +	its = vgic_msi_to_its(kvm, msi);
> +	if (IS_ERR(its))
> +		return PTR_ERR(its);
>  
> -	iodev = vgic_get_its_iodev(kvm_io_dev);
> -	if (!iodev)
> -		return -EINVAL;
> -
> -	mutex_lock(&iodev->its->its_lock);
> -	ret = vgic_its_trigger_msi(kvm, iodev->its, msi->devid, msi->data);
> -	mutex_unlock(&iodev->its->its_lock);
> +	mutex_lock(&its->its_lock);
> +	ret = vgic_its_trigger_msi(kvm, its, msi->devid, msi->data);
> +	mutex_unlock(&its->its_lock);
>  
>  	if (ret < 0)
>  		return ret;
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index bf9ceab67c77..31b70326b966 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -236,4 +236,8 @@ static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
> +			 u32 devid, u32 eventid, struct vgic_irq **irq);
> +struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
> +
>  #endif
> 
