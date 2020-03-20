Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CA0C4332B
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 16:20:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ADD1A20724
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 16:20:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W7MDA72E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADD1A20724
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 670AC4B091;
	Fri, 20 Mar 2020 12:20:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Nl3OHvYlVR15; Fri, 20 Mar 2020 12:20:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F89D4B08E;
	Fri, 20 Mar 2020 12:20:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB45B4B093
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 12:20:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0veBLIhhgMo0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 12:20:52 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [216.205.24.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CD4A4B090
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 12:20:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584721252;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Gsn88KCOy4TFjSN8wEnmeeh/A4dC91vCp+i38ZmovTM=;
 b=W7MDA72Ewg9VHEoZHbQpMAaTHOaqWA4/iUg+5baohpF28iUs74Q/vpgBQym03L1o+kafHp
 YZTQvIDl0SWReLwc9H+Vge9rAuqWcULplk/Ps3aRoAe8/EsZy2DSDn/B7QbZ47u1G72XhC
 V2MqIkDYrI95B44NTkBwnnOkOw9TI/M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-TT3b5ESxPzi-BiGqNel9bA-1; Fri, 20 Mar 2020 12:20:50 -0400
X-MC-Unique: TT3b5ESxPzi-BiGqNel9bA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52D8918A6EC0;
 Fri, 20 Mar 2020 16:20:48 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-142.ams2.redhat.com [10.36.113.142])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 8F00860BFB;
 Fri, 20 Mar 2020 16:20:37 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com,
 robin.murphy@arm.com
Subject: [PATCH v10 09/11] vfio/pci: Add framework for custom interrupt indices
Date: Fri, 20 Mar 2020 17:19:09 +0100
Message-Id: <20200320161911.27494-10-eric.auger@redhat.com>
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

Implement IRQ capability chain infrastructure. All interrupt
indexes beyond VFIO_PCI_NUM_IRQS are handled as extended
interrupts. They are registered with a specific type/subtype
and supported flags.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c         | 100 +++++++++++++++++++++++-----
 drivers/vfio/pci/vfio_pci_intrs.c   |  62 +++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |  14 ++++
 3 files changed, 158 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 3c99f6f3825b..ca13067e4718 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -543,6 +543,14 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 				VFIO_IRQ_SET_ACTION_TRIGGER,
 				vdev->irq_type, 0, 0, NULL);
 
+	for (i = 0; i < vdev->num_ext_irqs; i++)
+		vfio_pci_set_irqs_ioctl(vdev, VFIO_IRQ_SET_DATA_NONE |
+					VFIO_IRQ_SET_ACTION_TRIGGER,
+					VFIO_PCI_NUM_IRQS + i, 0, 0, NULL);
+	vdev->num_ext_irqs = 0;
+	kfree(vdev->ext_irqs);
+	vdev->ext_irqs = NULL;
+
 	/* Device closed, don't need mutex here */
 	list_for_each_entry_safe(ioeventfd, ioeventfd_tmp,
 				 &vdev->ioeventfds_list, next) {
@@ -709,6 +717,9 @@ static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
 			return 1;
 	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX) {
 		return 1;
+	} else if (irq_type >= VFIO_PCI_NUM_IRQS &&
+		   irq_type < VFIO_PCI_NUM_IRQS + vdev->num_ext_irqs) {
+		return 1;
 	}
 
 	return 0;
