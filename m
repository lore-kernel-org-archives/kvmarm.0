From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 06/10] vfio: introduce
 vfio_group_alloc_map_/unmap_free_reserved_iova
Date: Tue, 26 Jan 2016 13:12:44 +0000
Message-ID: <1453813968-2024-7-git-send-email-eric.auger@linaro.org>
References: <1453813968-2024-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E94D740FA2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 08:08:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nsnk2H3c28gi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2016 08:08:43 -0500 (EST)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 758B2410D7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 08:08:42 -0500 (EST)
Received: by mail-wm0-f52.google.com with SMTP id u188so105682267wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 05:13:37 -0800 (PST)
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

This patch introduces vfio_group_alloc_map_/unmap_free_reserved_iova
and implements corresponding vfio_iommu_type1 operations.

alloc_map allows to allocate a new reserved iova page and map it
onto the physical page that contains a given PA. It returns the iova
that is mapped onto the provided PA. In case a mapping already exist
between both pages, the IOVA corresponding to the PA is directly returned.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Ankit Jindal <ajindal@apm.com>
Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
---
 drivers/vfio/vfio.c             |  39 ++++++++++
 drivers/vfio/vfio_iommu_type1.c | 163 ++++++++++++++++++++++++++++++++++++++--
 include/linux/vfio.h            |  34 ++++++++-
 3 files changed, 228 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 82f25cc..3d9de00 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -268,6 +268,45 @@ void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops)
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_iommu_driver);
 
+int vfio_group_alloc_map_reserved_iova(struct vfio_group *group,
+				       phys_addr_t addr, int prot,
+				       dma_addr_t *iova)
+{
+	struct vfio_container *container = group->container;
+	const struct vfio_iommu_driver_ops *ops = container->iommu_driver->ops;
+	int ret;
+
+	if (!ops->alloc_map_reserved_iova)
+		return -EINVAL;
+
+	down_read(&container->group_lock);
+	ret = ops->alloc_map_reserved_iova(container->iommu_data,
+					   group->iommu_group,
+					   addr, prot, iova);
+	up_read(&container->group_lock);
+	return ret;
+
+}
+EXPORT_SYMBOL_GPL(vfio_group_alloc_map_reserved_iova);
+
+int vfio_group_unmap_free_reserved_iova(struct vfio_group *group,
+					dma_addr_t iova)
+{
+	struct vfio_container *container = group->container;
+	const struct vfio_iommu_driver_ops *ops = container->iommu_driver->ops;
+	int ret;
+
+	if (!ops->unmap_free_reserved_iova)
+		return -EINVAL;
+
+	down_read(&container->group_lock);
+	ret = ops->unmap_free_reserved_iova(container->iommu_data,
+					    group->iommu_group, iova);
+	up_read(&container->group_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_group_unmap_free_reserved_iova);
+
 /**
  * Group minor allocation/free - both called with vfio.group_lock held
  */
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 33304c0..a79e2a8 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -156,6 +156,19 @@ static void vfio_unlink_reserved_binding(struct vfio_domain *d,
 	rb_erase(&old->node, &d->reserved_binding_list);
 }
 
+static void vfio_reserved_binding_release(struct kref *kref)
+{
+	struct vfio_reserved_binding *b =
+		container_of(kref, struct vfio_reserved_binding, kref);
+	struct vfio_domain *d = b->domain;
+	unsigned long order = __ffs(b->size);
+
+	iommu_unmap(d->domain, b->iova, b->size);
+	free_iova(d->reserved_iova_domain, b->iova >> order);
+	vfio_unlink_reserved_binding(d, b);
+	kfree(b);
+}
+
 /*
  * This code handles mapping and unmapping of user data buffers
  * into DMA'ble space using the IOMMU
@@ -1034,6 +1047,138 @@ done:
 	mutex_unlock(&iommu->lock);
 }
 
+static struct vfio_domain *vfio_find_iommu_domain(void *iommu_data,
+						   struct iommu_group *group)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	struct vfio_group *g;
+	struct vfio_domain *d;
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		list_for_each_entry(g, &d->group_list, next) {
+			if (g->iommu_group == group)
+				return d;
+		}
+	}
+	return NULL;
+}
+
+static int vfio_iommu_type1_alloc_map_reserved_iova(void *iommu_data,
+						    struct iommu_group *group,
+						    phys_addr_t addr, int prot,
+						    dma_addr_t *iova)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	struct vfio_domain *d;
+	uint64_t mask, iommu_page_size;
+	struct vfio_reserved_binding *b;
+	unsigned long order;
+	struct iova *p_iova;
+	phys_addr_t aligned_addr, offset;
+	int ret = 0;
+
+	order = __ffs(vfio_pgsize_bitmap(iommu));
+	iommu_page_size = (uint64_t)1 << order;
+	mask = iommu_page_size - 1;
+	aligned_addr = addr & ~mask;
+	offset = addr - aligned_addr;
+
+	mutex_lock(&iommu->lock);
+
+	d = vfio_find_iommu_domain(iommu_data, group);
+	if (!d) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	b = vfio_find_reserved_binding(d, aligned_addr, iommu_page_size);
+	if (b) {
+		ret = 0;
+		*iova = b->iova + offset;
+		kref_get(&b->kref);
+		goto unlock;
+	}
+
+	/* allocate a new reserved IOVA page and a new binding node */
+	p_iova = alloc_iova(d->reserved_iova_domain, 1,
+			    d->reserved_iova_domain->dma_32bit_pfn, true);
+	if (!p_iova) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+	*iova = p_iova->pfn_lo << order;
+
+	b = kzalloc(sizeof(*b), GFP_KERNEL);
+	if (!b) {
+		ret = -ENOMEM;
+		goto free_iova_unlock;
+	}
+
+	ret = iommu_map(d->domain, *iova, aligned_addr, iommu_page_size, prot);
+	if (ret)
+		goto free_binding_iova_unlock;
+
+	kref_init(&b->kref);
+	kref_get(&b->kref);
+	b->domain = d;
+	b->addr = aligned_addr;
+	b->iova = *iova;
+	b->size = iommu_page_size;
+	vfio_link_reserved_binding(d, b);
+	*iova += offset;
+
+	goto unlock;
+
+free_binding_iova_unlock:
+	kfree(b);
+free_iova_unlock:
+	free_iova(d->reserved_iova_domain, *iova >> order);
+unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
+static int vfio_iommu_type1_unmap_free_reserved_iova(void *iommu_data,
+						     struct iommu_group *group,
+						     dma_addr_t iova)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	struct vfio_reserved_binding *b;
+	struct vfio_domain *d;
+	phys_addr_t aligned_addr;
+	dma_addr_t aligned_iova, iommu_page_size, mask, offset;
+	unsigned long order;
+	int ret = 0;
+
+	order = __ffs(vfio_pgsize_bitmap(iommu));
+	iommu_page_size = (uint64_t)1 << order;
+	mask = iommu_page_size - 1;
+	aligned_iova = iova & ~mask;
+	offset = iova - aligned_iova;
+
+	mutex_lock(&iommu->lock);
+
+	d = vfio_find_iommu_domain(iommu_data, group);
+	if (!d) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	aligned_addr = iommu_iova_to_phys(d->domain, aligned_iova);
+
+	b = vfio_find_reserved_binding(d, aligned_addr, iommu_page_size);
+	if (!b) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	kref_put(&b->kref, vfio_reserved_binding_release);
+
+unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static void *vfio_iommu_type1_open(unsigned long arg)
 {
 	struct vfio_iommu *iommu;
@@ -1180,13 +1325,17 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 }
 
 static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
-	.name		= "vfio-iommu-type1",
-	.owner		= THIS_MODULE,
-	.open		= vfio_iommu_type1_open,
-	.release	= vfio_iommu_type1_release,
-	.ioctl		= vfio_iommu_type1_ioctl,
-	.attach_group	= vfio_iommu_type1_attach_group,
-	.detach_group	= vfio_iommu_type1_detach_group,
+	.name				= "vfio-iommu-type1",
+	.owner				= THIS_MODULE,
+	.open				= vfio_iommu_type1_open,
+	.release			= vfio_iommu_type1_release,
+	.ioctl				= vfio_iommu_type1_ioctl,
+	.attach_group			= vfio_iommu_type1_attach_group,
+	.detach_group			= vfio_iommu_type1_detach_group,
+	.alloc_map_reserved_iova	=
+		vfio_iommu_type1_alloc_map_reserved_iova,
+	.unmap_free_reserved_iova	=
+		vfio_iommu_type1_unmap_free_reserved_iova,
 };
 
 static int __init vfio_iommu_type1_init(void)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 610a86a..0020f81 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -75,7 +75,13 @@ struct vfio_iommu_driver_ops {
 					struct iommu_group *group);
 	void		(*detach_group)(void *iommu_data,
 					struct iommu_group *group);
