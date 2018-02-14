From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH 1/4] iommu: Add virtio-iommu driver
Date: Wed, 14 Feb 2018 14:53:37 +0000
Message-ID: <20180214145340.1223-2-jean-philippe.brucker@arm.com>
References: <20180214145340.1223-1-jean-philippe.brucker@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180214145340.1223-1-jean-philippe.brucker@arm.com>
Sender: kvm-owner@vger.kernel.org
To: iommu@lists.linux-foundation.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-dev@lists.oasis-open.org, kvmarm@lists.cs.columbia.edu
Cc: joro@8bytes.org, alex.williamson@redhat.com, mst@redhat.com, jasowang@redhat.com, marc.zyngier@arm.com, robin.murphy@arm.com, will.deacon@arm.com, lorenzo.pieralisi@arm.com, eric.auger@redhat.com, eric.auger.pro@gmail.com, peterx@redhat.com, bharat.bhushan@nxp.com, tnowicki@caviumnetworks.com, jayachandran.nair@cavium.com, kevin.tian@intel.com, jintack@cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The virtio IOMMU is a para-virtualized device, allowing to send IOMMU
requests such as map/unmap over virtio-mmio transport without emulating
page tables. This implementation handles ATTACH, DETACH, MAP and UNMAP
requests.

The bulk of the code transforms calls coming from the IOMMU API into
corresponding virtio requests. Mappings are kept in an interval tree
instead of page tables.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 MAINTAINERS                       |   6 +
 drivers/iommu/Kconfig             |  11 +
 drivers/iommu/Makefile            |   1 +
 drivers/iommu/virtio-iommu.c      | 960 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/virtio_ids.h   |   1 +
 include/uapi/linux/virtio_iommu.h | 116 +++++
 6 files changed, 1095 insertions(+)
 create mode 100644 drivers/iommu/virtio-iommu.c
 create mode 100644 include/uapi/linux/virtio_iommu.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 3bdc260e36b7..2a181924d420 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14818,6 +14818,12 @@ S:	Maintained
 F:	drivers/virtio/virtio_input.c
 F:	include/uapi/linux/virtio_input.h
 
+VIRTIO IOMMU DRIVER
+M:	Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
+S:	Maintained
+F:	drivers/iommu/virtio-iommu.c
+F:	include/uapi/linux/virtio_iommu.h
+
 VIRTUAL BOX GUEST DEVICE DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
 M:	Arnd Bergmann <arnd@arndb.de>
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index f3a21343e636..1ea0ec74524f 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -381,4 +381,15 @@ config QCOM_IOMMU
 	help
 	  Support for IOMMU on certain Qualcomm SoCs.
 
+config VIRTIO_IOMMU
+	bool "Virtio IOMMU driver"
+	depends on VIRTIO_MMIO
+	select IOMMU_API
+	select INTERVAL_TREE
+	select ARM_DMA_USE_IOMMU if ARM
+	help
+	  Para-virtualised IOMMU driver with virtio.
+
+	  Say Y here if you intend to run this kernel as a guest.
+
 endif # IOMMU_SUPPORT
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 1fb695854809..9c68be1365e1 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -29,3 +29,4 @@ obj-$(CONFIG_EXYNOS_IOMMU) += exynos-iommu.o
 obj-$(CONFIG_FSL_PAMU) += fsl_pamu.o fsl_pamu_domain.o
 obj-$(CONFIG_S390_IOMMU) += s390-iommu.o
 obj-$(CONFIG_QCOM_IOMMU) += qcom_iommu.o
