From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v5] VFIO: platform: reset: AMD xgbe reset module
Date: Tue,  3 Nov 2015 18:20:57 +0000
Message-ID: <1446574857-2336-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D0694972F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 13:17:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iKfT17xhjrfe for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2015 13:17:53 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEBFB4970D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 13:17:53 -0500 (EST)
Received: by wmff134 with SMTP id f134so22233569wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Nov 2015 10:21:04 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, arnd@arndb.de, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: thomas.lendacky@amd.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch introduces a module that registers and implements a low-level
reset function for the AMD XGBE device.

it performs the following actions:
- reset the PHY
- disable auto-negotiation
- disable & clear auto-negotiation IRQ
- soft-reset the MAC

Those tiny pieces of code are inherited from the native xgbe driver.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>

---

Applies on top of [PATCH v6 0/8] VFIO platform reset module rework

v4 -> v5:
- fix ioaddr leak
  iounmap is done in vfio platform driver (vfio_platform_regions_cleanup)
  after reset (vfio_platform_release)

v3 -> v4:
- add Arnd's R-b

v2 -> v3:
- in Kconfig, add empty line between the 2 options
- remove DRIVER_VERSION, DRIVER_AUTHOR and DRIVER_DESC and put
  strings directly in MODULE macros

v1 -> v2:
- uses module_vfio_reset_handler macro
---
 drivers/vfio/platform/reset/Kconfig                |   8 ++
 drivers/vfio/platform/reset/Makefile               |   2 +
 .../vfio/platform/reset/vfio_platform_amdxgbe.c    | 127 +++++++++++++++++++++
 3 files changed, 137 insertions(+)
 create mode 100644 drivers/vfio/platform/reset/vfio_platform_amdxgbe.c

diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
index 746b96b..70cccc5 100644
--- a/drivers/vfio/platform/reset/Kconfig
+++ b/drivers/vfio/platform/reset/Kconfig
@@ -5,3 +5,11 @@ config VFIO_PLATFORM_CALXEDAXGMAC_RESET
 	  Enables the VFIO platform driver to handle reset for Calxeda xgmac
 
 	  If you don't know what to do here, say N.
+
+config VFIO_PLATFORM_AMDXGBE_RESET
+	tristate "VFIO support for AMD XGBE reset"
+	depends on VFIO_PLATFORM
+	help
+	  Enables the VFIO platform driver to handle reset for AMD XGBE
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/platform/reset/Makefile b/drivers/vfio/platform/reset/Makefile
index 2a486af..93f4e23 100644
--- a/drivers/vfio/platform/reset/Makefile
+++ b/drivers/vfio/platform/reset/Makefile
@@ -1,5 +1,7 @@
 vfio-platform-calxedaxgmac-y := vfio_platform_calxedaxgmac.o
+vfio-platform-amdxgbe-y := vfio_platform_amdxgbe.o
 
 ccflags-y += -Idrivers/vfio/platform
 
 obj-$(CONFIG_VFIO_PLATFORM_CALXEDAXGMAC_RESET) += vfio-platform-calxedaxgmac.o
