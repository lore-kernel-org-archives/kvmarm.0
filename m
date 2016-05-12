From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 32/55] KVM: arm/arm64: vgic-new: Add GICv3 MMIO
 handling framework
Date: Thu, 12 May 2016 11:58:10 +0100
Message-ID: <573461C2.4090400@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-33-git-send-email-andre.przywara@arm.com>
 <20160512102630.GC27623@cbox> <5734608A.1080902@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5734608A.1080902@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 12/05/16 11:52, Andre Przywara wrote:
> Hi,
> 
> On 12/05/16 11:26, Christoffer Dall wrote:
>> On Fri, May 06, 2016 at 11:45:45AM +0100, Andre Przywara wrote:
>>> Create a new file called vgic-mmio-v3.c and describe the GICv3
>>> distributor and redistributor registers there.
>>> This adds a special macro to deal with the split of SGI/PPI in the
>>> redistributor and SPIs in the distributor, which allows us to reuse
>>> the existing GICv2 handlers for those registers which are compatible.
>>> Also we provide a function to deal with the registration of the two
>>> separate redistributor frames per VCPU.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> Reviewed-by: Eric Auger <eric.auger@linaro.org>
>>> ---
>>> Changelog RFC..v1:
>>> - adapt to new MMIO registration approach:
>>>   register one device for the distributor and two for each VCPU
>>> - implement special handling for private interrupts
>>> - remove empty stub functions
>>> - make IGROUPR return RAO
>>>
>>> Changelog v1 .. v2:
>>> - adapt to new framework, introduce vgic-mmio-v3.c
>>> - remove userland register access functions (for now)
>>> - precompute .len when describing a VGIC register
>>> - add missed pointer incrementation on registering redist regions
>>> - replace _nyi stub functions with raz/wi versions
>>>
>>> Changelog v2 .. v3:
>>> - replace inclusion of kvm/vgic/vgic.h with kvm/arm_vgic.h
>>> - add prototype and stub code for vgic_register_redist_iodevs
>>> - rename register struct variables _rdbase_ and _sgibase_
>>>
>>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 191 +++++++++++++++++++++++++++++++++++++++
>>>  virt/kvm/arm/vgic/vgic-mmio.c    |   5 +
>>>  virt/kvm/arm/vgic/vgic-mmio.h    |   2 +
>>>  virt/kvm/arm/vgic/vgic.h         |   7 ++
>>>  4 files changed, 205 insertions(+)
>>>  create mode 100644 virt/kvm/arm/vgic/vgic-mmio-v3.c
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> new file mode 100644
>>> index 0000000..06c7ec5
>>> --- /dev/null
>>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>>> @@ -0,0 +1,191 @@
>>> +/*
>>> + * VGICv3 MMIO handling functions
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + */
>>> +
>>> +#include <linux/irqchip/arm-gic-v3.h>
>>> +#include <linux/kvm.h>
>>> +#include <linux/kvm_host.h>
>>> +#include <kvm/iodev.h>
>>> +#include <kvm/arm_vgic.h>
>>> +
>>> +#include <asm/kvm_emulate.h>
>>> +
>>> +#include "vgic.h"
>>> +#include "vgic-mmio.h"
>>> +
>>> +/*
>>> + * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
>>> + * redistributors, while SPIs are covered by registers in the distributor
>>> + * block. Trying to set private IRQs in this block gets ignored.
>>> + * We take some special care here to fix the calculation of the register
>>> + * offset.
>>> + */
>>> +#define REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(off, read_ops, write_ops, bpi) \
>>> +	{								\
>>> +		.reg_offset = off,					\
>>> +		.bits_per_irq = bpi,					\
>>> +		.len = (bpi * VGIC_NR_PRIVATE_IRQS) / 8,		\
>>> +		.read = vgic_mmio_read_raz,				\
>>> +		.write = vgic_mmio_write_wi,				\
>>> +	}, {								\
>>> +		.reg_offset = off + (bpi * VGIC_NR_PRIVATE_IRQS) / 8,	\
>>> +		.bits_per_irq = bpi,					\
>>> +		.len = (bpi * (1024 - VGIC_NR_PRIVATE_IRQS)) / 8,	\
>>> +		.read = read_ops,					\
>>> +		.write = write_ops,					\
>>> +	}
>>> +
>>> +static const struct vgic_register_region vgic_v3_dist_registers[] = {
>>> +	REGISTER_DESC_WITH_LENGTH(GICD_CTLR,
>>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 16),
>>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
>>> +		vgic_mmio_read_rao, vgic_mmio_write_wi, 1),
>>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISENABLER,
>>> +		vgic_mmio_read_enable, vgic_mmio_write_senable, 1),
>>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICENABLER,
>>> +		vgic_mmio_read_enable, vgic_mmio_write_cenable, 1),
>>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISPENDR,
>>> +		vgic_mmio_read_pending, vgic_mmio_write_spending, 1),
>>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICPENDR,
>>> +		vgic_mmio_read_pending, vgic_mmio_write_cpending, 1),
>>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
>>> +		vgic_mmio_read_active, vgic_mmio_write_sactive, 1),
>>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICACTIVER,
>>> +		vgic_mmio_read_active, vgic_mmio_write_cactive, 1),
>>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IPRIORITYR,
>>> +		vgic_mmio_read_priority, vgic_mmio_write_priority, 8),
>>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ITARGETSR,
>>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
>>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICFGR,
>>> +		vgic_mmio_read_config, vgic_mmio_write_config, 2),
>>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGRPMODR,
>>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
>>> +	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IROUTER,
>>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 64),
>>> +	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS,
>>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 48),
>>> +};
>>> +
>>> +static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_CTLR,
>>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
>>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_TYPER,
>>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_PROPBASER,
>>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER,
>>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS,
>>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 48),
>>> +};
>>> +
>>> +static const struct vgic_register_region vgic_v3_sgibase_registers[] = {
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_IGROUPR0,
>>> +		vgic_mmio_read_rao, vgic_mmio_write_wi, 4),
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_ISENABLER0,
>>> +		vgic_mmio_read_enable, vgic_mmio_write_senable, 4),
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_ICENABLER0,
>>> +		vgic_mmio_read_enable, vgic_mmio_write_cenable, 4),
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_ISPENDR0,
>>> +		vgic_mmio_read_pending, vgic_mmio_write_spending, 4),
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_ICPENDR0,
>>> +		vgic_mmio_read_pending, vgic_mmio_write_cpending, 4),
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_ISACTIVER0,
>>> +		vgic_mmio_read_active, vgic_mmio_write_sactive, 4),
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_ICACTIVER0,
>>> +		vgic_mmio_read_active, vgic_mmio_write_cactive, 4),
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_IPRIORITYR0,
>>> +		vgic_mmio_read_priority, vgic_mmio_write_priority, 32),
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_ICFGR0,
>>> +		vgic_mmio_read_config, vgic_mmio_write_config, 8),
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_IGRPMODR0,
>>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
>>> +	REGISTER_DESC_WITH_LENGTH(GICR_NSACR,
>>> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
>>> +};
>>> +
>>> +unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev)
>>> +{
>>> +	dev->regions = vgic_v3_dist_registers;
>>> +	dev->nr_regions = ARRAY_SIZE(vgic_v3_dist_registers);
>>> +
>>> +	kvm_iodevice_init(&dev->dev, &kvm_io_gic_ops);
>>> +
>>> +	return SZ_64K;
>>> +}
>>> +
>>> +int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
>>> +{
>>> +	int nr_vcpus = atomic_read(&kvm->online_vcpus);
>>> +	struct kvm_vcpu *vcpu;
>>> +	struct vgic_io_device *devices, *device;
>>> +	int c, ret = 0;
>>> +
>>> +	devices = kmalloc(sizeof(struct vgic_io_device) * nr_vcpus * 2,
>>> +			  GFP_KERNEL);
>>> +	if (!devices)
>>> +		return -ENOMEM;
>>> +
>>> +	device = devices;
>>> +	kvm_for_each_vcpu(c, vcpu, kvm) {
>>> +		kvm_iodevice_init(&device->dev, &kvm_io_gic_ops);
>>> +		device->base_addr = redist_base_address;
>>> +		device->regions = vgic_v3_rdbase_registers;
>>> +		device->nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
>>> +		device->redist_vcpu = vcpu;
>>> +
>>> +		mutex_lock(&kvm->slots_lock);
>>> +		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS,
>>> +					      redist_base_address,
>>> +					      SZ_64K, &device->dev);
>>> +		mutex_unlock(&kvm->slots_lock);
>>> +
>>> +		if (ret)
>>> +			break;
>>> +
>>> +		device++;
>>> +		kvm_iodevice_init(&device->dev, &kvm_io_gic_ops);
>>> +		device->base_addr = redist_base_address + SZ_64K;
>>> +		device->regions = vgic_v3_sgibase_registers;
>>> +		device->nr_regions = ARRAY_SIZE(vgic_v3_sgibase_registers);
>>> +		device->redist_vcpu = vcpu;
>>> +
>>> +		mutex_lock(&kvm->slots_lock);
>>> +		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS,
>>> +					      redist_base_address + SZ_64K,
>>> +					      SZ_64K, &device->dev);
>>> +		mutex_unlock(&kvm->slots_lock);
>>> +		if (ret) {
>>> +			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
>>> +						  &devices[c * 2].dev);
>>> +			break;
>>> +		}
>>> +		device++;
>>> +		redist_base_address += 2 * SZ_64K;
>>
>> while I think this whole thing is actually correct, I think it could
>> have been much more clear by, in the beginning of the loop doing:
>>
>> 	gpa_t rd_base = redist_base_address + c * SZ_64K * 2;
>> 	gpa_t sgi_base = rd_base + SZ_64K;
>> 	struct vgic_io_device *rd_dev = &devices[c];
>> 	struct vgic_io_device *sgi_dev = &devices[c + 1];
>>
>> and then referring directly to these variables.
> 
> Yeah, looks useful, not sure we want to change it last minute though.

Why not? We're changing much more fundamental things already. I'd rather
have something that I can easily read and convince myself that it does
the right thing rather than merge something that I'm suspicious of.

In other words, we fix it.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
