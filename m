From: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Subject: [RFC PATCH 1/6] vfio: Add interface for add/del reserved iova region
Date: Wed, 30 Sep 2015 20:26:24 +0530
Message-ID: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3C6A411E2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 05:21:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dp4fT9OEVnpH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Sep 2015 05:21:45 -0400 (EDT)
Received: from na01-by2-obe.outbound.protection.outlook.com
 (mail-by2on0124.outbound.protection.outlook.com [207.46.100.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28DE2410BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 05:21:44 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com
Cc: marc.zyngier@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

This Patch adds the VFIO APIs to add and remove reserved iova
regions. The reserved iova region can be used for mapping some
specific physical address in iommu.

Currently we are planning to use this interface for adding iova
regions for creating iommu of msi-pages. But the API are designed
for future extension where some other physical address can be mapped.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
---
 drivers/vfio/vfio_iommu_type1.c | 201 +++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/vfio.h       |  43 +++++++++
 2 files changed, 243 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 57d8c37..fa5d3e4 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -59,6 +59,7 @@ struct vfio_iommu {
 	struct rb_root		dma_list;
 	bool			v2;
 	bool			nesting;
+	struct list_head	reserved_iova_list;
 };
 
 struct vfio_domain {
@@ -77,6 +78,15 @@ struct vfio_dma {
 	int			prot;		/* IOMMU_READ/WRITE */
 };
 
+struct vfio_resvd_region {
+	dma_addr_t	iova;
+	size_t		size;
+	int		prot;			/* IOMMU_READ/WRITE */
+	int		refcount;		/* ref count of mappings */
+	uint64_t	map_paddr;		/* Mapped Physical Address */
+	struct list_head next;
+};
+
 struct vfio_group {
 	struct iommu_group	*iommu_group;
 	struct list_head	next;
@@ -106,6 +116,38 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
 	return NULL;
 }
 
+/* This function must be called with iommu->lock held */
+static bool vfio_overlap_with_resvd_region(struct vfio_iommu *iommu,
+					   dma_addr_t start, size_t size)
+{
+	struct vfio_resvd_region *region;
+
+	list_for_each_entry(region, &iommu->reserved_iova_list, next) {
+		if (region->iova < start)
+			return (start - region->iova < region->size);
+		else if (start < region->iova)
+			return (region->iova - start < size);
+
+		return (region->size > 0 && size > 0);
+	}
+
+	return false;
+}
+
+/* This function must be called with iommu->lock held */
+static
+struct vfio_resvd_region *vfio_find_resvd_region(struct vfio_iommu *iommu,
+						 dma_addr_t start, size_t size)
+{
+	struct vfio_resvd_region *region;
+
+	list_for_each_entry(region, &iommu->reserved_iova_list, next)
+		if (region->iova == start && region->size == size)
+			return region;
+
+	return NULL;
+}
+
 static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
 {
 	struct rb_node **link = &iommu->dma_list.rb_node, *parent = NULL;
@@ -580,7 +622,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 
 	mutex_lock(&iommu->lock);
 
-	if (vfio_find_dma(iommu, iova, size)) {
+	if (vfio_find_dma(iommu, iova, size) ||
+	    vfio_overlap_with_resvd_region(iommu, iova, size)) {
 		mutex_unlock(&iommu->lock);
 		return -EEXIST;
 	}
@@ -626,6 +669,127 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	return ret;
 }
 
+/* This function must be called with iommu->lock held */
+static
+int vfio_iommu_resvd_region_del(struct vfio_iommu *iommu,
+				dma_addr_t iova, size_t size, int prot)
+{
+	struct vfio_resvd_region *res_region;
+
+	res_region = vfio_find_resvd_region(iommu, iova, size);
+	/* Region should not be mapped in iommu */
+	if (res_region == NULL || res_region->map_paddr)
+		return -EINVAL;
+
+	list_del(&res_region->next);
+	kfree(res_region);
+	return 0;
+}
+
+/* This function must be called with iommu->lock held */
+static int vfio_iommu_resvd_region_add(struct vfio_iommu *iommu,
+				       dma_addr_t iova, size_t size, int prot)
+{
+	struct vfio_resvd_region *res_region;
+
+	/* Check overlap with with dma maping and reserved regions */
+	if (vfio_find_dma(iommu, iova, size) ||
+	    vfio_find_resvd_region(iommu, iova, size))
+		return -EEXIST;
+
+	res_region = kzalloc(sizeof(*res_region), GFP_KERNEL);
+	if (res_region == NULL)
+		return -ENOMEM;
+
+	res_region->iova = iova;
+	res_region->size = size;
+	res_region->prot = prot;
+	res_region->refcount = 0;
+	res_region->map_paddr = 0;
+
+	list_add(&res_region->next, &iommu->reserved_iova_list);
+
+	return 0;
+}
+
+static
+int vfio_handle_reserved_region_add(struct vfio_iommu *iommu,
+				struct vfio_iommu_reserved_region_add *region)
+{
+	dma_addr_t iova = region->iova;
+	size_t size = region->size;
+	int flags = region->flags;
+	uint64_t mask;
+	int prot = 0;
+	int ret;
+
+	/* Verify that none of our __u64 fields overflow */
+	if (region->size != size || region->iova != iova)
+		return -EINVAL;
+
+	mask = ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
+
+	WARN_ON(mask & PAGE_MASK);
+
+	if (flags & VFIO_IOMMU_RES_REGION_READ)
+		prot |= IOMMU_READ;
+	if (flags & VFIO_IOMMU_RES_REGION_WRITE)
+		prot |= IOMMU_WRITE;
+
+	if (!prot || !size || (size | iova) & mask)
+		return -EINVAL;
+
+	/* Don't allow IOVA wrap */
+	if (iova + size - 1 < iova)
+		return -EINVAL;
+
+	mutex_lock(&iommu->lock);
+
+	if (region->flags & VFIO_IOMMU_RES_REGION_ADD) {
+		ret = vfio_iommu_resvd_region_add(iommu, iova, size, prot);
+		if (ret) {
+			mutex_unlock(&iommu->lock);
+			return ret;
+		}
+	}
+
+	mutex_unlock(&iommu->lock);
+	return 0;
+}
+
+static
+int vfio_handle_reserved_region_del(struct vfio_iommu *iommu,
+				struct vfio_iommu_reserved_region_del *region)
+{
+	dma_addr_t iova = region->iova;
+	size_t size = region->size;
+	int flags = region->flags;
+	int ret;
+
+	if (!(flags & VFIO_IOMMU_RES_REGION_DEL))
+		return -EINVAL;
+
+	mutex_lock(&iommu->lock);
+
+	/* Check for the region */
+	if (vfio_find_resvd_region(iommu, iova, size) == NULL) {
+		mutex_unlock(&iommu->lock);
+		return -EINVAL;
+	}
+
+	/* remove the reserved region */
+	if (region->flags & VFIO_IOMMU_RES_REGION_DEL) {
+		ret = vfio_iommu_resvd_region_del(iommu, iova, size, flags);
+		if (ret) {
+			mutex_unlock(&iommu->lock);
+			return ret;
+		}
+	}
+
+	mutex_unlock(&iommu->lock);
+	return 0;
+}
+
 static int vfio_bus_type(struct device *dev, void *data)
 {
 	struct bus_type **bus = data;
@@ -905,6 +1069,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	}
 
 	INIT_LIST_HEAD(&iommu->domain_list);
+	INIT_LIST_HEAD(&iommu->reserved_iova_list);
 	iommu->dma_list = RB_ROOT;
 	mutex_init(&iommu->lock);
 
@@ -1020,6 +1185,40 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 			return ret;
 
 		return copy_to_user((void __user *)arg, &unmap, minsz);
+	} else if (cmd == VFIO_IOMMU_RESERVED_REGION_ADD) {
+		struct vfio_iommu_reserved_region_add region;
+		long ret;
+
+		minsz = offsetofend(struct vfio_iommu_reserved_region_add,
+				    size);
+		if (copy_from_user(&region, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (region.argsz < minsz)
+			return -EINVAL;
+
+		ret = vfio_handle_reserved_region_add(iommu, &region);
+		if (ret)
+			return ret;
+
+		return copy_to_user((void __user *)arg, &region, minsz);
+	} else if (cmd == VFIO_IOMMU_RESERVED_REGION_DEL) {
+		struct vfio_iommu_reserved_region_del region;
+		long ret;
+
+		minsz = offsetofend(struct vfio_iommu_reserved_region_del,
+				    size);
+		if (copy_from_user(&region, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (region.argsz < minsz)
+			return -EINVAL;
+
+		ret = vfio_handle_reserved_region_del(iommu, &region);
+		if (ret)
+			return ret;
+
+		return copy_to_user((void __user *)arg, &region, minsz);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index b57b750..1abd1a9 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -440,6 +440,49 @@ struct vfio_iommu_type1_dma_unmap {
 #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
 #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+/**************** Reserved IOVA region specific APIs **********************/
+
+/*
+ * VFIO_IOMMU_RESERVED_REGION_ADD - _IO(VFIO_TYPE, VFIO_BASE + 17,
+ *					struct vfio_iommu_reserved_region_add)
+ * This is used to add a reserved iova region.
+ * @flags - Input: VFIO_IOMMU_RES_REGION_ADD flag is for adding
+ * a reserved region.
+ * Also pass READ/WRITE/IOMMU flags to be used in iommu mapping.
+ * @iova - Input: IOVA base address of reserved region
+ * @size - Input: Size of the reserved region
+ * Return: 0 on success, -errno on failure
+ */
+struct vfio_iommu_reserved_region_add {
+	__u32   argsz;
+	__u32   flags;
+#define VFIO_IOMMU_RES_REGION_ADD	(1 << 0) /* Add a reserved region */
+#define VFIO_IOMMU_RES_REGION_READ	(1 << 1) /* readable region */
+#define VFIO_IOMMU_RES_REGION_WRITE	(1 << 2) /* writable region */
+	__u64	iova;
+	__u64   size;
+};
+#define VFIO_IOMMU_RESERVED_REGION_ADD _IO(VFIO_TYPE, VFIO_BASE + 17)
+
+/*
+ * VFIO_IOMMU_RESERVED_REGION_DEL - _IO(VFIO_TYPE, VFIO_BASE + 18,
+ *					struct vfio_iommu_reserved_region_del)
+ * This is used to delete an existing reserved iova region.
+ * @flags - VFIO_IOMMU_RES_REGION_DEL flag is for deleting a region use,
+ *  only a unmapped region can be deleted.
+ * @iova - Input: IOVA base address of reserved region
+ * @size - Input: Size of the reserved region
+ * Return: 0 on success, -errno on failure
+ */
+struct vfio_iommu_reserved_region_del {
+	__u32   argsz;
+	__u32   flags;
+#define VFIO_IOMMU_RES_REGION_DEL	(1 << 0) /* unset the reserved region */
+	__u64	iova;
+	__u64   size;
+};
+#define VFIO_IOMMU_RESERVED_REGION_DEL _IO(VFIO_TYPE, VFIO_BASE + 18)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
1.9.3
