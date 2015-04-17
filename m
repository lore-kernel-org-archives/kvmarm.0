From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 3/3] VFIO: platform: add vfio-platform-calxedaxgmac driver
Date: Fri, 17 Apr 2015 15:37:13 +0200
Message-ID: <1429277833-28663-4-git-send-email-eric.auger@linaro.org>
References: <1429277833-28663-1-git-send-email-eric.auger@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1429277833-28663-1-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, agraf@suse.de, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, Bharat.Bhushan@freescale.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch introduces a specialized vfio platform driver for the
calxeda xgmac. On top of the generic vfio platform driver functionalities,
it implements the reset modality.  This latter basically disables interrupts
and stops DMA transfers.

Code is inherited from calxeda xgmac native driver

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/vfio/platform/Kconfig                      |   2 +
 drivers/vfio/platform/Makefile                     |   2 +
 drivers/vfio/platform/reset/Kconfig                |   7 ++
 drivers/vfio/platform/reset/Makefile               |   5 +
 .../platform/reset/vfio_platform_calxedaxgmac.c    | 109 +++++++++++++++++++++
 5 files changed, 125 insertions(+)
 create mode 100644 drivers/vfio/platform/reset/Kconfig
 create mode 100644 drivers/vfio/platform/reset/Makefile
 create mode 100644 drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c

diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
index 9a4403e..1df7477 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -18,3 +18,5 @@ config VFIO_AMBA
 	  framework.
 
 	  If you don't know what to do here, say N.
+
+source "drivers/vfio/platform/reset/Kconfig"
diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
index 81de144..9ce8afe 100644
--- a/drivers/vfio/platform/Makefile
+++ b/drivers/vfio/platform/Makefile
@@ -2,7 +2,9 @@
 vfio-platform-y := vfio_platform.o vfio_platform_common.o vfio_platform_irq.o
 
 obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
+obj-$(CONFIG_VFIO_PLATFORM) += reset/
 
 vfio-amba-y := vfio_amba.o
 
 obj-$(CONFIG_VFIO_AMBA) += vfio-amba.o
+obj-$(CONFIG_VFIO_AMBA) += reset/
diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
new file mode 100644
index 0000000..2c09cea
--- /dev/null
+++ b/drivers/vfio/platform/reset/Kconfig
@@ -0,0 +1,7 @@
+config VFIO_PLATFORM_CALXEDAXGMAC
+	tristate "VFIO support for calxeda xgmac"
+	depends on VFIO_PLATFORM
+	help
+	  Support for VFIO platform driver specialized for Calxeda xgmac reset.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/platform/reset/Makefile b/drivers/vfio/platform/reset/Makefile
new file mode 100644
index 0000000..8977721
--- /dev/null
+++ b/drivers/vfio/platform/reset/Makefile
@@ -0,0 +1,5 @@
+vfio-platform-calxedaxgmac-y := vfio_platform_calxedaxgmac.o
+
+ccflags-y += -Idrivers/vfio/platform
+
+obj-$(CONFIG_VFIO_PLATFORM_CALXEDAXGMAC) += vfio-platform-calxedaxgmac.o
diff --git a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
new file mode 100644
index 0000000..729d0cd
--- /dev/null
+++ b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
@@ -0,0 +1,109 @@
+/*
+ * VFIO platform driver specialized for Calxeda xgmac reset
+ * reset code is inherited from calxeda xgmac native driver
+ *
+ * Copyright 2010-2011 Calxeda, Inc.
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
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/vfio.h>
+#include "vfio_platform_private.h"
+#include <linux/io.h>
+
+#define DRIVER_VERSION  "0.1"
+#define DRIVER_AUTHOR   "Eric Auger <eric.auger@linaro.org>"
+#define DRIVER_DESC     "VFIO - Calxeda xgmac vfio platform driver"
+
+/* XGMAC Register definitions */
+#define XGMAC_CONTROL           0x00000000      /* MAC Configuration */
+
+/* DMA Control and Status Registers */
+#define XGMAC_DMA_CONTROL       0x00000f18      /* Ctrl (Operational Mode) */
+#define XGMAC_DMA_INTR_ENA      0x00000f1c      /* Interrupt Enable */
+
+/* DMA Control registe defines */
+#define DMA_CONTROL_ST          0x00002000      /* Start/Stop Transmission */
+#define DMA_CONTROL_SR          0x00000002      /* Start/Stop Receive */
+
+/* Common MAC defines */
+#define MAC_ENABLE_TX           0x00000008      /* Transmitter Enable */
+#define MAC_ENABLE_RX           0x00000004      /* Receiver Enable */
+
+static inline void xgmac_mac_disable(void __iomem *ioaddr)
+{
+	u32 value = readl(ioaddr + XGMAC_DMA_CONTROL);
+
+	value &= ~(DMA_CONTROL_ST | DMA_CONTROL_SR);
+	writel(value, ioaddr + XGMAC_DMA_CONTROL);
+
+	value = readl(ioaddr + XGMAC_CONTROL);
+	value &= ~(MAC_ENABLE_TX | MAC_ENABLE_RX);
+	writel(value, ioaddr + XGMAC_CONTROL);
+}
+
+static int vfio_platform_calxedaxgmac_reset(struct vfio_platform_device *vdev)
+{
+	struct resource *res = get_platform_resource(vdev, 0);
+	void __iomem *base = phys_to_virt(res->start);
+
+	if (!base)
+		return -ENOMEM;
+
+	/* disable IRQ */
+	writel(0, base + XGMAC_DMA_INTR_ENA);
+
+	/* Disable the MAC core */
+	xgmac_mac_disable(base);
+
+	return 0;
+}
+
+static int vfio_platform_calxedaxgmac_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct vfio_device *vfio_dev;
+	struct vfio_platform_device *vpdev;
+
+	ret = vfio_platform_probe(pdev);
+	if (ret)
+		return ret;
+
+	vfio_dev = vfio_device_get_from_dev(&pdev->dev),
+	vpdev = (struct vfio_platform_device *) vfio_device_data(vfio_dev);
+	vpdev->reset = vfio_platform_calxedaxgmac_reset;
+
+	return ret;
+}
+
+static struct platform_driver vfio_platform_calxedaxgmac_driver = {
+	.driver = {
+		.name = "vfio-platform-calxedaxgmac",
+	},
+	.probe = vfio_platform_calxedaxgmac_probe,
+	.remove = vfio_platform_remove,
+};
+
+module_platform_driver(vfio_platform_calxedaxgmac_driver);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
-- 
1.9.1

