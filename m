From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 07/16] arm/pci: Fix PCI IO region
Date: Thu,  7 Mar 2019 08:36:08 +0000
Message-ID: <1551947777-13044-8-git-send-email-julien.thierry@arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B8A14A48E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zvq-HS67pKn7 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Mar 2019 03:36:35 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 185464A4C1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:35 -0500 (EST)
In-Reply-To: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Andre.Przywara@arm.com, Sami.Mujawar@arm.com, will.deacon@arm.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Current PCI IO region that is exposed through the DT contains ports that
are reserved by non-PCI devices.

Use the proper PCI IO start so that the region exposed through DT can
actually be used to reassign device BARs.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 arm/include/arm-common/pci.h |  1 +
 arm/kvm.c                    |  3 +++
 arm/pci.c                    | 21 ++++++++++++++++++---
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arm/include/arm-common/pci.h b/arm/include/arm-common/pci.h
index 9008a0e..aea42b8 100644
--- a/arm/include/arm-common/pci.h
+++ b/arm/include/arm-common/pci.h
@@ -1,6 +1,7 @@
 #ifndef ARM_COMMON__PCI_H
 #define ARM_COMMON__PCI_H
 
+void pci__arm_init(struct kvm *kvm);
 void pci__generate_fdt_nodes(void *fdt);
 
 #endif /* ARM_COMMON__PCI_H */
diff --git a/arm/kvm.c b/arm/kvm.c
index b824f63..44d7796 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -6,6 +6,7 @@
 #include "kvm/fdt.h"
 
 #include "arm-common/gic.h"
+#include "arm-common/pci.h"
 
 #include <linux/kernel.h>
 #include <linux/kvm.h>
@@ -86,6 +87,8 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 	/* Create the virtual GIC. */
 	if (gic__create(kvm, kvm->cfg.arch.irqchip))
 		die("Failed to create virtual GIC");
+
+	pci__arm_init(kvm);
 }
 
 #define FDT_ALIGN	SZ_2M
diff --git a/arm/pci.c b/arm/pci.c
index 557cfa9..83238ca 100644
--- a/arm/pci.c
+++ b/arm/pci.c
@@ -1,3 +1,5 @@
+#include "linux/sizes.h"
+
 #include "kvm/devices.h"
 #include "kvm/fdt.h"
 #include "kvm/kvm.h"
@@ -7,6 +9,11 @@
 
 #include "arm-common/pci.h"
 
+#define ARM_PCI_IO_START ALIGN(PCI_IOPORT_START, SZ_4K)
+
+/* Must be a multiple of 4k */
+#define ARM_PCI_IO_SIZE ((ARM_MMIO_AREA - ARM_PCI_IO_START) & ~(SZ_4K - 1))
+
 /*
  * An entry in the interrupt-map table looks like:
  * <pci unit address> <pci interrupt pin> <gic phandle> <gic interrupt>
@@ -24,6 +31,14 @@ struct of_interrupt_map_entry {
 	struct of_gic_irq		gic_irq;
 } __attribute__((packed));
 
+void pci__arm_init(struct kvm *kvm)
+{
+	u32 align_pad = ARM_PCI_IO_START - PCI_IOPORT_START;
+
+	/* Make PCI port allocation start at a properly aligned address */
+	pci_get_io_space_block(align_pad);
+}
+
 void pci__generate_fdt_nodes(void *fdt)
 {
 	struct device_header *dev_hdr;
@@ -40,10 +55,10 @@ void pci__generate_fdt_nodes(void *fdt)
 			.pci_addr = {
 				.hi	= cpu_to_fdt32(of_pci_b_ss(OF_PCI_SS_IO)),
 				.mid	= 0,
-				.lo	= 0,
+				.lo	= cpu_to_fdt32(ARM_PCI_IO_START),
 			},
-			.cpu_addr	= cpu_to_fdt64(KVM_IOPORT_AREA),
-			.length		= cpu_to_fdt64(ARM_IOPORT_SIZE),
+			.cpu_addr	= cpu_to_fdt64(ARM_PCI_IO_START),
+			.length		= cpu_to_fdt64(ARM_PCI_IO_SIZE),
 		},
 		{
 			.pci_addr = {
-- 
1.9.1
