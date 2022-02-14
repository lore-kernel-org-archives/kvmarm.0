Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE891C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 16:58:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ECAC49F51;
	Mon, 14 Feb 2022 11:58:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b9udMdFuue91; Mon, 14 Feb 2022 11:58:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E23249F26;
	Mon, 14 Feb 2022 11:58:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A48649E3F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 11:58:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xhmy8IlKzULa for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 11:58:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BE6B49F0B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 11:58:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA5AE13D5;
 Mon, 14 Feb 2022 08:58:27 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 37F813F70D;
 Mon, 14 Feb 2022 08:58:26 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
 pierre.gondois@arm.com
Subject: [PATCH kvmtool 3/3] arm: pci: Generate "msi-parent" property only
 with a MSI controller
Date: Mon, 14 Feb 2022 16:58:30 +0000
Message-Id: <20220214165830.69207-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214165830.69207-1-alexandru.elisei@arm.com>
References: <20220214165830.69207-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The "msi-parent" PCI root complex property describes the MSI parent of the
root complex. When the VM is created with a GICv2 or GICv3 irqchip
(--irqchip=gicv3 or --irqchip=gicv2), there is no MSI controller present on
the system and the corresponding phandle is not generated, leaving the
"msi-parent" property to point to a non-existing phandle. Skip creating the
"msi-parent" property when no MSI controller exists.

Reported-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/fdt.c                    | 2 +-
 arm/include/arm-common/pci.h | 3 ++-
 arm/pci.c                    | 8 ++++++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arm/fdt.c b/arm/fdt.c
index 635de7f27fa5..286ccadf1311 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -190,7 +190,7 @@ static int setup_fdt(struct kvm *kvm)
 	}
 
 	/* PCI host controller */
-	pci__generate_fdt_nodes(fdt);
+	pci__generate_fdt_nodes(fdt, kvm);
 
 	/* PSCI firmware */
 	_FDT(fdt_begin_node(fdt, "psci"));
diff --git a/arm/include/arm-common/pci.h b/arm/include/arm-common/pci.h
index 9008a0ed072e..afa7f7f42bcb 100644
--- a/arm/include/arm-common/pci.h
+++ b/arm/include/arm-common/pci.h
@@ -1,6 +1,7 @@
 #ifndef ARM_COMMON__PCI_H
 #define ARM_COMMON__PCI_H
 
-void pci__generate_fdt_nodes(void *fdt);
+struct kvm;
+void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm);
 
 #endif /* ARM_COMMON__PCI_H */
diff --git a/arm/pci.c b/arm/pci.c
index e44e45343c6a..5bd82d438807 100644
--- a/arm/pci.c
+++ b/arm/pci.c
@@ -6,6 +6,7 @@
 #include "kvm/util.h"
 
 #include "arm-common/pci.h"
+#include "arm-common/gic.h"
 
 /*
  * An entry in the interrupt-map table looks like:
@@ -24,8 +25,9 @@ struct of_interrupt_map_entry {
 	struct of_gic_irq		gic_irq;
 } __attribute__((packed));
 
-void pci__generate_fdt_nodes(void *fdt)
+void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
+	enum irqchip_type irqchip = kvm->cfg.arch.irqchip;
 	struct device_header *dev_hdr;
 	struct of_interrupt_map_entry irq_map[OF_PCI_IRQ_MAP_MAX];
 	unsigned nentries = 0;
@@ -68,7 +70,9 @@ void pci__generate_fdt_nodes(void *fdt)
 	_FDT(fdt_property(fdt, "bus-range", bus_range, sizeof(bus_range)));
 	_FDT(fdt_property(fdt, "reg", &cfg_reg_prop, sizeof(cfg_reg_prop)));
 	_FDT(fdt_property(fdt, "ranges", ranges, sizeof(ranges)));
-	_FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_MSI));
+
+	if (irqchip == IRQCHIP_GICV2M || irqchip == IRQCHIP_GICV3_ITS)
+		_FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_MSI));
 
 	/* Generate the interrupt map ... */
 	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
