From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 22/56] KVM: arm/arm64: vgic-new: Add MMIO handling
 framework
Date: Wed, 18 May 2016 15:12:33 +0100
Message-ID: <573C7851.4010401@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-23-git-send-email-andre.przywara@arm.com>
 <573B1DB0.7030901@arm.com> <20160518122521.GD3827@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160518122521.GD3827@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 18/05/16 13:25, Christoffer Dall wrote:
> On Tue, May 17, 2016 at 02:33:36PM +0100, Marc Zyngier wrote:
>> On 16/05/16 10:53, Andre Przywara wrote:
>>> From: Marc Zyngier <marc.zyngier@arm.com>
>>>
>>> Add an MMIO handling framework to the VGIC emulation:
>>> Each register is described by its offset, size (or number of bits p=
er
>>> IRQ, if applicable) and the read/write handler functions. We provid=
e
>>> initialization macros to describe each GIC register later easily.
>>>
>>> Separate dispatch functions for read and write accesses are connect=
ed
>>> to the kvm_io_bus framework and binary-search for the responsible
>>> register handler based on the offset address within the region.
>>> We convert the incoming data (referenced by a pointer) to the host'=
s
>>> endianess and use pass-by-value to hand the data over to the actual
>>> handler functions.
>>>
>>> The register handler prototype and the endianess conversion are
>>> courtesy of Christoffer Dall.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>> Changelog RFC..v1:
>>> - rework MMIO dispatching to use only one kvm_io_bus device
>>> - document purpose of register region macros
>>> - rename "this" parameter to "dev"
>>> - change IGROUPR to be RAO (returning 1 =3D> Group1 IRQs)
>>>
>>> Changelog v1 .. v2:
>>> * MASSIVE rework:
>>> - store register_region pointer in kvm_io_bus linked struct
>>> - replace write_mask_xxx functions with extract_bytes() implementat=
ion
>>> - change handler functions' prototypes to take and return unsigned =
long
>>> - use binary search to find matching register handler
>>> - convert endianess of input data in dispatch_mmio_xxx functions
>>> - improve readability of register initializer macros
>>> - remove any GICv2/GICv3 specific functions from vgic-mmio.c
>>> - rename file from vgic_mmio.c to vgic-mmio.c
>>>
>>> Changelog v2 .. v3:
>>> - replace inclusion of vgic/vgic.h with arm_vgic.h
>>>
>>> Changelog v3 .. v4:
>>> - add IRQ number accessor macro
>>> - check access width in dispatcher
>>> - treat non-covered MMIO addresses as RAZ/WI
>>> - remove extract_bytes() (re-introduced as static later in the seri=
es)
>>>
>>>  include/kvm/vgic/vgic.h       |  13 +++
>>>  virt/kvm/arm/vgic/vgic-mmio.c | 184 ++++++++++++++++++++++++++++++=
++++++++++++
>>>  virt/kvm/arm/vgic/vgic-mmio.h |  87 ++++++++++++++++++++
>>>  3 files changed, 284 insertions(+)
>>>  create mode 100644 virt/kvm/arm/vgic/vgic-mmio.c
>>>  create mode 100644 virt/kvm/arm/vgic/vgic-mmio.h
>>>
>>> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
>>> index f663288..ff3f9c2 100644
>>> --- a/include/kvm/vgic/vgic.h
>>> +++ b/include/kvm/vgic/vgic.h
>>> @@ -106,6 +106,16 @@ struct vgic_irq {
>>>  	enum vgic_irq_config config;	/* Level or edge */
>>>  };
>>> =20
>>> +struct vgic_register_region;
>>> +
>>> +struct vgic_io_device {
>>> +	gpa_t base_addr;
>>> +	struct kvm_vcpu *redist_vcpu;
>>> +	const struct vgic_register_region *regions;
>>> +	int nr_regions;
>>> +	struct kvm_io_device dev;
>>> +};
>>> +
>>>  struct vgic_dist {
>>>  	bool			in_kernel;
>>>  	bool			ready;
>>> @@ -132,6 +142,9 @@ struct vgic_dist {
>>>  	bool			enabled;
>>> =20
>>>  	struct vgic_irq		*spis;
>>> +
>>> +	struct vgic_io_device	dist_iodev;
>>> +	struct vgic_io_device	*redist_iodevs;
>>>  };
>>> =20
>>>  struct vgic_v2_cpu_if {
>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic=
-mmio.c
>>> new file mode 100644
>>> index 0000000..012b82b
>>> --- /dev/null
>>> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
>>> @@ -0,0 +1,184 @@
>>> +/*
>>> + * VGIC MMIO handling functions
>>> + *
>>> + * This program is free software; you can redistribute it and/or m=
odify
>>> + * it under the terms of the GNU General Public License version 2 =
as
>>> + * published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + */
>>> +
>>> +#include <linux/bitops.h>
>>> +#include <linux/bsearch.h>
>>> +#include <linux/kvm.h>
>>> +#include <linux/kvm_host.h>
>>> +#include <kvm/iodev.h>
>>> +#include <kvm/arm_vgic.h>
>>> +
>>> +#include "vgic.h"
>>> +#include "vgic-mmio.h"
>>> +
>>> +unsigned long vgic_mmio_read_raz(struct kvm_vcpu *vcpu,
>>> +				 gpa_t addr, unsigned int len)
>>> +{
>>> +	return 0;
>>> +}
>>> +
>>> +unsigned long vgic_mmio_read_rao(struct kvm_vcpu *vcpu,
>>> +				 gpa_t addr, unsigned int len)
>>> +{
>>> +	return -1UL;
>>> +}
>>> +
>>> +void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
>>> +			unsigned int len, unsigned long val)
>>> +{
>>> +	/* Ignore */
>>> +}
>>> +
>>> +static int match_region(const void *key, const void *elt)
>>> +{
>>> +	const unsigned int offset =3D (unsigned long)key;
>>> +	const struct vgic_register_region *region =3D elt;
>>> +
>>> +	if (offset < region->reg_offset)
>>> +		return -1;
>>> +
>>> +	if (offset >=3D region->reg_offset + region->len)
>>> +		return 1;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +/* Find the proper register handler entry given a certain address =
offset. */
>>> +static const struct vgic_register_region *
>>> +vgic_find_mmio_region(const struct vgic_register_region *region, i=
nt nr_regions,
>>> +		      unsigned int offset)
>>> +{
>>> +	return bsearch((void *)(uintptr_t)offset, region, nr_regions,
>>> +		       sizeof(region[0]), match_region);
>>> +}
>>> +
>>> +/*
>>> + * kvm_mmio_read_buf() returns a value in a format where it can be=
 converted
>>> + * to a byte array and be directly observed as the guest wanted it=
 to appear
>>> + * in memory if it had done the store itself, which is LE for the =
GIC, as the
>>> + * guest knows the GIC is always LE.
>>> + *
>>> + * We convert this value to the CPUs native format to deal with it=
 as a data
>>> + * value.
>>> + */
>>> +unsigned long vgic_data_mmio_bus_to_host(const void *val, unsigned=
 int len)
>>> +{
>>> +	unsigned long data =3D kvm_mmio_read_buf(val, len);
>>> +
>>> +	switch (len) {
>>> +	case 1:
>>> +		return data;
>>> +	case 2:
>>> +		return le16_to_cpu(data);
>>> +	case 4:
>>> +		return le32_to_cpu(data);
>>> +	default:
>>> +		return le64_to_cpu(data);
>>> +	}
>>> +}
>>> +
>>> +/*
>>> + * kvm_mmio_write_buf() expects a value in a format such that if c=
onverted to
>>> + * a byte array it is observed as the guest would see it if it cou=
ld perform
>>> + * the load directly.  Since the GIC is LE, and the guest knows th=
is, the
>>> + * guest expects a value in little endian format.
>>> + *
>>> + * We convert the data value from the CPUs native format to LE so =
that the
>>> + * value is returned in the proper format.
>>> + */
>>> +void vgic_data_host_to_mmio_bus(void *buf, unsigned int len,
>>> +				unsigned long data)
>>> +{
>>> +	switch (len) {
>>> +	case 1:
>>> +		break;
>>> +	case 2:
>>> +		data =3D cpu_to_le16(data);
>>> +		break;
>>> +	case 4:
>>> +		data =3D cpu_to_le32(data);
>>> +		break;
>>> +	default:
>>> +		data =3D cpu_to_le64(data);
>>> +	}
>>> +
>>> +	kvm_mmio_write_buf(buf, len, data);
>>> +}
>>> +
>>> +static
>>> +struct vgic_io_device *kvm_to_vgic_iodev(const struct kvm_io_devic=
e *dev)
>>> +{
>>> +	return container_of(dev, struct vgic_io_device, dev);
>>> +}
>>> +
>>> +static bool check_region(const struct vgic_register_region *region=
,
>>> +			 gpa_t addr, int len)
>>> +{
>>> +	if ((region->access_flags & VGIC_ACCESS_8bit) && len =3D=3D 1)
>>> +		return true;
>>> +	if ((region->access_flags & VGIC_ACCESS_32bit) &&
>>> +	    len =3D=3D sizeof(u32) && !(addr & 3))
>>> +		return true;
>>> +	if ((region->access_flags & VGIC_ACCESS_64bit) &&
>>> +	    len =3D=3D sizeof(u64) && !(addr & 7))
>>> +		return true;
>>> +
>>> +	return false;
>>> +}
>>> +
>>> +static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io=
_device *dev,
>>> +			      gpa_t addr, int len, void *val)
>>> +{
>>> +	struct vgic_io_device *iodev =3D kvm_to_vgic_iodev(dev);
>>> +	const struct vgic_register_region *region;
>>> +	struct kvm_vcpu *r_vcpu;
>>> +	unsigned long data;
>>> +
>>> +	region =3D vgic_find_mmio_region(iodev->regions, iodev->nr_region=
s,
>>> +				       addr - iodev->base_addr);
>>> +	if (!region || !check_region(region, addr, len)) {
>>> +		memset(val, 0, len);
>>> +		return 0;
>>> +	}
>>> +
>>> +	r_vcpu =3D iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
>>> +	data =3D region->read(r_vcpu, addr, len);
>>> +	vgic_data_host_to_mmio_bus(val, len, data);
>>> +	return 0;
>>> +}
>>> +
>>> +static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_i=
o_device *dev,
>>> +			       gpa_t addr, int len, const void *val)
>>> +{
>>> +	struct vgic_io_device *iodev =3D kvm_to_vgic_iodev(dev);
>>> +	const struct vgic_register_region *region;
>>> +	struct kvm_vcpu *r_vcpu;
>>> +	unsigned long data =3D vgic_data_mmio_bus_to_host(val, len);
>>> +
>>> +	region =3D vgic_find_mmio_region(iodev->regions, iodev->nr_region=
s,
>>> +				       addr - iodev->base_addr);
>>> +	if (!region)
>>> +		return 0;
>>> +
>>> +	if (!check_region(region, addr, len))
>>> +		return 0;
>>> +
>>> +	r_vcpu =3D iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
>>> +	region->write(r_vcpu, addr, len, data);
>>> +	return 0;
>>> +}
>>> +
>>> +struct kvm_io_device_ops kvm_io_gic_ops =3D {
>>> +	.read =3D dispatch_mmio_read,
>>> +	.write =3D dispatch_mmio_write,
>>> +};
>>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic=
-mmio.h
>>> new file mode 100644
>>> index 0000000..855b1db
>>> --- /dev/null
>>> +++ b/virt/kvm/arm/vgic/vgic-mmio.h
>>> @@ -0,0 +1,87 @@
>>> +/*
>>> + * Copyright (C) 2015, 2016 ARM Ltd.
>>> + *
>>> + * This program is free software; you can redistribute it and/or m=
odify
>>> + * it under the terms of the GNU General Public License version 2 =
as
>>> + * published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public Licen=
se
>>> + * along with this program.  If not, see <http://www.gnu.org/licen=
ses/>.
>>> + */
>>> +#ifndef __KVM_ARM_VGIC_MMIO_H__
>>> +#define __KVM_ARM_VGIC_MMIO_H__
>>> +
>>> +struct vgic_register_region {
>>> +	unsigned int reg_offset;
>>> +	unsigned int len;
>>> +	unsigned int bits_per_irq;
>>> +	unsigned int access_flags;
>>> +	unsigned long (*read)(struct kvm_vcpu *vcpu, gpa_t addr,
>>> +			      unsigned int len);
>>> +	void (*write)(struct kvm_vcpu *vcpu, gpa_t addr, unsigned int len=
,
>>> +		      unsigned long val);
>>> +};
>>> +
>>> +extern struct kvm_io_device_ops kvm_io_gic_ops;
>>> +
>>> +#define VGIC_ACCESS_8bit	1
>>> +#define VGIC_ACCESS_32bit	2
>>> +#define VGIC_ACCESS_64bit	4
>>> +
>>> +/* generate a mask that covers 1024 interrupts with <b> bits per I=
RQ */
>>
>> Hmmm. I'd appreciate some additional comments, specially when it com=
es
>> to the various restrictions. May I'd suggest something like:
>>
>> /*
>>  * Generate a mask that covers the number of bytes required to addre=
ss
>>  * up to 1024 interrupts, each represented by <b> bits. This assumes
>>  * that <b> is a power of two.
>>  *
>>  * ilog2(b) + ilog2(1024) is the number of bits required to bit-addr=
ess
>>  * 1024 interrupts, each represented by b bits. Minus ilog2(8) conve=
rts
>>  * this to a byte address.
>=20
> So I'm guessting this is a rewrite of ilog2( (b * 1024) / 8), but I'm

Yes, same thing.

> stupid enough to not understand our use of logarithms here.  Can some=
one
> remind me whatever I forgot at CS 101?

I'm bad at explaining that kind of things, so let me just quote
Wikipedia (https://en.wikipedia.org/wiki/Binary_logarithm):

"The number of digits (bits) in the binary representation of a positive
integer n is the integral part of 1 + log2=E2=80=8An"

Is that what you were missing?

>=20
>>  */
>>
>>> +#define VGIC_ADDR_IRQ_MASK(b) GENMASK_ULL(ilog2(b) + ilog2(1024) -=
 \
>>> +					  ilog2(BITS_PER_BYTE) - 1, 0)
>>
>> /*
>>  * Convert a base address into a base interrupt (each interrupt
>>  * represented by <bits> bits. This assumes that <bits> is a power
>>  * of two, that <addr> both part of a memory region aligned on a
>=20
> did you mean '<addr> *is* both part of' ?

Indeed.

Thanks,

	M.
--=20
Jazz is not dead. It just smells funny...
