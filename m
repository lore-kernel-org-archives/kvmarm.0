From: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v3 18/21] vfio-pci: Add a new VFIO_REGION_TYPE_NESTED region type
Date: Tue,  8 Jan 2019 11:26:30 +0100
Message-ID: <20190108102633.17482-19-eric.auger@redhat.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20190108102633.17482-1-eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yi.l.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org
Cc: marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christoffer.dall-5wv7dgnIgG8@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds a new 64kB region aiming to report nested mode
translation faults.

The region contains a header with the size of the queue,
the producer and consumer indices and then the actual
fault queue data. The producer is updated by the kernel while
the consumer is updated by the userspace.

Signed-off-by: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---
---
 drivers/vfio/pci/vfio_pci.c         | 102 +++++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_private.h |   2 +
 include/uapi/linux/vfio.h           |  15 ++++
 3 files changed, 118 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index ff60bd1ea587..2ba181ab2edd 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -56,6 +56,11 @@ module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(disable_idle_d3,
 		 "Disable using the PCI D3 low power state for idle, unused devices");
 
+#define VFIO_FAULT_REGION_SIZE 0x10000
+#define VFIO_FAULT_QUEUE_SIZE	\
+	((VFIO_FAULT_REGION_SIZE - sizeof(struct vfio_fault_region_header)) / \
+	sizeof(struct iommu_fault))
+
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
@@ -1226,6 +1231,100 @@ static const struct vfio_device_ops vfio_pci_ops = {
 static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
 static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
 
+static size_t
+vfio_pci_dma_fault_rw(struct vfio_pci_device *vdev, char __user *buf,
+		      size_t count, loff_t *ppos, bool iswrite)
+{
+	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
+	void *base = vdev->region[i].data;
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+
+	if (pos >= vdev->region[i].size)
+		return -EINVAL;
+
+	count = min(count, (size_t)(vdev->region[i].size - pos));
+
+	if (copy_to_user(buf, base + pos, count))
+		return -EFAULT;
+
+	*ppos += count;
+
+	return count;
+}
+
+static int vfio_pci_dma_fault_mmap(struct vfio_pci_device *vdev,
+				   struct vfio_pci_region *region,
+				   struct vm_area_struct *vma)
+{
+	u64 phys_len, req_len, pgoff, req_start;
+	unsigned long long addr;
+	unsigned int index;
+
+	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+	if ((vma->vm_flags & VM_SHARED) == 0)
+		return -EINVAL;
+
+	phys_len = VFIO_FAULT_REGION_SIZE;
+
+	req_len = vma->vm_end - vma->vm_start;
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	req_start = pgoff << PAGE_SHIFT;
+
+	if (req_start + req_len > phys_len)
+		return -EINVAL;
+
+	addr = virt_to_phys(vdev->fault_region);
+	vma->vm_private_data = vdev;
+	vma->vm_pgoff = (addr >> PAGE_SHIFT) + pgoff;
+
+	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			       req_len, vma->vm_page_prot);
+}
+
+void vfio_pci_dma_fault_release(struct vfio_pci_device *vdev,
+				struct vfio_pci_region *region)
+{
+}
+
+static const struct vfio_pci_regops vfio_pci_dma_fault_regops = {
+	.rw		= vfio_pci_dma_fault_rw,
+	.mmap		= vfio_pci_dma_fault_mmap,
+	.release	= vfio_pci_dma_fault_release,
+};
+
+static int vfio_pci_init_dma_fault_region(struct vfio_pci_device *vdev)
+{
+	u32 flags = VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE |
+		    VFIO_REGION_INFO_FLAG_MMAP;
+	int ret;
+
+	spin_lock_init(&vdev->fault_queue_lock);
+
+	vdev->fault_region = kmalloc(VFIO_FAULT_REGION_SIZE, GFP_KERNEL);
+	if (!vdev->fault_region)
+		return -ENOMEM;
+
+	ret = vfio_pci_register_dev_region(vdev,
+		VFIO_REGION_TYPE_NESTED,
+		VFIO_REGION_SUBTYPE_NESTED_FAULT_REGION,
+		&vfio_pci_dma_fault_regops, VFIO_FAULT_REGION_SIZE,
+		flags, vdev->fault_region);
+	if (ret) {
+		kfree(vdev->fault_region);
+		return ret;
+	}
+
+	vdev->fault_region->header.prod = 0;
+	vdev->fault_region->header.cons = 0;
+	vdev->fault_region->header.reserved = 0;
+	vdev->fault_region->header.size = VFIO_FAULT_QUEUE_SIZE;
+	return 0;
+}
+
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct vfio_pci_device *vdev;
@@ -1300,7 +1399,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
 
-	return ret;
+	return vfio_pci_init_dma_fault_region(vdev);
 }
 
 static void vfio_pci_remove(struct pci_dev *pdev)
@@ -1315,6 +1414,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 
 	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
 	kfree(vdev->region);
+	kfree(vdev->fault_region);
 	mutex_destroy(&vdev->ioeventfds_lock);
 	kfree(vdev);
 
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 8c0009f00818..38b5d1764a26 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -120,6 +120,8 @@ struct vfio_pci_device {
 	int			ioeventfds_nr;
 	struct eventfd_ctx	*err_trigger;
 	struct eventfd_ctx	*req_trigger;
+	spinlock_t              fault_queue_lock;
+	struct vfio_fault_region *fault_region;
 	struct list_head	dummy_resources_list;
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 352e795a93c8..b78c2c62af6d 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -307,6 +307,9 @@ struct vfio_region_info_cap_type {
 #define VFIO_REGION_TYPE_GFX                    (1)
 #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
 
+#define VFIO_REGION_TYPE_NESTED			(2)
+#define VFIO_REGION_SUBTYPE_NESTED_FAULT_REGION	(1)
+
 /**
  * struct vfio_region_gfx_edid - EDID region layout.
  *
@@ -697,6 +700,18 @@ struct vfio_device_ioeventfd {
 
 #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+struct vfio_fault_region_header {
+	__u32	size;		/* Read-Only */
+	__u32	prod;		/* Read-Only */
+	__u32	cons;
+	__u32	reserved;	/* must be 0 */
+};
+
+struct vfio_fault_region {
+	struct vfio_fault_region_header header;
+	struct iommu_fault queue[0];
+};
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.17.2
