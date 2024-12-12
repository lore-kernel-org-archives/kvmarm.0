Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9945A240395
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026793; cv=none; b=SURyUqYo1mzkaXhEy/SYZ8I3f0vU2r1irbvTuzSKyIK1B26NuaWx4USO/5KV6PFIQH2UykVnf/Q0x2xLyOtDg+bqYZDMnl2ZzItkGXZNqyoUyaHpE4l5yIr0ufkjD+u1qyA/i2ZC7rkY17D26IryGputPrRzDHJxK2i4J4LaKgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026793; c=relaxed/simple;
	bh=07ud3kdPqRkJyWJjKZmbhmLN44HYdmlP0Fh8jQS65qQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DeHBxTDJYCHooZst8FPpzw2Hzk1+fVyJ8QlbdrpdliRVYZFWfm3itEAqiq1c1ozxqFsdzgvVWLgFozr1R11OOMI8p2DeAaQ7NIYceBpAENjsScJywtjc6JvWMe3TzDGMcetGif2NUephKvcjkdeA9z1vQexSwnT5AAxraxzAXko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e1p5dml4; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e1p5dml4"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43610eba55bso8228075e9.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026790; x=1734631590; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rDsPUb0bWk00lVk5VrmMCzR9hOnWzhzOdUMd5hdynGI=;
        b=e1p5dml4wR9uU46czFvJN8cb0Pw0igDsrfr9oNS0o7/hE33SfkvlWJM3dwmX1k7jpk
         TTI+h+K6iDS9ke/l0J7zvl7FitxWvgNloVB0LVvh7WO8YYJuZsPU52HTJwHOIioRMLCQ
         yrMRwb+pzaX/c5ZbzFRqsD5Vecg+QSjMS2iKJ6PxWsn+ngKtOihaHs00SEKAUxKljbrk
         KP3rRwgUID5H6gYj3Ph8PQFd8gEy/4tYpF8hw9LFjxrysGcFnOqFMvVX5QWYuxnb3pJn
         TOUVrnax8Vj9k6WIvjak/PlZB7g8cnh69066IqvwHiplJCuCb7TMD8uaxKCOxk9PjubQ
         Oaqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026790; x=1734631590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rDsPUb0bWk00lVk5VrmMCzR9hOnWzhzOdUMd5hdynGI=;
        b=dxBj79108vA8GeunjiFUOsCpjpnDHFN9NcsaYjYl3Kq+z3cAzXaHyxowtDuW7qWgdc
         9FAqP8uHirsG69kz37QIxhDhVJTA9g7jwPTbvP68jT7COd2vC8XJUpXlVZxQOpdvHoup
         BhmASWZDiIDZAKcGYcSJDM8azLSZ1mEcWgp0oK2FYmIKLLnXU46Sggz9RKy0iiP1hFbw
         c8LK7UyFh/VFAAXWKkI1Ixl9q2UmjyDI2EFz8RGrDSmvWECuRFthvS9EPa3Iy9Pm3HGx
         AkR3YsGe7eHIpA+XyKQziQLneo6I7Bt9V4VkdY33tz93bUyUTLS89bbco6d7WnqFk1Iy
         ZXvg==
X-Forwarded-Encrypted: i=1; AJvYcCWiLdXHI2HrTLp4JVGVhyQE5lt+lF4GliRmT8Tj/GSoh0/3PPHv4uvZabTYKNtOQkogKdUZBkc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAQw9vMFVTmUu8bUT0YojjOdyOf63v6Gc6zQ5S8v7pi2UoKTa6
	U2mCBty2LeP5iEKsqJ621zsGAyF9T+CBGwI1JpkX+jUWNML318UQuY3NJy6xssdP+ocYcgrSs45
	D+UamBpv82g==
