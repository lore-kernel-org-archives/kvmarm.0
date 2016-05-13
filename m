From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 42/55] KVM: arm/arm64: vgic-new: vgic_kvm_device:
 KVM_DEV_ARM_VGIC_GRP_ADDR
Date: Fri, 13 May 2016 12:12:37 +0200
Message-ID: <20160513101237.GE16274@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-43-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462531568-9799-43-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 06, 2016 at 11:45:55AM +0100, Andre Przywara wrote:
> From: Eric Auger <eric.auger@linaro.org>
> 
> This patch implements the KVM_DEV_ARM_VGIC_GRP_ADDR group which
> enables to set the base address of GIC regions as seen by the guest.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 38 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 493e941..0189c13 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -138,6 +138,17 @@ static int vgic_set_common_attr(struct kvm_device *dev,
>  	int r;
>  
>  	switch (attr->group) {
> +	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
> +		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +		u64 addr;
> +		unsigned long type = (unsigned long)attr->attr;
> +
> +		if (copy_from_user(&addr, uaddr, sizeof(addr)))
> +			return -EFAULT;
> +
> +		r = kvm_vgic_addr(dev->kvm, type, &addr, true);
> +		return (r == -ENODEV) ? -ENXIO : r;
> +	}
>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
>  		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
>  		u32 val;
> @@ -190,6 +201,19 @@ static int vgic_get_common_attr(struct kvm_device *dev,
>  	int r = -ENXIO;
>  
>  	switch (attr->group) {
> +	case KVM_DEV_ARM_VGIC_GRP_ADDR: {
> +		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +		u64 addr;
> +		unsigned long type = (unsigned long)attr->attr;
> +
> +		r = kvm_vgic_addr(dev->kvm, type, &addr, false);
> +		if (r)
> +			return (r == -ENODEV) ? -ENXIO : r;
> +
> +		if (copy_to_user(uaddr, &addr, sizeof(addr)))
> +			return -EFAULT;
> +		break;
> +	}
>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS: {
>  		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
>  
> @@ -253,6 +277,13 @@ static int vgic_v2_has_attr(struct kvm_device *dev,
>  			    struct kvm_device_attr *attr)
>  {
>  	switch (attr->group) {
> +	case KVM_DEV_ARM_VGIC_GRP_ADDR:
> +		switch (attr->attr) {
> +		case KVM_VGIC_V2_ADDR_TYPE_DIST:
> +		case KVM_VGIC_V2_ADDR_TYPE_CPU:
> +			return 0;
> +		}
> +		break;
>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
>  		return 0;
>  	case KVM_DEV_ARM_VGIC_GRP_CTRL:
> @@ -293,6 +324,13 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>  			    struct kvm_device_attr *attr)
>  {
>  	switch (attr->group) {
> +	case KVM_DEV_ARM_VGIC_GRP_ADDR:
> +		switch (attr->attr) {
> +		case KVM_VGIC_V3_ADDR_TYPE_DIST:
> +		case KVM_VGIC_V3_ADDR_TYPE_REDIST:
> +			return 0;
> +		}
> +		break;
>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
>  		return 0;
>  	case KVM_DEV_ARM_VGIC_GRP_CTRL:
> -- 
> 2.7.3
> 
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
