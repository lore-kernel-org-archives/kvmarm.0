Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6198949891A;
	Thu, 10 Sep 2026 14:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049128; cv=none; b=rxhR3ia8hWyCpCRv0AaIfzWLO+4hbRDWxCddlFJnqneMRDtmvi0xvXzPHZVw+eTjJfr2+hE4RmyHmIDL6yC+s8/w0/C63qytIc6yJlJxJkrohA6usrp7OTZ2n/5/suV6/bqDUHWBOdSxDgebMnStjf3jM0QaesArHsH17jY0bmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049128; c=relaxed/simple;
	bh=s23VfKMMmRNZNIU0pGAjcGNAwSkq9eHIXgc68aPcObw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKl5rE0pzQtwavESVC6L6eCsX+2UeAdEk419k3rfA84f/bY89z0BKS9os0+cpJvj16gVmr2vIMfE78muBnytAqCMGfpo2qvgIOI+VXS2qSGTUEKGlDmK60eUz9GhShVDF8J8x16wuKABxJqstMbQn+YI6m/nI11REAGI/OPJfhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DJ7iqDZc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJ7iqDZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB2C1F00893;
	Thu, 10 Sep 2026 14:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049126;
	bh=NDk08jf8/gCHIxn5wFUM9weoXOz0O1oU/9eJvj/KxnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJ7iqDZc5FDTJsXTAmrZcFigCdnq9KpTS+iZyvI0kdfK3OTHME+NTn6Ljkl1fFkrL
	 lr9VY5qMOx/xlAk3xJJYPnsCh0vRssbu0FDBdhppLVbM7Iio5XlH+WjO+bdSA5wvSH
	 qDAGeYWrr0MJClNV6jRzhgtbq01r1o+Ll3XC9fyTsTsSDqu5bwKiD//NnQnWpEm1lA
	 4QDDycN7unF8iu18G6koGT3AgOAh87mZdPxTHDdQYxPG+K1zofbkyrUDIA7SbayCOY
	 pWrPJHncPbdV1CK/+OKf2dgmHLI7XThE224VMEGPXRfuJgohGmHw0MXjHm56BII6kL
	 PL0WNbcI2QMwQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH v5 01/15] coco: host: arm64: Prepare host TSM plumbing for IDE streams
Date: Thu, 10 Sep 2026 19:34:54 +0530
Message-ID: <20260910140509.868402-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910140509.868402-1-aneesh.kumar@kernel.org>
References: <20260910140509.868402-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the initial Arm CCA host driver plumbing needed for device assignment
support. Register the RMI SMCCC device, add the host TSM driver, and hook
up the PCI TSM probe/remove callbacks when RMM reports Device Assignment
support.

This patch only establishes the driver and per-device PCI TSM state needed
by later patches. The RMM-facing pdev lifecycle, device communication, key
setup, peer stream coordination, IDE stream setup, and connect/disconnect
callbacks are added later in the series.

This keeps the patch as preparatory groundwork; complete enablement happens
once the follow-up patches wire these pieces into the RMM stream lifecycle.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/firmware/arm_rmm/rmi.c          |   4 +-
 drivers/firmware/smccc/smccc.c          |   6 +
 drivers/virt/coco/Kconfig               |   2 +
 drivers/virt/coco/Makefile              |   1 +
 drivers/virt/coco/arm-cca-host/Kconfig  |  19 +++
 drivers/virt/coco/arm-cca-host/Makefile |   5 +
 drivers/virt/coco/arm-cca-host/main.c   | 192 ++++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h |  46 ++++++
 8 files changed, 273 insertions(+), 2 deletions(-)
 create mode 100644 drivers/virt/coco/arm-cca-host/Kconfig
 create mode 100644 drivers/virt/coco/arm-cca-host/Makefile
 create mode 100644 drivers/virt/coco/arm-cca-host/main.c
 create mode 100644 drivers/virt/coco/arm-cca-host/rmi-da.h

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 34058e34188d..ba415b66991b 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -15,8 +15,8 @@
 
 static bool arm64_rmi_is_available;
 
