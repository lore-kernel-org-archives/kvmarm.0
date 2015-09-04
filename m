From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 2/5] KVM: arm64: Implement vGICv3 distributor and
 redistributor access from userspace
Date: Fri, 4 Sep 2015 14:53:43 +0100
Message-ID: <55E9A267.4040404@arm.com>
References: <cover.1441370053.git.p.fedin@samsung.com>
 <fc3dabfbff09f5c70affdde2996f3658b2000825.1441370053.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1778E412D6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2015 09:52:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W33-80mxDkYi for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2015 09:52:00 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7312B41278
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2015 09:52:00 -0400 (EDT)
In-Reply-To: <fc3dabfbff09f5c70affdde2996f3658b2000825.1441370053.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,

On 04/09/15 13:40, Pavel Fedin wrote:
> The access is done similar to vGICv2, using KVM_DEV_ARM_VGIC_GRP_DIST_REGS
> and KVM_DEV_ARM_VGIC_GRP_REDIST_REGS with KVM_SET_DEVICE_ATTR and
> KVM_GET_DEVICE_ATTR ioctls. Since GICv3 can handle large number of CPUs,
> KVM_DEV_ARM_VGIC_CPUID_MASK has been extended to 20 bits. This is enough
> for 1048576 CPUs.

I guess the 20 bits come from 8 bits for Aff2 and Aff1 and 4-bits for
Aff0? If so, please mention this. But I am not sure we should limit the
cpu index in this public API to something as low 20 bits. Since this
mask is GIC specific, we could push the size bit into offset and use the
full upper 32 bits for cpuid, or at least 28 bits plus 4 reserved.

> 
> Some registers are 64-bit wide according to the specification.
> KVM_DEV_ARM_VGIC_64BIT flag is introduced, allowing to perform full 64-bit
> accesses.
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  Documentation/virtual/kvm/devices/arm-vgic.txt | 35 ++++++++--
>  arch/arm64/include/uapi/asm/kvm.h              |  4 +-
>  virt/kvm/arm/vgic-v3-emul.c                    | 95 ++++++++++++++++++++++----
>  virt/kvm/arm/vgic.c                            |  1 +
>  4 files changed, 116 insertions(+), 19 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
> index 3fb9054..03f640f 100644
> --- a/Documentation/virtual/kvm/devices/arm-vgic.txt
> +++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
> @@ -43,10 +43,13 @@ Groups:
>    KVM_DEV_ARM_VGIC_GRP_DIST_REGS
>    Attributes:
>      The attr field of kvm_device_attr encodes two values:
> -    bits:     | 63   ....  40 | 39 ..  32  |  31   ....    0 |
> -    values:   |    reserved   |   cpu id   |      offset     |
> +    bits:     |  63  | 62 .. 52 | 51 ..  32  |  31   ....    0 |
> +    values:   | size | reserved |   cpu id   |      offset     |
>  
>      All distributor regs are (rw, 32-bit)
> +    For GICv3 some regs are also (rw, 64-bit) according to the specification.

That sounds contradictory to me. What about:
All registers can be accessed by using 32-bit accesses, some registers
also by 64-bit reads/writes according to the specification.

> +    In order to perform full 64-bit access 'size' bit should be set to 1.
> +    KVM_DEV_ARM_VGIC_64BIT flag value is provided for this purpose.
>  
>      The offset is relative to the "Distributor base address" as defined in the
>      GICv2 specs.  Getting or setting such a register has the same effect as
> @@ -54,9 +57,33 @@ Groups:
>      specified with cpu id field.  Note that most distributor fields are not
>      banked, but return the same value regardless of the cpu id used to access
>      the register.
> +
> +  Limitations:
> +    - Priorities are not implemented, and registers are RAZ/WI
> +  Errors:
> +    -ENODEV: Getting or setting this register is not yet supported

Isn't that actually -ENXIO in the code? I see that this is just copy &
paste, but it should be fixed in either case.

