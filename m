Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C212B2D949F;
	Thu, 12 Mar 2026 08:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302526; cv=none; b=BcmailVYzhoc6FtZklqWBlYiRSrvDbLMzbDGMGelWHhQHhV/dkUgUEH7DH83ilXTQHq3oZdvWYKf3cI9TzIzT1TkJC2uwS4g6Ifq/7vToqtS/whJRI+BIBGocqr+GZ7RlmOB067ApvRmmFjEJmJcMX0S9CBDyWny7qPOwxtKA/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302526; c=relaxed/simple;
	bh=eWlGJ1mq0uFiFfzJb+fYY2WYTV1JrcFFXW4P04yrmR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCQVLjwQN2JtjmwUH50I5MxEOzEw3zoZ15mXxxHJ/XbcGjW+ZSb0m6Meqnk1zSHIeZb5PC8NW/QOAHMKN34ppbeYgzXEI+T8qzb60wDl2k6eRdfazgxjB0ymfcsT7BET7Th3/Tu1lQepO/PVyfqNsSG/GyUjlAjy/STZfnyOr/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sYxk00+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sYxk00+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85E8C116C6;
	Thu, 12 Mar 2026 08:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302526;
	bh=eWlGJ1mq0uFiFfzJb+fYY2WYTV1JrcFFXW4P04yrmR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYxk00+3L2os3MAfNJKAbiE7LZpbj2O10PFrY9REUQuQTcLjHUmQBmvTugGrbX11N
	 RQE8Uli1HHrYCqBFThEQaBu/QybxLHHl675SRiDOGfNq64dScTzAkRuQEYV5ekAElM
	 NLjzBiY1oafLdVMXAxpImQfOjj8UyG1QghXdvP6uxetdm/2UMN3/aa3eSbDaaiZzPv
	 rfLoc9yOp/epU74Mnxjn82nz8m/EbpmhzoPIJ4aziaU6K7Lfg/gkd7iNuIqfKhxekq
	 dSayP8ICVpdLyBtuiEA+/7VmRHOeHrACHUrtlZvlwghkLDAXnlD0WctUgGlk+gpBb0
	 uagp2pwifyCWA==
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
Subject: [RFC PATCH v3 02/10] coco: host: arm64: Add host TSM callback and IDE stream allocation support
Date: Thu, 12 Mar 2026 13:31:21 +0530
Message-ID: <20260312080129.3483585-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260312080129.3483585-1-aneesh.kumar@kernel.org>
References: <20260312080129.3483585-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Register the TSM callback when the DA feature is supported by KVM.

This driver handles IDE stream setup for both the root port and PCIe
endpoints. Root port IDE stream enablement itself is managed by RMM.

In addition, the driver registers `pci_tsm_ops` with the TSM subsystem.

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
 arch/arm64/include/asm/rmi_smc.h         |   2 +
 drivers/firmware/smccc/rmm.c             |  12 ++
 drivers/firmware/smccc/rmm.h             |   8 +
 drivers/firmware/smccc/smccc.c           |   1 +
 drivers/virt/coco/Kconfig                |   2 +
 drivers/virt/coco/Makefile               |   1 +
 drivers/virt/coco/arm-cca-host/Kconfig   |  19 +++
 drivers/virt/coco/arm-cca-host/Makefile  |   5 +
 drivers/virt/coco/arm-cca-host/arm-cca.c | 205 +++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h  |  45 +++++
 10 files changed, 300 insertions(+)
 create mode 100644 drivers/virt/coco/arm-cca-host/Kconfig
 create mode 100644 drivers/virt/coco/arm-cca-host/Makefile
 create mode 100644 drivers/virt/coco/arm-cca-host/arm-cca.c
 create mode 100644 drivers/virt/coco/arm-cca-host/rmi-da.h

diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index f6f786bfb9c9..9f8b6aa5ea06 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -12,6 +12,8 @@
 
 #include <linux/arm-smccc.h>
 
+#define RMI_DEV_NAME "arm-rmi-dev"
+
 #define SMC_RMI_CALL(func)				\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
 			   ARM_SMCCC_SMC_64,		\
diff --git a/drivers/firmware/smccc/rmm.c b/drivers/firmware/smccc/rmm.c
index 03496330630f..7435996dcb90 100644
--- a/drivers/firmware/smccc/rmm.c
+++ b/drivers/firmware/smccc/rmm.c
@@ -23,3 +23,15 @@ void __init register_rsi_device(struct platform_device *pdev)
 	__devm_auxiliary_device_create(&pdev->dev,
 				       "arm_cca_guest", RSI_DEV_NAME, NULL, 0);
 }
+
+void __init register_rmi_device(struct platform_device *pdev)
+{
+	struct arm_smccc_res res;
+	unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
+						     RMI_ABI_MINOR_VERSION);
+
+	arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
+	if (res.a0 == RMI_SUCCESS)
+		__devm_auxiliary_device_create(&pdev->dev,
+					"arm_cca_host", RMI_DEV_NAME, NULL, 0);
+}
diff --git a/drivers/firmware/smccc/rmm.h b/drivers/firmware/smccc/rmm.h
index a47a650d4f51..37d0d95a099e 100644
--- a/drivers/firmware/smccc/rmm.h
+++ b/drivers/firmware/smccc/rmm.h
@@ -6,12 +6,20 @@
 
 #ifdef CONFIG_ARM64
 #include <asm/rsi_cmds.h>
