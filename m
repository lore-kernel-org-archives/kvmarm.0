Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B371C5519F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 10:44:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EA5722223C
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 10:44:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AwuiZlDj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA5722223C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DE044BF91;
	Mon, 16 Nov 2020 05:44:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SZvFTQG-zE+I; Mon, 16 Nov 2020 05:44:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87C464BFB7;
	Mon, 16 Nov 2020 05:44:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10B4D4BF91
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 05:44:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fS7OnNvpDKOL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 05:44:21 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D1014B822
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 05:44:21 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1605523460;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tsefOJadPA1aocTAGfXJUDZXHqV0tACZcG8qI+p638w=;
 b=AwuiZlDj+592OdRijO4QBdiB1j6amYAiLlBJNIBwo4rDPeJ/tWr5fwJhK2jVxL94GH2xnB
 GAWwFqJ1a3/0/DQPwOtJ9kUlrWAm5EEl8mTsUmFEx+TsFE2PUCctIIWGSwAZltF0COI4EG
 gwXsA1azqhcdIenoxrxumVJY9HbGdDo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-F5SNU774Mnym7SbeLQ6j2A-1; Mon, 16 Nov 2020 05:44:17 -0500
X-MC-Unique: F5SNU774Mnym7SbeLQ6j2A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDC795F9CA;
 Mon, 16 Nov 2020 10:44:14 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-113-230.ams2.redhat.com [10.36.113.230])
 by smtp.corp.redhat.com (Postfix) with ESMTP id AD6FE5C5FE;
 Mon, 16 Nov 2020 10:44:10 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
 joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com
Subject: [PATCH v12 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
Date: Mon, 16 Nov 2020 11:43:08 +0100
Message-Id: <20201116104316.31816-8-eric.auger@redhat.com>
In-Reply-To: <20201116104316.31816-1-eric.auger@redhat.com>
References: <20201116104316.31816-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 nicoleotsuka@gmail.com, vivek.gautam@arm.com, alex.williamson@redhat.com,
 yi.l.liu@intel.com, zhangfei.gao@linaro.org
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

With nested stage support, soon we will need to invalidate
S1 contexts and ranges tagged with an unmanaged asid, this
latter being managed by the guest. So let's introduce 2 helpers
that allow to invalidate with externally managed ASIDs

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 35 +++++++++++++++++----
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 08ab0dd81049..73f7a56101dd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1679,9 +1679,9 @@ static int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
 }
 
 /* IO_PGTABLE API */
-static void arm_smmu_tlb_inv_context(void *cookie)
+static void __arm_smmu_tlb_inv_context(struct arm_smmu_domain *smmu_domain,
+				       int ext_asid)
 {
-	struct arm_smmu_domain *smmu_domain = cookie;
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 	struct arm_smmu_cmdq_ent cmd;
 
@@ -1692,7 +1692,11 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	 * insertion to guarantee those are observed before the TLBI. Do be
 	 * careful, 007.
 	 */
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+	if (ext_asid >= 0) { /* guest stage 1 invalidation */
+		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
+		cmd.tlbi.asid	= ext_asid;
+		cmd.tlbi.vmid	= smmu_domain->s2_cfg->vmid;
+	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
 		arm_smmu_tlb_inv_asid(smmu, smmu_domain->s1_cfg->cd.asid);
 	} else {
 		cmd.opcode	= CMDQ_OP_TLBI_S12_VMALL;
@@ -1703,9 +1707,17 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	arm_smmu_atc_inv_domain(smmu_domain, 0, 0, 0);
 }
 
-static void arm_smmu_tlb_inv_range(unsigned long iova, size_t size,
+static void arm_smmu_tlb_inv_context(void *cookie)
+{
+	struct arm_smmu_domain *smmu_domain = cookie;
+
+	__arm_smmu_tlb_inv_context(smmu_domain, -1);
+}
+
+static void __arm_smmu_tlb_inv_range(unsigned long iova, size_t size,
 				   size_t granule, bool leaf,
-				   struct arm_smmu_domain *smmu_domain)
+				   struct arm_smmu_domain *smmu_domain,
+				   int ext_asid)
 {
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 	unsigned long start = iova, end = iova + size, num_pages = 0, tg = 0;
@@ -1720,7 +1732,11 @@ static void arm_smmu_tlb_inv_range(unsigned long iova, size_t size,
 	if (!size)
 		return;
 
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+	if (ext_asid >= 0) {  /* guest stage 1 invalidation */
+		cmd.opcode	= CMDQ_OP_TLBI_NH_VA;
+		cmd.tlbi.asid	= ext_asid;
+		cmd.tlbi.vmid	= smmu_domain->s2_cfg->vmid;
+	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
 		cmd.opcode	= CMDQ_OP_TLBI_NH_VA;
 		cmd.tlbi.asid	= smmu_domain->s1_cfg->cd.asid;
 	} else {
@@ -1780,6 +1796,13 @@ static void arm_smmu_tlb_inv_range(unsigned long iova, size_t size,
 	arm_smmu_atc_inv_domain(smmu_domain, 0, start, size);
 }
 
+static void arm_smmu_tlb_inv_range(unsigned long iova, size_t size,
+				   size_t granule, bool leaf,
+				   struct arm_smmu_domain *smmu_domain)
+{
+	__arm_smmu_tlb_inv_range(iova, size, granule, leaf, smmu_domain, -1);
+}
+
 static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
 					 unsigned long iova, size_t granule,
 					 void *cookie)
-- 
2.21.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
