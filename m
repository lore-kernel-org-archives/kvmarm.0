From: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Subject: [PATCH v14 15/20] vfio: virqfd: rename vfio_pci_virqfd_init and
	vfio_pci_virqfd_exit
Date: Mon,  2 Mar 2015 17:59:55 +0100
Message-ID: <1425315600-29761-16-git-send-email-b.reynal@virtualopensystems.com>
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
Cc: Frank Blaschka <frank.blaschka-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "open list:VFIO DRIVER" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Gavin Shan <gwshan-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org, Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Yang <weiyang-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>

The functions vfio_pci_virqfd_init and vfio_pci_virqfd_exit are not really
PCI specific, since we plan to reuse the virqfd code with more VFIO drivers
in addition to VFIO_PCI.

Signed-off-by: Antonios Motakis <a.motakis-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
[Baptiste Reynal: Move rename vfio_pci_virqfd_init and vfio_pci_virqfd_exit
from "vfio: add a vfio_ prefix to virqfd_enable and virqfd_disable and export"]
Signed-off-by: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
---
 drivers/vfio/pci/vfio_pci.c         | 6 +++---
 drivers/vfio/pci/vfio_pci_intrs.c   | 4 ++--
 drivers/vfio/pci/vfio_pci_private.h | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index f8a1863..668d37c 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1030,7 +1030,7 @@ put_devs:
 static void __exit vfio_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_pci_driver);
-	vfio_pci_virqfd_exit();
+	vfio_virqfd_exit();
 	vfio_pci_uninit_perm_bits();
 }
 
@@ -1044,7 +1044,7 @@ static int __init vfio_pci_init(void)
 		return ret;
 
 	/* Start the virqfd cleanup handler */
-	ret = vfio_pci_virqfd_init();
+	ret = vfio_virqfd_init();
 	if (ret)
 		goto out_virqfd;
 
@@ -1056,7 +1056,7 @@ static int __init vfio_pci_init(void)
 	return 0;
 
 out_driver:
-	vfio_pci_virqfd_exit();
+	vfio_virqfd_exit();
 out_virqfd:
 	vfio_pci_uninit_perm_bits();
 	return ret;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 4d38c93..d96ffe0 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -45,7 +45,7 @@ struct virqfd {
 
 static struct workqueue_struct *vfio_irqfd_cleanup_wq;
 
-int __init vfio_pci_virqfd_init(void)
+int __init vfio_virqfd_init(void)
 {
 	vfio_irqfd_cleanup_wq =
 		create_singlethread_workqueue("vfio-irqfd-cleanup");
@@ -55,7 +55,7 @@ int __init vfio_pci_virqfd_init(void)
 	return 0;
 }
 
-void vfio_pci_virqfd_exit(void)
+void vfio_virqfd_exit(void)
 {
 	destroy_workqueue(vfio_irqfd_cleanup_wq);
 }
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index c9f9b32..0253965 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -87,8 +87,8 @@ extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 extern int vfio_pci_init_perm_bits(void);
 extern void vfio_pci_uninit_perm_bits(void);
 
-extern int vfio_pci_virqfd_init(void);
-extern void vfio_pci_virqfd_exit(void);
+extern int vfio_virqfd_init(void);
+extern void vfio_virqfd_exit(void);
 
 extern int vfio_config_init(struct vfio_pci_device *vdev);
 extern void vfio_config_free(struct vfio_pci_device *vdev);
-- 
2.3.1
