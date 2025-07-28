Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C642B28751E
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725241; cv=none; b=ITbDkYZnsHXrXhr7r6zZOP4K3I5d4gKQz4pTsTxVuy956xvXsaoHld3Am6NSnnRkruDEoqCIR/jGhsjzL+u1pXH9B2cRW2YU2LR/+Koy7tEYRBQ0Pu/UrdigUPSPbRGVuzYBkGm/pKs253sC5HzdoglfytnDdq72CLi2qmDjJV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725241; c=relaxed/simple;
	bh=iZLib39lOYnTwgfJltDfFYFegqqNiAE8JukenhKWnJ4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZZbI65qRjM+YG0kUzP+lojpgsxhA9b9bKEtKFYjvtQBspaznzbnW4GcCK8O6ELzlI0DxgUi/Sb79bZrJ8B6fmUff328X+ga2m1xxt1syyXBOwSFHjNgKcuHUKLS2uKV8NKq61YjtxmSo1hFLxKctDSKb4r2swjsR5NVeoVPjggE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fn54tfEE; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fn54tfEE"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-af4f3e4514dso556245866b.2
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725237; x=1754330037; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0vj2lZtAFAyuHgLIRKJXZh0xuKI4AtqGdr8zk+v3t+I=;
        b=fn54tfEEjiW5Hu+RIvBs8KSvOwkBu8dWfY7YV+Z+roZ8OJpnYegm4J96jHzt7ndVqn
         FDTWdaaZSbXYiWG427glRHSChwKTU3hA3yHknDU8R3YrGLsyxRbH0s4ToyrP9PpcoxK3
         31zPaW+HkZoKIqvlouunCP4+PPBcDBf2W2XJ3y+Tfxd5tJTKmaL80A2H8XTnthrZXhBy
         cAiNpC7DcxcEfyrk2AecuACBCNdVep0ajccJMS2Ir7ECP8uOiLwRuGQ8o1DjVf5ti6CW
         TLZR3Vwuz5jNVLTa6Z2uwo4EFKUTDD3aw67PNHKlOqurZ/BCzptSXDrbg4lUU/d/KE6Y
         mfWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725237; x=1754330037;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0vj2lZtAFAyuHgLIRKJXZh0xuKI4AtqGdr8zk+v3t+I=;
        b=ppcvEQ8fk2igPJDjfZWEVjQfeK2nfXbq3btvKHGREiHsBHoOB81fqthL+5VaDWrmLf
         NRwCuly6CI2ONfkz/m/5S+JYuEZwUd45Xr4zr59LgizyDeSpJzLjibfNF9yS0KkFNZM/
         WsMFyzuNIEB5McmIW9AGD8QAAxnHbnh3D/T1FlQ6bDSFn8CNF+ldPMUR/E5MmqFpXkkH
         QzuVSPHOidkMjuqd9708EDmARRHvUA1FRCF7tRnb25NwQT5OLcztAHssoIB5PL8gEK2U
         0tz5W5VdF9oESjC4dnHLUGAwuN83Y4GzwPHlPRbrWoxNif/uc961NH5p3fCRHvoxrZ91
         AOTg==
X-Forwarded-Encrypted: i=1; AJvYcCXQ20wB6uE/kP5NmEg/9vvq8MhEopoCYKJKSPl8BFB0nPRRtmtbHfMKF4ToLsqP0B6+0NRV8cc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSr+rXsk/3D6IauGYx2InbBg6I3EgvgJ2XYuWQF4IcSOP88eve
	YWdgnEr/HCiZV6F0gjptfDRHsin6KcJOxnlUz4mRuBx1puGrghNGdNQxFcZQYtsLlGlxDEhWDK5
	2GcQO66qTWG1cEQ==
X-Google-Smtp-Source: AGHT+IGVIq17cLn93oc40o5M8UsmhcmyEY+aWX6m0jcNoqtnD1qIUUFbq5lUoqYkBT4qJuVFWbmyB6BKPXnAVg==
X-Received: from ejcss14.prod.google.com ([2002:a17:907:c00e:b0:ade:897b:b48d])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3e12:b0:ae0:b847:435 with SMTP id a640c23a62f3a-af61eb0d30dmr1480823666b.49.1753725236850;
 Mon, 28 Jul 2025 10:53:56 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:53:15 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-29-smostafa@google.com>
