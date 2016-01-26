From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 09/10] vfio-pci: create an iommu mapping for msi address
Date: Tue, 26 Jan 2016 13:12:47 +0000
Message-ID: <1453813968-2024-10-git-send-email-eric.auger@linaro.org>
References: <1453813968-2024-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA24140B58
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 08:08:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0PhZFuOaY3q3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2016 08:08:51 -0500 (EST)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BAC0410D7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 08:08:51 -0500 (EST)
Received: by mail-wm0-f54.google.com with SMTP id n5so129563513wmn.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 05:13:46 -0800 (PST)
In-Reply-To: <1453813968-2024-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, will.deacon@arm.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

Some platforms require the MSI address programmed in the PCI
device to be an IOVA and not a host physical address.
This is typically the case for ARM and PowerPC, as opposed
to x86. This patch allocates an IOVA page and maps it onto
the physical page which contains the target MSI write transaction
address. In case an IOMMU binding already exists between those 2,
simply reprogram the device.

The binding is destroyed by the VFIO IOMMU backend.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
---
 drivers/vfio/pci/vfio_pci_intrs.c | 73 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 3b3ba15..bac24c9 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -305,6 +305,57 @@ static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
 	return 0;
 }
 
+/**
+ * vfio_set_mapped_msi_addr: overwrites the msi physical address with an iova
+ *
+ * @pdev: vfio pci device handle
+ * @irq: irq linux number
+ * returns 0 upon success, < 0 on failure
+ */
+static int vfio_set_mapped_msi_addr(struct vfio_pci_device *vdev, int irq)
+{
+	phys_addr_t msi_addr;
+	dma_addr_t msi_iova;
+	struct vfio_group *group = vdev->vfio_group;
+	struct msi_msg msg;
+	int ret;
+
+	get_cached_msi_msg(irq, &msg);
+	msi_addr = (phys_addr_t)(msg.address_hi) << 32 |
+			(phys_addr_t)(msg.address_lo);
+
+	ret = vfio_group_alloc_map_reserved_iova(group, msi_addr,
+						 IOMMU_WRITE, &msi_iova);
+	if (ret)
+		goto out;
+
+	/* Re-program the msi-address with the iova */
+	msg.address_hi = (u32)(msi_iova >> 32);
+	msg.address_lo = (u32)(msi_iova & 0xffffffff);
+	pci_write_msi_msg(irq, &msg);
+
+out:
+	return ret;
+}
+
+/**
+ * vfio_unset_mapped_msi_addr: decrement the ref counter of the msi iova page
+ * associated to the linux irq (in case it is null unmaps and frees resources)
+ *
+ * @pdev: vfio pci device handle
+ * @irq: irq linux number
+ */
+static void vfio_unset_mapped_msi_addr(struct vfio_pci_device *vdev, int irq)
+{
+	dma_addr_t msi_iova;
+	struct vfio_group *group = vdev->vfio_group;
+	struct msi_msg msg;
+
+	get_cached_msi_msg(irq, &msg);
+	msi_iova = (u64)(msg.address_hi) << 32 | (u64)(msg.address_lo);
+	vfio_group_unmap_free_reserved_iova(group, msi_iova);
+}
+
 static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 				      int vector, int fd, bool msix)
 {
@@ -318,6 +369,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 		return -EINVAL;
 
 	if (vdev->ctx[vector].trigger) {
+		vfio_unset_mapped_msi_addr(vdev, irq);
 		free_irq(irq, vdev->ctx[vector].trigger);
 		irq_bypass_unregister_producer(&vdev->ctx[vector].producer);
 		kfree(vdev->ctx[vector].name);
@@ -355,11 +407,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 
 	ret = request_irq(irq, vfio_msihandler, 0,
 			  vdev->ctx[vector].name, trigger);
-	if (ret) {
-		kfree(vdev->ctx[vector].name);
-		eventfd_ctx_put(trigger);
-		return ret;
-	}
+	if (ret)
+		goto error_free;
 
 	vdev->ctx[vector].producer.token = trigger;
 	vdev->ctx[vector].producer.irq = irq;
@@ -369,9 +418,23 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 		"irq bypass producer (token %p) registration fails: %d\n",
 		vdev->ctx[vector].producer.token, ret);
 
+	if (vfio_group_require_msi_mapping(vdev->vfio_group)) {
+		ret = vfio_set_mapped_msi_addr(vdev, irq);
+		if (ret)
+			goto error_free_irq;
+	}
+
 	vdev->ctx[vector].trigger = trigger;
 
 	return 0;
+
+error_free_irq:
+	free_irq(irq, vdev->ctx[vector].trigger);
+error_free:
+	kfree(vdev->ctx[vector].name);
+	eventfd_ctx_put(trigger);
+	return ret;
+
 }
 
 static int vfio_msi_set_block(struct vfio_pci_device *vdev, unsigned start,
-- 
1.9.1
