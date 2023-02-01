Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5455F63C7
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:40 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id a3so10534380wrt.6
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BKjgmaDxLkmrQ0mpxwx2r9pGg6x4GEO3iHZz6Uf5p3w=;
        b=li73nmc1UxwrkMWjkGKFFhTVQtrHociEVH9aYlHsY9ZKApJNsJx7aTCpI2BzVQGSVB
         hBkwUB/RWJWUZ4yqLIl2Y9KPBcRezlTjL3RAB9Ztcn9gHLHOEgjY5BU9iKVYIqN+oZxW
         musGWcucKajPIP8AF4AZ8MbembXZgbejsfKvMg4DodT/iPV3e4bUFnrqmOCnuq0p/wg/
         2NkB3jwUmyzAg4RRPrK7FpYWu7SEPYM6DT0Wd4jgqd6vATEZkchKW5bNFyCSKBPtm8/S
         5JQki4YOGVI2Wz77ZTbUBm1ss/Oms4VhtxdJklLOIydXox4fVdVJ8VbwnbRuehbT4YZz
         7J5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BKjgmaDxLkmrQ0mpxwx2r9pGg6x4GEO3iHZz6Uf5p3w=;
        b=ACbu/iYedH4NkEavxb83B+6SP5uXysZ0TX/xcRrED9ZCtnSg/yBavWfgkokTB47xep
         yHF0HVYTYXGDisex6nvsmMlJ0xF4HgnylfMp76COIIiSt65Y1R6W/Gdge9rTpsoOAot+
         fnxGWC2RDnG2wUJo3bJiq66ng7LTx4rU/gyC4gcpw2CnxjIIyrDbWCoMPZZfbfVLzDSG
         S2DyGdP7YQdVIE4alwi69uNZxGgDLFymP2MN2DPWVsDgDDHHY+VzhVNyfoLPlo58zsrE
         FBTqJpRKxNvwQOwPzL6LqTJRexMaNR5LUcL3PUF9GYZIc5czGpza4PCvwFW4m+es51M7
         NfZQ==
X-Gm-Message-State: AO0yUKXFeXelqRlIFQvei9XrbE1nw9VlsdQMEaiNKNErMUWY4BZ73MUZ
	cYe9t2iA6+OQgQc+mDALgTGoyA==
X-Google-Smtp-Source: AK7set929JCQtOsi6+aIpV+17WDiEBZh7VrjLqph/lKy2FUykdpHt3ALamuIzZ3nT3DrqEwV0ZjE+A==
X-Received: by 2002:a5d:47a2:0:b0:2bf:b5bd:8f60 with SMTP id 2-20020a5d47a2000000b002bfb5bd8f60mr1982390wrb.61.1675256379854;
        Wed, 01 Feb 2023 04:59:39 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:39 -0800 (PST)
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
Subject: [RFC PATCH 26/45] KVM: arm64: smmu-v3: Support io-pgtable
Date: Wed,  1 Feb 2023 12:53:10 +0000
Message-Id: <20230201125328.2186498-27-jean-philippe@linaro.org>
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

Implement the hypervisor version of io-pgtable allocation functions,
mirroring drivers/iommu/io-pgtable-arm.c. Page allocation uses the IOMMU
memcache filled by the host, except for the PGD which may be larger than
a page.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/nvhe/Makefile              |  2 +
 arch/arm64/kvm/hyp/include/nvhe/iommu.h       |  7 ++
 include/linux/io-pgtable-arm.h                |  6 ++
 .../arm64/kvm/hyp/nvhe/iommu/io-pgtable-arm.c | 97 +++++++++++++++++++
 4 files changed, 112 insertions(+)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/iommu/io-pgtable-arm.c

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 349c874762c8..8359909bd796 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -30,6 +30,8 @@ hyp-obj-y += $(lib-objs)
 
 hyp-obj-$(CONFIG_KVM_IOMMU) += iommu/iommu.o
 hyp-obj-$(CONFIG_ARM_SMMU_V3_PKVM) += iommu/arm-smmu-v3.o
+hyp-obj-$(CONFIG_ARM_SMMU_V3_PKVM) += iommu/io-pgtable-arm.o \
+	../../../../../drivers/iommu/io-pgtable-arm-common.o
 
 ##
 ## Build rules for compiling nVHE hyp code
diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index 0ba59d20bef3..c7744cca6e13 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -6,7 +6,14 @@
 #include <linux/io-pgtable.h>
 
 #if IS_ENABLED(CONFIG_ARM_SMMU_V3_PKVM)
+#include <linux/io-pgtable-arm.h>
+
 int kvm_arm_smmu_v3_register(void);