@@ -878,7 +889,7 @@ static long vfio_pci_ioctl(void *device_data,
 			info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
 		info.num_regions = VFIO_PCI_NUM_REGIONS + vdev->num_regions;
-		info.num_irqs = VFIO_PCI_NUM_IRQS;
+		info.num_irqs = VFIO_PCI_NUM_IRQS + vdev->num_ext_irqs;
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
@@ -1033,36 +1044,88 @@ static long vfio_pci_ioctl(void *device_data,
 
 	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
 		struct vfio_irq_info info;
+		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+		unsigned long capsz;
 
 		minsz = offsetofend(struct vfio_irq_info, count);
 
+		/* For backward compatibility, cannot require this */
+		capsz = offsetofend(struct vfio_irq_info, cap_offset);
+
 		if (copy_from_user(&info, (void __user *)arg, minsz))
 			return -EFAULT;
 
-		if (info.argsz < minsz || info.index >= VFIO_PCI_NUM_IRQS)
+		if (info.argsz < minsz ||
+			info.index >= VFIO_PCI_NUM_IRQS + vdev->num_ext_irqs)
 			return -EINVAL;
 
-		switch (info.index) {
-		case VFIO_PCI_INTX_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
-		case VFIO_PCI_REQ_IRQ_INDEX:
-			break;
-		case VFIO_PCI_ERR_IRQ_INDEX:
-			if (pci_is_pcie(vdev->pdev))
-				break;
-		/* fall through */
-		default:
-			return -EINVAL;
-		}
+		if (info.argsz >= capsz)
+			minsz = capsz;
 
 		info.flags = VFIO_IRQ_INFO_EVENTFD;
 
-		info.count = vfio_pci_get_irq_count(vdev, info.index);
-
-		if (info.index == VFIO_PCI_INTX_IRQ_INDEX)
+		switch (info.index) {
+		case VFIO_PCI_INTX_IRQ_INDEX:
 			info.flags |= (VFIO_IRQ_INFO_MASKABLE |
 				       VFIO_IRQ_INFO_AUTOMASKED);
-		else
+			break;
+		case VFIO_PCI_MSI_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
+		case VFIO_PCI_REQ_IRQ_INDEX:
 			info.flags |= VFIO_IRQ_INFO_NORESIZE;
+			break;
+		case VFIO_PCI_ERR_IRQ_INDEX:
+			info.flags |= VFIO_IRQ_INFO_NORESIZE;
+			if (!pci_is_pcie(vdev->pdev))
+				return -EINVAL;
+			break;
+		/* fall through */
+		default:
+		{
+			struct vfio_irq_info_cap_type cap_type = {
+				.header.id = VFIO_IRQ_INFO_CAP_TYPE,
+				.header.version = 1 };
+			int ret, i;
+
+			if (info.index >= VFIO_PCI_NUM_IRQS +
+						vdev->num_ext_irqs)
+				return -EINVAL;
+			info.index = array_index_nospec(info.index,
+							VFIO_PCI_NUM_IRQS +
+							vdev->num_ext_irqs);
+			i = info.index - VFIO_PCI_NUM_IRQS;
+
+			info.flags = vdev->ext_irqs[i].flags;
+			cap_type.type = vdev->ext_irqs[i].type;
+			cap_type.subtype = vdev->ext_irqs[i].subtype;
+
+			ret = vfio_info_add_capability(&caps,
+					&cap_type.header,
+					sizeof(cap_type));
+			if (ret)
+				return ret;
+		}
+		}
+
+		info.count = vfio_pci_get_irq_count(vdev, info.index);
+
+		if (caps.size) {
+			info.flags |= VFIO_IRQ_INFO_FLAG_CAPS;
+			if (info.argsz < sizeof(info) + caps.size) {
+				info.argsz = sizeof(info) + caps.size;
+				info.cap_offset = 0;
+			} else {
+				vfio_info_cap_shift(&caps, sizeof(info));
+				if (copy_to_user((void __user *)arg +
+						  sizeof(info), caps.buf,
+						  caps.size)) {
+					kfree(caps.buf);
+					return -EFAULT;
+				}
+				info.cap_offset = sizeof(info);
+			}
+
+			kfree(caps.buf);
+		}
 
 		return copy_to_user((void __user *)arg, &info, minsz) ?
 			-EFAULT : 0;
@@ -1081,7 +1144,8 @@ static long vfio_pci_ioctl(void *device_data,
 		max = vfio_pci_get_irq_count(vdev, hdr.index);
 
 		ret = vfio_set_irqs_validate_and_prepare(&hdr, max,
-						 VFIO_PCI_NUM_IRQS, &data_size);
+				VFIO_PCI_NUM_IRQS + vdev->num_ext_irqs,
+				&data_size);
 		if (ret)
 			return ret;
 
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 2056f3f85f59..f15e2cd7ae64 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -19,6 +19,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
+#include <linux/nospec.h>
 
 #include "vfio_pci_private.h"
 
@@ -619,6 +620,24 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_device *vdev,
 					       count, flags, data);
 }
 
