Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EE26ADC
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:43 +0000 (UTC)
Received: by mail-wr1-f46.google.com with SMTP id h16so17197270wrz.12
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZWyvRGjN1hWh9Kt9qhU/sgEA46LGfzgFOOld/1yFu4=;
        b=dfScr3h3qshLBf1B014FouB4z/1CopKuz/MO/EE7+b9TesnPty6Em1E6tfi4iIIXBd
         zZ1RPy2uQ2uzr39P/WO7S5/EstvRwh2WysL1DjmICiH/ol53CsuzE9aMz6WzHz4UM3ms
         GGy6J3Y0aXV175rCm4P2OqRpvFBIzXuBjucPQV4ykIWmL51Z7F3OVtQSfzAjxAuZrITu
         525vg9jwehAFP5gOiHrwXKFPAWLGwxcCtb84aXEBeT+lc4bnHFOf0fOmZ/MHixOqWdDW
         F4avwa0bBpUs01oIzK+dFZsBKJA9vJqpV2cIASIeYO9D7lVyQULape1NZoML4B+KGba1
         VYrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eZWyvRGjN1hWh9Kt9qhU/sgEA46LGfzgFOOld/1yFu4=;
        b=Q1piZuYtZOfuXscbqUhxm/x9fDmD1fgxOnHlTGEY1eUZv7odt/lMWrbzhmVC7dEIPf
         RlyOzHKb+MS7dSLLy/btb+uThFF6nqJUohZwvnU2dPJlx5mmv54AQzqnOg/OEFtFLS93
         yPkrzoEr9YogwP7r8SfWToE5V7ujo9h1Hm3xYjjWzTGsv/HHIKxUfQ/LvXr+4ih9Xoau
         lTyc5IVaXSQenDNSTGyIIhs1iBYZGuvB4JiGX+3H92Widk1wlQSQeHmbb2lSVcFICZM8
         IcWtEMdcNlt503R9nIayVKvcGSa4mUNbZ4ybmeYhZR6Ry0bZ2G/DC77L60NGWYGLYPye
         FRdg==
X-Gm-Message-State: AO0yUKVesQvmDL0obSG93rL+YqqDQVcaQETN/QqxitDLySdBO8dZaFWm
	ZCcR0n8FTSFqR9Mt9l9rpUvv8w==
X-Google-Smtp-Source: AK7set+SAZmma/mIC/SofWrwrAByNMx0pHWI7IJggK0gg3QH5HvjERWTG3NiPGqqX7n2D+i7IeOrpQ==
X-Received: by 2002:a5d:4fce:0:b0:2bf:b672:689b with SMTP id h14-20020a5d4fce000000b002bfb672689bmr1568372wrw.62.1675256382262;
        Wed, 01 Feb 2023 04:59:42 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:41 -0800 (PST)
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
Subject: [RFC PATCH 29/45] iommu/arm-smmu-v3: Move some functions to arm-smmu-v3-common.c
Date: Wed,  1 Feb 2023 12:53:13 +0000
Message-Id: <20230201125328.2186498-30-jean-philippe@linaro.org>
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

Move functions that can be shared between normal and KVM drivers to
arm-smmu-v3-common.c

Only straightforward moves here. More subtle factoring will be done in
then next patches.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 drivers/iommu/arm/arm-smmu-v3/Makefile        |   1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   9 +
 .../arm/arm-smmu-v3/arm-smmu-v3-common.c      | 296 ++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 293 -----------------
 4 files changed, 306 insertions(+), 293 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c

diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index 54feb1ecccad..c4fcc796213c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
 arm_smmu_v3-objs-y += arm-smmu-v3.o
+arm_smmu_v3-objs-y += arm-smmu-v3-common.o
 arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-objs := $(arm_smmu_v3-objs-y)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 32ce835ab4eb..59e8101d4ff5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -269,6 +269,15 @@ extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
+int arm_smmu_write_reg_sync(struct arm_smmu_device *smmu, u32 val,
+			    unsigned int reg_off, unsigned int ack_off);
+int arm_smmu_update_gbpa(struct arm_smmu_device *smmu, u32 set, u32 clr);
+int arm_smmu_device_disable(struct arm_smmu_device *smmu);
+bool arm_smmu_capable(struct device *dev, enum iommu_cap cap);
+struct iommu_group *arm_smmu_device_group(struct device *dev);
+int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args *args);
+int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu);
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_domain *smmu_domain, int ssid,
 			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
