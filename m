From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 13/15] vfio/type1: also check IRQ remapping capability at msi
 domain
Date: Thu, 11 Feb 2016 14:34:20 +0000
Message-ID: <1455201262-5259-14-git-send-email-eric.auger@linaro.org>
References: <1455201262-5259-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D46149AAF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 09:29:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vMefo2DxXzXw for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 09:29:51 -0500 (EST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D16149A0C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 09:29:50 -0500 (EST)
Received: by mail-wm0-f53.google.com with SMTP id g62so23930418wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 06:35:46 -0800 (PST)
In-Reply-To: <1455201262-5259-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Thomas.Lendacky@amd.com, brijesh.singh@amd.com, patches@linaro.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, leo.duran@amd.com, sherry.hurwitz@amd.com
List-Id: kvmarm@lists.cs.columbia.edu

On x86 IRQ remapping is abstracted by the IOMMU. On ARM this is abstracted
by the msi controller. vfio_msi_parent_irq_remapping_capable allows to
check whether interrupts are "safe" for a given device. There are if the device
does not use MSI or if the device uses MSI and the msi-parent controller
supports IRQ remapping.

Then we check at group level if all devices have safe interrupts: if not
only allow the group to be attached if allow_unsafe_interrupts is set.

At this point ARM sMMU still advertises IOMMU_CAP_INTR_REMAP. This is
changed in next patch.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/vfio/vfio_iommu_type1.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c5d3b48..080321b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -36,6 +36,8 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/workqueue.h>
+#include <linux/irqdomain.h>
+#include <linux/msi.h>
 
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
@@ -754,6 +756,31 @@ static int vfio_bus_type(struct device *dev, void *data)
 	return 0;
 }
 
+/**
+ * vfio_msi_parent_irq_remapping_capable: returns whether the device msi-parent
+ * controller supports IRQ remapping, aka interrupt translation
+ *
+ * @dev: device handle
+ * @data: unused
+ * returns 0 if irq remapping is supported or -1 if not supported.
+ */
+static int vfio_msi_parent_irq_remapping_capable(struct device *dev, void *data)
+{
+	struct irq_domain *domain;
+	struct msi_domain_info *info;
+
+	domain = dev_get_msi_domain(dev);
+	if (!domain)
+		return 0;
+
+	info = msi_get_domain_info(domain);
+
+	if (!(info->flags & MSI_FLAG_IRQ_REMAPPING))
+		return -1;
+
+	return 0;
+}
+
 static int vfio_iommu_replay(struct vfio_iommu *iommu,
 			     struct vfio_domain *domain)
 {
@@ -848,7 +875,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	struct vfio_group *group, *g;
 	struct vfio_domain *domain, *d;
 	struct bus_type *bus = NULL;
-	int ret;
+	int ret, irq_remapping;
 
 	mutex_lock(&iommu->lock);
 
@@ -871,6 +898,13 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 	group->iommu_group = iommu_group;
 
+	/*
+	 * Determine if all the devices of the group has an MSI-parent that
+	 * supports irq remapping
+	 */
+	irq_remapping = !iommu_group_for_each_dev(iommu_group, &bus,
+				       vfio_msi_parent_irq_remapping_capable);
+
 	/* Determine bus_type in order to allocate a domain */
 	ret = iommu_group_for_each_dev(iommu_group, &bus, vfio_bus_type);
 	if (ret)
@@ -899,7 +933,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	list_add(&group->next, &domain->group_list);
 
 	if (!allow_unsafe_interrupts &&
-	    !iommu_capable(bus, IOMMU_CAP_INTR_REMAP)) {
+	    (!iommu_capable(bus, IOMMU_CAP_INTR_REMAP) && !irq_remapping)) {
 		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
 		       __func__);
 		ret = -EPERM;
-- 
1.9.1
