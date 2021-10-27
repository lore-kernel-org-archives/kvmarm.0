Return-Path: <SRS0=suDQ=PP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F244C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 10:47:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A86D8608FE
	for <kvmarm@archiver.kernel.org>; Wed, 27 Oct 2021 10:47:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A86D8608FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5856F4B15C;
	Wed, 27 Oct 2021 06:47:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q18iZppkPZrI; Wed, 27 Oct 2021 06:47:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED9004B099;
	Wed, 27 Oct 2021 06:47:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00B784B08E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 06:47:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2SSIUaxI6QqN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Oct 2021 06:47:05 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B965402A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Oct 2021 06:47:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1635331624;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=4jf1m3TJlglHhUX7yLsviN+p9FvmvAmCzhSZjHu7gUY=;
 b=WIIKk3eg3EK66drsfhKARbhvRmbYvn8BYIMkvKZ223xCowyAl5q1mXRyzByK9kNQhecfEd
 K/gTfU/tf7n2kW8jCwr+OFuE7rKMDBtuYz70OiznhwYH518diDwEN7H/23qRn73qJvhJ9y
 83C7nyn0THPDOMHcOSG5ypjSBpJjGCQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-sitbeS-9M3-FpXC8aIuiYQ-1; Wed, 27 Oct 2021 06:47:01 -0400
X-MC-Unique: sitbeS-9M3-FpXC8aIuiYQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B597D89CD12;
 Wed, 27 Oct 2021 10:46:57 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.154])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 571721042AEE;
 Wed, 27 Oct 2021 10:46:40 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
 zhukeqian1@huawei.com
Subject: [RFC v16 9/9] iommu/smmuv3: Disallow nested mode in presence of HW
 MSI regions
Date: Wed, 27 Oct 2021 12:44:28 +0200
Message-Id: <20211027104428.1059740-10-eric.auger@redhat.com>
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

Nested mode currently is not compatible with HW MSI reserved regions.
Indeed MSI transactions targeting those MSI doorbells bypass the SMMU.
This would require the guest to also bypass those ranges but the guest
has no information about them.

Let's check nested mode is not attempted in such configuration.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 23 +++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ddfc069c10ae..12e7d7920f27 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2488,6 +2488,23 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 	arm_smmu_install_ste_for_dev(master);
 }
 
+static bool arm_smmu_has_hw_msi_resv_region(struct device *dev)
+{
+	struct iommu_resv_region *region;
+	bool has_msi_resv_region = false;
+	LIST_HEAD(resv_regions);
+
+	iommu_get_resv_regions(dev, &resv_regions);
+	list_for_each_entry(region, &resv_regions, list) {
+		if (region->type == IOMMU_RESV_MSI) {
+			has_msi_resv_region = true;
+			break;
+		}
+	}
+	iommu_put_resv_regions(dev, &resv_regions);
+	return has_msi_resv_region;
+}
+
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	int ret = 0;
@@ -2545,6 +2562,12 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		ret = -EINVAL;
 		goto out_unlock;
 	}
+	/* Nested mode is not compatible with MSI HW reserved regions */
+	if (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED &&
+	    arm_smmu_has_hw_msi_resv_region(dev)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
 
 	master->domain = smmu_domain;
 
-- 
2.26.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
