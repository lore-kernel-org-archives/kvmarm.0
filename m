From: Leo Yan <leo.yan@linaro.org>
Subject: [PATCH kvmtool v2 2/3] vfio-pci: Remove useless FDs reservation in
 vfio_pci_enable_intx()
Date: Wed, 20 Mar 2019 14:20:45 +0800
Message-ID: <20190320062046.3895-3-leo.yan@linaro.org>
References: <20190320062046.3895-1-leo.yan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD5A74A379
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Mar 2019 02:21:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PZf3MEpScDxi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Mar 2019 02:21:16 -0400 (EDT)
Received: from mail-oi1-f194.google.com (mail-oi1-f194.google.com
 [209.85.167.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E53EF4A36D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Mar 2019 02:21:15 -0400 (EDT)
Received: by mail-oi1-f194.google.com with SMTP id 67so882379oif.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 23:21:15 -0700 (PDT)
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

Since INTx only uses 2 FDs, it's not particularly useful to reserve FDs
in function vfio_pci_enable_intx(); so this patch is to remove FDs
reservation in this function.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 vfio/pci.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index 5224fee..d025581 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -1025,8 +1025,6 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 		.index = VFIO_PCI_INTX_IRQ_INDEX,
 	};
 
-	vfio_pci_reserve_irq_fds(2);
-
 	ret = ioctl(vdev->fd, VFIO_DEVICE_GET_IRQ_INFO, &irq_info);
 	if (ret || irq_info.count == 0) {
 		vfio_dev_err(vdev, "no INTx reported by VFIO");
-- 
2.19.1
