From: "Chalamarla, Tirumalesh" <Tirumalesh.Chalamarla@cavium.com>
Subject: Re: [PATCH v3 32/55] KVM: arm/arm64: vgic-new: Add GICv3 MMIO
 handling framework
Date: Mon, 9 May 2016 17:51:04 +0000
Message-ID: <9CD2D565-5046-4366-9CB5-A08C5D7B1909@caviumnetworks.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-33-git-send-email-andre.przywara@arm.com>
 <5730C65D.5000609@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6AFB49B99
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2016 13:48:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nVJ0lTfHL2tr for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2016 13:48:13 -0400 (EDT)
Received: from na01-bl2-obe.outbound.protection.outlook.com
 (mail-bl2on0070.outbound.protection.outlook.com [65.55.169.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F90D49B2E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2016 13:48:13 -0400 (EDT)
In-Reply-To: <5730C65D.5000609@arm.com>
Content-Language: en-US
Content-ID: <C8C16026A01BC643896E6736C80AF237@namprd07.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu






On 5/9/16, 10:18 AM, "kvmarm-bounces@lists.cs.columbia.edu on behalf of Marc Zyngier" <kvmarm-bounces@lists.cs.columbia.edu on behalf of marc.zyngier@arm.com> wrote:

>On 06/05/16 11:45, Andre Przywara wrote:
>> Create a new file called vgic-mmio-v3.c and describe the GICv3
>> distributor and redistributor registers there.
>> This adds a special macro to deal with the split of SGI/PPI in the
>> redistributor and SPIs in the distributor, which allows us to reuse
>> the existing GICv2 handlers for those registers which are compatible.
>> Also we provide a function to deal with the registration of the two
>> separate redistributor frames per VCPU.
>> 
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> Reviewed-by: Eric Auger <eric.auger@linaro.org>
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
>> Changelog v2 .. v3:
>> - replace inclusion of kvm/vgic/vgic.h with kvm/arm_vgic.h
>> - add prototype and stub code for vgic_register_redist_iodevs
>> - rename register struct variables _rdbase_ and _sgibase_
>> 
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 191 +++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic-mmio.c    |   5 +
>>  virt/kvm/arm/vgic/vgic-mmio.h    |   2 +
>>  virt/kvm/arm/vgic/vgic.h         |   7 ++
>>  4 files changed, 205 insertions(+)
>>  create mode 100644 virt/kvm/arm/vgic/vgic-mmio-v3.c
>> 
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> new file mode 100644
>> index 0000000..06c7ec5
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
>> +#include <kvm/arm_vgic.h>
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
>> +static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
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
>> +static const struct vgic_register_region vgic_v3_sgibase_registers[] = {
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
>> +		device->regions = vgic_v3_rdbase_registers;
>> +		device->nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
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
>> +		device->regions = vgic_v3_sgibase_registers;
>> +		device->nr_regions = ARRAY_SIZE(vgic_v3_sgibase_registers);
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
>
>What I fail to see here is what prevents the redistributor range from
>overlapping with the distributor (or any other device). The kvm IO bus
>is happy with overlapping addresses, but I'm not sure at all that this
>is safe.
>
>Care to shed some light on it?

Added the same question on wrong patch last week, thanks Marc. 
>
>Thanks,
>
>	M.
>-- 
>Jazz is not dead. It just smells funny...
>_______________________________________________
>kvmarm mailing list
>kvmarm@lists.cs.columbia.edu
>https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
