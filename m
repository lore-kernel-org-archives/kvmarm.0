From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v6 3/5] vfio/type1: also check IRQ remapping capability at msi
 domain
Date: Mon,  4 Apr 2016 08:30:09 +0000
Message-ID: <1459758611-2972-4-git-send-email-eric.auger@linaro.org>
References: <1459758611-2972-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2377840B58
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:29:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LFZ58fMwlEIC for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 04:29:15 -0400 (EDT)
Received: from mail-lf0-f45.google.com (mail-lf0-f45.google.com
 [209.85.215.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A78E409A2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:29:14 -0400 (EDT)
Received: by mail-lf0-f45.google.com with SMTP id g184so83822965lfb.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2016 01:30:30 -0700 (PDT)
In-Reply-To: <1459758611-2972-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

On x86 IRQ remapping is abstracted by the IOMMU. On ARM this is abstracted
by the msi controller. vfio_safe_irq_domain allows to check whether
interrupts are "safe" for a given device. They are if the device does
not use MSI or if the device uses MSI and the msi-parent controller
supports IRQ remapping.

Then we check at group level if all devices have safe interrupts: if not,
we only allow the group to be attached if allow_unsafe_interrupts is set.

At this point ARM sMMU still advertises IOMMU_CAP_INTR_REMAP. This is
changed in next patch.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v3 -> v4:
- rename vfio_msi_parent_irq_remapping_capable into vfio_safe_irq_domain
  and irq_remapping into safe_irq_domains

v2 -> v3:
- protect vfio_msi_parent_irq_remapping_capable with
  CONFIG_GENERIC_MSI_IRQ_DOMAIN
---
 drivers/vfio/vfio_iommu_type1.c | 44 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 4497b20..b330b81 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -37,6 +37,8 @@
 #include <linux/vfio.h>
 #include <linux/workqueue.h>
 #include <linux/dma-reserved-iommu.h>
+#include <linux/irqdomain.h>
+#include <linux/msi.h>
 
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
@@ -788,6 +790,33 @@ static int vfio_bus_type(struct device *dev, void *data)
 	return 0;
 }
 
+/**
+ * vfio_safe_irq_domain: returns whether the irq domain
+ * the device is attached to is safe with respect to MSI isolation.
+ * If the irq domain is not an MSI domain, we return it is safe.
+ *
+ * @dev: device handle
+ * @data: unused
+ * returns 0 if the irq domain is safe, -1 if not.
+ */
+static int vfio_safe_irq_domain(struct device *dev, void *data)
+{
+#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
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
+#endif
+	return 0;
+}
+
 static int vfio_iommu_replay(struct vfio_iommu *iommu,
 			     struct vfio_domain *domain)
 {
@@ -882,7 +911,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	struct vfio_group *group, *g;
 	struct vfio_domain *domain, *d;
 	struct bus_type *bus = NULL;
-	int ret;
+	int ret, safe_irq_domains;
 
 	mutex_lock(&iommu->lock);
 
@@ -905,6 +934,13 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 	group->iommu_group = iommu_group;
 
+	/*
+	 * Determine if all the devices of the group have a safe irq domain
+	 * with respect to MSI isolation
+	 */
+	safe_irq_domains = !iommu_group_for_each_dev(iommu_group, &bus,
+				       vfio_safe_irq_domain);
+
 	/* Determine bus_type in order to allocate a domain */
 	ret = iommu_group_for_each_dev(iommu_group, &bus, vfio_bus_type);
 	if (ret)
@@ -932,8 +968,12 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	INIT_LIST_HEAD(&domain->group_list);
 	list_add(&group->next, &domain->group_list);
 
+	/*
+	 * to advertise safe interrupts either the IOMMU or the MSI controllers
+	 * must support IRQ remapping/interrupt translation
+	 */
 	if (!allow_unsafe_interrupts &&
-	    !iommu_capable(bus, IOMMU_CAP_INTR_REMAP)) {
+	    (!iommu_capable(bus, IOMMU_CAP_INTR_REMAP) && !safe_irq_domains)) {
 		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
 		       __func__);
 		ret = -EPERM;
-- 
1.9.1
