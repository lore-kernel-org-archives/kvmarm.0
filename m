Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E01133D0
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:36 +0000 (UTC)
Received: by mail-wr1-f41.google.com with SMTP id q5so17271899wrv.0
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YdP3DX4BPrTeIfyGSx6/ywhf75AZ8OaGFBR5uBxLPeI=;
        b=gi1u327r3bwhgQ0jcZTy2ePBAObJbV74KeqIs4sLYZ6oCBJp3nQUuE781l7zOxjyJ0
         ht6clbf/Nk0rHGcIOoMHocLZTvz8WilfSn+eFjPb6R2j8LiNxXnu+x9FhW0Yr/+GAJfJ
         oMlpmE2yqEmbbW+m1ySj4CoRKcfvyM//ZIKSPCuqF4iaED1c4MoCccfGSqtvFZZtZx6y
         Vv1VizuB1FUNOOWizObIzkAeT7mcqoaCmWnvzlnFf569Fk7jM69tjzbXZeBJ9C9xfOBI
         reVXapwJdiLdHDi91UXtNiQkNhEKs2UNCli76l4WX0/7mDWAxEP3DX3ZwzR8tMqntD6Z
         MRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YdP3DX4BPrTeIfyGSx6/ywhf75AZ8OaGFBR5uBxLPeI=;
        b=f5svp33DqTslZrnDmFfN5na948X3+pnfYJMfArntNeubcSwyIs4qgClXkLTsKtj54f
         1lcko3OoKU0LhTPc4JrppZ32kCl0PWPVsjL/aj60PoukV3zXwiQzHIw/xlqvJWYp7smB
         w4BcTXm50QRv3GRhlWSs4JOmPzhb76ECb1CmjHnV5dH7TEkk2NtbTpXVLb2UvQnUICqZ
         okjuMOkftCosEtnMDQqB+0u6IVA+Gw7IDDmNrFCeKDIpS6NS5su0pqjgZb4JZuGPn75p
         TZ0WVCvHe8p92Ue0ElfWIKlwqzdh6WS6ebfWNCpPuqgr/EleNCi1HQCou0uSNQANYSH6
         2QFw==
X-Gm-Message-State: AO0yUKVuxbe3VWXIbw5j6RGoBXbug8otCHh1TgYXl8dl7AvjxOaBPnpM
	KAQE0j7fETIB5+a54JHC6BkYOg==
X-Google-Smtp-Source: AK7set9uV9gcpJddzgbgGf+mtj837ImA617uXmGOdJV7SZrqmyd74oHFIscY1a8OJzgCGXL0U+HhLg==
X-Received: by 2002:adf:f911:0:b0:2bd:e7a0:6b5e with SMTP id b17-20020adff911000000b002bde7a06b5emr2317032wrr.40.1675256376014;
        Wed, 01 Feb 2023 04:59:36 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:35 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 21/45] KVM: arm64: iommu: Add SMMUv3 driver
Date: Wed,  1 Feb 2023 12:53:05 +0000
Message-Id: <20230201125328.2186498-22-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the skeleton for an Arm SMMUv3 driver at EL2.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 drivers/iommu/Kconfig                       | 10 ++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile            |  1 +
 arch/arm64/include/asm/kvm_host.h           |  1 +
 arch/arm64/kvm/hyp/include/nvhe/iommu.h     |  9 +++++++
 include/kvm/arm_smmu_v3.h                   | 22 +++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 27 +++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c             |  2 ++
 7 files changed, 72 insertions(+)
 create mode 100644 include/kvm/arm_smmu_v3.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 79707685d54a..1689d416ccd8 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -410,6 +410,16 @@ config ARM_SMMU_V3_SVA
 	  Say Y here if your system supports SVA extensions such as PCIe PASID
 	  and PRI.
 
+config ARM_SMMU_V3_PKVM
+	bool "ARM SMMUv3 support for protected Virtual Machines"
+	depends on KVM && ARM64
+	select KVM_IOMMU
+	help
+	  Enable a SMMUv3 driver in the KVM hypervisor, to protect VMs against
+	  memory accesses from devices owned by the host.
+
+	  Say Y here if you intend to enable KVM in protected mode.
+
 config S390_IOMMU
 	def_bool y if S390 && PCI
 	depends on S390 && PCI
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index f7dfc88c9f5b..349c874762c8 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -29,6 +29,7 @@ hyp-obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 hyp-obj-y += $(lib-objs)
 
 hyp-obj-$(CONFIG_KVM_IOMMU) += iommu/iommu.o
+hyp-obj-$(CONFIG_ARM_SMMU_V3_PKVM) += iommu/arm-smmu-v3.o
 
 ##
 ## Build rules for compiling nVHE hyp code
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b8e032bda022..c98ce17f8148 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -379,6 +379,7 @@ extern u64 kvm_nvhe_sym(hyp_cpu_logical_map)[NR_CPUS];
 
 enum kvm_iommu_driver {
 	KVM_IOMMU_DRIVER_NONE,
+	KVM_IOMMU_DRIVER_SMMUV3,
 };
 
 struct vcpu_reset_state {
diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index 76d3fa6ce331..0ba59d20bef3 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -5,6 +5,15 @@
 #include <kvm/iommu.h>
 #include <linux/io-pgtable.h>
 
+#if IS_ENABLED(CONFIG_ARM_SMMU_V3_PKVM)
+int kvm_arm_smmu_v3_register(void);
+#else /* CONFIG_ARM_SMMU_V3_PKVM */
+static inline int kvm_arm_smmu_v3_register(void)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_ARM_SMMU_V3_PKVM */
+
 #if IS_ENABLED(CONFIG_KVM_IOMMU)
 int kvm_iommu_init(void);
 int kvm_iommu_init_device(struct kvm_hyp_iommu *iommu);
diff --git a/include/kvm/arm_smmu_v3.h b/include/kvm/arm_smmu_v3.h
new file mode 100644
index 000000000000..ebe488b2f93c
--- /dev/null
+++ b/include/kvm/arm_smmu_v3.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_ARM_SMMU_V3_H
+#define __KVM_ARM_SMMU_V3_H
+
+#include <asm/kvm_asm.h>
+#include <kvm/iommu.h>
+
+#if IS_ENABLED(CONFIG_ARM_SMMU_V3_PKVM)
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
+#endif /* CONFIG_ARM_SMMU_V3_PKVM */
+
+#endif /* __KVM_ARM_SMMU_V3_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
new file mode 100644
index 000000000000..c167e4dbd28d
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -0,0 +1,27 @@
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
+struct hyp_arm_smmu_v3_device __ro_after_init *kvm_hyp_arm_smmu_v3_smmus;
+
+static int smmu_init(void)
+{
+	return -ENOSYS;
+}
+
+static struct kvm_iommu_ops smmu_ops = {
+	.init				= smmu_init,
+};
+
+int kvm_arm_smmu_v3_register(void)
+{
+	kvm_iommu_ops = smmu_ops;
+	return 0;
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 3e73c066d560..a25de8c5d489 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -294,6 +294,8 @@ static int select_iommu_ops(enum kvm_iommu_driver driver)
 	switch (driver) {
 	case KVM_IOMMU_DRIVER_NONE:
 		return 0;
+	case KVM_IOMMU_DRIVER_SMMUV3:
+		return kvm_arm_smmu_v3_register();
 	}
 
 	return -EINVAL;
-- 
2.39.0

