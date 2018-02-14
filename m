From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH 3/4] iommu/virtio: Add event queue
Date: Wed, 14 Feb 2018 14:53:39 +0000
Message-ID: <20180214145340.1223-4-jean-philippe.brucker@arm.com>
References: <20180214145340.1223-1-jean-philippe.brucker@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180214145340.1223-1-jean-philippe.brucker@arm.com>
Sender: kvm-owner@vger.kernel.org
To: iommu@lists.linux-foundation.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, kvmarm@lists.cs.columbia.edu
Cc: joro@8bytes.org, alex.williamson@redhat.com, mst@redhat.com, jasowang@redhat.com, marc.zyngier@arm.com, robin.murphy@arm.com, will.deacon@arm.com, lorenzo.pieralisi@arm.com, eric.auger@redhat.com, eric.auger.pro@gmail.com, peterx@redhat.com, bharat.bhushan@nxp.com, tnowicki@caviumnetworks.com, jayachandran.nair@cavium.com, kevin.tian@intel.com, jintack@cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The event queue offers a way for the device to report access faults from
endpoints. It is implemented on virtqueue #1. Whenever the host needs to
signal a fault, it fills one of the buffers offered by the guest and
interrupts it.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 drivers/iommu/virtio-iommu.c      | 139 ++++++++++++++++++++++++++++++++++----
 include/uapi/linux/virtio_iommu.h |  18 +++++
 2 files changed, 143 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 3ac4b38eaf19..6b96f1b36d5a 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -30,6 +30,12 @@
 #define MSI_IOVA_BASE			0x8000000
 #define MSI_IOVA_LENGTH			0x100000
 
+enum viommu_vq_idx {
+	VIOMMU_REQUEST_VQ	= 0,
+	VIOMMU_EVENT_VQ		= 1,
+	VIOMMU_NUM_VQS		= 2,
+};
+
 struct viommu_dev {
 	struct iommu_device		iommu;
 	struct device			*dev;
@@ -37,9 +43,10 @@ struct viommu_dev {
 
 	struct ida			domain_ids;
 
-	struct virtqueue		*vq;
+	struct virtqueue		*vqs[VIOMMU_NUM_VQS];
 	/* Serialize anything touching the request queue */
 	spinlock_t			request_lock;
+	void				*evts;
 
 	/* Device configuration */
 	struct iommu_domain_geometry	geometry;
@@ -84,6 +91,15 @@ struct viommu_request {
 	struct list_head		list;
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
 
@@ -161,12 +177,13 @@ static int viommu_receive_resp(struct viommu_dev *viommu, int nr_sent,
 	unsigned int len;
 	int nr_received = 0;
 	struct viommu_request *req, *pending;
+	struct virtqueue *vq = viommu->vqs[VIOMMU_REQUEST_VQ];
 
 	pending = list_first_entry_or_null(sent, struct viommu_request, list);
 	if (WARN_ON(!pending))
 		return 0;
 
-	while ((req = virtqueue_get_buf(viommu->vq, &len)) != NULL) {
+	while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
 		if (req != pending) {
 			dev_warn(viommu->dev, "discarding stale request\n");
 			continue;
@@ -201,6 +218,7 @@ static int _viommu_send_reqs_sync(struct viommu_dev *viommu,
 	 * up the CPU in case of a device bug.
 	 */
 	unsigned long timeout_ms = 1000;
+	struct virtqueue *vq = viommu->vqs[VIOMMU_REQUEST_VQ];
 
 	*nr_sent = 0;
 
@@ -210,15 +228,14 @@ static int _viommu_send_reqs_sync(struct viommu_dev *viommu,
 		sg[0] = &req->top;
 		sg[1] = &req->bottom;
 
-		ret = virtqueue_add_sgs(viommu->vq, sg, 1, 1, req,
-					GFP_ATOMIC);
+		ret = virtqueue_add_sgs(vq, sg, 1, 1, req, GFP_ATOMIC);
 		if (ret)
 			break;
 
 		list_add_tail(&req->list, &pending);
 	}
 
-	if (i && !virtqueue_kick(viommu->vq))
+	if (i && !virtqueue_kick(vq))
 		return -EPIPE;
 
 	timeout = ktime_add_ms(ktime_get(), timeout_ms * i);
@@ -553,6 +570,70 @@ static int viommu_probe_endpoint(struct viommu_dev *viommu, struct device *dev)
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
+
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
 
 static bool viommu_capable(enum iommu_cap cap)
@@ -934,19 +1015,44 @@ static struct iommu_ops viommu_ops = {
 	.put_resv_regions	= viommu_put_resv_regions,
 };
 
-static int viommu_init_vq(struct viommu_dev *viommu)
+static int viommu_init_vqs(struct viommu_dev *viommu)
 {
 	struct virtio_device *vdev = dev_to_virtio(viommu->dev);
-	const char *name = "request";
-	void *ret;
+	const char *names[] = { "request", "event" };
+	vq_callback_t *callbacks[] = {
+		NULL, /* No async requests */
+		viommu_event_handler,
+	};
+
+	return virtio_find_vqs(vdev, VIOMMU_NUM_VQS, viommu->vqs, callbacks,
+			       names, NULL);
+}
 
-	ret = virtio_find_single_vq(vdev, NULL, name);
-	if (IS_ERR(ret)) {
-		dev_err(viommu->dev, "cannot find VQ\n");
-		return PTR_ERR(ret);
+static int viommu_fill_evtq(struct viommu_dev *viommu)
+{
+	int i, ret;
+	struct scatterlist sg[1];
+	struct viommu_event *evts;
+	struct virtqueue *vq = viommu->vqs[VIOMMU_EVENT_VQ];
+	size_t nr_evts = min_t(size_t, PAGE_SIZE / sizeof(struct viommu_event),
+			       viommu->vqs[VIOMMU_EVENT_VQ]->num_free);
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
 	}
 
-	viommu->vq = ret;
+	if (!virtqueue_kick(vq))
+		return -EPIPE;
+
+	dev_info(viommu->dev, "%zu event buffers\n", nr_evts);
 
 	return 0;
 }
@@ -969,7 +1075,7 @@ static int viommu_probe(struct virtio_device *vdev)
 	viommu->dev = dev;
 	viommu->vdev = vdev;
 
-	ret = viommu_init_vq(viommu);
+	ret = viommu_init_vqs(viommu);
 	if (ret)
 		return ret;
 
@@ -1010,6 +1116,11 @@ static int viommu_probe(struct virtio_device *vdev)
 
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
index 2335d9ed4676..d6c0224efe61 100644
--- a/include/uapi/linux/virtio_iommu.h
+++ b/include/uapi/linux/virtio_iommu.h
@@ -150,4 +150,22 @@ union virtio_iommu_req {
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
2.16.1