new file mode 100644
index 000000000000..5e43329c0826
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
@@ -0,0 +1,296 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/dma-mapping.h>
+#include <linux/iopoll.h>
+#include <linux/pci.h>
+
+#include "arm-smmu-v3.h"
+
+int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
+{
+	u32 reg;
+	bool coherent = smmu->features & ARM_SMMU_FEAT_COHERENCY;
+
+	/* IDR0 */
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR0);
+
+	/* 2-level structures */
+	if (FIELD_GET(IDR0_ST_LVL, reg) == IDR0_ST_LVL_2LVL)
+		smmu->features |= ARM_SMMU_FEAT_2_LVL_STRTAB;
+
+	if (reg & IDR0_CD2L)
+		smmu->features |= ARM_SMMU_FEAT_2_LVL_CDTAB;
+
+	/*
+	 * Translation table endianness.
+	 * We currently require the same endianness as the CPU, but this
+	 * could be changed later by adding a new IO_PGTABLE_QUIRK.
+	 */
+	switch (FIELD_GET(IDR0_TTENDIAN, reg)) {
+	case IDR0_TTENDIAN_MIXED:
+		smmu->features |= ARM_SMMU_FEAT_TT_LE | ARM_SMMU_FEAT_TT_BE;
+		break;
+#ifdef __BIG_ENDIAN
+	case IDR0_TTENDIAN_BE:
+		smmu->features |= ARM_SMMU_FEAT_TT_BE;
+		break;
+#else
+	case IDR0_TTENDIAN_LE:
+		smmu->features |= ARM_SMMU_FEAT_TT_LE;
+		break;
+#endif
+	default:
+		dev_err(smmu->dev, "unknown/unsupported TT endianness!\n");
+		return -ENXIO;
+	}
+
+	/* Boolean feature flags */
+	if (IS_ENABLED(CONFIG_PCI_PRI) && reg & IDR0_PRI)
+		smmu->features |= ARM_SMMU_FEAT_PRI;
+
+	if (IS_ENABLED(CONFIG_PCI_ATS) && reg & IDR0_ATS)
+		smmu->features |= ARM_SMMU_FEAT_ATS;
+
+	if (reg & IDR0_SEV)
+		smmu->features |= ARM_SMMU_FEAT_SEV;
+
+	if (reg & IDR0_MSI) {
+		smmu->features |= ARM_SMMU_FEAT_MSI;
+		if (coherent)
+			smmu->options |= ARM_SMMU_OPT_MSIPOLL;
+	}
+
+	if (reg & IDR0_HYP) {
+		smmu->features |= ARM_SMMU_FEAT_HYP;
+		if (cpus_have_cap(ARM64_HAS_VIRT_HOST_EXTN))
+			smmu->features |= ARM_SMMU_FEAT_E2H;
+	}
+
+	/*
+	 * The coherency feature as set by FW is used in preference to the ID
+	 * register, but warn on mismatch.
+	 */
+	if (!!(reg & IDR0_COHACC) != coherent)
+		dev_warn(smmu->dev, "IDR0.COHACC overridden by FW configuration (%s)\n",
+			 coherent ? "true" : "false");
+
+	switch (FIELD_GET(IDR0_STALL_MODEL, reg)) {
+	case IDR0_STALL_MODEL_FORCE:
+		smmu->features |= ARM_SMMU_FEAT_STALL_FORCE;
+		fallthrough;
+	case IDR0_STALL_MODEL_STALL:
+		smmu->features |= ARM_SMMU_FEAT_STALLS;
+	}
+
+	if (reg & IDR0_S1P)
+		smmu->features |= ARM_SMMU_FEAT_TRANS_S1;
+
+	if (reg & IDR0_S2P)
+		smmu->features |= ARM_SMMU_FEAT_TRANS_S2;
+
+	if (!(reg & (IDR0_S1P | IDR0_S2P))) {
+		dev_err(smmu->dev, "no translation support!\n");
+		return -ENXIO;
+	}
+
+	/* We only support the AArch64 table format at present */
+	switch (FIELD_GET(IDR0_TTF, reg)) {
+	case IDR0_TTF_AARCH32_64:
+		smmu->ias = 40;
+		fallthrough;
+	case IDR0_TTF_AARCH64:
+		break;
+	default:
+		dev_err(smmu->dev, "AArch64 table format not supported!\n");
+		return -ENXIO;
+	}
+
+	/* ASID/VMID sizes */
+	smmu->asid_bits = reg & IDR0_ASID16 ? 16 : 8;
+	smmu->vmid_bits = reg & IDR0_VMID16 ? 16 : 8;
+
+	/* IDR1 */
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR1);
+	if (reg & (IDR1_TABLES_PRESET | IDR1_QUEUES_PRESET | IDR1_REL)) {
+		dev_err(smmu->dev, "embedded implementation not supported\n");
+		return -ENXIO;
+	}
+
+	/* Queue sizes, capped to ensure natural alignment */
+	smmu->cmdq.q.llq.max_n_shift = min_t(u32, CMDQ_MAX_SZ_SHIFT,
+					     FIELD_GET(IDR1_CMDQS, reg));
+	if (smmu->cmdq.q.llq.max_n_shift <= ilog2(CMDQ_BATCH_ENTRIES)) {
+		/*
+		 * We don't support splitting up batches, so one batch of
+		 * commands plus an extra sync needs to fit inside the command
+		 * queue. There's also no way we can handle the weird alignment
+		 * restrictions on the base pointer for a unit-length queue.
+		 */
+		dev_err(smmu->dev, "command queue size <= %d entries not supported\n",
+			CMDQ_BATCH_ENTRIES);
+		return -ENXIO;
+	}
+
+	smmu->evtq.q.llq.max_n_shift = min_t(u32, EVTQ_MAX_SZ_SHIFT,
+					     FIELD_GET(IDR1_EVTQS, reg));
+	smmu->priq.q.llq.max_n_shift = min_t(u32, PRIQ_MAX_SZ_SHIFT,
+					     FIELD_GET(IDR1_PRIQS, reg));
+
+	/* SID/SSID sizes */
+	smmu->ssid_bits = FIELD_GET(IDR1_SSIDSIZE, reg);
+	smmu->sid_bits = FIELD_GET(IDR1_SIDSIZE, reg);
+	smmu->iommu.max_pasids = 1UL << smmu->ssid_bits;
+
+	/*
+	 * If the SMMU supports fewer bits than would fill a single L2 stream
+	 * table, use a linear table instead.
+	 */
+	if (smmu->sid_bits <= STRTAB_SPLIT)
+		smmu->features &= ~ARM_SMMU_FEAT_2_LVL_STRTAB;
+
+	/* IDR3 */
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
+	if (FIELD_GET(IDR3_RIL, reg))
+		smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
+
+	/* IDR5 */
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR5);
+
+	/* Maximum number of outstanding stalls */
+	smmu->evtq.max_stalls = FIELD_GET(IDR5_STALL_MAX, reg);
+
+	/* Page sizes */
+	if (reg & IDR5_GRAN64K)
+		smmu->pgsize_bitmap |= SZ_64K | SZ_512M;
+	if (reg & IDR5_GRAN16K)
+		smmu->pgsize_bitmap |= SZ_16K | SZ_32M;
+	if (reg & IDR5_GRAN4K)
+		smmu->pgsize_bitmap |= SZ_4K | SZ_2M | SZ_1G;
+
+	/* Input address size */
+	if (FIELD_GET(IDR5_VAX, reg) == IDR5_VAX_52_BIT)
+		smmu->features |= ARM_SMMU_FEAT_VAX;
+
+	/* Output address size */
+	switch (FIELD_GET(IDR5_OAS, reg)) {
+	case IDR5_OAS_32_BIT:
+		smmu->oas = 32;
+		break;
+	case IDR5_OAS_36_BIT:
+		smmu->oas = 36;
+		break;
+	case IDR5_OAS_40_BIT:
+		smmu->oas = 40;
+		break;
+	case IDR5_OAS_42_BIT:
+		smmu->oas = 42;
+		break;
+	case IDR5_OAS_44_BIT:
+		smmu->oas = 44;
+		break;
+	case IDR5_OAS_52_BIT:
+		smmu->oas = 52;
+		smmu->pgsize_bitmap |= 1ULL << 42; /* 4TB */
+		break;
+	default:
+		dev_info(smmu->dev,
+			"unknown output address size. Truncating to 48-bit\n");
+		fallthrough;
+	case IDR5_OAS_48_BIT:
+		smmu->oas = 48;
+	}
+
+	/* Set the DMA mask for our table walker */
+	if (dma_set_mask_and_coherent(smmu->dev, DMA_BIT_MASK(smmu->oas)))
+		dev_warn(smmu->dev,
+			 "failed to set DMA mask for table walker\n");
+
+	smmu->ias = max(smmu->ias, smmu->oas);
+
+	if (arm_smmu_sva_supported(smmu))
+		smmu->features |= ARM_SMMU_FEAT_SVA;
+
+	dev_info(smmu->dev, "ias %lu-bit, oas %lu-bit (features 0x%08x)\n",
+		 smmu->ias, smmu->oas, smmu->features);
+	return 0;
+}
+
+int arm_smmu_write_reg_sync(struct arm_smmu_device *smmu, u32 val,
+			    unsigned int reg_off, unsigned int ack_off)
+{
+	u32 reg;
+
+	writel_relaxed(val, smmu->base + reg_off);
+	return readl_relaxed_poll_timeout(smmu->base + ack_off, reg, reg == val,
+					  1, ARM_SMMU_POLL_TIMEOUT_US);
+}
+
+/* GBPA is "special" */
+int arm_smmu_update_gbpa(struct arm_smmu_device *smmu, u32 set, u32 clr)
+{
+	int ret;
+	u32 reg, __iomem *gbpa = smmu->base + ARM_SMMU_GBPA;
+
+	ret = readl_relaxed_poll_timeout(gbpa, reg, !(reg & GBPA_UPDATE),
+					 1, ARM_SMMU_POLL_TIMEOUT_US);
+	if (ret)
+		return ret;
+
+	reg &= ~clr;
+	reg |= set;
+	writel_relaxed(reg | GBPA_UPDATE, gbpa);
+	ret = readl_relaxed_poll_timeout(gbpa, reg, !(reg & GBPA_UPDATE),
+					 1, ARM_SMMU_POLL_TIMEOUT_US);
+
+	if (ret)
+		dev_err(smmu->dev, "GBPA not responding to update\n");
+	return ret;
+}
+
+int arm_smmu_device_disable(struct arm_smmu_device *smmu)
+{
+	int ret;
+
+	ret = arm_smmu_write_reg_sync(smmu, 0, ARM_SMMU_CR0, ARM_SMMU_CR0ACK);
+	if (ret)
+		dev_err(smmu->dev, "failed to clear cr0\n");
+
+	return ret;
+}
+
+bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
+{
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+
+	switch (cap) {
+	case IOMMU_CAP_CACHE_COHERENCY:
+		/* Assume that a coherent TCU implies coherent TBUs */
+		return master->smmu->features & ARM_SMMU_FEAT_COHERENCY;
+	case IOMMU_CAP_NOEXEC:
+		return true;
+	default:
+		return false;
+	}
+}
+
+
+struct iommu_group *arm_smmu_device_group(struct device *dev)
+{
+	struct iommu_group *group;
+
+	/*
+	 * We don't support devices sharing stream IDs other than PCI RID
+	 * aliases, since the necessary ID-to-device lookup becomes rather
+	 * impractical given a potential sparse 32-bit stream ID space.
+	 */
+	if (dev_is_pci(dev))
+		group = pci_device_group(dev);
+	else
+		group = generic_device_group(dev);
+
+	return group;
+}
+
+int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args *args)
+{
+	return iommu_fwspec_add_ids(dev, args->args, 1);
+}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index bcbd691ca96a..08fd79f66d29 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -17,13 +17,11 @@
 #include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/io-pgtable.h>
