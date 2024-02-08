Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD0679DDA;
	Thu,  8 Feb 2024 15:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707405680; cv=none; b=mZrysWpi/0N2p0Ad4OE35VL0T43ANX6EKBUloCG6jEp06G5HXiCFodSJ0fqQ1KTaQTpRfRZR134QIZomfNHGkpXguNfSw8hG/LzpnzT1zq7vMEMVOT7teiTh/AeBXE+cJyMkldX2bjIGUJWmbrz0fvK9JxE1B4mYOFHsZHdJcic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707405680; c=relaxed/simple;
	bh=wH3W+HV2vRIixQrjln1H0RAoW+Tjs5yp7QkYzKE3PHY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=avrncgce9IvjYpHhKyYuWP8ssWJSNWe6/x2qnmhmVPMJ1cyo0Ylv6+zCvI79Zh8+f1VsQaUJeouLF0qi7n2ZzFep/nFArd70g1kwapW1L8bYsA2qyYYwONJ9yIgaI90cfNiIkMFNqLgLl0vb7g8QWogjI6OsCzBpyj1iJTh9hm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TW0wk2M81z6K93W;
	Thu,  8 Feb 2024 23:17:58 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 746B6140595;
	Thu,  8 Feb 2024 23:21:16 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.202.227.28) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 8 Feb 2024 15:21:09 +0000
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <iommu@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linuxarm@huawei.com>
CC: <kevin.tian@intel.com>, <jgg@ziepe.ca>, <alex.williamson@redhat.com>,
	<maz@kernel.org>, <oliver.upton@linux.dev>, <will@kernel.org>,
	<robin.murphy@arm.com>, <jean-philippe@linaro.org>,
	<jonathan.cameron@huawei.com>
Subject: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd ctx
Date: Thu, 8 Feb 2024 15:18:34 +0000
Message-ID: <20240208151837.35068-5-shameerali.kolothum.thodi@huawei.com>
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

Introduce an API to set the KVM pointer to the iommufd ctx
and set the same when a vfio dev is bind to iommufd.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/iommu/iommufd/iommufd_private.h |  3 +++
 drivers/iommu/iommufd/main.c            | 14 ++++++++++++++
 drivers/vfio/device_cdev.c              |  3 +++
 include/linux/iommufd.h                 |  7 +++++++
 4 files changed, 27 insertions(+)

diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 991f864d1f9b..28ede82bb1a6 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -16,6 +16,7 @@ struct iommu_domain;
 struct iommu_group;
 struct iommu_option;
 struct iommufd_device;
+struct kvm;
 
 struct iommufd_ctx {
 	struct file *file;
@@ -27,6 +28,8 @@ struct iommufd_ctx {
 	/* Compatibility with VFIO no iommu */
 	u8 no_iommu_mode;
 	struct iommufd_ioas *vfio_ioas;
+	/* Associated KVM pointer */
+	struct kvm *kvm;
 };
 
 /*
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 39b32932c61e..28272510fba4 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -495,6 +495,20 @@ void iommufd_ctx_put(struct iommufd_ctx *ictx)
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_ctx_put, IOMMUFD);
 
+/**
+ * iommufd_ctx_set_kvm - Called to set a KVM pointer to iommufd context
+ * @ictx: Context to operate on
+ * @kvm: KVM pointer with a reference taken using kvm_get_kvm_safe()
+ */
+void iommufd_ctx_set_kvm(struct iommufd_ctx *ictx, struct kvm *kvm)
+{
+	xa_lock(&ictx->objects);
+	if (!ictx->kvm)
+		ictx->kvm = kvm;
+	xa_unlock(&ictx->objects);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_ctx_set_kvm, IOMMUFD);
+
 static const struct iommufd_object_ops iommufd_object_ops[] = {
 	[IOMMUFD_OBJ_ACCESS] = {
 		.destroy = iommufd_access_destroy_object,
diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index e75da0a70d1f..e75e96fb57cb 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -101,6 +101,9 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 	 */
 	vfio_df_get_kvm_safe(df);
 
+	if (df->kvm)
+		iommufd_ctx_set_kvm(df->iommufd, df->kvm);
+
 	ret = vfio_df_open(df);
 	if (ret)
 		goto out_put_kvm;
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index ffc3a949f837..7408b620d0b8 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -17,6 +17,7 @@ struct iommufd_ctx;
 struct iommufd_access;
 struct file;
 struct iommu_group;
+struct kvm;
 
 struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
 					   struct device *dev, u32 *id);
@@ -59,6 +60,7 @@ struct iommufd_ctx *iommufd_ctx_from_file(struct file *file);
 struct iommufd_ctx *iommufd_ctx_from_fd(int fd);
 void iommufd_ctx_put(struct iommufd_ctx *ictx);
 bool iommufd_ctx_has_group(struct iommufd_ctx *ictx, struct iommu_group *group);
+void iommufd_ctx_set_kvm(struct iommufd_ctx *ictx, struct kvm *kvm);
 
 int iommufd_access_pin_pages(struct iommufd_access *access, unsigned long iova,
 			     unsigned long length, struct page **out_pages,
@@ -80,6 +82,11 @@ static inline void iommufd_ctx_put(struct iommufd_ctx *ictx)
 {
 }
 
+static inline void iommufd_ctx_set_kvm(struct iommufd_ctx *ictx,
+				       struct kvm *kvm)
+{
+}
+
 static inline int iommufd_access_pin_pages(struct iommufd_access *access,
 					   unsigned long iova,
 					   unsigned long length,
-- 
2.34.1