X-Google-Smtp-Source: AGHT+IG5YT0EqzqwRu68YDl6GFjwRjdyDc1eUBljQvzlbHZ6i5XzGDeiAujVaOE5XHTme90ZWc1iBhvfMg1TXA==
X-Received: from wmdp19.prod.google.com ([2002:a05:600c:5d3:b0:434:f271:522e])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1e0b:b0:436:1b96:7072 with SMTP id 5b1f17b1804b1-43622827675mr38391595e9.5.1734026790384;
 Thu, 12 Dec 2024 10:06:30 -0800 (PST)
Date: Thu, 12 Dec 2024 18:04:15 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-52-smostafa@google.com>
Subject: [RFC PATCH v2 51/58] iommu/arm-smmu-v3-kvm: Support PASID operations
From: Mostafa Saleh <smostafa@google.com>
To: iommu@lists.linux.dev, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org, 
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca, 
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com, 
	tabba@google.com, danielmentz@google.com, tzukui@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Add support for set_dev_pasid and remove_dev_pasid, the hypervisor
already supports pasid, so we just need to forward it in the
hypercalls in addition to proper tracking of domains per master.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 58 +++++++++++++++----
 1 file changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 82f0191b222c..cbcd8a75d562 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -29,7 +29,8 @@ struct host_arm_smmu_device {
 struct kvm_arm_smmu_master {
 	struct arm_smmu_device		*smmu;
 	struct device			*dev;
-	struct kvm_arm_smmu_domain      *domain;
+	struct xarray			domains;
+	u32				ssid_bits;
 };
 
 struct kvm_arm_smmu_domain {
@@ -119,6 +120,10 @@ static struct iommu_device *kvm_arm_smmu_probe_device(struct device *dev)
 
 	master->dev = dev;
 	master->smmu = smmu;
+
+	device_property_read_u32(dev, "pasid-num-bits", &master->ssid_bits);
+	master->ssid_bits = min(smmu->ssid_bits, master->ssid_bits);
+	xa_init(&master->domains);
 	dev_iommu_priv_set(dev, master);
 
 	return &smmu->iommu;
@@ -235,13 +240,14 @@ static void kvm_arm_smmu_domain_free(struct iommu_domain *domain)
 	kfree(kvm_smmu_domain);
 }
 
-static int kvm_arm_smmu_detach_dev(struct host_arm_smmu_device *host_smmu,
-				   struct kvm_arm_smmu_master *master)
+static int kvm_arm_smmu_detach_dev_pasid(struct host_arm_smmu_device *host_smmu,
+					 struct kvm_arm_smmu_master *master,
+					 ioasid_t pasid)
 {
 	int i, ret;
 	struct arm_smmu_device *smmu = &host_smmu->smmu;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(master->dev);
-	struct kvm_arm_smmu_domain *domain = master->domain;
+	struct kvm_arm_smmu_domain *domain = xa_load(&master->domains, pasid);
 
 	if (!domain)
 		return 0;
@@ -250,7 +256,7 @@ static int kvm_arm_smmu_detach_dev(struct host_arm_smmu_device *host_smmu,
 		int sid = fwspec->ids[i];
 
 		ret = kvm_call_hyp_nvhe(__pkvm_host_iommu_detach_dev,
-					host_smmu->id, domain->id, sid, 0);
+					host_smmu->id, domain->id, sid, pasid);
 		if (ret) {
 			dev_err(smmu->dev, "cannot detach device %s (0x%x): %d\n",
 				dev_name(master->dev), sid, ret);
@@ -258,22 +264,39 @@ static int kvm_arm_smmu_detach_dev(struct host_arm_smmu_device *host_smmu,
 		}
 	}
 
-	master->domain = NULL;
+	xa_erase(&master->domains, pasid);
 
 	return ret;
 }
 
+static int kvm_arm_smmu_detach_dev(struct host_arm_smmu_device *host_smmu,
+				   struct kvm_arm_smmu_master *master)
+{
+	return kvm_arm_smmu_detach_dev_pasid(host_smmu, master, 0);
+}
+
+static void kvm_arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
+					  struct iommu_domain *domain)
+{
+	struct kvm_arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct host_arm_smmu_device *host_smmu = smmu_to_host(master->smmu);
+
+	kvm_arm_smmu_detach_dev_pasid(host_smmu, master, pasid);
+}
+
 static void kvm_arm_smmu_release_device(struct device *dev)
 {
 	struct kvm_arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct host_arm_smmu_device *host_smmu = smmu_to_host(master->smmu);
 
 	kvm_arm_smmu_detach_dev(host_smmu, master);
+	xa_destroy(&master->domains);
 	kfree(master);
 	iommu_fwspec_free(dev);
 }
 