-#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/msi.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
-#include <linux/pci.h>
 #include <linux/pci-ats.h>
 #include <linux/platform_device.h>
 
@@ -1642,8 +1640,6 @@ static irqreturn_t arm_smmu_priq_thread(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-static int arm_smmu_device_disable(struct arm_smmu_device *smmu);
-
 static irqreturn_t arm_smmu_gerror_handler(int irq, void *dev)
 {
 	u32 gerror, gerrorn, active;
@@ -1990,21 +1986,6 @@ static const struct iommu_flush_ops arm_smmu_flush_ops = {
 };
 
 /* IOMMU API */
-static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
-{
-	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-
-	switch (cap) {
-	case IOMMU_CAP_CACHE_COHERENCY:
-		/* Assume that a coherent TCU implies coherent TBUs */
-		return master->smmu->features & ARM_SMMU_FEAT_COHERENCY;
-	case IOMMU_CAP_NOEXEC:
-		return true;
-	default:
-		return false;
-	}
-}
-
 static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 {
 	struct arm_smmu_domain *smmu_domain;
@@ -2698,23 +2679,6 @@ static void arm_smmu_release_device(struct device *dev)
 	kfree(master);
 }
 
-static struct iommu_group *arm_smmu_device_group(struct device *dev)
-{
-	struct iommu_group *group;
-
-	/*
-	 * We don't support devices sharing stream IDs other than PCI RID
-	 * aliases, since the necessary ID-to-device lookup becomes rather
-	 * impractical given a potential sparse 32-bit stream ID space.
-	 */
-	if (dev_is_pci(dev))
-		group = pci_device_group(dev);
-	else
-		group = generic_device_group(dev);
-
-	return group;
-}
-
 static int arm_smmu_enable_nesting(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
@@ -2730,11 +2694,6 @@ static int arm_smmu_enable_nesting(struct iommu_domain *domain)
 	return ret;
 }
 
-static int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args *args)
-{
-	return iommu_fwspec_add_ids(dev, args->args, 1);
-}
-
 static void arm_smmu_get_resv_regions(struct device *dev,
 				      struct list_head *head)
 {
@@ -3081,38 +3040,6 @@ static int arm_smmu_init_structures(struct arm_smmu_device *smmu)
 	return arm_smmu_init_strtab(smmu);
 }
 
-static int arm_smmu_write_reg_sync(struct arm_smmu_device *smmu, u32 val,
-				   unsigned int reg_off, unsigned int ack_off)
-{
-	u32 reg;
-
-	writel_relaxed(val, smmu->base + reg_off);
-	return readl_relaxed_poll_timeout(smmu->base + ack_off, reg, reg == val,
-					  1, ARM_SMMU_POLL_TIMEOUT_US);
-}
-
-/* GBPA is "special" */
-static int arm_smmu_update_gbpa(struct arm_smmu_device *smmu, u32 set, u32 clr)
-{
-	int ret;
-	u32 reg, __iomem *gbpa = smmu->base + ARM_SMMU_GBPA;
-
-	ret = readl_relaxed_poll_timeout(gbpa, reg, !(reg & GBPA_UPDATE),
-					 1, ARM_SMMU_POLL_TIMEOUT_US);
-	if (ret)
-		return ret;
-
-	reg &= ~clr;
-	reg |= set;
-	writel_relaxed(reg | GBPA_UPDATE, gbpa);
-	ret = readl_relaxed_poll_timeout(gbpa, reg, !(reg & GBPA_UPDATE),
-					 1, ARM_SMMU_POLL_TIMEOUT_US);
-
-	if (ret)
-		dev_err(smmu->dev, "GBPA not responding to update\n");
-	return ret;
-}
-
 static void arm_smmu_free_msis(void *data)
 {
 	struct device *dev = data;
@@ -3258,17 +3185,6 @@ static int arm_smmu_setup_irqs(struct arm_smmu_device *smmu)
 	return 0;
 }
 
-static int arm_smmu_device_disable(struct arm_smmu_device *smmu)
-{
-	int ret;
-
-	ret = arm_smmu_write_reg_sync(smmu, 0, ARM_SMMU_CR0, ARM_SMMU_CR0ACK);
-	if (ret)
-		dev_err(smmu->dev, "failed to clear cr0\n");
-
-	return ret;
-}
-
 static int arm_smmu_device_reset(struct arm_smmu_device *smmu, bool bypass)
 {
 	int ret;
@@ -3404,215 +3320,6 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu, bool bypass)
 	return 0;
 }
 
