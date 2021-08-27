Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 702C1C432BE
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 11:54:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E2AA860FDA
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 11:54:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E2AA860FDA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 700CA4B102;
	Fri, 27 Aug 2021 07:54:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bk3EzWsh6lc8; Fri, 27 Aug 2021 07:54:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44AEF4B10B;
	Fri, 27 Aug 2021 07:54:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBBD14B0E2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 07:54:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4cZmfUg6ZESj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 07:54:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 781394B0BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 07:54:14 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 615CB60FDA;
 Fri, 27 Aug 2021 11:54:13 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mJaR1-007YG1-8P; Fri, 27 Aug 2021 12:54:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH][kvmtool] virtio/pci: Size the MSI-X bar according to the
 number of MSI-X
Date: Fri, 27 Aug 2021 12:54:05 +0100
Message-Id: <20210827115405.1981529-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 andre.przywara@arm.com, alexandru.elisei@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Since 45d3b59e8c45 ("kvm tools: Increase amount of possible interrupts
per PCI device"), the number of MSI-S has gone from 4 to 33.

However, the corresponding storage hasn't been upgraded, and writing
to the MSI-X table is a pretty risky business. Now that the Linux
kernel writes to *all* MSI-X entries before doing anything else
with the device, kvmtool dies a horrible death.

Fix it by properly defining the size of the MSI-X bar, and make
Linux great again.

This includes some fixes the PBA region decoding, as well as minor
cleanups to make this code a bit more maintainable.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virtio/pci.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/virtio/pci.c b/virtio/pci.c
index eb91f512..41085291 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -7,6 +7,7 @@
 #include "kvm/irq.h"
 #include "kvm/virtio.h"
 #include "kvm/ioeventfd.h"
+#include "kvm/util.h"
 
 #include <sys/ioctl.h>
 #include <linux/virtio_pci.h>
@@ -14,6 +15,13 @@
 #include <assert.h>
 #include <string.h>
 
+#define ALIGN_UP(x, s)		ALIGN((x) + (s) - 1, (s))
+#define VIRTIO_NR_MSIX		(VIRTIO_PCI_MAX_VQ + VIRTIO_PCI_MAX_CONFIG)
+#define VIRTIO_MSIX_TABLE_SIZE	(VIRTIO_NR_MSIX * 16)
+#define VIRTIO_MSIX_PBA_SIZE	(ALIGN_UP(VIRTIO_MSIX_TABLE_SIZE, 64) / 8)
+#define VIRTIO_MSIX_BAR_SIZE	(1UL << fls_long(VIRTIO_MSIX_TABLE_SIZE + \
+						 VIRTIO_MSIX_PBA_SIZE))
+
 static u16 virtio_pci__port_addr(struct virtio_pci *vpci)
 {
 	return pci__bar_address(&vpci->pci_hdr, 0);
@@ -333,18 +341,27 @@ static void virtio_pci__msix_mmio_callback(struct kvm_cpu *vcpu,
 	struct virtio_pci *vpci = vdev->virtio;
 	struct msix_table *table;
 	u32 msix_io_addr = virtio_pci__msix_io_addr(vpci);
+	u32 pba_offset;
 	int vecnum;
 	size_t offset;
 
-	if (addr > msix_io_addr + PCI_IO_SIZE) {
+	BUILD_BUG_ON(VIRTIO_NR_MSIX > (sizeof(vpci->msix_pba) * 8));
+
+	pba_offset = vpci->pci_hdr.msix.pba_offset & ~PCI_MSIX_TABLE_BIR;
+	if (addr >= msix_io_addr + pba_offset) {
+		/* Read access to PBA */
 		if (is_write)
 			return;
-		table  = (struct msix_table *)&vpci->msix_pba;
-		offset = addr - (msix_io_addr + PCI_IO_SIZE);
-	} else {
-		table  = vpci->msix_table;
-		offset = addr - msix_io_addr;
+		offset = addr - (msix_io_addr + pba_offset);
+		if ((offset + len) > sizeof (vpci->msix_pba))
+			return;
+		memcpy(data, (void *)&vpci->msix_pba + offset, len);
+		return;
 	}
+
+	table  = vpci->msix_table;
+	offset = addr - msix_io_addr;
+
 	vecnum = offset / sizeof(struct msix_table);
 	offset = offset % sizeof(struct msix_table);
 
@@ -520,7 +537,7 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 	port_addr = pci_get_io_port_block(PCI_IO_SIZE);
 	mmio_addr = pci_get_mmio_block(PCI_IO_SIZE);
-	msix_io_block = pci_get_mmio_block(PCI_IO_SIZE * 2);
+	msix_io_block = pci_get_mmio_block(VIRTIO_MSIX_BAR_SIZE);
 
 	vpci->pci_hdr = (struct pci_device_header) {
 		.vendor_id		= cpu_to_le16(PCI_VENDOR_ID_REDHAT_QUMRANET),
@@ -543,7 +560,7 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		.capabilities		= (void *)&vpci->pci_hdr.msix - (void *)&vpci->pci_hdr,
 		.bar_size[0]		= cpu_to_le32(PCI_IO_SIZE),
 		.bar_size[1]		= cpu_to_le32(PCI_IO_SIZE),
-		.bar_size[2]		= cpu_to_le32(PCI_IO_SIZE*2),
+		.bar_size[2]		= cpu_to_le32(VIRTIO_MSIX_BAR_SIZE),
 	};
 
 	r = pci__register_bar_regions(kvm, &vpci->pci_hdr,
@@ -560,8 +577,9 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	vpci->pci_hdr.msix.cap = PCI_CAP_ID_MSIX;
 	vpci->pci_hdr.msix.next = 0;
 	/*
-	 * We at most have VIRTIO_PCI_MAX_VQ entries for virt queue,
-	 * VIRTIO_PCI_MAX_CONFIG entries for config.
+	 * We at most have VIRTIO_NR_MSIX entries (VIRTIO_PCI_MAX_VQ
+	 * entries for virt queue, VIRTIO_PCI_MAX_CONFIG entries for
+	 * config).
 	 *
 	 * To quote the PCI spec:
 	 *
@@ -570,11 +588,11 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 	 * For example, a returned value of "00000000011"
 	 * indicates a table size of 4.
 	 */
-	vpci->pci_hdr.msix.ctrl = cpu_to_le16(VIRTIO_PCI_MAX_VQ + VIRTIO_PCI_MAX_CONFIG - 1);
+	vpci->pci_hdr.msix.ctrl = cpu_to_le16(VIRTIO_NR_MSIX - 1);
 
 	/* Both table and PBA are mapped to the same BAR (2) */
 	vpci->pci_hdr.msix.table_offset = cpu_to_le32(2);
-	vpci->pci_hdr.msix.pba_offset = cpu_to_le32(2 | PCI_IO_SIZE);
+	vpci->pci_hdr.msix.pba_offset = cpu_to_le32(2 | VIRTIO_MSIX_TABLE_SIZE);
 	vpci->config_vector = 0;
 
 	if (irq__can_signal_msi(kvm))
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
