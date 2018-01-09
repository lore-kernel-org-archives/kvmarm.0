From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v1 01/16] virtio: Validate queue pfn for 32bit transports
Date: Tue,  9 Jan 2018 19:03:56 +0000
Message-ID: <20180109190414.4017-2-suzuki.poulose@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180109190414.4017-1-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, peter.maydell@linaro.org, suzuki.poulose@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

virtio-mmio using virtio-v1 and virtio legacy pci use a 32bit PFN
for the queue. If the queue pfn is too large to fit in 32bits, which
we could hit on arm64 systems with 52bit physical addresses (even with
64K page size), we simply miss out a proper link to the other side of
the queue.

Add a check to validate the PFN, rather than silently breaking
the devices.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 drivers/virtio/virtio_mmio.c       | 19 ++++++++++++++++---
 drivers/virtio/virtio_pci_legacy.c | 11 +++++++++--
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index a9192fe4f345..47109baf37f7 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -358,6 +358,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned index,
 	struct virtqueue *vq;
 	unsigned long flags;
 	unsigned int num;
+	u64 addr;
 	int err;
 
 	if (!name)
@@ -394,16 +395,26 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned index,
 		goto error_new_virtqueue;
 	}
 
+	addr = virtqueue_get_desc_addr(vq);
+	/*
+	 * virtio-mmio v1 uses a 32bit QUEUE PFN. If we have something that
+	 * doesn't fit in 32bit, fail the setup rather than pretending to
+	 * be successful.
+	 */
+	if (vm_dev->version == 1 && (addr >> (PAGE_SHIFT + 32))) {
+		dev_err(&vdev->dev, "virtio-mmio: queue address too large\n");
+		err = -ENOMEM;
+		goto error_bad_pfn;
+	}
+
 	/* Activate the queue */
 	writel(virtqueue_get_vring_size(vq), vm_dev->base + VIRTIO_MMIO_QUEUE_NUM);
 	if (vm_dev->version == 1) {
 		writel(PAGE_SIZE, vm_dev->base + VIRTIO_MMIO_QUEUE_ALIGN);
-		writel(virtqueue_get_desc_addr(vq) >> PAGE_SHIFT,
+		writel(addr >> PAGE_SHIFT,
 				vm_dev->base + VIRTIO_MMIO_QUEUE_PFN);
 	} else {
-		u64 addr;
 
-		addr = virtqueue_get_desc_addr(vq);
 		writel((u32)addr, vm_dev->base + VIRTIO_MMIO_QUEUE_DESC_LOW);
 		writel((u32)(addr >> 32),
 				vm_dev->base + VIRTIO_MMIO_QUEUE_DESC_HIGH);
@@ -430,6 +441,8 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned index,
 
 	return vq;
 
+error_bad_pfn:
+	vring_del_virtqueue(vq);
 error_new_virtqueue:
 	if (vm_dev->version == 1) {
 		writel(0, vm_dev->base + VIRTIO_MMIO_QUEUE_PFN);
diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index 2780886e8ba3..099d2cfb47b3 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -122,6 +122,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	struct virtqueue *vq;
 	u16 num;
 	int err;
+	u64 q_pfn;
 
 	/* Select the queue we're interested in */
 	iowrite16(index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
@@ -141,9 +142,15 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	if (!vq)
 		return ERR_PTR(-ENOMEM);
 
+	q_pfn = virtqueue_get_desc_addr(vq) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT;
+	if (q_pfn >> 32) {
+		dev_err(&vp_dev->pci_dev->dev, "virtio-pci queue PFN too large\n");
+		err = -ENOMEM;
+		goto out_deactivate;
+	}
+
 	/* activate the queue */
-	iowrite32(virtqueue_get_desc_addr(vq) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT,
-		  vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
+	iowrite32((u32)q_pfn, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
 
 	vq->priv = (void __force *)vp_dev->ioaddr + VIRTIO_PCI_QUEUE_NOTIFY;
 
-- 
2.13.6
