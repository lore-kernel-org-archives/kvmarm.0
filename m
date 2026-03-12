Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2533D27470;
	Thu, 12 Mar 2026 08:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302700; cv=none; b=RSFezxUf+eFpCXflU8tQihuFsTH9/UEigQ7FbhHxRIUen1cGnsr5v5qGLZvj08fjzPCLt3f7z9OFtclOUak45OsGx7/kvuURn7tlnhd05PmZ9f48Ct6VDTrtJuQT2Wbj24Ha6iQMXnwHR+/HZCGgVoFnjMBIduAffiHB1KIHMZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302700; c=relaxed/simple;
	bh=4+Yt465AqY2sihQ6fJfZxhUEPLtuJ1924Wwm1dlVPZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0Z5O/3fqM9ri+A7B8B0NlP4ztc3SVQktVgQmf+fmHmAqEzdh+kezCTqEIOvv1zl6sOboeCJYrrYUpsa6ixpnNgZnD7PUF3BXIJd8ngLh9HTot/HYjYcD0/e5ErAUOn7WldjXEpcrgju54Nw7cSSm7tIQTN9k8Cprfo5+OaCVbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZluGMJ/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZluGMJ/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D0EC116C6;
	Thu, 12 Mar 2026 08:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302700;
	bh=4+Yt465AqY2sihQ6fJfZxhUEPLtuJ1924Wwm1dlVPZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZluGMJ/eB0Wc6xy0Q4YVyYkMfV0SRh+vNAbCrZbSFLsmwgfb6+wC78RJfzt/NAktY
	 WI3nbcBcwdGPPzVoPqSp/f6KYOqzCoYt8e9GfflF0izfGBujwaedt/ejKFZyq+Wwbu
	 ac98bip93+AaQNdS4YsL99C6y0Y1gwIZnNCSOksDkLe3Ppj8lTkpSnp058PhRWUKGl
	 fhutU7T8PCrgQg/PE0PY3yeKNmicZGZrwO/z3SCryygzbsXjMp7pN7VgYq26KpvHS8
	 tijnJd5Qp/WnuezlOmpzmLDjPws/tW1igJAsb1O7NRXvlStSKmYux56toP0Z1tuZ40
	 pG1K1AMVMpVXw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Dan Williams <dan.j.williams@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: [RFC PATCH v3 01/11] coco: guest: arm64: Guest TSM callback and realm device lock support
Date: Thu, 12 Mar 2026 13:34:32 +0530
Message-ID: <20260312080442.3485633-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260312080442.3485633-1-aneesh.kumar@kernel.org>
References: <20260312080442.3485633-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Register the TSM callback when the DA feature is supported by RSI. The
build order is also adjusted so that the TSM class is created before the
arm-cca-guest driver is initialized.

In addition, add support for the TDISP lock sequence. Writing a TSM
(TEE Security Manager) device name from `/sys/class/tsm` into `tsm/lock`
triggers the realm device lock operation.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Samuel Ortiz <sameo@rivosinc.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rsi.h              |  1 +
 arch/arm64/include/asm/rsi_cmds.h         | 17 +++++++
 arch/arm64/include/asm/rsi_smc.h          |  1 +
 arch/arm64/kernel/rsi.c                   | 10 ++++
 drivers/virt/coco/Makefile                |  2 +-
 drivers/virt/coco/arm-cca-guest/Kconfig   |  5 ++
 drivers/virt/coco/arm-cca-guest/arm-cca.c | 60 ++++++++++++++++++++++-
 drivers/virt/coco/arm-cca-guest/rsi-da.h  | 35 +++++++++++++
 8 files changed, 129 insertions(+), 2 deletions(-)
 create mode 100644 drivers/virt/coco/arm-cca-guest/rsi-da.h

diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
index 34c8f649fe48..f5288551ae77 100644
--- a/arch/arm64/include/asm/rsi.h
+++ b/arch/arm64/include/asm/rsi.h
@@ -68,5 +68,6 @@ static inline int rsi_set_memory_range_shared(phys_addr_t start,
 				    RSI_CHANGE_DESTROYED);
 }
 
+bool rsi_has_da_feature(void);
 unsigned long realm_get_hyp_pagesize(void);
 #endif /* __ASM_RSI_H_ */
diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
index a341ce0eeda1..596bdc356f1a 100644
--- a/arch/arm64/include/asm/rsi_cmds.h
+++ b/arch/arm64/include/asm/rsi_cmds.h
@@ -169,4 +169,21 @@ static inline unsigned long rsi_host_call(struct rsi_host_call *rhi_call)
 	return res.a0;
 }
 