+obj-$(CONFIG_VFIO_PLATFORM_AMDXGBE_RESET) += vfio-platform-amdxgbe.o
diff --git a/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c b/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
new file mode 100644
index 0000000..da5356f
--- /dev/null
+++ b/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
@@ -0,0 +1,127 @@
+/*
+ * VFIO platform driver specialized for AMD xgbe reset
+ * reset code is inherited from AMD xgbe native driver
+ *
+ * Copyright (c) 2015 Linaro Ltd.
+ *              www.linaro.org
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <uapi/linux/mdio.h>
+#include <linux/delay.h>
+
+#include "vfio_platform_private.h"
+
+#define DMA_MR			0x3000
+#define MAC_VR			0x0110
+#define DMA_ISR			0x3008
+#define MAC_ISR			0x00b0
+#define PCS_MMD_SELECT		0xff
+#define MDIO_AN_INT		0x8002
+#define MDIO_AN_INTMASK		0x8001
+
+static unsigned int xmdio_read(void *ioaddr, unsigned int mmd,
+			       unsigned int reg)
+{
+	unsigned int mmd_address, value;
+
+	mmd_address = (mmd << 16) | ((reg) & 0xffff);
+	iowrite32(mmd_address >> 8, ioaddr + (PCS_MMD_SELECT << 2));
+	value = ioread32(ioaddr + ((mmd_address & 0xff) << 2));
+	return value;
+}
+
+static void xmdio_write(void *ioaddr, unsigned int mmd,
+			unsigned int reg, unsigned int value)
+{
+	unsigned int mmd_address;
+
+	mmd_address = (mmd << 16) | ((reg) & 0xffff);
+	iowrite32(mmd_address >> 8, ioaddr + (PCS_MMD_SELECT << 2));
+	iowrite32(value, ioaddr + ((mmd_address & 0xff) << 2));
+}
+
+int vfio_platform_amdxgbe_reset(struct vfio_platform_device *vdev)
+{
+	struct vfio_platform_region *xgmac_regs = &vdev->regions[0];
+	struct vfio_platform_region *xpcs_regs = &vdev->regions[1];
+	u32 dma_mr_value, pcs_value, value;
+	unsigned int count;
+
+	if (!xgmac_regs->ioaddr) {
+		xgmac_regs->ioaddr =
+			ioremap_nocache(xgmac_regs->addr, xgmac_regs->size);
+		if (!xgmac_regs->ioaddr)
+			return -ENOMEM;
+	}
+	if (!xpcs_regs->ioaddr) {
+		xpcs_regs->ioaddr =
+			ioremap_nocache(xpcs_regs->addr, xpcs_regs->size);
+		if (!xpcs_regs->ioaddr)
+			return -ENOMEM;
+	}
+
+	/* reset the PHY through MDIO*/
+	pcs_value = xmdio_read(xpcs_regs->ioaddr, MDIO_MMD_PCS, MDIO_CTRL1);
+	pcs_value |= MDIO_CTRL1_RESET;
+	xmdio_write(xpcs_regs->ioaddr, MDIO_MMD_PCS, MDIO_CTRL1, pcs_value);
+
+	count = 50;
+	do {
+		msleep(20);
+		pcs_value = xmdio_read(xpcs_regs->ioaddr, MDIO_MMD_PCS,
+					MDIO_CTRL1);
+	} while ((pcs_value & MDIO_CTRL1_RESET) && --count);
+
+	if (pcs_value & MDIO_CTRL1_RESET)
+		pr_warn("%s XGBE PHY reset timeout\n", __func__);
+
+	/* disable auto-negotiation */
+	value = xmdio_read(xpcs_regs->ioaddr, MDIO_MMD_AN, MDIO_CTRL1);
+	value &= ~MDIO_AN_CTRL1_ENABLE;
+	xmdio_write(xpcs_regs->ioaddr, MDIO_MMD_AN, MDIO_CTRL1, value);
+
+	/* disable AN IRQ */
+	xmdio_write(xpcs_regs->ioaddr, MDIO_MMD_AN, MDIO_AN_INTMASK, 0);
+
+	/* clear AN IRQ */
+	xmdio_write(xpcs_regs->ioaddr, MDIO_MMD_AN, MDIO_AN_INT, 0);
+
+	/* MAC software reset */
+	dma_mr_value = ioread32(xgmac_regs->ioaddr + DMA_MR);
+	dma_mr_value |= 0x1;
+	iowrite32(dma_mr_value, xgmac_regs->ioaddr + DMA_MR);
+
+	usleep_range(10, 15);
+
+	count = 2000;
+	while (count-- && (ioread32(xgmac_regs->ioaddr + DMA_MR) & 1))
+		usleep_range(500, 600);
+
+	if (!count)
+		pr_warn("%s MAC SW reset failed\n", __func__);
+
+	return 0;
+}
+
+module_vfio_reset_handler("amd,xgbe-seattle-v1a", vfio_platform_amdxgbe_reset);
+
+MODULE_VERSION("0.1");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Eric Auger <eric.auger@linaro.org>");
+MODULE_DESCRIPTION("Reset support for AMD xgbe vfio platform device");
-- 
1.9.1
