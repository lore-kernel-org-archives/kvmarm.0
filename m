From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/2] KVM: arm/arm64: Rename vgic_attr_regs_access to
 vgic_attr_regs_access_v2
Date: Tue, 16 Aug 2016 18:09:24 +0200
Message-ID: <20160816160924.vaq7s3n3vjvx4uhg@kamzik.localdomain>
References: <20160816151034.16930-1-christoffer.dall@linaro.org>
 <20160816151034.16930-3-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 810A241267
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 12:02:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QHRJJk2pDwex for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Aug 2016 12:02:02 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF6FA411E3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 12:02:02 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20160816151034.16930-3-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 16, 2016 at 05:10:34PM +0200, Christoffer Dall wrote:
> Just a rename so we can implement a v3-specific function later.  No
> functional change.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 22d7ab3..2e18f03 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -296,17 +296,20 @@ static bool lock_all_vcpus(struct kvm *kvm)
>  	return true;
>  }
>  
> -/** vgic_attr_regs_access: allows user space to read/write VGIC registers
> - *
> - * @dev: kvm device handle
> - * @attr: kvm device attribute
> - * @reg: address the value is read or written
> - * @is_write: write flag
> +/* V2 ops */
> +
> +

Do we want 2 blank lines here? Do we need the 'V2 ops' comment at all?

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
> @@ -349,8 +352,6 @@ out:
>  	return ret;
>  }
>  
> -/* V2 ops */
> -
>  static int vgic_v2_set_attr(struct kvm_device *dev,
>  			    struct kvm_device_attr *attr)
>  {
> @@ -369,7 +370,7 @@ static int vgic_v2_set_attr(struct kvm_device *dev,
>  		if (get_user(reg, uaddr))
>  			return -EFAULT;
>  
> -		return vgic_attr_regs_access(dev, attr, &reg, true);
> +		return vgic_attr_regs_access_v2(dev, attr, &reg, true);
>  	}
>  	}
>  
> @@ -391,7 +392,7 @@ static int vgic_v2_get_attr(struct kvm_device *dev,
>  		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
>  		u32 reg = 0;
>  
> -		ret = vgic_attr_regs_access(dev, attr, &reg, false);
> +		ret = vgic_attr_regs_access_v2(dev, attr, &reg, false);
>  		if (ret)
>  			return ret;
>  		return put_user(reg, uaddr);
> -- 
> 2.9.0
>

No better way to attract reviewers than to advertise no functional
change :-)

Looks good to me.

drew
