From: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: [PATCH v14 16/20] vfio: add local lock for virqfd instead of
	depending on VFIO PCI
Date: Mon,  2 Mar 2015 17:59:56 +0100
Message-ID: <1425315600-29761-17-git-send-email-b.reynal@virtualopensystems.com>
References: <1425315600-29761-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1425315600-29761-1-git-send-email-b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org
Cc: "open list:VFIO DRIVER" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Gavin Shan <gwshan-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>

The Virqfd code needs to keep accesses to any struct *virqfd safe, but
this comes into play only when creating or destroying eventfds, so sharing
the same spinlock with the VFIO bus driver is not necessary.

Signed-off-by: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Signed-off-by: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index d96ffe0..7d3c135 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -44,6 +44,7 @@ struct virqfd {
 };
 
 static struct workqueue_struct *vfio_irqfd_cleanup_wq;
+DEFINE_SPINLOCK(virqfd_lock);
 
 int __init vfio_virqfd_init(void)
 {
@@ -80,21 +81,21 @@ static int virqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 
 	if (flags & POLLHUP) {
 		unsigned long flags;
-		spin_lock_irqsave(&virqfd->vdev->irqlock, flags);
+		spin_lock_irqsave(&virqfd_lock, flags);
 
 		/*
 		 * The eventfd is closing, if the virqfd has not yet been
 		 * queued for release, as determined by testing whether the
-		 * vdev pointer to it is still valid, queue it now.  As
+		 * virqfd pointer to it is still valid, queue it now.  As
 		 * with kvm irqfds, we know we won't race against the virqfd
-		 * going away because we hold wqh->lock to get here.
+		 * going away because we hold the lock to get here.
 		 */
 		if (*(virqfd->pvirqfd) == virqfd) {
 			*(virqfd->pvirqfd) = NULL;
 			virqfd_deactivate(virqfd);
 		}
 
-		spin_unlock_irqrestore(&virqfd->vdev->irqlock, flags);
+		spin_unlock_irqrestore(&virqfd_lock, flags);
 	}
 
 	return 0;
@@ -170,16 +171,16 @@ int vfio_virqfd_enable(struct vfio_pci_device *vdev,
 	 * we update the pointer to the virqfd under lock to avoid
 	 * pushing multiple jobs to release the same virqfd.
 	 */
-	spin_lock_irq(&vdev->irqlock);
+	spin_lock_irq(&virqfd_lock);
 
 	if (*pvirqfd) {
-		spin_unlock_irq(&vdev->irqlock);
+		spin_unlock_irq(&virqfd_lock);
 		ret = -EBUSY;
 		goto err_busy;
 	}
 	*pvirqfd = virqfd;
 
-	spin_unlock_irq(&vdev->irqlock);
+	spin_unlock_irq(&virqfd_lock);
 
 	/*
 	 * Install our own custom wake-up handling so we are notified via
@@ -217,18 +218,18 @@ err_fd:
 }
 EXPORT_SYMBOL_GPL(vfio_virqfd_enable);
 
-void vfio_virqfd_disable(struct vfio_pci_device *vdev, struct virqfd **pvirqfd)
+void vfio_virqfd_disable(struct virqfd **pvirqfd)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&vdev->irqlock, flags);
+	spin_lock_irqsave(&virqfd_lock, flags);
 
 	if (*pvirqfd) {
 		virqfd_deactivate(*pvirqfd);
 		*pvirqfd = NULL;
 	}
 
-	spin_unlock_irqrestore(&vdev->irqlock, flags);
+	spin_unlock_irqrestore(&virqfd_lock, flags);
 
 	/*
 	 * Block until we know all outstanding shutdown jobs have completed.
@@ -441,8 +442,8 @@ static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
 static void vfio_intx_disable(struct vfio_pci_device *vdev)
 {
 	vfio_intx_set_signal(vdev, -1);
-	vfio_virqfd_disable(vdev, &vdev->ctx[0].unmask);
-	vfio_virqfd_disable(vdev, &vdev->ctx[0].mask);
+	vfio_virqfd_disable(&vdev->ctx[0].unmask);
+	vfio_virqfd_disable(&vdev->ctx[0].mask);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	vdev->num_ctx = 0;
 	kfree(vdev->ctx);
@@ -606,8 +607,8 @@ static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
 	vfio_msi_set_block(vdev, 0, vdev->num_ctx, NULL, msix);
 
 	for (i = 0; i < vdev->num_ctx; i++) {
-		vfio_virqfd_disable(vdev, &vdev->ctx[i].unmask);
-		vfio_virqfd_disable(vdev, &vdev->ctx[i].mask);
+		vfio_virqfd_disable(&vdev->ctx[i].unmask);
+		vfio_virqfd_disable(&vdev->ctx[i].mask);
 	}
 
 	if (msix) {
@@ -645,7 +646,7 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
 						  vfio_send_intx_eventfd, NULL,
 						  &vdev->ctx[0].unmask, fd);
 
-		vfio_virqfd_disable(vdev, &vdev->ctx[0].unmask);
+		vfio_virqfd_disable(&vdev->ctx[0].unmask);
 	}
 
 	return 0;
-- 
2.3.1
