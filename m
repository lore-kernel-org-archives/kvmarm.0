Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B0B2288F9
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026706; cv=none; b=LCjIhrT8U2Mc3QsbTrnyRtIVaJoULr3UReXzvI8rRKSenaUvTzhPAGW3Tt/YbjGCCSEH/inbmWTuoJDaJkcMQq2Ka7iB+LTaMuDMVVP1z1ObosHmOwH6jikYV0icmKLIM0JHWubPx1bvjpOQGx2q159qP8BpADqpijqHHkmJvYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026706; c=relaxed/simple;
	bh=s41qDBeIfR+pyi6L0VZtpKA+UqenXrCMsBsTuT0BQaM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B6mfGaFgKOVI0eaPMErFqr/u2j29Yblerjaslzn9ekXb9Ys9q0veqxniisHQmk+iyDgyOKGlEHpRaTGrXxQ7Ja6D0H3zELF9W5++gsXvq2Q/aDHKBBQs8SUIXSkR2G9gdTFBSPRGjx4CF2C9rI7PTF2cKBJXaQBAID5bXB3hLxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VJfl4kse; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VJfl4kse"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-434e9e1b4d7so5501535e9.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026702; x=1734631502; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RRlluNjB7B7yhqcQsTcc7WzSgCbMOzbSDkNF00y+zZQ=;
        b=VJfl4kse0NSeS1cV6anBjGLCErVgpGOyl3kDJeko2xXYBqaqZC3YEsWTqBa/i8R/Kg
         VuMXSO6+ya3FcVXeGeDJJrIwgF8bDh73BClfgO7umqmJlgoDZaOjguPiTc2uUtOz11uJ
         a/X5QUfT6jw97Y1LdDQl1nIBOTAqd9JZnwyLG+cgbAXp4dCNOrDXjLHDs+u0sAIwUKKr
         6F+O2qiTqWC2dh8CdO6uX/qESA68wVanem9t2O/WOKqscc7l1+xM+huor6aLoea5UGXH
         rc8st0Pryw2laFy+PhNs0RrEo9/zos2/6l5/SxIgKikEsU5xPSu9EzeucQHDXjpFXAzi
         q5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026702; x=1734631502;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RRlluNjB7B7yhqcQsTcc7WzSgCbMOzbSDkNF00y+zZQ=;
        b=kzJLJ74yG4gkCVWO1ROfg3EhTglXZSrBa5IMsOqM6xyeF0K0/jw/VcOLrnwBaIYBCy
         eeFxeF9CtwrkIJyprwsGyEOKftT1vk5cBo5ABHoG4oD67x0EzjImLAgaLzHsEgFq+SHA
         6SJnFlUX6l8OYebg8O3XbZl8fpUUpJ886QPEHiQqYtQpf1CgcUivBfCcCMDjl9JloKsP
         4kfVigdyiTW2tomamGtswax1kPQGcoS/oafxj1x4Xh7EvvWT50s0P48w78Ht3D0Y/cAD
         AlXgZ6+QhqyHcP0O9LgOtAKEWyAM7pce1zAPWWI5UukNiv5c83TV8YhZ2yeQNhS7Febd
         omnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXD5ouR/XkSF+dMI/Yve1KfSUDySuInbg2nn4mfdxWtOdgrScLVwjEI+dJ4CSSNBCSsx1rjTM4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwUn/bk7odti9nyOYPrhuJpFzrnqy8aTIIceUPRVGXFHug6rzTF
	Jy8j2rEk0fV55iD1FDsrqmXjN3oXqG5EXI/bp98ZjtWL2s2rloJy6jHIfNZBZtiB6XE/rZcVw/A
	QOt7SzBVE6w==
X-Google-Smtp-Source: AGHT+IG8R7L09stXwqH3oYXhWOZy4o2kVZLVIfQiCvS7+nSVYxh7Lqp6AmiQAmgplzW2b5ucEblLkxA9Ex8Hjg==
X-Received: from wmik26.prod.google.com ([2002:a7b:c41a:0:b0:434:f801:bf67])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b94:b0:434:f2bf:1708 with SMTP id 5b1f17b1804b1-4361c34672amr67605075e9.7.1734026702619;
 Thu, 12 Dec 2024 10:05:02 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:33 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-10-smostafa@google.com>
Subject: [RFC PATCH v2 09/58] iommu/arm-smmu-v3: Move IOMMU registration to arm-smmu-v3-common.c
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

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

The KVM driver will need to implement a few IOMMU ops, so move the
helpers to arm-smmu-v3-common.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-common.c      | 27 +++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 17 ++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  4 +++
 3 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
index 04f1e2f1c458..b7bcac51cc7d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
@@ -645,3 +645,30 @@ void arm_smmu_write_strtab(struct arm_smmu_device *smmu)
 		       smmu->base + ARM_SMMU_STRTAB_BASE);
 	writel_relaxed(reg, smmu->base + ARM_SMMU_STRTAB_BASE_CFG);
 }
+
+int arm_smmu_register_iommu(struct arm_smmu_device *smmu,
+			    struct iommu_ops *ops, phys_addr_t ioaddr)
+{
+	int ret;
+	struct device *dev = smmu->dev;
+
+	ret = iommu_device_sysfs_add(&smmu->iommu, dev, NULL,
+				     "smmu3.%pa", &ioaddr);
+	if (ret)
+		return ret;
+
+	ret = iommu_device_register(&smmu->iommu, ops, dev);
+	if (ret) {
+		dev_err(dev, "Failed to register iommu\n");
+		iommu_device_sysfs_remove(&smmu->iommu);
+		return ret;
+	}
+
+	return 0;
+}
+
+void arm_smmu_unregister_iommu(struct arm_smmu_device *smmu)
+{
+	iommu_device_unregister(&smmu->iommu);
+	iommu_device_sysfs_remove(&smmu->iommu);
+}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 91f64416900b..bcefa361f3d3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3980,27 +3980,14 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 		return ret;
 
 	/* And we're up. Go go go! */
-	ret = iommu_device_sysfs_add(&smmu->iommu, dev, NULL,
-				     "smmu3.%pa", &ioaddr);
-	if (ret)
-		return ret;
-
-	ret = iommu_device_register(&smmu->iommu, &arm_smmu_ops, dev);
-	if (ret) {
-		dev_err(dev, "Failed to register iommu\n");
-		iommu_device_sysfs_remove(&smmu->iommu);
-		return ret;
-	}
-
-	return 0;
+	return arm_smmu_register_iommu(smmu, &arm_smmu_ops, ioaddr);
 }
 
 static void arm_smmu_device_remove(struct platform_device *pdev)
 {
 	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
 
-	iommu_device_unregister(&smmu->iommu);
-	iommu_device_sysfs_remove(&smmu->iommu);
+	arm_smmu_unregister_iommu(smmu);
 	arm_smmu_device_disable(smmu);
 	iopf_queue_free(smmu->evtq.iopf);
 	ida_destroy(&smmu->vmid_map);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 2d658f15973a..63545fdf55f9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -349,6 +349,10 @@ void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
 				   dma_addr_t l2ptr_dma);
 void arm_smmu_write_strtab(struct arm_smmu_device *smmu);
 
+int arm_smmu_register_iommu(struct arm_smmu_device *smmu,
+			    struct iommu_ops *ops, phys_addr_t ioaddr);
+void arm_smmu_unregister_iommu(struct arm_smmu_device *smmu);
+
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
-- 
2.47.0.338.g60cca15819-goog

