Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEAA1DE884;
	Wed, 19 Mar 2025 17:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742405604; cv=none; b=OWaxWpfFS6SQohjcrLW0yRqMM+Yf6a3u8RccvXwkX++W+Sav68Kzjvoz5i4yYe28WOi8rGWtDyCWbI+AZG85p/Kj8p+U4vmsfWK3zvkYoHliLldycwxdnpCSzznWd16hFPwPNPFVxMMyUKHMqU7FeczRgHqqAeyYLNooOBA+Nu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742405604; c=relaxed/simple;
	bh=m/NNdtzk5cS5D4HgwovG9RtA7k/ey6JoZn/tt6UJ9r4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VuVF7GfIwpdz2Ez4Q6ih2qHf/B++4ljNVYjFOqHrAUgizh3xGDQ+Y6VHp3fLEtPvFpxio43m0nmp7DLucd5h2gQ6+ED8VrOQ4MTnmZ+NgUQxWXW691ZF3vvw9M0DzlVXfzpgHufH1mX9nY+IdJypvNJK7iz3HX1g/NWG1O8wTaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZHwhc5WzJz67GVD;
	Thu, 20 Mar 2025 01:30:24 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 667551402A5;
	Thu, 20 Mar 2025 01:33:20 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.203.177.241) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 19 Mar 2025 18:33:13 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>
CC: <linuxarm@huawei.com>, <kevin.tian@intel.com>, <jgg@ziepe.ca>,
	<alex.williamson@redhat.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<will@kernel.org>, <robin.murphy@arm.com>, <nicolinc@nvidia.com>,
	<jean-philippe@linaro.org>, <jonathan.cameron@huawei.com>
Subject: [RFC PATCH v3 4/5] iommu/arm-smmu-v3-iommufd: Use KVM VMID for s2 stage
Date: Wed, 19 Mar 2025 17:32:01 +0000
Message-ID: <20250319173202.78988-5-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20250319173202.78988-1-shameerali.kolothum.thodi@huawei.com>
References: <20250319173202.78988-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 frapeml500008.china.huawei.com (7.182.85.71)

If kvm is available make use of kvm pinned VMID on BTM
enabled systems to set the s2 stage VMID for nested
domains.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 53 +++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  1 +
 2 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index ee2fac5c899b..79fcb903741f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
  */
 
+#include <linux/kvm_host.h>
 #include <uapi/linux/iommufd.h>
 
 #include "arm-smmu-v3.h"
@@ -39,6 +40,48 @@ arm_smmu_get_msi_mapping_domain(struct iommu_domain *domain)
 	return &nested_domain->vsmmu->s2_parent->domain;
 }
 
+static int arm_vsmmu_alloc_vmid(struct arm_smmu_device *smmu, struct kvm *kvm,
+				bool *kvm_used)
+{
+#ifdef CONFIG_KVM
+	/*
+	 * There can only be one allocator for VMIDs active at once. If BTM is
+	 * turned on then KVM's allocator always supplies the VMID, and the
+	 * VMID is matched by CPU invalidation of the KVM S2. Right now there
+	 * is no API to get an unused VMID from KVM so this also means BTM systems
+	 * cannot support S2 without an associated KVM.
+	 */
+	if ((smmu->features & ARM_SMMU_FEAT_BTM)) {
+		int vmid;
+
+		if (!kvm || !kvm_get_kvm_safe(kvm))
+			return -EOPNOTSUPP;
+		vmid = kvm_arm_pinned_vmid_get(kvm);
+		if (vmid < 0)
+			kvm_put_kvm(kvm);
+		else
+			*kvm_used = true;
+		return vmid;
+	}
+#endif
+	return ida_alloc_range(&smmu->vmid_map, 1, (1 << smmu->vmid_bits) - 1,
+			       GFP_KERNEL);
+}
+
+static void arm_vsmmu_free_vmid(struct arm_smmu_device *smmu, u16 vmid,
+				struct kvm *kvm)
+{
+#ifdef CONFIG_KVM
+	if ((smmu->features & ARM_SMMU_FEAT_BTM)) {
+		if (kvm) {
+			kvm_arm_pinned_vmid_put(kvm);
+			return kvm_put_kvm(kvm);
+		}
+	}
+#endif
+	ida_free(&smmu->vmid_map, vmid);
+}
+
 static void arm_vsmmu_destroy(struct iommufd_viommu *viommu)
 {
 	struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
@@ -53,7 +96,7 @@ static void arm_vsmmu_destroy(struct iommufd_viommu *viommu)
 	list_del(&vsmmu->vsmmus_elm);
 	spin_unlock_irqrestore(&vsmmu->s2_parent->vsmmus.lock, flags);
 	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
-	ida_free(&smmu->vmid_map, vsmmu->vmid);
+	arm_vsmmu_free_vmid(smmu, vsmmu->vmid, vsmmu->kvm);
 }
 
 static void arm_smmu_make_nested_cd_table_ste(
@@ -379,6 +422,7 @@ struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
 		iommu_get_iommu_dev(dev, struct arm_smmu_device, iommu);
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_domain *s2_parent = to_smmu_domain(parent);
+	bool kvm_used = false;
 	struct arm_vsmmu *vsmmu;
 	unsigned long flags;
 	int vmid;
@@ -409,21 +453,22 @@ struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
 	    !(smmu->features & ARM_SMMU_FEAT_S2FWB))
 		return ERR_PTR(-EOPNOTSUPP);
 
-	vmid = ida_alloc_range(&smmu->vmid_map, 1, (1 << smmu->vmid_bits) - 1,
-			       GFP_KERNEL);
+	vmid = arm_vsmmu_alloc_vmid(smmu, kvm, &kvm_used);
 	if (vmid < 0)
 		return ERR_PTR(vmid);
 
 	vsmmu = iommufd_viommu_alloc(ictx, struct arm_vsmmu, core,
 				     &arm_vsmmu_ops);
 	if (IS_ERR(vsmmu)) {
-		ida_free(&smmu->vmid_map, vmid);
+		arm_vsmmu_free_vmid(smmu, vmid, kvm);
 		return ERR_CAST(vsmmu);
 	}
 
 	vsmmu->smmu = smmu;
 	vsmmu->vmid = (u16)vmid;
 	vsmmu->s2_parent = s2_parent;
+	if (kvm_used)
+		vsmmu->kvm = kvm;
 	spin_lock_irqsave(&s2_parent->vsmmus.lock, flags);
 	list_add_tail(&vsmmu->vsmmus_elm, &s2_parent->vsmmus.list);
 	spin_unlock_irqrestore(&s2_parent->vsmmus.lock, flags);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 9f49de52a700..5890c233f73b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1053,6 +1053,7 @@ struct arm_vsmmu {
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *s2_parent;
 	u16 vmid;
+	struct kvm *kvm;
 
 	struct list_head vsmmus_elm; /* arm_smmu_domain::vsmmus::list */
 };
-- 
2.47.0

