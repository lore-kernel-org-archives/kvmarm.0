From: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Subject: [RFC PATCH 6/6] arm-smmu: Allow to set iommu mapping for MSI
Date: Wed, 30 Sep 2015 20:26:29 +0530
Message-ID: <1443624989-24346-6-git-send-email-Bharat.Bhushan@freescale.com>
References: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3141B41252
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 05:22:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xlVbxivM1Oru for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Sep 2015 05:22:01 -0400 (EDT)
Received: from na01-by2-obe.outbound.protection.outlook.com
 (mail-by2on0114.outbound.protection.outlook.com [207.46.100.114])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F65D410D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2015 05:22:01 -0400 (EDT)
In-Reply-To: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com
Cc: marc.zyngier@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Finally ARM SMMU declare that iommu-mapping for MSI-pages are not
set automatically and it should be set explicitly.

Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
---
 drivers/iommu/arm-smmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index a3956fb..9d37e72 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1401,13 +1401,18 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
 				    enum iommu_attr attr, void *data)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct iommu_domain_msi_maps *msi_maps;
 
 	switch (attr) {
 	case DOMAIN_ATTR_NESTING:
 		*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
 		return 0;
 	case DOMAIN_ATTR_MSI_MAPPING:
-		/* Dummy handling added */
+		msi_maps = data;
+
+		msi_maps->automap = false;
+		msi_maps->override_automap = true;
+
 		return 0;
 	default:
 		return -ENODEV;
-- 
1.9.3
