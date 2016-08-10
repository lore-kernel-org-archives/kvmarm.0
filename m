From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: arm64: vgic-its: Grab kvm->lock when reading
 kvm->devices
Date: Wed, 10 Aug 2016 15:10:51 +0200
Message-ID: <d02583ed-d396-4431-ba91-903d04843fb3@redhat.com>
References: <20160808154543.23463-1-andre.przywara@arm.com>
 <20160810103914.30322-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EE4841145
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2016 09:03:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SLUy0qLUsYEi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2016 09:03:46 -0400 (EDT)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 047E9410EB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2016 09:03:45 -0400 (EDT)
Received: by mail-wm0-f68.google.com with SMTP id o80so9454816wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2016 06:10:55 -0700 (PDT)
In-Reply-To: <20160810103914.30322-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 10/08/2016 12:39, Christoffer Dall wrote:
> Since we are about to synchronize all accesses to kvm->devices using the
> kvm->lock mutex, we should hold this mutex while iterating over the list
> of devices in the ITS code.
> 
> Also move the vgic_register_its_iodev function to where it's called and
> rename it to register_its_iodev to avoid having two almost identially
> named functions.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 64 +++++++++++++++++++++++---------------------
>  1 file changed, 34 insertions(+), 30 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 1cf9f59..4e76877 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1319,32 +1319,6 @@ void vgic_enable_lpis(struct kvm_vcpu *vcpu)
>  		its_sync_lpi_pending_table(vcpu);
>  }
>  
> -static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its)
> -{
> -	struct vgic_io_device *iodev = &its->iodev;
> -	int ret;
> -
> -	if (!its->initialized)
> -		return -EBUSY;
> -
> -	if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base))
> -		return -ENXIO;
> -
> -	iodev->regions = its_registers;
> -	iodev->nr_regions = ARRAY_SIZE(its_registers);
> -	kvm_iodevice_init(&iodev->dev, &kvm_io_gic_ops);
> -
> -	iodev->base_addr = its->vgic_its_base;
> -	iodev->iodev_type = IODEV_ITS;
> -	iodev->its = its;
> -	mutex_lock(&kvm->slots_lock);
> -	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, iodev->base_addr,
> -				      KVM_VGIC_V3_ITS_SIZE, &iodev->dev);
> -	mutex_unlock(&kvm->slots_lock);
> -
> -	return ret;
> -}
> -
>  #define INITIAL_BASER_VALUE						  \
>  	(GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWb)		| \
>  	 GIC_BASER_CACHEABILITY(GITS_BASER, OUTER, SameAsInner)		| \
> @@ -1526,6 +1500,32 @@ int kvm_vgic_register_its_device(void)
>  				       KVM_DEV_TYPE_ARM_VGIC_ITS);
>  }
>  
> +static int register_its_iodev(struct kvm *kvm, struct vgic_its *its)
> +{
> +	struct vgic_io_device *iodev = &its->iodev;
> +	int ret;
> +
> +	if (!its->initialized)
> +		return -EBUSY;
> +
> +	if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base))
> +		return -ENXIO;
> +
> +	iodev->regions = its_registers;
> +	iodev->nr_regions = ARRAY_SIZE(its_registers);
> +	kvm_iodevice_init(&iodev->dev, &kvm_io_gic_ops);
> +
> +	iodev->base_addr = its->vgic_its_base;
> +	iodev->iodev_type = IODEV_ITS;
> +	iodev->its = its;
> +	mutex_lock(&kvm->slots_lock);
> +	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, iodev->base_addr,
> +				      KVM_VGIC_V3_ITS_SIZE, &iodev->dev);
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	return ret;
> +}
> +
>  /*
>   * Registers all ITSes with the kvm_io_bus framework.
>   * To follow the existing VGIC initialization sequence, this has to be
> @@ -1536,19 +1536,23 @@ int vgic_register_its_iodevs(struct kvm *kvm)
>  	struct kvm_device *dev;
>  	int ret = 0;
>  
> +	mutex_lock(&kvm->lock);
>  	list_for_each_entry(dev, &kvm->devices, vm_node) {
>  		if (dev->ops != &kvm_arm_vgic_its_ops)
>  			continue;
>  
> -		ret = vgic_register_its_iodev(kvm, dev->private);
> +		ret = register_its_iodev(kvm, dev->private);
>  		if (ret)
> -			return ret;
> +			goto out;
> +
>  		/*
>  		 * We don't need to care about tearing down previously
> -		 * registered ITSes, as the kvm_io_bus framework removes
> -		 * them for us if the VM gets destroyed.
> +		 * registered ITSes on error, as the kvm_io_bus framework
> +		 * removes them for us if the VM gets destroyed.
>  		 */
>  	}
>  
> +out:
> +	mutex_unlock(&kvm->lock);
>  	return ret;
>  }
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