> +    -EBUSY: One or more VCPUs are running
> +
> +  KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
> +  Attributes:
> +    The attr field of kvm_device_attr encodes two values:
> +    bits:     |  63  | 62 .. 52 | 51 ..  32  |  31   ....    0 |
> +    values:   | size | reserved |   cpu id   |      offset     |
> +
> +    All redistributor regs are (rw, 32-bit)
> +    For GICv3 some regs are also (rw, 64-bit) according to the specification.
> +    In order to perform full 64-bit access 'size' bit should be set to 1.
> +    KVM_DEV_ARM_VGIC_64BIT flag value is provided for this purpose.
> +
> +    The offset is relative to the "Redistributor base address" as defined in
> +    the GICv3 specs.  Getting or setting such a register has the same effect as
> +    reading or writing the register on the actual hardware from the cpu
> +    specified with cpu id field.  Note that most distributor fields are not
> +    banked, but return the same value regardless of the cpu id used to access
> +    the register.
> +
>    Limitations:
>      - Priorities are not implemented, and registers are RAZ/WI
> -    - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
>    Errors:
>      -ENODEV: Getting or setting this register is not yet supported
>      -EBUSY: One or more VCPUs are running
> @@ -64,7 +91,7 @@ Groups:
>    KVM_DEV_ARM_VGIC_GRP_CPU_REGS
>    Attributes:
>      The attr field of kvm_device_attr encodes two values:
> -    bits:     | 63   ....  40 | 39 ..  32  |  31   ....    0 |
> +    bits:     | 63   ....  52 | 51 ..  32  |  31   ....    0 |
>      values:   |    reserved   |   cpu id   |      offset     |
>  
>      All CPU interface regs are (rw, 32-bit)
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 0cd7b59..249954f 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -196,13 +196,15 @@ struct kvm_arch_memory_slot {
>  #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
>  #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
>  #define KVM_DEV_ARM_VGIC_GRP_CPU_REGS	2
> +#define   KVM_DEV_ARM_VGIC_64BIT	(1ULL << 63)
>  #define   KVM_DEV_ARM_VGIC_CPUID_SHIFT	32
> -#define   KVM_DEV_ARM_VGIC_CPUID_MASK	(0xffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
> +#define   KVM_DEV_ARM_VGIC_CPUID_MASK	(0xfffffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
>  #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
>  #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
>  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
>  #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
> +#define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
>  
>  /* KVM_IRQ_LINE irq field index values */
>  #define KVM_ARM_IRQ_TYPE_SHIFT		24
> diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
> index e661e7f..8bda714 100644
> --- a/virt/kvm/arm/vgic-v3-emul.c
> +++ b/virt/kvm/arm/vgic-v3-emul.c
> @@ -39,6 +39,7 @@
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  #include <linux/interrupt.h>
> +#include <linux/uaccess.h>
>  
>  #include <linux/irqchip/arm-gic-v3.h>
>  #include <kvm/arm_vgic.h>
> @@ -990,6 +991,77 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
>  		vgic_kick_vcpus(vcpu->kvm);
>  }
>  
> +static int vgic_v3_attr_regs_access(struct kvm_device *dev,
> +				    struct kvm_device_attr *attr,
> +				    bool is_write)
> +{
> +	const struct vgic_io_range *ranges;
> +	phys_addr_t offset;
> +	int cpuid, ret;
> +	struct vgic_dist *vgic = &dev->kvm->arch.vgic;
> +	struct kvm_exit_mmio mmio;
> +
> +	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
> +		KVM_DEV_ARM_VGIC_CPUID_SHIFT;
> +
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> +		offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;

Can't this be just after the cpuid= assignment outside of the switch
statement?

> +		mmio.phys_addr = vgic->vgic_dist_base;
> +		ranges = vgic_v3_dist_ranges;
> +		break;
> +	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
> +		offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
> +		mmio.phys_addr = vgic->vgic_redist_base;
> +		ranges = vgic_redist_ranges;
> +		break;
> +	default:
> +		return -ENXIO;
> +	}
> +
> +	mmio.is_write = is_write;
> +
> +	if (attr->attr & KVM_DEV_ARM_VGIC_64BIT) {
> +		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +		__le64 data;
> +
> +		if (is_write) {
> +			u64 reg;
> +
> +			if (get_user(reg, uaddr))

Wouldn't the use of copy_from_user/copy_to_user here make this whole
switch redundant? Even if not, you could think about moving this logic
into into vgic_attr_regs_access() and just hardcode "len=4" into GICv2
accesses.

> +				return -EFAULT;
> +			data = cpu_to_le64(reg);
> +		}
> +
> +		mmio.data = &data;
> +		ret = vgic_attr_regs_access(dev, ranges, &mmio, offset,
> +					    sizeof(data), cpuid);
> +
> +		if (!ret && !is_write)
> +			ret = put_user(le64_to_cpu(data), uaddr);
> +	} else {
> +		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
> +		__le32 data;
> +
> +		if (is_write) {
> +			u32 reg;
> +
> +			if (get_user(reg, uaddr))
> +				return -EFAULT;
> +			data = cpu_to_le32(reg);
> +		}
> +
> +		mmio.data = &data;
> +		ret = vgic_attr_regs_access(dev, ranges, &mmio, offset,
> +					    sizeof(data), cpuid);
> +
> +		if (!ret && !is_write)
> +			ret = put_user(le32_to_cpu(data), uaddr);
> +	}
> +
> +	return ret;
> +}
> +
>  static int vgic_v3_create(struct kvm_device *dev, u32 type)
>  {
>  	return kvm_vgic_create(dev->kvm, type);
> @@ -1009,13 +1081,7 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
>  	if (ret != -ENXIO)
>  		return ret;
>  
> -	switch (attr->group) {
> -	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> -	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
> -		return -ENXIO;
> -	}
> -
> -	return -ENXIO;
> +	return vgic_v3_attr_regs_access(dev, attr, true);
>  }
>  
>  static int vgic_v3_get_attr(struct kvm_device *dev,
> @@ -1027,18 +1093,14 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
>  	if (ret != -ENXIO)
>  		return ret;
>  
> -	switch (attr->group) {
> -	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> -	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
> -		return -ENXIO;
> -	}
> -
> -	return -ENXIO;
> +	return vgic_v3_attr_regs_access(dev, attr, false);
>  }
>  
>  static int vgic_v3_has_attr(struct kvm_device *dev,
>  			    struct kvm_device_attr *attr)
>  {
> +	phys_addr_t offset;
> +
>  	switch (attr->group) {
>  	case KVM_DEV_ARM_VGIC_GRP_ADDR:
>  		switch (attr->attr) {
> @@ -1051,6 +1113,11 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>  		}
>  		break;
>  	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
> +		offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
> +		return vgic_has_attr_regs(vgic_v3_dist_ranges, offset);
> +	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
> +		offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
> +		return vgic_has_attr_regs(vgic_redist_ranges, offset);
>  	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
>  		return -ENXIO;
>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 33b00e5..9aa802b 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -2468,6 +2468,7 @@ int vgic_attr_regs_access(struct kvm_device *dev,
>  	 * access. For 64-bit registers we have to split up the operation.
>  	 */
>  	mmio->len = sizeof(u32);
> +	mmio->private = vcpu; /* For redistributor handlers */

I guess this can be moved into the caller and then you can drop the vcpu
parameter and use private here instead, no?

Cheers,
Andre.

>  	mmio->phys_addr += offset;
>  	offset -= r->base;
>  	r->handle_mmio(vcpu, mmio, offset);
> 
