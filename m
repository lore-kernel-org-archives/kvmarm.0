From: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v3 09/21] iommu/smmuv3: Get prepared for nested stage support
Date: Tue,  8 Jan 2019 11:26:21 +0100
Message-ID: <20190108102633.17482-10-eric.auger@redhat.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20190108102633.17482-1-eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yi.l.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org
Cc: marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christoffer.dall-5wv7dgnIgG8@public.gmane.org
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

Signed-off-by: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---

v1 -> v2:
- invalidate the STE before moving from a live STE config to another
- add the nested_abort and nested_bypass fields
---
 drivers/iommu/arm-smmu-v3.c | 43 ++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 9af68266bbb1..9716a301d9ae 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -212,6 +212,7 @@
 #define STRTAB_STE_0_CFG_BYPASS		4
 #define STRTAB_STE_0_CFG_S1_TRANS	5
 #define STRTAB_STE_0_CFG_S2_TRANS	6
+#define STRTAB_STE_0_CFG_NESTED		7
 
 #define STRTAB_STE_0_S1FMT		GENMASK_ULL(5, 4)
 #define STRTAB_STE_0_S1FMT_LINEAR	0
@@ -491,6 +492,10 @@ struct arm_smmu_strtab_l1_desc {
 struct arm_smmu_s1_cfg {
 	__le64				*cdptr;
 	dma_addr_t			cdptr_dma;
+	/* in nested mode, tells s1 must be bypassed */
+	bool				nested_bypass;
+	/* in nested mode, abort is forced by guest */
+	bool				nested_abort;
 
 	struct arm_smmu_ctx_desc {
 		u16	asid;
@@ -515,6 +520,7 @@ struct arm_smmu_strtab_ent {
 	 * configured according to the domain type.
 	 */
 	bool				assigned;
+	bool				nested;
 	struct arm_smmu_s1_cfg		*s1_cfg;
 	struct arm_smmu_s2_cfg		*s2_cfg;
 };
@@ -629,10 +635,8 @@ struct arm_smmu_domain {
 	bool				non_strict;
 
 	enum arm_smmu_domain_stage	stage;
-	union {
-		struct arm_smmu_s1_cfg	s1_cfg;
-		struct arm_smmu_s2_cfg	s2_cfg;
-	};
+	struct arm_smmu_s1_cfg	s1_cfg;
+	struct arm_smmu_s2_cfg	s2_cfg;
 
 	struct iommu_domain		domain;
 
@@ -1139,10 +1143,11 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
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
@@ -1154,7 +1159,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
 
 	/* Bypass/fault */
 	if (!ste->assigned || !(ste->s1_cfg || ste->s2_cfg)) {
-		if (!ste->assigned && disable_bypass)
+		if ((!ste->assigned && disable_bypass) ||
+				(ste->s1_cfg && ste->s1_cfg->nested_abort))
 			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
 		else
 			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
@@ -1172,8 +1178,17 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
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
@@ -1187,12 +1202,12 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
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
@@ -1454,6 +1469,10 @@ static void arm_smmu_tlb_inv_context(void *cookie)
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
@@ -1484,6 +1503,10 @@ static void arm_smmu_tlb_inv_range_nosync(unsigned long iova, size_t size,
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
2.17.2
