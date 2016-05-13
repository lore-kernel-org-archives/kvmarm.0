From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 40/55] KVM: arm/arm64: vgic-new: vgic_kvm_device:
 KVM_DEV_ARM_VGIC_GRP_CTRL
Date: Fri, 13 May 2016 12:11:58 +0200
Message-ID: <20160513101158.GC16274@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-41-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462531568-9799-41-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 06, 2016 at 11:45:53AM +0100, Andre Przywara wrote:
> From: Eric Auger <eric.auger@linaro.org>
> 
> This patch implements the KVM_DEV_ARM_VGIC_GRP_CTRL group API
> featuring KVM_DEV_ARM_VGIC_CTRL_INIT attribute. The vgic_init
> function is not yet implemented though.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 05ff925..e153f12 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -23,6 +23,8 @@
>  static int vgic_set_common_attr(struct kvm_device *dev,
>  				struct kvm_device_attr *attr)
>  {
> +	int r;
> +
>  	switch (attr->group) {
>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
>  		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> @@ -55,6 +57,16 @@ static int vgic_set_common_attr(struct kvm_device *dev,
>  
>  		return ret;
>  	}
> +	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
> +		switch (attr->attr) {
> +		case KVM_DEV_ARM_VGIC_CTRL_INIT:
> +			mutex_lock(&dev->kvm->lock);
> +			r = vgic_init(dev->kvm);
> +			mutex_unlock(&dev->kvm->lock);
> +			return r;
> +		}
> +		break;
> +	}
>  	}
>  
>  	return -ENXIO;
> @@ -131,6 +143,11 @@ static int vgic_v2_has_attr(struct kvm_device *dev,
>  	switch (attr->group) {
>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
>  		return 0;
> +	case KVM_DEV_ARM_VGIC_GRP_CTRL:
> +		switch (attr->attr) {
> +		case KVM_DEV_ARM_VGIC_CTRL_INIT:
> +			return 0;
> +		}
>  	}
>  	return -ENXIO;
>  }
> @@ -166,6 +183,11 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>  	switch (attr->group) {
>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
>  		return 0;
> +	case KVM_DEV_ARM_VGIC_GRP_CTRL:
> +		switch (attr->attr) {
> +		case KVM_DEV_ARM_VGIC_CTRL_INIT:
> +			return 0;
> +		}
>  	}
>  	return -ENXIO;
>  }
> -- 
> 2.7.3
> 
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