+/**
+ * rsi_features() - Read feature register
+ * @index: Feature register index
+ * @out: Feature register value is written to this pointer
+ *
+ * Return: RSI return code
+ */
+static inline unsigned long rsi_features(unsigned long index, u64 *out)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RSI_FEATURES, index, &res);
+
+	*out = res.a1;
+	return res.a0;
+}
+
 #endif /* __ASM_RSI_CMDS_H */
diff --git a/arch/arm64/include/asm/rsi_smc.h b/arch/arm64/include/asm/rsi_smc.h
index 9ee8b5c7612e..4af4638fdd49 100644
--- a/arch/arm64/include/asm/rsi_smc.h
+++ b/arch/arm64/include/asm/rsi_smc.h
@@ -53,6 +53,7 @@
  */
 #define SMC_RSI_ABI_VERSION	SMC_RSI_FID(0x190)
 
+#define RSI_FEATURE_REGISTER_0_DA		BIT(0)
 /*
  * Read feature register.
  *
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index 29d3c20ce011..2816f31d0dc6 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -16,6 +16,7 @@
 #include <asm/rhi.h>
 
 static struct realm_config config;
+static u64 rsi_feat_reg0;
 static unsigned long ipa_change_alignment = PAGE_SIZE;
 
 unsigned long prot_ns_shared;
@@ -24,6 +25,12 @@ EXPORT_SYMBOL(prot_ns_shared);
 DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
 EXPORT_SYMBOL(rsi_present);
 
+bool rsi_has_da_feature(void)
+{
+	return u64_get_bits(rsi_feat_reg0, RSI_FEATURE_REGISTER_0_DA);
+}
+EXPORT_SYMBOL_GPL(rsi_has_da_feature);
+
 bool cc_platform_has(enum cc_attr attr)
 {
 	switch (attr) {
@@ -159,6 +166,9 @@ void __init arm64_rsi_init(void)
 	if (!ipa_change_alignment)
 		return;
 
+	if (WARN_ON(rsi_features(0, &rsi_feat_reg0)))
+		return;
+
 	prot_ns_shared = BIT(config.ipa_bits - 1);
 
 	if (arm64_ioremap_prot_hook_register(realm_ioremap_hook))
diff --git a/drivers/virt/coco/Makefile b/drivers/virt/coco/Makefile
index b323b0ae4f82..4f7e30f5aeb8 100644
--- a/drivers/virt/coco/Makefile
+++ b/drivers/virt/coco/Makefile
@@ -7,6 +7,6 @@ obj-$(CONFIG_ARM_PKVM_GUEST)	+= pkvm-guest/
 obj-$(CONFIG_SEV_GUEST)		+= sev-guest/
 obj-$(CONFIG_INTEL_TDX_GUEST)	+= tdx-guest/
 obj-$(CONFIG_INTEL_TDX_HOST)	+= tdx-host/
-obj-$(CONFIG_ARM_CCA_GUEST)	+= arm-cca-guest/
 obj-$(CONFIG_TSM) 		+= tsm-core.o
 obj-$(CONFIG_TSM_GUEST)		+= guest/
+obj-$(CONFIG_ARM_CCA_GUEST)	+= arm-cca-guest/
diff --git a/drivers/virt/coco/arm-cca-guest/Kconfig b/drivers/virt/coco/arm-cca-guest/Kconfig
index a42359a90558..5f7f284dae1a 100644
--- a/drivers/virt/coco/arm-cca-guest/Kconfig
+++ b/drivers/virt/coco/arm-cca-guest/Kconfig
@@ -1,11 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+
 config ARM_CCA_GUEST
 	tristate "Arm CCA Guest driver"
 	depends on ARM64
+	select PCI_TSM if PCI
 	select TSM_REPORTS
 	select AUXILIARY_BUS
 	help
 	  The driver provides userspace interface to request and
 	  attestation report from the Realm Management Monitor(RMM).
+	  If the DA feature is supported, it also register with TSM framework.
 
 	  If you choose 'M' here, this module will be called
 	  arm-cca-guest.
diff --git a/drivers/virt/coco/arm-cca-guest/arm-cca.c b/drivers/virt/coco/arm-cca-guest/arm-cca.c
index 3d5c0fe75500..1d78727702be 100644
--- a/drivers/virt/coco/arm-cca-guest/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-guest/arm-cca.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (C) 2023 ARM Ltd.
+ * Copyright (C) 2023-2025 ARM Ltd.
  */
 
 #include <linux/auxiliary_bus.h>
