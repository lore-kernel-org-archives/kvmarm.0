From: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: [PATCH v14 18/20] vfio: move eventfd support code for VFIO_PCI to a
	separate file
Date: Mon,  2 Mar 2015 17:59:58 +0100
Message-ID: <1425315600-29761-19-git-send-email-b.reynal@virtualopensystems.com>
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
Cc: "open list:VFIO DRIVER" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Gavin Shan <gwshan-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>

The virqfd functionality that is used by VFIO_PCI to implement interrupt
masking and unmasking via an eventfd, is generic enough and can be reused
by another driver. Move it to a separate file in order to allow the code
to be shared.

Signed-off-by: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Signed-off-by: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
---
 drivers/vfio/pci/Makefile           |   3 +-
 drivers/vfio/pci/vfio_pci_intrs.c   | 215 ------------------------------------
 drivers/vfio/pci/vfio_pci_private.h |   3 -
 drivers/vfio/virqfd.c               | 213 +++++++++++++++++++++++++++++++++++
 include/linux/vfio.h                |  27 +++++
 5 files changed, 242 insertions(+), 219 deletions(-)
 create mode 100644 drivers/vfio/virqfd.c

diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 1310792..c7c8644 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,4 +1,5 @@
 
-vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
+vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o \
+	      ../virqfd.o
 
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 1a16da3..da6616e 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -19,228 +19,13 @@
 #include <linux/msi.h>
 #include <linux/pci.h>
 #include <linux/file.h>
-#include <linux/poll.h>
 #include <linux/vfio.h>
 #include <linux/wait.h>
