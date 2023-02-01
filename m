Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360AD63B2
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:37 +0000 (UTC)
Received: by mail-wr1-f49.google.com with SMTP id m7so17222734wru.8
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U/1E+V5Gw5Rx46TOmlvRjgOfJHiZaXebZrwYicZFtkM=;
        b=rbZDUky7hyOUseO47rt8pNa6lE8iRS4ovMkNWarTthOMVpGeSQTtP9qSj/majBB5iD
         vOznM2LLhpX3MQkqjmXs3AYAF8ghw1OTIEDc76WKJQrvnjh8u0YE9fDgf1Z3b3FrEGW7
         pLkItik7KqD7NZnCEul3NZTQpobfUf3cdZGPN9vwUxyAxwJp8RWyqiEdT1difM66qKSX
         4xlI7H73dui8mKy5RjxRRlqu1QvGnVfkF8xvsTjM0yHEq/DN+YRnjVrw9cf8hIVX6PL8
         XZMuV64GrB2ooxI9UVxJZ0/Ua+0tPoE/N76WNmcnBctnBf8INDZ2DepTqt98rmNCRuus
         Lh+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U/1E+V5Gw5Rx46TOmlvRjgOfJHiZaXebZrwYicZFtkM=;
        b=nzM+fbKs4ZrjWdfj+myvT8RMioRA/nYX4XQ1YAHwvRhTaQ3l6Obv3wkjjDBTZhe6YR
         x+ZWur1+0IhrcawsfOSdHvuwDY8x/LCVppoPPi/a0iZOzXvn7TQQcz1+0uXA5aoh5fSJ
         PVoq2j2ge0IM8Xb6flUwJHNzLomwjIvTNKH2AnYeUoVGN3NF+5fyxf25guT27n2E0vxN
         J/NixpzyGk/hTzOMTHZXv6WIaWVACqwbQb+s9OO9NpPcCh4jKBQMyxdX+hXSHefoPEN4
         JoLk40JTzU2rld5lGg0Pe4WDMs8i5d3CbPj8EDSj53Inwt1wjASiT83cYOEGdxm9rBQH
         o6dg==
X-Gm-Message-State: AO0yUKWGsGVDFIdqFrfpZv+G/VRLr2DGw8wn3l5yXv4Ayw99iqyFlTiL
	OZMQme8BpvN29m4/dP7u87h0DQ==
X-Google-Smtp-Source: AK7set9e0pBWb6kGtQQaKRSuYaYQ3aayGueAvARL6oWlBrFe/ohTg7/zUWlhu/MDSt+NySkK0eZRyA==
X-Received: by 2002:adf:ef05:0:b0:2bf:d72b:d039 with SMTP id e5-20020adfef05000000b002bfd72bd039mr2394106wro.10.1675256376784;
        Wed, 01 Feb 2023 04:59:36 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:36 -0800 (PST)
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
Subject: [RFC PATCH 22/45] KVM: arm64: smmu-v3: Initialize registers
Date: Wed,  1 Feb 2023 12:53:06 +0000
Message-Id: <20230201125328.2186498-23-jean-philippe@linaro.org>
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

Ensure all writable registers are properly initialized. We do not touch
registers that will not be read by the SMMU due to disabled features,
such as event queue registers.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/kvm/arm_smmu_v3.h                   |  11 +++
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 103 +++++++++++++++++++-
 2 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/include/kvm/arm_smmu_v3.h b/include/kvm/arm_smmu_v3.h
index ebe488b2f93c..d4b1e487b7d7 100644
--- a/include/kvm/arm_smmu_v3.h
+++ b/include/kvm/arm_smmu_v3.h
@@ -7,8 +7,19 @@
 
 #if IS_ENABLED(CONFIG_ARM_SMMU_V3_PKVM)
 
