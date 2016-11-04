From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v8 03/16] irq: move IRQ routing into irq.c
Date: Fri,  4 Nov 2016 17:31:50 +0000
Message-ID: <20161104173203.21168-4-andre.przywara@arm.com>
References: <20161104173203.21168-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 161F64042D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2016 13:31:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OvR+cL6GFAiG for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2016 13:31:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D01484029B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2016 13:31:25 -0400 (EDT)
In-Reply-To: <20161104173203.21168-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The current IRQ routing code in x86/irq.c is mostly implementing a
generic KVM interface which other architectures may use too.
Move the code to set up an MSI route into the generic irq.c file and
guard it with the KVM_CAP_IRQ_ROUTING capability to return an error
if the kernel does not support interrupt routing.
This also removes the dummy implementations for all other
architectures and only leaves the x86 specific code in x86/irq.c.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Makefile          |  4 +--
 arm/irq.c         |  9 ------
 hw/pci-shmem.c    |  2 ++
 include/kvm/irq.h |  5 ++++
 irq.c             | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mips/irq.c        | 10 -------
 powerpc/irq.c     | 31 --------------------
 virtio/pci.c      | 21 +++++++++-----
 x86/irq.c         | 45 ++++------------------------
 9 files changed, 114 insertions(+), 100 deletions(-)
 delete mode 100644 arm/irq.c
 delete mode 100644 mips/irq.c
 delete mode 100644 powerpc/irq.c

diff --git a/Makefile b/Makefile
index e4a4002..8ca887f 100644
--- a/Makefile
+++ b/Makefile
@@ -138,7 +138,6 @@ ifeq ($(ARCH), powerpc)
 	DEFINES += -DCONFIG_PPC
 	OBJS	+= powerpc/boot.o
 	OBJS	+= powerpc/ioport.o
-	OBJS	+= powerpc/irq.o
 	OBJS	+= powerpc/kvm.o
 	OBJS	+= powerpc/cpu_info.o
 	OBJS	+= powerpc/kvm-cpu.o
@@ -153,7 +152,7 @@ ifeq ($(ARCH), powerpc)
 endif
 
 # ARM
-OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/ioport.o arm/irq.o \
+OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/ioport.o \
 			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o \
 			   arm/pmu.o
 HDRS_ARM_COMMON		:= arm/include
@@ -186,7 +185,6 @@ ifeq ($(ARCH),mips)
 	ARCH_INCLUDE	:= mips/include
 	OBJS		+= mips/kvm.o
 	OBJS		+= mips/kvm-cpu.o
-	OBJS		+= mips/irq.o
 endif
 ###
 
diff --git a/arm/irq.c b/arm/irq.c
deleted file mode 100644
index d8f44df..0000000
--- a/arm/irq.c
+++ /dev/null
@@ -1,9 +0,0 @@
-#include "kvm/irq.h"
-#include "kvm/kvm.h"
-#include "kvm/util.h"
-
-int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg)
-{
-	die(__FUNCTION__);
-	return 0;
-}
diff --git a/hw/pci-shmem.c b/hw/pci-shmem.c
index a1c5ab7..7ce98cb 100644
--- a/hw/pci-shmem.c
+++ b/hw/pci-shmem.c
@@ -136,6 +136,8 @@ int pci_shmem__get_local_irqfd(struct kvm *kvm)
 
 		if (pci_shmem_pci_device.msix.ctrl & cpu_to_le16(PCI_MSIX_FLAGS_ENABLE)) {
 			gsi = irq__add_msix_route(kvm, &msix_table[0].msg);
+			if (gsi < 0)
+				return gsi;
 		} else {
 			gsi = pci_shmem_pci_device.irq_line;
 		}
diff --git a/include/kvm/irq.h b/include/kvm/irq.h
index 8a78e43..bb71521 100644
--- a/include/kvm/irq.h
+++ b/include/kvm/irq.h
@@ -10,11 +10,16 @@
 
 struct kvm;
 
+extern struct kvm_irq_routing *irq_routing;
+extern int next_gsi;
+
 int irq__alloc_line(void);
 int irq__get_nr_allocated_lines(void);
 
 int irq__init(struct kvm *kvm);
 int irq__exit(struct kvm *kvm);
+
+int irq__allocate_routing_entry(void);
 int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg);
 
 #endif
