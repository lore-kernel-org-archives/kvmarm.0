From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 12/45] KVM: arm/arm64: vgic-new: Add MMIO handling
 framework
Date: Thu, 31 Mar 2016 11:08:24 +0200
Message-ID: <20160331090824.GR4126@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-13-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93FCB40FA7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 05:07:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B6SU+UfX3izD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Mar 2016 05:07:20 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F39EE40C9A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 05:07:19 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id r72so132032290wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2016 02:08:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1458871508-17279-13-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

[cc'ing Paolo here for his thoughts on the KVM IO bus framework]

On Fri, Mar 25, 2016 at 02:04:35AM +0000, Andre Przywara wrote:
> We register each register group of the distributor and redistributors
> as separate regions of the kvm-io-bus framework. This way calls get
> directly handed over to the actual handler.
> This puts a lot more regions into kvm-io-bus than what we use at the
> moment on other architectures, so we will probably need to revisit the
> implementation of the framework later to be more efficient.

Looking more carefully at the KVM IO bus stuff, it looks like it is
indeed designed to be a *per device* thing you register, not a *per
register* thing.

My comments to Vladimir's bug report notwithstanding, there's still a
choice here to:

1) Expand/modify the KVM IO bus framework to take an arbitrary number of devices

2) Build a KVM architectureal generic framework on top of the IO bus
framework to handle individual register regions.

3) Stick with what we had before, do not modify the KVM IO bus stuff,
and handle the individual register region business locally within the
arm/vgic code.


> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> ---
>  include/kvm/vgic/vgic.h       |   9 ++
>  virt/kvm/arm/vgic/vgic_mmio.c | 194 ++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic_mmio.h |  47 ++++++++++
>  3 files changed, 250 insertions(+)
>  create mode 100644 virt/kvm/arm/vgic/vgic_mmio.c
>  create mode 100644 virt/kvm/arm/vgic/vgic_mmio.h
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 2ce9b4a..a8262c7 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -106,6 +106,12 @@ struct vgic_irq {
>  	enum vgic_irq_config config;	/* Level or edge */
>  };
>  
> +struct vgic_io_device {
> +	gpa_t base_addr;
> +	struct kvm_vcpu *redist_vcpu;
> +	struct kvm_io_device dev;
> +};
> +
>  struct vgic_dist {
>  	bool			in_kernel;
>  	bool			ready;
> @@ -132,6 +138,9 @@ struct vgic_dist {
>  	u32			enabled;
>  
>  	struct vgic_irq		*spis;
> +
> +	struct vgic_io_device	*dist_iodevs;
> +	struct vgic_io_device	*redist_iodevs;
>  };
>  
>  struct vgic_v2_cpu_if {
> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> new file mode 100644
> index 0000000..26c46e7
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> @@ -0,0 +1,194 @@
> +/*
> + * VGIC MMIO handling functions
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <kvm/iodev.h>
> +#include <kvm/vgic/vgic.h>
> +#include <linux/bitops.h>
> +#include <linux/irqchip/arm-gic.h>
> +
> +#include "vgic.h"
> +#include "vgic_mmio.h"
> +
> +void write_mask32(u32 value, int offset, int len, void *val)
> +{
> +	value = cpu_to_le32(value) >> (offset * 8);
> +	memcpy(val, &value, len);
> +}
> +
> +u32 mask32(u32 origvalue, int offset, int len, const void *val)
> +{
> +	origvalue &= ~((BIT_ULL(len) - 1) << (offset * 8));
> +	memcpy((char *)&origvalue + (offset * 8), val, len);
> +	return origvalue;
> +}
> +
> +#ifdef CONFIG_KVM_ARM_VGIC_V3
> +void write_mask64(u64 value, int offset, int len, void *val)
> +{
> +	value = cpu_to_le64(value) >> (offset * 8);
> +	memcpy(val, &value, len);
> +}
> +
> +/* FIXME: I am clearly misguided here, there must be some saner way ... */

I'm confuses in general.  Can you explain what these mask functions do
overall at some higher level?

I also keep having a feeling that mixing endianness stuff into the
emulation code itself is the wrong way to go about it.  The emulation
code should just deal with register values of varying length and the
interface to the VGIC should abstract all endianness nonsense for us,
but I also think I've lost this argument some time in the past.  Sigh.

But, is the maximum read/write unit for any MMIO access not a 64-bit
value?  So why can't we let the VGIC emulation code simply take/return a
u64 which is then masked off/morphed into the right endianness outside
the VGIC code?

> +u64 mask64(u64 origvalue, int offset, int len, const void *val)
> +{
> +	origvalue &= ~((BIT_ULL(len) - 1) << (offset * 8));
> +	memcpy((char *)&origvalue + (offset * 8), val, len);
> +	return origvalue;
> +}
> +#endif
> +
> +int vgic_mmio_read_raz(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
> +		       gpa_t addr, int len, void *val)
> +{
> +	memset(val, 0, len);
> +
> +	return 0;
> +}
> +
> +int vgic_mmio_write_wi(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
> +		       gpa_t addr, int len, const void *val)
> +{
> +	return 0;
> +}

I dislike the use of 'this' as a parameter name, why not 'dev' ?

> +
> +static int vgic_mmio_read_nyi(struct kvm_vcpu *vcpu,
> +			      struct kvm_io_device *this,
> +			      gpa_t addr, int len, void *val)
> +{
> +	pr_warn("KVM: handling unimplemented VGIC MMIO read: VCPU %d, address: 0x%llx\n",
> +		vcpu->vcpu_id, (unsigned long long)addr);
> +	return 0;
> +}
> +
> +static int vgic_mmio_write_nyi(struct kvm_vcpu *vcpu,
> +			       struct kvm_io_device *this,
> +			       gpa_t addr, int len, const void *val)
> +{
> +	pr_warn("KVM: handling unimplemented VGIC MMIO write: VCPU %d, address: 0x%llx\n",
> +		vcpu->vcpu_id, (unsigned long long)addr);
> +	return 0;
> +}
> +
> +struct vgic_register_region vgic_v2_dist_registers[] = {
> +	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
> +		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 12),
> +	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
> +	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
> +		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
> +	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_CLEAR,
> +		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
> +	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
> +		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
> +	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
> +		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
> +	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
> +		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
> +	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
> +		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
> +	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
> +		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 8),
> +	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
> +		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 8),
> +	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
> +		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 8),
> +	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
> +		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 4),
> +	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR,
> +		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 16),
> +	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_SET,
> +		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 16),
> +};
> +
> +int kvm_vgic_register_mmio_region(struct kvm *kvm, struct kvm_vcpu *vcpu,
> +				  struct vgic_register_region *reg_desc,
> +				  struct vgic_io_device *region,
> +				  int nr_irqs, bool offset_private)
> +{
> +	int bpi = reg_desc->bits_per_irq;
> +	int offset = 0;
> +	int len, ret;
> +
> +	region->base_addr	+= reg_desc->reg_offset;
> +	region->redist_vcpu	= vcpu;
> +
> +	kvm_iodevice_init(&region->dev, &reg_desc->ops);
> +
> +	if (bpi) {
> +		len = (bpi * nr_irqs) / 8;
> +		if (offset_private)
> +			offset = (bpi * VGIC_NR_PRIVATE_IRQS) / 8;
> +	} else {
> +		len = reg_desc->len;
> +	}
> +
> +	mutex_lock(&kvm->slots_lock);
> +	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS,
> +				      region->base_addr + offset,
> +				      len - offset, &region->dev);
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	return ret;
> +}
> +
> +int vgic_register_dist_regions(struct kvm *kvm, gpa_t dist_base_address,
> +			       enum vgic_type type)
> +{
> +	struct vgic_io_device *regions;
> +	struct vgic_register_region *reg_desc;
> +	int nr_regions;
> +	int nr_irqs = kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
> +	int i;
> +	int ret = 0;
> +
> +	switch (type) {
> +	case VGIC_V2:
> +		reg_desc = vgic_v2_dist_registers;
> +		nr_regions = ARRAY_SIZE(vgic_v2_dist_registers);
> +		break;
> +	default:
> +		BUG_ON(1);
> +	}
> +
> +	regions = kmalloc_array(nr_regions, sizeof(struct vgic_io_device),
> +				GFP_KERNEL);
> +	if (!regions)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < nr_regions; i++) {
> +		regions[i].base_addr	= dist_base_address;
> +
> +		ret = kvm_vgic_register_mmio_region(kvm, NULL, reg_desc,
> +						    regions + i, nr_irqs,
> +						    type == VGIC_V3);
> +		if (ret)
> +			break;
> +
> +		reg_desc++;
> +	}
> +
> +	if (ret) {
> +		mutex_lock(&kvm->slots_lock);
> +		for (i--; i >= 0; i--)
> +			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
> +						  &regions[i].dev);
> +		mutex_unlock(&kvm->slots_lock);
> +	} else {
> +		kvm->arch.vgic.dist_iodevs = regions;
> +	}
> +
> +	return ret;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic_mmio.h b/virt/kvm/arm/vgic/vgic_mmio.h
> new file mode 100644
> index 0000000..cf2314c
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic_mmio.h
> @@ -0,0 +1,47 @@
> +/*
> + * Copyright (C) 2015, 2016 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __KVM_ARM_VGIC_MMIO_H__
> +#define __KVM_ARM_VGIC_MMIO_H__
> +
> +struct vgic_register_region {
> +	int reg_offset;
> +	int len;
> +	int bits_per_irq;
> +	struct kvm_io_device_ops ops;
> +};
> +
> +#define REGISTER_DESC_WITH_BITS_PER_IRQ(name, read_ops, write_ops, bpi) \
> +	{.reg_offset = name, .bits_per_irq = bpi, .len = 0, \
> +	 .ops.read = read_ops, .ops.write = write_ops}
> +#define REGISTER_DESC_WITH_LENGTH(name, read_ops, write_ops, length) \
> +	{.reg_offset = name, .bits_per_irq = 0, .len = length, \
> +	 .ops.read = read_ops, .ops.write = write_ops}
> +
> +int vgic_mmio_read_raz(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
> +		       gpa_t addr, int len, void *val);
> +int vgic_mmio_write_wi(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
> +		       gpa_t addr, int len, const void *val);
> +int kvm_vgic_register_mmio_region(struct kvm *kvm, struct kvm_vcpu *vcpu,
> +				  struct vgic_register_region *reg_desc,
> +				  struct vgic_io_device *region,
> +				  int nr_irqs, bool offset_private);
> +
> +void write_mask32(u32 value, int offset, int len, void *val);
> +void write_mask64(u64 value, int offset, int len, void *val);
> +u32 mask32(u32 origvalue, int offset, int len, const void *val);
> +u64 mask64(u64 origvalue, int offset, int len, const void *val);
> +
> +#endif
> -- 
> 2.7.3
> 
> 

Thanks,
-Christoffer
