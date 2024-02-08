Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178C71E525;
	Thu,  8 Feb 2024 15:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707405688; cv=none; b=s2NhFmZVn1eo0pZJUSb8ua6eMLjT263kNJ2p6BM49aYKlHYnhCj6LNXnb+3HKedl3yqeH4lg89+jKTtFH4Z+PuGT4m605aFsLiEjd8DkwztS4M/SB7khU+Q8ie5PiAgrnYGOcBIa2p8wLAd6ogeYAcSbSHSudTD9C7YjBQr45Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707405688; c=relaxed/simple;
	bh=Bs2BSm3MV95jmms0H6CEfwvr4HlzmQUumrWqUm0go9Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cud2ntBNMFCItzAdBhk18Ae8xzucVfyr4Fmt0NPBBH91/+br8IptALLAKpqeqvnT42K+VIB4EkPaaLaQeeN1vSrSYvj+p10k0T2F+k/mpraHomiY/N7DgPG7dgKcH+G5bpKVaMgNq2dpwQyfnwZd9xxtujwWHwRYJSmju38wpN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TW0wq2MMvz6K5lR;
	Thu,  8 Feb 2024 23:18:03 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 40BBB140595;
	Thu,  8 Feb 2024 23:21:25 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.202.227.28) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 8 Feb 2024 15:21:18 +0000
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
CC: <kevin.tian@intel.com>, <jgg@ziepe.ca>, <alex.williamson@redhat.com>,
	<maz@kernel.org>, <oliver.upton@linux.dev>, <will@kernel.org>,
	<robin.murphy@arm.com>, <jean-philippe@linaro.org>,
	<jonathan.cameron@huawei.com>
Subject: [RFC PATCH v2 5/7] iommu: Pass in kvm pointer to domain_alloc_user
Date: Thu, 8 Feb 2024 15:18:35 +0000
Message-ID: <20240208151837.35068-6-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

No functional changes.

This will be used in a later patch to add support to use
KVM VMID in ARM SMMUv3 s2 stage configuration.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/iommu/amd/iommu.c                   | 1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 1 +
 drivers/iommu/intel/iommu.c                 | 1 +
 drivers/iommu/iommufd/hw_pagetable.c        | 5 +++--
 drivers/iommu/iommufd/selftest.c            | 1 +
 include/linux/iommu.h                       | 3 ++-
 6 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 4283dd8191f0..75e0f4e9253a 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2244,6 +2244,7 @@ static struct iommu_domain *amd_iommu_domain_alloc(unsigned int type)
 static struct iommu_domain *
 amd_iommu_domain_alloc_user(struct device *dev, u32 flags,
 			    struct iommu_domain *parent,
+			    struct kvm *kvm,
 			    const struct iommu_user_data *user_data)
 
 {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0606166a8781..b41d77787a2f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3190,6 +3190,7 @@ arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
 static struct iommu_domain *
 arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 			   struct iommu_domain *parent,
+			   struct kvm *kvm,
 			   const struct iommu_user_data *user_data)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 6fb5f6fceea1..992a2f233198 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3877,6 +3877,7 @@ static struct iommu_domain *intel_iommu_domain_alloc(unsigned type)
 static struct iommu_domain *
 intel_iommu_domain_alloc_user(struct device *dev, u32 flags,
 			      struct iommu_domain *parent,
+			      struct kvm *kvm,
 			      const struct iommu_user_data *user_data)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 3f3f1fa1a0a9..1efc4ef863ac 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -129,7 +129,7 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 
 	if (ops->domain_alloc_user) {
 		hwpt->domain = ops->domain_alloc_user(idev->dev, flags, NULL,
-						      user_data);
+						      ictx->kvm, user_data);
 		if (IS_ERR(hwpt->domain)) {
 			rc = PTR_ERR(hwpt->domain);
 			hwpt->domain = NULL;
@@ -228,7 +228,8 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
 	hwpt_nested->parent = parent;
 
 	hwpt->domain = ops->domain_alloc_user(idev->dev, flags,
-					      parent->common.domain, user_data);
+					      parent->common.domain,
+					      ictx->kvm, user_data);
 	if (IS_ERR(hwpt->domain)) {
 		rc = PTR_ERR(hwpt->domain);
 		hwpt->domain = NULL;
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index d9e9920c7eba..483bb7216235 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -269,6 +269,7 @@ __mock_domain_alloc_nested(struct mock_iommu_domain *mock_parent,
 static struct iommu_domain *
 mock_domain_alloc_user(struct device *dev, u32 flags,
 		       struct iommu_domain *parent,
+		       struct kvm *kvm,
 		       const struct iommu_user_data *user_data)
 {
 	struct mock_iommu_domain *mock_parent;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 1446e3718642..ad14cdc22863 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -43,6 +43,7 @@ struct notifier_block;
 struct iommu_sva;
 struct iommu_fault_event;
 struct iommu_dma_cookie;
+struct kvm;
 
 /* iommu fault flags */
 #define IOMMU_FAULT_READ	0x0
@@ -458,7 +459,7 @@ struct iommu_ops {
 	struct iommu_domain *(*domain_alloc)(unsigned iommu_domain_type);
 	struct iommu_domain *(*domain_alloc_user)(
 		struct device *dev, u32 flags, struct iommu_domain *parent,
-		const struct iommu_user_data *user_data);
+		struct kvm *kvm, const struct iommu_user_data *user_data);
 	struct iommu_domain *(*domain_alloc_paging)(struct device *dev);
 	struct iommu_domain *(*domain_alloc_sva)(struct device *dev,
 						 struct mm_struct *mm);
-- 
2.34.1

