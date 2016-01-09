From: Alexander Gordeev <agordeev@redhat.com>
Subject: [kvm-unit-tests PATCH 07/11] arm/pci: PCI device operation test
Date: Sat,  9 Jan 2016 13:22:54 +0100
Message-ID: <597fba0ba6cdc84495acd7dd2119d9c785a76548.1452341807.git.agordeev@redhat.com>
References: <cover.1452341807.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A59D34993D
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 07:19:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KLEMa9oDStxp for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Jan 2016 07:19:20 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B83B7497F8
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 07:19:20 -0500 (EST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
 (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
 by mx1.redhat.com (Postfix) with ESMTPS id 7495A558D3
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 12:23:11 +0000 (UTC)
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
 arm/pci-test.c    |   2 +-
 lib/pci-testdev.c | 139 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 lib/pci.h         |   2 +-
 3 files changed, 138 insertions(+), 5 deletions(-)

diff --git a/arm/pci-test.c b/arm/pci-test.c
index 695acf9..44e2857 100644
--- a/arm/pci-test.c
+++ b/arm/pci-test.c
@@ -23,7 +23,7 @@ int main(void)
 	report("PCI bus scanning detected %d devices", true, ret);
 
 	ret = pci_testdev(pci);
-	report("PCI test device", ret);
+	report("PCI test device passed %d tests", (ret >= 6), ret);
 
 	pci_shutdown(pci);
 
diff --git a/lib/pci-testdev.c b/lib/pci-testdev.c
index a7e0995..de97f82 100644
--- a/lib/pci-testdev.c
+++ b/lib/pci-testdev.c
@@ -11,21 +11,154 @@
 #define PCI_VENDOR_ID_REDHAT		0x1b36
 #define PCI_DEVICE_ID_REDHAT_TEST	0x0005
 
-bool pci_testdev(struct pci *pci)
+struct pci_test_dev_hdr {
+	u8 test;
+	u8 width;
+	u8 pad0[2];
+	u32 offset;
+	u32 data;
+	u32 count;
+	u8 name[];
+};
+
+struct pci_testdev_ops {
+	u8 (*read8)(const volatile void *addr);
+	u16 (*read16)(const volatile void *addr);
+	u32 (*read32)(const volatile void *addr);
+	void (*write8)(u8 value, volatile void *addr);
+	void (*write16)(u16 value, volatile void *addr);
+	void (*write32)(u32 value, volatile void *addr);
+};
+
+static u8 ioread8(const volatile void *addr)
+{
+	return readb(addr);
+}
+
+static u16 ioread16(const volatile void *addr)
+{
+	return readw(addr);
+}
+
+static u32 ioread32(const volatile void *addr)
+{
+	return readl(addr);
+}
+
+static void iowrite8(u8 value, volatile void *addr)
+{
+	writeb(value, addr);
+}
+
+static void iowrite16(u16 value, volatile void *addr)
+{
+	writew(value, addr);
+}
+
+static void iowrite32(u32 value, volatile void *addr)
+{
+	writel(value, addr);
+}
+
+static struct pci_testdev_ops pci_testdev_io_ops = {
+	.read8		= ioread8,
+	.read16		= ioread16,
+	.read32		= ioread32,
+	.write8		= iowrite8,
+	.write16	= iowrite16,
+	.write32	= iowrite32
+};
+
+static u8 memread8(const volatile void *addr)
+{
+	return *(const volatile u8 __force *)addr;
+}
+
+static u16 memread16(const volatile void *addr)
+{
+	return *(const volatile u16 __force *)addr;
+}
+
+static u32 memread32(const volatile void *addr)
+{
+	return *(const volatile u32 __force *)addr;
+}
+
+static void memwrite8(u8 value, volatile void *addr)
+{
+	*(volatile u8 __force *)addr = value;
+}
+
+static void memwrite16(u16 value, volatile void *addr)
+{
+	*(volatile u16 __force *)addr = value;
+}
+
+static void memwrite32(u32 value, volatile void *addr)
+{
+	*(volatile u32 __force *)addr = value;
+}
+
+static struct pci_testdev_ops pci_testdev_mem_ops = {
+	.read8		= memread8,
+	.read16		= memread16,
+	.read32		= memread32,
+	.write8		= memwrite8,
+	.write16	= memwrite16,
+	.write32	= memwrite32
+};
+
+static bool pci_testdev_one(struct pci_test_dev_hdr *test,
+			    int test_nr,
+			    struct pci_testdev_ops *ops)
+{
+	u8 width;
+
+	ops->write8(test_nr, &test->test);
+	assert(ops->read32(&test->count) == 0);
+
+	width = ops->read8(&test->width);
+	if ((width != 1) && (width != 2) && (width != 4))
+		return false;
+
+	return true;
+}
+
+static int pci_testdev_all(struct pci_test_dev_hdr *test,
+			   struct pci_testdev_ops *ops)
+{
+	int i;
+
+	for (i = 0;; i++) {
+		if (!pci_testdev_one(test, i, ops))
+			break;
+	}
+
+	return i;
+}
+
+int pci_testdev(struct pci *pci)
 {
 	phys_addr_t addr;
+	void __iomem *mem, *io;
+	int nr_tests = 0;
 	pcidevaddr_t dev = pci_find_dev(pci,
 					PCI_VENDOR_ID_REDHAT,
 					PCI_DEVICE_ID_REDHAT_TEST);
 
 	if (dev == PCIDEVADDR_INVALID)
-		return false;
+		return 0;
 
 	addr = pci_bar_addr(pci, dev, 0);
 	assert(addr);
+	mem = ioremap(addr, 0);
 
 	addr = pci_bar_addr(pci, dev, 1);
 	assert(addr);
+	io = (void*)addr;
 
-	return true;
+	nr_tests += pci_testdev_all(mem, &pci_testdev_mem_ops);
+	nr_tests += pci_testdev_all(io, &pci_testdev_io_ops);
+
+	return nr_tests;
 }
diff --git a/lib/pci.h b/lib/pci.h
index 6af5599..0cb0e27 100644
--- a/lib/pci.h
+++ b/lib/pci.h
@@ -24,7 +24,7 @@ typedef enum {
 
 extern struct pci *pci_dt_probe(void);
 extern int pci_bus_scan(struct pci *pci);
-extern bool pci_testdev(struct pci *pci);
+extern int pci_testdev(struct pci *pci);
 extern void pci_shutdown(struct pci *pci);
 
 extern pcidevaddr_t pci_find_dev(struct pci *pci, u16 vendor_id, u16 device_id);
-- 
1.8.3.1
