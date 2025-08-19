Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC2A3054D1
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 21:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640361; cv=none; b=FXbBJcMCYTczI0eQPFUEq//EsPJpV0eFvF54p2L0CdH9ZPkfVPcvJpPITnKtKsI9bF8FoqqDbQJQzpQRjpPAQynia3MYdnN2Yvz52BkmOtD5/1bAo3ixkONaZAFkjRZLfUX02PLtruvIGVHXGfd8ffK8/i6WVmBrjy38ukTb3AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640361; c=relaxed/simple;
	bh=3r8oXH7nsfm/ONpYF9TIZSokbPzVQMcEKf/AvnlgvDw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=plnCUZnsEadGnzMHynkO3h1mfSAMYzSH7NJ01oWNUrKHqKec+glgWMVSHu0Z0EgQO8zbEjmoap/oIn2VfA3yg74a3Bx5dhb/u5hr1XnF29Z3RaPE7nN8lGgoXL098IS2+0eUAni4sRXwXDIwsSmbJdal9bmibTTGFEhFhJv4Njw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VhQzLGjT; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VhQzLGjT"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b0b14daso21689125e9.2
        for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640357; x=1756245157; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X4PaN1FBVh+xdnfphbKwqZhoaGiNxq0bOXNDJ6vx+5U=;
        b=VhQzLGjTahQ3yAzsn1Wl0nsWkItpi1XW5AsGR7qFmc64sfxmc9zYxrcwaWy/aSlOdt
         wXoeAwlRpAVOYTXtLj/G6YWX+A0JFKgNuOkJUmWHH+74Zb+l/rEBZa3cG0Pm+wS0oVoM
         JJc/xJfVYFytI7KkOlSmRYHXXfKnpOUqGr14M4WWTAiDRoIOQEAbi1RhwDEyftVx8iE1
         qTGWi5o0M8XmZA4sm6PwKuKmCuDHSvHJ/dW721dR+EVSjpTd5Ea+hdGPet6ksQlqrQ70
         IzKHzXcvu97BG+TN1VQ5rv2zsYYuLw1P9u8qC7ErdFQ/J+YxRycVJKt34XLBZ8lOCIRb
         Zr9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640357; x=1756245157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X4PaN1FBVh+xdnfphbKwqZhoaGiNxq0bOXNDJ6vx+5U=;
        b=H73dm+uOTJJLadIK6a1H9BW5pn8QftwLOVgRnjHeXms8CvkmRtb3ldgvziNseuKu+R
         Y/Njjv5XqR9WGmTwLwIjt2auTFNl0UjTDH1mRyyvOFHF/mshte6dXwEpcrzTFMqHV5IK
         qGDFA7A+nOaA6vbn2BunSehoYI2KDzVOum5ITdF7FU3L8aGR+LNrV8AphwAEncDwAszn
         1TJu38wc75sz6DLL8eU7EmZ5uncgm+CwZYNasIR8+VKhq1IiKFqQcbvC2msY3Q7HPDgH
         g6WMM4HD4bsWtpQuNMyHoJNh4ArvOtW9V5Spb+yaQXJiXPXaI05aE2cApHxQLTP7+ONJ
         8Fuw==
X-Forwarded-Encrypted: i=1; AJvYcCU7irs0msjzjLfj0xJw4z4Ll93k0h9D0P8RNYK/5XgUZ8TGjZRJsha0g7fvLWsJHAgiNtc4M0U=@lists.linux.dev
X-Gm-Message-State: AOJu0YzNirSpZKM1WYCnoaVsY9cAn+Y1hSGJ7y5XX8KHUsIh4nWVg38W
	GQ5NJtFTlSIGiGgzOGKPGVkKujIBVHoTmiSrS1+PZzheSPUkHvIph3O6eeStUV3ZupBEsYF/8xQ
	i/uUjql4T4V8ImQ==
X-Google-Smtp-Source: AGHT+IFsd9NA8cMc7rDL27Ho1qYY/f8xjo3m+B7JdKk4faCMk1aV/KdUXjy/UILcCgJqjvIHpGxiAh/dHHuItw==
X-Received: from wmcn3-n2.prod.google.com ([2002:a05:600c:c0c3:20b0:45b:4777:8063])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1e89:b0:459:e398:ed80 with SMTP id 5b1f17b1804b1-45b47a0700bmr2494445e9.32.1755640357365;
 Tue, 19 Aug 2025 14:52:37 -0700 (PDT)
Date: Tue, 19 Aug 2025 21:51:42 +0000
In-Reply-To: <20250819215156.2494305-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250819215156.2494305-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819215156.2494305-15-smostafa@google.com>
Subject: [PATCH v4 14/28] iommu/arm-smmu-v3: Add KVM mode in the driver
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a file only compiled for KVM mode.

At the moment it registers the driver with KVM, and add the hook
needed for memory allocation.

Next, it will create the array with available SMMUs and their
description.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/kvm_host.h             |  4 +++
 arch/arm64/kvm/iommu.c                        | 10 ++++--
 drivers/iommu/arm/arm-smmu-v3/Makefile        |  1 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 36 +++++++++++++++++++
 4 files changed, 49 insertions(+), 2 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fcb4b26072f7..52212c0f2e9c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1678,4 +1678,8 @@ struct kvm_iommu_ops;
 int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops);
 size_t kvm_iommu_pages(void);
 
+#ifdef CONFIG_ARM_SMMU_V3_PKVM
+size_t smmu_hyp_pgt_pages(void);
+#endif
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
index 5460b1bd44a6..0475f7c95c6c 100644
--- a/arch/arm64/kvm/iommu.c
+++ b/arch/arm64/kvm/iommu.c
@@ -17,10 +17,16 @@ int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops)
 
 size_t kvm_iommu_pages(void)
 {
+	size_t nr_pages = 0;
+
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
diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index 1918b4a64cb0..284ad71c5282 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -4,5 +4,6 @@ arm_smmu_v3-y := arm-smmu-v3.o arm-smmu-v3-common-hyp.o
 arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_IOMMUFD) += arm-smmu-v3-iommufd.o
 arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-$(CONFIG_TEGRA241_CMDQV) += tegra241-cmdqv.o
+arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_PKVM) += arm-smmu-v3-kvm.o
 
 obj-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
new file mode 100644
index 000000000000..ac4eac6d567f
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pKVM host driver for the Arm SMMUv3
+ *
+ * Copyright (C) 2022 Linaro Ltd.
+ */
+#include <asm/kvm_mmu.h>
+#include <asm/kvm_pkvm.h>
+
+#include <linux/of_platform.h>
+
+#include "arm-smmu-v3.h"
+#include "pkvm/arm_smmu_v3.h"
+
+extern struct kvm_iommu_ops kvm_nvhe_sym(smmu_ops);
+
+size_t smmu_hyp_pgt_pages(void)
+{
+	/*
+	 * SMMUv3 uses the same format as stage-2 and hence have the same memory
+	 * requirements, we add extra 500 pages for L2 ste.
+	 */
+	if (of_find_compatible_node(NULL, NULL, "arm,smmu-v3"))
+		return host_s2_pgtable_pages() + 500;
+	return 0;
+}
+
+static int kvm_arm_smmu_v3_register(void)
+{
+	if (!is_protected_kvm_enabled())
+		return 0;
+
+	return kvm_iommu_register_driver(kern_hyp_va(lm_alias(&kvm_nvhe_sym(smmu_ops))));
+};
+
+core_initcall(kvm_arm_smmu_v3_register);
-- 
2.51.0.rc1.167.g924127e9c0-goog