-/* Currently only the first 2 registers are used by Linux */
-#define RMI_FEAT_REG_COUNT	2
+/* Currently only the first 3 registers are used by Linux */
+#define RMI_FEAT_REG_COUNT	3
 static __ro_after_init unsigned long rmi_feat_reg_cache[RMI_FEAT_REG_COUNT];
 
 unsigned long rmi_feat_reg(unsigned long id)
diff --git a/drivers/firmware/smccc/smccc.c b/drivers/firmware/smccc/smccc.c
index 854276a3cd57..90b87a622a6b 100644
--- a/drivers/firmware/smccc/smccc.c
+++ b/drivers/firmware/smccc/smccc.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/arm-smccc-bus.h>
 #include <linux/arm-smccc-rsi.h>
+#include <linux/arm-smccc-rmi.h>
 
 #include <asm/archrandom.h>
 
@@ -100,6 +101,11 @@ static const struct smccc_device_info smccc_devices[] __initconst = {
 		.requires_smc   = true,
 		.device_name    = "arm-rsi",
 	},
+	{
+		.func_id        = SMC_RMI_VERSION,
+		.requires_smc   = true,
+		.device_name    = "arm-rmi",
+	},
 };
 
 static bool __init smccc_probe_smccc_device(const struct smccc_device_info *smccc_dev)
diff --git a/drivers/virt/coco/Kconfig b/drivers/virt/coco/Kconfig
index f7691f64fbe3..1cbc2134f9ea 100644
--- a/drivers/virt/coco/Kconfig
+++ b/drivers/virt/coco/Kconfig
@@ -19,5 +19,7 @@ endif
 
 source "drivers/virt/coco/tdx-host/Kconfig"
 
+source "drivers/virt/coco/arm-cca-host/Kconfig"
+
 config TSM
 	bool
diff --git a/drivers/virt/coco/Makefile b/drivers/virt/coco/Makefile
index b323b0ae4f82..f2310c34daf9 100644
--- a/drivers/virt/coco/Makefile
+++ b/drivers/virt/coco/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_INTEL_TDX_HOST)	+= tdx-host/
 obj-$(CONFIG_ARM_CCA_GUEST)	+= arm-cca-guest/
 obj-$(CONFIG_TSM) 		+= tsm-core.o
 obj-$(CONFIG_TSM_GUEST)		+= guest/
