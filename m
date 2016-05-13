From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 43/55] KVM: arm/arm64: vgic-new: vgic_kvm_device:
 access to VGIC registers
Date: Fri, 13 May 2016 13:24:07 +0100
Message-ID: <5735C767.7030807@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-44-git-send-email-andre.przywara@arm.com>
 <20160512183016.GJ27623@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28B5249B4A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2016 08:20:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GNM94o08FkKE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 May 2016 08:20:36 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1885D49B47
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 May 2016 08:20:35 -0400 (EDT)
In-Reply-To: <20160512183016.GJ27623@cbox>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 12/05/16 19:30, Christoffer Dall wrote:
> On Fri, May 06, 2016 at 11:45:56AM +0100, Andre Przywara wrote:
>> From: Eric Auger <eric.auger@linaro.org>
>>
>> This patch implements the switches for KVM_DEV_ARM_VGIC_GRP_DIST_REGS
>> and KVM_DEV_ARM_VGIC_GRP_CPU_REGS API which allows the userspace to
>> access VGIC registers.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  virt/kvm/arm/vgic/vgic-kvm-device.c | 53 +++++++++++++++++++++++++++++++++++--
>>  virt/kvm/arm/vgic/vgic-mmio-v2.c    | 34 ++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic.h            |  1 +
>>  3 files changed, 86 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
>> index 0189c13..c952f6f 100644
>> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
>> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
>> @@ -252,6 +252,21 @@ void kvm_register_vgic_device(unsigned long type)
>>  	}
>>  }
>>  
>> +/** vgic_attr_regs_access: allows user space to read/write VGIC registers
>> + *
>> + * @dev: kvm device handle
>> + * @attr: kvm device attribute
>> + * @reg: address the value is read or written
>> + * @is_write: write flag
>> + *
>> + */
>> +static int vgic_attr_regs_access(struct kvm_device *dev,
>> +				 struct kvm_device_attr *attr,
>> +				 u32 *reg, bool is_write)
>> +{
>> +	return -ENXIO;
>> +}
>> +
>>  /* V2 ops */
>>  
>>  static int vgic_v2_set_attr(struct kvm_device *dev,
>> @@ -260,8 +275,23 @@ static int vgic_v2_set_attr(struct kvm_device *dev,
>>  	int ret;
>>  
>>  	ret = vgic_set_common_attr(dev, attr);
>> -	return ret;
>> +	if (ret != -ENXIO)
>> +		return ret;
>> +
>> +	switch (attr->group) {
>> +	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
>> +	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
>> +		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
>> +		u32 reg;
>> +
>> +		if (get_user(reg, uaddr))
>> +			return -EFAULT;
>>  
>> +		return vgic_attr_regs_access(dev, attr, &reg, true);
>> +	}
>> +	}
>> +
>> +	return -ENXIO;
>>  }
>>  
>>  static int vgic_v2_get_attr(struct kvm_device *dev,
>> @@ -270,7 +300,23 @@ static int vgic_v2_get_attr(struct kvm_device *dev,
>>  	int ret;
>>  
>>  	ret = vgic_get_common_attr(dev, attr);
>> -	return ret;
>> +	if (ret != -ENXIO)
>> +		return ret;
>> +
>> +	switch (attr->group) {
>> +	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
>> +	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
>> +		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
>> +		u32 reg = 0;
>> +
>> +		ret = vgic_attr_regs_access(dev, attr, &reg, false);
>> +		if (ret)
>> +			return ret;
>> +		return put_user(reg, uaddr);
>> +	}
>> +	}
>> +
>> +	return -ENXIO;
>>  }
>>  
>>  static int vgic_v2_has_attr(struct kvm_device *dev,
>> @@ -284,6 +330,9 @@ static int vgic_v2_has_attr(struct kvm_device *dev,
>>  			return 0;
>>  		}
>>  		break;
>> +	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
>> +	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
>> +		return vgic_v2_has_attr_regs(dev, attr);
>>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
>>  		return 0;
>>  	case KVM_DEV_ARM_VGIC_GRP_CTRL:
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> index 8006ac0..cf8fee9 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
>> @@ -246,3 +246,37 @@ unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev)
>>  
>>  	return SZ_4K;
>>  }
>> +
>> +int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
>> +{
>> +	int nr_irqs = dev->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
>> +	const struct vgic_register_region *regions;
>> +	gpa_t addr;
>> +	int nr_regions, i, len;
>> +
>> +	addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
>> +
>> +	switch (attr->group) {
>> +	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
>> +		regions = vgic_v2_dist_registers;
>> +		nr_regions = ARRAY_SIZE(vgic_v2_dist_registers);
>> +		break;
>> +	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
>> +		return -ENXIO;		/* TODO: describe CPU i/f regs also */
>> +	default:
>> +		return -ENXIO;
>> +	}
>> +
>> +	for (i = 0; i < nr_regions; i++) {
>> +		if (regions[i].bits_per_irq)
>> +			len = (regions[i].bits_per_irq * nr_irqs) / 8;
>> +		else
>> +			len = regions[i].len;
>> +
>> +		if (regions[i].reg_offset <= addr &&
>> +		    regions[i].reg_offset + len > addr)
>> +			return 0;
> 
> should we check if addr is word-aligned ?

Do we care here? This is just the function that says whether we support
this register or not, so I don't see so much benefit in checking here.
A check would be more useful in get/set_attr, if this isn't even
enforced before.

Cheers,
Andre.
