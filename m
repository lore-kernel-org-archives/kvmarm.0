From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2] vfio/type1: handle case where IOMMU does not support
 PAGE_SIZE size
Date: Thu, 29 Oct 2015 17:49:42 +0000
Message-ID: <1446140982-4059-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D99241280
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2015 13:47:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id INj2p8UcaTNi for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Oct 2015 13:47:08 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD3F441022
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2015 13:47:07 -0400 (EDT)
Received: by wmec75 with SMTP id c75so29283248wme.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2015 10:50:04 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will.deacon@arm.com
Cc: patches@linaro.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Current vfio_pgsize_bitmap code hides the supported IOMMU page
sizes smaller than PAGE_SIZE. As a result, in case the IOMMU
does not support PAGE_SIZE page, the alignment check on map/unmap
is done with larger page sizes, if any. This can fail although
mapping could be done with pages smaller than PAGE_SIZE.

This patch modifies vfio_pgsize_bitmap implementation so that,
in case the IOMMU supports page sizes smaller than PAGE_SIZE
we pretend PAGE_SIZE is supported and hide sub-PAGE_SIZE sizes.
That way the user will be able to map/unmap buffers whose size/
start address is aligned with PAGE_SIZE. Pinning code uses that
granularity while iommu driver can use the sub-PAGE_SIZE size
to map the buffer.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Will Deacon <will.deacon@arm.com>

---

This was tested on AMD Seattle with 64kB page host. ARM MMU 401
currently expose 4kB, 2MB and 1GB page support. With a 64kB page host,
the map/unmap check is done against 2MB. Some alignment check fail
so VFIO_IOMMU_MAP_DMA fail while we could map using 4kB IOMMU page
size.

v1 -> v2:
- correct PAGE_HOST type in comment and commit msg
- Add Will's R-b

RFC -> PATCH v1:
- move all modifications in vfio_pgsize_bitmap following Alex'
  suggestion to expose a fake PAGE_SIZE support
- restore WARN_ON's
---
 drivers/vfio/vfio_iommu_type1.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 57d8c37..59d47cb 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -403,13 +403,26 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
 {
 	struct vfio_domain *domain;
-	unsigned long bitmap = PAGE_MASK;
+	unsigned long bitmap = ULONG_MAX;
 
 	mutex_lock(&iommu->lock);
 	list_for_each_entry(domain, &iommu->domain_list, next)
 		bitmap &= domain->domain->ops->pgsize_bitmap;
 	mutex_unlock(&iommu->lock);
 
+	/*
+	 * In case the IOMMU supports page sizes smaller than PAGE_SIZE
+	 * we pretend PAGE_SIZE is supported and hide sub-PAGE_SIZE sizes.
+	 * That way the user will be able to map/unmap buffers whose size/
+	 * start address is aligned with PAGE_SIZE. Pinning code uses that
+	 * granularity while iommu driver can use the sub-PAGE_SIZE size
+	 * to map the buffer.
+	 */
+	if (bitmap & ~PAGE_MASK) {
+		bitmap &= PAGE_MASK;
+		bitmap |= PAGE_SIZE;
+	}
+
 	return bitmap;
 }
 
-- 
1.9.1
