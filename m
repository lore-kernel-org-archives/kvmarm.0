Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A8C279915
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725225; cv=none; b=HtNEqSXnwkQCiw+E3XkIJ/zm5Le6gRjtlij4kg+dXYvxvuhCireLDsXn5kywnf3ZmQrt9/K3PH+/5xnzd3N59gK0cq461N99W7fcMPp32KsgRBIgopWgxT96WL/K5QRyOPNhlH0zxRe5BdSbKDWJX2Sm3gdtdB5synvsfm/bm70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725225; c=relaxed/simple;
	bh=RxPbPhNqEx9akHkIou9iNguWeMIuxS6YzG17MY3jzBE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RojZnUQzed8+S0RDIs7djmy1kSrxXlIhQ6pvojXZV2DEAqOCGnmFAcRheojTYHW8tj1smeGzYbSBJykpaC7BApExEv6ZUA5jkrSZjw/RepYTflsKswn4+bH29opWKPST99G4MdV0GFMuEQciarYrkFWjqi6OrDIzWuScYTlZlXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b3il+WlE; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b3il+WlE"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-ae6c9aa2c93so395896566b.1
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725221; x=1754330021; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zYSaQxxv0yy3Y7EMVpbwK7SrDhDexuagcipLxM0lKzk=;
        b=b3il+WlEKNbNL0Qq9XRmBTWgLpYx/5l0Vm7L6zaM8GtobJ4QSS5PNRi2x+ApnbJe1a
         nmt/yh1xlaxeztd48COinEWrRKy5hyEWZTpxSo82nrunRbF/d9fzhuQrEaQsdqUchc24
         0iFHvdDui1Q29dE6vMd32rMObLOirm4ql6oUCBYcY/JWJCZsPsmGvOg2BFmzldLVw+rc
         k/Kgd7yL7DArd/+EaYWBF1toV+6vqXQv4XixhQx6aAuDbi/aNxu+KagiRvFxcqlS1lLu
         0oVgG6c61J/VchQN9jm8SvuMwpJgM+YV6h44WCu9znf5y42ZQqiCdIJt5FGOg9yAxiP3
         Ae/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725221; x=1754330021;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zYSaQxxv0yy3Y7EMVpbwK7SrDhDexuagcipLxM0lKzk=;
        b=fWu8UGTRsUabf0iLUGPKhwdBCHOYPH9ADpsNTCI/1yj1d1WIOrnogvpAwuK+dyCMPV
         DAqgR0oQZ1z9imDllzt8yVC4mdYkT/lIrxY8OJp2yS+VTunY4eNux/K90uiVqkfOmsQ4
         Z/SQMf6xH8JfcQ+lUIYLmkOOU/d2Bj5UGwR5UhGCHvItYCZKB4FPvgG0eU6wm7cUUFaI
         jlr/EHxdIW3hARyykzXtddr852qzWqv4CyPv2JhYRTVqSzFI3+iSj4YPJ8jUTqm2vX+Z
         mgkIB+Q41Qk+lyEwm10JKn6F8iiBBIY6ffxpZ+7169+4jI7IehCdQFbOHLfd01WOSYuG
         KcBA==
X-Forwarded-Encrypted: i=1; AJvYcCVL0lNq5X4Eh5h8sYzMWEIJTk2zePh4wEsb+GdacukEkD8l9RZjelHs5C8RIq5yVhq9UvT6x4g=@lists.linux.dev
X-Gm-Message-State: AOJu0YxrEJKOMobq+faJuIEGbbjCpP66exBrd6SeISvNA/JzLaf1Z61W
	Kf5f8qDqD6nbhVKbU1aOtUmmU78zeDW11jVoiOKdWh9yW6o3ohOyvGj7G1F9Sp/LZ5ORX/qYxSN
	3hKJV7mcVM4KbHA==
X-Google-Smtp-Source: AGHT+IEqJ30qZTbb5uhq7Ulncx7YgH8wYLGAX5KY0xkgcaQRC+MirKkQi/xoWXPkKjKloEcVMUK+yOS2vLoJOA==
X-Received: from ejcry7.prod.google.com ([2002:a17:906:8d87:b0:ae0:d1fb:d297])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7b8b:b0:ad8:914b:7d0b with SMTP id a640c23a62f3a-af61c2adce9mr1312173166b.11.1753725221260;
 Mon, 28 Jul 2025 10:53:41 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:52:58 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-12-smostafa@google.com>
Subject: [PATCH v3 11/29] iommu/arm-smmu-v3: Move IOMMU registration to arm-smmu-v3-common.c
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

The KVM driver will need to implement a few IOMMU ops, so move the
helpers to arm-smmu-v3-common.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-common.c      | 27 +++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 18 ++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  3 +++
 3 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
index 835eeae3bf5e..7453d9894ca3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
@@ -671,3 +671,30 @@ int arm_smmu_fw_probe(struct platform_device *pdev,
 	else
 		return arm_smmu_device_acpi_probe(pdev, smmu);
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
index 4cd0a115fc0e..8fbc7dd2a2db 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4138,21 +4138,8 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 		goto err_disable;
 
 	/* And we're up. Go go go! */
-	ret = iommu_device_sysfs_add(&smmu->iommu, dev, NULL,
-				     "smmu3.%pa", &ioaddr);
-	if (ret)
-		goto err_disable;
-
-	ret = iommu_device_register(&smmu->iommu, &arm_smmu_ops, dev);
-	if (ret) {
-		dev_err(dev, "Failed to register iommu\n");
-		goto err_free_sysfs;
-	}
-
-	return 0;
+	return arm_smmu_register_iommu(smmu, &arm_smmu_ops, ioaddr);
 
-err_free_sysfs:
-	iommu_device_sysfs_remove(&smmu->iommu);
 err_disable:
 	arm_smmu_device_disable(smmu);
 err_free_iopf:
@@ -4164,8 +4151,7 @@ static void arm_smmu_device_remove(struct platform_device *pdev)
 {
 	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
 
-	iommu_device_unregister(&smmu->iommu);
-	iommu_device_sysfs_remove(&smmu->iommu);
+	arm_smmu_unregister_iommu(smmu);
 	arm_smmu_device_disable(smmu);
 	iopf_queue_free(smmu->evtq.iopf);
 	ida_destroy(&smmu->vmid_map);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 787296a2f0c2..e3c46b3344db 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -564,6 +564,9 @@ int arm_smmu_init_one_queue(struct arm_smmu_device *smmu,
 			    size_t dwords, const char *name);
 int arm_smmu_fw_probe(struct platform_device *pdev,
 		      struct arm_smmu_device *smmu);
+int arm_smmu_register_iommu(struct arm_smmu_device *smmu,
+			    struct iommu_ops *ops, phys_addr_t ioaddr);
+void arm_smmu_unregister_iommu(struct arm_smmu_device *smmu);
 
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
-- 
2.50.1.552.g942d659e1b-goog