+
+int kvm_arm_io_pgtable_init(struct io_pgtable_cfg *cfg,
+			    struct arm_lpae_io_pgtable *data);
+int kvm_arm_io_pgtable_alloc(struct io_pgtable *iop, unsigned long pgd_hva);
+int kvm_arm_io_pgtable_free(struct io_pgtable *iop);
 #else /* CONFIG_ARM_SMMU_V3_PKVM */
 static inline int kvm_arm_smmu_v3_register(void)
 {
diff --git a/include/linux/io-pgtable-arm.h b/include/linux/io-pgtable-arm.h
index 2b3e69386d08..b89b8ec57721 100644
--- a/include/linux/io-pgtable-arm.h
+++ b/include/linux/io-pgtable-arm.h
@@ -161,8 +161,14 @@ static inline bool iopte_leaf(arm_lpae_iopte pte, int lvl,
 	return iopte_type(pte) == ARM_LPAE_PTE_TYPE_BLOCK;
 }
 
+#ifdef __KVM_NVHE_HYPERVISOR__
+#include <nvhe/memory.h>
+#define __arm_lpae_virt_to_phys	hyp_virt_to_phys
+#define __arm_lpae_phys_to_virt	hyp_phys_to_virt
+#else
 #define __arm_lpae_virt_to_phys	__pa
 #define __arm_lpae_phys_to_virt	__va
+#endif
 
 /* Generic functions */
 void __arm_lpae_free_pgtable(struct arm_lpae_io_pgtable *data, int lvl,
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/io-pgtable-arm.c b/arch/arm64/kvm/hyp/nvhe/iommu/io-pgtable-arm.c
new file mode 100644
index 000000000000..a46490acb45c
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/io-pgtable-arm.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2022 Arm Ltd.
+ */
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+#include <kvm/arm_smmu_v3.h>
+#include <linux/types.h>
+#include <linux/gfp_types.h>
+#include <linux/io-pgtable-arm.h>
+
+#include <nvhe/iommu.h>
+#include <nvhe/mem_protect.h>
+
+bool __ro_after_init selftest_running;
+
+void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp, struct io_pgtable_cfg *cfg)
+{
+	void *addr = kvm_iommu_donate_page();
+
+	BUG_ON(size != PAGE_SIZE);
+
+	if (addr && !cfg->coherent_walk)
+		kvm_flush_dcache_to_poc(addr, size);
+
+	return addr;
+}
+
+void __arm_lpae_free_pages(void *addr, size_t size, struct io_pgtable_cfg *cfg)
+{
+	BUG_ON(size != PAGE_SIZE);
+
+	if (!cfg->coherent_walk)
+		kvm_flush_dcache_to_poc(addr, size);
+
+	kvm_iommu_reclaim_page(addr);
+}
+
+void __arm_lpae_sync_pte(arm_lpae_iopte *ptep, int num_entries,
+			 struct io_pgtable_cfg *cfg)
+{
+	if (!cfg->coherent_walk)
+		kvm_flush_dcache_to_poc(ptep, sizeof(*ptep) * num_entries);
+}
+
+int kvm_arm_io_pgtable_init(struct io_pgtable_cfg *cfg,
+			    struct arm_lpae_io_pgtable *data)
+{
+	int ret = arm_lpae_init_pgtable_s2(cfg, data);
+
+	if (ret)
+		return ret;
+
+	data->iop.cfg = *cfg;
+	return 0;
+}
+
+int kvm_arm_io_pgtable_alloc(struct io_pgtable *iopt, unsigned long pgd_hva)
+{
+	size_t pgd_size, alignment;
+	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(iopt->ops);
+
+	pgd_size = ARM_LPAE_PGD_SIZE(data);
+	/*
+	 * If it has eight or more entries, the table must be aligned on
+	 * its size. Otherwise 64 bytes.
+	 */
+	alignment = max(pgd_size, 8 * sizeof(arm_lpae_iopte));
+	if (!IS_ALIGNED(pgd_hva, alignment))
+		return -EINVAL;
+
+	iopt->pgd = pkvm_map_donated_memory(pgd_hva, pgd_size);
+	if (!iopt->pgd)
+		return -ENOMEM;
+
+	if (!data->iop.cfg.coherent_walk)
+		kvm_flush_dcache_to_poc(iopt->pgd, pgd_size);
+
+	/* Ensure the empty pgd is visible before any actual TTBR write */
+	wmb();
+
+	return 0;
+}
+
+int kvm_arm_io_pgtable_free(struct io_pgtable *iopt)
+{
+	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(iopt->ops);
+	size_t pgd_size = ARM_LPAE_PGD_SIZE(data);
+
+	if (!data->iop.cfg.coherent_walk)
+		kvm_flush_dcache_to_poc(iopt->pgd, pgd_size);
+
+	/* Free all tables but the pgd */
+	__arm_lpae_free_pgtable(data, data->start_level, iopt->pgd, true);
+	pkvm_unmap_donated_memory(iopt->pgd, pgd_size);
+	return 0;
+}
-- 
2.39.0

