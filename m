From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v10 5/7] hw/vfio: calxeda xgmac device
Date: Tue, 17 Feb 2015 11:29:18 +0000
Message-ID: <87d258zshd.fsf@linaro.org>
References: <1423799232-10816-1-git-send-email-eric.auger@linaro.org>
	<1423799232-10816-6-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-reply-to: <1423799232-10816-6-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Eric Auger <eric.auger@linaro.org>
Cc: peter.maydell@linaro.org, eric.auger@st.com, patches@linaro.org, qemu-devel@nongnu.org, agraf@suse.de, alex.williamson@redhat.com, pbonzini@redhat.com, b.reynal@virtualopensystems.com, feng.wu@intel.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu


Eric Auger <eric.auger@linaro.org> writes:

> The platform device class has become abstract. This patch introduces
> a calxeda xgmac device that can be be instantiated on command line
> using such option.
>
> -device vfio-calxeda-xgmac,host="fff51000.ethernet"
>
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>

>
> ---
> v8 -> v9:
> - renamed calxeda_xgmac.c into calxeda-xgmac.c
>
> v7 -> v8:
> - add a comment in the header about the MMIO regions and IRQ which
>   are exposed by the device
>
> v5 -> v6
> - back again following Alex Graf advises
> - fix a bug related to compat override
>
> v4 -> v5:
> removed since device tree was moved to hw/arm/dyn_sysbus_devtree.c
>
> v4: creation for device tree specialization
> ---
>  hw/arm/virt.c                        | 15 +++++++---
>  hw/vfio/Makefile.objs                |  1 +
>  hw/vfio/calxeda-xgmac.c              | 54 ++++++++++++++++++++++++++++++++++++
>  include/hw/vfio/vfio-calxeda-xgmac.h | 46 ++++++++++++++++++++++++++++++
>  4 files changed, 112 insertions(+), 4 deletions(-)
>  create mode 100644 hw/vfio/calxeda-xgmac.c
>  create mode 100644 include/hw/vfio/vfio-calxeda-xgmac.h
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 9df9b60..c1e0a10 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -44,6 +44,7 @@
>  #include "qemu/error-report.h"
>  #include "hw/arm/sysbus-fdt.h"
>  #include "hw/platform-bus.h"
> +#include "hw/vfio/vfio-platform.h"
>  
>  #define NUM_VIRTIO_TRANSPORTS 32
>  
> @@ -342,7 +343,7 @@ static void fdt_add_gic_node(const VirtBoardInfo *vbi)
>      qemu_fdt_setprop_cell(vbi->fdt, "/intc", "phandle", gic_phandle);
>  }
>  
> -static void create_gic(const VirtBoardInfo *vbi, qemu_irq *pic)
> +static DeviceState *create_gic(const VirtBoardInfo *vbi, qemu_irq *pic)
>  {
>      /* We create a standalone GIC v2 */
>      DeviceState *gicdev;
> @@ -390,6 +391,7 @@ static void create_gic(const VirtBoardInfo *vbi, qemu_irq *pic)
>      }
>  
>      fdt_add_gic_node(vbi);
> +    return gicdev;
>  }
>  
>  static void create_uart(const VirtBoardInfo *vbi, qemu_irq *pic)
> @@ -594,7 +596,8 @@ static void create_fw_cfg(const VirtBoardInfo *vbi)
>      g_free(nodename);
>  }
>  
> -static void create_platform_bus(VirtBoardInfo *vbi, qemu_irq *pic)
> +static void create_platform_bus(VirtBoardInfo *vbi, qemu_irq *pic,
> +                                DeviceState *gic)
>  {
>      DeviceState *dev;
>      SysBusDevice *s;
> @@ -633,6 +636,9 @@ static void create_platform_bus(VirtBoardInfo *vbi, qemu_irq *pic)
>      memory_region_add_subregion(sysmem,
>                                  platform_bus_params.platform_bus_base,
>                                  sysbus_mmio_get_region(s, 0));
> +
> +    /* setup VFIO signaling/IRQFD for all VFIO platform sysbus devices */
> +    qemu_register_reset(vfio_kick_irqs, gic);
>  }
>  
>  static void *machvirt_dtb(const struct arm_boot_info *binfo, int *fdt_size)
> @@ -652,6 +658,7 @@ static void machvirt_init(MachineState *machine)
>      MemoryRegion *ram = g_new(MemoryRegion, 1);
>      const char *cpu_model = machine->cpu_model;
>      VirtBoardInfo *vbi;
> +    DeviceState *gic;
>  
>      if (!cpu_model) {
>          cpu_model = "cortex-a15";
> @@ -713,7 +720,7 @@ static void machvirt_init(MachineState *machine)
>  
>      create_flash(vbi);
>  
> -    create_gic(vbi, pic);
> +    gic = create_gic(vbi, pic);
>  
>      create_uart(vbi, pic);
>  
> @@ -744,7 +751,7 @@ static void machvirt_init(MachineState *machine)
>       * another notifier is registered which adds platform bus nodes.
>       * Notifiers are executed in registration reverse order.
>       */
> -    create_platform_bus(vbi, pic);
> +    create_platform_bus(vbi, pic, gic);
>  }
>  
>  static bool virt_get_secure(Object *obj, Error **errp)
> diff --git a/hw/vfio/Makefile.objs b/hw/vfio/Makefile.objs
> index c5c76fe..d540c9d 100644
> --- a/hw/vfio/Makefile.objs
> +++ b/hw/vfio/Makefile.objs
> @@ -2,4 +2,5 @@ ifeq ($(CONFIG_LINUX), y)
>  obj-$(CONFIG_SOFTMMU) += common.o
>  obj-$(CONFIG_PCI) += pci.o
>  obj-$(CONFIG_SOFTMMU) += platform.o
> +obj-$(CONFIG_SOFTMMU) += calxeda-xgmac.o
>  endif
> diff --git a/hw/vfio/calxeda-xgmac.c b/hw/vfio/calxeda-xgmac.c
> new file mode 100644
> index 0000000..199e076
> --- /dev/null
> +++ b/hw/vfio/calxeda-xgmac.c
> @@ -0,0 +1,54 @@
> +/*
> + * calxeda xgmac example VFIO device
> + *
> + * Copyright Linaro Limited, 2014
> + *
> + * Authors:
> + *  Eric Auger <eric.auger@linaro.org>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.  See
> + * the COPYING file in the top-level directory.
> + *
> + */
> +
> +#include "hw/vfio/vfio-calxeda-xgmac.h"
> +
> +static void calxeda_xgmac_realize(DeviceState *dev, Error **errp)
> +{
> +    VFIOPlatformDevice *vdev = VFIO_PLATFORM_DEVICE(dev);
> +    VFIOCalxedaXgmacDeviceClass *k = VFIO_CALXEDA_XGMAC_DEVICE_GET_CLASS(dev);
> +
> +    vdev->compat = g_strdup("calxeda,hb-xgmac");
> +
> +    k->parent_realize(dev, errp);
> +}
> +
> +static const VMStateDescription vfio_platform_vmstate = {
> +    .name = TYPE_VFIO_CALXEDA_XGMAC,
> +    .unmigratable = 1,
> +};
> +
> +static void vfio_calxeda_xgmac_class_init(ObjectClass *klass, void *data)
> +{
> +    DeviceClass *dc = DEVICE_CLASS(klass);
> +    VFIOCalxedaXgmacDeviceClass *vcxc =
> +        VFIO_CALXEDA_XGMAC_DEVICE_CLASS(klass);
> +    vcxc->parent_realize = dc->realize;
> +    dc->realize = calxeda_xgmac_realize;
> +    dc->desc = "VFIO Calxeda XGMAC";
> +}
> +
> +static const TypeInfo vfio_calxeda_xgmac_dev_info = {
> +    .name = TYPE_VFIO_CALXEDA_XGMAC,
> +    .parent = TYPE_VFIO_PLATFORM,
> +    .instance_size = sizeof(VFIOCalxedaXgmacDevice),
> +    .class_init = vfio_calxeda_xgmac_class_init,
> +    .class_size = sizeof(VFIOCalxedaXgmacDeviceClass),
> +};
> +
> +static void register_calxeda_xgmac_dev_type(void)
> +{
> +    type_register_static(&vfio_calxeda_xgmac_dev_info);
> +}
> +
> +type_init(register_calxeda_xgmac_dev_type)
> diff --git a/include/hw/vfio/vfio-calxeda-xgmac.h b/include/hw/vfio/vfio-calxeda-xgmac.h
> new file mode 100644
> index 0000000..f994775
> --- /dev/null
> +++ b/include/hw/vfio/vfio-calxeda-xgmac.h
> @@ -0,0 +1,46 @@
> +/*
> + * VFIO calxeda xgmac device
> + *
> + * Copyright Linaro Limited, 2014
> + *
> + * Authors:
> + *  Eric Auger <eric.auger@linaro.org>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.  See
> + * the COPYING file in the top-level directory.
> + *
> + */
> +
> +#ifndef HW_VFIO_VFIO_CALXEDA_XGMAC_H
> +#define HW_VFIO_VFIO_CALXEDA_XGMAC_H
> +
> +#include "hw/vfio/vfio-platform.h"
> +
> +#define TYPE_VFIO_CALXEDA_XGMAC "vfio-calxeda-xgmac"
> +
> +/**
> + * This device exposes:
> + * - a single MMIO region corresponding to its register space
> + * - 3 IRQS (main and 2 power related IRQs)
> + */
> +typedef struct VFIOCalxedaXgmacDevice {
> +    VFIOPlatformDevice vdev;
> +} VFIOCalxedaXgmacDevice;
> +
> +typedef struct VFIOCalxedaXgmacDeviceClass {
> +    /*< private >*/
> +    VFIOPlatformDeviceClass parent_class;
> +    /*< public >*/
> +    DeviceRealize parent_realize;
> +} VFIOCalxedaXgmacDeviceClass;
> +
> +#define VFIO_CALXEDA_XGMAC_DEVICE(obj) \
> +     OBJECT_CHECK(VFIOCalxedaXgmacDevice, (obj), TYPE_VFIO_CALXEDA_XGMAC)
> +#define VFIO_CALXEDA_XGMAC_DEVICE_CLASS(klass) \
> +     OBJECT_CLASS_CHECK(VFIOCalxedaXgmacDeviceClass, (klass), \
> +                        TYPE_VFIO_CALXEDA_XGMAC)
> +#define VFIO_CALXEDA_XGMAC_DEVICE_GET_CLASS(obj) \
> +     OBJECT_GET_CLASS(VFIOCalxedaXgmacDeviceClass, (obj), \
> +                      TYPE_VFIO_CALXEDA_XGMAC)
> +
> +#endif

-- 
Alex Bennée
