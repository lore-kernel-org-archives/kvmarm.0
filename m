From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 09/20] iommu/smmuv3: Get prepared for nested stage support
Date: Tue, 18 Sep 2018 16:24:46 +0200
Message-ID: <20180918142457.3325-10-eric.auger@redhat.com>
References: <20180918142457.3325-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1642449F94
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 10:26:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZscG5re02LKl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Sep 2018 10:26:13 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D79449F8B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 10:26:13 -0400 (EDT)
In-Reply-To: <20180918142457.3325-1-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: tianyu.lan@intel.com, marc.zyngier@arm.com, ashok.raj@intel.com
List-Id: kvmarm@lists.cs.columbia.edu

To allow nested stage support, we need to store both
stage 1 and stage 2 configurations (and remove the former
union).

arm_smmu_write_strtab_ent() is modified to write both stage
fields in the STE.

We add a nested_bypass field to the S1 configuration as the first
stage can be bypassed. Also the guest may force the STE to abort:
this information gets stored into the nested_abort field.

Only S2 stage is "finalized" as the host does not configure
S1 CD, guest does.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- invalidate the STE before moving from a live STE config to another
- add the nested_abort and nested_bypass fields
---
 drivers/iommu/arm-smmu-v3.c | 43 ++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 80bb93b43a2e..9749c36208f3 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -222,6 +222,7 @@
 #define STRTAB_STE_0_CFG_BYPASS		4
 #define STRTAB_STE_0_CFG_S1_TRANS	5
 #define STRTAB_STE_0_CFG_S2_TRANS	6
+#define STRTAB_STE_0_CFG_NESTED		7
 
 #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
 #define STRTAB_STE_0_S1FMT_LINEAR	0
@@ -497,6 +498,10 @@ struct arm_smmu_strtab_l1_desc {
 struct arm_smmu_s1_cfg {
 	__le64				*cdptr;
 	dma_addr_t			cdptr_dma;
+	/* in nested mode, tells s1 must be bypassed */
+	bool				nested_bypass;
+	/* in nested mode, abort is forced by guest */
+	bool				nested_abort;
 
 	struct arm_smmu_ctx_desc {
 		u16	asid;
@@ -521,6 +526,7 @@ struct arm_smmu_strtab_ent {
 	 * configured according to the domain type.
 	 */
 	bool				assigned;
+	bool				nested;
 	struct arm_smmu_s1_cfg		*s1_cfg;
 	struct arm_smmu_s2_cfg		*s2_cfg;
 };
@@ -629,10 +635,8 @@ struct arm_smmu_domain {
 	struct io_pgtable_ops		*pgtbl_ops;
 
 	enum arm_smmu_domain_stage	stage;
-	union {
-		struct arm_smmu_s1_cfg	s1_cfg;
-		struct arm_smmu_s2_cfg	s2_cfg;
-	};
+	struct arm_smmu_s1_cfg	s1_cfg;
+	struct arm_smmu_s2_cfg	s2_cfg;
 
 	struct iommu_domain		domain;
 
@@ -1119,10 +1123,11 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
 			break;
 		case STRTAB_STE_0_CFG_S1_TRANS:
 		case STRTAB_STE_0_CFG_S2_TRANS:
+		case STRTAB_STE_0_CFG_NESTED:
 			ste_live = true;
 			break;
 		case STRTAB_STE_0_CFG_ABORT:
-			if (disable_bypass)
+			if (disable_bypass || ste->nested)
 				break;
 		default:
 			BUG(); /* STE corruption */
@@ -1134,7 +1139,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
 
 	/* Bypass/fault */
 	if (!ste->assigned || !(ste->s1_cfg || ste->s2_cfg)) {
-		if (!ste->assigned && disable_bypass)
+		if ((!ste->assigned && disable_bypass) ||
+				(ste->s1_cfg && ste->s1_cfg->nested_abort))
 			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
 		else
 			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
@@ -1152,8 +1158,17 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
 		return;
 	}
 
+	if (ste->nested && ste_live) {
+		/*
+		 * When enabling nested, the STE may be transitionning from
+		 * s2 to nested and back. Invalidate the STE before changing it.
+		 */
+		dst[0] = cpu_to_le64(0);
+		arm_smmu_sync_ste_for_sid(smmu, sid);
+		val = STRTAB_STE_0_V;
+	}
+
 	if (ste->s1_cfg) {
-		BUG_ON(ste_live);
 		dst[1] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 			 FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
@@ -1167,12 +1182,12 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
 		   !(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
 			dst[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
 
-		val |= (ste->s1_cfg->cdptr_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
-			FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS);
+		if (!ste->s1_cfg->nested_bypass)
+			val |= (ste->s1_cfg->cdptr_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
+				FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS);
 	}
 
 	if (ste->s2_cfg) {
-		BUG_ON(ste_live);
 		dst[2] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_2_S2VMID, ste->s2_cfg->vmid) |
 			 FIELD_PREP(STRTAB_STE_2_VTCR, ste->s2_cfg->vtcr) |
@@ -1438,6 +1453,10 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
 		cmd.tlbi.asid	= smmu_domain->s1_cfg.cd.asid;
 		cmd.tlbi.vmid	= 0;
+	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED) {
+		cmd.opcode      = CMDQ_OP_TLBI_NH_ASID;
+		cmd.tlbi.asid   = smmu_domain->s1_cfg.cd.asid;
+		cmd.tlbi.vmid   = smmu_domain->s2_cfg.vmid;
 	} else {
 		cmd.opcode	= CMDQ_OP_TLBI_S12_VMALL;
 		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
@@ -1462,6 +1481,10 @@ static void arm_smmu_tlb_inv_range_nosync(unsigned long iova, size_t size,
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
 		cmd.opcode	= CMDQ_OP_TLBI_NH_VA;
 		cmd.tlbi.asid	= smmu_domain->s1_cfg.cd.asid;
+	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED) {
+		cmd.opcode      = CMDQ_OP_TLBI_NH_VA;
+		cmd.tlbi.asid   = smmu_domain->s1_cfg.cd.asid;
+		cmd.tlbi.vmid   = smmu_domain->s2_cfg.vmid;
 	} else {
 		cmd.opcode	= CMDQ_OP_TLBI_S2_IPA;
 		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
-- 
2.17.1
