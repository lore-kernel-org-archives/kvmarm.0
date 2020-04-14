Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EFFBC2BA19
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 15:07:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 59DB62076D
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 15:07:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VR4V7gUX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59DB62076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBA514B0CE;
	Tue, 14 Apr 2020 11:07:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id na8J1jY+IIXb; Tue, 14 Apr 2020 11:07:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCB1A4B144;
	Tue, 14 Apr 2020 11:07:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44D484B0C9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 11:07:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PFNRTP0hTScI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 11:07:42 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D84F4B0C1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 11:07:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586876862;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=AGZKlh4Y3iYusjFkAozB1BrSL7TWS1xxMSS4nCN5u3I=;
 b=VR4V7gUXvadkobUxCScdU2uzItLUf8N9ipgFVNcy9l4Q3TkmJYRwrzB5QKo5CcmYu/HZtY
 BVGZqHRBlF5QagNj5bm8mXj8iIf/3xQU15rTe9RolNxFoDPuNpeIRBxROtUzjEojsZPq+J
 sHfNgcRxMxOws1rUHoZtgaRYgaQcGnw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-oN7FE4DZPF2iCVNJOZ74QA-1; Tue, 14 Apr 2020 11:07:32 -0400
X-MC-Unique: oN7FE4DZPF2iCVNJOZ74QA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E2D38017F5;
 Tue, 14 Apr 2020 15:07:29 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-53.ams2.redhat.com [10.36.115.53])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 1840F271A3;
 Tue, 14 Apr 2020 15:07:24 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
 joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com
Subject: [PATCH v11 07/13] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
Date: Tue, 14 Apr 2020 17:06:01 +0200
Message-Id: <20200414150607.28488-8-eric.auger@redhat.com>
In-Reply-To: <20200414150607.28488-1-eric.auger@redhat.com>
References: <20200414150607.28488-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 zhangfei.gao@foxmail.com, alex.williamson@redhat.com, yi.l.liu@intel.com,
 zhangfei.gao@linaro.org, bbhushan2@marvell.com
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
 drivers/iommu/arm-smmu-v3.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 21bcf2536320..4ec2106be301 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2307,13 +2307,18 @@ static int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
 }
 
 /* IO_PGTABLE API */
-static void arm_smmu_tlb_inv_context(void *cookie)
+
+static void __arm_smmu_tlb_inv_context(struct arm_smmu_domain *smmu_domain,
+				       int ext_asid)
 {
-	struct arm_smmu_domain *smmu_domain = cookie;
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 	struct arm_smmu_cmdq_ent cmd;
 
-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+	if (ext_asid >= 0) { /* guest stage 1 invalidation */
+		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
+		cmd.tlbi.asid	= ext_asid;
+		cmd.tlbi.vmid	= smmu_domain->s2_cfg->vmid;
+	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
 		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
 		cmd.tlbi.asid	= smmu_domain->s1_cfg->cd.asid;
 		cmd.tlbi.vmid	= 0;
@@ -2334,9 +2339,17 @@ static void arm_smmu_tlb_inv_context(void *cookie)
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
@@ -2351,7 +2364,11 @@ static void arm_smmu_tlb_inv_range(unsigned long iova, size_t size,
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
@@ -2411,6 +2428,13 @@ static void arm_smmu_tlb_inv_range(unsigned long iova, size_t size,
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
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
