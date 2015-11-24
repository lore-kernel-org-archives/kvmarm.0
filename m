From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v2 1/3] vfio: Introduce map and unmap operations
Date: Tue, 24 Nov 2015 16:50:54 +0300
Message-ID: <1c098d851fe86c1307c4497d1c58c331c7d71942.1448372839.git.p.fedin@samsung.com>
References: <cover.1448372839.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15391496B1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 08:50:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nBWYpupBdlqT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2015 08:50:04 -0500 (EST)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 086F1419D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 08:50:04 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYB00D4MNT0ZB10@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 24 Nov 2015 13:51:01 +0000 (GMT)
In-reply-to: <cover.1448372839.git.p.fedin@samsung.com>
In-reply-to: <cover.1448372839.git.p.fedin@samsung.com>
References: <cover.1448372839.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Alex Williamson <alex.williamson@redhat.com>, Manish Jaggi <mjaggi@caviumnetworks.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

These new functions allow direct mapping and unmapping of addresses on the
given IOMMU. They will be used for mapping MSI hardware.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 drivers/vfio/vfio_iommu_type1.c | 29 +++++++++++++++++++++++++++++
 include/linux/vfio.h            |  4 +++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 59d47cb..17506eb 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -558,6 +558,33 @@ unwind:
 	return ret;
 }
 
+static int vfio_iommu_type1_map(void *iommu_data, dma_addr_t iova,
+			      phys_addr_t paddr, long npage, int prot)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	int ret;
+
+	mutex_lock(&iommu->lock);
+	ret = vfio_iommu_map(iommu, iova, paddr >> PAGE_SHIFT, npage, prot);
+	mutex_unlock(&iommu->lock);
+
+	return ret;
+}
+
+static void vfio_iommu_type1_unmap(void *iommu_data, dma_addr_t iova,
+				   long npage)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	struct vfio_domain *d;
+
+	mutex_lock(&iommu->lock);
+
+	list_for_each_entry_reverse(d, &iommu->domain_list, next)
+		iommu_unmap(d->domain, iova, npage << PAGE_SHIFT);
+
+	mutex_unlock(&iommu->lock);
+}
+
 static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   struct vfio_iommu_type1_dma_map *map)
 {
@@ -1046,6 +1073,8 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.ioctl		= vfio_iommu_type1_ioctl,
 	.attach_group	= vfio_iommu_type1_attach_group,
 	.detach_group	= vfio_iommu_type1_detach_group,
+	.map		= vfio_iommu_type1_map,
+	.unmap		= vfio_iommu_type1_unmap,
 };
 
 static int __init vfio_iommu_type1_init(void)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 610a86a..061038a 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -75,7 +75,9 @@ struct vfio_iommu_driver_ops {
 					struct iommu_group *group);
 	void		(*detach_group)(void *iommu_data,
 					struct iommu_group *group);
-
+	int		(*map)(void *iommu_data, dma_addr_t iova,
+			       phys_addr_t paddr, long npage, int prot);
+	void		(*unmap)(void *iommu_data, dma_addr_t iova, long npage);
 };
 
 extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
-- 
2.4.4
