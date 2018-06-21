From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v2 4/5] iommu/virtio: Add event queue
Date: Thu, 21 Jun 2018 20:06:54 +0100
Message-ID: <20180621190655.56391-5-jean-philippe.brucker@arm.com>
References: <20180621190655.56391-1-jean-philippe.brucker@arm.com>
Return-path: <virtio-dev-return-4473-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20180621190655.56391-1-jean-philippe.brucker@arm.com>
To: iommu@lists.linux-foundation.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, devicetree@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: joro@8bytes.org, alex.williamson@redhat.com, robh+dt@kernel.org, mark.rutland@arm.com, mst@redhat.com, jasowang@redhat.com, marc.zyngier@arm.com, robin.murphy@arm.com, will.deacon@arm.com, lorenzo.pieralisi@arm.com, eric.auger@redhat.com, peterx@redhat.com, bharat.bhushan@nxp.com, tnowicki@caviumnetworks.com, jayachandran.nair@cavium.com, kevin.tian@intel.com
List-Id: kvmarm@lists.cs.columbia.edu

The event queue offers a way for the device to report access faults from
endpoints. It is implemented on virtqueue #1. Whenever the host needs to
signal a fault, it fills one of the buffers offered by the guest and
interrupts it.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 drivers/iommu/virtio-iommu.c      | 116 +++++++++++++++++++++++++++---
 include/uapi/linux/virtio_iommu.h |  18 +++++
 2 files changed, 125 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 29ce9f4398ef..c075404e97d6 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -29,7 +29,8 @@
 #define MSI_IOVA_LENGTH			0x100000
 
 #define VIOMMU_REQUEST_VQ		0
-#define VIOMMU_NR_VQS			1
+#define VIOMMU_EVENT_VQ			1
+#define VIOMMU_NR_VQS			2
 
 #define VIOMMU_REQUEST_TIMEOUT		10000 /* 10s */
 
@@ -43,6 +44,7 @@ struct viommu_dev {
 	struct virtqueue		*vqs[VIOMMU_NR_VQS];
 	spinlock_t			request_lock;
 	struct list_head		requests;
+	void				*evts;
 
 	/* Device configuration */
 	struct iommu_domain_geometry	geometry;
@@ -84,6 +86,15 @@ struct viommu_request {
 	char				buf[];
 };
 
+#define VIOMMU_FAULT_RESV_MASK		0xffffff00
+
+struct viommu_event {
+	union {
+		u32			head;
+		struct virtio_iommu_fault fault;
+	};
+};
+
 #define to_viommu_domain(domain)	\
 	container_of(domain, struct viommu_domain, domain)
 
@@ -507,6 +518,69 @@ static int viommu_probe_endpoint(struct viommu_dev *viommu, struct device *dev)
 	return ret;
 }
 
+static int viommu_fault_handler(struct viommu_dev *viommu,
+				struct virtio_iommu_fault *fault)
+{
+	char *reason_str;
+
+	u8 reason	= fault->reason;
+	u32 flags	= le32_to_cpu(fault->flags);
+	u32 endpoint	= le32_to_cpu(fault->endpoint);
+	u64 address	= le64_to_cpu(fault->address);
+
+	switch (reason) {
+	case VIRTIO_IOMMU_FAULT_R_DOMAIN:
+		reason_str = "domain";
+		break;
+	case VIRTIO_IOMMU_FAULT_R_MAPPING:
+		reason_str = "page";
+		break;
+	case VIRTIO_IOMMU_FAULT_R_UNKNOWN:
+	default:
+		reason_str = "unknown";
+		break;
+	}
+
+	/* TODO: find EP by ID and report_iommu_fault */
+	if (flags & VIRTIO_IOMMU_FAULT_F_ADDRESS)
+		dev_err_ratelimited(viommu->dev, "%s fault from EP %u at %#llx [%s%s%s]\n",
+				    reason_str, endpoint, address,
+				    flags & VIRTIO_IOMMU_FAULT_F_READ ? "R" : "",
+				    flags & VIRTIO_IOMMU_FAULT_F_WRITE ? "W" : "",
+				    flags & VIRTIO_IOMMU_FAULT_F_EXEC ? "X" : "");
+	else
+		dev_err_ratelimited(viommu->dev, "%s fault from EP %u\n",
+				    reason_str, endpoint);
+	return 0;
+}
+
+static void viommu_event_handler(struct virtqueue *vq)
+{
+	int ret;
+	unsigned int len;
+	struct scatterlist sg[1];
+	struct viommu_event *evt;
+	struct viommu_dev *viommu = vq->vdev->priv;
+
+	while ((evt = virtqueue_get_buf(vq, &len)) != NULL) {
+		if (len > sizeof(*evt)) {
+			dev_err(viommu->dev,
+				"invalid event buffer (len %u != %zu)\n",
+				len, sizeof(*evt));
+		} else if (!(evt->head & VIOMMU_FAULT_RESV_MASK)) {
+			viommu_fault_handler(viommu, &evt->fault);
+		}
+
+		sg_init_one(sg, evt, sizeof(*evt));
+		ret = virtqueue_add_inbuf(vq, sg, 1, evt, GFP_ATOMIC);
+		if (ret)
+			dev_err(viommu->dev, "could not add event buffer\n");
+	}
+
+	if (!virtqueue_kick(vq))
+		dev_err(viommu->dev, "kick failed\n");
+}
+
 /* IOMMU API */
 
 static struct iommu_domain *viommu_domain_alloc(unsigned type)
