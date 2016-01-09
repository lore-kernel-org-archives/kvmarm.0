From: Alexander Gordeev <agordeev@redhat.com>
Subject: [kvm-unit-tests PATCH 06/11] arm/pci: PCI testdev existence test
Date: Sat,  9 Jan 2016 13:22:53 +0100
Message-ID: <a22ed67ab7d062005a11a1174f7e44d2a747b49f.1452341807.git.agordeev@redhat.com>
References: <cover.1452341807.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 377AF4993D
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 07:19:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1eWsRlKeY1-G for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Jan 2016 07:19:19 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7AA1E49969
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 07:19:19 -0500 (EST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
 (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
 by mx1.redhat.com (Postfix) with ESMTPS id 36EC4C0B73E5
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 12:23:10 +0000 (UTC)
In-Reply-To: <cover.1452341807.git.agordeev@redhat.com>
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
Cc: Alexander Gordeev <agordeev@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arm/pci-test.c               |  3 +++
 config/config-arm-common.mak |  1 +
 lib/pci-testdev.c            | 31 +++++++++++++++++++++++++++++++
 lib/pci.h                    |  1 +
 4 files changed, 36 insertions(+)
 create mode 100644 lib/pci-testdev.c

diff --git a/arm/pci-test.c b/arm/pci-test.c
index 1539d3e..695acf9 100644
--- a/arm/pci-test.c
+++ b/arm/pci-test.c
@@ -22,6 +22,9 @@ int main(void)
 	ret = pci_bus_scan(pci);
 	report("PCI bus scanning detected %d devices", true, ret);
 
+	ret = pci_testdev(pci);
+	report("PCI test device", ret);
+
 	pci_shutdown(pci);
 
 done:
diff --git a/config/config-arm-common.mak b/config/config-arm-common.mak
index 06ad346..f2e0ad1 100644
--- a/config/config-arm-common.mak
+++ b/config/config-arm-common.mak
@@ -31,6 +31,7 @@ include config/asm-offsets.mak
 cflatobjs += lib/alloc.o
 cflatobjs += lib/devicetree.o
 cflatobjs += lib/pci-host-generic.o
+cflatobjs += lib/pci-testdev.o
 cflatobjs += lib/virtio.o
 cflatobjs += lib/virtio-mmio.o
 cflatobjs += lib/chr-testdev.o
diff --git a/lib/pci-testdev.c b/lib/pci-testdev.c
new file mode 100644
index 0000000..a7e0995
--- /dev/null
+++ b/lib/pci-testdev.c
@@ -0,0 +1,31 @@
+/*
+ * QEMU "pci-testdev" PCI test device
+ *
+ * Copyright (C) 2015, Red Hat Inc, Alexander Gordeev <agordeev@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include "pci.h"
+#include "asm/io.h"
+
+#define PCI_VENDOR_ID_REDHAT		0x1b36
+#define PCI_DEVICE_ID_REDHAT_TEST	0x0005
+
+bool pci_testdev(struct pci *pci)
+{
+	phys_addr_t addr;
+	pcidevaddr_t dev = pci_find_dev(pci,
+					PCI_VENDOR_ID_REDHAT,
+					PCI_DEVICE_ID_REDHAT_TEST);
+
+	if (dev == PCIDEVADDR_INVALID)
+		return false;
+
+	addr = pci_bar_addr(pci, dev, 0);
+	assert(addr);
+
+	addr = pci_bar_addr(pci, dev, 1);
+	assert(addr);
+
+	return true;
+}
diff --git a/lib/pci.h b/lib/pci.h
index 7d9baad..6af5599 100644
--- a/lib/pci.h
+++ b/lib/pci.h
@@ -24,6 +24,7 @@ typedef enum {
 
 extern struct pci *pci_dt_probe(void);
 extern int pci_bus_scan(struct pci *pci);
+extern bool pci_testdev(struct pci *pci);
 extern void pci_shutdown(struct pci *pci);
 
 extern pcidevaddr_t pci_find_dev(struct pci *pci, u16 vendor_id, u16 device_id);
-- 
1.8.3.1