+#include <asm/rmi_smc.h>
+
 void __init register_rsi_device(struct platform_device *pdev);
+void __init register_rmi_device(struct platform_device *pdev);
 #else
 
 static void __init register_rsi_device(struct platform_device *pdev)
 {
 
+}
+
+static void __init register_rmi_device(struct platform_device *pdev)
+{
+
 }
 #endif
 #endif
diff --git a/drivers/firmware/smccc/smccc.c b/drivers/firmware/smccc/smccc.c
index fc9b44b7c687..2bf2d59e686d 100644
--- a/drivers/firmware/smccc/smccc.c
+++ b/drivers/firmware/smccc/smccc.c
@@ -97,6 +97,7 @@ static int __init smccc_devices_init(void)
 		 * the required SMCCC function IDs at a supported revision.
 		 */
 		register_rsi_device(pdev);
+		register_rmi_device(pdev);
 	}
 
 	if (smccc_trng_available) {
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
index 000000000000..efe40d61d5d8
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
+	depends on KVM
+	select PCI_TSM
+	select AUXILIARY_BUS
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
index 000000000000..c236827f002c
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-host/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+obj-$(CONFIG_ARM_CCA_HOST) += arm-cca-host.o
+
+arm-cca-host-y	+=  arm-cca.o
diff --git a/drivers/virt/coco/arm-cca-host/arm-cca.c b/drivers/virt/coco/arm-cca-host/arm-cca.c
new file mode 100644
index 000000000000..639ebd82978a
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
@@ -0,0 +1,205 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+
+#include <linux/auxiliary_bus.h>
+#include <linux/pci-tsm.h>
+#include <linux/pci-ide.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/tsm.h>
+#include <linux/vmalloc.h>
+#include <linux/cleanup.h>
+#include <linux/kvm_host.h>
+
+#include "rmi-da.h"
+
+/* Total number of stream id supported at root port level */
+#define MAX_STREAM_ID	256
+
+static struct pci_tsm *cca_tsm_pci_probe(struct tsm_dev *tsm_dev, struct pci_dev *pdev)
+{
+	int rc;
+
+	if (!is_pci_tsm_pf0(pdev)) {
+		struct cca_host_fn_dsc *fn_dsc __free(kfree) =
+			kzalloc(sizeof(*fn_dsc), GFP_KERNEL);
+
+		if (!fn_dsc)
+			return NULL;
+
+		rc = pci_tsm_link_constructor(pdev, &fn_dsc->pci, tsm_dev);
+		if (rc)
+			return NULL;
+
+		return &no_free_ptr(fn_dsc)->pci;
+	}
+
+	if (!pdev->ide_cap)
+		return NULL;
+
+	struct cca_host_pf0_dsc *pf0_dsc __free(kfree) =
+					kzalloc(sizeof(*pf0_dsc), GFP_KERNEL);
+	if (!pf0_dsc)
+		return NULL;
+
+	rc = pci_tsm_pf0_constructor(pdev, &pf0_dsc->pci, tsm_dev);
+	if (rc)
+		return NULL;
+
+	pci_dbg(pdev, "tsm enabled\n");
+	return &no_free_ptr(pf0_dsc)->pci.base_tsm;
+}
+
+static void cca_tsm_pci_remove(struct pci_tsm *tsm)
+{
+	struct pci_dev *pdev = tsm->pdev;
+
+	if (is_pci_tsm_pf0(pdev)) {
+		struct cca_host_pf0_dsc *pf0_dsc = to_cca_pf0_dsc(pdev);
+
+		pci_tsm_pf0_destructor(&pf0_dsc->pci);
+		kfree(pf0_dsc);
+	} else {
+		kfree(to_cca_fn_dsc(pdev));
+	}
+}
+
+/* For now global for simplicity. Protected by pci_tsm_rwsem */
+static DECLARE_BITMAP(cca_stream_ids, MAX_STREAM_ID);
+static int alloc_stream_id(struct pci_host_bridge *hb)
+{
+	int stream_id;
+
+redo_alloc:
+	stream_id = find_first_zero_bit(cca_stream_ids, MAX_STREAM_ID);
+	if (stream_id == MAX_STREAM_ID)
+		return stream_id;
+
+	if (ida_exists(&hb->ide_stream_ids_ida, stream_id)) {
+		/* mark the stream allocated in the global bitmap. */
+		set_bit(stream_id, cca_stream_ids);
+		goto redo_alloc;
+	}
+	return stream_id;
+}
+
+static int cca_tsm_connect(struct pci_dev *pdev)
+{
+	struct pci_dev *rp = pcie_find_root_port(pdev);
+	struct cca_host_pf0_dsc *pf0_dsc;
+	struct pci_ide *ide;
+	int rc, stream_id;
+
+	/* Only function 0 supports connect in host */
+	if (WARN_ON(!is_pci_tsm_pf0(pdev)))
+		return -EIO;
+
+	pf0_dsc = to_cca_pf0_dsc(pdev);
+	/* Allocate stream id */
+	stream_id = alloc_stream_id(pci_find_host_bridge(pdev->bus));
+	if (stream_id == MAX_STREAM_ID)
+		return -EBUSY;
+	set_bit(stream_id, cca_stream_ids);
+
+	ide = pci_ide_stream_alloc(pdev);
+	if (!ide) {
+		rc = -ENOMEM;
+		goto err_stream_alloc;
+	}
+
+	pf0_dsc->sel_stream = ide;
+	ide->stream_id = stream_id;
+	rc = pci_ide_stream_register(ide);
+	if (rc)
+		goto err_stream;
+
+	pci_ide_stream_setup(pdev, ide);
+	pci_ide_stream_setup(rp, ide);
+
+	rc = tsm_ide_stream_register(ide);
+	if (rc)
+		goto err_tsm;
+
+	/*
+	 * Once ide is setup, enable the stream at the endpoint
+	 * Root port will be done by RMM
+	 */
+	pci_ide_stream_enable(pdev, ide);
+	return 0;
+
+err_tsm:
+	pci_ide_stream_teardown(rp, ide);
+	pci_ide_stream_teardown(pdev, ide);
+	pci_ide_stream_unregister(ide);
+err_stream:
+	pci_ide_stream_free(ide);
+	pf0_dsc->sel_stream = NULL;
+err_stream_alloc:
+	clear_bit(stream_id, cca_stream_ids);
+
+	return rc;
+}
+
+static void cca_tsm_disconnect(struct pci_dev *pdev)
+{
+	int stream_id;
+	struct pci_ide *ide;
+	struct cca_host_pf0_dsc *pf0_dsc;
+
+	pf0_dsc = to_cca_pf0_dsc(pdev);
+	if (!pf0_dsc)
+		return;
+
+	ide = pf0_dsc->sel_stream;
+	stream_id = ide->stream_id;
+
+	pci_ide_stream_release(ide);
+	pf0_dsc->sel_stream = NULL;
+	clear_bit(stream_id, cca_stream_ids);
+}
+
+static struct pci_tsm_ops cca_link_pci_ops = {
+	.probe = cca_tsm_pci_probe,
+	.remove = cca_tsm_pci_remove,
+	.connect = cca_tsm_connect,
+	.disconnect = cca_tsm_disconnect,
+};
+
+static void cca_link_tsm_remove(void *tsm_dev)
+{
+	tsm_unregister(tsm_dev);
+}
+
+static int cca_link_tsm_probe(struct auxiliary_device *adev,
+			      const struct auxiliary_device_id *id)
+{
+	struct tsm_dev *tsm_dev;
+
+	if (!kvm_has_da_feature())
+		return -ENODEV;
+
+	tsm_dev = tsm_register(&adev->dev, &cca_link_pci_ops);
+	if (IS_ERR(tsm_dev))
+		return PTR_ERR(tsm_dev);
+
+	return devm_add_action_or_reset(&adev->dev, cca_link_tsm_remove,
+					tsm_dev);
+}
+
+static const struct auxiliary_device_id cca_link_tsm_id_table[] = {
+	{ .name =  KBUILD_MODNAME "." RMI_DEV_NAME },
+	{}
+};
+MODULE_DEVICE_TABLE(auxiliary, cca_link_tsm_id_table);
+
+static struct auxiliary_driver cca_link_tsm_driver = {
+	.probe = cca_link_tsm_probe,
+	.id_table = cca_link_tsm_id_table,
+};
+module_auxiliary_driver(cca_link_tsm_driver);
+MODULE_IMPORT_NS("PCI_IDE");
+MODULE_AUTHOR("Aneesh Kumar <aneesh.kumar@kernel.org>");
+MODULE_DESCRIPTION("ARM CCA Host TSM driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
new file mode 100644
index 000000000000..a23955f84e4f
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+
+#ifndef _VIRT_COCO_RMM_DA_H_
+#define _VIRT_COCO_RMM_DA_H_
+
+#include <linux/pci.h>
+#include <linux/pci-ide.h>
+#include <linux/pci-tsm.h>
+#include <asm/rmi_smc.h>
+
+/**
+ * struct cca_host_pf0_dsc - Device Security Context for physical function 0.
+ * @pci: Physical Function 0 TDISP link context
+ * @sel_stream: Selective IDE Stream descriptor
+ */
+struct cca_host_pf0_dsc {
+	struct pci_tsm_pf0 pci;
+	struct pci_ide *sel_stream;
+};
+
+struct cca_host_fn_dsc {
+	struct pci_tsm pci;
+};
+
+static inline struct cca_host_pf0_dsc *to_cca_pf0_dsc(struct pci_dev *pdev)
+{
+	struct pci_tsm *tsm = pdev->tsm;
+
+	if (!tsm || !is_pci_tsm_pf0(pdev))
+		return NULL;
+
+	return container_of(tsm, struct cca_host_pf0_dsc, pci.base_tsm);
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