Subject: [PATCH v3 28/29] iommu/arm-smmu-v3-kvm: Allocate structures and reset device
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Allocate the structures that will be shared between hypervisor and SMMU:
command queue, page table and stream table. Install them in the MMIO
registers, along with some configuration bits. After hyp initialization,
the host won't have access to those pages anymore.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h             |  5 ++
 arch/arm64/kvm/iommu.c                        |  9 ++-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 65 +++++++++++++++++++
 3 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b42e32ff2a84..37b34a9f7135 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1684,4 +1684,9 @@ int kvm_iommu_register_driver(struct kvm_iommu_driver *kern_ops, struct kvm_iomm
 int kvm_iommu_init_driver(void);
 void kvm_iommu_remove_driver(void);
 size_t kvm_iommu_pages(void);
+
+#ifdef CONFIG_ARM_SMMU_V3_PKVM
+size_t smmu_hyp_pgt_pages(void);
+#endif
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
index 0e52cc0e18de..c4605e8001ca 100644
--- a/arch/arm64/kvm/iommu.c
+++ b/arch/arm64/kvm/iommu.c
@@ -51,10 +51,15 @@ void kvm_iommu_remove_driver(void)
 
 size_t kvm_iommu_pages(void)
 {
+	size_t nr_pages = 0;
 	/*
 	 * This is called very early during setup_arch() where no initcalls,
 	 * so this has to call specific functions per each KVM driver.
 	 */
-	kvm_nvhe_sym(hyp_kvm_iommu_pages) = 0;
-	return 0;
+#ifdef CONFIG_ARM_SMMU_V3_PKVM
+	nr_pages = smmu_hyp_pgt_pages();
+#endif
+
+	kvm_nvhe_sym(hyp_kvm_iommu_pages) = nr_pages;
+	return nr_pages;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 2fa56ddfbdab..2e51e211250d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2022 Linaro Ltd.
  */
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_pkvm.h>
 
 #include <linux/of_platform.h>
 
@@ -16,6 +17,7 @@ extern struct kvm_iommu_ops kvm_nvhe_sym(smmu_ops);
 struct host_arm_smmu_device {
 	struct arm_smmu_device		smmu;
 	pkvm_handle_t			id;
+	u32				boot_gbpa;
 };
 
 #define smmu_to_host(_smmu) \
@@ -65,6 +67,35 @@ static bool kvm_arm_smmu_validate_features(struct arm_smmu_device *smmu)
 	return true;
 }
 
+static int kvm_arm_smmu_device_reset(struct host_arm_smmu_device *host_smmu)
+{
+	int ret;
+	u32 reg;
+	struct arm_smmu_device *smmu = &host_smmu->smmu;
+
+	reg = readl_relaxed(smmu->base + ARM_SMMU_CR0);
+	if (reg & CR0_SMMUEN)
+		dev_warn(smmu->dev, "SMMU currently enabled! Resetting...\n");
+
+	/* Disable bypass */
+	host_smmu->boot_gbpa = readl_relaxed(smmu->base + ARM_SMMU_GBPA);
+	ret = arm_smmu_update_gbpa(smmu, GBPA_ABORT, 0);
+	if (ret)
+		return ret;
+
+	ret = arm_smmu_device_disable(smmu);
+	if (ret)
+		return ret;
+
+	/* Stream table */
+	arm_smmu_write_strtab(smmu);
+
+	/* Command queue */
+	writeq_relaxed(smmu->cmdq.q.q_base, smmu->base + ARM_SMMU_CMDQ_BASE);
+
+	return 0;
+}
+
 static int kvm_arm_smmu_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -112,6 +143,20 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 	if (!kvm_arm_smmu_validate_features(smmu))
 		return -ENODEV;
 
+	ret = arm_smmu_init_one_queue(smmu, &smmu->cmdq.q, smmu->base,
+				      ARM_SMMU_CMDQ_PROD, ARM_SMMU_CMDQ_CONS,
+				      CMDQ_ENT_DWORDS, "cmdq");
+	if (ret)
+		return ret;
+
+	ret = arm_smmu_init_strtab(smmu);
+	if (ret)
+		return ret;
+
+	ret = kvm_arm_smmu_device_reset(host_smmu);
+	if (ret)
+		return ret;
+
 	platform_set_drvdata(pdev, smmu);
 
 	/* Hypervisor parameters */
@@ -130,6 +175,15 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 
 static void kvm_arm_smmu_remove(struct platform_device *pdev)
 {
+	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
+	struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);
+
+	/*
+	 * There was an error during hypervisor setup. The hyp driver may
+	 * have already enabled the device, so disable it.
+	 */
+	arm_smmu_device_disable(smmu);
+	arm_smmu_update_gbpa(smmu, host_smmu->boot_gbpa, GBPA_ABORT);
 }
 
 static const struct of_device_id arm_smmu_of_match[] = {
@@ -208,6 +262,17 @@ static void kvm_arm_smmu_v3_remove_drv(void)
 	platform_driver_unregister(&kvm_arm_smmu_driver);
 }
 
+size_t smmu_hyp_pgt_pages(void)
+{
+	/*
+	 * SMMUv3 uses the same format as stage-2 and hence have the same memory
+	 * requirements, we add extra 100 pages for L2 ste.
+	 */
+	if (of_find_compatible_node(NULL, NULL, "arm,smmu-v3"))
+		return host_s2_pgtable_pages() + 100;
+	return 0;
+}
+
 struct kvm_iommu_driver kvm_smmu_v3_ops = {
 	.init_driver = kvm_arm_smmu_v3_init_drv,
 	.remove_driver = kvm_arm_smmu_v3_remove_drv,
-- 
2.50.1.552.g942d659e1b-goog

