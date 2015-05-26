From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v3 4/4] target-arm: Add the GICv2m to the virt board
Date: Tue, 26 May 2015 14:54:39 +0200
Message-ID: <55646D0F.9040801@linaro.org>
References: <1432464666-4825-1-git-send-email-christoffer.dall@linaro.org>
 <1432464666-4825-5-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A00DF520C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 08:45:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OKYLW4fAggd5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2015 08:45:10 -0400 (EDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
 [209.85.212.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1DD16520C1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 08:45:09 -0400 (EDT)
Received: by wifw1 with SMTP id w1so29614945wif.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 05:54:49 -0700 (PDT)
In-Reply-To: <1432464666-4825-5-git-send-email-christoffer.dall@linaro.org>
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

The only question I have is related to mid-term virt strategy about
GICv3 integration. Are we going to reuse that memory map for the machine
instantiating the GICv3? If yes, shouldn't we put the GICv2M somewhere
else to leave space for GICv3 redistributors, assuming we reuse the
shared distributor region. I understood the memory map is difficult to
change once applied once.

Best Regards

Eric

On 05/24/2015 12:51 PM, Christoffer Dall wrote:
> Add a GICv2m device to the virt board to enable MSIs on the generic PCI
> host controller.  We allocate 64 SPIs in the IRQ space for now (this can
> be increased/decreased later) and map the GICv2m right after the GIC in
> the memory map.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> Changes since v2:
>  - Factored out changes to GIC DT node to previous patch.
>  - Renamed QOM type name to "arm-gicv2m"
> Changes since v1:
>  - Remove stray merge conflict line
>  - Reworded commmit message.
> 
>  hw/arm/virt.c | 42 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 6797c6f..2972bb3 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -45,6 +45,7 @@
>  #include "hw/pci-host/gpex.h"
>  
>  #define NUM_VIRTIO_TRANSPORTS 32
> +#define NUM_GICV2M_SPIS 64
>  
>  /* Number of external interrupt lines to configure the GIC with */
>  #define NUM_IRQS 128
> @@ -71,6 +72,7 @@ enum {
>      VIRT_RTC,
>      VIRT_FW_CFG,
>      VIRT_PCIE,
> +    VIRT_GIC_V2M,
>  };
>  
>  typedef struct MemMapEntry {
> @@ -88,6 +90,7 @@ typedef struct VirtBoardInfo {
>      int fdt_size;
>      uint32_t clock_phandle;
>      uint32_t gic_phandle;
> +    uint32_t v2m_phandle;
>  } VirtBoardInfo;
>  
>  typedef struct {
> @@ -127,6 +130,7 @@ static const MemMapEntry a15memmap[] = {
>      /* GIC distributor and CPU interfaces sit inside the CPU peripheral space */
>      [VIRT_GIC_DIST] =   { 0x08000000, 0x00010000 },
>      [VIRT_GIC_CPU] =    { 0x08010000, 0x00010000 },
> +    [VIRT_GIC_V2M] =    { 0x08020000, 0x00001000 },
>      [VIRT_UART] =       { 0x09000000, 0x00001000 },
>      [VIRT_RTC] =        { 0x09010000, 0x00001000 },
>      [VIRT_FW_CFG] =     { 0x09020000, 0x0000000a },
> @@ -148,6 +152,7 @@ static const int a15irqmap[] = {
>      [VIRT_RTC] = 2,
>      [VIRT_PCIE] = 3, /* ... to 6 */
>      [VIRT_MMIO] = 16, /* ...to 16 + NUM_VIRTIO_TRANSPORTS - 1 */
> +    [VIRT_GIC_V2M] = 48, /* ...to 48 + NUM_GICV2M_SPIS - 1 */
>  };
>  
>  static VirtBoardInfo machines[] = {
> @@ -323,9 +328,21 @@ static void fdt_add_cpu_nodes(const VirtBoardInfo *vbi)
>      }
>  }
>  
> -static void fdt_add_gic_node(VirtBoardInfo *vbi)
> +static void fdt_add_v2m_gic_node(VirtBoardInfo *vbi)
>  {
> +    vbi->v2m_phandle = qemu_fdt_alloc_phandle(vbi->fdt);
> +    qemu_fdt_add_subnode(vbi->fdt, "/intc/v2m");
> +    qemu_fdt_setprop_string(vbi->fdt, "/intc/v2m", "compatible",
> +                            "arm,gic-v2m-frame");
> +    qemu_fdt_setprop(vbi->fdt, "/intc/v2m", "msi-controller", NULL, 0);
> +    qemu_fdt_setprop_sized_cells(vbi->fdt, "/intc/v2m", "reg",
> +                                 2, vbi->memmap[VIRT_GIC_V2M].base,
> +                                 2, vbi->memmap[VIRT_GIC_V2M].size);
> +    qemu_fdt_setprop_cell(vbi->fdt, "/intc/v2m", "phandle", vbi->v2m_phandle);
> +}
>  
> +static void fdt_add_gic_node(VirtBoardInfo *vbi)
> +{
>      vbi->gic_phandle = qemu_fdt_alloc_phandle(vbi->fdt);
>      qemu_fdt_setprop_cell(vbi->fdt, "/", "interrupt-parent", vbi->gic_phandle);
>  
> @@ -347,6 +364,25 @@ static void fdt_add_gic_node(VirtBoardInfo *vbi)
>  
>  }
>  
> +static void create_v2m(VirtBoardInfo *vbi, qemu_irq *pic)
> +{
> +    int i;
> +    int irq = vbi->irqmap[VIRT_GIC_V2M];
> +    DeviceState *dev;
> +
> +    dev = qdev_create(NULL, "arm-gicv2m");
> +    sysbus_mmio_map(SYS_BUS_DEVICE(dev), 0, vbi->memmap[VIRT_GIC_V2M].base);
> +    qdev_prop_set_uint32(dev, "base-spi", irq);
> +    qdev_prop_set_uint32(dev, "num-spi", NUM_GICV2M_SPIS);
> +    qdev_init_nofail(dev);
> +
> +    for (i = 0; i < NUM_GICV2M_SPIS; i++) {
> +        sysbus_connect_irq(SYS_BUS_DEVICE(dev), i, pic[irq + i]);
> +    }
> +
> +    fdt_add_v2m_gic_node(vbi);
> +}
> +
>  static void create_gic(VirtBoardInfo *vbi, qemu_irq *pic)
>  {
>      /* We create a standalone GIC v2 */
> @@ -397,6 +433,8 @@ static void create_gic(VirtBoardInfo *vbi, qemu_irq *pic)
>      }
>  
>      fdt_add_gic_node(vbi);
> +
> +    create_v2m(vbi, pic);
>  }
>  
>  static void create_uart(const VirtBoardInfo *vbi, qemu_irq *pic)
> @@ -707,6 +745,8 @@ static void create_pcie(const VirtBoardInfo *vbi, qemu_irq *pic)
>      qemu_fdt_setprop_cells(vbi->fdt, nodename, "bus-range", 0,
>                             nr_pcie_buses - 1);
>  
> +    qemu_fdt_setprop_cells(vbi->fdt, nodename, "msi-parent", vbi->v2m_phandle);
> +
>      qemu_fdt_setprop_sized_cells(vbi->fdt, nodename, "reg",
>                                   2, base_ecam, 2, size_ecam);
>      qemu_fdt_setprop_sized_cells(vbi->fdt, nodename, "ranges",
> 
