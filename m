From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 06/17] VFIO: add vfio_external_{mask|is_active|set_automasked}
Date: Thu,  2 Jul 2015 15:17:16 +0200
Message-ID: <1435843047-6327-7-git-send-email-eric.auger@linaro.org>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E67E576ED
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:06:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WieTZ5d4kuDS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 09:06:51 -0400 (EDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
 [209.85.212.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 18172576E8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 09:06:50 -0400 (EDT)
Received: by wiar9 with SMTP id r9so100910870wia.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Jul 2015 06:18:07 -0700 (PDT)
In-Reply-To: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, pbonzini@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Introduces 3 new external functions aimed at doing actions
on VFIO devices:
- mask VFIO IRQ
- get the active status of VFIO IRQ (active at interrupt
  controller level or masked by the level-sensitive automasking).
- change the automasked property and switch the IRQ handler
  (between automasked/ non automasked)

Their implementation is based on bus specific callbacks.

Note there is no way to discriminate between user-space
masking and automasked handler masking. As a consequence, is_active
will return true in case the IRQ was masked by the user-space.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v5 -> v6:
- implementation now uses external ops
- prototype changed (index, start, count) and returns int

V4: creation
---
 drivers/vfio/vfio.c  | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h | 16 ++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 2fb29df..af6901e 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1527,6 +1527,45 @@ long vfio_external_check_extension(struct vfio_group *group, unsigned long arg)
 }
 EXPORT_SYMBOL_GPL(vfio_external_check_extension);
 
+int vfio_external_mask(struct vfio_device *vdev, unsigned index,
+			unsigned start, unsigned count)
+{
+	if (vdev->ops->external_ops &&
+		vdev->ops->external_ops->mask)
+		return vdev->ops->external_ops->mask(vdev->device_data,
+						     index, start, count);
+	else
+		return -ENXIO;
+}
+EXPORT_SYMBOL_GPL(vfio_external_mask);
+
+int vfio_external_is_active(struct vfio_device *vdev, unsigned index,
+			     unsigned start, unsigned count)
+{
+	if (vdev->ops->external_ops &&
+		vdev->ops->external_ops->is_active)
+		return vdev->ops->external_ops->is_active(vdev->device_data,
+							  index, start, count);
+	else
+		return -ENXIO;
+}
+EXPORT_SYMBOL_GPL(vfio_external_is_active);
+
+int vfio_external_set_automasked(struct vfio_device *vdev,
+				  unsigned index, unsigned start,
+				  unsigned count, bool automasked)
+{
+	if (vdev->ops->external_ops &&
+		vdev->ops->external_ops->set_automasked)
+		return vdev->ops->external_ops->set_automasked(
+							vdev->device_data,
+							index, start,
+							count, automasked);
+	else
+		return -ENXIO;
+}
+EXPORT_SYMBOL_GPL(vfio_external_set_automasked);
+
 /**
  * Module/class support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index d79e8a9..31d3c95 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -107,6 +107,22 @@ extern int vfio_external_user_iommu_id(struct vfio_group *group);
 extern long vfio_external_check_extension(struct vfio_group *group,
 					  unsigned long arg);
 
+extern int vfio_external_mask(struct vfio_device *vdev, unsigned index,
+			       unsigned start, unsigned count);
+/*
+ * returns whether the VFIO IRQ is active:
+ * true if not yet deactivated at interrupt controller level or if
+ * automasked (level sensitive IRQ). Unfortunately there is no way to
+ * discriminate between handler auto-masking and user-space masking
+ */
+extern int vfio_external_is_active(struct vfio_device *vdev,
+				    unsigned index, unsigned start,
+				    unsigned count);
+
+extern int vfio_external_set_automasked(struct vfio_device *vdev,
+					 unsigned index, unsigned start,
+					 unsigned count, bool automasked);
+
 struct pci_dev;
 #ifdef CONFIG_EEH
 extern void vfio_spapr_pci_eeh_open(struct pci_dev *pdev);
-- 
1.9.1
