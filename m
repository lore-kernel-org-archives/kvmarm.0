From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v2 2/2] KVM: arm/arm64: Rename vgic_attr_regs_access to
 vgic_attr_regs_access_v2
Date: Wed, 17 Aug 2016 07:46:37 +0200
Message-ID: <ca5b4328-5d9e-d3b7-a922-0d3409a7f3e7@redhat.com>
References: <20160816173501.21521-1-christoffer.dall@linaro.org>
 <20160816173501.21521-3-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69C7C40FA7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 01:39:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m-Qz4VkGqJ9v for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Aug 2016 01:39:12 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F8C740F9B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2016 01:39:12 -0400 (EDT)
In-Reply-To: <20160816173501.21521-3-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, vijay.kilari@gmail.com
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 16/08/2016 19:35, Christoffer Dall wrote:
> Just a rename so we can implement a v3-specific function later.
> 
> We take the chance to get rid of the V2/V3 ops comments as well.
> 
> No functional change.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 26 +++++++++++---------------
>  1 file changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 19fa331..163b057 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -294,17 +294,17 @@ static bool lock_all_vcpus(struct kvm *kvm)
>  	return true;
>  }
>  
> -/** vgic_attr_regs_access: allows user space to read/write VGIC registers
> - *
> - * @dev: kvm device handle
> - * @attr: kvm device attribute
> - * @reg: address the value is read or written
> - * @is_write: write flag
> +/**
> + * vgic_attr_regs_access_v2 - allows user space to access VGIC v2 state
>   *
> + * @dev:      kvm device handle
> + * @attr:     kvm device attribute
> + * @reg:      address the value is read or written
> + * @is_write: true if userspace is writing a register
>   */
> -static int vgic_attr_regs_access(struct kvm_device *dev,
> -				 struct kvm_device_attr *attr,
> -				 u32 *reg, bool is_write)
> +static int vgic_attr_regs_access_v2(struct kvm_device *dev,
> +				    struct kvm_device_attr *attr,
> +				    u32 *reg, bool is_write)
>  {
>  	struct vgic_reg_attr reg_attr;
>  	gpa_t addr;
> @@ -347,8 +347,6 @@ out:
>  	return ret;
>  }
>  
> -/* V2 ops */
> -
>  static int vgic_v2_set_attr(struct kvm_device *dev,
>  			    struct kvm_device_attr *attr)
>  {
> @@ -367,7 +365,7 @@ static int vgic_v2_set_attr(struct kvm_device *dev,
>  		if (get_user(reg, uaddr))
>  			return -EFAULT;
>  
> -		return vgic_attr_regs_access(dev, attr, &reg, true);
> +		return vgic_attr_regs_access_v2(dev, attr, &reg, true);
>  	}
>  	}
>  
> @@ -389,7 +387,7 @@ static int vgic_v2_get_attr(struct kvm_device *dev,
>  		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
>  		u32 reg = 0;
>  
> -		ret = vgic_attr_regs_access(dev, attr, &reg, false);
> +		ret = vgic_attr_regs_access_v2(dev, attr, &reg, false);
>  		if (ret)
>  			return ret;
>  		return put_user(reg, uaddr);
> @@ -433,8 +431,6 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
>  	.has_attr = vgic_v2_has_attr,
>  };
>  
> -/* V3 ops */
> -
>  #ifdef CONFIG_KVM_ARM_VGIC_V3
>  
>  static int vgic_v3_set_attr(struct kvm_device *dev,
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
