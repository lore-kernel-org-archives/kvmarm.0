From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: [PATCH v14 19/20] vfio: initialize the virqfd workqueue in VFIO
 generic code
Date: Mon,  2 Mar 2015 17:59:59 +0100
Message-ID: <1425315600-29761-20-git-send-email-b.reynal@virtualopensystems.com>
References: <1425315600-29761-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15FE9475A0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:57:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SH3ELvX+99Yg for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2015 11:57:36 -0500 (EST)
Received: from mail-wg0-f44.google.com (mail-wg0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E4A0475D8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:57:35 -0500 (EST)
Received: by wghl18 with SMTP id l18so34735165wgh.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Mar 2015 09:03:32 -0800 (PST)
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
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>, Alexey Kardashevskiy <aik@ozlabs.ru>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Gavin Shan <gwshan@linux.vnet.ibm.com>, open list <linux-kernel@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, tech@virtualopensystems.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Antonios Motakis <a.motakis@virtualopensystems.com>

Now we have finally completely decoupled virqfd from VFIO_PCI. We can
initialize it from the VFIO generic code, in order to safely use it from
multiple independent VFIO bus drivers.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
---
 drivers/vfio/Makefile       | 4 +++-
 drivers/vfio/pci/Makefile   | 3 +--
 drivers/vfio/pci/vfio_pci.c | 8 --------
 drivers/vfio/vfio.c         | 8 ++++++++
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index dadf0ca..d798b09 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -1,4 +1,6 @@
-obj-$(CONFIG_VFIO) += vfio.o
+vfio_core-y := vfio.o virqfd.o
+
+obj-$(CONFIG_VFIO) += vfio_core.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
 obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
 obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index c7c8644..1310792 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,5 +1,4 @@
 
-vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o \
-	      ../virqfd.o
+vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
 
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 668d37c..2f865d07 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1030,7 +1030,6 @@ put_devs:
 static void __exit vfio_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_pci_driver);
-	vfio_virqfd_exit();
 	vfio_pci_uninit_perm_bits();
 }
 
@@ -1043,11 +1042,6 @@ static int __init vfio_pci_init(void)
 	if (ret)
 		return ret;
 
-	/* Start the virqfd cleanup handler */
-	ret = vfio_virqfd_init();
-	if (ret)
-		goto out_virqfd;
-
 	/* Register and scan for devices */
 	ret = pci_register_driver(&vfio_pci_driver);
 	if (ret)
@@ -1056,8 +1050,6 @@ static int __init vfio_pci_init(void)
 	return 0;
 
 out_driver:
-	vfio_virqfd_exit();
-out_virqfd:
 	vfio_pci_uninit_perm_bits();
 	return ret;
 }
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 4cde855..23ba12a 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1553,6 +1553,11 @@ static int __init vfio_init(void)
 	if (ret)
 		goto err_cdev_add;
 
+	/* Start the virqfd cleanup handler used by some VFIO bus drivers */
+	ret = vfio_virqfd_init();
+	if (ret)
+		goto err_virqfd;
+
 	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 
 	/*
@@ -1565,6 +1570,8 @@ static int __init vfio_init(void)
 
 	return 0;
 
+err_virqfd:
+	cdev_del(&vfio.group_cdev);
 err_cdev_add:
 	unregister_chrdev_region(vfio.group_devt, MINORMASK);
 err_alloc_chrdev:
@@ -1579,6 +1586,7 @@ static void __exit vfio_cleanup(void)
 {
 	WARN_ON(!list_empty(&vfio.group_list));
 
+	vfio_virqfd_exit();
 	idr_destroy(&vfio.group_idr);
 	cdev_del(&vfio.group_cdev);
 	unregister_chrdev_region(vfio.group_devt, MINORMASK);
-- 
2.3.1
