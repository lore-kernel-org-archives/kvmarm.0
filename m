From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v5 6/7] iommu/virtio: Add probe request
Date: Thu, 22 Nov 2018 19:38:00 +0000
Message-ID: <20181122193801.50510-7-jean-philippe.brucker@arm.com>
References: <20181122193801.50510-1-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <virtio-dev-return-5020-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20181122193801.50510-1-jean-philippe.brucker@arm.com>
To: iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org, devicetree@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, joro@8bytes.org, mst@redhat.com
Cc: jasowang@redhat.com, robh+dt@kernel.org, mark.rutland@arm.com, bhelgaas@google.com, frowand.list@gmail.com, kvmarm@lists.cs.columbia.edu, eric.auger@redhat.com, tnowicki@caviumnetworks.com, kevin.tian@intel.com, marc.zyngier@arm.com, robin.murphy@arm.com, will.deacon@arm.com, lorenzo.pieralisi@arm.com, bharat.bhushan@nxp.com
List-Id: kvmarm@lists.cs.columbia.edu

When the device offers the probe feature, send a probe request for each
device managed by the IOMMU. Extract RESV_MEM information. When we
encounter a MSI doorbell region, set it up as a IOMMU_RESV_MSI region.
This will tell other subsystems that there is no need to map the MSI
doorbell in the virtio-iommu, because MSIs bypass it.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 drivers/iommu/virtio-iommu.c      | 156 ++++++++++++++++++++++++++++--
 include/uapi/linux/virtio_iommu.h |  38 ++++++++
 2 files changed, 188 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 7540dab9c8dc..0c7a7fa2628d 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -46,6 +46,7 @@ struct viommu_dev {
 	struct iommu_domain_geometry	geometry;
 	u64				pgsize_bitmap;
 	u8				domain_bits;
+	u32				probe_size;
 };
 
 struct viommu_mapping {
@@ -67,8 +68,10 @@ struct viommu_domain {
 };
 
 struct viommu_endpoint {
+	struct device			*dev;
 	struct viommu_dev		*viommu;
 	struct viommu_domain		*vdomain;
+	struct list_head		resv_regions;
 };
 
 struct viommu_request {
@@ -119,6 +122,9 @@ static off_t viommu_get_write_desc_offset(struct viommu_dev *viommu,
 {
 	size_t tail_size = sizeof(struct virtio_iommu_req_tail);
 
+	if (req->type == VIRTIO_IOMMU_T_PROBE)
+		return len - viommu->probe_size - tail_size;
+
 	return len - tail_size;
 }
 
@@ -393,6 +399,110 @@ static int viommu_replay_mappings(struct viommu_domain *vdomain)
 	return ret;
 }
 
+static int viommu_add_resv_mem(struct viommu_endpoint *vdev,
+			       struct virtio_iommu_probe_resv_mem *mem,
+			       size_t len)
+{
+	size_t size;
+	u64 start64, end64;
+	phys_addr_t start, end;
+	struct iommu_resv_region *region = NULL;
+	unsigned long prot = IOMMU_WRITE | IOMMU_NOEXEC | IOMMU_MMIO;
+
+	start = start64 = le64_to_cpu(mem->start);
+	end = end64 = le64_to_cpu(mem->end);
+	size = end64 - start64 + 1;
+
+	/* Catch any overflow, including the unlikely end64 - start64 + 1 = 0 */
+	if (start != start64 || end != end64 || size < end64 - start64)
+		return -EOVERFLOW;
+
+	if (len < sizeof(*mem))
+		return -EINVAL;
+
+	switch (mem->subtype) {
+	default:
+		dev_warn(vdev->dev, "unknown resv mem subtype 0x%x\n",
+			 mem->subtype);
+		/* Fall-through */
+	case VIRTIO_IOMMU_RESV_MEM_T_RESERVED:
+		region = iommu_alloc_resv_region(start, size, 0,
+						 IOMMU_RESV_RESERVED);
+		break;
+	case VIRTIO_IOMMU_RESV_MEM_T_MSI:
+		region = iommu_alloc_resv_region(start, size, prot,
+						 IOMMU_RESV_MSI);
+		break;
+	}
+	if (!region)
+		return -ENOMEM;
+
+	list_add(&vdev->resv_regions, &region->list);
+	return 0;
+}
+
+static int viommu_probe_endpoint(struct viommu_dev *viommu, struct device *dev)
+{
+	int ret;
+	u16 type, len;
+	size_t cur = 0;
+	size_t probe_len;
+	struct virtio_iommu_req_probe *probe;
+	struct virtio_iommu_probe_property *prop;
+	struct iommu_fwspec *fwspec = dev->iommu_fwspec;
+	struct viommu_endpoint *vdev = fwspec->iommu_priv;
+
+	if (!fwspec->num_ids)
+		return -EINVAL;
+
+	probe_len = sizeof(*probe) + viommu->probe_size +
+		    sizeof(struct virtio_iommu_req_tail);
+	probe = kzalloc(probe_len, GFP_KERNEL);
+	if (!probe)
+		return -ENOMEM;
+
+	probe->head.type = VIRTIO_IOMMU_T_PROBE;
+	/*
+	 * For now, assume that properties of an endpoint that outputs multiple
+	 * IDs are consistent. Only probe the first one.
+	 */
+	probe->endpoint = cpu_to_le32(fwspec->ids[0]);
+
+	ret = viommu_send_req_sync(viommu, probe, probe_len);
+	if (ret)
+		goto out_free;
+
+	prop = (void *)probe->properties;
+	type = le16_to_cpu(prop->type) & VIRTIO_IOMMU_PROBE_T_MASK;
+
+	while (type != VIRTIO_IOMMU_PROBE_T_NONE &&
+	       cur < viommu->probe_size) {
+		len = le16_to_cpu(prop->length) + sizeof(*prop);
+
+		switch (type) {
+		case VIRTIO_IOMMU_PROBE_T_RESV_MEM:
+			ret = viommu_add_resv_mem(vdev, (void *)prop, len);
+			break;
+		default:
+			dev_err(dev, "unknown viommu prop 0x%x\n", type);
+		}
+
+		if (ret)
+			dev_err(dev, "failed to parse viommu prop 0x%x\n", type);
+
+		cur += len;
+		if (cur >= viommu->probe_size)
+			break;
+
+		prop = (void *)probe->properties + cur;
+		type = le16_to_cpu(prop->type) & VIRTIO_IOMMU_PROBE_T_MASK;
+	}
+
+out_free:
+	kfree(probe);
+	return ret;
+}
+
 /* IOMMU API */
 
 static struct iommu_domain *viommu_domain_alloc(unsigned type)
@@ -614,15 +724,33 @@ static void viommu_iotlb_sync(struct iommu_domain *domain)
 
 static void viommu_get_resv_regions(struct device *dev, struct list_head *head)
 {
-	struct iommu_resv_region *region;
+	struct iommu_resv_region *entry, *new_entry, *msi = NULL;
+	struct viommu_endpoint *vdev = dev->iommu_fwspec->iommu_priv;
 	int prot = IOMMU_WRITE | IOMMU_NOEXEC | IOMMU_MMIO;
 
-	region = iommu_alloc_resv_region(MSI_IOVA_BASE, MSI_IOVA_LENGTH, prot,
-					 IOMMU_RESV_SW_MSI);
-	if (!region)
-		return;
+	list_for_each_entry(entry, &vdev->resv_regions, list) {
+		if (entry->type == IOMMU_RESV_MSI)
+			msi = entry;
+
+		new_entry = kmemdup(entry, sizeof(*entry), GFP_KERNEL);
+		if (!new_entry)
+			return;
+		list_add_tail(&new_entry->list, head);
+	}
+
+	/*
+	 * If the device didn't register any bypass MSI window, add a
+	 * software-mapped region.
+	 */
+	if (!msi) {
+		msi = iommu_alloc_resv_region(MSI_IOVA_BASE, MSI_IOVA_LENGTH,
+					      prot, IOMMU_RESV_SW_MSI);
+		if (!msi)
+			return;
+
+		list_add_tail(&msi->list, head);
+	}
 
-	list_add_tail(&region->list, head);
 	iommu_dma_get_resv_regions(dev, head);
 }
 
@@ -670,9 +798,18 @@ static int viommu_add_device(struct device *dev)
 	if (!vdev)
 		return -ENOMEM;
 
+	vdev->dev = dev;
 	vdev->viommu = viommu;
+	INIT_LIST_HEAD(&vdev->resv_regions);
 	fwspec->iommu_priv = vdev;
 
+	if (viommu->probe_size) {
+		/* Get additional information for this endpoint */
+		ret = viommu_probe_endpoint(viommu, dev);
+		if (ret)
+			goto err_free_dev;
+	}
+
 	ret = iommu_device_link(&viommu->iommu, dev);
 	if (ret)
 		goto err_free_dev;
@@ -694,6 +831,7 @@ static int viommu_add_device(struct device *dev)
 err_unlink_dev:
 	iommu_device_unlink(&viommu->iommu, dev);
 err_free_dev:
+	viommu_put_resv_regions(dev, &vdev->resv_regions);
 	kfree(vdev);
 
 	return ret;
@@ -711,6 +849,7 @@ static void viommu_remove_device(struct device *dev)
 
 	iommu_group_remove_device(dev);
 	iommu_device_unlink(&vdev->viommu->iommu, dev);
+	viommu_put_resv_regions(dev, &vdev->resv_regions);
 	kfree(vdev);
 }
 
@@ -810,6 +949,10 @@ static int viommu_probe(struct virtio_device *vdev)
 			     struct virtio_iommu_config, domain_bits,
 			     &viommu->domain_bits);
 
