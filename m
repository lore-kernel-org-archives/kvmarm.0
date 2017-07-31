From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 15/59] irqchip/gic-v3-its: Add GICv4 ITS command definitions
Date: Mon, 31 Jul 2017 18:25:53 +0100
Message-ID: <20170731172637.29355-16-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170731172637.29355-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Add the new GICv4 ITS command definitions, most of them, being
defined in terms of their physical counterparts.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c   |  2 +-
 include/linux/irqchip/arm-gic-v3.h | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 7ef448a963c1..bc396ab24037 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2013, 2014 ARM Limited, All Rights Reserved.
+ * Copyright (C) 2013-2017 ARM Limited, All Rights Reserved.
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index af8c55105fc2..7c6fd8f3e36c 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -348,6 +348,18 @@
 #define GITS_CMD_SYNC			0x05
 
 /*
+ * GICv4 ITS specific commands
+ */
+#define GITS_CMD_GICv4(x)		((x) | 0x20)
+#define GITS_CMD_VINVALL		GITS_CMD_GICv4(GITS_CMD_INVALL)
+#define GITS_CMD_VMAPP			GITS_CMD_GICv4(GITS_CMD_MAPC)
+#define GITS_CMD_VMAPTI			GITS_CMD_GICv4(GITS_CMD_MAPTI)
+#define GITS_CMD_VMOVI			GITS_CMD_GICv4(GITS_CMD_MOVI)
+#define GITS_CMD_VSYNC			GITS_CMD_GICv4(GITS_CMD_SYNC)
+/* VMOVP is the odd one, as it doesn't have a physical counterpart */
+#define GITS_CMD_VMOVP			GITS_CMD_GICv4(2)
+
+/*
  * ITS error numbers
  */
 #define E_ITS_MOVI_UNMAPPED_INTERRUPT		0x010107
-- 
2.11.0