+obj-$(CONFIG_ARM_CCA_HOST)	+= arm-cca-host/
diff --git a/drivers/virt/coco/arm-cca-host/Kconfig b/drivers/virt/coco/arm-cca-host/Kconfig
new file mode 100644
index 000000000000..d2bf44f9776a
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-host/Kconfig
@@ -0,0 +1,19 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# TSM (TEE Security Manager) host drivers
+#
+config ARM_CCA_HOST
+	tristate "Arm CCA Host driver"
+	depends on ARM64
+	depends on PCI
+	depends on ARM_RMM_RMI
+	depends on HAVE_ARM_SMCCC_DISCOVERY
+	select PCI_TSM
+
+	help
+	  ARM CCA RMM firmware is the trusted runtime that enforces memory
+	  isolation and security for confidential computing on ARM. This driver
+	  provides the interface for communicating with RMM to support secure
+	  device assignment.
+
+	  If you choose 'M' here, this module will be called arm-cca-host.
diff --git a/drivers/virt/coco/arm-cca-host/Makefile b/drivers/virt/coco/arm-cca-host/Makefile
new file mode 100644
index 000000000000..7a4c2e0e5d26
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-host/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+obj-$(CONFIG_ARM_CCA_HOST) += arm-cca-host.o
+
+arm-cca-host-y	+=  main.o
diff --git a/drivers/virt/coco/arm-cca-host/main.c b/drivers/virt/coco/arm-cca-host/main.c
new file mode 100644
index 000000000000..df2cc761f68b
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-host/main.c
@@ -0,0 +1,192 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+
+#include <linux/arm-smccc.h>
+#include <linux/arm-smccc-bus.h>
+#include <linux/pci-tsm.h>
+#include <linux/pci-ide.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/tsm.h>
+#include <linux/vmalloc.h>
+#include <linux/cleanup.h>
+
+#include "rmi-da.h"
+
+static struct pci_tsm *cca_tsm_pci_probe(struct tsm_dev *tsm_dev, struct pci_dev *pdev)
+{
+	int ret;
+
+	if (!is_pci_tsm_pf0(pdev)) {
+		struct cca_host_fn_dsc *fn_dsc __free(kfree) =
+			kzalloc(sizeof(*fn_dsc), GFP_KERNEL);
+
+		if (!fn_dsc)
+			return NULL;
+
+		ret = pci_tsm_link_constructor(pdev, &fn_dsc->pci, tsm_dev);
+		if (ret)
+			return NULL;
+
+		return &no_free_ptr(fn_dsc)->pci;
+	}
+
+	if (!pdev->ide_cap)
+		return NULL;
+
+	struct cca_host_pf0_ep_dsc *pf0_ep_dsc __free(kfree) =
+		kzalloc(sizeof(*pf0_ep_dsc), GFP_KERNEL);
+	if (!pf0_ep_dsc)
+		return NULL;
+
+	ret = pci_tsm_pf0_constructor(pdev, &pf0_ep_dsc->pci, tsm_dev);
+	if (ret)
+		return NULL;
+
+	pci_dbg(pdev, "tsm enabled\n");
+	return &no_free_ptr(pf0_ep_dsc)->pci.base_tsm;
+}
+
+static void cca_tsm_pci_remove(struct pci_tsm *tsm)
+{
+	struct pci_dev *pdev = tsm->pdev;
+
+	if (is_pci_tsm_pf0(pdev)) {
+		struct cca_host_pf0_ep_dsc *pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
+
+		pci_tsm_pf0_destructor(&pf0_ep_dsc->pci);
+		kfree(pf0_ep_dsc);
+	} else {
+		kfree(to_cca_fn_dsc(pdev));
+	}
+}
+
+static inline bool cca_pdev_need_sel_ide_streams(struct pci_dev *pdev)
+{
+	return pci_pcie_type(pdev) == PCI_EXP_TYPE_ENDPOINT;
+}
+
+static int __maybe_unused cca_tsm_connect(struct pci_dev *pdev)
+{
+	struct pci_dev *rp = pcie_find_root_port(pdev);
+	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
+	struct pci_ide *ide;
+	int ret, stream_id = 0;
+
+	/* Only function 0 supports connect in host */
+	if (WARN_ON(!is_pci_tsm_pf0(pdev)))
+		return -EIO;
+
+	pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
+	if (cca_pdev_need_sel_ide_streams(pdev)) {
+
+		ide = pci_ide_stream_alloc(pdev);
+		if (!ide) {
+			ret = -ENOMEM;
+			goto err_stream_alloc;
+		}
+
+		pf0_ep_dsc->sel_stream = ide;
+		/*
+		 * keep the stream id simple by using the host-bridge id
+		 */
+		stream_id = ide->host_bridge_stream;
+		ide->stream_id = stream_id;
+		ret = pci_ide_stream_register(ide);
+		if (ret)
+			goto err_stream;
+		/*
+		 * Configure IDE capability for target device
+		 *
+		 * Some test devices work only with DEFAULT_STREAM enabled.
+		 * For simplicity, enable DEFAULT_STREAM for all devices. A
+		 * future decent solution may be to have a quirk table to
+		 * specify which devices need DEFAULT_STREAM.
+		 */
+		ide->partner[PCI_IDE_EP].default_stream = 1;
+		pci_ide_stream_setup(pdev, ide);
+		pci_ide_stream_setup(rp, ide);
+
+		/*
+		 * Once ide is setup, enable the stream at the endpoint
+		 * Root port will be done by RMM
+		 */
+		pci_ide_stream_enable(pdev, ide);
+	}
+	return 0;
+
+err_stream:
+	if (cca_pdev_need_sel_ide_streams(pdev))
+		pci_ide_stream_free(ide);
+	pf0_ep_dsc->sel_stream = NULL;
+err_stream_alloc:
+
+	return ret;
+}
+
+static void __maybe_unused cca_tsm_disconnect(struct pci_dev *pdev)
+{
+	struct pci_ide *ide;
+	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
+
+	pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
+	if (!pf0_ep_dsc)
+		return;
+
+	if (cca_pdev_need_sel_ide_streams(pdev)) {
+		ide = pf0_ep_dsc->sel_stream;
+
+		pci_ide_stream_release(ide);
+		pf0_ep_dsc->sel_stream = NULL;
+	}
+
+}
+
+static struct pci_tsm_ops cca_link_pci_ops = {
+	.probe = cca_tsm_pci_probe,
+	.remove = cca_tsm_pci_remove,
+};
+
+static void cca_link_tsm_remove(void *tsm_dev)
+{
+	tsm_unregister(tsm_dev);
+}
+
+static bool rmi_has_reg2_feature(unsigned long feature)
+{
+	return !!u64_get_bits(rmi_feat_reg(2), feature);
+}
+
+static int cca_link_tsm_probe(struct arm_smccc_device *sdev)
+{
+	struct tsm_dev *tsm_dev;
+
+	if (!rmi_has_reg2_feature(RMI_FEATURE_REGISTER_2_DA))
+		return -ENODEV;
+
+	tsm_dev = tsm_register(&sdev->dev, &cca_link_pci_ops);
+	if (IS_ERR(tsm_dev))
+		return PTR_ERR(tsm_dev);
+
+	return devm_add_action_or_reset(&sdev->dev, cca_link_tsm_remove,
+					tsm_dev);
+}
+
+static const struct arm_smccc_device_id cca_link_tsm_id_table[] = {
+	{ .func_id = SMC_RMI_VERSION },
+	{}
+};
+MODULE_DEVICE_TABLE(arm_smccc, cca_link_tsm_id_table);
+
+static struct arm_smccc_driver cca_link_tsm_driver = {
+	.name = KBUILD_MODNAME,
+	.probe = cca_link_tsm_probe,
+	.id_table = cca_link_tsm_id_table,
+};
+module_arm_smccc_driver(cca_link_tsm_driver);
+MODULE_IMPORT_NS("PCI_IDE");
+MODULE_AUTHOR("Aneesh Kumar <aneesh.kumar@kernel.org>");
+MODULE_DESCRIPTION("ARM CCA Host TSM driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
new file mode 100644
index 000000000000..c5a568cb5674
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+
+#ifndef _VIRT_COCO_RMM_DA_H_
+#define _VIRT_COCO_RMM_DA_H_
+
+#include <linux/arm-smccc-rmi.h>
+#include <linux/arm-rmi-cmds.h>
+#include <linux/pci.h>
+#include <linux/pci-ide.h>
+#include <linux/pci-tsm.h>
+
+/**
+ * struct cca_host_pf0_ep_dsc - PF0 endpoint device security context.
+ * @pci: Physical Function 0 TDISP link context
+ * @sel_stream: Selective IDE Stream descriptor
+ */
+struct cca_host_pf0_ep_dsc {
+	struct pci_tsm_pf0 pci;
+	struct pci_ide *sel_stream;
+};
+
+struct cca_host_fn_dsc {
+	struct pci_tsm pci;
+};
+
+static inline struct cca_host_pf0_ep_dsc *to_cca_pf0_ep_dsc(struct pci_dev *pdev)
+{
+	struct pci_tsm *tsm = pdev->tsm;
+
+	if (!tsm || !is_pci_tsm_pf0(pdev))
+		return NULL;
+
+	return container_of(tsm, struct cca_host_pf0_ep_dsc, pci.base_tsm);
+}
+
+static inline struct cca_host_fn_dsc *to_cca_fn_dsc(struct pci_dev *pdev)
+{
+	struct pci_tsm *tsm = pdev->tsm;
+
+	return container_of(tsm, struct cca_host_fn_dsc, pci);
+}
+
+#endif
-- 
2.43.0

