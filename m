From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v6 kvmtool 01/13] pci: add config operations callbacks on the
 PCI header
Date: Mon, 18 Jun 2018 19:41:59 +0100
Message-ID: <20180618184211.43904-2-jean-philippe.brucker@arm.com>
References: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBB774A0E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1OVjaXtZHfk1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jun 2018 14:31:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 916C54048A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:25 -0400 (EDT)
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

When implementing PCI device passthrough, we will need to forward config
accesses from a guest to the VFIO driver. Add a private cfg_ops structure
to the PCI header, and use it in the PCI config access functions.

A read from the guest first calls into the device's cfg_ops.read, to let
the backend update the local header before filling the guest register.
Same happens for a write, we let the backend perform the write and replace
the guest-provided register with whatever sticks, before updating the local
header.

Try to untangle the PCI config access logic while we're at it.

Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[JPB: moved to a separate patch]
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/pci.h | 72 +++++++++++++++++++++++++-------------
 pci.c             | 89 ++++++++++++++++++++++-------------------------
 2 files changed, 89 insertions(+), 72 deletions(-)

diff --git a/include/kvm/pci.h b/include/kvm/pci.h
index b0c28a10a..56649d87d 100644
--- a/include/kvm/pci.h
+++ b/include/kvm/pci.h
@@ -57,33 +57,55 @@ struct msix_cap {
 	u32 pba_offset;
 };
 
+#define PCI_BAR_OFFSET(b)	(offsetof(struct pci_device_header, bar[b]))
+#define PCI_DEV_CFG_SIZE	256
+#define PCI_DEV_CFG_MASK	(PCI_DEV_CFG_SIZE - 1)
+
+struct pci_device_header;
+
+struct pci_config_operations {
+	void (*write)(struct kvm *kvm, struct pci_device_header *pci_hdr,
+		      u8 offset, void *data, int sz);
+	void (*read)(struct kvm *kvm, struct pci_device_header *pci_hdr,
+		     u8 offset, void *data, int sz);
+};
+
 struct pci_device_header {
-	u16		vendor_id;
-	u16		device_id;
-	u16		command;
-	u16		status;
-	u8		revision_id;
-	u8		class[3];
-	u8		cacheline_size;
-	u8		latency_timer;
-	u8		header_type;
-	u8		bist;
-	u32		bar[6];
-	u32		card_bus;
-	u16		subsys_vendor_id;
-	u16		subsys_id;
-	u32		exp_rom_bar;
-	u8		capabilities;
-	u8		reserved1[3];
-	u32		reserved2;
-	u8		irq_line;
-	u8		irq_pin;
-	u8		min_gnt;
-	u8		max_lat;
-	struct msix_cap msix;
-	u8		empty[136]; /* Rest of PCI config space */
+	/* Configuration space, as seen by the guest */
+	union {
+		struct {
+			u16		vendor_id;
+			u16		device_id;
+			u16		command;
+			u16		status;
+			u8		revision_id;
+			u8		class[3];
+			u8		cacheline_size;
+			u8		latency_timer;
+			u8		header_type;
+			u8		bist;
+			u32		bar[6];
+			u32		card_bus;
+			u16		subsys_vendor_id;
+			u16		subsys_id;
+			u32		exp_rom_bar;
+			u8		capabilities;
+			u8		reserved1[3];
+			u32		reserved2;
+			u8		irq_line;
+			u8		irq_pin;
+			u8		min_gnt;
+			u8		max_lat;
+			struct msix_cap msix;
+		} __attribute__((packed));
+		/* Pad to PCI config space size */
+		u8	__pad[PCI_DEV_CFG_SIZE];
+	};
+
+	/* Private to lkvm */
 	u32		bar_size[6];
-} __attribute__((packed));
+	struct pci_config_operations	cfg_ops;
+};
 
 int pci__init(struct kvm *kvm);
 int pci__exit(struct kvm *kvm);
diff --git a/pci.c b/pci.c
index 3a6696c54..e48e24b8c 100644
--- a/pci.c
+++ b/pci.c
@@ -8,8 +8,6 @@
 #include <linux/err.h>
 #include <assert.h>
 
