From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v6 kvmtool 05/13] pci: add capability helpers
Date: Mon, 18 Jun 2018 19:42:03 +0100
Message-ID: <20180618184211.43904-6-jean-philippe.brucker@arm.com>
References: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A54F4A0EC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:32:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qgnniWOI64IN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jun 2018 14:31:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73A3B4A0DB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:32 -0400 (EDT)
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

Add a way to iterate over all capabilities in a config space. Add a search
function for getting a specific capability.

Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/pci.h | 14 ++++++++++++++
 pci.c             | 13 +++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/kvm/pci.h b/include/kvm/pci.h
index 5d9c0f3b0..01c244bcf 100644
--- a/include/kvm/pci.h
+++ b/include/kvm/pci.h
@@ -58,6 +58,11 @@ struct msix_cap {
 	u32 pba_offset;
 };
 
+struct pci_cap_hdr {
+	u8	type;
+	u8	next;
+};
+
 #define PCI_BAR_OFFSET(b)	(offsetof(struct pci_device_header, bar[b]))
 #define PCI_DEV_CFG_SIZE	256
 #define PCI_DEV_CFG_MASK	(PCI_DEV_CFG_SIZE - 1)
@@ -113,6 +118,13 @@ struct pci_device_header {
 	enum irq_type	irq_type;
 };
 
+#define PCI_CAP(pci_hdr, pos) ((void *)(pci_hdr) + (pos))
+
+#define pci_for_each_cap(pos, cap, hdr)				\
+	for ((pos) = (hdr)->capabilities & ~3;			\
+	     (cap) = PCI_CAP(hdr, pos), (pos) != 0;		\
+	     (pos) = ((struct pci_cap_hdr *)(cap))->next & ~3)
+
 int pci__init(struct kvm *kvm);
 int pci__exit(struct kvm *kvm);
 struct pci_device_header *pci__find_dev(u8 dev_num);
@@ -121,4 +133,6 @@ void pci__assign_irq(struct device_header *dev_hdr);
 void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size);
 void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data, int size);
 
+void *pci_find_cap(struct pci_device_header *hdr, u8 cap_type);
+
 #endif /* KVM__PCI_H */
diff --git a/pci.c b/pci.c
index 5a8c2ef41..689869cb7 100644
--- a/pci.c
+++ b/pci.c
@@ -27,6 +27,19 @@ u32 pci_get_io_space_block(u32 size)
 	return block;
 }
 
+void *pci_find_cap(struct pci_device_header *hdr, u8 cap_type)
+{
+	u8 pos;
+	struct pci_cap_hdr *cap;
+
+	pci_for_each_cap(pos, cap, hdr) {
+		if (cap->type == cap_type)
+			return cap;
+	}
+
+	return NULL;
+}
+
 void pci__assign_irq(struct device_header *dev_hdr)
 {
 	struct pci_device_header *pci_hdr = dev_hdr->data;
-- 
2.17.0
