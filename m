Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238A5C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 10:45:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B8E3B6109E
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 10:45:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B8E3B6109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4967D4B08B;
	Wed, 27 Oct 2021 06:45:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LCiz8V1Y0dn8; Wed, 27 Oct 2021 06:45:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 828614B092;
	Wed, 27 Oct 2021 06:45:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 460C84A19A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 06:45:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kzSNIpVA+BgR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 06:45:28 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0434A4A3BF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 06:45:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635331527;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=dqSepvb2YiqoeKHY293Z6dXyQ5qrifJdEOlDVnVYd+E=;
 b=O4b0Bktxp1U7zoBGQ5GpjZhAv6iVBDQEeoOo7eEd7vQdB5FQs++jx1iYzEpfpF4nTu4LmP
 aWMozMnyg/3BBMtubj+7e9d53jt7+DXX0k6vKdmYN0KcV3WMt17tUr0aZ8IEKiuQ3+jjQi
 O8nJ3hfzLwxmA50aXaFRKAHY7w+XBGw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-1XhAUh16NcaPLx3qAevXIg-1; Wed, 27 Oct 2021 06:45:24 -0400
X-MC-Unique: 1XhAUh16NcaPLx3qAevXIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D4DA80A5C1;
 Wed, 27 Oct 2021 10:45:20 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.154])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 5315F10016FE;
 Wed, 27 Oct 2021 10:45:10 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
 zhukeqian1@huawei.com
Subject: [RFC v16 3/9] iommu/smmuv3: Allow s1 and s2 configs to coexist
Date: Wed, 27 Oct 2021 12:44:22 +0200
Message-Id: <20211027104428.1059740-4-eric.auger@redhat.com>
In-Reply-To: <20211027104428.1059740-1-eric.auger@redhat.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: kevin.tian@intel.com, jacob.jun.pan@linux.intel.com, ashok.raj@intel.com,
 chenxiang66@hisilicon.com, maz@kernel.org, vdumpa@nvidia.com,
 nicoleotsuka@gmail.com, vivek.gautam@arm.com, alex.williamson@redhat.com,
 yi.l.liu@intel.com, nicolinc@nvidia.com, vsethi@nvidia.com,
 zhangfei.gao@linaro.org, sumitg@nvidia.com, lushenming@huawei.com,
 wangxingang5@huawei.com
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

In true nested mode, both s1_cfg and s2_cfg will coexist.
Let's remove the union and add a "set" field in each
config structure telling whether the config is set and needs
to be applied when writing the STE. In legacy nested mode,
only the second stage is used. In true nested mode, both stages
are used and the S1 config is "set" when the guest passes
its pasid table.

No functional change intended.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v13 -> v14:
- slight reword of the commit message

v12 -> v13:
- does not dynamically allocate s1-cfg and s2_cfg anymore. Add
  the set field
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 43 +++++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  8 ++--
 2 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 61477853a536..b8384a834552 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1254,8 +1254,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	u64 val = le64_to_cpu(dst[0]);
 	bool ste_live = false;
 	struct arm_smmu_device *smmu = NULL;
-	struct arm_smmu_s1_cfg *s1_cfg = NULL;
-	struct arm_smmu_s2_cfg *s2_cfg = NULL;
+	struct arm_smmu_s1_cfg *s1_cfg;
+	struct arm_smmu_s2_cfg *s2_cfg;
 	struct arm_smmu_domain *smmu_domain = NULL;
 	struct arm_smmu_cmdq_ent prefetch_cmd = {
 		.opcode		= CMDQ_OP_PREFETCH_CFG,
@@ -1270,13 +1270,24 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	}
 
 	if (smmu_domain) {
+		s1_cfg = &smmu_domain->s1_cfg;
+		s2_cfg = &smmu_domain->s2_cfg;
+
 		switch (smmu_domain->stage) {
 		case ARM_SMMU_DOMAIN_S1:
-			s1_cfg = &smmu_domain->s1_cfg;
+			s1_cfg->set = true;
+			s2_cfg->set = false;
 			break;
 		case ARM_SMMU_DOMAIN_S2:
+			s1_cfg->set = false;
+			s2_cfg->set = true;
+			break;
 		case ARM_SMMU_DOMAIN_NESTED:
-			s2_cfg = &smmu_domain->s2_cfg;
+			/*
+			 * Actual usage of stage 1 depends on nested mode:
+			 * legacy (2d stage only) or true nested mode
+			 */
+			s2_cfg->set = true;
 			break;
 		default:
 			break;
@@ -1303,7 +1314,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	val = STRTAB_STE_0_V;
 
 	/* Bypass/fault */
-	if (!smmu_domain || !(s1_cfg || s2_cfg)) {
+	if (!smmu_domain || !(s1_cfg->set || s2_cfg->set)) {
 		if (!smmu_domain && disable_bypass)
 			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
 		else
@@ -1322,7 +1333,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		return;
 	}
 
-	if (s1_cfg) {
+	if (s1_cfg->set) {
 		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
 			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
 
@@ -1344,7 +1355,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 			FIELD_PREP(STRTAB_STE_0_S1FMT, s1_cfg->s1fmt);
 	}
 
-	if (s2_cfg) {
+	if (s2_cfg->set) {
 		BUG_ON(ste_live);
 		dst[2] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
@@ -2036,23 +2047,23 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	struct arm_smmu_s1_cfg *s1_cfg = &smmu_domain->s1_cfg;
+	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
 
 	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
 
 	/* Free the CD and ASID, if we allocated them */
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
-		struct arm_smmu_s1_cfg *cfg = &smmu_domain->s1_cfg;
-
+	if (s1_cfg->set) {
 		/* Prevent SVA from touching the CD while we're freeing it */
 		mutex_lock(&arm_smmu_asid_lock);
-		if (cfg->cdcfg.cdtab)
+		if (s1_cfg->cdcfg.cdtab)
 			arm_smmu_free_cd_tables(smmu_domain);
-		arm_smmu_free_asid(&cfg->cd);
+		arm_smmu_free_asid(&s1_cfg->cd);
 		mutex_unlock(&arm_smmu_asid_lock);
-	} else {
-		struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
-		if (cfg->vmid)
-			arm_smmu_bitmap_free(smmu->vmid_map, cfg->vmid);
+	}
+	if (s2_cfg->set) {
+		if (s2_cfg->vmid)
+			arm_smmu_bitmap_free(smmu->vmid_map, s2_cfg->vmid);
 	}
 
 	kfree(smmu_domain);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4cb136f07914..db1a84d24e30 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -597,12 +597,14 @@ struct arm_smmu_s1_cfg {
 	struct arm_smmu_ctx_desc	cd;
 	u8				s1fmt;
 	u8				s1cdmax;
+	bool				set;
 };
 
 struct arm_smmu_s2_cfg {
 	u16				vmid;
 	u64				vttbr;
 	u64				vtcr;
+	bool				set;
 };
 
 struct arm_smmu_strtab_cfg {
@@ -716,10 +718,8 @@ struct arm_smmu_domain {
 	atomic_t			nr_ats_masters;
 
 	enum arm_smmu_domain_stage	stage;
-	union {
-		struct arm_smmu_s1_cfg	s1_cfg;
-		struct arm_smmu_s2_cfg	s2_cfg;
-	};
+	struct arm_smmu_s1_cfg	s1_cfg;
+	struct arm_smmu_s2_cfg	s2_cfg;
 
 	struct iommu_domain		domain;
 
-- 
2.26.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
