From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v3 1/4] target-arm: Add GIC phandle to VirtBoardInfo
Date: Tue, 26 May 2015 14:24:33 +0200
Message-ID: <55646601.6060804@linaro.org>
References: <1432464666-4825-1-git-send-email-christoffer.dall@linaro.org>
 <1432464666-4825-2-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F496520B1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 08:15:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MS8poirHpAUB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2015 08:15:03 -0400 (EDT)
Received: from mail-wg0-f54.google.com (mail-wg0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 71484520B0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 08:15:02 -0400 (EDT)
Received: by wgme6 with SMTP id e6so27030610wgm.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 05:24:42 -0700 (PDT)
In-Reply-To: <1432464666-4825-2-git-send-email-christoffer.dall@linaro.org>
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
> Instead of passing the GIC phandle around between functions, add it to
> the VirtBoardInfo just like we do for the clock_phandle.  We are about
> to add the v2m phandle as well, and it's easier not having to pass
> around a bunch of phandles, return multiple values from functions, etc.
> 
> Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> Changes since v2:
>  - None
> Changes since v1:
>  - Added reviewed-by tag
> 
>  hw/arm/virt.c | 26 +++++++++++---------------
>  1 file changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index a7f9a10..f9f7482 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -87,6 +87,7 @@ typedef struct VirtBoardInfo {
>      void *fdt;
>      int fdt_size;
>      uint32_t clock_phandle;
> +    uint32_t gic_phandle;
>  } VirtBoardInfo;
>  
>  typedef struct {
> @@ -322,12 +323,11 @@ static void fdt_add_cpu_nodes(const VirtBoardInfo *vbi)
>      }
>  }
>  
> -static uint32_t fdt_add_gic_node(const VirtBoardInfo *vbi)
> +static void fdt_add_gic_node(VirtBoardInfo *vbi)
>  {
> -    uint32_t gic_phandle;
>  
> -    gic_phandle = qemu_fdt_alloc_phandle(vbi->fdt);
> -    qemu_fdt_setprop_cell(vbi->fdt, "/", "interrupt-parent", gic_phandle);
> +    vbi->gic_phandle = qemu_fdt_alloc_phandle(vbi->fdt);
> +    qemu_fdt_setprop_cell(vbi->fdt, "/", "interrupt-parent", vbi->gic_phandle);
>  
>      qemu_fdt_add_subnode(vbi->fdt, "/intc");
>      /* 'cortex-a15-gic' means 'GIC v2' */
> @@ -340,12 +340,10 @@ static uint32_t fdt_add_gic_node(const VirtBoardInfo *vbi)
>                                       2, vbi->memmap[VIRT_GIC_DIST].size,
>                                       2, vbi->memmap[VIRT_GIC_CPU].base,
>                                       2, vbi->memmap[VIRT_GIC_CPU].size);
> -    qemu_fdt_setprop_cell(vbi->fdt, "/intc", "phandle", gic_phandle);
> -
> -    return gic_phandle;
> +    qemu_fdt_setprop_cell(vbi->fdt, "/intc", "phandle", vbi->gic_phandle);
>  }
>  
> -static uint32_t create_gic(const VirtBoardInfo *vbi, qemu_irq *pic)
> +static void create_gic(VirtBoardInfo *vbi, qemu_irq *pic)
>  {
>      /* We create a standalone GIC v2 */
>      DeviceState *gicdev;
> @@ -394,7 +392,7 @@ static uint32_t create_gic(const VirtBoardInfo *vbi, qemu_irq *pic)
>          pic[i] = qdev_get_gpio_in(gicdev, i);
>      }
>  
> -    return fdt_add_gic_node(vbi);
> +    fdt_add_gic_node(vbi);
>  }
>  
>  static void create_uart(const VirtBoardInfo *vbi, qemu_irq *pic)
> @@ -641,8 +639,7 @@ static void create_pcie_irq_map(const VirtBoardInfo *vbi, uint32_t gic_phandle,
>                             0x7           /* PCI irq */);
>  }
>  
> -static void create_pcie(const VirtBoardInfo *vbi, qemu_irq *pic,
> -                        uint32_t gic_phandle)
> +static void create_pcie(const VirtBoardInfo *vbi, qemu_irq *pic)
>  {
>      hwaddr base = vbi->memmap[VIRT_PCIE].base;
>      hwaddr size = vbi->memmap[VIRT_PCIE].size;
> @@ -714,7 +711,7 @@ static void create_pcie(const VirtBoardInfo *vbi, qemu_irq *pic,
>                                   2, base_mmio, 2, size_mmio);
>  
>      qemu_fdt_setprop_cell(vbi->fdt, nodename, "#interrupt-cells", 1);
> -    create_pcie_irq_map(vbi, gic_phandle, irq, nodename);
> +    create_pcie_irq_map(vbi, vbi->gic_phandle, irq, nodename);
>  
>      g_free(nodename);
>  }
> @@ -736,7 +733,6 @@ static void machvirt_init(MachineState *machine)
>      MemoryRegion *ram = g_new(MemoryRegion, 1);
>      const char *cpu_model = machine->cpu_model;
>      VirtBoardInfo *vbi;
> -    uint32_t gic_phandle;
>      char **cpustr;
>  
>      if (!cpu_model) {
> @@ -813,13 +809,13 @@ static void machvirt_init(MachineState *machine)
>  
>      create_flash(vbi);
>  
> -    gic_phandle = create_gic(vbi, pic);
> +    create_gic(vbi, pic);
>  
>      create_uart(vbi, pic);
>  
>      create_rtc(vbi, pic);
>  
> -    create_pcie(vbi, pic, gic_phandle);
> +    create_pcie(vbi, pic);
>  
>      /* Create mmio transports, so the user can create virtio backends
>       * (which will be automatically plugged in to the transports). If
> 