-#include <linux/workqueue.h>
 #include <linux/slab.h>
 
 #include "vfio_pci_private.h"
 
 /*
- * IRQfd - generic
- */
-struct virqfd {
-	void			*opaque;
-	struct eventfd_ctx	*eventfd;
-	int			(*handler)(void *, void *);
-	void			(*thread)(void *, void *);
-	void			*data;
-	struct work_struct	inject;
-	wait_queue_t		wait;
-	poll_table		pt;
-	struct work_struct	shutdown;
-	struct virqfd		**pvirqfd;
-};
-
-static struct workqueue_struct *vfio_irqfd_cleanup_wq;
-DEFINE_SPINLOCK(virqfd_lock);
-
-int __init vfio_virqfd_init(void)
-{
-	vfio_irqfd_cleanup_wq =
-		create_singlethread_workqueue("vfio-irqfd-cleanup");
-	if (!vfio_irqfd_cleanup_wq)
-		return -ENOMEM;
-
-	return 0;
-}
-
-void vfio_virqfd_exit(void)
-{
-	destroy_workqueue(vfio_irqfd_cleanup_wq);
-}
-
-static void virqfd_deactivate(struct virqfd *virqfd)
-{
-	queue_work(vfio_irqfd_cleanup_wq, &virqfd->shutdown);
-}
-
-static int virqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
-{
-	struct virqfd *virqfd = container_of(wait, struct virqfd, wait);
-	unsigned long flags = (unsigned long)key;
-
-	if (flags & POLLIN) {
-		/* An event has been signaled, call function */
-		if ((!virqfd->handler ||
-		     virqfd->handler(virqfd->opaque, virqfd->data)) &&
-		    virqfd->thread)
-			schedule_work(&virqfd->inject);
-	}
-
-	if (flags & POLLHUP) {
-		unsigned long flags;
-		spin_lock_irqsave(&virqfd_lock, flags);
-
-		/*
-		 * The eventfd is closing, if the virqfd has not yet been
-		 * queued for release, as determined by testing whether the
-		 * virqfd pointer to it is still valid, queue it now.  As
-		 * with kvm irqfds, we know we won't race against the virqfd
-		 * going away because we hold the lock to get here.
-		 */
-		if (*(virqfd->pvirqfd) == virqfd) {
-			*(virqfd->pvirqfd) = NULL;
-			virqfd_deactivate(virqfd);
-		}
-
-		spin_unlock_irqrestore(&virqfd_lock, flags);
-	}
-
-	return 0;
-}
-
-static void virqfd_ptable_queue_proc(struct file *file,
-				     wait_queue_head_t *wqh, poll_table *pt)
-{
-	struct virqfd *virqfd = container_of(pt, struct virqfd, pt);
-	add_wait_queue(wqh, &virqfd->wait);
-}
-
-static void virqfd_shutdown(struct work_struct *work)
-{
-	struct virqfd *virqfd = container_of(work, struct virqfd, shutdown);
-	u64 cnt;
-
-	eventfd_ctx_remove_wait_queue(virqfd->eventfd, &virqfd->wait, &cnt);
-	flush_work(&virqfd->inject);
-	eventfd_ctx_put(virqfd->eventfd);
-
-	kfree(virqfd);
-}
-
-static void virqfd_inject(struct work_struct *work)
-{
-	struct virqfd *virqfd = container_of(work, struct virqfd, inject);
-	if (virqfd->thread)
-		virqfd->thread(virqfd->opaque, virqfd->data);
-}
-
-int vfio_virqfd_enable(void *opaque,
-		       int (*handler)(void *, void *),
-		       void (*thread)(void *, void *),
-		       void *data, struct virqfd **pvirqfd, int fd)
-{
-	struct fd irqfd;
-	struct eventfd_ctx *ctx;
-	struct virqfd *virqfd;
-	int ret = 0;
-	unsigned int events;
-
-	virqfd = kzalloc(sizeof(*virqfd), GFP_KERNEL);
-	if (!virqfd)
-		return -ENOMEM;
-
-	virqfd->pvirqfd = pvirqfd;
-	virqfd->opaque = opaque;
-	virqfd->handler = handler;
-	virqfd->thread = thread;
-	virqfd->data = data;
-
-	INIT_WORK(&virqfd->shutdown, virqfd_shutdown);
-	INIT_WORK(&virqfd->inject, virqfd_inject);
-
-	irqfd = fdget(fd);
-	if (!irqfd.file) {
-		ret = -EBADF;
-		goto err_fd;
-	}
-
-	ctx = eventfd_ctx_fileget(irqfd.file);
-	if (IS_ERR(ctx)) {
-		ret = PTR_ERR(ctx);
-		goto err_ctx;
-	}
-
-	virqfd->eventfd = ctx;
-
-	/*
-	 * virqfds can be released by closing the eventfd or directly
-	 * through ioctl.  These are both done through a workqueue, so
-	 * we update the pointer to the virqfd under lock to avoid
-	 * pushing multiple jobs to release the same virqfd.
-	 */
-	spin_lock_irq(&virqfd_lock);
-
-	if (*pvirqfd) {
-		spin_unlock_irq(&virqfd_lock);
-		ret = -EBUSY;
-		goto err_busy;
-	}
-	*pvirqfd = virqfd;
-
-	spin_unlock_irq(&virqfd_lock);
-
-	/*
-	 * Install our own custom wake-up handling so we are notified via
-	 * a callback whenever someone signals the underlying eventfd.
-	 */
-	init_waitqueue_func_entry(&virqfd->wait, virqfd_wakeup);
-	init_poll_funcptr(&virqfd->pt, virqfd_ptable_queue_proc);
-
-	events = irqfd.file->f_op->poll(irqfd.file, &virqfd->pt);
-
-	/*
-	 * Check if there was an event already pending on the eventfd
-	 * before we registered and trigger it as if we didn't miss it.
-	 */
-	if (events & POLLIN) {
-		if ((!handler || handler(opaque, data)) && thread)
-			schedule_work(&virqfd->inject);
-	}
-
-	/*
-	 * Do not drop the file until the irqfd is fully initialized,
-	 * otherwise we might race against the POLLHUP.
-	 */
-	fdput(irqfd);
-
-	return 0;
-err_busy:
-	eventfd_ctx_put(ctx);
-err_ctx:
-	fdput(irqfd);
-err_fd:
-	kfree(virqfd);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(vfio_virqfd_enable);
-
-void vfio_virqfd_disable(struct virqfd **pvirqfd)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&virqfd_lock, flags);
-
-	if (*pvirqfd) {
-		virqfd_deactivate(*pvirqfd);
-		*pvirqfd = NULL;
-	}
-
-	spin_unlock_irqrestore(&virqfd_lock, flags);
-
-	/*
-	 * Block until we know all outstanding shutdown jobs have completed.
-	 * Even if we don't queue the job, flush the wq to be sure it's
-	 * been released.
-	 */
-	flush_workqueue(vfio_irqfd_cleanup_wq);
-}
-EXPORT_SYMBOL_GPL(vfio_virqfd_disable);
-
-/*
  * INTx
  */
 static void vfio_send_intx_eventfd(void *opaque, void *unused)
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 0253965..ae0e1b4 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -87,9 +87,6 @@ extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 extern int vfio_pci_init_perm_bits(void);
 extern void vfio_pci_uninit_perm_bits(void);
 
