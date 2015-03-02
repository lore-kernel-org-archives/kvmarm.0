From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: [PATCH 1/1] iommu/arm-smmu: fix ARM_SMMU_FEAT_TRANS_OPS condition
Date: Mon,  2 Mar 2015 17:57:22 +0100
Message-ID: <1425315442-29584-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22A0F47513
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:52:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ysC1l5zrjx0k for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2015 11:51:59 -0500 (EST)
Received: from mail-we0-f172.google.com (mail-we0-f172.google.com
 [74.125.82.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99DF54750E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:51:59 -0500 (EST)
Received: by wevk48 with SMTP id k48so34619974wev.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Mar 2015 08:57:56 -0800 (PST)
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
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, tech@virtualopensystems.com, "moderated list:ARM SMMU DRIVER" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

This patch is a fix to "iommu/arm-smmu: add support for iova_to_phys
through ATS1PR".
According to ARM documentation, translation registers are optional even
in SMMUv1, so ID0_S1TS needs to be checked to verify their presence.

Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
---
 drivers/iommu/arm-smmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index fc13dd5..d4beca4 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1556,7 +1556,7 @@ static int arm_smmu_device_cfg_probe(struct arm_smmu_device *smmu)
 		return -ENODEV;
 	}
 
-	if (smmu->version == 1 || (!(id & ID0_ATOSNS) && (id & ID0_S1TS))) {
+	if ((id & ID0_S1TS) && ((smmu->version == 1) || (id & ID0_ATOSNS))) {
 		smmu->features |= ARM_SMMU_FEAT_TRANS_OPS;
 		dev_notice(smmu->dev, "\taddress translation ops\n");
 	}
-- 
2.3.1
