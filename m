From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v6 kvmtool 10/13] vfio-pci: add MSI support
Date: Mon, 18 Jun 2018 19:42:08 +0100
Message-ID: <20180618184211.43904-11-jean-philippe.brucker@arm.com>
References: <20180618184211.43904-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 753034A0D6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:32:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ETymxlTfX4oM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jun 2018 14:31:51 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 794844A0E1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jun 2018 14:31:41 -0400 (EDT)
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

Allow guests to use the MSI capability in devices that support it. Emulate
the MSI capability, which is simpler than MSI-X as it doesn't rely on
external tables. Reuse most of the MSI-X code. Guests may choose between
MSI and MSI-X at runtime since we present both capabilities, but they
cannot enable MSI and MSI-X at the same time (forbidden by PCI).

Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/pci.h  |  23 ++++++
 include/kvm/vfio.h |   1 +
 vfio/pci.c         | 178 +++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 195 insertions(+), 7 deletions(-)

diff --git a/include/kvm/pci.h b/include/kvm/pci.h
index 274b77ea6..a86c15a70 100644
--- a/include/kvm/pci.h
+++ b/include/kvm/pci.h
@@ -59,6 +59,29 @@ struct msix_cap {
 	u32 pba_offset;
 };
 
+struct msi_cap_64 {
+	u8 cap;
+	u8 next;
+	u16 ctrl;
+	u32 address_lo;
+	u32 address_hi;
+	u16 data;
+	u16 _align;
+	u32 mask_bits;
+	u32 pend_bits;
+};
+
+struct msi_cap_32 {
+	u8 cap;
+	u8 next;
+	u16 ctrl;
+	u32 address_lo;
+	u16 data;
+	u16 _align;
+	u32 mask_bits;
+	u32 pend_bits;
+};
+
 struct pci_cap_hdr {
 	u8	type;
 	u8	next;
diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
index 483ba7e42..2c621ec75 100644
--- a/include/kvm/vfio.h
+++ b/include/kvm/vfio.h
@@ -75,6 +75,7 @@ struct vfio_pci_device {
 	unsigned long			irq_modes;
 	int				intx_fd;
 	unsigned int			intx_gsi;
+	struct vfio_pci_msi_common	msi;
 	struct vfio_pci_msi_common	msix;
 	struct vfio_pci_msix_table	msix_table;
 	struct vfio_pci_msix_pba	msix_pba;
diff --git a/vfio/pci.c b/vfio/pci.c
index b27de8548..3ed07fb43 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -29,13 +29,14 @@ struct vfio_irq_eventfd {
 
 static void vfio_pci_disable_intx(struct kvm *kvm, struct vfio_device *vdev);
 
-static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev)
+static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
+				bool msix)
 {
 	size_t i;
 	int ret = 0;
 	int *eventfds;
 	struct vfio_pci_device *pdev = &vdev->pci;
-	struct vfio_pci_msi_common *msis = &pdev->msix;
+	struct vfio_pci_msi_common *msis = msix ? &pdev->msix : &pdev->msi;
 	struct vfio_irq_eventfd single = {
 		.irq = {
 			.argsz	= sizeof(single),
@@ -135,11 +136,12 @@ static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev)
 	return ret;
 }
 
-static int vfio_pci_disable_msis(struct kvm *kvm, struct vfio_device *vdev)
+static int vfio_pci_disable_msis(struct kvm *kvm, struct vfio_device *vdev,
+				 bool msix)
 {
 	int ret;
 	struct vfio_pci_device *pdev = &vdev->pci;
-	struct vfio_pci_msi_common *msis = &pdev->msix;
+	struct vfio_pci_msi_common *msis = msix ? &pdev->msix : &pdev->msi;
 	struct vfio_irq_set irq_set = {
 		.argsz	= sizeof(irq_set),
 		.flags 	= VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_TRIGGER,
@@ -287,7 +289,7 @@ static void vfio_pci_msix_table_access(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 		vfio_dev_err(vdev, "failed to configure MSIX vector %zu", vector);
 
 	/* Update the physical capability if necessary */
-	if (vfio_pci_enable_msis(kvm, vdev))
+	if (vfio_pci_enable_msis(kvm, vdev, true))
 		vfio_dev_err(vdev, "cannot enable MSIX");
 
 out_unlock:
@@ -318,14 +320,120 @@ static void vfio_pci_msix_cap_write(struct kvm *kvm,
 	enable = flags & PCI_MSIX_FLAGS_ENABLE;
 	msi_set_enabled(pdev->msix.virt_state, enable);
 
-	if (enable && vfio_pci_enable_msis(kvm, vdev))
+	if (enable && vfio_pci_enable_msis(kvm, vdev, true))
 		vfio_dev_err(vdev, "cannot enable MSIX");
-	else if (!enable && vfio_pci_disable_msis(kvm, vdev))
+	else if (!enable && vfio_pci_disable_msis(kvm, vdev, true))
 		vfio_dev_err(vdev, "cannot disable MSIX");
 
 	mutex_unlock(&pdev->msix.mutex);
 }
 
+static int vfio_pci_msi_vector_write(struct kvm *kvm, struct vfio_device *vdev,
+				     u8 off, u8 *data, u32 sz)
+{
+	size_t i;
+	u32 mask = 0;
+	size_t mask_pos, start, limit;
+	struct vfio_pci_msi_entry *entry;
+	struct vfio_pci_device *pdev = &vdev->pci;
+	struct msi_cap_64 *msi_cap_64 = PCI_CAP(&pdev->hdr, pdev->msi.pos);
+
+	if (!(msi_cap_64->ctrl & PCI_MSI_FLAGS_MASKBIT))
+		return 0;
+
+	if (msi_cap_64->ctrl & PCI_MSI_FLAGS_64BIT)
+		mask_pos = PCI_MSI_MASK_64;
+	else
+		mask_pos = PCI_MSI_MASK_32;
+
+	if (off >= mask_pos + 4 || off + sz <= mask_pos)
+		return 0;
+
+	/* Set mask to current state */
+	for (i = 0; i < pdev->msi.nr_entries; i++) {
+		entry = &pdev->msi.entries[i];
+		mask |= !!msi_is_masked(entry->virt_state) << i;
+	}
+
+	/* Update mask following the intersection of access and register */
+	start = max_t(size_t, off, mask_pos);
+	limit = min_t(size_t, off + sz, mask_pos + 4);
+
+	memcpy((void *)&mask + start - mask_pos, data + start - off,
+	       limit - start);
+
+	/* Update states if necessary */
+	for (i = 0; i < pdev->msi.nr_entries; i++) {
+		bool masked = mask & (1 << i);
+
+		entry = &pdev->msi.entries[i];
+		if (masked != msi_is_masked(entry->virt_state)) {
+			msi_set_masked(entry->virt_state, masked);
+			vfio_pci_update_msi_entry(kvm, vdev, entry);
+		}
+	}
+
+	return 1;
+}
+
+static void vfio_pci_msi_cap_write(struct kvm *kvm, struct vfio_device *vdev,
+				   u8 off, u8 *data, u32 sz)
+{
+	u8 ctrl;
+	struct msi_msg msg;
+	size_t i, nr_vectors;
+	struct vfio_pci_msi_entry *entry;
+	struct vfio_pci_device *pdev = &vdev->pci;
+	struct msi_cap_64 *msi_cap_64 = PCI_CAP(&pdev->hdr, pdev->msi.pos);
+
+	off -= pdev->msi.pos;
+
+	mutex_lock(&pdev->msi.mutex);
+
+	/* Check if the guest is trying to update mask bits */
+	if (vfio_pci_msi_vector_write(kvm, vdev, off, data, sz))
+		goto out_unlock;
+
+	/* Only modify routes when guest pokes the enable bit */
+	if (off > PCI_MSI_FLAGS || off + sz <= PCI_MSI_FLAGS)
+		goto out_unlock;
+
+	ctrl = *(u8 *)(data + PCI_MSI_FLAGS - off);
+
+	msi_set_enabled(pdev->msi.virt_state, ctrl & PCI_MSI_FLAGS_ENABLE);
+
+	if (!msi_is_enabled(pdev->msi.virt_state)) {
+		vfio_pci_disable_msis(kvm, vdev, false);
+		goto out_unlock;
+	}
+
+	/* Create routes for the requested vectors */
+	nr_vectors = 1 << ((ctrl & PCI_MSI_FLAGS_QSIZE) >> 4);
+
+	msg.address_lo = msi_cap_64->address_lo;
+	if (msi_cap_64->ctrl & PCI_MSI_FLAGS_64BIT) {
+		msg.address_hi = msi_cap_64->address_hi;
+		msg.data = msi_cap_64->data;
+	} else {
+		struct msi_cap_32 *msi_cap_32 = (void *)msi_cap_64;
+		msg.address_hi = 0;
+		msg.data = msi_cap_32->data;
+	}
+
+	for (i = 0; i < nr_vectors; i++) {
+		entry = &pdev->msi.entries[i];
+		entry->config.msg = msg;
+		vfio_pci_update_msi_entry(kvm, vdev, entry);
+	}
+
+	/* Update the physical capability if necessary */
+	if (vfio_pci_enable_msis(kvm, vdev, false))
+		vfio_dev_err(vdev, "cannot enable MSI");
+
+out_unlock:
+	mutex_unlock(&pdev->msi.mutex);
+}
+
 static void vfio_pci_cfg_read(struct kvm *kvm, struct pci_device_header *pci_hdr,
 			      u8 offset, void *data, int sz)
 {
@@ -364,16 +472,33 @@ static void vfio_pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hd
 	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSIX)
 		vfio_pci_msix_cap_write(kvm, vdev, offset, data, sz);
 
+	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSI)
+		vfio_pci_msi_cap_write(kvm, vdev, offset, data, sz);
+
 	if (pread(vdev->fd, base + offset, sz, info->offset + offset) != sz)
 		vfio_dev_warn(vdev, "Failed to read %d bytes from Configuration Space at 0x%x",
 			      sz, offset);
 }
 
+static ssize_t vfio_pci_msi_cap_size(struct msi_cap_64 *cap_hdr)
+{
+	size_t size = 10;
+
+	if (cap_hdr->ctrl & PCI_MSI_FLAGS_64BIT)
+		size += 4;
+	if (cap_hdr->ctrl & PCI_MSI_FLAGS_MASKBIT)
+		size += 10;
+
+	return size;
+}
+
 static ssize_t vfio_pci_cap_size(struct pci_cap_hdr *cap_hdr)
 {
 	switch (cap_hdr->type) {
 	case PCI_CAP_ID_MSIX:
 		return PCI_CAP_MSIX_SIZEOF;
+	case PCI_CAP_ID_MSI:
+		return vfio_pci_msi_cap_size((void *)cap_hdr);
 	default:
 		pr_err("unknown PCI capability 0x%x", cap_hdr->type);
 		return 0;
@@ -442,6 +567,14 @@ static int vfio_pci_parse_caps(struct vfio_device *vdev)
 			pdev->msix.pos = pos;
 			pdev->irq_modes |= VFIO_PCI_IRQ_MODE_MSIX;
 			break;
+		case PCI_CAP_ID_MSI:
+			ret = vfio_pci_add_cap(vdev, virt_hdr, cap, pos);
+			if (ret)
+				return ret;
+
+			pdev->msi.pos = pos;
+			pdev->irq_modes |= VFIO_PCI_IRQ_MODE_MSI;
+			break;
 		}
 	}
 
@@ -644,6 +777,19 @@ out_free:
 	return ret;
 }
 
+static int vfio_pci_create_msi_cap(struct kvm *kvm, struct vfio_pci_device *pdev)
+{
+	struct msi_cap_64 *cap = PCI_CAP(&pdev->hdr, pdev->msi.pos);
+
+	pdev->msi.nr_entries = 1 << ((cap->ctrl & PCI_MSI_FLAGS_QMASK) >> 1),
+	pdev->msi.entries = calloc(pdev->msi.nr_entries,
+				   sizeof(struct vfio_pci_msi_entry));
+	if (!pdev->msi.entries)
+		return -ENOMEM;
+
+	return 0;
+}
+
 static int vfio_pci_configure_bar(struct kvm *kvm, struct vfio_device *vdev,
 				  size_t nr)
 {
@@ -716,6 +862,12 @@ static int vfio_pci_configure_dev_regions(struct kvm *kvm,
 			return ret;
 	}
 
+	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSI) {
+		ret = vfio_pci_create_msi_cap(kvm, pdev);
+		if (ret)
+			return ret;
+	}
+
 	for (i = VFIO_PCI_BAR0_REGION_INDEX; i <= VFIO_PCI_BAR5_REGION_INDEX; ++i) {
 		/* Ignore top half of 64-bit BAR */
 		if (i % 2 && is_64bit)
@@ -971,6 +1123,16 @@ static int vfio_pci_configure_dev_irqs(struct kvm *kvm, struct vfio_device *vdev
 			return ret;
 	}
 
+	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_MSI) {
+		pdev->msi.info = (struct vfio_irq_info) {
+			.argsz = sizeof(pdev->msi.info),
+			.index = VFIO_PCI_MSI_IRQ_INDEX,
+		};
+		ret = vfio_pci_init_msis(kvm, vdev, &pdev->msi);
+		if (ret)
+			return ret;
+	}
+
 	if (pdev->irq_modes & VFIO_PCI_IRQ_MODE_INTX)
 		ret = vfio_pci_enable_intx(kvm, vdev);
 
@@ -1019,4 +1181,6 @@ void vfio_pci_teardown_device(struct kvm *kvm, struct vfio_device *vdev)
 
 	free(pdev->msix.irq_set);
 	free(pdev->msix.entries);
+	free(pdev->msi.irq_set);
+	free(pdev->msi.entries);
 }
-- 
2.17.0
