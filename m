From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v2 09/11] KVM: arm/arm64: Register ITS iodev when setting
 base address
Date: Tue, 9 May 2017 11:53:17 +0200
Message-ID: <de932538-854f-eb94-49e5-9d94e3e1cb84@redhat.com>
References: <20170509085618.28311-1-cdall@linaro.org>
 <20170509085618.28311-10-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170509085618.28311-10-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 09/05/2017 10:56, Christoffer Dall wrote:
> We have to register the ITS iodevice before running the VM, because in
> migration scenarios, we may be restoring a live device that wishes to
> inject MSIs before the VCPUs have started.
> 
> All we need to register the ITS io device is the base address of the
> ITS, so we can simply register that when the base address of the ITS is
> set.
> 
>   [ Code to fix concurrency issues when setting the ITS base address and
>     to fix the undef base address check written by Marc Zyngier ]
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

thanks

Eric
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 44 ++++++++++----------------------------------
>  virt/kvm/arm/vgic/vgic-v3.c  |  8 --------
>  virt/kvm/arm/vgic/vgic.h     |  1 -
>  3 files changed, 10 insertions(+), 43 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 18318c6..89acaef 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1540,14 +1540,19 @@ void vgic_enable_lpis(struct kvm_vcpu *vcpu)
>  		its_sync_lpi_pending_table(vcpu);
>  }
>  
> -static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its)
> +static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its,
> +				   u64 addr)
>  {
>  	struct vgic_io_device *iodev = &its->iodev;
>  	int ret;
>  
> -	if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base))
> -		return -ENXIO;
> +	mutex_lock(&kvm->slots_lock);
> +	if (!IS_VGIC_ADDR_UNDEF(its->vgic_its_base)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
>  
> +	its->vgic_its_base = addr;
>  	iodev->regions = its_registers;
>  	iodev->nr_regions = ARRAY_SIZE(its_registers);
>  	kvm_iodevice_init(&iodev->dev, &kvm_io_gic_ops);
> @@ -1555,9 +1560,9 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its)
>  	iodev->base_addr = its->vgic_its_base;
>  	iodev->iodev_type = IODEV_ITS;
>  	iodev->its = its;
> -	mutex_lock(&kvm->slots_lock);
>  	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, iodev->base_addr,
>  				      KVM_VGIC_V3_ITS_SIZE, &iodev->dev);
> +out:
>  	mutex_unlock(&kvm->slots_lock);
>  
>  	return ret;
> @@ -2384,9 +2389,7 @@ static int vgic_its_set_attr(struct kvm_device *dev,
>  		if (ret)
>  			return ret;
>  
> -		its->vgic_its_base = addr;
> -
> -		return 0;
> +		return vgic_register_its_iodev(dev->kvm, its, addr);
>  	}
>  	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
>  		const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> @@ -2462,30 +2465,3 @@ int kvm_vgic_register_its_device(void)
>  	return kvm_register_device_ops(&kvm_arm_vgic_its_ops,
>  				       KVM_DEV_TYPE_ARM_VGIC_ITS);
>  }
> -
> -/*
> - * Registers all ITSes with the kvm_io_bus framework.
> - * To follow the existing VGIC initialization sequence, this has to be
> - * done as late as possible, just before the first VCPU runs.
> - */
> -int vgic_register_its_iodevs(struct kvm *kvm)
> -{
> -	struct kvm_device *dev;
> -	int ret = 0;
> -
> -	list_for_each_entry(dev, &kvm->devices, vm_node) {
> -		if (dev->ops != &kvm_arm_vgic_its_ops)
> -			continue;
> -
> -		ret = vgic_register_its_iodev(kvm, dev->private);
> -		if (ret)
> -			return ret;
> -		/*
> -		 * We don't need to care about tearing down previously
> -		 * registered ITSes, as the kvm_io_bus framework removes
> -		 * them for us if the VM gets destroyed.
> -		 */
> -	}
> -
> -	return ret;
> -}
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index bb35078..8fa737e 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -397,14 +397,6 @@ int vgic_v3_map_resources(struct kvm *kvm)
>  		goto out;
>  	}
>  
> -	if (vgic_has_its(kvm)) {
> -		ret = vgic_register_its_iodevs(kvm);
> -		if (ret) {
> -			kvm_err("Unable to register VGIC ITS MMIO regions\n");
> -			goto out;
> -		}
> -	}
> -
>  	dist->ready = true;
>  
>  out:
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 5f17eac..8ac7397 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -181,7 +181,6 @@ bool vgic_v3_check_base(struct kvm *kvm);
>  void vgic_v3_load(struct kvm_vcpu *vcpu);
>  void vgic_v3_put(struct kvm_vcpu *vcpu);
>  
> -int vgic_register_its_iodevs(struct kvm *kvm);
>  bool vgic_has_its(struct kvm *kvm);
>  int kvm_vgic_register_its_device(void);
>  void vgic_enable_lpis(struct kvm_vcpu *vcpu);
> 
