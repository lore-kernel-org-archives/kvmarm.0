From: Alexander Gordeev <agordeev@redhat.com>
Subject: [kvm-unit-tests PATCH 04/11] arm/pci: Allocate and assign memory/io
 space resources
Date: Sat,  9 Jan 2016 13:22:51 +0100
Message-ID: <3fdf8892b958b323a8cbf38c079b08855d372038.1452341807.git.agordeev@redhat.com>
References: <cover.1452341807.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1F7C497F8
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 07:19:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8+f7TRbZUnIt for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Jan 2016 07:19:17 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FB7549997
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 07:19:17 -0500 (EST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
 (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
 by mx1.redhat.com (Postfix) with ESMTPS id D0F1214CAB3
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 12:23:07 +0000 (UTC)
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
 lib/pci-host-generic.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 2 deletions(-)

diff --git a/lib/pci-host-generic.c b/lib/pci-host-generic.c
index b783d29..f3161f8 100644
--- a/lib/pci-host-generic.c
+++ b/lib/pci-host-generic.c
@@ -19,6 +19,11 @@
 	     dev >= 0;					\
 	     dev = find_next_dev(pci, dev, &conf))
 
+static pci_res_type_t flags_to_type(u32 of_flags)
+{
+	return ((of_flags & 0x40000000) >> 28) | ((of_flags >> 24) & 0x03);
+}
+
 static u8 pci_config_readb(const void *conf, int off)
 {
 	return readb(conf + off);
@@ -255,11 +260,66 @@ static bool pci_get_bar(void *conf, int bar, pci_res_type_t *type,
 	return true;
 }
 
+static void pci_set_bar(void *conf, int bar, phys_addr_t addr, bool is64)
+{
+	int off = PCI_BASE_ADDRESS_0 + (bar * 4);
+
+	pci_config_writel(addr, conf, off);
+	if (is64)
+		pci_config_writel(addr >> 32, conf, off + 4);
+}
+
+static struct pci_addr_space *pci_find_res(struct pci_host_bridge *host,
+					   pci_res_type_t type)
+{
+	struct pci_addr_space *as = &host->addr_space[0];
+	int i;
+
+	for (i = 0; i < host->nr_addr_spaces; i++, as++) {
+		if (flags_to_type(as->of_flags) == type)
+			return as;
+	}
+
+	return NULL;
+}
+
+static phys_addr_t pci_align_res_size(phys_addr_t size, pci_res_type_t type)
+{
+	phys_addr_t mask;
+
+	if (type == PCI_RES_TYPE_IO)
+		mask = PCI_BASE_ADDRESS_IO_MASK;
+	else
+		mask = PCI_BASE_ADDRESS_MEM_MASK;
+
+	return (size + ~mask) & mask;
+}
+
+static phys_addr_t pci_alloc_res(struct pci_host_bridge *host,
+				 pci_res_type_t type, u64 size)
+{
+	struct pci_addr_space *res;
+	phys_addr_t addr;
+
+	assert(res = pci_find_res(host, type));
+
+	size = pci_align_res_size(size, type);
+	assert(res->alloc + size <= res->pci_range.size);
+
+	addr = res->pci_range.start + res->alloc;
+	res->alloc += size;
+
+	return addr;
+}
+
 int pci_bus_scan(struct pci *pci)
 {
 	void *conf;
+	phys_addr_t addr;
+	u64 size;
 	pci_res_type_t type;
 	bool is64;
+	u32 cmd = PCI_COMMAND_SERR;
 	int bar;
 	int dev;
 	int nr_dev = 0;
@@ -271,13 +331,20 @@ int pci_bus_scan(struct pci *pci)
 			continue;
 
 		for (bar = 0; bar < PCI_HEADER_TYPE_NORMAL_NUM_BARS; bar++) {
-			if (!pci_get_bar(conf, bar, &type, NULL, NULL, &is64))
+			if (!pci_get_bar(conf, bar, &type, NULL, &size, &is64))
 				break;
+			addr = pci_alloc_res(pci->sysdata, type, size);
+			pci_set_bar(conf, bar, addr, is64);
 			if (is64)
 				bar++;
+
+			if (type == PCI_RES_TYPE_IO)
+				cmd |= PCI_COMMAND_IO;
+			else
+				cmd |= PCI_COMMAND_MEMORY;
 		}
 
-		pci_config_writel(PCI_COMMAND_SERR, conf, PCI_COMMAND);
+		pci_config_writel(cmd, conf, PCI_COMMAND);
 		nr_dev++;
 	}
 
-- 
1.8.3.1