diff --git a/irq.c b/irq.c
index 71eaa05..a742aa2 100644
--- a/irq.c
+++ b/irq.c
@@ -1,7 +1,19 @@
+#include <stdlib.h>
+#include <sys/ioctl.h>
+#include <linux/types.h>
+#include <linux/kvm.h>
+#include <errno.h>
+
+#include "kvm/kvm.h"
 #include "kvm/irq.h"
 #include "kvm/kvm-arch.h"
 
 static u8 next_line = KVM_IRQ_OFFSET;
+static int allocated_gsis = 0;
+
+int next_gsi;
+
+struct kvm_irq_routing *irq_routing = NULL;
 
 int irq__alloc_line(void)
 {
@@ -12,3 +24,78 @@ int irq__get_nr_allocated_lines(void)
 {
 	return next_line - KVM_IRQ_OFFSET;
 }
+
+int irq__allocate_routing_entry(void)
+{
+	size_t table_size = sizeof(struct kvm_irq_routing);
+	size_t old_size = table_size;
+	int nr_entries = 0;
+
+	if (irq_routing)
+		nr_entries = irq_routing->nr;
+
+	if (nr_entries < allocated_gsis)
+		return 0;
+
+	old_size += sizeof(struct kvm_irq_routing_entry) * allocated_gsis;
+	allocated_gsis = ALIGN(nr_entries + 1, 32);
+	table_size += sizeof(struct kvm_irq_routing_entry) * allocated_gsis;
+	irq_routing = realloc(irq_routing, table_size);
+
+	if (irq_routing == NULL)
+		return -ENOMEM;
+	memset((void *)irq_routing + old_size, 0, table_size - old_size);
+
+	irq_routing->nr = nr_entries;
+	irq_routing->flags = 0;
+
+	return 0;
+}
+
+static bool check_for_irq_routing(struct kvm *kvm)
+{
+	static int has_irq_routing = 0;
+
+	if (has_irq_routing == 0) {
+		if (kvm__supports_extension(kvm, KVM_CAP_IRQ_ROUTING))
+			has_irq_routing = 1;
+		else
+			has_irq_routing = -1;
+	}
+
+	return has_irq_routing > 0;
+}
+
+int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg)
+{
+	int r;
+
+	if (!check_for_irq_routing(kvm))
+		return -ENXIO;
+
+	r = irq__allocate_routing_entry();
+	if (r)
+		return r;
+
+	irq_routing->entries[irq_routing->nr++] =
+		(struct kvm_irq_routing_entry) {
+			.gsi = next_gsi,
+			.type = KVM_IRQ_ROUTING_MSI,
+			.u.msi.address_hi = msg->address_hi,
+			.u.msi.address_lo = msg->address_lo,
+			.u.msi.data = msg->data,
+		};
+
+	r = ioctl(kvm->vm_fd, KVM_SET_GSI_ROUTING, irq_routing);
+	if (r)
+		return r;
+
+	return next_gsi++;
+}
+
+int __attribute__((weak)) irq__exit(struct kvm *kvm)
+{
+	free(irq_routing);
+	return 0;
+}
+dev_base_exit(irq__exit);
diff --git a/mips/irq.c b/mips/irq.c
deleted file mode 100644
index c1ff6bb..0000000
--- a/mips/irq.c
+++ /dev/null
@@ -1,10 +0,0 @@
-#include "kvm/irq.h"
-#include "kvm/kvm.h"
-
-#include <stdlib.h>
-
-int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg)
-{
-	pr_warning("irq__add_msix_route");
-	return 1;
-}
diff --git a/powerpc/irq.c b/powerpc/irq.c
deleted file mode 100644
index 03f2fe7..0000000
--- a/powerpc/irq.c
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- * PPC64 IRQ routines
- *
- * Copyright 2011 Matt Evans <matt@ozlabs.org>, IBM Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation.
- */
-
-#include "kvm/devices.h"
-#include "kvm/irq.h"
-#include "kvm/kvm.h"
-#include "kvm/util.h"
-
-#include <linux/types.h>
-#include <linux/rbtree.h>
-#include <linux/list.h>
-#include <linux/kvm.h>
-#include <sys/ioctl.h>
-
-#include <stddef.h>
-#include <stdlib.h>
-
-#include "kvm/pci.h"
-
-int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg)
-{
-	die(__FUNCTION__);
-	return 0;
-}
diff --git a/virtio/pci.c b/virtio/pci.c
index 90fcd64..072e5b7 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -156,7 +156,8 @@ static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *v
 					void *data, int size, int offset)
 {
 	struct virtio_pci *vpci = vdev->virtio;
-	u32 config_offset, gsi, vec;
+	u32 config_offset, vec;
+	int gsi;
 	int type = virtio__get_dev_specific_field(offset - 20, virtio_pci__msix_enabled(vpci),
 							&config_offset);
 	if (type == VIRTIO_PCI_O_MSIX) {
@@ -166,21 +167,27 @@ static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_device *v
 			if (vec == VIRTIO_MSI_NO_VECTOR)
 				break;
 
-			gsi = irq__add_msix_route(kvm, &vpci->msix_table[vec].msg);
-
-			vpci->config_gsi = gsi;
+			gsi = irq__add_msix_route(kvm,
+						  &vpci->msix_table[vec].msg);
+			if (gsi >= 0)
+				vpci->config_gsi = gsi;
 			break;
 		case VIRTIO_MSI_QUEUE_VECTOR:
-			vec = vpci->vq_vector[vpci->queue_selector] = ioport__read16(data);
+			vec = ioport__read16(data);
+			vpci->vq_vector[vpci->queue_selector] = vec;
 
 			if (vec == VIRTIO_MSI_NO_VECTOR)
 				break;
 
-			gsi = irq__add_msix_route(kvm, &vpci->msix_table[vec].msg);
+			gsi = irq__add_msix_route(kvm,
+						  &vpci->msix_table[vec].msg);
+			if (gsi < 0)
+				break;
 			vpci->gsis[vpci->queue_selector] = gsi;
 			if (vdev->ops->notify_vq_gsi)
 				vdev->ops->notify_vq_gsi(kvm, vpci->dev,
-							vpci->queue_selector, gsi);
+							 vpci->queue_selector,
+							 gsi);
 			break;
 		};
 