@@ -15,6 +15,10 @@
 
 #include <asm/rsi.h>
 
+#ifdef CONFIG_PCI_TSM
+#include "rsi-da.h"
+#endif
+
 /**
  * struct arm_cca_token_info - a descriptor for the token buffer.
  * @challenge:		Pointer to the challenge data
@@ -192,6 +196,53 @@ static void unregister_cca_tsm_report(void *data)
 	tsm_report_unregister(&arm_cca_tsm_report_ops);
 }
 
+#ifdef CONFIG_PCI_TSM
+static struct pci_tsm *cca_tsm_lock(struct tsm_dev *tsm_dev, struct pci_dev *pdev)
+{
+	int ret;
+
+	struct cca_guest_dsc *cca_dsc __free(kfree) =
+		kzalloc_obj(struct cca_guest_dsc);
+	if (!cca_dsc)
+		return ERR_PTR(-ENOMEM);
+
+	ret = pci_tsm_devsec_constructor(pdev, &cca_dsc->pci, tsm_dev);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* For now always return an error */
+	return ERR_PTR(-EIO);
+}
+
+static void cca_tsm_unlock(struct pci_tsm *tsm)
+{
+	struct cca_guest_dsc *cca_dsc = to_cca_guest_dsc(tsm->pdev);
+
+	kfree(cca_dsc);
+}
+
+static struct pci_tsm_ops cca_devsec_pci_ops = {
+	.lock = cca_tsm_lock,
+	.unlock = cca_tsm_unlock,
+};
+
+static void cca_devsec_tsm_remove(void *tsm_dev)
+{
+	tsm_unregister(tsm_dev);
+}
+
+static int cca_devsec_tsm_register(struct auxiliary_device *adev)
+{
+	struct tsm_dev *tsm_dev;
+
+	tsm_dev = tsm_register(&adev->dev, &cca_devsec_pci_ops);
+	if (IS_ERR(tsm_dev))
+		return PTR_ERR(tsm_dev);
+
+	return devm_add_action_or_reset(&adev->dev, cca_devsec_tsm_remove, tsm_dev);
+}
+#endif /* CONFIG_PCI_TSM */
+
 static int cca_devsec_tsm_probe(struct auxiliary_device *adev,
 				const struct auxiliary_device_id *id)
 {
@@ -212,6 +263,12 @@ static int cca_devsec_tsm_probe(struct auxiliary_device *adev,
 		return ret;
 	}
 
+#ifdef CONFIG_PCI_TSM
+	/* Allow tsm report even if tsm_register fails */
+	if (rsi_has_da_feature())
+		cca_devsec_tsm_register(adev);
+#endif
+
 	return 0;
 }
 
@@ -227,5 +284,6 @@ static struct auxiliary_driver cca_devsec_tsm_driver = {
 };
 module_auxiliary_driver(cca_devsec_tsm_driver);
 MODULE_AUTHOR("Sami Mujawar <sami.mujawar@arm.com>");
+MODULE_AUTHOR("Aneesh Kumar <aneesh.kumar@kernel.org>");
 MODULE_DESCRIPTION("Arm CCA Guest TSM Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.h b/drivers/virt/coco/arm-cca-guest/rsi-da.h
new file mode 100644
index 000000000000..858bfdaf59c9
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-guest/rsi-da.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+
+#ifndef _VIRT_COCO_RSI_DA_H_
+#define _VIRT_COCO_RSI_DA_H_
+
+#include <linux/pci.h>
+#include <linux/pci-tsm.h>
+#include <asm/rsi_smc.h>
+
+struct cca_guest_dsc {
+	struct pci_tsm_devsec pci;
+};
+
+static inline struct cca_guest_dsc *to_cca_guest_dsc(struct pci_dev *pdev)
+{
+	struct pci_tsm *tsm = pdev->tsm;
+
+	if (!tsm)
+		return NULL;
+	return container_of(tsm, struct cca_guest_dsc, pci.base_tsm);
+}
+
+/*
+ * Linux use device requester id as the vdev id.
+ */
+static inline int rsi_vdev_id(struct pci_dev *pdev)
+{
+	return (pci_domain_nr(pdev->bus) << 16) |
+	       PCI_DEVID(pdev->bus->number, pdev->devfn);
+}
+
+#endif
-- 
2.43.0

