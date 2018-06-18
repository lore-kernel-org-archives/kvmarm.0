From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v6 kvmtool 02/13] pci: allow to specify IRQ type for PCI
 devices
Date: Mon, 18 Jun 2018 19:42:00 +0100
Message-ID: <20180618184211.43904-3-jean-philippe.brucker@arm.com>
References: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1281B4A0EC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t4uBnAT-TT1K for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jun 2018 14:31:27 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 402374A0D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:27 -0400 (EDT)
In-Reply-To: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org
Cc: lorenzo.pieralisi@arm.com, marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, alex.williamson@redhat.com, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Currently all our virtual device interrupts are edge-triggered. But we're
going to need level-triggered interrupts when passing physical devices.
Let the device configure its interrupt kind. Keep edge as default, to
avoid changing existing users.

Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 arm/pci.c         | 3 ++-
 include/kvm/pci.h | 6 ++++++
 pci.c             | 3 +++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arm/pci.c b/arm/pci.c
index 813df26a8..744b14c26 100644
--- a/arm/pci.c
+++ b/arm/pci.c
@@ -77,6 +77,7 @@ void pci__generate_fdt_nodes(void *fdt)
 		u8 dev_num = dev_hdr->dev_num;
 		u8 pin = pci_hdr->irq_pin;
 		u8 irq = pci_hdr->irq_line;
+		u32 irq_flags = pci_hdr->irq_type;
 
 		*entry = (struct of_interrupt_map_entry) {
 			.pci_irq_mask = {
@@ -93,7 +94,7 @@ void pci__generate_fdt_nodes(void *fdt)
 			.gic_irq = {
 				.type	= cpu_to_fdt32(GIC_FDT_IRQ_TYPE_SPI),
 				.num	= cpu_to_fdt32(irq - GIC_SPI_IRQ_BASE),
-				.flags	= cpu_to_fdt32(IRQ_TYPE_EDGE_RISING),
+				.flags	= cpu_to_fdt32(irq_flags),
 			},
 		};
 
diff --git a/include/kvm/pci.h b/include/kvm/pci.h
index 56649d87d..5d9c0f3b0 100644
--- a/include/kvm/pci.h
+++ b/include/kvm/pci.h
@@ -9,6 +9,7 @@
 #include "kvm/devices.h"
 #include "kvm/kvm.h"
 #include "kvm/msi.h"
+#include "kvm/fdt.h"
 
 /*
  * PCI Configuration Mechanism #1 I/O ports. See Section 3.7.4.1.
@@ -105,6 +106,11 @@ struct pci_device_header {
 	/* Private to lkvm */
 	u32		bar_size[6];
 	struct pci_config_operations	cfg_ops;
+	/*
+	 * PCI INTx# are level-triggered, but virtual device often feature
+	 * edge-triggered INTx# for convenience.
+	 */
+	enum irq_type	irq_type;
 };
 
 int pci__init(struct kvm *kvm);
diff --git a/pci.c b/pci.c
index e48e24b8c..5a8c2ef41 100644
--- a/pci.c
+++ b/pci.c
@@ -39,6 +39,9 @@ void pci__assign_irq(struct device_header *dev_hdr)
 	 */
 	pci_hdr->irq_pin	= 1;
 	pci_hdr->irq_line	= irq__alloc_line();
+
+	if (!pci_hdr->irq_type)
+		pci_hdr->irq_type = IRQ_TYPE_EDGE_RISING;
 }
 
 static void *pci_config_address_ptr(u16 port)
-- 
2.17.0
