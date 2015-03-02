From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: [PATCH v14 17/20] vfio: pass an opaque pointer on virqfd
 initialization
Date: Mon,  2 Mar 2015 17:59:57 +0100
Message-ID: <1425315600-29761-18-git-send-email-b.reynal@virtualopensystems.com>
References: <1425315600-29761-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8491C4769E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:57:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pX5iqfT3bkeR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2015 11:57:14 -0500 (EST)
Received: from mail-wg0-f41.google.com (mail-wg0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AE60476BC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:57:14 -0500 (EST)
Received: by wggx12 with SMTP id x12so34732838wgg.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Mar 2015 09:03:11 -0800 (PST)
In-Reply-To: <1425315600-29761-1-git-send-email-b.reynal@virtualopensystems.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: iommu@lists.linux-foundation.org, kvmarm@lists.cs.columbia.edu
Cc: "open list:VFIO DRIVER" <kvm@vger.kernel.org>, Gavin Shan <gwshan@linux.vnet.ibm.com>, open list <linux-kernel@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, tech@virtualopensystems.com, Jiang Liu <jiang.liu@linux.intel.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Antonios Motakis <a.motakis@virtualopensystems.com>

VFIO_PCI passes the VFIO device structure *vdev via eventfd to the handler
that implements masking/unmasking of IRQs via an eventfd. We can replace
it in the virqfd infrastructure with an opaque type so we can make use
of the mechanism from other VFIO bus drivers.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 7d3c135..1a16da3 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -31,10 +31,10 @@
  * IRQfd - generic
  */
 struct virqfd {
-	struct vfio_pci_device	*vdev;
+	void			*opaque;
 	struct eventfd_ctx	*eventfd;
-	int			(*handler)(struct vfio_pci_device *, void *);
-	void			(*thread)(struct vfio_pci_device *, void *);
+	int			(*handler)(void *, void *);
+	void			(*thread)(void *, void *);
 	void			*data;
 	struct work_struct	inject;
 	wait_queue_t		wait;
@@ -74,7 +74,7 @@ static int virqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 	if (flags & POLLIN) {
 		/* An event has been signaled, call function */
 		if ((!virqfd->handler ||
-		     virqfd->handler(virqfd->vdev, virqfd->data)) &&
+		     virqfd->handler(virqfd->opaque, virqfd->data)) &&
 		    virqfd->thread)
 			schedule_work(&virqfd->inject);
 	}
@@ -124,12 +124,12 @@ static void virqfd_inject(struct work_struct *work)
 {
 	struct virqfd *virqfd = container_of(work, struct virqfd, inject);
 	if (virqfd->thread)
-		virqfd->thread(virqfd->vdev, virqfd->data);
+		virqfd->thread(virqfd->opaque, virqfd->data);
 }
 
-int vfio_virqfd_enable(struct vfio_pci_device *vdev,
-		       int (*handler)(struct vfio_pci_device *, void *),
-		       void (*thread)(struct vfio_pci_device *, void *),
+int vfio_virqfd_enable(void *opaque,
+		       int (*handler)(void *, void *),
+		       void (*thread)(void *, void *),
 		       void *data, struct virqfd **pvirqfd, int fd)
 {
 	struct fd irqfd;
@@ -143,7 +143,7 @@ int vfio_virqfd_enable(struct vfio_pci_device *vdev,
 		return -ENOMEM;
 
 	virqfd->pvirqfd = pvirqfd;
-	virqfd->vdev = vdev;
+	virqfd->opaque = opaque;
 	virqfd->handler = handler;
 	virqfd->thread = thread;
 	virqfd->data = data;
@@ -196,7 +196,7 @@ int vfio_virqfd_enable(struct vfio_pci_device *vdev,
 	 * before we registered and trigger it as if we didn't miss it.
 	 */
 	if (events & POLLIN) {
-		if ((!handler || handler(vdev, data)) && thread)
+		if ((!handler || handler(opaque, data)) && thread)
 			schedule_work(&virqfd->inject);
 	}
 
@@ -243,8 +243,10 @@ EXPORT_SYMBOL_GPL(vfio_virqfd_disable);
 /*
  * INTx
  */
-static void vfio_send_intx_eventfd(struct vfio_pci_device *vdev, void *unused)
+static void vfio_send_intx_eventfd(void *opaque, void *unused)
 {
+	struct vfio_pci_device *vdev = opaque;
+
 	if (likely(is_intx(vdev) && !vdev->virq_disabled))
 		eventfd_signal(vdev->ctx[0].trigger, 1);
 }
@@ -287,9 +289,9 @@ void vfio_pci_intx_mask(struct vfio_pci_device *vdev)
  * a signal is necessary, which can then be handled via a work queue
  * or directly depending on the caller.
  */
-static int vfio_pci_intx_unmask_handler(struct vfio_pci_device *vdev,
-					void *unused)
+static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 {
+	struct vfio_pci_device *vdev = opaque;
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long flags;
 	int ret = 0;
@@ -641,7 +643,7 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
 	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
 		int32_t fd = *(int32_t *)data;
 		if (fd >= 0)
-			return vfio_virqfd_enable(vdev,
+			return vfio_virqfd_enable((void *) vdev,
 						  vfio_pci_intx_unmask_handler,
 						  vfio_send_intx_eventfd, NULL,
 						  &vdev->ctx[0].unmask, fd);
-- 
2.3.1
