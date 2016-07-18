From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v10 09/17] KVM: arm64: introduce ITS emulation file with
 MMIO framework
Date: Mon, 18 Jul 2016 10:43:54 +0100
Message-ID: <578CA4DA.50005@arm.com>
References: <20160715114338.10484-1-andre.przywara@arm.com>
 <20160715114338.10484-10-andre.przywara@arm.com>
 <5a1405f7-201c-6f8c-0b16-c64a192dc5f0@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5a1405f7-201c-6f8c-0b16-c64a192dc5f0@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 18/07/16 10:18, Auger Eric wrote:
> Hi Andre, Marc,
> 
> On 15/07/2016 13:43, Andre Przywara wrote:
>> The ARM GICv3 ITS emulation code goes into a separate file, but needs
>> to be connected to the GICv3 emulation, of which it is an option.
>> The ITS MMIO handlers require the respective ITS pointer to be passed in,
>> so we amend the existing VGIC MMIO framework to let it cope with that.
>> Also we introduce the basic ITS data structure and initialize it, but
>> don't return any success yet, as we are not yet ready for the show.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  include/kvm/arm_vgic.h           |  22 ++++++++-
>>  virt/kvm/arm/vgic/vgic-its.c     | 103 +++++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c |  40 ++++++++++++++-
>>  virt/kvm/arm/vgic/vgic-mmio.c    |  37 +++++++++++---
>>  virt/kvm/arm/vgic/vgic-mmio.h    |  17 +++++--
>>  virt/kvm/arm/vgic/vgic.h         |   7 +++
>>  6 files changed, 213 insertions(+), 13 deletions(-)
>>  create mode 100644 virt/kvm/arm/vgic/vgic-its.c
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index df2dec5..685f339 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -108,15 +108,35 @@ struct vgic_irq {
>>  };
>>  
>>  struct vgic_register_region;
>> +struct vgic_its;
>> +
>> +enum iodev_type {
>> +	IODEV_CPUIF,
>> +	IODEV_DIST,
>> +	IODEV_REDIST,
>> +	IODEV_ITS
>> +};
>>  
>>  struct vgic_io_device {
>>  	gpa_t base_addr;
>> -	struct kvm_vcpu *redist_vcpu;
>> +	union {
>> +		struct kvm_vcpu *redist_vcpu;
>> +		struct vgic_its *its;
>> +	};
>>  	const struct vgic_register_region *regions;
>> +	enum iodev_type iodev_type;
>>  	int nr_regions;
>>  	struct kvm_io_device dev;
>>  };
>>  
>> +struct vgic_its {
>> +	/* The base address of the ITS control register frame */
>> +	gpa_t			vgic_its_base;
>> +
>> +	bool			enabled;
>> +	struct vgic_io_device	iodev;
>> +};
>> +
>>  struct vgic_dist {
>>  	bool			in_kernel;
>>  	bool			ready;
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> new file mode 100644
>> index 0000000..4654d6e
>> --- /dev/null
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -0,0 +1,103 @@
>> +/*
>> + * GICv3 ITS emulation
>> + *
>> + * Copyright (C) 2015,2016 ARM Ltd.
>> + * Author: Andre Przywara <andre.przywara@arm.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/cpu.h>
>> +#include <linux/kvm.h>
>> +#include <linux/kvm_host.h>
>> +#include <linux/interrupt.h>
>> +
>> +#include <linux/irqchip/arm-gic-v3.h>
>> +
>> +#include <asm/kvm_emulate.h>
>> +#include <asm/kvm_arm.h>
>> +#include <asm/kvm_mmu.h>
>> +
>> +#include "vgic.h"
>> +#include "vgic-mmio.h"
>> +
>> +#define REGISTER_ITS_DESC(off, rd, wr, length, acc)		\
>> +{								\
>> +	.reg_offset = off,					\
>> +	.len = length,						\
>> +	.access_flags = acc,					\
>> +	.its_read = rd,						\
>> +	.its_write = wr,					\
>> +}
>> +
>> +static unsigned long its_mmio_read_raz(struct kvm *kvm, struct vgic_its *its,
>> +				       gpa_t addr, unsigned int len)
>> +{
>> +	return 0;
>> +}
>> +
>> +static void its_mmio_write_wi(struct kvm *kvm, struct vgic_its *its,
>> +			      gpa_t addr, unsigned int len, unsigned long val)
>> +{
>> +	/* Ignore */
>> +}
>> +
>> +static struct vgic_register_region its_registers[] = {
>> +	REGISTER_ITS_DESC(GITS_CTLR,
>> +		its_mmio_read_raz, its_mmio_write_wi, 4,
>> +		VGIC_ACCESS_32bit),
>> +	REGISTER_ITS_DESC(GITS_IIDR,
>> +		its_mmio_read_raz, its_mmio_write_wi, 4,
>> +		VGIC_ACCESS_32bit),
>> +	REGISTER_ITS_DESC(GITS_TYPER,
>> +		its_mmio_read_raz, its_mmio_write_wi, 8,
>> +		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>> +	REGISTER_ITS_DESC(GITS_CBASER,
>> +		its_mmio_read_raz, its_mmio_write_wi, 8,
>> +		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>> +	REGISTER_ITS_DESC(GITS_CWRITER,
>> +		its_mmio_read_raz, its_mmio_write_wi, 8,
>> +		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>> +	REGISTER_ITS_DESC(GITS_CREADR,
>> +		its_mmio_read_raz, its_mmio_write_wi, 8,
>> +		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>> +	REGISTER_ITS_DESC(GITS_BASER,
>> +		its_mmio_read_raz, its_mmio_write_wi, 0x40,
>> +		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
>> +	REGISTER_ITS_DESC(GITS_IDREGS_BASE,
>> +		its_mmio_read_raz, its_mmio_write_wi, 0x30,
>> +		VGIC_ACCESS_32bit),
>> +};
>> +
>> +static int vgic_its_init_its(struct kvm *kvm, struct vgic_its *its)
>> +{
>> +	struct vgic_io_device *iodev = &its->iodev;
>> +	int ret;
>> +
>> +	if (IS_VGIC_ADDR_UNDEF(its->vgic_its_base))
>> +		return -ENXIO;
>> +
>> +	iodev->regions = its_registers;
>> +	iodev->nr_regions = ARRAY_SIZE(its_registers);
>> +	kvm_iodevice_init(&iodev->dev, &kvm_io_gic_ops);
>> +
>> +	iodev->base_addr = its->vgic_its_base;
>> +	iodev->iodev_type = IODEV_ITS;
>> +	iodev->its = its;
>> +	mutex_lock(&kvm->slots_lock);
>> +	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, iodev->base_addr,
>> +				      KVM_VGIC_V3_ITS_SIZE, &iodev->dev);
>> +	mutex_unlock(&kvm->slots_lock);
>> +
>> +	return ret;
>> +}
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index 278bfbb..b92b7d6 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -42,6 +42,16 @@ static u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
>>  	return reg | ((u64)val << lower);
>>  }
>>  
>> +bool vgic_has_its(struct kvm *kvm)
>> +{
>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>> +
>> +	if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
>> +		return false;
>> +
>> +	return false;
>> +}
>> +
>>  static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
>>  					    gpa_t addr, unsigned int len)
>>  {
>> @@ -132,6 +142,32 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
>>  	vgic_put_irq(vcpu->kvm, irq);
>>  }
>>  
>> +static unsigned long vgic_mmio_read_v3r_ctlr(struct kvm_vcpu *vcpu,
>> +					     gpa_t addr, unsigned int len)
>> +{
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +
>> +	return vgic_cpu->lpis_enabled ? GICR_CTLR_ENABLE_LPIS : 0;
>> +}
>> +
>> +
>> +static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
>> +				     gpa_t addr, unsigned int len,
>> +				     unsigned long val)
>> +{
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +	bool was_enabled = vgic_cpu->lpis_enabled;
>> +
>> +	if (!vgic_has_its(vcpu->kvm))
>> +		return;
>> +
>> +	vgic_cpu->lpis_enabled = val & GICR_CTLR_ENABLE_LPIS;
>> +
>> +	if (!was_enabled && vgic_cpu->lpis_enabled) {
>> +		/* Eventually do something */
>> +	}
>> +}
>> +
>>  static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
>>  					      gpa_t addr, unsigned int len)
>>  {
>> @@ -372,7 +408,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
>>  
>>  static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
>>  	REGISTER_DESC_WITH_LENGTH(GICR_CTLR,
>> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
>> +		vgic_mmio_read_v3r_ctlr, vgic_mmio_write_v3r_ctlr, 4,
>>  		VGIC_ACCESS_32bit),
>>  	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
>>  		vgic_mmio_read_v3r_iidr, vgic_mmio_write_wi, 4,
>> @@ -450,6 +486,7 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
>>  
>>  		kvm_iodevice_init(&rd_dev->dev, &kvm_io_gic_ops);
>>  		rd_dev->base_addr = rd_base;
>> +		rd_dev->iodev_type = IODEV_REDIST;
>>  		rd_dev->regions = vgic_v3_rdbase_registers;
>>  		rd_dev->nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
>>  		rd_dev->redist_vcpu = vcpu;
>> @@ -464,6 +501,7 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
>>  
>>  		kvm_iodevice_init(&sgi_dev->dev, &kvm_io_gic_ops);
>>  		sgi_dev->base_addr = sgi_base;
>> +		sgi_dev->iodev_type = IODEV_REDIST;
>>  		sgi_dev->regions = vgic_v3_sgibase_registers;
>>  		sgi_dev->nr_regions = ARRAY_SIZE(vgic_v3_sgibase_registers);
>>  		sgi_dev->redist_vcpu = vcpu;
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
>> index 5e79e01..26be827 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
>> @@ -473,8 +473,7 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>>  {
>>  	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
>>  	const struct vgic_register_region *region;
>> -	struct kvm_vcpu *r_vcpu;
>> -	unsigned long data;
>> +	unsigned long data = 0;
>>  
>>  	region = vgic_find_mmio_region(iodev->regions, iodev->nr_regions,
>>  				       addr - iodev->base_addr);
>> @@ -483,8 +482,20 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>>  		return 0;
>>  	}
>>  
>> -	r_vcpu = iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
>> -	data = region->read(r_vcpu, addr, len);
>> +	switch (iodev->iodev_type) {
>> +	case IODEV_CPUIF:
>> +		return 1;
> This change causes a regression on AMD Seattle with QEMU (abort with
> message "restoring 288 IRQs, but kernel supports max 32").
> Shoudn't we have
> 		data = region->read(vcpu, addr, len);
> 		break;
> This path is exercised by vgic_v2_cpuif_uaccess/vgic_uaccess

Bloody hell. Andre, have you even tested this?

>> +	case IODEV_DIST:
>> +		data = region->read(vcpu, addr, len);
>> +		break;
>> +	case IODEV_REDIST:
>> +		data = region->read(iodev->redist_vcpu, addr, len);
>> +		break;
>> +	case IODEV_ITS:
>> +		data = region->its_read(vcpu->kvm, iodev->its, addr, len);
>> +		break;
>> +	}
>> +
>>  	vgic_data_host_to_mmio_bus(val, len, data);
>>  	return 0;
>>  }
>> @@ -494,7 +505,6 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>>  {
>>  	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
>>  	const struct vgic_register_region *region;
>> -	struct kvm_vcpu *r_vcpu;
>>  	unsigned long data = vgic_data_mmio_bus_to_host(val, len);
>>  
>>  	region = vgic_find_mmio_region(iodev->regions, iodev->nr_regions,
>> @@ -505,8 +515,20 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>>  	if (!check_region(region, addr, len))
>>  		return 0;
>>  
>> -	r_vcpu = iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
>> -	region->write(r_vcpu, addr, len, data);
>> +	switch (iodev->iodev_type) {
>> +	case IODEV_CPUIF:
>> +		break;
> same here
> region->write(vcpu, addr, len, data);
> 
> The above modifications fix the issue.

Eric, can you please whip up a quick patch patch that I can stick on
top? Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
