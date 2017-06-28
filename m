From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 14/52] irqchip/gic-v4: Add management structure definitions
Date: Wed, 28 Jun 2017 16:03:33 +0100
Message-ID: <20170628150411.15846-15-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAB7640D77
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:04:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sG-hInVNLRVl for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:04:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D141641260
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:04:51 -0400 (EDT)
In-Reply-To: <20170628150411.15846-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

Add a bunch of GICv4-specific data structures that will get used in
subsequent patches.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irqchip/arm-gic-v4.h | 91 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)
 create mode 100644 include/linux/irqchip/arm-gic-v4.h

diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
new file mode 100644
index 000000000000..4cac48e220da
--- /dev/null
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -0,0 +1,91 @@
+/*
+ * Copyright (C) 2016 ARM Limited, All Rights Reserved.
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __LINUX_IRQCHIP_ARM_GIC_V4_H
+#define __LINUX_IRQCHIP_ARM_GIC_V4_H
+
+struct its_vpe;
+
+/* Embedded in kvm.arch */
+struct its_vm {
+	struct irq_domain	*domain;
+	struct page		*vprop_page;
+	struct its_vpe		**vpes;
+	int			nr_vpes;
+	irq_hw_number_t		db_lpi_base;
+	unsigned long		*db_bitmap;
+	int			nr_db_lpis;
+};
+
+/* Embedded in kvm_vcpu.arch */
+struct its_vpe {
+	struct page 		*vpt_page;
+	struct its_vm		*its_vm;
+	/* Doorbell interrupt */
+	int			irq;
+	irq_hw_number_t		vpe_db_lpi;
+	/*
+	 * This collection ID is used to indirect the target
+	 * redistributor for this VPE. The ID itself isn't involved in
+	 * programming of the ITS.
+	 */
+	u16			col_idx;
+	/* Unique (system-wide) VPE identifier */
+	u16			vpe_id;
+	/* Implementation Defined Area Invalid */
+	bool			idai;
+	/* Pending VLPIs on schedule out? */
+	bool			pending_last;
+};
+
+/*
+ * struct its_vlpi_map: structure describing the mapping of a
+ * VLPI. Only to be interpreted in the context of a physical interrupt
+ * it complements.  To be used as the vcpu_info passed to
+ * irq_set_vcpu_affinity().
+ *
+ * @vm:		Pointer to the GICv4 notion of a VM
+ * @vintid:	Virtual LPI number
+ * @db_enabled:	Is the VPE doorbell to be generated?
+ * @vpe_idx:	Index (0-based) of the VPE in this VM. Not the vpe_id!
+ */
+struct its_vlpi_map {
+	struct its_vm		*vm;
+	u32			vintid;
+	bool			db_enabled;
+	u16			vpe_idx;
+};
+
+enum its_vcpu_info_cmd_type {
+	MAP_VLPI,
+	GET_VLPI,
+	PROP_UPDATE_VLPI,
+	PROP_UPDATE_AND_INV_VLPI,
+	SCHEDULE_VPE,
+	DESCHEDULE_VPE,
+	INVALL_VPE,
+};
+
+struct its_cmd_info {
+	enum its_vcpu_info_cmd_type	cmd_type;
+	union {
+		struct its_vlpi_map	*map;
+		u8			config;
+	};
+};
+
+#endif
-- 
2.11.0
