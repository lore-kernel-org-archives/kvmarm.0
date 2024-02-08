Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F8A79940;
	Thu,  8 Feb 2024 15:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707405697; cv=none; b=NkDgohJ752fpWFJKk9fHPly1V0Fn4f5NVNWkmubejAT3oDSqX3bKjkS4QMsL6feoEtlAnDnjcXVZv1ySOUgpmhK8g4BlXCXMNPpU2nLjFF0sAxIFM/RSVfz2nVthV6uggoBWzykn9oKbezbi9AxbriU55+ji6jC0bVz+cH3axWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707405697; c=relaxed/simple;
	bh=tYOmGg/qZ5Sz/7Z5qz4DKJG3+RX4gjqgqmBZEXxyKaE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BRzt7gZT96YVQl3JcGpofjFMhfFTHWwnR/seahASK47xm8tg2HJpFk05etglr/5qRuJejO/2H8ZPqqfJkhTWefM220lbe00AEWlbhVR1ZYxCIBLhhBOyrm0EUeJa1kRBis6Jy78ukLHW5D7nDXoxZo7360pB0muILANg6Hqy4S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TW0wb3l9fz6JB4j;
	Thu,  8 Feb 2024 23:17:51 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 56D82140B2F;
	Thu,  8 Feb 2024 23:21:34 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.202.227.28) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 8 Feb 2024 15:21:27 +0000
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
CC: <kevin.tian@intel.com>, <jgg@ziepe.ca>, <alex.williamson@redhat.com>,
	<maz@kernel.org>, <oliver.upton@linux.dev>, <will@kernel.org>,
	<robin.murphy@arm.com>, <jean-philippe@linaro.org>,
	<jonathan.cameron@huawei.com>
Subject: [RFC PATCH v2 6/7] iommu/arm-smmu-v3: Use KVM VMID for s2 stage
Date: Thu, 8 Feb 2024 15:18:36 +0000
Message-ID: <20240208151837.35068-7-shameerali.kolothum.thodi@huawei.com>
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

If kvm is available make use of kvm pinned VMID interfaces to
set the s2 stage VMID for nested domains.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 18 +++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 ++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b41d77787a2f..18e3e04b50f4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/io-pgtable.h>
 #include <linux/iopoll.h>
+#include <linux/kvm_host.h>
 #include <linux/module.h>
 #include <linux/msi.h>
 #include <linux/of.h>
@@ -2399,9 +2400,13 @@ int arm_smmu_domain_alloc_id(struct arm_smmu_device *smmu,
 	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2) {
 		int vmid;
 
-		/* Reserve VMID 0 for stage-2 bypass STEs */
-		vmid = ida_alloc_range(&smmu->vmid_map, 1,
-				       (1 << smmu->vmid_bits) - 1, GFP_KERNEL);
+		if (smmu_domain->kvm) {
+			vmid = kvm_pinned_vmid_get(smmu_domain->kvm);
+		} else {
+			/* Reserve VMID 0 for stage-2 bypass STEs */
+			vmid = ida_alloc_range(&smmu->vmid_map, 1,
+					       (1 << smmu->vmid_bits) - 1, GFP_KERNEL);
+		}
 		if (vmid < 0)
 			return vmid;
 		smmu_domain->vmid = vmid;
@@ -2431,7 +2436,10 @@ void arm_smmu_domain_free_id(struct arm_smmu_domain *smmu_domain)
 	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2 &&
 		   smmu_domain->vmid) {
 		arm_smmu_tlb_inv_all_s2(smmu_domain);
-		ida_free(&smmu->vmid_map, smmu_domain->vmid);
+		if (smmu_domain->kvm)
+			kvm_pinned_vmid_put(smmu_domain->kvm);
+		else
+			ida_free(&smmu->vmid_map, smmu_domain->vmid);
 	}
 }
 
@@ -3217,7 +3225,7 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 			goto err_free;
 		}
 		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
-		smmu_domain->nesting_parent = true;
+		smmu_domain->kvm = kvm;
 	}
 
 	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 45bcd72fcda4..7d732ea2a6ee 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -758,6 +758,8 @@ struct arm_smmu_domain {
 	struct mmu_notifier		mmu_notifier;
 	bool				btm_invalidation : 1;
 	bool				nesting_parent : 1;
+
+	struct kvm			*kvm;
 };
 
 struct arm_smmu_nested_domain {
-- 
2.34.1