-static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
-{
-	u32 reg;
-	bool coherent = smmu->features & ARM_SMMU_FEAT_COHERENCY;
-
-	/* IDR0 */
-	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR0);
-
-	/* 2-level structures */
-	if (FIELD_GET(IDR0_ST_LVL, reg) == IDR0_ST_LVL_2LVL)
-		smmu->features |= ARM_SMMU_FEAT_2_LVL_STRTAB;
-
-	if (reg & IDR0_CD2L)
-		smmu->features |= ARM_SMMU_FEAT_2_LVL_CDTAB;
-
-	/*
-	 * Translation table endianness.
-	 * We currently require the same endianness as the CPU, but this
-	 * could be changed later by adding a new IO_PGTABLE_QUIRK.
-	 */
-	switch (FIELD_GET(IDR0_TTENDIAN, reg)) {
-	case IDR0_TTENDIAN_MIXED:
-		smmu->features |= ARM_SMMU_FEAT_TT_LE | ARM_SMMU_FEAT_TT_BE;
-		break;
-#ifdef __BIG_ENDIAN
-	case IDR0_TTENDIAN_BE:
-		smmu->features |= ARM_SMMU_FEAT_TT_BE;
-		break;
-#else
-	case IDR0_TTENDIAN_LE:
-		smmu->features |= ARM_SMMU_FEAT_TT_LE;
-		break;
-#endif
-	default:
-		dev_err(smmu->dev, "unknown/unsupported TT endianness!\n");
-		return -ENXIO;
-	}
-
-	/* Boolean feature flags */
-	if (IS_ENABLED(CONFIG_PCI_PRI) && reg & IDR0_PRI)
-		smmu->features |= ARM_SMMU_FEAT_PRI;
-
-	if (IS_ENABLED(CONFIG_PCI_ATS) && reg & IDR0_ATS)
-		smmu->features |= ARM_SMMU_FEAT_ATS;
-
-	if (reg & IDR0_SEV)
-		smmu->features |= ARM_SMMU_FEAT_SEV;
-
-	if (reg & IDR0_MSI) {
-		smmu->features |= ARM_SMMU_FEAT_MSI;
-		if (coherent)
-			smmu->options |= ARM_SMMU_OPT_MSIPOLL;
-	}
-
-	if (reg & IDR0_HYP) {
-		smmu->features |= ARM_SMMU_FEAT_HYP;
-		if (cpus_have_cap(ARM64_HAS_VIRT_HOST_EXTN))
-			smmu->features |= ARM_SMMU_FEAT_E2H;
-	}
-
-	/*
-	 * The coherency feature as set by FW is used in preference to the ID
-	 * register, but warn on mismatch.
-	 */
-	if (!!(reg & IDR0_COHACC) != coherent)
-		dev_warn(smmu->dev, "IDR0.COHACC overridden by FW configuration (%s)\n",
-			 coherent ? "true" : "false");
-
-	switch (FIELD_GET(IDR0_STALL_MODEL, reg)) {
-	case IDR0_STALL_MODEL_FORCE:
-		smmu->features |= ARM_SMMU_FEAT_STALL_FORCE;
-		fallthrough;
-	case IDR0_STALL_MODEL_STALL:
-		smmu->features |= ARM_SMMU_FEAT_STALLS;
-	}
-
-	if (reg & IDR0_S1P)
-		smmu->features |= ARM_SMMU_FEAT_TRANS_S1;
-
-	if (reg & IDR0_S2P)
-		smmu->features |= ARM_SMMU_FEAT_TRANS_S2;
-
-	if (!(reg & (IDR0_S1P | IDR0_S2P))) {
-		dev_err(smmu->dev, "no translation support!\n");
-		return -ENXIO;
-	}
-
-	/* We only support the AArch64 table format at present */
-	switch (FIELD_GET(IDR0_TTF, reg)) {
-	case IDR0_TTF_AARCH32_64:
-		smmu->ias = 40;
-		fallthrough;
-	case IDR0_TTF_AARCH64:
-		break;
-	default:
-		dev_err(smmu->dev, "AArch64 table format not supported!\n");
-		return -ENXIO;
-	}
-
-	/* ASID/VMID sizes */
-	smmu->asid_bits = reg & IDR0_ASID16 ? 16 : 8;
-	smmu->vmid_bits = reg & IDR0_VMID16 ? 16 : 8;
-
-	/* IDR1 */
-	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR1);
-	if (reg & (IDR1_TABLES_PRESET | IDR1_QUEUES_PRESET | IDR1_REL)) {
-		dev_err(smmu->dev, "embedded implementation not supported\n");
-		return -ENXIO;
-	}
-
-	/* Queue sizes, capped to ensure natural alignment */
-	smmu->cmdq.q.llq.max_n_shift = min_t(u32, CMDQ_MAX_SZ_SHIFT,
-					     FIELD_GET(IDR1_CMDQS, reg));
-	if (smmu->cmdq.q.llq.max_n_shift <= ilog2(CMDQ_BATCH_ENTRIES)) {
-		/*
-		 * We don't support splitting up batches, so one batch of
-		 * commands plus an extra sync needs to fit inside the command
-		 * queue. There's also no way we can handle the weird alignment
-		 * restrictions on the base pointer for a unit-length queue.
-		 */
-		dev_err(smmu->dev, "command queue size <= %d entries not supported\n",
-			CMDQ_BATCH_ENTRIES);
-		return -ENXIO;
-	}
-
-	smmu->evtq.q.llq.max_n_shift = min_t(u32, EVTQ_MAX_SZ_SHIFT,
-					     FIELD_GET(IDR1_EVTQS, reg));
-	smmu->priq.q.llq.max_n_shift = min_t(u32, PRIQ_MAX_SZ_SHIFT,
-					     FIELD_GET(IDR1_PRIQS, reg));
-
-	/* SID/SSID sizes */
-	smmu->ssid_bits = FIELD_GET(IDR1_SSIDSIZE, reg);
-	smmu->sid_bits = FIELD_GET(IDR1_SIDSIZE, reg);
-	smmu->iommu.max_pasids = 1UL << smmu->ssid_bits;
-
-	/*
-	 * If the SMMU supports fewer bits than would fill a single L2 stream
-	 * table, use a linear table instead.
-	 */
-	if (smmu->sid_bits <= STRTAB_SPLIT)
-		smmu->features &= ~ARM_SMMU_FEAT_2_LVL_STRTAB;
-
-	/* IDR3 */
-	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
-	if (FIELD_GET(IDR3_RIL, reg))
-		smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
-
-	/* IDR5 */
-	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR5);
-
-	/* Maximum number of outstanding stalls */
-	smmu->evtq.max_stalls = FIELD_GET(IDR5_STALL_MAX, reg);
-
-	/* Page sizes */
-	if (reg & IDR5_GRAN64K)
-		smmu->pgsize_bitmap |= SZ_64K | SZ_512M;
-	if (reg & IDR5_GRAN16K)
-		smmu->pgsize_bitmap |= SZ_16K | SZ_32M;
-	if (reg & IDR5_GRAN4K)
-		smmu->pgsize_bitmap |= SZ_4K | SZ_2M | SZ_1G;
-
-	/* Input address size */
-	if (FIELD_GET(IDR5_VAX, reg) == IDR5_VAX_52_BIT)
-		smmu->features |= ARM_SMMU_FEAT_VAX;
-
-	/* Output address size */
-	switch (FIELD_GET(IDR5_OAS, reg)) {
-	case IDR5_OAS_32_BIT:
-		smmu->oas = 32;
-		break;
-	case IDR5_OAS_36_BIT:
-		smmu->oas = 36;
-		break;
-	case IDR5_OAS_40_BIT:
-		smmu->oas = 40;
-		break;
-	case IDR5_OAS_42_BIT:
-		smmu->oas = 42;
-		break;
-	case IDR5_OAS_44_BIT:
-		smmu->oas = 44;
-		break;
-	case IDR5_OAS_52_BIT:
-		smmu->oas = 52;
-		smmu->pgsize_bitmap |= 1ULL << 42; /* 4TB */
-		break;
-	default:
-		dev_info(smmu->dev,
-			"unknown output address size. Truncating to 48-bit\n");
-		fallthrough;
-	case IDR5_OAS_48_BIT:
-		smmu->oas = 48;
-	}
-
-	/* Set the DMA mask for our table walker */
-	if (dma_set_mask_and_coherent(smmu->dev, DMA_BIT_MASK(smmu->oas)))
-		dev_warn(smmu->dev,
-			 "failed to set DMA mask for table walker\n");
-
-	smmu->ias = max(smmu->ias, smmu->oas);
-
-	if (arm_smmu_sva_supported(smmu))
-		smmu->features |= ARM_SMMU_FEAT_SVA;
-
-	dev_info(smmu->dev, "ias %lu-bit, oas %lu-bit (features 0x%08x)\n",
-		 smmu->ias, smmu->oas, smmu->features);
-	return 0;
-}
-
 #ifdef CONFIG_ACPI
 static void acpi_smmu_get_options(u32 model, struct arm_smmu_device *smmu)
 {
-- 
2.39.0

