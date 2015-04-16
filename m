From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v12 5/9] hw/arm/virt: start VFIO IRQ propagation
Date: Thu, 16 Apr 2015 16:05:35 -0600
Message-ID: <1429221935.10086.39.camel@redhat.com>
References: <1426785402-2091-1-git-send-email-eric.auger@linaro.org>
 <1426785402-2091-6-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BC6B4DD52
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2015 17:57:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U3J2rzNhrfDO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Apr 2015 17:57:41 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CD264DD4B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2015 17:57:41 -0400 (EDT)
In-Reply-To: <1426785402-2091-6-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, patches@linaro.org, qemu-devel@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 2015-03-19 at 17:16 +0000, Eric Auger wrote:
> Although the dynamic instantiation of VFIO QEMU devices already is
> possible, VFIO IRQ signaling is not yet started. This patch enables
> IRQ forwarding by registering a reset notifier that kick off VFIO
> signaling for all VFIO devices.
> 
> Such mechanism is requested because the VFIO IRQ binding
> is handled in a machine init done notifier and only at that time the
> aboslute GSI number the physical IRQ is forwarded to is known.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> v10 - v11:
> - becomes a separate patch
> ---
>  hw/arm/virt.c | 34 ++++++++++++++++++++--------------
>  1 file changed, 20 insertions(+), 14 deletions(-)


I would strongly discourage pushing vfio specific setup out to other
code.  If you look at existing vfio (and ignore the spapr mess), there's
not a single place where anybody else knows or cares about vfio.  It
seems like what you're looking for here is what we do on x86 with the
PCI INTx routing notifier.  vfio-pci and legacy KVM device assignment
may be the only users of that interface, but we've abstracted the
callback we're looking for rather than taking the quirk and dirty path
of dropping a vfio specific callback out in non-vfio code.


> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 439739d..820b09d 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -45,6 +45,7 @@
>  #include "hw/pci-host/gpex.h"
>  #include "hw/arm/sysbus-fdt.h"
>  #include "hw/platform-bus.h"
> +#include "hw/vfio/vfio-platform.h"
>  
>  #define NUM_VIRTIO_TRANSPORTS 32
>  
> @@ -354,10 +355,10 @@ static uint32_t fdt_add_gic_node(const VirtBoardInfo *vbi)
>      return gic_phandle;
>  }
>  
> -static uint32_t create_gic(const VirtBoardInfo *vbi, qemu_irq *pic)
> +static uint32_t create_gic(const VirtBoardInfo *vbi, qemu_irq *pic,
> +                           DeviceState **gicdev)
>  {
>      /* We create a standalone GIC v2 */
> -    DeviceState *gicdev;
>      SysBusDevice *gicbusdev;
>      const char *gictype = "arm_gic";
>      int i;
> @@ -366,15 +367,15 @@ static uint32_t create_gic(const VirtBoardInfo *vbi, qemu_irq *pic)
>          gictype = "kvm-arm-gic";
>      }
>  
> -    gicdev = qdev_create(NULL, gictype);
> -    qdev_prop_set_uint32(gicdev, "revision", 2);
> -    qdev_prop_set_uint32(gicdev, "num-cpu", smp_cpus);
> +    *gicdev = qdev_create(NULL, gictype);
> +    qdev_prop_set_uint32(*gicdev, "revision", 2);
> +    qdev_prop_set_uint32(*gicdev, "num-cpu", smp_cpus);
>      /* Note that the num-irq property counts both internal and external
>       * interrupts; there are always 32 of the former (mandated by GIC spec).
>       */
> -    qdev_prop_set_uint32(gicdev, "num-irq", NUM_IRQS + 32);
> -    qdev_init_nofail(gicdev);
> -    gicbusdev = SYS_BUS_DEVICE(gicdev);
> +    qdev_prop_set_uint32(*gicdev, "num-irq", NUM_IRQS + 32);
> +    qdev_init_nofail(*gicdev);
> +    gicbusdev = SYS_BUS_DEVICE(*gicdev);
>      sysbus_mmio_map(gicbusdev, 0, vbi->memmap[VIRT_GIC_DIST].base);
>      sysbus_mmio_map(gicbusdev, 1, vbi->memmap[VIRT_GIC_CPU].base);
>  
> @@ -389,16 +390,16 @@ static uint32_t create_gic(const VirtBoardInfo *vbi, qemu_irq *pic)
>           * since a real A15 always has TrustZone but QEMU doesn't.
>           */
>          qdev_connect_gpio_out(cpudev, 0,
> -                              qdev_get_gpio_in(gicdev, ppibase + 30));
> +                              qdev_get_gpio_in(*gicdev, ppibase + 30));
>          /* virtual timer */
>          qdev_connect_gpio_out(cpudev, 1,
> -                              qdev_get_gpio_in(gicdev, ppibase + 27));
> +                              qdev_get_gpio_in(*gicdev, ppibase + 27));
>  
>          sysbus_connect_irq(gicbusdev, i, qdev_get_gpio_in(cpudev, ARM_CPU_IRQ));
>      }
>  
>      for (i = 0; i < NUM_IRQS; i++) {
> -        pic[i] = qdev_get_gpio_in(gicdev, i);
> +        pic[i] = qdev_get_gpio_in(*gicdev, i);
>      }
>  
>      return fdt_add_gic_node(vbi);
> @@ -719,7 +720,8 @@ static void create_pcie(const VirtBoardInfo *vbi, qemu_irq *pic,
>      g_free(nodename);
>  }
>  
> -static void create_platform_bus(VirtBoardInfo *vbi, qemu_irq *pic)
> +static void create_platform_bus(VirtBoardInfo *vbi, qemu_irq *pic,
> +                                DeviceState *gic)
>  {
>      DeviceState *dev;
>      SysBusDevice *s;
> @@ -758,6 +760,9 @@ static void create_platform_bus(VirtBoardInfo *vbi, qemu_irq *pic)
>      memory_region_add_subregion(sysmem,
>                                  platform_bus_params.platform_bus_base,
>                                  sysbus_mmio_get_region(s, 0));
> +
> +    /* setup VFIO signaling/IRQFD for all VFIO platform sysbus devices */
> +    qemu_register_reset(vfio_kick_irqs, gic);
>  }
>  
>  static void *machvirt_dtb(const struct arm_boot_info *binfo, int *fdt_size)
> @@ -779,6 +784,7 @@ static void machvirt_init(MachineState *machine)
>      VirtBoardInfo *vbi;
>      uint32_t gic_phandle;
>      char **cpustr;
> +    DeviceState *gicdev;
>  
>      if (!cpu_model) {
>          cpu_model = "cortex-a15";
> @@ -855,7 +861,7 @@ static void machvirt_init(MachineState *machine)
>  
>      create_flash(vbi);
>  
> -    gic_phandle = create_gic(vbi, pic);
> +    gic_phandle = create_gic(vbi, pic, &gicdev);
>  
>      create_uart(vbi, pic);
>  
> @@ -888,7 +894,7 @@ static void machvirt_init(MachineState *machine)
>       * another notifier is registered which adds platform bus nodes.
>       * Notifiers are executed in registration reverse order.
>       */
> -    create_platform_bus(vbi, pic);
> +    create_platform_bus(vbi, pic, gicdev);
>  }
>  
>  static bool virt_get_secure(Object *obj, Error **errp)
