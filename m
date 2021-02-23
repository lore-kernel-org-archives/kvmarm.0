Return-Path: <SRS0=rfx0=HZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78083C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 20:59:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 09E1A64E85
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 20:59:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09E1A64E85
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9755D4B191;
	Tue, 23 Feb 2021 15:59:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rzCX3zjKof6P; Tue, 23 Feb 2021 15:59:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A63B4B1E0;
	Tue, 23 Feb 2021 15:59:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E1414B19A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 15:59:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8sPppEuqUk5m for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Feb 2021 15:59:24 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EB164B0F6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 15:59:24 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1614113964;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=kOG5ouxkHwJB92685qf8wFfHRaVUmiy9Jy0UpVAA4qk=;
 b=PksWX4v9X2I+gnoh3xUGv2OzkOoqI9omQIBGd6VSuUeiBoqxSxjlBZ/nkN0aGYUpuWPbv5
 JibHIk0Rs98oUDtyeh8uVwFQONj37qw3idGE8eveF5vJL+v71MwGCbpkTudW6+egYP1nd9
 Xm4Mj2wOHhSiqBWuqZBUmMqGFMdaEgQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-b6LrOC1WOhKPQ2PX5vTztw-1; Tue, 23 Feb 2021 15:59:20 -0500
X-MC-Unique: b6LrOC1WOhKPQ2PX5vTztw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88AFE107ACFC;
 Tue, 23 Feb 2021 20:59:17 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-114-34.ams2.redhat.com [10.36.114.34])
 by smtp.corp.redhat.com (Postfix) with ESMTP id B8D605D9D0;
 Tue, 23 Feb 2021 20:59:01 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
 maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
 alex.williamson@redhat.com, tn@semihalf.com, zhukeqian1@huawei.com
Subject: [PATCH v14 13/13] iommu/smmuv3: Accept configs with more than one
 context descriptor
Date: Tue, 23 Feb 2021 21:56:34 +0100
Message-Id: <20210223205634.604221-14-eric.auger@redhat.com>
In-Reply-To: <20210223205634.604221-1-eric.auger@redhat.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
 wangxingang5@huawei.com, lushenming@huawei.com, nicoleotsuka@gmail.com,
 vivek.gautam@arm.com, yi.l.liu@intel.com, vsethi@nvidia.com,
 zhangfei.gao@linaro.org
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

In preparation for vSVA, let's accept userspace provided configs
with more than one CD. We check the max CD against the host iommu
capability and also the format (linear versus 2 level).

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 332d31c0680f..ab74a0289893 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3038,14 +3038,17 @@ static int arm_smmu_attach_pasid_table(struct iommu_domain *domain,
 		if (smmu_domain->s1_cfg.set)
 			goto out;
 
-		/*
-		 * we currently support a single CD so s1fmt and s1dss
-		 * fields are also ignored
-		 */
-		if (cfg->pasid_bits)
+		list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+			if (cfg->pasid_bits > master->ssid_bits)
+				goto out;
+		}
+		if (cfg->vendor_data.smmuv3.s1fmt == STRTAB_STE_0_S1FMT_64K_L2 &&
+				!(smmu->features & ARM_SMMU_FEAT_2_LVL_CDTAB))
 			goto out;
 
 		smmu_domain->s1_cfg.cdcfg.cdtab_dma = cfg->base_ptr;
+		smmu_domain->s1_cfg.s1cdmax = cfg->pasid_bits;
+		smmu_domain->s1_cfg.s1fmt = cfg->vendor_data.smmuv3.s1fmt;
 		smmu_domain->s1_cfg.set = true;
 		smmu_domain->abort = false;
 		break;
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
