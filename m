Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8D5C4332D
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 16:20:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1223420724
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 16:20:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cCEntqkT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1223420724
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C06A14B0A3;
	Fri, 20 Mar 2020 12:20:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fzqlSHu6-x9q; Fri, 20 Mar 2020 12:20:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 531134B083;
	Fri, 20 Mar 2020 12:20:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F41094B095
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 12:20:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wQ9HLidI2H-x for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 12:20:03 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [216.205.24.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 586C34ACC9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 12:20:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584721202;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2QcW6ZnRzJ2aFmZq2RzXvJ/KIAbDk13HbSmFep2+6wQ=;
 b=cCEntqkTcu+yMksGSX8AXlVBHpm1+7YMoSWAz8T2EPjLdA5soSpEbgsVLW8c0ck2W2mhBb
 X+3HbRSPdWavZGtXB65a++CbDj2wacvULD9IF5uc9DlBJYaxv8lqG2y77jbG2xdllJz8xf
 WuOn16RlZF2H94NH0U0AaldfR4QONp8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-pqPYFjuuPXy6maVl701BMQ-1; Fri, 20 Mar 2020 12:20:00 -0400
X-MC-Unique: pqPYFjuuPXy6maVl701BMQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DFAE108442D;
 Fri, 20 Mar 2020 16:19:55 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 6494660BF1;
 Fri, 20 Mar 2020 16:19:51 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com,
 robin.murphy@arm.com
Subject: [PATCH v10 04/11] vfio/pci: Add VFIO_REGION_TYPE_NESTED region type
Date: Fri, 20 Mar 2020 17:19:04 +0100
Message-Id: <20200320161911.27494-5-eric.auger@redhat.com>
In-Reply-To: <20200320161911.27494-1-eric.auger@redhat.com>
References: <20200320161911.27494-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: marc.zyngier@arm.com
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

Add a new specific DMA_FAULT region aiming to exposed nested mode
translation faults.

The region has a ring buffer that contains the actual fault
records plus a header allowing to handle it (tail/head indices,
max capacity, entry size). At the moment the region is dimensionned
for 512 fault records.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v8 -> v9:
- Use a single region instead of a prod/cons region

v4 -> v5
- check cons is not null in vfio_pci_check_cons_fault

v3 -> v4:
- use 2 separate regions, respectively in read and write modes
- add the version capability
---
 drivers/vfio/pci/vfio_pci.c         | 68 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h | 10 +++++
 drivers/vfio/pci/vfio_pci_rdwr.c    | 45 +++++++++++++++++++
 include/uapi/linux/vfio.h           | 35 +++++++++++++++
 4 files changed, 158 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 379a02c36e37..586b89debed5 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -260,6 +260,69 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
 	return ret;
 }
 
+static void vfio_pci_dma_fault_release(struct vfio_pci_device *vdev,
+				       struct vfio_pci_region *region)
+{
+}
+
+static int vfio_pci_dma_fault_add_capability(struct vfio_pci_device *vdev,
+					     struct vfio_pci_region *region,
+					     struct vfio_info_cap *caps)
+{
+	struct vfio_region_info_cap_fault cap = {
+		.header.id = VFIO_REGION_INFO_CAP_DMA_FAULT,
+		.header.version = 1,
+		.version = 1,
+	};
+	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
+}
+
+static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
+	.rw		= vfio_pci_dma_fault_rw,
+	.release	= vfio_pci_dma_fault_release,
+	.add_capability = vfio_pci_dma_fault_add_capability,
+};
+
+#define DMA_FAULT_RING_LENGTH 512
+
+static int vfio_pci_init_dma_fault_region(struct vfio_pci_device *vdev)
+{
+	struct vfio_region_dma_fault *header;
+	size_t size;
+	int ret;
+
+	mutex_init(&vdev->fault_queue_lock);
+
+	/*
+	 * We provision 1 page for the header and space for
+	 * DMA_FAULT_RING_LENGTH fault records in the ring buffer.
+	 */
+	size = ALIGN(sizeof(struct iommu_fault) *
+		     DMA_FAULT_RING_LENGTH, PAGE_SIZE) + PAGE_SIZE;
+
+	vdev->fault_pages = kzalloc(size, GFP_KERNEL);
+	if (!vdev->fault_pages)
+		return -ENOMEM;
+
+	ret = vfio_pci_register_dev_region(vdev,
+		VFIO_REGION_TYPE_NESTED,
+		VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT,
+		&vfio_pci_dma_fault_regops, size,
+		VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE,
+		vdev->fault_pages);
+	if (ret)
+		goto out;
+
+	header = (struct vfio_region_dma_fault *)vdev->fault_pages;
+	header->entry_size = sizeof(struct iommu_fault);
+	header->nb_entries = DMA_FAULT_RING_LENGTH;
+	header->offset = sizeof(struct vfio_region_dma_fault);
+	return 0;
+out:
+	kfree(vdev->fault_pages);
+	return ret;
+}
+
 static int vfio_pci_enable(struct vfio_pci_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -358,6 +421,10 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 		}
 	}
 
