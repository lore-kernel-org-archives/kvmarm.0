From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH] KVM: arm64: ITS: move ITS registration into first VCPU run
Date: Thu, 4 Aug 2016 12:11:02 +0200
Message-ID: <8ef91ad8-d597-bcb7-db46-2a7194f79f32@redhat.com>
References: <20160803145745.7556-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5FCE49B1D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2016 06:04:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sbf+L23qza0q for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Aug 2016 06:04:15 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D53540FA6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2016 06:04:14 -0400 (EDT)
In-Reply-To: <20160803145745.7556-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

On 03/08/2016 16:57, Andre Przywara wrote:
> Currently we register ITS devices upon userland issuing the CTRL_INIT
> ioctl to mark initialization of the ITS as done.
> This deviates from the initialization sequence of the existing GIC
> devices and does not play well with the way QEMU handles things.
> To be more in line with what we are used to, register the ITS(es) just
> before the first VCPU is about to run, so in the map_resources() call.
> This involves iterating through the list of KVM devices and handle each
> ITS that we find.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Hi,
> 
> this is based upon next-20160728 plus Christoffer's kvm_device locking
> fix from today. Please let me know what tree I should base upon and I
> will rebase.
> Eric, Christoffer: does that do what you expect? Can QEMU live with that?
> 
> Cheers,
> Andre.
> 
>  virt/kvm/arm/vgic/vgic-its.c | 56 ++++++++++++++++++++++++++++++++++++--------
>  virt/kvm/arm/vgic/vgic-v3.c  |  6 +++++
>  virt/kvm/arm/vgic/vgic.h     |  6 +++++
>  3 files changed, 58 insertions(+), 10 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 07411cf..e677a60 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1288,13 +1288,13 @@ void vgic_enable_lpis(struct kvm_vcpu *vcpu)
>  		its_sync_lpi_pending_table(vcpu);
>  }
>  
> -static int vgic_its_init_its(struct kvm *kvm, struct vgic_its *its)
> +static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its)
>  {
>  	struct vgic_io_device *iodev = &its->iodev;
>  	int ret;
>  
> -	if (its->initialized)
> -		return 0;
> +	if (!its->initialized)
> +		return -EBUSY;
>  
>  	if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base))
>  		return -ENXIO;
> @@ -1311,9 +1311,6 @@ static int vgic_its_init_its(struct kvm *kvm, struct vgic_its *its)
>  				      KVM_VGIC_V3_ITS_SIZE, &iodev->dev);
>  	mutex_unlock(&kvm->slots_lock);
>  
> -	if (!ret)
> -		its->initialized = true;
> -
>  	return ret;
>  }
>  
> @@ -1435,9 +1432,6 @@ static int vgic_its_set_attr(struct kvm_device *dev,
>  		if (type != KVM_VGIC_ITS_ADDR_TYPE)
>  			return -ENODEV;
>  
> -		if (its->initialized)
> -			return -EBUSY;
> -
>  		if (copy_from_user(&addr, uaddr, sizeof(addr)))
>  			return -EFAULT;
>  
> @@ -1453,7 +1447,9 @@ static int vgic_its_set_attr(struct kvm_device *dev,
>  	case KVM_DEV_ARM_VGIC_GRP_CTRL:
>  		switch (attr->attr) {
>  		case KVM_DEV_ARM_VGIC_CTRL_INIT:
> -			return vgic_its_init_its(dev->kvm, its);
> +			its->initialized = true;
> +
> +			return 0;
>  		}
>  		break;
>  	}
> @@ -1498,3 +1494,43 @@ int kvm_vgic_register_its_device(void)
>  	return kvm_register_device_ops(&kvm_arm_vgic_its_ops,
>  				       KVM_DEV_TYPE_ARM_VGIC_ITS);
>  }
> +
> +/*
> + * Registers all ITSes with the kvm_io_bus framework.
> + * To follow the existing VGIC initialization sequence, this has to be
> + * done as late as possible, just before the first VCPU runs.
> + */
> +int vgic_register_its_iodevs(struct kvm *kvm)
> +{
> +	struct kvm_device *dev;
> +	int ret = 0;
> +
> +	mutex_lock(&kvm->devices_lock);
> +
> +	list_for_each_entry(dev, &kvm->devices, vm_node) {
> +		if (dev->ops != &kvm_arm_vgic_its_ops)
> +			continue;
> +
> +		ret = vgic_register_its_iodev(kvm, dev->private);
> +		if (ret)
> +			break;
> +	}
> +
> +	if (ret) {
> +		/* Iterate backwards to roll back previous registrations. */
> +		for (dev = list_prev_entry(dev, vm_node);
> +		     &dev->vm_node != &kvm->devices;
> +		     dev = list_prev_entry(dev, vm_node)) {
> +			struct vgic_its *its = dev->private;
> +
> +			if (dev->ops != &kvm_arm_vgic_its_ops)
> +				continue;
> +
> +			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
> +						  &its->iodev.dev);
> +		}
> +	}
> +
> +	mutex_unlock(&kvm->devices_lock);
> +	return ret;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 0506543..f0d9b2b 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -289,6 +289,12 @@ int vgic_v3_map_resources(struct kvm *kvm)
>  		goto out;
>  	}
>  
don't you need to check vgic_has_its() first

Thanks

Eric
> +	ret = vgic_register_its_iodevs(kvm);
> +	if (ret) {
> +		kvm_err("Unable to register VGIC ITS MMIO regions\n");
> +		goto out;
> +	}
> +
>  	dist->ready = true;
>  
>  out:
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 1d8e21d..6c4625c 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -84,6 +84,7 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu);
>  int vgic_v3_probe(const struct gic_kvm_info *info);
>  int vgic_v3_map_resources(struct kvm *kvm);
>  int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
> +int vgic_register_its_iodevs(struct kvm *kvm);
>  bool vgic_has_its(struct kvm *kvm);
>  int kvm_vgic_register_its_device(void);
>  void vgic_enable_lpis(struct kvm_vcpu *vcpu);
> @@ -140,6 +141,11 @@ static inline int vgic_register_redist_iodevs(struct kvm *kvm,
>  	return -ENODEV;
>  }
>  
> +static inline int vgic_register_its_iodevs(struct kvm *kvm)
> +{
> +	return -ENODEV;
> +}
> +
>  static inline bool vgic_has_its(struct kvm *kvm)
>  {
>  	return false;
> 
