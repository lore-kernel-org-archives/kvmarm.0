From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v3 3/4] target-arm: Extend the gic node properties
Date: Tue, 26 May 2015 14:54:50 +0200
Message-ID: <55646D1A.3060508@linaro.org>
References: <1432464666-4825-1-git-send-email-christoffer.dall@linaro.org>
 <1432464666-4825-4-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BEF4520CC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 08:45:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FENpUeKUYgdK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2015 08:45:20 -0400 (EDT)
Received: from mail-wi0-f176.google.com (mail-wi0-f176.google.com
 [209.85.212.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 800C0520C7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 08:45:20 -0400 (EDT)
Received: by wifw1 with SMTP id w1so29621609wif.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 05:54:59 -0700 (PDT)
In-Reply-To: <1432464666-4825-4-git-send-email-christoffer.dall@linaro.org>
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

only minor things below

On 05/24/2015 12:51 PM, Christoffer Dall wrote:
> From: Shanker Donthineni <shankerd@codeaurora.org>
> 
> In preparation for adding the GICv2m which requires address specifiers
> and is a subnode of the gic, we extend the gic DT definition to specify
> the #address-cells and #size-cells properties and add an empty ranges
> property properties of the DT node, since this is required to add the
> v2m node as a child of the gic node.
> 
> Note that we must also expand the irq-map to reference the gic with the
> right address-cells as a consequnce of this change.
consequence
> 
> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> Changes since v2:
>  - New separate patch factoring out changes to existing code for eased
>    bisectability in case we broke something
>  - The above fixes the issue with non-MSI compatible guests.
> 
>  hw/arm/virt.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index f9f7482..6797c6f 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -340,7 +340,11 @@ static void fdt_add_gic_node(VirtBoardInfo *vbi)
>                                       2, vbi->memmap[VIRT_GIC_DIST].size,
>                                       2, vbi->memmap[VIRT_GIC_CPU].base,
>                                       2, vbi->memmap[VIRT_GIC_CPU].size);
> +    qemu_fdt_setprop_cell(vbi->fdt, "/intc", "#address-cells", 0x2);
> +    qemu_fdt_setprop_cell(vbi->fdt, "/intc", "#size-cells", 0x2);
> +    qemu_fdt_setprop(vbi->fdt, "/intc", "ranges", NULL, 0);
>      qemu_fdt_setprop_cell(vbi->fdt, "/intc", "phandle", vbi->gic_phandle);
> +
spare empty line
>  }
>  
>  static void create_gic(VirtBoardInfo *vbi, qemu_irq *pic)
> @@ -604,11 +608,12 @@ static void create_fw_cfg(const VirtBoardInfo *vbi)
>      g_free(nodename);
>  }
>  
> +#define PCIE_IRQMAP_LEN 10
>  static void create_pcie_irq_map(const VirtBoardInfo *vbi, uint32_t gic_phandle,
>                                  int first_irq, const char *nodename)
>  {
>      int devfn, pin;
> -    uint32_t full_irq_map[4 * 4 * 8] = { 0 };
> +    uint32_t full_irq_map[4 * 4 * PCIE_IRQMAP_LEN] = { 0 };
>      uint32_t *irq_map = full_irq_map;
>  
>      for (devfn = 0; devfn <= 0x18; devfn += 0x8) {
> @@ -619,15 +624,15 @@ static void create_pcie_irq_map(const VirtBoardInfo *vbi, uint32_t gic_phandle,
>              int i;
>  
>              uint32_t map[] = {
> -                devfn << 8, 0, 0,                           /* devfn */
> -                pin + 1,                                    /* PCI pin */
> -                gic_phandle, irq_type, irq_nr, irq_level }; /* GIC irq */
> +                devfn << 8, 0, 0,                                 /* devfn */
> +                pin + 1,                                          /* PCI pin */
> +                gic_phandle, 0, 0, irq_type, irq_nr, irq_level }; /* GIC irq */
>  
>              /* Convert map to big endian */
> -            for (i = 0; i < 8; i++) {
> +            for (i = 0; i < PCIE_IRQMAP_LEN; i++) {
>                  irq_map[i] = cpu_to_be32(map[i]);
>              }
> -            irq_map += 8;
> +            irq_map += PCIE_IRQMAP_LEN;
>          }
>      }
>  
> 