-#define PCI_BAR_OFFSET(b)		(offsetof(struct pci_device_header, bar[b]))
-
 static u32 pci_config_address_bits;
 
 /* This is within our PCI gap - in an unused area.
@@ -131,59 +129,56 @@ static struct ioport_operations pci_config_data_ops = {
 
 void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size)
 {
-	u8 dev_num;
-
-	dev_num	= addr.device_number;
-
-	if (pci_device_exists(0, dev_num, 0)) {
-		unsigned long offset;
-
-		offset = addr.w & 0xff;
-		if (offset < sizeof(struct pci_device_header)) {
-			void *p = device__find_dev(DEVICE_BUS_PCI, dev_num)->data;
-			struct pci_device_header *hdr = p;
-			u8 bar = (offset - PCI_BAR_OFFSET(0)) / (sizeof(u32));
-			u32 sz = cpu_to_le32(PCI_IO_SIZE);
-
-			if (bar < 6 && hdr->bar_size[bar])
-				sz = hdr->bar_size[bar];
-
-			/*
-			 * If the kernel masks the BAR it would expect to find the
-			 * size of the BAR there next time it reads from it.
-			 * When the kernel got the size it would write the address
-			 * back.
-			 */
-			if (*(u32 *)(p + offset)) {
-				/* See if kernel tries to mask one of the BARs */
-				if ((offset >= PCI_BAR_OFFSET(0)) &&
-				    (offset <= PCI_BAR_OFFSET(6)) &&
-				    (ioport__read32(data)  == 0xFFFFFFFF))
-					memcpy(p + offset, &sz, sizeof(sz));
-				    else
-					memcpy(p + offset, data, size);
-			}
-		}
+	void *base;
+	u8 bar, offset;
+	struct pci_device_header *pci_hdr;
+	u8 dev_num = addr.device_number;
+
+	if (!pci_device_exists(addr.bus_number, dev_num, 0))
+		return;
+
+	offset = addr.w & PCI_DEV_CFG_MASK;
+	base = pci_hdr = device__find_dev(DEVICE_BUS_PCI, dev_num)->data;
+
+	if (pci_hdr->cfg_ops.write)
+		pci_hdr->cfg_ops.write(kvm, pci_hdr, offset, data, size);
+
+	/*
+	 * legacy hack: ignore writes to uninitialized regions (e.g. ROM BAR).
+	 * Not very nice but has been working so far.
+	 */
+	if (*(u32 *)(base + offset) == 0)
+		return;
+
+	bar = (offset - PCI_BAR_OFFSET(0)) / sizeof(u32);
+
+	/*
+	 * If the kernel masks the BAR it would expect to find the size of the
+	 * BAR there next time it reads from it. When the kernel got the size it
+	 * would write the address back.
+	 */
+	if (bar < 6 && ioport__read32(data) == 0xFFFFFFFF) {
+		u32 sz = pci_hdr->bar_size[bar];
+		memcpy(base + offset, &sz, sizeof(sz));
+	} else {
+		memcpy(base + offset, data, size);
 	}
 }
 
 void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data, int size)
 {
-	u8 dev_num;
-
-	dev_num	= addr.device_number;
+	u8 offset;
+	struct pci_device_header *pci_hdr;
+	u8 dev_num = addr.device_number;
 
-	if (pci_device_exists(0, dev_num, 0)) {
-		unsigned long offset;
+	if (pci_device_exists(addr.bus_number, dev_num, 0)) {
+		pci_hdr = device__find_dev(DEVICE_BUS_PCI, dev_num)->data;
+		offset = addr.w & PCI_DEV_CFG_MASK;
 
-		offset = addr.w & 0xff;
-		if (offset < sizeof(struct pci_device_header)) {
-			void *p = device__find_dev(DEVICE_BUS_PCI, dev_num)->data;
+		if (pci_hdr->cfg_ops.read)
+			pci_hdr->cfg_ops.read(kvm, pci_hdr, offset, data, size);
 
-			memcpy(data, p + offset, size);
-		} else {
-			memset(data, 0x00, size);
-		}
+		memcpy(data, (void *)pci_hdr + offset, size);
 	} else {
 		memset(data, 0xff, size);
 	}
-- 
2.17.0
