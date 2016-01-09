From: Alexander Gordeev <agordeev@redhat.com>
Subject: [kvm-unit-tests PATCH 10/11] arm/pci: PCI devices basic info printing
Date: Sat,  9 Jan 2016 13:22:57 +0100
Message-ID: <9122dc5a32fc248e2cde597f02fa8efb9cb21591.1452341807.git.agordeev@redhat.com>
References: <cover.1452341807.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E70D49954
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 07:19:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sLWuoDj4fqqK for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Jan 2016 07:19:24 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 90D0B49997
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 07:19:24 -0500 (EST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
 (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
 by mx1.redhat.com (Postfix) with ESMTPS id 4D49D3B715
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jan 2016 12:23:15 +0000 (UTC)
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
 lib/pci-host-generic.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/lib/pci-host-generic.c b/lib/pci-host-generic.c
index 2d218a4..50cf09a 100644
--- a/lib/pci-host-generic.c
+++ b/lib/pci-host-generic.c
@@ -352,6 +352,35 @@ static phys_addr_t pci_alloc_res(struct pci_host_bridge *host,
 	return addr;
 }
 
+static void pci_dev_print(void *conf)
+{
+	u16 vendor_id = pci_config_readw(conf, PCI_VENDOR_ID);
+	u16 device_id = pci_config_readw(conf, PCI_DEVICE_ID);
+	u8 header = pci_config_readb(conf, PCI_HEADER_TYPE);
+	u8 progif = pci_config_readb(conf, PCI_CLASS_PROG);
+	u8 subcl = pci_config_readb(conf, PCI_CLASS_DEVICE);
+	u8 class = pci_config_readb(conf, PCI_CLASS_DEVICE + 1);
+
+	printf("conf %p vendor_id %04x device_id %04x type %d "
+	       "progif %02x class %02x subcl %02x\n",
+	       conf, vendor_id, device_id, header,
+	       progif, class, subcl);
+}
+
+static void pci_dev_bar_print(int bar, pci_res_type_t type,
+			      phys_addr_t addr, u64 size, bool is64)
+{
+	const char *desc = addr_space_desc[type];
+
+	if (is64) {
+		printf("\tBAR#%d,%d [%-7s %02x-%02x]\n",
+			bar, bar + 1, desc, addr, addr + size - 1);
+	} else {
+		printf("\tBAR#%d    [%-7s %02x-%02x]\n",
+			bar, desc, addr, addr + size - 1);
+	}
+}
+
 int pci_bus_scan(struct pci *pci)
 {
 	void *conf;
@@ -365,6 +394,8 @@ int pci_bus_scan(struct pci *pci)
 	int nr_dev = 0;
 
 	for_each_pci_dev(pci, dev, conf) {
+		pci_dev_print(conf);
+
 		/* We are only interested in normal PCI devices */
 		if (pci_config_readb(conf, PCI_HEADER_TYPE) !=
 					   PCI_HEADER_TYPE_NORMAL)
@@ -375,6 +406,9 @@ int pci_bus_scan(struct pci *pci)
 				break;
 			addr = pci_alloc_res(pci->sysdata, type, size);
 			pci_set_bar(conf, bar, addr, is64);
+
+			pci_dev_bar_print(bar, type, addr, size, is64);
+
 			if (is64)
 				bar++;
 
-- 
1.8.3.1