-extern int vfio_virqfd_init(void);
-extern void vfio_virqfd_exit(void);
-
 extern int vfio_config_init(struct vfio_pci_device *vdev);
 extern void vfio_config_free(struct vfio_pci_device *vdev);
 #endif /* VFIO_PCI_PRIVATE_H */
diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
new file mode 100644
index 0000000..5967899
--- /dev/null
+++ b/drivers/vfio/virqfd.c
@@ -0,0 +1,213 @@
+/*
+ * VFIO generic eventfd code for IRQFD support.
+ * Derived from drivers/vfio/pci/vfio_pci_intrs.c
+ *
+ * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
+ *     Author: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/vfio.h>
+#include <linux/eventfd.h>
+#include <linux/file.h>
+#include <linux/slab.h>
+
+static struct workqueue_struct *vfio_irqfd_cleanup_wq;
+DEFINE_SPINLOCK(virqfd_lock);
+
+int __init vfio_virqfd_init(void)
+{
+	vfio_irqfd_cleanup_wq =
+		create_singlethread_workqueue("vfio-irqfd-cleanup");
+	if (!vfio_irqfd_cleanup_wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void vfio_virqfd_exit(void)
+{
+	destroy_workqueue(vfio_irqfd_cleanup_wq);
+}
+
+static void virqfd_deactivate(struct virqfd *virqfd)
+{
+	queue_work(vfio_irqfd_cleanup_wq, &virqfd->shutdown);
+}
+
+static int virqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
+{
+	struct virqfd *virqfd = container_of(wait, struct virqfd, wait);
+	unsigned long flags = (unsigned long)key;
+
+	if (flags & POLLIN) {
+		/* An event has been signaled, call function */
+		if ((!virqfd->handler ||
+		     virqfd->handler(virqfd->opaque, virqfd->data)) &&
+		    virqfd->thread)
+			schedule_work(&virqfd->inject);
+	}
+
+	if (flags & POLLHUP) {
+		unsigned long flags;
+		spin_lock_irqsave(&virqfd_lock, flags);
+
+		/*
+		 * The eventfd is closing, if the virqfd has not yet been
+		 * queued for release, as determined by testing whether the
+		 * virqfd pointer to it is still valid, queue it now.  As
+		 * with kvm irqfds, we know we won't race against the virqfd
+		 * going away because we hold the lock to get here.
+		 */
+		if (*(virqfd->pvirqfd) == virqfd) {
+			*(virqfd->pvirqfd) = NULL;
+			virqfd_deactivate(virqfd);
+		}
+
+		spin_unlock_irqrestore(&virqfd_lock, flags);
+	}
+
+	return 0;
+}
+
+static void virqfd_ptable_queue_proc(struct file *file,
+				     wait_queue_head_t *wqh, poll_table *pt)
+{
+	struct virqfd *virqfd = container_of(pt, struct virqfd, pt);
+	add_wait_queue(wqh, &virqfd->wait);
+}
+
+static void virqfd_shutdown(struct work_struct *work)
+{
+	struct virqfd *virqfd = container_of(work, struct virqfd, shutdown);
+	u64 cnt;
+
+	eventfd_ctx_remove_wait_queue(virqfd->eventfd, &virqfd->wait, &cnt);
+	flush_work(&virqfd->inject);
+	eventfd_ctx_put(virqfd->eventfd);
+
+	kfree(virqfd);
+}
+
+static void virqfd_inject(struct work_struct *work)
+{
+	struct virqfd *virqfd = container_of(work, struct virqfd, inject);
+	if (virqfd->thread)
+		virqfd->thread(virqfd->opaque, virqfd->data);
+}
+
+int vfio_virqfd_enable(void *opaque,
+		       int (*handler)(void *, void *),
+		       void (*thread)(void *, void *),
+		       void *data, struct virqfd **pvirqfd, int fd)
+{
+	struct fd irqfd;
+	struct eventfd_ctx *ctx;
+	struct virqfd *virqfd;
+	int ret = 0;
+	unsigned int events;
+
+	virqfd = kzalloc(sizeof(*virqfd), GFP_KERNEL);
+	if (!virqfd)
+		return -ENOMEM;
+
+	virqfd->pvirqfd = pvirqfd;
+	virqfd->opaque = opaque;
+	virqfd->handler = handler;
+	virqfd->thread = thread;
+	virqfd->data = data;
+
+	INIT_WORK(&virqfd->shutdown, virqfd_shutdown);
+	INIT_WORK(&virqfd->inject, virqfd_inject);
+
+	irqfd = fdget(fd);
+	if (!irqfd.file) {
+		ret = -EBADF;
+		goto err_fd;
+	}
+
+	ctx = eventfd_ctx_fileget(irqfd.file);
+	if (IS_ERR(ctx)) {
+		ret = PTR_ERR(ctx);
+		goto err_ctx;
+	}
+
+	virqfd->eventfd = ctx;
+
+	/*
+	 * virqfds can be released by closing the eventfd or directly
+	 * through ioctl.  These are both done through a workqueue, so
+	 * we update the pointer to the virqfd under lock to avoid
+	 * pushing multiple jobs to release the same virqfd.
+	 */
+	spin_lock_irq(&virqfd_lock);
+
+	if (*pvirqfd) {
+		spin_unlock_irq(&virqfd_lock);
+		ret = -EBUSY;
+		goto err_busy;
+	}
+	*pvirqfd = virqfd;
+
+	spin_unlock_irq(&virqfd_lock);
+
+	/*
+	 * Install our own custom wake-up handling so we are notified via
+	 * a callback whenever someone signals the underlying eventfd.
+	 */
+	init_waitqueue_func_entry(&virqfd->wait, virqfd_wakeup);
+	init_poll_funcptr(&virqfd->pt, virqfd_ptable_queue_proc);
+
+	events = irqfd.file->f_op->poll(irqfd.file, &virqfd->pt);
+
+	/*
+	 * Check if there was an event already pending on the eventfd
+	 * before we registered and trigger it as if we didn't miss it.
+	 */
+	if (events & POLLIN) {
+		if ((!handler || handler(opaque, data)) && thread)
+			schedule_work(&virqfd->inject);
+	}
+
+	/*
+	 * Do not drop the file until the irqfd is fully initialized,
+	 * otherwise we might race against the POLLHUP.
+	 */
+	fdput(irqfd);
+
+	return 0;
+err_busy:
+	eventfd_ctx_put(ctx);
+err_ctx:
+	fdput(irqfd);
+err_fd:
+	kfree(virqfd);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_virqfd_enable);
+
+void vfio_virqfd_disable(struct virqfd **pvirqfd)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&virqfd_lock, flags);
+
+	if (*pvirqfd) {
+		virqfd_deactivate(*pvirqfd);
+		*pvirqfd = NULL;
+	}
+
+	spin_unlock_irqrestore(&virqfd_lock, flags);
+
+	/*
+	 * Block until we know all outstanding shutdown jobs have completed.
+	 * Even if we don't queue the job, flush the wq to be sure it's
+	 * been released.
+	 */
+	flush_workqueue(vfio_irqfd_cleanup_wq);
+}
+EXPORT_SYMBOL_GPL(vfio_virqfd_disable);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 2d67b89..683b514 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -14,6 +14,8 @@
 
 #include <linux/iommu.h>
 #include <linux/mm.h>
+#include <linux/workqueue.h>
+#include <linux/poll.h>
 #include <uapi/linux/vfio.h>
 
 /**
@@ -123,4 +125,29 @@ static inline long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
 	return -ENOTTY;
 }
 #endif /* CONFIG_EEH */
+
+/*
+ * IRQfd - generic
+ */
+struct virqfd {
+	void			*opaque;
+	struct eventfd_ctx	*eventfd;
+	int			(*handler)(void *, void *);
+	void			(*thread)(void *, void *);
+	void			*data;
+	struct work_struct	inject;
+	wait_queue_t		wait;
+	poll_table		pt;
+	struct work_struct	shutdown;
+	struct virqfd		**pvirqfd;
+};
+
+extern int vfio_virqfd_init(void);
+extern void vfio_virqfd_exit(void);
+extern int vfio_virqfd_enable(void *opaque,
+			      int (*handler)(void *, void *),
+			      void (*thread)(void *, void *),
+			      void *data, struct virqfd **pvirqfd, int fd);
+extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
+
 #endif /* VFIO_H */
-- 
2.3.1