+static int vfio_pci_set_ext_irq_trigger(struct vfio_pci_device *vdev,
+					unsigned int index, unsigned int start,
+					unsigned int count, uint32_t flags,
+					void *data)
+{
+	int i;
+
+	if (start != 0 || count > 1)
+		return -EINVAL;
+
+	index = array_index_nospec(index,
+				   VFIO_PCI_NUM_IRQS + vdev->num_ext_irqs);
+	i = index - VFIO_PCI_NUM_IRQS;
+
+	return vfio_pci_set_ctx_trigger_single(&vdev->ext_irqs[i].trigger,
+					       count, flags, data);
+}
+
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
 			    unsigned index, unsigned start, unsigned count,
 			    void *data)
@@ -668,6 +687,13 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
 			break;
 		}
 		break;
+	default:
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			func = vfio_pci_set_ext_irq_trigger;
+			break;
+		}
+		break;
 	}
 
 	if (!func)
@@ -675,3 +701,39 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
 
 	return func(vdev, index, start, count, flags, data);
 }
+
+int vfio_pci_get_ext_irq_index(struct vfio_pci_device *vdev,
+			       unsigned int type, unsigned int subtype)
+{
+	int i;
+
+	for (i = 0; i <  vdev->num_ext_irqs; i++) {
+		if (vdev->ext_irqs[i].type == type &&
+		    vdev->ext_irqs[i].subtype == subtype) {
+			return i;
+		}
+	}
+	return -EINVAL;
+}
+
+int vfio_pci_register_irq(struct vfio_pci_device *vdev,
+			  unsigned int type, unsigned int subtype,
+			  u32 flags)
+{
+	struct vfio_ext_irq *ext_irqs;
+
+	ext_irqs = krealloc(vdev->ext_irqs,
+			    (vdev->num_ext_irqs + 1) * sizeof(*ext_irqs),
+			    GFP_KERNEL);
+	if (!ext_irqs)
+		return -ENOMEM;
+
+	vdev->ext_irqs = ext_irqs;
+
+	vdev->ext_irqs[vdev->num_ext_irqs].type = type;
+	vdev->ext_irqs[vdev->num_ext_irqs].subtype = subtype;
+	vdev->ext_irqs[vdev->num_ext_irqs].flags = flags;
+	vdev->ext_irqs[vdev->num_ext_irqs].trigger = NULL;
+	vdev->num_ext_irqs++;
+	return 0;
+}
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index a392f50e3a99..e296a45c136e 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -73,6 +73,13 @@ struct vfio_pci_region {
 	u32				flags;
 };
 
+struct vfio_ext_irq {
+	u32				type;
+	u32				subtype;
+	u32				flags;
+	struct eventfd_ctx		*trigger;
+};
+
 struct vfio_pci_dummy_resource {
 	struct resource		resource;
 	int			index;
@@ -96,6 +103,8 @@ struct vfio_pci_device {
 	struct vfio_pci_irq_ctx	*ctx;
 	int			num_ctx;
 	int			irq_type;
+	struct vfio_ext_irq	*ext_irqs;
+	int			num_ext_irqs;
 	int			num_regions;
 	struct vfio_pci_region	*region;
 	u8			msi_qmax;
@@ -134,6 +143,11 @@ struct vfio_pci_device {
 
 extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
 extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
+extern int vfio_pci_register_irq(struct vfio_pci_device *vdev,
+				 unsigned int type, unsigned int subtype,
+				 u32 flags);
+extern int vfio_pci_get_ext_irq_index(struct vfio_pci_device *vdev,
+				      unsigned int type, unsigned int subtype);
 
 extern int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev,
 				   uint32_t flags, unsigned index,
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