+/*
+ * Parameters from the trusted host:
+ * @mmio_addr		base address of the SMMU registers
+ * @mmio_size		size of the registers resource
+ *
+ * Other members are filled and used at runtime by the SMMU driver.
+ */
 struct hyp_arm_smmu_v3_device {
 	struct kvm_hyp_iommu	iommu;
+	phys_addr_t		mmio_addr;
+	size_t			mmio_size;
+
+	void __iomem		*base;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
index c167e4dbd28d..75a6aa01b057 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -4,16 +4,117 @@
  *
  * Copyright (C) 2022 Linaro Ltd.
  */
+#include <asm/arm-smmu-v3-regs.h>
 #include <asm/kvm_hyp.h>
 #include <kvm/arm_smmu_v3.h>
 #include <nvhe/iommu.h>
+#include <nvhe/mm.h>
+#include <nvhe/pkvm.h>
+
+#define ARM_SMMU_POLL_TIMEOUT_US	1000000 /* 1s! */
 
 size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
 struct hyp_arm_smmu_v3_device __ro_after_init *kvm_hyp_arm_smmu_v3_smmus;
 
+#define for_each_smmu(smmu) \
+	for ((smmu) = kvm_hyp_arm_smmu_v3_smmus; \
+	     (smmu) != &kvm_hyp_arm_smmu_v3_smmus[kvm_hyp_arm_smmu_v3_count]; \
+	     (smmu)++)
+
+/*
+ * Wait until @cond is true.
+ * Return 0 on success, or -ETIMEDOUT
+ */
+#define smmu_wait(_cond)					\
+({								\
+	int __i = 0;						\
+	int __ret = 0;						\
+								\
+	while (!(_cond)) {					\
+		if (++__i > ARM_SMMU_POLL_TIMEOUT_US) {		\
+			__ret = -ETIMEDOUT;			\
+			break;					\
+		}						\
+		pkvm_udelay(1);					\
+	}							\
+	__ret;							\
+})
+
+static int smmu_write_cr0(struct hyp_arm_smmu_v3_device *smmu, u32 val)
+{
+	writel_relaxed(val, smmu->base + ARM_SMMU_CR0);
+	return smmu_wait(readl_relaxed(smmu->base + ARM_SMMU_CR0ACK) == val);
+}
+
+static int smmu_init_registers(struct hyp_arm_smmu_v3_device *smmu)
+{
+	u64 val, old;
+
+	if (!(readl_relaxed(smmu->base + ARM_SMMU_GBPA) & GBPA_ABORT))
+		return -EINVAL;
+
+	/* Initialize all RW registers that will be read by the SMMU */
+	smmu_write_cr0(smmu, 0);
+
+	val = FIELD_PREP(CR1_TABLE_SH, ARM_SMMU_SH_ISH) |
+	      FIELD_PREP(CR1_TABLE_OC, CR1_CACHE_WB) |
+	      FIELD_PREP(CR1_TABLE_IC, CR1_CACHE_WB) |
+	      FIELD_PREP(CR1_QUEUE_SH, ARM_SMMU_SH_ISH) |
+	      FIELD_PREP(CR1_QUEUE_OC, CR1_CACHE_WB) |
+	      FIELD_PREP(CR1_QUEUE_IC, CR1_CACHE_WB);
+	writel_relaxed(val, smmu->base + ARM_SMMU_CR1);
+	writel_relaxed(CR2_PTM, smmu->base + ARM_SMMU_CR2);
+	writel_relaxed(0, smmu->base + ARM_SMMU_IRQ_CTRL);
+
+	val = readl_relaxed(smmu->base + ARM_SMMU_GERROR);
+	old = readl_relaxed(smmu->base + ARM_SMMU_GERRORN);
+	/* Service Failure Mode is fatal */
+	if ((val ^ old) & GERROR_SFM_ERR)
+		return -EIO;
+	/* Clear pending errors */
+	writel_relaxed(val, smmu->base + ARM_SMMU_GERRORN);
+
+	return 0;
+}
+
+static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
+{
+	int ret;
+
+	if (!PAGE_ALIGNED(smmu->mmio_addr | smmu->mmio_size))
+		return -EINVAL;
+
+	ret = pkvm_create_hyp_device_mapping(smmu->mmio_addr, smmu->mmio_size,
+					     &smmu->base);
+	if (IS_ERR(smmu->base))
+		return PTR_ERR(smmu->base);
+
+	ret = smmu_init_registers(smmu);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int smmu_init(void)
 {
-	return -ENOSYS;
+	int ret;
+	struct hyp_arm_smmu_v3_device *smmu;
+
+	ret = pkvm_create_mappings(kvm_hyp_arm_smmu_v3_smmus,
+				   kvm_hyp_arm_smmu_v3_smmus +
+				   kvm_hyp_arm_smmu_v3_count,
+				   PAGE_HYP);
+	if (ret)
+		return ret;
+
+	for_each_smmu(smmu) {
+		ret = smmu_init_device(smmu);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static struct kvm_iommu_ops smmu_ops = {
-- 
2.39.0

