Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E8C2368E5
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026738; cv=none; b=Zv9keM4gZXK3cDAmKT9cGrJWUzPYHz4QALk+z0QzMtKlYEJRZLa+MNS+KnIHRc8aDbJlrNjLnQRry7Cq4XvqFqoIURNQmBoEBtwp5ITJOalZjrnbS65iwT050fmuIySYbYT2MCIBKBZ8PjaDMmQ2WKL72E2oArx47XljjMuKjIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026738; c=relaxed/simple;
	bh=Z2UHwzkM46eNyOELnlSu5KplZV6dyg6FmiiX5LeoOuQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PMInivWQegoOMo97bI5x2Uk6sxiu5pZvIQ497fxdg0o1Y39xQ99lcPliBZ34MTWFmqaK3C2AMwKsuVxo/V48SjMzAU6SDuuM6BgA1SZEMCNEpUTsLviqhP+826lGPicq8SCRV7hmqmbmAMMK2aJ3+B2Ij05paiywhfMyvlp+ONk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CDc1q309; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CDc1q309"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43624b081f3so8258375e9.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026735; x=1734631535; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YdMuO2gtmeL3RMqWaakXFL6M4DlcZZq40B5WqzcNta4=;
        b=CDc1q309AceL53kcTRrKKHLpQ1cvHv/Kx+OgBvZb9w6hmk5gT8sr9tA9AYyKwxOvY7
         Dw2yCefOOOaL8Iyx71g/YNRjjKK0dJWthzWjnWXIBdvcKht9e3tEi3xUDOZ7vFR6uboH
         vn01iVSqS3f0Coq/X9WdFyRshV/3ZyWzL8EB/pTmcofPFn4eIz1+EMh+uYOD+gBuMgLY
         8Dze83dzESYijqsrS1e1cJZ3l4s4kpOzyOMhlg5hb3zsbJD2ui06IX/fafg27GA1+V45
         1gOH11W/JiTqkuKQkYJHvNcqnNnahn6PkcT+idJlFWtm3GmMKIchOlKQ5khjffIOvSZY
         hzRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026735; x=1734631535;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YdMuO2gtmeL3RMqWaakXFL6M4DlcZZq40B5WqzcNta4=;
        b=XXvZVY6FRfLm4X8wh1rX71ri/sLuzIlGEufAaA2DYNYD5AOHor98Bq1kO6+YKdMg2y
         e8D94PL9zxkmwxuVzFPhSIa58QXHJ/CGFvz7XW4x9XMWlcRTpwZdtVC83dOBTzaDLuj1
         VmUYGwsoQ8+Ac8gUSuLbvp4EfwGbMOBi0DTBTtOgU1E6dfkcCGkQ3CW7cKYwebEhq6Wv
         lrBHnV192Hs6y+CuY8R4vKYKgMwyHxpavoEdat5So3cQM16GYCzZQbwUONwvUxqj5xY3
         uY1kf802MlEfdrA06ecS9VZCPMItEqyDBQx53vRSfRldZ6ExNyXyXKZ6Kytanr1t2P0g
         Ffog==
X-Forwarded-Encrypted: i=1; AJvYcCXeWYnxBbQO9/wkQyDifEeNS7oYmB+RwuulyUNcbJasdsUy4sk0bisC1JHshW801qY3fm7sk+c=@lists.linux.dev
X-Gm-Message-State: AOJu0YzHI+0VdoIDgx3ye0skMgQSN8hDE6zIBhPy5qTYxB/CLWzYbqMd
	DGMz5q+dJJnXT+07g9Tcjy/xHCic6+fyhCvhQHCE5YYdQwAVpUV/0Bu+/aXQt2Z+czivbysI9/4
	LLJ9I2d1bsg==
X-Google-Smtp-Source: AGHT+IFhLgvU2Rm+DNubCv6JNasQpuX6sd+/DiydVh4HkRumx8mqOJN1mpnAimZm+KH9fDL3y3s/kc2a4/LuEQ==
X-Received: from wmso20.prod.google.com ([2002:a05:600c:5114:b0:436:1abf:b8fe])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5028:b0:435:172:5052 with SMTP id 5b1f17b1804b1-4362282768bmr38379225e9.1.1734026735825;
 Thu, 12 Dec 2024 10:05:35 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:49 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-26-smostafa@google.com>
Subject: [RFC PATCH v2 25/58] KVM: arm64: iommu: Add SMMUv3 driver
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

Add the skeleton for an Arm SMMUv3 driver at EL2.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile            |  2 ++
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 22 +++++++++++++++++++++
 drivers/iommu/Kconfig                       |  9 +++++++++
 include/kvm/arm_smmu_v3.h                   | 18 +++++++++++++++++
 4 files changed, 51 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
 create mode 100644 include/kvm/arm_smmu_v3.h

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index d846962e7246..edfd8a11ac90 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -16,6 +16,8 @@ hyp-obj-$(CONFIG_TRACING) += clock.o events.o trace.o
 hyp-obj-$(CONFIG_MODULES) += modules.o
 hyp-obj-y += $(lib-objs)
 
+hyp-obj-$(CONFIG_ARM_SMMU_V3_PKVM) += iommu/arm-smmu-v3.o
+
 $(obj)/hyp.lds: $(src)/hyp.lds.S FORCE
 	$(call if_changed_dep,cpp_lds_S)
 
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
new file mode 100644
index 000000000000..d2a570c9f3ec
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pKVM hyp driver for the Arm SMMUv3
+ *
+ * Copyright (C) 2022 Linaro Ltd.
+ */
+#include <asm/kvm_hyp.h>
+#include <kvm/arm_smmu_v3.h>
+#include <nvhe/iommu.h>
+
+size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
+struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
+
+static int smmu_init(void)
+{
+	return -ENOSYS;
+}
+
+/* Shared with the kernel driver in EL1 */
+struct kvm_iommu_ops smmu_ops = {
+	.init				= smmu_init,
+};
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index b3aa1f5d5321..fea5d6a8b90b 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -437,6 +437,15 @@ config TEGRA241_CMDQV
 	  CMDQ-V extension.
 endif
 
+config ARM_SMMU_V3_PKVM
+	bool "ARM SMMUv3 support for protected Virtual Machines"
+	depends on KVM && ARM64
+	help
+	  Enable a SMMUv3 driver in the KVM hypervisor, to protect VMs against
+	  memory accesses from devices owned by the host.
+
+	  Say Y here if you intend to enable KVM in protected mode.
+
 config S390_IOMMU
 	def_bool y if S390 && PCI
 	depends on S390 && PCI
diff --git a/include/kvm/arm_smmu_v3.h b/include/kvm/arm_smmu_v3.h
new file mode 100644
index 000000000000..521028b3ff71
--- /dev/null
+++ b/include/kvm/arm_smmu_v3.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_ARM_SMMU_V3_H
+#define __KVM_ARM_SMMU_V3_H
+
+#include <asm/kvm_asm.h>
+#include <kvm/iommu.h>
+
+struct hyp_arm_smmu_v3_device {
+	struct kvm_hyp_iommu	iommu;
+};
+
+extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
+#define kvm_hyp_arm_smmu_v3_count kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count)
+
+extern struct hyp_arm_smmu_v3_device *kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_smmus);
+#define kvm_hyp_arm_smmu_v3_smmus kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_smmus)
+
+#endif /* __KVM_ARM_SMMU_V3_H */
-- 
2.47.0.338.g60cca15819-goog

