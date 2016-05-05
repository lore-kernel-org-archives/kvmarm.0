From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v2 32/54] KVM: arm/arm64: vgic-new: Add GICv3 MMIO
 handling framework
Date: Thu, 5 May 2016 18:55:28 +0100
Message-ID: <572B8910.4030706@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-33-git-send-email-andre.przywara@arm.com>
 <57277CA6.6060804@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92B9449B6A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2016 13:52:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LJSX5HJ5boml for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 May 2016 13:52:19 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0525649B55
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2016 13:52:18 -0400 (EDT)
In-Reply-To: <57277CA6.6060804@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On 02/05/16 17:13, Eric Auger wrote:
> Hi Andre,
> 
> Some minor comments below.
> On 04/28/2016 06:45 PM, Andre Przywara wrote:
>> Create a new file called vgic-mmio-v3.c and describe the GICv3
>> distributor and redistributor registers there.
>> This adds a special macro to deal with the split of SGI/PPI in the
>> redistributor and SPIs in the distributor, which allows us to reuse
>> the existing GICv2 handlers for those registers which are compatible.
>> Also we provide a function to deal with the registration of the two
>> separate redistributor frames per VCPU.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>> Changelog RFC..v1:
>> - adapt to new MMIO registration approach:
>>   register one device for the distributor and two for each VCPU
>> - implement special handling for private interrupts
>> - remove empty stub functions
>> - make IGROUPR return RAO
>>
>> Changelog v1 .. v2:
>> - adapt to new framework, introduce vgic-mmio-v3.c
>> - remove userland register access functions (for now)
>> - precompute .len when describing a VGIC register
>> - add missed pointer incrementation on registering redist regions
>> - replace _nyi stub functions with raz/wi versions
>>
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 191 +++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic-mmio.c    |   5 +
>>  virt/kvm/arm/vgic/vgic-mmio.h    |   2 +
>>  virt/kvm/arm/vgic/vgic.h         |   3 +
>>  4 files changed, 201 insertions(+)
>>  create mode 100644 virt/kvm/arm/vgic/vgic-mmio-v3.c
>>
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> new file mode 100644
>> index 0000000..c6765d4
>> --- /dev/null
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -0,0 +1,191 @@
>> +/*
>> + * VGICv3 MMIO handling functions
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/irqchip/arm-gic-v3.h>
>> +#include <linux/kvm.h>
>> +#include <linux/kvm_host.h>
>> +#include <kvm/iodev.h>
>> +#include <kvm/vgic/vgic.h>
>> +
>> +#include <asm/kvm_emulate.h>
>> +
>> +#include "vgic.h"
>> +#include "vgic-mmio.h"
>> +
>> +/*
>> + * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
>> + * redistributors, while SPIs are covered by registers in the distributor
>> + * block. Trying to set private IRQs in this block gets ignored.
>> + * We take some special care here to fix the calculation of the register
>> + * offset.
>> + */
>> +#define REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(off, read_ops, write_ops, bpi) \
>> +	{								\
>> +		.reg_offset = off,					\
>> +		.bits_per_irq = bpi,					\
>> +		.len = (bpi * VGIC_NR_PRIVATE_IRQS) / 8,		\
>> +		.read = vgic_mmio_read_raz,				\
>> +		.write = vgic_mmio_write_wi,				\
>> +	}, {								\
>> +		.reg_offset = off + (bpi * VGIC_NR_PRIVATE_IRQS) / 8,	\
>> +		.bits_per_irq = bpi,					\
>> +		.len = (bpi * (1024 - VGIC_NR_PRIVATE_IRQS)) / 8,	\
>> +		.read = read_ops,					\
>> +		.write = write_ops,					\
>> +	}
>> +
>> +static const struct vgic_register_region vgic_v3_dist_registers[] = {
>> +	REGISTER_DESC_WITH_LENGTH(GICD_CTLR,
>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 16),
>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
>> +		vgic_mmio_read_rao, vgic_mmio_write_wi, 1),
>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISENABLER,
>> +		vgic_mmio_read_enable, vgic_mmio_write_senable, 1),
>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICENABLER,
>> +		vgic_mmio_read_enable, vgic_mmio_write_cenable, 1),
>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISPENDR,
>> +		vgic_mmio_read_pending, vgic_mmio_write_spending, 1),
>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICPENDR,
>> +		vgic_mmio_read_pending, vgic_mmio_write_cpending, 1),
>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
>> +		vgic_mmio_read_active, vgic_mmio_write_sactive, 1),
>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICACTIVER,
>> +		vgic_mmio_read_active, vgic_mmio_write_cactive, 1),
>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IPRIORITYR,
>> +		vgic_mmio_read_priority, vgic_mmio_write_priority, 8),
>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ITARGETSR,
>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICFGR,
>> +		vgic_mmio_read_config, vgic_mmio_write_config, 2),
>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGRPMODR,
>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IROUTER,
>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 64),
>> +	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS,
>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 48),
>> +};
>> +
> would add a comment to say this corresponds to RD_base frame, to use the
> same terminology as the spec. IHI0069B.
>> +static const struct vgic_register_region vgic_v3_redist_registers[] = {
>> +	REGISTER_DESC_WITH_LENGTH(GICR_CTLR,
>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
>> +	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
>> +	REGISTER_DESC_WITH_LENGTH(GICR_TYPER,
>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
>> +	REGISTER_DESC_WITH_LENGTH(GICR_PROPBASER,
>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
>> +	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER,
>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
>> +	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS,
>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 48),
>> +};
>> +
> same as above: SGI_base frame. Used terminology was a bit misleading for
> me since this is also part of redist, 2d frame.

I took the freedom to just replace the variable names with
vgic_v3_rdbase_registers and vgic_v3_sgibase_registers, respectively.
Hope that does the trick for you as well.

>> +static const struct vgic_register_region vgic_v3_private_registers[] = {
>> +	REGISTER_DESC_WITH_LENGTH(GICR_IGROUPR0,
>> +		vgic_mmio_read_rao, vgic_mmio_write_wi, 4),
>> +	REGISTER_DESC_WITH_LENGTH(GICR_ISENABLER0,
>> +		vgic_mmio_read_enable, vgic_mmio_write_senable, 4),
>> +	REGISTER_DESC_WITH_LENGTH(GICR_ICENABLER0,
>> +		vgic_mmio_read_enable, vgic_mmio_write_cenable, 4),
>> +	REGISTER_DESC_WITH_LENGTH(GICR_ISPENDR0,
>> +		vgic_mmio_read_pending, vgic_mmio_write_spending, 4),
>> +	REGISTER_DESC_WITH_LENGTH(GICR_ICPENDR0,
>> +		vgic_mmio_read_pending, vgic_mmio_write_cpending, 4),
>> +	REGISTER_DESC_WITH_LENGTH(GICR_ISACTIVER0,
>> +		vgic_mmio_read_active, vgic_mmio_write_sactive, 4),
>> +	REGISTER_DESC_WITH_LENGTH(GICR_ICACTIVER0,
>> +		vgic_mmio_read_active, vgic_mmio_write_cactive, 4),
>> +	REGISTER_DESC_WITH_LENGTH(GICR_IPRIORITYR0,
>> +		vgic_mmio_read_priority, vgic_mmio_write_priority, 32),
>> +	REGISTER_DESC_WITH_LENGTH(GICR_ICFGR0,
>> +		vgic_mmio_read_config, vgic_mmio_write_config, 8),
>> +	REGISTER_DESC_WITH_LENGTH(GICR_IGRPMODR0,
>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
>> +	REGISTER_DESC_WITH_LENGTH(GICR_NSACR,
>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
>> +};
>> +
>> +unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev)
>> +{
>> +	dev->regions = vgic_v3_dist_registers;
>> +	dev->nr_regions = ARRAY_SIZE(vgic_v3_dist_registers);
>> +
>> +	kvm_iodevice_init(&dev->dev, &kvm_io_gic_ops);
>> +
>> +	return SZ_64K;
>> +}
>> +
>> +int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
>> +{
>> +	int nr_vcpus = atomic_read(&kvm->online_vcpus);
>> +	struct kvm_vcpu *vcpu;
>> +	struct vgic_io_device *devices, *device;
>> +	int c, ret = 0;
>> +
>> +	devices = kmalloc(sizeof(struct vgic_io_device) * nr_vcpus * 2,
>> +			  GFP_KERNEL);
>> +	if (!devices)
>> +		return -ENOMEM;
>> +
>> +	device = devices;
>> +	kvm_for_each_vcpu(c, vcpu, kvm) {
>> +		kvm_iodevice_init(&device->dev, &kvm_io_gic_ops);
>> +		device->base_addr = redist_base_address;
>> +		device->regions = vgic_v3_redist_registers;
>> +		device->nr_regions = ARRAY_SIZE(vgic_v3_redist_registers);
>> +		device->redist_vcpu = vcpu;
>> +
>> +		mutex_lock(&kvm->slots_lock);
>> +		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS,
>> +					      redist_base_address,
>> +					      SZ_64K, &device->dev);
>> +		mutex_unlock(&kvm->slots_lock);
>> +
>> +		if (ret)
>> +			break;
>> +
>> +		device++;
>> +		kvm_iodevice_init(&device->dev, &kvm_io_gic_ops);
>> +		device->base_addr = redist_base_address + SZ_64K;
>> +		device->regions = vgic_v3_private_registers;
>> +		device->nr_regions = ARRAY_SIZE(vgic_v3_private_registers);
>> +		device->redist_vcpu = vcpu;
>> +
>> +		mutex_lock(&kvm->slots_lock);
>> +		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS,
>> +					      redist_base_address + SZ_64K,
>> +					      SZ_64K, &device->dev);
>> +		mutex_unlock(&kvm->slots_lock);
>> +		if (ret) {
>> +			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
>> +						  &devices[c * 2].dev);
>> +			break;
>> +		}
>> +		device++;
>> +		redist_base_address += 2 * SZ_64K;
>> +	}
>> +
>> +	if (ret) {
>> +		for (c--; c >= 0; c--) {
>> +			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
>> +						  &devices[c * 2].dev);
>> +			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
>> +						  &devices[c * 2 + 1].dev);
>> +		}
>> +		kfree(devices);
>> +	} else {
>> +		kvm->arch.vgic.redist_iodevs = devices;
>> +	}
>> +
>> +	return ret;
>> +}
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
>> index bf4278c..80d977e 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
>> @@ -502,6 +502,11 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
>>  	case VGIC_V2:
>>  		len = vgic_v2_init_dist_iodev(io_device);
>>  		break;
>> +#ifdef CONFIG_KVM_ARM_VGIC_V3
>> +	case VGIC_V3:
>> +		len = vgic_v3_init_dist_iodev(io_device);
>> +		break;
>> +#endif
>>  	default:
>>  		BUG_ON(1);
>>  	}
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
>> index 884eb71..3585ac6 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio.h
>> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
>> @@ -123,4 +123,6 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
>>  
>>  unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
>>  
>> +unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
>> +
>>  #endif
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index 1ab7d97..6fe07df 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -61,6 +61,9 @@ static inline void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
>>  static inline void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
>>  {
>>  }
>> +
>>  #endif
>>  
>> +void kvm_register_vgic_device(unsigned long type);
> I don't think this relates to this patch.

Eek, good catch.

> Besides Reviewed-by: Eric Auger <eric.auger@linaro.org>

Merci!
Andre.
