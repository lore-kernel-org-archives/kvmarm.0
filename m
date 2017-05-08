From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 7/8] KVM: arm/arm64: Register ITS iodev when setting base
 address
Date: Mon, 8 May 2017 19:12:27 +0200
Message-ID: <a4214a5f-a19b-839b-5a00-cf8d415a723b@redhat.com>
References: <20170508115454.5075-1-cdall@linaro.org>
 <20170508115454.5075-8-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170508115454.5075-8-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 08/05/2017 13:54, Christoffer Dall wrote:
> We have to register the ITS iodevice before running the VM, because in
> migration scenarios, we may be restoring a live device that wishes to
> inject MSIs before we get a chance to run the VM.

actually the VM is in running state but the vcpus has not yet started.
> 
> All we need to register the ITS io device is the base address of the
> ITS, so we can simply register that when the base address of the ITS is
> set.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 29 +----------------------------
>  virt/kvm/arm/vgic/vgic-v3.c  |  8 --------
>  virt/kvm/arm/vgic/vgic.h     |  1 -
>  3 files changed, 1 insertion(+), 37 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 9f7105c..375c503 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -2390,7 +2390,7 @@ static int vgic_its_set_attr(struct kvm_device *dev,
>  
>  		its->vgic_its_base = addr;
>  
> -		return 0;
> +		return vgic_register_its_iodev(dev->kvm, its);
>  	}
>  	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
>  		const struct vgic_its_abi *abi = vgic_its_get_abi(its);
> @@ -2467,30 +2467,3 @@ int kvm_vgic_register_its_device(void)
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
> index 4d51d1f..d77fcb3 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -396,14 +396,6 @@ int vgic_v3_map_resources(struct kvm *kvm)
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
