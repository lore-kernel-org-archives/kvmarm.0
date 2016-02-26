From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v4 10/14] vfio: introduce VFIO_IOVA_RESERVED vfio_dma type
Date: Fri, 26 Feb 2016 17:35:50 +0000
Message-ID: <1456508154-2253-11-git-send-email-eric.auger@linaro.org>
References: <1456508154-2253-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE0BA4852F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 12:29:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EMOKJy8zqRVb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Feb 2016 12:29:41 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9256410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 12:29:40 -0500 (EST)
Received: by mail-wm0-f41.google.com with SMTP id c200so82114766wme.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 09:36:33 -0800 (PST)
In-Reply-To: <1456508154-2253-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

We introduce a vfio_dma type since we will need to discriminate
legacy vfio_dma's from new reserved ones. Since those latter are
not mapped at registration, some treatments need to be reworked:
removal, replay. Currently they are unplugged. In subsequent patches
they will be reworked.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/vfio/vfio_iommu_type1.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 6f1ea3d..692e9a2 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -53,6 +53,15 @@ module_param_named(disable_hugepages,
 MODULE_PARM_DESC(disable_hugepages,
 		 "Disable VFIO IOMMU support for IOMMU hugepages.");
 
+enum vfio_iova_type {
+	VFIO_IOVA_USER = 0, /* standard IOVA used to map user vaddr */
+	/*
+	 * IOVA reserved to map special host physical addresses,
+	 * MSI frames for instance
+	 */
+	VFIO_IOVA_RESERVED,
+};
+
 struct vfio_iommu {
 	struct list_head	domain_list;
 	struct mutex		lock;
@@ -75,6 +84,7 @@ struct vfio_dma {
 	unsigned long		vaddr;		/* Process virtual addr */
 	size_t			size;		/* Map size (bytes) */
 	int			prot;		/* IOMMU_READ/WRITE */
+	enum vfio_iova_type	type;		/* type of IOVA */
 };
 
 struct vfio_group {
@@ -395,7 +405,8 @@ static void vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma)
 
 static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 {
-	vfio_unmap_unpin(iommu, dma);
+	if (likely(dma->type != VFIO_IOVA_RESERVED))
+		vfio_unmap_unpin(iommu, dma);
 	vfio_unlink_dma(iommu, dma);
 	kfree(dma);
 }
@@ -671,6 +682,10 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 		dma_addr_t iova;
 
 		dma = rb_entry(n, struct vfio_dma, node);
+
+		if (unlikely(dma->type == VFIO_IOVA_RESERVED))
+			continue;
+
 		iova = dma->iova;
 
 		while (iova < dma->iova + dma->size) {
-- 
1.9.1
