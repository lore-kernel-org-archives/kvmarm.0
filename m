Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A85F3264FA;
	Mon, 27 Apr 2026 06:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777272701; cv=none; b=jSqClZuWw1Y6C/u3VoeDFMRqqycFsqyUNr3aNId2Q4OvMZTQe3LQ+kyEv30r04ffq4JWS30og2kCgtMn1WBK5MRjCDVq3d+F6C3rezWlJ/1ooE0W73ylxEggdmbgBO+Ma225rj7CJpCWgnpvchte+GDuMQEsW88tyTkm90A/FIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777272701; c=relaxed/simple;
	bh=DItmN7CZJj9mPjedXacvO6++q0aZQyxMF5Mr5JCA8i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FEgELuALJ3XTB2AuihzyePMdnBq73a+76/19D5CZ7r2ouhyx29rII7kXUqw8egVWItTBzLwNump1M22KhP5EJOdfImQE/prKxdOImahxe6FpS5x+lNHXcSxXKsP9S3e6mKpaJE6/IdHJOryqTRRQaoL6vGwW9n77Cm/UWCLPJsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dh1wPQPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dh1wPQPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607F5C19425;
	Mon, 27 Apr 2026 06:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777272701;
	bh=DItmN7CZJj9mPjedXacvO6++q0aZQyxMF5Mr5JCA8i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dh1wPQPpsfz4oPsUXrvorOw5GifxbivRYT8lRBBE0Pz0WDLXkgZg6TBuVk+w1hiAU
	 R1jvr8W5O6FyXQv0tGTd4U9tflsQAedWKpFCG3iwjZ4keFt8HWqx9bISg8B2YIt3ZE
	 GNERJYyTQkROaxWGTOhOa9F9+h81Zdn7WNf0xjRFY/J8HXpWyoiRCeTsPqq+a7Zn29
	 GTrm/MP3UCMBqvneEAaUb4ANO+kCj+6MJPbwqyKsvFaUZsJBQXfeql42vdwYNV77k6
	 Vv7gOtfBr4oOWdwXcMfPUqfFiQ0T7l/K1Be3L0ld7diV9HbxOvZaj1krPUTf9dqnK9
	 bZPE4/z0xKROg==
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
Subject: [RFC PATCH v4 01/14] coco: host: arm64: Add host TSM callback and IDE stream allocation support
Date: Mon, 27 Apr 2026 12:21:08 +0530
Message-ID: <20260427065121.916615-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427065121.916615-1-aneesh.kumar@kernel.org>
References: <20260427065121.916615-1-aneesh.kumar@kernel.org>
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

In addition, the driver registers pci_tsm_ops with the TSM subsystem.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rmi_smc.h         |   2 +
 drivers/firmware/smccc/rmm.c             |  12 ++
 drivers/firmware/smccc/rmm.h             |   8 +
 drivers/firmware/smccc/smccc.c           |   1 +
 drivers/virt/coco/Kconfig                |   2 +
 drivers/virt/coco/Makefile               |   1 +
 drivers/virt/coco/arm-cca-host/Kconfig   |  19 ++
 drivers/virt/coco/arm-cca-host/Makefile  |   5 +
 drivers/virt/coco/arm-cca-host/arm-cca.c | 225 +++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h  |  46 +++++
 10 files changed, 321 insertions(+)
 create mode 100644 drivers/virt/coco/arm-cca-host/Kconfig
 create mode 100644 drivers/virt/coco/arm-cca-host/Makefile
 create mode 100644 drivers/virt/coco/arm-cca-host/arm-cca.c
 create mode 100644 drivers/virt/coco/arm-cca-host/rmi-da.h

diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index fa23818e1b4c..109d6cc6ef37 100644
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
index 2a6187df3285..7444cc3a588c 100644
--- a/drivers/firmware/smccc/rmm.c
+++ b/drivers/firmware/smccc/rmm.c
@@ -21,3 +21,15 @@ void __init register_rsi_device(struct platform_device *pdev)
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
index 000000000000..67f7e80106e8
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
@@ -0,0 +1,225 @@
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
+
+#include "rmi-da.h"
+
+/* Total number of stream id supported at root port level */
+#define MAX_STREAM_ID	256
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
+static inline bool cca_pdev_need_sel_ide_streams(struct pci_dev *pdev)
+{
+	return pci_pcie_type(pdev) == PCI_EXP_TYPE_ENDPOINT;
+}
+
+static int cca_tsm_connect(struct pci_dev *pdev)
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
+		/* Allocate stream id */
+		stream_id = alloc_stream_id(pci_find_host_bridge(pdev->bus));
+		if (stream_id == MAX_STREAM_ID)
+			return -EBUSY;
+		set_bit(stream_id, cca_stream_ids);
+
+		ide = pci_ide_stream_alloc(pdev);
+		if (!ide) {
+			ret = -ENOMEM;
+			goto err_stream_alloc;
+		}
+
+		pf0_ep_dsc->sel_stream = ide;
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
+		ret = tsm_ide_stream_register(ide);
+		if (ret)
+			goto err_tsm;
+
+		/*
+		 * Once ide is setup, enable the stream at the endpoint
+		 * Root port will be done by RMM
+		 */
+		pci_ide_stream_enable(pdev, ide);
+	}
+	return 0;
+
+err_tsm:
+	if (cca_pdev_need_sel_ide_streams(pdev)) {
+		pci_ide_stream_teardown(rp, ide);
+		pci_ide_stream_teardown(pdev, ide);
+		pci_ide_stream_unregister(ide);
+	}
+err_stream:
+	if (cca_pdev_need_sel_ide_streams(pdev))
+		pci_ide_stream_free(ide);
+	pf0_ep_dsc->sel_stream = NULL;
+err_stream_alloc:
+	clear_bit(stream_id, cca_stream_ids);
+
+	return ret;
+}
+
+static void cca_tsm_disconnect(struct pci_dev *pdev)
+{
+	int stream_id;
+	struct pci_ide *ide;
+	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
+
+	pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
+	if (!pf0_ep_dsc)
+		return;
+
+	if (cca_pdev_need_sel_ide_streams(pdev)) {
+		ide = pf0_ep_dsc->sel_stream;
+		stream_id = ide->stream_id;
+
+		pci_ide_stream_release(ide);
+		pf0_ep_dsc->sel_stream = NULL;
+		clear_bit(stream_id, cca_stream_ids);
+	}
+
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
+		const struct auxiliary_device_id *id)
+{
+	struct tsm_dev *tsm_dev;
+
+	if (!rmm_has_reg2_feature(RMI_FEATURE_REGISTER_2_DA))
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
index 000000000000..4abc7ad159e5
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
+#include <linux/pci.h>
+#include <linux/pci-ide.h>
+#include <linux/pci-tsm.h>
+#include <asm/rmi_cmds.h>
+#include <asm/rmi_smc.h>
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