-
+	int		(*alloc_map_reserved_iova)(void *iommu_data,
+						   struct iommu_group *group,
+						   phys_addr_t addr, int prot,
+						   dma_addr_t *iova);
+	int		(*unmap_free_reserved_iova)(void *iommu_data,
+						    struct iommu_group *group,
+						    dma_addr_t iova);
 };
 
 extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
@@ -138,4 +144,30 @@ extern int vfio_virqfd_enable(void *opaque,
 			      void *data, struct virqfd **pvirqfd, int fd);
 extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
 
+/**
+ * vfio_group_alloc_map_reserved_iova: allocates a new iova page and map
+ * it onto the aligned physical page that contains a given physical addr.
+ * page size is the domain iommu page size.
+ *
+ * @group: vfio group handle
+ * @addr: physical address to map
+ * @prot: protection attribute
+ * @iova: returned iova that is mapped onto addr
+ *
+ * returns 0 on success, < 0 on failure
+ */
+extern int vfio_group_alloc_map_reserved_iova(struct vfio_group *group,
+					      phys_addr_t addr, int prot,
+					      dma_addr_t *iova);
+/**
+ * vfio_group_unmap_free_reserved_iova: unmap and free the reserved iova page
+ *
+ * @group: vfio group handle
+ * @iova: base iova, must be aligned on the IOMMU page size
+ *
+ * returns 0 on success, < 0 on failure
+ */
+extern int vfio_group_unmap_free_reserved_iova(struct vfio_group *group,
+					       dma_addr_t iova);
+
 #endif /* VFIO_H */
-- 
1.9.1
