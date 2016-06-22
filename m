From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v6 07/15] KVM: arm64: introduce ITS emulation file with
 MMIO framework
Date: Wed, 22 Jun 2016 16:03:40 +0100
Message-ID: <a740fdaf-194f-f55a-6548-04f1c320a8a2@arm.com>
References: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
 <1466165327-32060-8-git-send-email-andre.przywara@arm.com>
 <576AA558.2000208@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA91C49B21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 10:58:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9b+2DLEiCJYZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2016 10:58:01 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E822749B1D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2016 10:58:00 -0400 (EDT)
In-Reply-To: <576AA558.2000208@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 22/06/16 15:48, Marc Zyngier wrote:
> On 17/06/16 13:08, Andre Przywara wrote:
>> The ARM GICv3 ITS emulation code goes into a separate file, but needs
>> to be connected to the GICv3 emulation, of which it is an option.
>> The ITS MMIO handlers require the respective ITS pointer to be passed in,
>> so we amend the existing VGIC MMIO framework to let it cope with that.
>> Also we introduce the basic ITS data structure and initialize it, but
>> don't return any success yet, as we are not yet ready for the show.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  arch/arm64/kvm/Makefile            |   1 +
>>  include/kvm/vgic/vgic.h            |  13 ++++-
>>  include/linux/irqchip/arm-gic-v3.h |   1 +
>>  virt/kvm/arm/vgic/vgic-its.c       | 107 +++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c   |  38 ++++++++++++-
>>  virt/kvm/arm/vgic/vgic-mmio.c      |  25 ++++++---
>>  virt/kvm/arm/vgic/vgic-mmio.h      |   4 ++
>>  virt/kvm/arm/vgic/vgic.h           |   7 +++
>>  8 files changed, 187 insertions(+), 9 deletions(-)
>>  create mode 100644 virt/kvm/arm/vgic/vgic-its.c
>>
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index a7a958c..2755d17 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -30,6 +30,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v2.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
>> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
>>  else
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2.o
>> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
>> index dc7f2fd..a66ba9a 100644
>> --- a/include/kvm/vgic/vgic.h
>> +++ b/include/kvm/vgic/vgic.h
>> @@ -111,12 +111,23 @@ struct vgic_register_region;
>>  
>>  struct vgic_io_device {
>>  	gpa_t base_addr;
>> -	struct kvm_vcpu *redist_vcpu;
>> +	union {
>> +		struct kvm_vcpu *redist_vcpu;
>> +		struct vgic_its *its;
>> +	};
>>  	const struct vgic_register_region *regions;
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
> 
> You may want to move this definition before struct vgic_io_device, some
> compilers are more picky than some others.

Mmh, I just see that this is actually circular here.
So shall I add an opaque declaration for struct vgic_its above?

> 
>> +
>>  struct vgic_dist {
>>  	bool			in_kernel;
>>  	bool			ready;
>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>> index 64e8c70..92d5da8 100644
>> --- a/include/linux/irqchip/arm-gic-v3.h
>> +++ b/include/linux/irqchip/arm-gic-v3.h
>> @@ -176,6 +176,7 @@
>>  #define GITS_CWRITER			0x0088
>>  #define GITS_CREADR			0x0090
>>  #define GITS_BASER			0x0100
>> +#define GITS_IDREGS_BASE		0xffd0
> 
> Please make all the changes to the core GIC code in a separate patch,
> which I can pick independently.

Sure.

> 
>>  #define GITS_PIDR2			GICR_PIDR2
>>  
>>  #define GITS_TRANSLATER			0x10040
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> new file mode 100644
>> index 0000000..c02d9df
>> --- /dev/null
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -0,0 +1,107 @@
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
>> +	.read = NULL,						\
>> +	.write = NULL,						\
>> +	.its_read = rd,						\
>> +	.its_write = wr,					\
> 
> Meh. That's not very nice... Why can't they be a union?

We can, but we would need another differentiator then (as you suggested
below).

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
>> +struct vgic_register_region its_registers[] = {
> 
> Shouldn't this be static?

Indeed, looks like a rebase artefact (I had the registration in another
file during some rework attempts).

> 
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
>> +int vits_register(struct kvm *kvm, struct vgic_its *its)
>> +{
>> +	struct vgic_io_device *iodev = &its->iodev;
>> +	int ret;
>> +
>> +	iodev->regions = its_registers;
>> +	iodev->nr_regions = ARRAY_SIZE(its_registers);
>> +	kvm_iodevice_init(&iodev->dev, &kvm_io_gic_ops);
>> +
>> +	iodev->base_addr = its->vgic_its_base;
>> +	iodev->its = its;
>> +	mutex_lock(&kvm->slots_lock);
>> +	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, iodev->base_addr,
>> +				      SZ_64K, &iodev->dev);
>> +	mutex_unlock(&kvm->slots_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +void vits_destroy(struct kvm *kvm, struct vgic_its *its)
>> +{
>> +
>> +	its->enabled = false;
>> +}
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index 8cd7190..4eee0d7 100644
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
>> @@ -126,6 +136,32 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
>>  	vgic_put_irq(irq);
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
>> @@ -325,7 +361,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
>>  
>>  static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
>>  	REGISTER_DESC_WITH_LENGTH(GICR_CTLR,
>> -		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
>> +		vgic_mmio_read_v3r_ctlr, vgic_mmio_write_v3r_ctlr, 4,
>>  		VGIC_ACCESS_32bit),
>>  	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
>>  		vgic_mmio_read_v3r_iidr, vgic_mmio_write_wi, 4,
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
>> index 4050c1c..c98a4fd 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
>> @@ -461,8 +461,7 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>>  {
>>  	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
>>  	const struct vgic_register_region *region;
>> -	struct kvm_vcpu *r_vcpu;
>> -	unsigned long data;
>> +	unsigned long data = 0;
>>  
>>  	region = vgic_find_mmio_region(iodev->regions, iodev->nr_regions,
>>  				       addr - iodev->base_addr);
>> @@ -471,8 +470,15 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>>  		return 0;
>>  	}
>>  
>> -	r_vcpu = iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
>> -	data = region->read(r_vcpu, addr, len);
>> +	if (region->read) {
>> +		struct kvm_vcpu *r_vcpu;
>> +
>> +		r_vcpu = iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
>> +		data = region->read(r_vcpu, addr, len);
>> +	} else if (region->its_read) {
>> +		data = region->its_read(vcpu->kvm, iodev->its, addr, len);
>> +	}
> 
> I'd rather have a flag somewhere that allows us to identify the type of
> device we're dealing with. You could have something like:
> 
> enum iodev_type {
> 	IODEV_VGIC_DISTRIBUTOR,
> 	IODEV_VGIC_REDISTRIBUTOR,
> 	IODEV_VGIC_ITS,
> };
> 
> assign the type to each region we have, and then have something like:
> 
> 	switch (region->iodev_type) {
> 	case IODEV_VGIC_DISTRIBUTOR:
> 		data = region->read(vcpu, addr, len);
> 		break;
> 	case IODEV_VGIC_REDISTRIBUTOR:
> 		data = region->read(iodev->redist_vcpu, addr, len);
> 		break;
> 	case IODEV_VGIC_ITS:
> 		data = region->its_read(vcpu->kvm, iodev->its, addr, len);
> 		break;
> 	}
> 
> It would make it extensible *and* readable.

Agreed, will fix it.

Cheers,
Andre.

>> +
>>  	vgic_data_host_to_mmio_bus(val, len, data);
>>  	return 0;
>>  }
>> @@ -482,7 +488,6 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>>  {
>>  	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
>>  	const struct vgic_register_region *region;
>> -	struct kvm_vcpu *r_vcpu;
>>  	unsigned long data = vgic_data_mmio_bus_to_host(val, len);
>>  
>>  	region = vgic_find_mmio_region(iodev->regions, iodev->nr_regions,
>> @@ -493,8 +498,14 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>>  	if (!check_region(region, addr, len))
>>  		return 0;
>>  
>> -	r_vcpu = iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
>> -	region->write(r_vcpu, addr, len, data);
>> +	if (region->write) {
>> +		struct kvm_vcpu *r_vcpu;
>> +
>> +		r_vcpu = iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
>> +		region->write(r_vcpu, addr, len, data);
>> +	} else if (region->its_write) {
>> +		region->its_write(vcpu->kvm, iodev->its, addr, len, data);
>> +	}
> 
> Same here.
> 
>>  	return 0;
>>  }
>>  
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
>> index 8509014..6dfc2f0 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio.h
>> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
>> @@ -25,6 +25,10 @@ struct vgic_register_region {
>>  			      unsigned int len);
>>  	void (*write)(struct kvm_vcpu *vcpu, gpa_t addr, unsigned int len,
>>  		      unsigned long val);
>> +	unsigned long (*its_read)(struct kvm *kvm, struct vgic_its *its,
>> +				  gpa_t addr, unsigned int len);
>> +	void (*its_write)(struct kvm *kvm, struct vgic_its *its,
>> +			  gpa_t addr, unsigned int len, unsigned long val);
>>  };
>>  
>>  extern struct kvm_io_device_ops kvm_io_gic_ops;
>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
>> index fa2d225..b09590d 100644
>> --- a/virt/kvm/arm/vgic/vgic.h
>> +++ b/virt/kvm/arm/vgic/vgic.h
>> @@ -76,6 +76,7 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu);
>>  int vgic_v3_probe(const struct gic_kvm_info *info);
>>  int vgic_v3_map_resources(struct kvm *kvm);
>>  int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
>> +bool vgic_has_its(struct kvm *kvm);
>>  #else
>>  static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
>>  {
>> @@ -127,6 +128,12 @@ static inline int vgic_register_redist_iodevs(struct kvm *kvm,
>>  {
>>  	return -ENODEV;
>>  }
>> +
>> +static inline bool vgic_has_its(struct kvm *kvm)
>> +{
>> +	return false;
>> +}
>> +
>>  #endif
>>  
>>  int kvm_register_vgic_device(unsigned long type);
>>
> 
> Thanks,
> 
> 	M.
> 
