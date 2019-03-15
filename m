From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v5 12/22] iommu/smmuv3: Get prepared for nested stage support
Date: Fri, 15 Mar 2019 17:08:56 +0100
Message-ID: <20190315160906.12900-13-eric.auger@redhat.com>
References: <20190315160906.12900-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66B6A4A420
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 12:10:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KWP52KJ7aDhq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Mar 2019 12:10:50 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C0B64A441
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Mar 2019 12:10:50 -0400 (EDT)
In-Reply-To: <20190315160906.12900-1-eric.auger@redhat.com>
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
Cc: kevin.tian@intel.com, vincent.stehle@arm.com, ashok.raj@intel.com, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

To allow nested stage support, we need to store both
stage 1 and stage 2 configurations (and remove the former
union).

A nested setup is characterized by both s1_cfg and s2_cfg
set.

We introduce a new ste.abort field that will be set upon
guest stage1 configuration passing. If s1_cfg is NULL and
ste.abort is set, traffic can't pass. If ste.abort is not set,
S1 is bypassed.

arm_smmu_write_strtab_ent() is modified to write both stage
fields in the STE and deal with the abort field.

In nested mode, only stage 2 is "finalized" as the host does
not own/configure the stage 1 context descriptor, guest does.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v4 -> v5:
- reset ste.abort on detach

v3 -> v4:
- s1_cfg.nested_abort and nested_bypass removed.
- s/ste.nested/ste.abort
- arm_smmu_write_strtab_ent modifications with introduction
  of local abort, bypass and translate local variables
- comment updated

v1 -> v2:
- invalidate the STE before moving from a live STE config to another
- add the nested_abort and nested_bypass fields
---
 drivers/iommu/arm-smmu-v3.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 21d027695181..e22e944ffc05 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -211,6 +211,7 @@
 #define STRTAB_STE_0_CFG_BYPASS		4
 #define STRTAB_STE_0_CFG_S1_TRANS	5
 #define STRTAB_STE_0_CFG_S2_TRANS	6
+#define STRTAB_STE_0_CFG_NESTED		7
 
 #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
 #define STRTAB_STE_0_S1FMT_LINEAR	0
@@ -514,6 +515,7 @@ struct arm_smmu_strtab_ent {
 	 * configured according to the domain type.
 	 */
 	bool				assigned;
+	bool				abort;
 	struct arm_smmu_s1_cfg		*s1_cfg;
 	struct arm_smmu_s2_cfg		*s2_cfg;
 };
@@ -628,10 +630,8 @@ struct arm_smmu_domain {
 	bool				non_strict;
 
 	enum arm_smmu_domain_stage	stage;
-	union {
-		struct arm_smmu_s1_cfg	s1_cfg;
-		struct arm_smmu_s2_cfg	s2_cfg;
-	};
+	struct arm_smmu_s1_cfg	s1_cfg;
+	struct arm_smmu_s2_cfg	s2_cfg;
 
 	struct iommu_domain		domain;
 
@@ -1108,12 +1108,13 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
 				      __le64 *dst, struct arm_smmu_strtab_ent *ste)
 {
 	/*
-	 * This is hideously complicated, but we only really care about
-	 * three cases at the moment:
+	 * We care about the following transitions:
 	 *
 	 * 1. Invalid (all zero) -> bypass/fault (init)
-	 * 2. Bypass/fault -> translation/bypass (attach)
-	 * 3. Translation/bypass -> bypass/fault (detach)
+	 * 2. Bypass/fault -> single stage translation/bypass (attach)
+	 * 3. single stage Translation/bypass -> bypass/fault (detach)
+	 * 4. S2 -> S1 + S2 (attach_pasid_table)
+	 * 5. S1 + S2 -> S2 (detach_pasid_table)
 	 *
 	 * Given that we can't update the STE atomically and the SMMU
 	 * doesn't read the thing in a defined order, that leaves us
@@ -1124,7 +1125,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
 	 * 3. Update Config, sync
 	 */
 	u64 val = le64_to_cpu(dst[0]);
-	bool ste_live = false;
+	bool abort, bypass, translate, ste_live = false;
 	struct arm_smmu_cmdq_ent prefetch_cmd = {
 		.opcode		= CMDQ_OP_PREFETCH_CFG,
 		.prefetch	= {
@@ -1138,11 +1139,11 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
 			break;
 		case STRTAB_STE_0_CFG_S1_TRANS:
 		case STRTAB_STE_0_CFG_S2_TRANS:
+		case STRTAB_STE_0_CFG_NESTED:
 			ste_live = true;
 			break;
 		case STRTAB_STE_0_CFG_ABORT:
-			if (disable_bypass)
-				break;
+			break;
 		default:
 			BUG(); /* STE corruption */
 		}
@@ -1152,8 +1153,13 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
 	val = STRTAB_STE_0_V;
 
 	/* Bypass/fault */
-	if (!ste->assigned || !(ste->s1_cfg || ste->s2_cfg)) {
-		if (!ste->assigned && disable_bypass)
+
+	abort = (!ste->assigned && disable_bypass) || ste->abort;
+	translate = ste->s1_cfg || ste->s2_cfg;
+	bypass = !abort && !translate;
+
+	if (abort || bypass) {
+		if (abort)
 			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
 		else
 			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
@@ -1172,7 +1178,6 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
 	}
 
 	if (ste->s1_cfg) {
-		BUG_ON(ste_live);
 		dst[1] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 			 FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
@@ -1191,7 +1196,6 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
 	}
 
 	if (ste->s2_cfg) {
-		BUG_ON(ste_live);
 		dst[2] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_2_S2VMID, ste->s2_cfg->vmid) |
 			 FIELD_PREP(STRTAB_STE_2_VTCR, ste->s2_cfg->vtcr) |
@@ -1773,6 +1777,7 @@ static void arm_smmu_detach_dev(struct device *dev)
 	}
 
 	master->ste.assigned = false;
+	master->ste.abort = false;
 	arm_smmu_install_ste_for_dev(fwspec);
 }
 
-- 
2.20.1
