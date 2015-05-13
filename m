From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 5/5] VFIO: platform: VFIO platform Calxeda xgmac reset
 module
Date: Wed, 13 May 2015 12:33:37 -0600
Message-ID: <1431542017.3625.56.camel@redhat.com>
References: <1431008843-28411-1-git-send-email-eric.auger@linaro.org>
 <1431008843-28411-6-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 369BD5135D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2015 14:24:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VPlzdbG7m1Fo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 May 2015 14:24:40 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E51DE51359
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2015 14:24:39 -0400 (EDT)
In-Reply-To: <1431008843-28411-6-git-send-email-eric.auger@linaro.org>
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
Cc: kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 2015-05-07 at 16:27 +0200, Eric Auger wrote:
> This patch introduces a module that registers and implements a basic
> reset function for the Calxeda xgmac device. This latter basically disables
> interrupts and stops DMA transfers.
> 
> The reset function code is inherited from the native calxeda xgmac driver.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> ---
>  drivers/vfio/platform/Kconfig                      |   2 +
>  drivers/vfio/platform/Makefile                     |   2 +
>  drivers/vfio/platform/reset/Kconfig                |   7 ++
>  drivers/vfio/platform/reset/Makefile               |   5 +
>  .../platform/reset/vfio_platform_calxedaxgmac.c    | 121 +++++++++++++++++++++
>  5 files changed, 137 insertions(+)
>  create mode 100644 drivers/vfio/platform/reset/Kconfig
>  create mode 100644 drivers/vfio/platform/reset/Makefile
>  create mode 100644 drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
> 
> diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
> index 9a4403e..1df7477 100644
> --- a/drivers/vfio/platform/Kconfig
> +++ b/drivers/vfio/platform/Kconfig
> @@ -18,3 +18,5 @@ config VFIO_AMBA
>  	  framework.
>  
>  	  If you don't know what to do here, say N.
> +
> +source "drivers/vfio/platform/reset/Kconfig"
> diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
> index 81de144..9ce8afe 100644
> --- a/drivers/vfio/platform/Makefile
> +++ b/drivers/vfio/platform/Makefile
> @@ -2,7 +2,9 @@
>  vfio-platform-y := vfio_platform.o vfio_platform_common.o vfio_platform_irq.o
>  
>  obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
> +obj-$(CONFIG_VFIO_PLATFORM) += reset/
>  
>  vfio-amba-y := vfio_amba.o
>  
>  obj-$(CONFIG_VFIO_AMBA) += vfio-amba.o
> +obj-$(CONFIG_VFIO_AMBA) += reset/
> diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
> new file mode 100644
> index 0000000..746b96b
> --- /dev/null
> +++ b/drivers/vfio/platform/reset/Kconfig
> @@ -0,0 +1,7 @@
> +config VFIO_PLATFORM_CALXEDAXGMAC_RESET
> +	tristate "VFIO support for calxeda xgmac reset"
> +	depends on VFIO_PLATFORM
> +	help
> +	  Enables the VFIO platform driver to handle reset for Calxeda xgmac
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/platform/reset/Makefile b/drivers/vfio/platform/reset/Makefile
> new file mode 100644
> index 0000000..2a486af
> --- /dev/null
> +++ b/drivers/vfio/platform/reset/Makefile
> @@ -0,0 +1,5 @@
> +vfio-platform-calxedaxgmac-y := vfio_platform_calxedaxgmac.o
> +
> +ccflags-y += -Idrivers/vfio/platform
> +
> +obj-$(CONFIG_VFIO_PLATFORM_CALXEDAXGMAC_RESET) += vfio-platform-calxedaxgmac.o
> diff --git a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
> new file mode 100644
> index 0000000..3c6e428
> --- /dev/null
> +++ b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
> @@ -0,0 +1,121 @@
> +/*
> + * VFIO platform driver specialized for Calxeda xgmac reset
> + * reset code is inherited from calxeda xgmac native driver
> + *
> + * Copyright 2010-2011 Calxeda, Inc.
> + * Copyright (c) 2015 Linaro Ltd.
> + *              www.linaro.org
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +
> +#include "vfio_platform_private.h"
> +
> +#define DRIVER_VERSION  "0.1"
> +#define DRIVER_AUTHOR   "Eric Auger <eric.auger@linaro.org>"
> +#define DRIVER_DESC     "Reset support for Calxeda xgmac vfio platform device"
> +
> +#define CALXEDAXGMAC_COMPAT "calxeda,hb-xgmac"
> +
> +/* XGMAC Register definitions */
> +#define XGMAC_CONTROL           0x00000000      /* MAC Configuration */
> +
> +/* DMA Control and Status Registers */
> +#define XGMAC_DMA_CONTROL       0x00000f18      /* Ctrl (Operational Mode) */
> +#define XGMAC_DMA_INTR_ENA      0x00000f1c      /* Interrupt Enable */
> +
> +/* DMA Control registe defines */
> +#define DMA_CONTROL_ST          0x00002000      /* Start/Stop Transmission */
> +#define DMA_CONTROL_SR          0x00000002      /* Start/Stop Receive */
> +
> +/* Common MAC defines */
> +#define MAC_ENABLE_TX           0x00000008      /* Transmitter Enable */
> +#define MAC_ENABLE_RX           0x00000004      /* Receiver Enable */
> +
> +static inline void xgmac_mac_disable(void __iomem *ioaddr)
> +{
> +	u32 value = readl(ioaddr + XGMAC_DMA_CONTROL);
> +
> +	value &= ~(DMA_CONTROL_ST | DMA_CONTROL_SR);
> +	writel(value, ioaddr + XGMAC_DMA_CONTROL);
> +
> +	value = readl(ioaddr + XGMAC_CONTROL);
> +	value &= ~(MAC_ENABLE_TX | MAC_ENABLE_RX);
> +	writel(value, ioaddr + XGMAC_CONTROL);
> +}
> +
> +int vfio_platform_calxedaxgmac_reset(struct vfio_platform_device *vdev)
> +{
> +	struct vfio_platform_region reg = vdev->regions[0];
> +
> +	if (!reg.ioaddr) {
> +		reg.ioaddr =
> +			ioremap_nocache(reg.addr, reg.size);
> +		if (!reg.ioaddr)
> +			return -ENOMEM;
> +	}
> +
> +	/* disable IRQ */
> +	writel(0, reg.ioaddr + XGMAC_DMA_INTR_ENA);
> +
> +	/* Disable the MAC core */
> +	xgmac_mac_disable(reg.ioaddr);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(vfio_platform_calxedaxgmac_reset);
> +
> +static int __init vfio_platform_calxedaxgmac_init(void)
> +{
> +	int (*register_reset)(char *, struct module *,
> +				vfio_platform_reset_fn_t);
> +	int ret;
> +
> +	register_reset = symbol_get(vfio_platform_register_reset);
> +	if (!register_reset)
> +		return -EINVAL;
> +
> +	ret = register_reset(CALXEDAXGMAC_COMPAT, THIS_MODULE,
> +			     vfio_platform_calxedaxgmac_reset);
> +
> +	symbol_put(vfio_platform_register_reset);
> +
> +	return ret;
> +}
> +
> +static void __exit vfio_platform_calxedaxgmac_exit(void)
> +{
> +	int (*unregister_reset)(char *);
> +	int ret;
> +
> +	unregister_reset = symbol_get(vfio_platform_unregister_reset);

Shouldn't we have gotten the symbol during the module init so that this
cannot fail?

> +	if (!unregister_reset)
> +		return;
> +
> +	ret = unregister_reset(CALXEDAXGMAC_COMPAT);

unregister_reset() should just return void

> +
> +	symbol_put(vfio_platform_unregister_reset);
> +}
> +
> +module_init(vfio_platform_calxedaxgmac_init);
> +module_exit(vfio_platform_calxedaxgmac_exit);
> +
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);


So a user needs to manually load this module to get a working reset for
this device?  That's never going to happen.
