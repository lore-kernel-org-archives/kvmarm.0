From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v11 8/8] iommu/arm-smmu: get/put the msi cookie
Date: Tue, 19 Jul 2016 12:55:11 +0000
Message-ID: <1468932911-23062-9-git-send-email-eric.auger@redhat.com>
References: <1468932911-23062-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2D0C49B37
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2016 08:49:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TnX+Ql4QHNGx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2016 08:49:58 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6A0E49B45
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2016 08:49:57 -0400 (EDT)
In-Reply-To: <1468932911-23062-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, robert.richter@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

For IOMMU_DOMAIN_UNMANAGED type we now also get the msi
cookie in both arm-smmu and arm-smmu-v3. This initializes
resources for MSI doorbell mapping.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/arm-smmu-v3.c | 16 ++++++++++++----
 drivers/iommu/arm-smmu.c    | 15 +++++++++++----
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 066d92c..960d377 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -22,6 +22,7 @@
 
 #include <linux/delay.h>
 #include <linux/dma-iommu.h>
+#include <linux/msi-iommu.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/iommu.h>
@@ -1412,15 +1413,21 @@ static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 		return NULL;
 
 	if (type == IOMMU_DOMAIN_DMA &&
-	    iommu_get_dma_cookie(&smmu_domain->domain)) {
-		kfree(smmu_domain);
-		return NULL;
-	}
+	    iommu_get_dma_cookie(&smmu_domain->domain))
+		goto err;
+
+	if (type == IOMMU_DOMAIN_UNMANAGED &&
+		iommu_get_msi_cookie(&smmu_domain->domain))
+		goto err;
+
 	smmu_domain->domain.msi_geometry = msi_geometry;
 
 	mutex_init(&smmu_domain->init_mutex);
 	spin_lock_init(&smmu_domain->pgtbl_lock);
 	return &smmu_domain->domain;
+err:
+	kfree(smmu_domain);
+	return NULL;
 }
 
 static int arm_smmu_bitmap_alloc(unsigned long *map, int span)
@@ -1446,6 +1453,7 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 
+	iommu_put_msi_cookie(domain);
 	iommu_put_dma_cookie(domain);
 	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
 
diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 9755a1b..867910b 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -30,6 +30,7 @@
 
 #include <linux/delay.h>
 #include <linux/dma-iommu.h>
+#include <linux/msi-iommu.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
@@ -1052,10 +1053,12 @@ static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 		return NULL;
 
 	if (type == IOMMU_DOMAIN_DMA &&
-	    iommu_get_dma_cookie(&smmu_domain->domain)) {
-		kfree(smmu_domain);
-		return NULL;
-	}
+	    iommu_get_dma_cookie(&smmu_domain->domain))
+		goto err;
+
+	if (type == IOMMU_DOMAIN_UNMANAGED &&
+		iommu_get_msi_cookie(&smmu_domain->domain))
+		goto err;
 
 	smmu_domain->domain.msi_geometry = msi_geometry;
 
@@ -1063,6 +1066,9 @@ static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 	spin_lock_init(&smmu_domain->pgtbl_lock);
 
 	return &smmu_domain->domain;
+err:
+	kfree(smmu_domain);
+	return NULL;
 }
 
 static void arm_smmu_domain_free(struct iommu_domain *domain)
@@ -1073,6 +1079,7 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 	 * Free the domain resources. We assume that all devices have
 	 * already been detached.
 	 */
+	iommu_put_msi_cookie(domain);
 	iommu_put_dma_cookie(domain);
 	arm_smmu_destroy_domain_context(domain);
 	kfree(smmu_domain);
-- 
1.9.1