+obj-$(CONFIG_VIRTIO_IOMMU) += virtio-iommu.o
diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
new file mode 100644
index 000000000000..a9c9245e8ba2
--- /dev/null
+++ b/drivers/iommu/virtio-iommu.c
@@ -0,0 +1,960 @@
+/*
+ * Virtio driver for the paravirtualized IOMMU
+ *
+ * Copyright (C) 2018 ARM Limited
+ * Author: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
+ *
+ * SPDX-License-Identifier: GPL-2.0
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/amba/bus.h>
+#include <linux/delay.h>
+#include <linux/dma-iommu.h>
+#include <linux/freezer.h>
+#include <linux/interval_tree.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/of_iommu.h>
+#include <linux/of_platform.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+#include <linux/virtio.h>
+#include <linux/virtio_config.h>
+#include <linux/virtio_ids.h>
+#include <linux/wait.h>
+
+#include <uapi/linux/virtio_iommu.h>
+
+#define MSI_IOVA_BASE			0x8000000
+#define MSI_IOVA_LENGTH			0x100000
+
+struct viommu_dev {
+	struct iommu_device		iommu;
+	struct device			*dev;
+	struct virtio_device		*vdev;
+
+	struct ida			domain_ids;
+
+	struct virtqueue		*vq;
+	/* Serialize anything touching the request queue */
+	spinlock_t			request_lock;
+
+	/* Device configuration */
+	struct iommu_domain_geometry	geometry;
+	u64				pgsize_bitmap;
+	u8				domain_bits;
+};
+
+struct viommu_mapping {
+	phys_addr_t			paddr;
+	struct interval_tree_node	iova;
+	union {
+		struct virtio_iommu_req_map map;
+		struct virtio_iommu_req_unmap unmap;
+	} req;
+};
+
+struct viommu_domain {
+	struct iommu_domain		domain;
+	struct viommu_dev		*viommu;
+	struct mutex			mutex;
+	unsigned int			id;
+
+	spinlock_t			mappings_lock;
+	struct rb_root_cached		mappings;
+
+	/* Number of endpoints attached to this domain */
+	unsigned long			endpoints;
+};
+
+struct viommu_endpoint {
+	struct viommu_dev		*viommu;
+	struct viommu_domain		*vdomain;
+};
+
+struct viommu_request {
+	struct scatterlist		top;
+	struct scatterlist		bottom;
+
+	int				written;
+	struct list_head		list;
+};
+
+#define to_viommu_domain(domain)	\
+	container_of(domain, struct viommu_domain, domain)
+
+/* Virtio transport */
+
+static int viommu_status_to_errno(u8 status)
+{
+	switch (status) {
+	case VIRTIO_IOMMU_S_OK:
+		return 0;
+	case VIRTIO_IOMMU_S_UNSUPP:
+		return -ENOSYS;
+	case VIRTIO_IOMMU_S_INVAL:
+		return -EINVAL;
+	case VIRTIO_IOMMU_S_RANGE:
+		return -ERANGE;
+	case VIRTIO_IOMMU_S_NOENT:
+		return -ENOENT;
+	case VIRTIO_IOMMU_S_FAULT:
+		return -EFAULT;
+	case VIRTIO_IOMMU_S_IOERR:
+	case VIRTIO_IOMMU_S_DEVERR:
+	default:
+		return -EIO;
+	}
+}
+
+/*
+ * viommu_get_req_size - compute request size
+ *
+ * A virtio-iommu request is split into one device-read-only part (top) and one
+ * device-write-only part (bottom). Given a request, return the sizes of the two
+ * parts in @top and @bottom.
+ *
+ * Return 0 on success, or an error when the request seems invalid.
+ */
+static int viommu_get_req_size(struct viommu_dev *viommu,
+			       struct virtio_iommu_req_head *req, size_t *top,
+			       size_t *bottom)
+{
+	size_t size;
+	union virtio_iommu_req *r = (void *)req;
+
+	*bottom = sizeof(struct virtio_iommu_req_tail);
+
+	switch (req->type) {
+	case VIRTIO_IOMMU_T_ATTACH:
+		size = sizeof(r->attach);
+		break;
+	case VIRTIO_IOMMU_T_DETACH:
+		size = sizeof(r->detach);
+		break;
+	case VIRTIO_IOMMU_T_MAP:
+		size = sizeof(r->map);
+		break;
+	case VIRTIO_IOMMU_T_UNMAP:
+		size = sizeof(r->unmap);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*top = size - *bottom;
+	return 0;
+}
+
+static int viommu_receive_resp(struct viommu_dev *viommu, int nr_sent,
+			       struct list_head *sent)
+{
+
+	unsigned int len;
+	int nr_received = 0;
+	struct viommu_request *req, *pending;
+
+	pending = list_first_entry_or_null(sent, struct viommu_request, list);
+	if (WARN_ON(!pending))
+		return 0;
+
+	while ((req = virtqueue_get_buf(viommu->vq, &len)) != NULL) {
+		if (req != pending) {
+			dev_warn(viommu->dev, "discarding stale request\n");
+			continue;
+		}
+
+		pending->written = len;
+
+		if (++nr_received == nr_sent) {
+			WARN_ON(!list_is_last(&pending->list, sent));
+			break;
+		} else if (WARN_ON(list_is_last(&pending->list, sent))) {
+			break;
+		}
+
+		pending = list_next_entry(pending, list);
+	}
+
+	return nr_received;
+}
+
+static int _viommu_send_reqs_sync(struct viommu_dev *viommu,
+				  struct viommu_request *req, int nr,
+				  int *nr_sent)
+{
+	int i, ret;
+	ktime_t timeout;
+	LIST_HEAD(pending);
+	int nr_received = 0;
+	struct scatterlist *sg[2];
+	/*
+	 * The timeout is chosen arbitrarily. It's only here to prevent locking
+	 * up the CPU in case of a device bug.
+	 */
+	unsigned long timeout_ms = 1000;
+
+	*nr_sent = 0;
+
+	for (i = 0; i < nr; i++, req++) {
+		req->written = 0;
+
+		sg[0] = &req->top;
+		sg[1] = &req->bottom;
+
+		ret = virtqueue_add_sgs(viommu->vq, sg, 1, 1, req,
+					GFP_ATOMIC);
+		if (ret)
+			break;
+
+		list_add_tail(&req->list, &pending);
+	}
+
+	if (i && !virtqueue_kick(viommu->vq))
+		return -EPIPE;
+
+	timeout = ktime_add_ms(ktime_get(), timeout_ms * i);
+	while (nr_received < i && ktime_before(ktime_get(), timeout)) {
+		nr_received += viommu_receive_resp(viommu, i - nr_received,
+						   &pending);
+		if (nr_received < i)
+			cpu_relax();
+	}
+
+	if (nr_received != i)
+		ret = -ETIMEDOUT;
+
+	if (ret == -ENOSPC && nr_received)
+		/*
+		 * We've freed some space since virtio told us that the ring is
+		 * full, tell the caller to come back for more.
+		 */
+		ret = -EAGAIN;
+
+	*nr_sent = nr_received;
+
+	return ret;
+}
+
+/*
+ * viommu_send_reqs_sync - add a batch of requests, kick the host and wait for
+ *                         them to return
+ *
+ * @req: array of requests
+ * @nr: array length
+ * @nr_sent: on return, contains the number of requests actually sent
+ *
+ * Return 0 on success, or an error if we failed to send some of the requests.
+ */
+static int viommu_send_reqs_sync(struct viommu_dev *viommu,
+				 struct viommu_request *req, int nr,
+				 int *nr_sent)
+{
+	int ret;
+	int sent = 0;
+	unsigned long flags;
+
+	*nr_sent = 0;
+	do {
+		spin_lock_irqsave(&viommu->request_lock, flags);
+		ret = _viommu_send_reqs_sync(viommu, req, nr, &sent);
+		spin_unlock_irqrestore(&viommu->request_lock, flags);
+
+		*nr_sent += sent;
+		req += sent;
+		nr -= sent;
+	} while (ret == -EAGAIN);
+
+	return ret;
+}
+
+/*
+ * viommu_send_req_sync - send one request and wait for reply
+ *
+ * @top: pointer to a virtio_iommu_req_* structure
+ *
+ * Returns 0 if the request was successful, or an error number otherwise. No
+ * distinction is done between transport and request errors.
+ */
+static int viommu_send_req_sync(struct viommu_dev *viommu, void *top)
+{
+	int ret;
+	int nr_sent;
+	void *bottom;
+	size_t top_size, bottom_size;
+	struct virtio_iommu_req_tail *tail;
+	struct virtio_iommu_req_head *head = top;
+	struct viommu_request req = {
+		.written = 0
+	};
+
+	ret = viommu_get_req_size(viommu, head, &top_size, &bottom_size);
+	if (ret)
+		return ret;
+
+	bottom = top + top_size;
+	tail = bottom + bottom_size - sizeof(*tail);
+
+	sg_init_one(&req.top, top, top_size);
+	sg_init_one(&req.bottom, bottom, bottom_size);
+
+	ret = viommu_send_reqs_sync(viommu, &req, 1, &nr_sent);
+	if (ret || !req.written || nr_sent != 1) {
+		dev_err(viommu->dev, "failed to send request\n");
+		return -EIO;
+	}
+
+	return viommu_status_to_errno(tail->status);
+}
+
+/*
+ * viommu_add_mapping - add a mapping to the internal tree
+ *
+ * On success, return the new mapping. Otherwise return NULL.
+ */
+static struct viommu_mapping *
+viommu_add_mapping(struct viommu_domain *vdomain, unsigned long iova,
+		   phys_addr_t paddr, size_t size)
+{
+	unsigned long flags;
+	struct viommu_mapping *mapping;
+
+	mapping = kzalloc(sizeof(*mapping), GFP_ATOMIC);
+	if (!mapping)
+		return NULL;
+
+	mapping->paddr		= paddr;
+	mapping->iova.start	= iova;
+	mapping->iova.last	= iova + size - 1;
+
+	spin_lock_irqsave(&vdomain->mappings_lock, flags);
+	interval_tree_insert(&mapping->iova, &vdomain->mappings);
+	spin_unlock_irqrestore(&vdomain->mappings_lock, flags);
+
+	return mapping;
+}
+
+/*
+ * viommu_del_mappings - remove mappings from the internal tree
+ *
+ * @vdomain: the domain
+ * @iova: start of the range
+ * @size: size of the range. A size of 0 corresponds to the entire address
+ *	space.
+ * @out_mapping: if not NULL, the first removed mapping is returned in there.
+ *	This allows the caller to reuse the buffer for the unmap request. When
+ *	the returned size is greater than zero, if a mapping is returned, the
+ *	caller must free it.
+ *
+ * On success, returns the number of unmapped bytes (>= size)
+ */
+static size_t viommu_del_mappings(struct viommu_domain *vdomain,
+				 unsigned long iova, size_t size,
+				 struct viommu_mapping **out_mapping)
+{
+	size_t unmapped = 0;
+	unsigned long flags;
+	unsigned long last = iova + size - 1;
+	struct viommu_mapping *mapping = NULL;
+	struct interval_tree_node *node, *next;
+
+	spin_lock_irqsave(&vdomain->mappings_lock, flags);
+	next = interval_tree_iter_first(&vdomain->mappings, iova, last);
+
+	if (next) {
+		mapping = container_of(next, struct viommu_mapping, iova);
+		/* Trying to split a mapping? */
+		if (WARN_ON(mapping->iova.start < iova))
+			next = NULL;
+	}
+
+	while (next) {
+		node = next;
+		mapping = container_of(node, struct viommu_mapping, iova);
+
+		next = interval_tree_iter_next(node, iova, last);
+
+		/*
+		 * Note that for a partial range, this will return the full
+		 * mapping so we avoid sending split requests to the device.
+		 */
+		unmapped += mapping->iova.last - mapping->iova.start + 1;
+
+		interval_tree_remove(node, &vdomain->mappings);
+
+		if (out_mapping && !(*out_mapping))
+			*out_mapping = mapping;
+		else
+			kfree(mapping);
+	}
+	spin_unlock_irqrestore(&vdomain->mappings_lock, flags);
+
+	return unmapped;
+}
+
+/*
+ * viommu_replay_mappings - re-send MAP requests
+ *
+ * When reattaching a domain that was previously detached from all endpoints,
+ * mappings were deleted from the device. Re-create the mappings available in
+ * the internal tree.
+ */
+static int viommu_replay_mappings(struct viommu_domain *vdomain)
+{
+	unsigned long flags;
+	int i = 1, ret, nr_sent;
+	struct viommu_request *reqs;
+	struct viommu_mapping *mapping;
+	struct interval_tree_node *node;
+	size_t top_size, bottom_size;
+
+	spin_lock_irqsave(&vdomain->mappings_lock, flags);
+	node = interval_tree_iter_first(&vdomain->mappings, 0, -1UL);
+	if (!node) {
+		spin_unlock_irqrestore(&vdomain->mappings_lock, flags);
+		return 0;
+	}
+
+	while ((node = interval_tree_iter_next(node, 0, -1UL)) != NULL)
+		i++;
+	spin_unlock_irqrestore(&vdomain->mappings_lock, flags);
+
+	reqs = kcalloc(i, sizeof(*reqs), GFP_KERNEL);
+	if (!reqs)
+		return -ENOMEM;
+
+	bottom_size = sizeof(struct virtio_iommu_req_tail);
+	top_size = sizeof(struct virtio_iommu_req_map) - bottom_size;
+
+	i = 0;
+	spin_lock_irqsave(&vdomain->mappings_lock, flags);
+	node = interval_tree_iter_first(&vdomain->mappings, 0, -1UL);
+	while (node) {
+		mapping = container_of(node, struct viommu_mapping, iova);
+		sg_init_one(&reqs[i].top, &mapping->req.map, top_size);
+		sg_init_one(&reqs[i].bottom, &mapping->req.map.tail,
+			    bottom_size);
+
+		node = interval_tree_iter_next(node, 0, -1UL);
+		i++;
+	}
+	spin_unlock_irqrestore(&vdomain->mappings_lock, flags);
+
+	ret = viommu_send_reqs_sync(vdomain->viommu, reqs, i, &nr_sent);
+	kfree(reqs);
+
+	return ret;
+}
+
+/* IOMMU API */
+
+static bool viommu_capable(enum iommu_cap cap)
+{
+	return false;
+}
+
+static struct iommu_domain *viommu_domain_alloc(unsigned type)
+{
+	struct viommu_domain *vdomain;
+
+	if (type != IOMMU_DOMAIN_UNMANAGED && type != IOMMU_DOMAIN_DMA)
+		return NULL;
+
+	vdomain = kzalloc(sizeof(*vdomain), GFP_KERNEL);
+	if (!vdomain)
+		return NULL;
+
+	mutex_init(&vdomain->mutex);
+	spin_lock_init(&vdomain->mappings_lock);
+	vdomain->mappings = RB_ROOT_CACHED;
+
+	if (type == IOMMU_DOMAIN_DMA &&
+	    iommu_get_dma_cookie(&vdomain->domain)) {
+		kfree(vdomain);
+		return NULL;
+	}
+
+	return &vdomain->domain;
+}
+
+static int viommu_domain_finalise(struct viommu_dev *viommu,
+				  struct iommu_domain *domain)
+{
+	int ret;
+	struct viommu_domain *vdomain = to_viommu_domain(domain);
+	/* ida limits size to 31 bits. A value of 0 means "max" */
+	unsigned int max_domain = viommu->domain_bits >= 31 ? 0 :
+				  1U << viommu->domain_bits;
+
+	vdomain->viommu		= viommu;
+
+	domain->pgsize_bitmap	= viommu->pgsize_bitmap;
+	domain->geometry	= viommu->geometry;
+
+	ret = ida_simple_get(&viommu->domain_ids, 0, max_domain, GFP_KERNEL);
+	if (ret >= 0)
+		vdomain->id = (unsigned int)ret;
+
+	return ret > 0 ? 0 : ret;
+}
+
+static void viommu_domain_free(struct iommu_domain *domain)
+{
+	struct viommu_domain *vdomain = to_viommu_domain(domain);
+
+	iommu_put_dma_cookie(domain);
+
+	/* Free all remaining mappings (size 2^64) */
+	viommu_del_mappings(vdomain, 0, 0, NULL);
+
+	if (vdomain->viommu)
+		ida_simple_remove(&vdomain->viommu->domain_ids, vdomain->id);
+
+	kfree(vdomain);
+}
+
+static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
+{
+	int i;
+	int ret = 0;
+	struct virtio_iommu_req_attach *req;
+	struct iommu_fwspec *fwspec = dev->iommu_fwspec;
+	struct viommu_endpoint *vdev = fwspec->iommu_priv;
+	struct viommu_domain *vdomain = to_viommu_domain(domain);
+
+	mutex_lock(&vdomain->mutex);
+	if (!vdomain->viommu) {
+		/*
+		 * Initialize the domain proper now that we know which viommu
+		 * owns it.
+		 */
+		ret = viommu_domain_finalise(vdev->viommu, domain);
+	} else if (vdomain->viommu != vdev->viommu) {
+		dev_err(dev, "cannot attach to foreign vIOMMU\n");
+		ret = -EXDEV;
+	}
+	mutex_unlock(&vdomain->mutex);
+
+	if (ret)
+		return ret;
+
+	/*
+	 * In the virtio-iommu device, when attaching the endpoint to a new
+	 * domain, it is detached from the old one and, if as as a result the
+	 * old domain isn't attached to any endpoint, all mappings are removed
+	 * from the old domain and it is freed.
+	 *
+	 * In the driver the old domain still exists, and its mappings will be
+	 * recreated if it gets reattached to an endpoint. Otherwise it will be
+	 * freed explicitly.
+	 *
+	 * vdev->vdomain is protected by group->mutex
+	 */
+	if (vdev->vdomain)
+		vdev->vdomain->endpoints--;
+
+	/* DMA to the stack is forbidden, store request on the heap */
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	*req = (struct virtio_iommu_req_attach) {
+		.head.type	= VIRTIO_IOMMU_T_ATTACH,
+		.domain		= cpu_to_le32(vdomain->id),
+	};
+
+	for (i = 0; i < fwspec->num_ids; i++) {
+		req->endpoint = cpu_to_le32(fwspec->ids[i]);
+
+		ret = viommu_send_req_sync(vdomain->viommu, req);
+		if (ret)
+			break;
+	}
+
+	kfree(req);
+
+	if (ret)
+		return ret;
+
+	if (!vdomain->endpoints) {
+		/*
+		 * This endpoint is the first to be attached to the domain.
+		 * Replay existing mappings if any (e.g. SW MSI).
+		 */
+		ret = viommu_replay_mappings(vdomain);
+		if (ret)
+			return ret;
+	}
+
+	vdomain->endpoints++;
+	vdev->vdomain = vdomain;
+
+	return 0;
+}
+
+static int viommu_map(struct iommu_domain *domain, unsigned long iova,
+		      phys_addr_t paddr, size_t size, int prot)
+{
+	int ret;
+	int flags;
+	struct viommu_mapping *mapping;
+	struct viommu_domain *vdomain = to_viommu_domain(domain);
+
+	mapping = viommu_add_mapping(vdomain, iova, paddr, size);
+	if (!mapping)
+		return -ENOMEM;
+
+	flags = (prot & IOMMU_READ ? VIRTIO_IOMMU_MAP_F_READ : 0) |
+		(prot & IOMMU_WRITE ? VIRTIO_IOMMU_MAP_F_WRITE : 0);
+
+	mapping->req.map = (struct virtio_iommu_req_map) {
+		.head.type	= VIRTIO_IOMMU_T_MAP,
+		.domain		= cpu_to_le32(vdomain->id),
+		.virt_start	= cpu_to_le64(iova),
+		.phys_start	= cpu_to_le64(paddr),
+		.virt_end	= cpu_to_le64(iova + size - 1),
+		.flags		= cpu_to_le32(flags),
+	};
+
+	if (!vdomain->endpoints)
+		return 0;
+
+	ret = viommu_send_req_sync(vdomain->viommu, &mapping->req);
+	if (ret)
+		viommu_del_mappings(vdomain, iova, size, NULL);
+
+	return ret;
+}
+
+static size_t viommu_unmap(struct iommu_domain *domain, unsigned long iova,
+			   size_t size)
+{
+	int ret = 0;
+	size_t unmapped;
+	struct viommu_mapping *mapping = NULL;
+	struct viommu_domain *vdomain = to_viommu_domain(domain);
+
+	unmapped = viommu_del_mappings(vdomain, iova, size, &mapping);
+	if (unmapped < size) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	/* Device already removed all mappings after detach. */
+	if (!vdomain->endpoints)
+		goto out_free;
+
+	if (WARN_ON(!mapping))
+		return 0;
+
+	mapping->req.unmap = (struct virtio_iommu_req_unmap) {
+		.head.type	= VIRTIO_IOMMU_T_UNMAP,
+		.domain		= cpu_to_le32(vdomain->id),
+		.virt_start	= cpu_to_le64(iova),
+		.virt_end	= cpu_to_le64(iova + unmapped - 1),
+	};
+
+	ret = viommu_send_req_sync(vdomain->viommu, &mapping->req);
+
+out_free:
+	kfree(mapping);
+
+	return ret ? 0 : unmapped;
+}
+
+static phys_addr_t viommu_iova_to_phys(struct iommu_domain *domain,
+				       dma_addr_t iova)
+{
+	u64 paddr = 0;
+	unsigned long flags;
+	struct viommu_mapping *mapping;
+	struct interval_tree_node *node;
+	struct viommu_domain *vdomain = to_viommu_domain(domain);
+
+	spin_lock_irqsave(&vdomain->mappings_lock, flags);
+	node = interval_tree_iter_first(&vdomain->mappings, iova, iova);
+	if (node) {
+		mapping = container_of(node, struct viommu_mapping, iova);
+		paddr = mapping->paddr + (iova - mapping->iova.start);
+	}
+	spin_unlock_irqrestore(&vdomain->mappings_lock, flags);
+
+	return paddr;
+}
+
+static struct iommu_ops viommu_ops;
+static struct virtio_driver virtio_iommu_drv;
+
+static int viommu_match_node(struct device *dev, void *data)
+{
+	return dev->parent->fwnode == data;
+}
+
+static struct viommu_dev *viommu_get_by_fwnode(struct fwnode_handle *fwnode)
+{
+	struct device *dev = driver_find_device(&virtio_iommu_drv.driver, NULL,
+						fwnode, viommu_match_node);
+	put_device(dev);
+
+	return dev ? dev_to_virtio(dev)->priv : NULL;
+}
+
+static int viommu_add_device(struct device *dev)
+{
+	struct iommu_group *group;
+	struct viommu_endpoint *vdev;
+	struct viommu_dev *viommu = NULL;
+	struct iommu_fwspec *fwspec = dev->iommu_fwspec;
+
+	if (!fwspec || fwspec->ops != &viommu_ops)
+		return -ENODEV;
+
+	viommu = viommu_get_by_fwnode(fwspec->iommu_fwnode);
+	if (!viommu)
+		return -ENODEV;
+
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev)
+		return -ENOMEM;
+
+	vdev->viommu = viommu;
+	fwspec->iommu_priv = vdev;
+
+	/*
+	 * Last step creates a default domain and attaches to it. Everything
+	 * must be ready.
+	 */
+	group = iommu_group_get_for_dev(dev);
+	if (!IS_ERR(group))
+		iommu_group_put(group);
+
+	return PTR_ERR_OR_ZERO(group);
+}
+
+static void viommu_remove_device(struct device *dev)
+{
+	kfree(dev->iommu_fwspec->iommu_priv);
+}
+
+static struct iommu_group *viommu_device_group(struct device *dev)
+{
+	if (dev_is_pci(dev))
+		return pci_device_group(dev);
+	else
+		return generic_device_group(dev);
+}
+
+static int viommu_of_xlate(struct device *dev, struct of_phandle_args *args)
+{
+	return iommu_fwspec_add_ids(dev, args->args, 1);
+}
+
+static void viommu_get_resv_regions(struct device *dev, struct list_head *head)
+{
+	struct iommu_resv_region *region;
+	int prot = IOMMU_WRITE | IOMMU_NOEXEC | IOMMU_MMIO;
+
+	region = iommu_alloc_resv_region(MSI_IOVA_BASE, MSI_IOVA_LENGTH, prot,
+					 IOMMU_RESV_SW_MSI);
+	if (!region)
+		return;
+
+	list_add_tail(&region->list, head);
+	iommu_dma_get_resv_regions(dev, head);
+}
+
+static void viommu_put_resv_regions(struct device *dev, struct list_head *head)
+{
+	struct iommu_resv_region *entry, *next;
+
+	list_for_each_entry_safe(entry, next, head, list)
+		kfree(entry);
+}
+
+static struct iommu_ops viommu_ops = {
+	.capable		= viommu_capable,
+	.domain_alloc		= viommu_domain_alloc,
+	.domain_free		= viommu_domain_free,
+	.attach_dev		= viommu_attach_dev,
+	.map			= viommu_map,
+	.unmap			= viommu_unmap,
+	.map_sg			= default_iommu_map_sg,
+	.iova_to_phys		= viommu_iova_to_phys,
+	.add_device		= viommu_add_device,
+	.remove_device		= viommu_remove_device,
+	.device_group		= viommu_device_group,
+	.of_xlate		= viommu_of_xlate,
+	.get_resv_regions	= viommu_get_resv_regions,
+	.put_resv_regions	= viommu_put_resv_regions,
+};
+
+static int viommu_init_vq(struct viommu_dev *viommu)
+{
+	struct virtio_device *vdev = dev_to_virtio(viommu->dev);
+	const char *name = "request";
+	void *ret;
+
+	ret = virtio_find_single_vq(vdev, NULL, name);
+	if (IS_ERR(ret)) {
+		dev_err(viommu->dev, "cannot find VQ\n");
+		return PTR_ERR(ret);
+	}
+
+	viommu->vq = ret;
+
+	return 0;
+}
+
+static int viommu_probe(struct virtio_device *vdev)
+{
+	struct device *parent_dev = vdev->dev.parent;
+	struct viommu_dev *viommu = NULL;
+	struct device *dev = &vdev->dev;
+	u64 input_start = 0;
+	u64 input_end = -1UL;
+	int ret;
+
+	viommu = devm_kzalloc(dev, sizeof(*viommu), GFP_KERNEL);
+	if (!viommu)
+		return -ENOMEM;
+
+	spin_lock_init(&viommu->request_lock);
+	ida_init(&viommu->domain_ids);
+	viommu->dev = dev;
+	viommu->vdev = vdev;
+
+	ret = viommu_init_vq(viommu);
+	if (ret)
+		return ret;
+
+	virtio_cread(vdev, struct virtio_iommu_config, page_size_mask,
+		     &viommu->pgsize_bitmap);
+
+	if (!viommu->pgsize_bitmap) {
+		ret = -EINVAL;
+		goto err_free_vqs;
+	}
+
+	viommu->domain_bits = 32;
+
+	/* Optional features */
+	virtio_cread_feature(vdev, VIRTIO_IOMMU_F_INPUT_RANGE,
+			     struct virtio_iommu_config, input_range.start,
+			     &input_start);
+
+	virtio_cread_feature(vdev, VIRTIO_IOMMU_F_INPUT_RANGE,
+			     struct virtio_iommu_config, input_range.end,
+			     &input_end);
+
+	virtio_cread_feature(vdev, VIRTIO_IOMMU_F_DOMAIN_BITS,
+			     struct virtio_iommu_config, domain_bits,
+			     &viommu->domain_bits);
+
+	viommu->geometry = (struct iommu_domain_geometry) {
+		.aperture_start	= input_start,
+		.aperture_end	= input_end,
+		.force_aperture	= true,
+	};
+
+	viommu_ops.pgsize_bitmap = viommu->pgsize_bitmap;
+
+	virtio_device_ready(vdev);
+
+	ret = iommu_device_sysfs_add(&viommu->iommu, dev, NULL, "%s",
+				     virtio_bus_name(vdev));
+	if (ret)
+		goto err_free_vqs;
+
+	iommu_device_set_ops(&viommu->iommu, &viommu_ops);
+	iommu_device_set_fwnode(&viommu->iommu, parent_dev->fwnode);
+
+	iommu_device_register(&viommu->iommu);
+
+#ifdef CONFIG_PCI
+	if (pci_bus_type.iommu_ops != &viommu_ops) {
+		pci_request_acs();
+		ret = bus_set_iommu(&pci_bus_type, &viommu_ops);
+		if (ret)
+			goto err_unregister;
+	}
+#endif
+#ifdef CONFIG_ARM_AMBA
+	if (amba_bustype.iommu_ops != &viommu_ops) {
+		ret = bus_set_iommu(&amba_bustype, &viommu_ops);
+		if (ret)
+			goto err_unregister;
+	}
+#endif
+	if (platform_bus_type.iommu_ops != &viommu_ops) {
+		ret = bus_set_iommu(&platform_bus_type, &viommu_ops);
+		if (ret)
+			goto err_unregister;
+	}
+
+	vdev->priv = viommu;
+
+	dev_info(dev, "input address: %u bits\n",
+		 order_base_2(viommu->geometry.aperture_end));
+	dev_info(dev, "page mask: %#llx\n", viommu->pgsize_bitmap);
+
+	return 0;
+
+err_unregister:
+	iommu_device_sysfs_remove(&viommu->iommu);
+	iommu_device_unregister(&viommu->iommu);
+err_free_vqs:
+	vdev->config->del_vqs(vdev);
+
+	return ret;
+}
+
+static void viommu_remove(struct virtio_device *vdev)
+{
+	struct viommu_dev *viommu = vdev->priv;
+
+	iommu_device_sysfs_remove(&viommu->iommu);
+	iommu_device_unregister(&viommu->iommu);
+
+	/* Stop all virtqueues */
+	vdev->config->reset(vdev);
+	vdev->config->del_vqs(vdev);
+
+	dev_info(&vdev->dev, "device removed\n");
+}
+
+static void viommu_config_changed(struct virtio_device *vdev)
+{
+	dev_warn(&vdev->dev, "config changed\n");
+}
+
+static unsigned int features[] = {
+	VIRTIO_IOMMU_F_MAP_UNMAP,
+	VIRTIO_IOMMU_F_DOMAIN_BITS,
+	VIRTIO_IOMMU_F_INPUT_RANGE,
+};
+
+static struct virtio_device_id id_table[] = {
+	{ VIRTIO_ID_IOMMU, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+static struct virtio_driver virtio_iommu_drv = {
+	.driver.name		= KBUILD_MODNAME,
+	.driver.owner		= THIS_MODULE,
+	.id_table		= id_table,
+	.feature_table		= features,
+	.feature_table_size	= ARRAY_SIZE(features),
+	.probe			= viommu_probe,
+	.remove			= viommu_remove,
+	.config_changed		= viommu_config_changed,
+};
+
+module_virtio_driver(virtio_iommu_drv);
+
+IOMMU_OF_DECLARE(viommu, "virtio,mmio");
+
+MODULE_DESCRIPTION("Virtio IOMMU driver");
+MODULE_AUTHOR("Jean-Philippe Brucker <jean-philippe.brucker@arm.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_ids.h
index 6d5c3b2d4f4d..cfe47c5d9a56 100644
--- a/include/uapi/linux/virtio_ids.h
+++ b/include/uapi/linux/virtio_ids.h
@@ -43,5 +43,6 @@
 #define VIRTIO_ID_INPUT        18 /* virtio input */
 #define VIRTIO_ID_VSOCK        19 /* virtio vsock transport */
 #define VIRTIO_ID_CRYPTO       20 /* virtio crypto */
+#define VIRTIO_ID_IOMMU        23 /* virtio IOMMU */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
diff --git a/include/uapi/linux/virtio_iommu.h b/include/uapi/linux/virtio_iommu.h
new file mode 100644
index 000000000000..0de9b44db14d
--- /dev/null
+++ b/include/uapi/linux/virtio_iommu.h
@@ -0,0 +1,116 @@
+/*
+ * Virtio-iommu definition v0.6
+ *
+ * Copyright (C) 2018 ARM Ltd.
+ *
+ * SPDX-License-Identifier: BSD-3-Clause
+ */
+#ifndef _UAPI_LINUX_VIRTIO_IOMMU_H
+#define _UAPI_LINUX_VIRTIO_IOMMU_H
+
+#include <linux/types.h>
+
+/* Feature bits */
+#define VIRTIO_IOMMU_F_INPUT_RANGE		0
+#define VIRTIO_IOMMU_F_DOMAIN_BITS		1
+#define VIRTIO_IOMMU_F_MAP_UNMAP		2
+#define VIRTIO_IOMMU_F_BYPASS			3
+
+struct virtio_iommu_config {
+	/* Supported page sizes */
+	__u64					page_size_mask;
+	/* Supported IOVA range */
+	struct virtio_iommu_range {
+		__u64				start;
+		__u64				end;
+	} input_range;
+	/* Max domain ID size */
+	__u8					domain_bits;
+} __packed;
+
+/* Request types */
+#define VIRTIO_IOMMU_T_ATTACH			0x01
+#define VIRTIO_IOMMU_T_DETACH			0x02
+#define VIRTIO_IOMMU_T_MAP			0x03
+#define VIRTIO_IOMMU_T_UNMAP			0x04
+
+/* Status types */
+#define VIRTIO_IOMMU_S_OK			0x00
+#define VIRTIO_IOMMU_S_IOERR			0x01
+#define VIRTIO_IOMMU_S_UNSUPP			0x02
+#define VIRTIO_IOMMU_S_DEVERR			0x03
+#define VIRTIO_IOMMU_S_INVAL			0x04
+#define VIRTIO_IOMMU_S_RANGE			0x05
+#define VIRTIO_IOMMU_S_NOENT			0x06
+#define VIRTIO_IOMMU_S_FAULT			0x07
+
+struct virtio_iommu_req_head {
+	__u8					type;
+	__u8					reserved[3];
+} __packed;
+
+struct virtio_iommu_req_tail {
+	__u8					status;
+	__u8					reserved[3];
+} __packed;
+
+struct virtio_iommu_req_attach {
+	struct virtio_iommu_req_head		head;
+
+	__le32					domain;
+	__le32					endpoint;
+	__le32					reserved;
+
+	struct virtio_iommu_req_tail		tail;
+} __packed;
+
+struct virtio_iommu_req_detach {
+	struct virtio_iommu_req_head		head;
+
+	__le32					endpoint;
+	__le32					reserved;
+
+	struct virtio_iommu_req_tail		tail;
+} __packed;
+
+#define VIRTIO_IOMMU_MAP_F_READ			(1 << 0)
+#define VIRTIO_IOMMU_MAP_F_WRITE		(1 << 1)
+#define VIRTIO_IOMMU_MAP_F_EXEC			(1 << 2)
+
+#define VIRTIO_IOMMU_MAP_F_MASK			(VIRTIO_IOMMU_MAP_F_READ |	\
+						 VIRTIO_IOMMU_MAP_F_WRITE |	\
+						 VIRTIO_IOMMU_MAP_F_EXEC)
+
+struct virtio_iommu_req_map {
+	struct virtio_iommu_req_head		head;
+
+	__le32					domain;
+	__le64					virt_start;
+	__le64					virt_end;
+	__le64					phys_start;
+	__le32					flags;
+
+	struct virtio_iommu_req_tail		tail;
+} __packed;
+
+struct virtio_iommu_req_unmap {
+	struct virtio_iommu_req_head		head;
+
+	__le32					domain;
+	__le64					virt_start;
+	__le64					virt_end;
+	__le32					reserved;
+
+	struct virtio_iommu_req_tail		tail;
+} __packed;
+
+union virtio_iommu_req {
+	struct virtio_iommu_req_head		head;
+
+	struct virtio_iommu_req_attach		attach;
+	struct virtio_iommu_req_detach		detach;
+	struct virtio_iommu_req_map		map;
+	struct virtio_iommu_req_unmap		unmap;
+};
+
+#endif
-- 
2.16.1
