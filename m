From: Leo Yan <leo.yan@linaro.org>
Subject: [PATCH kvmtool v2 1/3] vfio-pci: Release INTx's unmask eventfd
 properly
Date: Wed, 20 Mar 2019 14:20:44 +0800
Message-ID: <20190320062046.3895-2-leo.yan@linaro.org>
References: <20190320062046.3895-1-leo.yan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ADC94A330
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Mar 2019 02:21:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uIDaEwb2OD9R for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Mar 2019 02:21:12 -0400 (EDT)
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com
 [209.85.167.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B96949F94
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Mar 2019 02:21:12 -0400 (EDT)
Received: by mail-oi1-f196.google.com with SMTP id 67so882302oif.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 23:21:12 -0700 (PDT)
In-Reply-To: <20190320062046.3895-1-leo.yan@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, Eric Auger <eric.auger@redhat.com>, Robin Murphy <robin.murphy@arm.com>
Cc: Leo Yan <leo.yan@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The PCI device INTx uses event fd 'unmask_fd' to signal the deassertion
of the line from guest to host; but this eventfd isn't released properly
when disable INTx.

This patch firstly adds field 'unmask_fd' in struct vfio_pci_device for
storing unmask eventfd and close it when disable INTx.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 include/kvm/vfio.h | 1 +
 vfio/pci.c         | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
index 60e6c54..28223cf 100644
--- a/include/kvm/vfio.h
+++ b/include/kvm/vfio.h
@@ -74,6 +74,7 @@ struct vfio_pci_device {
 
 	unsigned long			irq_modes;
 	int				intx_fd;
+	int				unmask_fd;
 	unsigned int			intx_gsi;
 	struct vfio_pci_msi_common	msi;
 	struct vfio_pci_msi_common	msix;
diff --git a/vfio/pci.c b/vfio/pci.c
index 03de3c1..5224fee 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -1008,6 +1008,7 @@ static void vfio_pci_disable_intx(struct kvm *kvm, struct vfio_device *vdev)
 	irq__del_irqfd(kvm, gsi, pdev->intx_fd);
 
 	close(pdev->intx_fd);
+	close(pdev->unmask_fd);
 }
 
 static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
@@ -1095,6 +1096,7 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 	}
 
 	pdev->intx_fd = trigger_fd;
+	pdev->unmask_fd = unmask_fd;
 	/* Guest is going to ovewrite our irq_line... */
 	pdev->intx_gsi = gsi;
 
-- 
2.19.1