@@ -893,16 +967,35 @@ static struct iommu_ops viommu_ops = {
 static int viommu_init_vqs(struct viommu_dev *viommu)
 {
 	struct virtio_device *vdev = dev_to_virtio(viommu->dev);
-	const char *name = "request";
-	void *ret;
+	const char *names[] = { "request", "event" };
+	vq_callback_t *callbacks[] = {
+		NULL, /* No async requests */
+		viommu_event_handler,
+	};
 
-	ret = virtio_find_single_vq(vdev, NULL, name);
-	if (IS_ERR(ret)) {
-		dev_err(viommu->dev, "cannot find VQ\n");
-		return PTR_ERR(ret);
-	}
+	return virtio_find_vqs(vdev, VIOMMU_NR_VQS, viommu->vqs, callbacks,
+			       names, NULL);
+}
 
-	viommu->vqs[VIOMMU_REQUEST_VQ] = ret;
+static int viommu_fill_evtq(struct viommu_dev *viommu)
+{
+	int i, ret;
+	struct scatterlist sg[1];
+	struct viommu_event *evts;
+	struct virtqueue *vq = viommu->vqs[VIOMMU_EVENT_VQ];
+	size_t nr_evts = vq->num_free;
+
+	viommu->evts = evts = devm_kmalloc_array(viommu->dev, nr_evts,
+						 sizeof(*evts), GFP_KERNEL);
+	if (!evts)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_evts; i++) {
+		sg_init_one(sg, &evts[i], sizeof(*evts));
+		ret = virtqueue_add_inbuf(vq, sg, 1, &evts[i], GFP_KERNEL);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
@@ -967,6 +1060,11 @@ static int viommu_probe(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
+	/* Populate the event queue with buffers */
+	ret = viommu_fill_evtq(viommu);
+	if (ret)
+		goto err_free_vqs;
+
 	ret = iommu_device_sysfs_add(&viommu->iommu, dev, NULL, "%s",
 				     virtio_bus_name(vdev));
 	if (ret)
diff --git a/include/uapi/linux/virtio_iommu.h b/include/uapi/linux/virtio_iommu.h
index 2fd802a860cd..4e501d34267a 100644
--- a/include/uapi/linux/virtio_iommu.h
+++ b/include/uapi/linux/virtio_iommu.h
@@ -151,4 +151,22 @@ union virtio_iommu_req {
 	struct virtio_iommu_req_probe		probe;
 };
 
+/* Fault types */
+#define VIRTIO_IOMMU_FAULT_R_UNKNOWN		0
+#define VIRTIO_IOMMU_FAULT_R_DOMAIN		1
+#define VIRTIO_IOMMU_FAULT_R_MAPPING		2
+
+#define VIRTIO_IOMMU_FAULT_F_READ		(1 << 0)
+#define VIRTIO_IOMMU_FAULT_F_WRITE		(1 << 1)
+#define VIRTIO_IOMMU_FAULT_F_EXEC		(1 << 2)
+#define VIRTIO_IOMMU_FAULT_F_ADDRESS		(1 << 8)
+
+struct virtio_iommu_fault {
+	__u8					reason;
+	__u8					padding[3];
+	__le32					flags;
+	__le32					endpoint;
+	__le64					address;
+} __packed;
+
 #endif
-- 
2.17.0