+	ret = vfio_pci_init_dma_fault_region(vdev);
+	if (ret)
+		goto disable_exit;
+
 	vfio_pci_probe_mmaps(vdev);
 
 	return 0;
@@ -1383,6 +1450,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 
 	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
 	kfree(vdev->region);
+	kfree(vdev->fault_pages);
 	mutex_destroy(&vdev->ioeventfds_lock);
 
 	if (!disable_idle_d3)
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 8a2c7607d513..a392f50e3a99 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -119,6 +119,8 @@ struct vfio_pci_device {
 	int			ioeventfds_nr;
 	struct eventfd_ctx	*err_trigger;
 	struct eventfd_ctx	*req_trigger;
+	u8			*fault_pages;
+	struct mutex		fault_queue_lock;
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
@@ -150,6 +152,14 @@ extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 extern long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
 			       uint64_t data, int count, int fd);
 
+struct vfio_pci_fault_abi {
+	u32 entry_size;
+};
+
+extern size_t vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev,
+				    char __user *buf, size_t count,
+				    loff_t *ppos, bool iswrite);
+
 extern int vfio_pci_init_perm_bits(void);
 extern void vfio_pci_uninit_perm_bits(void);
 
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a87992892a9f..4004ab8cad0e 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -274,6 +274,51 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 	return done;
 }
 
+size_t vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev, char __user *buf,
+			     size_t count, loff_t *ppos, bool iswrite)
+{
+	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	void *base = vdev->region[i].data;
+	int ret = -EFAULT;
+
+	if (pos >= vdev->region[i].size)
+		return -EINVAL;
+
+	count = min(count, (size_t)(vdev->region[i].size - pos));
+
+	mutex_lock(&vdev->fault_queue_lock);
+
+	if (iswrite) {
+		struct vfio_region_dma_fault *header =
+			(struct vfio_region_dma_fault *)base;
+		u32 new_tail;
+
+		if (pos != 0 || count != 4) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+
+		if (copy_from_user((void *)&new_tail, buf, count))
+			goto unlock;
+
+		if (new_tail > header->nb_entries) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+		header->tail = new_tail;
+	} else {
+		if (copy_to_user(buf, base + pos, count))
+			goto unlock;
+	}
+	*ppos += count;
+	ret = count;
+unlock:
+	mutex_unlock(&vdev->fault_queue_lock);
+	return ret;
+}
+
+
 static int vfio_pci_ioeventfd_handler(void *opaque, void *unused)
 {
 	struct vfio_pci_ioeventfd *ioeventfd = opaque;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9f2429eb1958..40d770f80e3d 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -330,6 +330,9 @@ struct vfio_region_info_cap_type {
 /* sub-types for VFIO_REGION_TYPE_GFX */
 #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
 
+#define VFIO_REGION_TYPE_NESTED			(2)
+#define VFIO_REGION_SUBTYPE_NESTED_DMA_FAULT	(1)
+
 /**
  * struct vfio_region_gfx_edid - EDID region layout.
  *
@@ -708,6 +711,38 @@ struct vfio_device_ioeventfd {
 
 #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+
+/*
+ * Capability exposed by the DMA fault region
+ * @version: ABI version
+ */
+#define VFIO_REGION_INFO_CAP_DMA_FAULT	6
+
+struct vfio_region_info_cap_fault {
+	struct vfio_info_cap_header header;
+	__u32 version;
+};
+
+/*
+ * DMA Fault Region Layout
+ * @tail: index relative to the start of the ring buffer at which the
+ *        consumer finds the next item in the buffer
+ * @entry_size: fault ring buffer entry size in bytes
+ * @nb_entries: max capacity of the fault ring buffer
+ * @offset: ring buffer offset relative to the start of the region
+ * @head: index relative to the start of the ring buffer at which the
+ *        producer (kernel) inserts items into the buffers
+ */
+struct vfio_region_dma_fault {
+	/* Write-Only */
+	__u32   tail;
+	/* Read-Only */
+	__u32   entry_size;
+	__u32	nb_entries;
+	__u32	offset;
+	__u32   head;
+};
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