-static int kvm_arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
+static int kvm_arm_smmu_set_dev_pasid(struct iommu_domain *domain,
+				      struct device *dev, ioasid_t pasid)
 {
 	int i, ret;
 	struct arm_smmu_device *smmu;
@@ -288,7 +311,7 @@ static int kvm_arm_smmu_attach_dev(struct iommu_domain *domain, struct device *d
 	smmu = master->smmu;
 	host_smmu = smmu_to_host(smmu);
 
-	ret = kvm_arm_smmu_detach_dev(host_smmu, master);
+	ret = kvm_arm_smmu_detach_dev_pasid(host_smmu, master, pasid);
 	if (ret)
 		return ret;
 
@@ -303,14 +326,14 @@ static int kvm_arm_smmu_attach_dev(struct iommu_domain *domain, struct device *d
 
 		ret = kvm_call_hyp_nvhe_mc(__pkvm_host_iommu_attach_dev,
 					   host_smmu->id, kvm_smmu_domain->id,
-					   sid, 0, 0);
+					   sid, pasid, master->ssid_bits);
 		if (ret) {
 			dev_err(smmu->dev, "cannot attach device %s (0x%x): %d\n",
 				dev_name(dev), sid, ret);
 			goto out_ret;
 		}
 	}
-	master->domain = kvm_smmu_domain;
+	ret = xa_insert(&master->domains, pasid, kvm_smmu_domain, GFP_KERNEL);
 
 out_ret:
 	if (ret)
@@ -318,6 +341,19 @@ static int kvm_arm_smmu_attach_dev(struct iommu_domain *domain, struct device *d
 	return ret;
 }
 
+static int kvm_arm_smmu_attach_dev(struct iommu_domain *domain,
+				   struct device *dev)
+{
+	struct kvm_arm_smmu_master *master = dev_iommu_priv_get(dev);
+	unsigned long pasid = 0;
+
+	/* All pasids must be removed first. */
+	if (xa_find_after(&master->domains, &pasid, ULONG_MAX, XA_PRESENT))
+		return -EBUSY;
+
+	return kvm_arm_smmu_set_dev_pasid(domain, dev, 0);
+}
+
 static bool kvm_arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 {
 	struct kvm_arm_smmu_master *master = dev_iommu_priv_get(dev);
@@ -409,6 +445,7 @@ static struct iommu_ops kvm_arm_smmu_ops = {
 	.release_device		= kvm_arm_smmu_release_device,
 	.domain_alloc		= kvm_arm_smmu_domain_alloc,
 	.pgsize_bitmap		= -1UL,
+	.remove_dev_pasid	= kvm_arm_smmu_remove_dev_pasid,
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev	= kvm_arm_smmu_attach_dev,
@@ -416,6 +453,7 @@ static struct iommu_ops kvm_arm_smmu_ops = {
 		.map_pages	= kvm_arm_smmu_map_pages,
 		.unmap_pages	= kvm_arm_smmu_unmap_pages,
 		.iova_to_phys	= kvm_arm_smmu_iova_to_phys,
+		.set_dev_pasid	= kvm_arm_smmu_set_dev_pasid,
 	}
 };
 
-- 
2.47.0.338.g60cca15819-goog

