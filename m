From: Alexander Gordeev <agordeev@redhat.com>
Subject: [kvm-unit-tests PATCH 03/11] arm/pci: Read devices BARs
Date: Sat,  9 Jan 2016 13:22:50 +0100
Message-ID: <95c40a7a8b9e006a3180b2a25cb6f5d605b20e3c.1452341807.git.agordeev@redhat.com>
References: <cover.1452341807.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD89F497F8
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 07:19:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N3QhQLTNMTMz for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Jan 2016 07:19:16 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE6AC49954
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 07:19:15 -0500 (EST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
 (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
 by mx1.redhat.com (Postfix) with ESMTPS id 968C8C0B73E5
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 12:23:06 +0000 (UTC)
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
 lib/pci-host-generic.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/pci-host-generic.h | 10 ++++++
 2 files changed, 100 insertions(+)

diff --git a/lib/pci-host-generic.c b/lib/pci-host-generic.c
index e479989..b783d29 100644
--- a/lib/pci-host-generic.c
+++ b/lib/pci-host-generic.c
@@ -176,9 +176,91 @@ static struct pci_host_bridge *pci_host_bridge_probe(void)
 	return host;
 }
 
+static void pci_get_bar_addr_size(void *conf, int bar, u32 *addr, u32 *size)
+{
+	int off = PCI_BASE_ADDRESS_0 + (bar * 4);
+
+	*addr = pci_config_readl(conf, off);
+	pci_config_writel(~0, conf, off);
+	*size = pci_config_readl(conf, off);
+	pci_config_writel(*addr, conf, off);
+}
+
+static bool pci_get_bar(void *conf, int bar, pci_res_type_t *type,
+			u64 *addr, u64 *size, bool *is64)
+{
+	u32 addr_low, size_low;
+	u64 mask;
+
+	/*
+	 * To determine the amount of address space needed by a PCI device,
+	 * one must save the original value of the BAR, write a value of
+	 * all 1's to the register, then read it back. The amount of memory
+	 * can then be then determined by masking the information bits,
+	 * performing a bitwise NOT and incrementing the value by 1.
+	 * Use pci_get_bar_addr_size() helper to facilitate that algorithm.
+	 */
+	pci_get_bar_addr_size(conf, bar, &addr_low, &size_low);
+
+	if (addr_low & PCI_BASE_ADDRESS_SPACE_IO) {
+		mask = PCI_BASE_ADDRESS_IO_MASK;
+		*type = PCI_RES_TYPE_IO;
+		*is64 = false;
+	} else {
+		mask = PCI_BASE_ADDRESS_MEM_MASK;
+		if ((addr_low & PCI_BASE_ADDRESS_MEM_TYPE_MASK) ==
+				PCI_BASE_ADDRESS_MEM_TYPE_64) {
+			if (addr_low & PCI_BASE_ADDRESS_MEM_PREFETCH)
+				*type = PCI_RES_TYPE_PREFMEM64;
+			else
+				*type = PCI_RES_TYPE_MEM64;
+			*is64 = true;
+		} else {
+			if (addr_low & PCI_BASE_ADDRESS_MEM_PREFETCH)
+				*type = PCI_RES_TYPE_PREFMEM32;
+			else
+				*type = PCI_RES_TYPE_MEM32;
+			*is64 = false;
+		}
+	}
+
+	if (*is64) {
+		u32 addr_high, size_high;
+		u64 size64;
+
+		assert(bar < 5);
+		pci_get_bar_addr_size(conf, bar + 1, &addr_high, &size_high);
+
+		size64 = (~((((u64)size_high << 32) | size_low) & mask)) + 1;
+		if (!size64)
+			return false;
+
+		if (size)
+			*size = size64;
+		if (addr)
+			*addr = (((u64)addr_high << 32) | addr_low) & mask;
+	} else {
+		u32 size32;
+
+		size32 = (~(size_low & (u32)mask)) + 1;
+		if (!size32)
+			return false;
+
+		if (size)
+			*size = size32;
+		if (addr)
+			*addr = addr_low & mask;
+	}
+
+	return true;
+}
+
 int pci_bus_scan(struct pci *pci)
 {
 	void *conf;
+	pci_res_type_t type;
+	bool is64;
+	int bar;
 	int dev;
 	int nr_dev = 0;
 
@@ -187,6 +269,14 @@ int pci_bus_scan(struct pci *pci)
 		if (pci_config_readb(conf, PCI_HEADER_TYPE) !=
 					   PCI_HEADER_TYPE_NORMAL)
 			continue;
+
+		for (bar = 0; bar < PCI_HEADER_TYPE_NORMAL_NUM_BARS; bar++) {
+			if (!pci_get_bar(conf, bar, &type, NULL, NULL, &is64))
+				break;
+			if (is64)
+				bar++;
+		}
+
 		pci_config_writel(PCI_COMMAND_SERR, conf, PCI_COMMAND);
 		nr_dev++;
 	}
diff --git a/lib/pci-host-generic.h b/lib/pci-host-generic.h
index c14d32d..132dc5f 100644
--- a/lib/pci-host-generic.h
+++ b/lib/pci-host-generic.h
@@ -21,7 +21,17 @@ struct pci_host_bridge {
 	struct pci_addr_space		addr_space[];
 };
 
+typedef enum pci_res_type {
+	PCI_RES_TYPE_CONF		= 0,
+	PCI_RES_TYPE_IO			= 1,
+	PCI_RES_TYPE_MEM32		= 2,
+	PCI_RES_TYPE_MEM64		= 3,
+	PCI_RES_TYPE_PREFMEM32		= 6,
+	PCI_RES_TYPE_PREFMEM64		= 7
+} pci_res_type_t;
+
 #define PCI_ECAM_BUS_SIZE		(1 << 20)
 #define PCI_ECAM_CONFIG_SIZE		(1 << 12)
+#define PCI_HEADER_TYPE_NORMAL_NUM_BARS	6	/* # of BARs in PCI function */
 
 #endif
-- 
1.8.3.1
