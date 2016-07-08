From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 09/17] KVM: arm64: introduce ITS emulation file with
 MMIO framework
Date: Fri, 8 Jul 2016 14:55:37 +0100
Message-ID: <577FB0D9.6090109@arm.com>
References: <20160705112309.28877-1-andre.przywara@arm.com>
 <20160705112309.28877-10-andre.przywara@arm.com> <577FABF2.30302@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <577FABF2.30302@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 08/07/16 14:34, Marc Zyngier wrote:
> On 05/07/16 12:23, Andre Przywara wrote:
>> The ARM GICv3 ITS emulation code goes into a separate file, but needs
>> to be connected to the GICv3 emulation, of which it is an option.
>> The ITS MMIO handlers require the respective ITS pointer to be passed in,
>> so we amend the existing VGIC MMIO framework to let it cope with that.
>> Also we introduce the basic ITS data structure and initialize it, but
>> don't return any success yet, as we are not yet ready for the show.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  arch/arm64/kvm/Makefile          |   1 +
>>  include/kvm/arm_vgic.h           |  14 +++++-
>>  virt/kvm/arm/vgic/vgic-its.c     | 100 +++++++++++++++++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  40 +++++++--------
>>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 104 ++++++++++++++++++++++++++-------------
>>  virt/kvm/arm/vgic/vgic-mmio.c    |  36 +++++++++++---
>>  virt/kvm/arm/vgic/vgic-mmio.h    |  31 +++++++++---
>>  virt/kvm/arm/vgic/vgic.h         |   7 +++
>>  8 files changed, 266 insertions(+), 67 deletions(-)
>>  create mode 100644 virt/kvm/arm/vgic/vgic-its.c
>>
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index f00b2cd..a5b9664 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -29,5 +29,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v2.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
>> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index f6f860d..f606641 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -108,15 +108,27 @@ struct vgic_irq {
>>  };
>>  
>>  struct vgic_register_region;
>> +struct vgic_its;
>>  
>>  struct vgic_io_device {
>>  	gpa_t base_addr;
>> -	struct kvm_vcpu *redist_vcpu;
>> +	union {
>> +		struct kvm_vcpu *redist_vcpu;
>> +		struct vgic_its *its;
>> +	};
> 
> The only question that springs to mind is...
> 
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
>> +
>>  struct vgic_dist {
>>  	bool			in_kernel;
>>  	bool			ready;
>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>> new file mode 100644
>> index 0000000..ab8d244
>> --- /dev/null
>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>> @@ -0,0 +1,100 @@
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
>> +	.iodev_type = IODEV_ITS,				\
> 
> ... why isn't this at the device level? It doesn't make much sense to
> have it at the register level (we never access a register in isolation,
> we always access it relatively to a device).
> 
> And given that the *only* time you actually evaluate this flag is in
> dispatch_mmio_read/write, there is zero benefit in duplicating it all
> over the place.
> 
> Smaller structures, smaller patch. Am I missing something?

And for the record, here's what I've cooked on top of your patch:

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index c64db0f..95eab74 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -112,12 +112,20 @@ struct vgic_irq {
 struct vgic_register_region;
 struct vgic_its;
 
+enum iodev_type {
+	IODEV_CPUIF,
+	IODEV_DIST,
+	IODEV_REDIST,
+	IODEV_ITS,
+};
+
 struct vgic_io_device {
 	gpa_t base_addr;
 	union {
 		struct kvm_vcpu *redist_vcpu;
 		struct vgic_its *its;
 	};
+	enum iodev_type iodev_type;
 	const struct vgic_register_region *regions;
 	int nr_regions;
 	struct kvm_io_device dev;
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 4459a59..7c7d16b 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1162,7 +1162,6 @@ static void vgic_mmio_write_its_baser(struct kvm *kvm,
 	.reg_offset = off,					\
 	.len = length,						\
 	.access_flags = acc,					\
-	.iodev_type = IODEV_ITS,				\
 	.its_read = rd,						\
 	.its_write = wr,					\
 }
@@ -1219,6 +1218,7 @@ static int vgic_its_register(struct kvm *kvm, struct vgic_its *its)
 
 	iodev->regions = its_registers;
 	iodev->nr_regions = ARRAY_SIZE(its_registers);
+	iodev->iodev_type = IODEV_ITS;
 	kvm_iodevice_init(&iodev->dev, &kvm_io_gic_ops);
 
 	iodev->base_addr = its->vgic_its_base;
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index bca5bf7..52af312 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -360,6 +360,7 @@ unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev)
 {
 	dev->regions = vgic_v2_dist_registers;
 	dev->nr_regions = ARRAY_SIZE(vgic_v2_dist_registers);
+	dev->iodev_type = IODEV_DIST;
 
 	kvm_iodevice_init(&dev->dev, &kvm_io_gic_ops);
 
@@ -437,6 +438,7 @@ int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 	struct vgic_io_device dev = {
 		.regions = vgic_v2_cpu_registers,
 		.nr_regions = ARRAY_SIZE(vgic_v2_cpu_registers),
+		.iodev_type = IODEV_CPUIF,
 	};
 
 	return vgic_uaccess(vcpu, &dev, is_write, offset, val);
@@ -448,6 +450,7 @@ int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 	struct vgic_io_device dev = {
 		.regions = vgic_v2_dist_registers,
 		.nr_regions = ARRAY_SIZE(vgic_v2_dist_registers),
+		.iodev_type = IODEV_DIST,
 	};
 
 	return vgic_uaccess(vcpu, &dev, is_write, offset, val);
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index c7c7a87..d1d2020 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -346,7 +346,6 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
 		.bits_per_irq = bpi,					\
 		.len = (bpi * VGIC_NR_PRIVATE_IRQS) / 8,		\
 		.access_flags = acc,					\
-		.iodev_type = type,					\
 		.read = vgic_mmio_read_raz,				\
 		.write = vgic_mmio_write_wi,				\
 	}, {								\
@@ -354,7 +353,6 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
 		.bits_per_irq = bpi,					\
 		.len = (bpi * (1024 - VGIC_NR_PRIVATE_IRQS)) / 8,	\
 		.access_flags = acc,					\
-		.iodev_type = type,					\
 		.read = rd,						\
 		.write = wr,						\
 	}
@@ -465,6 +463,7 @@ unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev)
 {
 	dev->regions = vgic_v3_dist_registers;
 	dev->nr_regions = ARRAY_SIZE(vgic_v3_dist_registers);
+	dev->iodev_type = IODEV_DIST;
 
 	kvm_iodevice_init(&dev->dev, &kvm_io_gic_ops);
 
@@ -486,6 +485,7 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
 		rd_dev->base_addr = rd_base;
 		rd_dev->regions = vgic_v3_rdbase_registers;
 		rd_dev->nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
+		rd_dev->iodev_type = IODEV_REDIST;
 		rd_dev->redist_vcpu = vcpu;
 
 		mutex_lock(&kvm->slots_lock);
@@ -500,6 +500,7 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
 		sgi_dev->base_addr = sgi_base;
 		sgi_dev->regions = vgic_v3_sgibase_registers;
 		sgi_dev->nr_regions = ARRAY_SIZE(vgic_v3_sgibase_registers);
+		sgi_dev->iodev_type = IODEV_REDIST;
 		sgi_dev->redist_vcpu = vcpu;
 
 		mutex_lock(&kvm->slots_lock);
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index a097c1a..97bf8e7 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -482,7 +482,7 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 		return 0;
 	}
 
-	switch (region->iodev_type) {
+	switch (iodev->iodev_type) {
 	case IODEV_CPUIF:
 		return 1;
 	case IODEV_DIST:
@@ -515,7 +515,7 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 	if (!check_region(region, addr, len))
 		return 0;
 
-	switch (region->iodev_type) {
+	switch (iodev->iodev_type) {
 	case IODEV_CPUIF:
 		break;
 	case IODEV_DIST:
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 513bb5c..b6950f3 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -16,19 +16,11 @@
 #ifndef __KVM_ARM_VGIC_MMIO_H__
 #define __KVM_ARM_VGIC_MMIO_H__
 
-enum iodev_type {
-	IODEV_CPUIF,
-	IODEV_DIST,
-	IODEV_REDIST,
-	IODEV_ITS
-};
-
 struct vgic_register_region {
 	unsigned int reg_offset;
 	unsigned int len;
 	unsigned int bits_per_irq;
 	unsigned int access_flags;
-	enum iodev_type iodev_type;
 	union {
 		unsigned long (*read)(struct kvm_vcpu *vcpu, gpa_t addr,
 				      unsigned int len);
@@ -80,7 +72,6 @@ extern struct kvm_io_device_ops kvm_io_gic_ops;
 		.bits_per_irq = bpi,					\
 		.len = bpi * 1024 / 8,					\
 		.access_flags = acc,					\
-		.iodev_type = type,					\
 		.read = rd,						\
 		.write = wr,						\
 	}
@@ -91,7 +82,6 @@ extern struct kvm_io_device_ops kvm_io_gic_ops;
 		.bits_per_irq = 0,					\
 		.len = length,						\
 		.access_flags = acc,					\
-		.iodev_type = type,					\
 		.read = rd,						\
 		.write = wr,						\
 	}

It works exactly the same way, except that I don't have to type
each and every register. I'll leave you to clean the rest of the
patch! ;-)

	M.
-- 
Jazz is not dead. It just smells funny...