diff --git a/x86/irq.c b/x86/irq.c
index 72177e7..db465a1 100644
--- a/x86/irq.c
+++ b/x86/irq.c
@@ -11,20 +11,15 @@
 #include <stddef.h>
 #include <stdlib.h>
 
-#define IRQ_MAX_GSI			64
 #define IRQCHIP_MASTER			0
 #define IRQCHIP_SLAVE			1
 #define IRQCHIP_IOAPIC			2
 
-/* First 24 GSIs are routed between IRQCHIPs and IOAPICs */
-static u32 gsi = 24;
-
-struct kvm_irq_routing *irq_routing;
-
 static int irq__add_routing(u32 gsi, u32 type, u32 irqchip, u32 pin)
 {
-	if (gsi >= IRQ_MAX_GSI)
-		return -ENOSPC;
+	int r = irq__allocate_routing_entry();
+	if (r)
+		return r;
 
 	irq_routing->entries[irq_routing->nr++] =
 		(struct kvm_irq_routing_entry) {
@@ -41,11 +36,6 @@ int irq__init(struct kvm *kvm)
 {
 	int i, r;
 
-	irq_routing = calloc(sizeof(struct kvm_irq_routing) +
-			IRQ_MAX_GSI * sizeof(struct kvm_irq_routing_entry), 1);
-	if (irq_routing == NULL)
-		return -ENOMEM;
-
 	/* Hook first 8 GSIs to master IRQCHIP */
 	for (i = 0; i < 8; i++)
 		if (i != 2)
@@ -69,33 +59,8 @@ int irq__init(struct kvm *kvm)
 		return errno;
 	}
 
-	return 0;
-}
-dev_base_init(irq__init);
+	next_gsi = i;
 
-int irq__exit(struct kvm *kvm)
-{
-	free(irq_routing);
 	return 0;
 }
-dev_base_exit(irq__exit);
-
-int irq__add_msix_route(struct kvm *kvm, struct msi_msg *msg)
-{
-	int r;
-
-	irq_routing->entries[irq_routing->nr++] =
-		(struct kvm_irq_routing_entry) {
-			.gsi = gsi,
-			.type = KVM_IRQ_ROUTING_MSI,
-			.u.msi.address_hi = msg->address_hi,
-			.u.msi.address_lo = msg->address_lo,
-			.u.msi.data = msg->data,
-		};
-
-	r = ioctl(kvm->vm_fd, KVM_SET_GSI_ROUTING, irq_routing);
-	if (r)
-		return r;
-
-	return gsi++;
-}
+dev_base_init(irq__init);
-- 
2.9.0