+	virtio_cread_feature(vdev, VIRTIO_IOMMU_F_PROBE,
+			     struct virtio_iommu_config, probe_size,
+			     &viommu->probe_size);
+
 	viommu->geometry = (struct iommu_domain_geometry) {
 		.aperture_start	= input_start,
 		.aperture_end	= input_end,
@@ -891,6 +1034,7 @@ static unsigned int features[] = {
 	VIRTIO_IOMMU_F_MAP_UNMAP,
 	VIRTIO_IOMMU_F_DOMAIN_BITS,
 	VIRTIO_IOMMU_F_INPUT_RANGE,
+	VIRTIO_IOMMU_F_PROBE,
 };
 
 static struct virtio_device_id id_table[] = {
diff --git a/include/uapi/linux/virtio_iommu.h b/include/uapi/linux/virtio_iommu.h
index e7c05e3afa44..ae6145cf5928 100644
--- a/include/uapi/linux/virtio_iommu.h
+++ b/include/uapi/linux/virtio_iommu.h
@@ -14,6 +14,7 @@
 #define VIRTIO_IOMMU_F_DOMAIN_BITS		1
 #define VIRTIO_IOMMU_F_MAP_UNMAP		2
 #define VIRTIO_IOMMU_F_BYPASS			3
+#define VIRTIO_IOMMU_F_PROBE			4
 
 struct virtio_iommu_range {
 	__u64					start;
@@ -28,6 +29,8 @@ struct virtio_iommu_config {
 	/* Max domain ID size */
 	__u8					domain_bits;
 	__u8					padding[3];
+	/* Probe buffer size */
+	__u32					probe_size;
 };
 
 /* Request types */
@@ -35,6 +38,7 @@ struct virtio_iommu_config {
 #define VIRTIO_IOMMU_T_DETACH			0x02
 #define VIRTIO_IOMMU_T_MAP			0x03
 #define VIRTIO_IOMMU_T_UNMAP			0x04
+#define VIRTIO_IOMMU_T_PROBE			0x05
 
 /* Status types */
 #define VIRTIO_IOMMU_S_OK			0x00
@@ -101,4 +105,38 @@ struct virtio_iommu_req_unmap {
 	struct virtio_iommu_req_tail		tail;
 };
 
+#define VIRTIO_IOMMU_PROBE_T_NONE		0
+#define VIRTIO_IOMMU_PROBE_T_RESV_MEM		1
+
+#define VIRTIO_IOMMU_PROBE_T_MASK		0xfff
+
+struct virtio_iommu_probe_property {
+	__le16					type;
+	__le16					length;
+};
+
+#define VIRTIO_IOMMU_RESV_MEM_T_RESERVED	0
+#define VIRTIO_IOMMU_RESV_MEM_T_MSI		1
+
+struct virtio_iommu_probe_resv_mem {
+	struct virtio_iommu_probe_property	head;
+	__u8					subtype;
+	__u8					reserved[3];
+	__le64					start;
+	__le64					end;
+};
+
+struct virtio_iommu_req_probe {
+	struct virtio_iommu_req_head		head;
+	__le32					endpoint;
+	__u8					reserved[64];
+
+	__u8					properties[];
+
+	/*
+	 * Tail follows the variable-length properties array. No padding,
+	 * property lengths are all aligned on 8 bytes.
+	 */
+};
+
 #endif
-- 
2.19.1
