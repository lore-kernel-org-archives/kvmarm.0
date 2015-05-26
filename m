From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v3 2/4] arm_gicv2m: Add GICv2m widget to support MSIs
Date: Tue, 26 May 2015 14:24:16 +0200
Message-ID: <556465F0.7090106@linaro.org>
References: <1432464666-4825-1-git-send-email-christoffer.dall@linaro.org>
 <1432464666-4825-3-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 388BC520AD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 08:14:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J0AdoT-Df7ZX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2015 08:14:47 -0400 (EDT)
Received: from mail-wg0-f43.google.com (mail-wg0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97658520A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 08:14:47 -0400 (EDT)
Received: by wgbgq6 with SMTP id gq6so95565883wgb.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 05:24:26 -0700 (PDT)
In-Reply-To: <1432464666-4825-3-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, qemu-devel@nongnu.org
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Reviewed-by: Eric Auger <eric.auger@linaro.org>

On 05/24/2015 12:51 PM, Christoffer Dall wrote:
> The ARM GICv2m widget is a little device that handles MSI interrupt
> writes to a trigger register and ties them to a range of interrupt lines
> wires to the GIC.  It has a few status/id registers and the interrupt wires,
> and that's about it.
> 
> A board instantiates the device by setting the base SPI number and
> number SPIs for the frame.  The base-spi parameter is indexed in the SPI
> number space only, so base-spi == 0, means IRQ number 32.  When a device
> (the PCI host controller) writes to the trigger register, the payload is
> the GIC IRQ number, so we have to subtract 32 from that and then index
> into our frame of SPIs.
> 
> When instantiating a GICv2m device, tell PCI that we have instantiated
> something that can deal with MSIs.  We rely on the board actually wiring
> up the GICv2m to the PCI host controller.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> Changes since v2:
>  - Renamed QOM type to "arm-gicv2m"
> Changes since v1:
>  - Check that writes to MSI_SETSPI are within the lower boundary as well
>  - Move gicv2m to common-obj in Makefile
>  - Separate switch case and comment for impdef regs
>  - Clearly document what is emulated
>  - Allow 16 bit lower accesses to MSI_SETSPI regs
>  - Fix commit grammar error
>  - Remove stray pixman commit
> 
>  hw/intc/Makefile.objs |   1 +
>  hw/intc/arm_gicv2m.c  | 190 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 191 insertions(+)
>  create mode 100644 hw/intc/arm_gicv2m.c
> 
> diff --git a/hw/intc/Makefile.objs b/hw/intc/Makefile.objs
> index 843864a..092d8a8 100644
> --- a/hw/intc/Makefile.objs
> +++ b/hw/intc/Makefile.objs
> @@ -11,6 +11,7 @@ common-obj-$(CONFIG_SLAVIO) += slavio_intctl.o
>  common-obj-$(CONFIG_IOAPIC) += ioapic_common.o
>  common-obj-$(CONFIG_ARM_GIC) += arm_gic_common.o
>  common-obj-$(CONFIG_ARM_GIC) += arm_gic.o
> +common-obj-$(CONFIG_ARM_GIC) += arm_gicv2m.o
>  common-obj-$(CONFIG_OPENPIC) += openpic.o
>  
>  obj-$(CONFIG_APIC) += apic.o apic_common.o
> diff --git a/hw/intc/arm_gicv2m.c b/hw/intc/arm_gicv2m.c
> new file mode 100644
> index 0000000..9f84f72
> --- /dev/null
> +++ b/hw/intc/arm_gicv2m.c
> @@ -0,0 +1,190 @@
> +/*
> + *  GICv2m extension for MSI/MSI-x support with a GICv2-based system
> + *
> + * Copyright (C) 2015 Linaro, All rights reserved.
> + *
> + * Author: Christoffer Dall <christoffer.dall@linaro.org>
> + *
> + * This library is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU Lesser General Public
> + * License as published by the Free Software Foundation; either
> + * version 2 of the License, or (at your option) any later version.
> + *
> + * This library is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * Lesser General Public License for more details.
> + *
> + * You should have received a copy of the GNU Lesser General Public
> + * License along with this library; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +/* This file implements an emulated GICv2m widget as described in the ARM
> + * Server Base System Architecture (SBSA) specification Version 2.2
> + * (ARM-DEN-0029 v2.2) pages 35-39 without any optional implementation defined
> + * identification registers and with a single non-secure MSI register frame.
> + */
> +
> +#include "hw/sysbus.h"
> +#include "hw/pci/msi.h"
> +
> +#define TYPE_ARM_GICV2M "arm-gicv2m"
> +#define ARM_GICV2M(obj) OBJECT_CHECK(ARMGICv2mState, (obj), TYPE_ARM_GICV2M)
> +
> +#define GICV2M_NUM_SPI_MAX 128
> +
> +#define V2M_MSI_TYPER           0x008
> +#define V2M_MSI_SETSPI_NS       0x040
> +#define V2M_MSI_IIDR            0xFCC
> +#define V2M_IIDR0               0xFD0
> +#define V2M_IIDR11              0xFFC
> +
> +#define PRODUCT_ID_QEMU         0x51 /* ASCII code Q */
> +
> +typedef struct ARMGICv2mState {
> +    SysBusDevice parent_obj;
> +
> +    MemoryRegion iomem;
> +    qemu_irq spi[GICV2M_NUM_SPI_MAX];
> +
> +    uint32_t base_spi;
> +    uint32_t num_spi;
> +} ARMGICv2mState;
> +
> +static void gicv2m_set_irq(void *opaque, int irq)
> +{
> +    ARMGICv2mState *s = (ARMGICv2mState *)opaque;
> +
> +    qemu_irq_pulse(s->spi[irq]);
> +}
> +
> +static uint64_t gicv2m_read(void *opaque, hwaddr offset,
> +                            unsigned size)
> +{
> +    ARMGICv2mState *s = (ARMGICv2mState *)opaque;
> +    uint32_t val;
> +
> +    if (size != 4) {
> +        qemu_log_mask(LOG_GUEST_ERROR, "gicv2m_read: bad size %u\n", size);
> +        return 0;
> +    }
> +
> +    switch (offset) {
> +    case V2M_MSI_TYPER:
> +        val = (s->base_spi + 32) << 16;
> +        val |= s->num_spi;
> +        return val;
> +    case V2M_MSI_IIDR:
> +        /* We don't have any valid implementor so we leave that field as zero
> +         * and we return 0 in the arch revision as per the spec.
> +         */
> +        return (PRODUCT_ID_QEMU << 20);
> +    case V2M_IIDR0 ... V2M_IIDR11:
> +        /* We do not implement any optional identification registers and the
> +         * mandatory MSI_PIDR2 register reads as 0x0, so we capture all
> +         * implementation defined registers here.
> +         */
> +        return 0;
> +    default:
> +        qemu_log_mask(LOG_GUEST_ERROR,
> +                      "gicv2m_read: Bad offset %x\n", (int)offset);
> +        return 0;
> +    }
> +}
> +
> +static void gicv2m_write(void *opaque, hwaddr offset,
> +                        uint64_t value, unsigned size)
> +{
> +    ARMGICv2mState *s = (ARMGICv2mState *)opaque;
> +
> +    if (size != 2 && size != 4) {
> +        qemu_log_mask(LOG_GUEST_ERROR, "gicv2m_write: bad size %u\n", size);
> +        return;
> +    }
> +
> +    switch (offset) {
> +    case V2M_MSI_SETSPI_NS: {
> +        int spi;
> +
> +        spi = (value & 0x3ff) - (s->base_spi + 32);
> +        if (spi >= 0 && spi < s->num_spi) {
> +            gicv2m_set_irq(s, spi);
> +        }
> +        return;
> +    }
> +    default:
> +        qemu_log_mask(LOG_GUEST_ERROR,
> +                      "gicv2m_write: Bad offset %x\n", (int)offset);
> +    }
> +}
> +
> +static const MemoryRegionOps gicv2m_ops = {
> +    .read = gicv2m_read,
> +    .write = gicv2m_write,
> +    .endianness = DEVICE_LITTLE_ENDIAN,
> +};
> +
> +static void gicv2m_realize(DeviceState *dev, Error **errp)
> +{
> +    ARMGICv2mState *s = ARM_GICV2M(dev);
> +    int i;
> +
> +    if (s->num_spi > GICV2M_NUM_SPI_MAX) {
> +        error_setg(errp,
> +                   "requested %u SPIs exceeds GICv2m frame maximum %d",
> +                   s->num_spi, GICV2M_NUM_SPI_MAX);
> +        return;
> +    }
> +
> +    if (s->base_spi + 32 > 1020 - s->num_spi) {
> +        error_setg(errp,
> +                   "requested base SPI %u+%u exceeds max. number 1020",
> +                   s->base_spi + 32, s->num_spi);
> +        return;
> +    }
> +
> +    for (i = 0; i < s->num_spi; i++) {
> +        sysbus_init_irq(SYS_BUS_DEVICE(dev), &s->spi[i]);
> +    }
> +
> +    msi_supported = true;
> +}
> +
> +static void gicv2m_init(Object *obj)
> +{
> +    SysBusDevice *sbd = SYS_BUS_DEVICE(obj);
> +    ARMGICv2mState *s = ARM_GICV2M(obj);
> +
> +    memory_region_init_io(&s->iomem, OBJECT(s), &gicv2m_ops, s,
> +                          "gicv2m", 0x1000);
> +    sysbus_init_mmio(sbd, &s->iomem);
> +}
> +
> +static Property gicv2m_properties[] = {
> +    DEFINE_PROP_UINT32("base-spi", ARMGICv2mState, base_spi, 0),
> +    DEFINE_PROP_UINT32("num-spi", ARMGICv2mState, num_spi, 64),
> +    DEFINE_PROP_END_OF_LIST(),
> +};
> +
> +static void gicv2m_class_init(ObjectClass *klass, void *data)
> +{
> +    DeviceClass *dc = DEVICE_CLASS(klass);
> +
> +    dc->props = gicv2m_properties;
> +    dc->realize = gicv2m_realize;
> +}
> +
> +static const TypeInfo gicv2m_info = {
> +    .name          = TYPE_ARM_GICV2M,
> +    .parent        = TYPE_SYS_BUS_DEVICE,
> +    .instance_size = sizeof(ARMGICv2mState),
> +    .instance_init = gicv2m_init,
> +    .class_init    = gicv2m_class_init,
> +};
> +
> +static void gicv2m_register_types(void)
> +{
> +    type_register_static(&gicv2m_info);
> +}
> +
> +type_init(gicv2m_register_types)
> 
