From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v6 05/16] VFIO: external user API for interaction with vfio
 devices
Date: Mon, 13 Apr 2015 14:29:20 +0200
Message-ID: <1428928171-18884-6-git-send-email-eric.auger@linaro.org>
References: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F12B4C3DE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:24:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d6wMafrVPZh6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 08:24:54 -0400 (EDT)
Received: from mail-wg0-f52.google.com (mail-wg0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C019D4C3D6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:24:53 -0400 (EDT)
Received: by wgin8 with SMTP id n8so78905889wgi.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 05:32:40 -0700 (PDT)
In-Reply-To: <1428928171-18884-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com
Cc: feng.wu@intel.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

The VFIO external user API is enriched with 3 new functions that
allows a kernel user external to VFIO to retrieve some information
from a VFIO device.

- vfio_device_get_external_user enables to get a vfio device from
  its fd and increments its reference counter
- vfio_device_put_external_user decrements the reference counter
- vfio_external_base_device returns a handle to the struct device

---

v3 -> v4:
- change the commit title

v2 -> v3:
- reword the commit message

v1 -> v2:

- vfio_external_get_base_device renamed into vfio_external_base_device
- vfio_external_get_type removed

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/vfio/vfio.c  | 24 ++++++++++++++++++++++++
 include/linux/vfio.h |  3 +++
 2 files changed, 27 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 23ba12a..33ae8c5 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1490,6 +1490,30 @@ void vfio_group_put_external_user(struct vfio_group *group)
 }
 EXPORT_SYMBOL_GPL(vfio_group_put_external_user);
 
+struct vfio_device *vfio_device_get_external_user(struct file *filep)
+{
+	struct vfio_device *vdev = filep->private_data;
+
+	if (filep->f_op != &vfio_device_fops)
+		return ERR_PTR(-EINVAL);
+
+	vfio_device_get(vdev);
+	return vdev;
+}
+EXPORT_SYMBOL_GPL(vfio_device_get_external_user);
+
+void vfio_device_put_external_user(struct vfio_device *vdev)
+{
+	vfio_device_put(vdev);
+}
+EXPORT_SYMBOL_GPL(vfio_device_put_external_user);
+
+struct device *vfio_external_base_device(struct vfio_device *vdev)
+{
+	return vdev->dev;
+}
+EXPORT_SYMBOL_GPL(vfio_external_base_device);
+
 int vfio_external_user_iommu_id(struct vfio_group *group)
 {
 	return iommu_group_id(group->iommu_group);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 683b514..b18c38f 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -101,6 +101,9 @@ extern void vfio_group_put_external_user(struct vfio_group *group);
 extern int vfio_external_user_iommu_id(struct vfio_group *group);
 extern long vfio_external_check_extension(struct vfio_group *group,
 					  unsigned long arg);
+extern struct vfio_device *vfio_device_get_external_user(struct file *filep);
+extern void vfio_device_put_external_user(struct vfio_device *vdev);
+extern struct device *vfio_external_base_device(struct vfio_device *vdev);
 
 struct pci_dev;
 #ifdef CONFIG_EEH
-- 
1.9.1
