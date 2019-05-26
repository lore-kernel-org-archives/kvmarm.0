Return-Path: <SRS0=9ge9=T2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05CA1C28CBF
	for <kvmarm@archiver.kernel.org>; Sun, 26 May 2019 16:11:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BEFC22075C
	for <kvmarm@archiver.kernel.org>; Sun, 26 May 2019 16:11:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEFC22075C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76F5F4A420;
	Sun, 26 May 2019 12:11:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X6kpVrk7HrH6; Sun, 26 May 2019 12:11:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DCCF4A4E8;
	Sun, 26 May 2019 12:11:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9DEE4A4C3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 May 2019 12:11:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iu0LeisYA6RK for <kvmarm@lists.cs.columbia.edu>;
 Sun, 26 May 2019 12:11:42 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C562F4A3BB
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 May 2019 12:11:42 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 238F43082200;
 Sun, 26 May 2019 16:11:42 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-67.ams2.redhat.com [10.36.116.67])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 43A755D72A;
 Sun, 26 May 2019 16:11:38 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com,
 robin.murphy@arm.com
Subject: [PATCH v8 15/29] iommu/smmuv3: Introduce
 __arm_smmu_tlb_inv_asid/s1_range_nosync
Date: Sun, 26 May 2019 18:09:50 +0200
Message-Id: <20190526161004.25232-16-eric.auger@redhat.com>
In-Reply-To: <20190526161004.25232-1-eric.auger@redhat.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.47]); Sun, 26 May 2019 16:11:42 +0000 (UTC)
Cc: marc.zyngier@arm.com, kevin.tian@intel.com, vincent.stehle@arm.com,
 ashok.raj@intel.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Introduce helpers to invalidate a given asid/vmid or invalidate
address ranges associated to a given asid/vmid.

S1 helpers will be used to invalidate stage 1 caches upon
userspace request, in nested mode.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
---
 drivers/iommu/arm-smmu-v3.c | 98 ++++++++++++++++++++++++++++---------
 1 file changed, 74 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index d770977bfc92..724b86ab9a80 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -1601,20 +1601,15 @@ static void arm_smmu_tlb_sync(void *cookie)
 	arm_smmu_cmdq_issue_sync(smmu_domain->smmu);
 }
 
-static void arm_smmu_tlb_inv_context(void *cookie)
+static void __arm_smmu_tlb_inv_asid(struct arm_smmu_domain *smmu_domain,
+				    u16 vmid, u16 asid)
 {
-	struct arm_smmu_domain *smmu_domain = cookie;
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
-	struct arm_smmu_cmdq_ent cmd;
+	struct arm_smmu_cmdq_ent cmd = {};
 
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
-		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
-		cmd.tlbi.asid	= smmu_domain->s1_cfg->cd.asid;
-		cmd.tlbi.vmid	= 0;
-	} else {
-		cmd.opcode	= CMDQ_OP_TLBI_S12_VMALL;
-		cmd.tlbi.vmid	= smmu_domain->s2_cfg->vmid;
-	}
+	cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
+	cmd.tlbi.vmid	= vmid;
+	cmd.tlbi.asid	= asid;
 
 	/*
 	 * NOTE: when io-pgtable is in non-strict mode, we may get here with
@@ -1626,32 +1621,87 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	arm_smmu_cmdq_issue_sync(smmu);
 }
 
-static void arm_smmu_tlb_inv_range_nosync(unsigned long iova, size_t size,
-					  size_t granule, bool leaf, void *cookie)
+static void __arm_smmu_tlb_inv_vmid(struct arm_smmu_domain *smmu_domain,
+				    u16 vmid)
+{
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	struct arm_smmu_cmdq_ent cmd = {};
+
+	cmd.opcode	= CMDQ_OP_TLBI_S12_VMALL;
+	cmd.tlbi.vmid	= vmid;
+
+	/* See DSB related comment in __arm_smmu_tlb_inv_asid */
+	arm_smmu_cmdq_issue_cmd(smmu, &cmd);
+	arm_smmu_cmdq_issue_sync(smmu);
+}
+
+static void arm_smmu_tlb_inv_context(void *cookie)
 {
 	struct arm_smmu_domain *smmu_domain = cookie;
-	struct arm_smmu_device *smmu = smmu_domain->smmu;
-	struct arm_smmu_cmdq_ent cmd = {
-		.tlbi = {
-			.leaf	= leaf,
-			.addr	= iova,
-		},
-	};
 
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
-		cmd.opcode	= CMDQ_OP_TLBI_NH_VA;
-		cmd.tlbi.asid	= smmu_domain->s1_cfg->cd.asid;
+		__arm_smmu_tlb_inv_asid(smmu_domain, 0,
+					smmu_domain->s1_cfg->cd.asid);
 	} else {
-		cmd.opcode	= CMDQ_OP_TLBI_S2_IPA;
-		cmd.tlbi.vmid	= smmu_domain->s2_cfg->vmid;
+		__arm_smmu_tlb_inv_vmid(smmu_domain,
+					smmu_domain->s2_cfg->vmid);
 	}
+}
 
+static void
+__arm_smmu_tlb_inv_s1_range_nosync(struct arm_smmu_domain *smmu_domain,
+				   u16 vmid, u16 asid, unsigned long iova,
+				   size_t size, size_t granule, bool leaf)
+{
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	struct arm_smmu_cmdq_ent cmd = {};
+
+	cmd.opcode	= CMDQ_OP_TLBI_NH_VA;
+	cmd.tlbi.vmid	= vmid;
+	cmd.tlbi.asid	= asid;
+	cmd.tlbi.addr	= iova;
+	cmd.tlbi.leaf	= leaf;
 	do {
 		arm_smmu_cmdq_issue_cmd(smmu, &cmd);
 		cmd.tlbi.addr += granule;
 	} while (size -= granule);
 }
 
+static void
+__arm_smmu_tlb_inv_s2_range_nosync(struct arm_smmu_domain *smmu_domain,
+				   u16 vmid, unsigned long iova, size_t size,
+				   size_t granule, bool leaf)
+{
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	struct arm_smmu_cmdq_ent cmd = {};
+
+	cmd.opcode	= CMDQ_OP_TLBI_S2_IPA;
+	cmd.tlbi.vmid	= vmid;
+	cmd.tlbi.addr	= iova;
+	cmd.tlbi.leaf	= leaf;
+	do {
+		arm_smmu_cmdq_issue_cmd(smmu, &cmd);
+		cmd.tlbi.addr += granule;
+	} while (size -= granule);
+}
+
+static void arm_smmu_tlb_inv_range_nosync(unsigned long iova, size_t size,
+					  size_t granule, bool leaf,
+					  void *cookie)
+{
+	struct arm_smmu_domain *smmu_domain = cookie;
+
+	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+		__arm_smmu_tlb_inv_s1_range_nosync(smmu_domain, 0,
+						   smmu_domain->s1_cfg->cd.asid,
+						   iova, size, granule, leaf);
+	} else {
+		__arm_smmu_tlb_inv_s2_range_nosync(smmu_domain,
+						   smmu_domain->s2_cfg->vmid,
+						   iova, size, granule, leaf);
+	}
+}
+
 static const struct iommu_gather_ops arm_smmu_gather_ops = {
 	.tlb_flush_all	= arm_smmu_tlb_inv_context,
 	.tlb_add_flush	= arm_smmu_tlb_inv_range_nosync,
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
