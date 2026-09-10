Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7718749BD88;
	Thu, 10 Sep 2026 14:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049135; cv=none; b=hB5T9e8bAIQkfX5nTZJYQIlH4XsoL/QxsTKvyTkpm4lrWf2PyLmprkJIWoW3NteNI4R8GK8+iqHr1wx4N/Lig19Z6KkR4K+JqMmZYp3ysJ3JJSR4g1I6EDaGfqYFEwXHAjRfZO5rX7Dn0K8GOO+qSnwPJGZuwOOBOCFDKO0YZbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049135; c=relaxed/simple;
	bh=D2thJi9YqnarZ9ESCZo3JVYhDCvRjNmOTLyItJJmI1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzfIALp6LcmoC+xd87N8EB7Ig7WMsy5rmJ2iLt8eFoRICuQwg6dIcCEBThvEZfd63e8SK7TAUp2dFxJW/fQmIIJMZqb+5epZzuO0/1GYCgrf6k8zsxVd0s3YgdDuXWrNbauGShhzMCrlO5YY/lbIpHiq1Y4wkOVgBcy9SDBBSVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LVRMEBsg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LVRMEBsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCE81F000FF;
	Thu, 10 Sep 2026 14:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049132;
	bh=gZCTlQJpIBSERmsxN06CrBINuFB1nOoFSPT8yuNke68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LVRMEBsg94Rd36kfVrF+woZhxkxn2Sle/Mdyj4e0L8Xz3kpXTl9tfvsiXTPHJX3+j
	 bdbAKrBaNL9qYL9H9tUPKJqkOHz5WfZJGVCN0fsshUB3Yw5+zLZbpUYMGRgVA2jSDz
	 dCnwuDecWWl2aQkoTfRe9eYjtHJ5VFIl8bb2bakUzF0pIWZZ492iLijqww1NKGl28t
	 OCfGgAzgePGrzg9PlihIt5+nFyxwj3i7H+LCO18OH4yTO99JWK2c0cy42CQPXr2OP7
	 1OZSpTGrC0LhRrxnb4NaOxR8tI6oCxQaJQR5f+gdtOnKJKanUH+5QcmVp7aMa7Hs1H
	 PvyaR6WiWv+uQ==
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
Subject: [PATCH v5 02/15] coco: host: arm64: Create RMM pdev objects for PCI endpoints
Date: Thu, 10 Sep 2026 19:34:55 +0530
Message-ID: <20260910140509.868402-3-aneesh.kumar@kernel.org>
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

Add the RMI definitions needed for pdev management, including the pdev
state enum, parameter layout, and helpers for RMI_PDEV_CREATE and
RMI_PDEV_GET_STATE.

Introduce a host-side pdev descriptor and cca_pdev_create() to
allocate and delegate the backing granule, populate the pdev parameters
from the PCI endpoint, and issue RMI_PDEV_CREATE to the RMM.

The new helper stores the created RMM pdev handle in the PF0 endpoint
descriptor preparing the device for later IDE/TDISP setup.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/arm-cca-host/Makefile |   2 +-
 drivers/virt/coco/arm-cca-host/rmi-da.c | 146 ++++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h |  26 +++++
 include/linux/arm-rmi-cmds.h            |  11 ++
 include/linux/arm-smccc-rmi.h           |  43 +++++++
 5 files changed, 227 insertions(+), 1 deletion(-)
 create mode 100644 drivers/virt/coco/arm-cca-host/rmi-da.c

diff --git a/drivers/virt/coco/arm-cca-host/Makefile b/drivers/virt/coco/arm-cca-host/Makefile
index 7a4c2e0e5d26..cdbe85d072ae 100644
--- a/drivers/virt/coco/arm-cca-host/Makefile
+++ b/drivers/virt/coco/arm-cca-host/Makefile
@@ -2,4 +2,4 @@
 #
 obj-$(CONFIG_ARM_CCA_HOST) += arm-cca-host.o
 
-arm-cca-host-y	+=  main.o
+arm-cca-host-y	+=  main.o rmi-da.o
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
new file mode 100644
index 000000000000..863bb425e5c9
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+
+#include <linux/arm-rmi-cmds.h>
+#include <linux/pci.h>
+#include <linux/pci-ecam.h>
+
+#include "rmi-da.h"
+
+static int pci_ide_segment(struct pci_dev *pdev)
+{
+	if (pdev->fm_enabled)
+		return pci_domain_nr(pdev->bus);
+	return 0;
+}
+
+static unsigned int pci_get_max_rid(struct pci_dev *pdev)
+{
+	int fn;
+	int max_rid;
+	int slot = PCI_SLOT(pdev->devfn);
+
+	for (fn = 0; fn < 8; fn++) {
+		struct pci_dev *fn_dev;
+
+		fn_dev = pci_get_slot(pdev->bus, PCI_DEVFN(slot, fn));
+		if (!fn_dev)
+			continue;
+
+		max_rid = pci_dev_id(fn_dev);
+		pci_dev_put(fn_dev);
+	}
+	return max_rid;
+}
+
+static int init_pdev_params(struct pci_dev *pdev, struct rmi_pdev_params *params)
+{
+	int rid;
+	unsigned long category;
+	struct pci_config_window *cfg = pdev->bus->sysdata;
+
+	/* check we are ECAM compliant */
+	if (!pdev->bus->ops->map_bus)
+		return -EINVAL;
+
+	switch (pci_pcie_type(pdev)) {
+	case PCI_EXP_TYPE_ENDPOINT: {
+		struct cca_host_pf0_ep_dsc *pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
+
+		/* Endpoint needs DOE mailbox */
+		if (!pf0_ep_dsc->pci.doe_mb)
+			return -EINVAL;
+
+		params->flags = RMI_PDEV_FLAGS_SPDM;
+		category = RMI_PDEV_FLAGS_CATEGORY_OFF_CHIP_EP;
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	params->flags |= (category << RMI_PDEV_FLAGS_CATEGORY_SHIFT);
+	/* assign the ep device with RMM */
+	rid = pci_dev_id(pdev);
+	params->pdev_id = rid;
+	params->hb_base = cfg->res.start;
+	params->routing_id = pci_ide_segment(pdev);
+	/* slot number for certificate chain default to zero */
+	params->id_index = 0;
+	params->hash_algo = RMI_HASH_SHA_256;
+	/* no multi function device here. */
+	params->rid_base = rid;
+	params->rid_top = pci_get_max_rid(pdev) + 1;
+	return 0;
+}
+
+static inline int rmi_pdev_create(unsigned long pdev_phys,
+		unsigned long pdev_params_phys, unsigned long *rmi_ret)
+{
+	struct rmi_sro_state *sro __free(kfree) = kmalloc_obj(*sro);
+	if (!sro)
+		return -ENOMEM;
+
+	*rmi_ret = rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_PDEV_CREATE,
+				       pdev_phys, pdev_params_phys);
+
+	return 0;
+}
+
+int cca_pdev_create(struct pci_dev *pci_dev)
+{
+	int ret;
+	void *rmm_pdev;
+	bool should_free = true;
+	phys_addr_t rmm_pdev_phys;
+	struct rmi_pdev_params *params;
+	struct cca_host_pdev_dsc *pdev_dsc = to_cca_pdev_dsc(pci_dev);
+
+	rmm_pdev = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!rmm_pdev)
+		return -ENOMEM;
+
+	rmm_pdev_phys = virt_to_phys(rmm_pdev);
+	if (rmi_delegate_page(rmm_pdev_phys)) {
+		ret = -EIO;
+		goto err_granule_delegate;
+	}
+
+	params = (struct rmi_pdev_params *)get_zeroed_page(GFP_KERNEL);
+	if (!params) {
+		ret = -ENOMEM;
+		goto err_param_alloc;
+	}
+
+	ret = init_pdev_params(pci_dev, params);
+	if (ret)
+		goto err_init_pdev_params;
+
+	{
+		unsigned long rmi_ret;
+
+		ret = rmi_pdev_create(rmm_pdev_phys, virt_to_phys(params),
+				      &rmi_ret);
+		if (ret || rmi_ret) {
+			if (!ret)
+				ret = -EIO;
+			goto err_init_pdev_params;
+		}
+	}
+
+	pdev_dsc->rmm_pdev = rmm_pdev;
+	free_page((unsigned long)params);
+	return 0;
+
+err_init_pdev_params:
+	free_page((unsigned long)params);
+err_param_alloc:
+	if (rmi_undelegate_page(rmm_pdev_phys))
+		should_free = false;
+err_granule_delegate:
+	if (should_free)
+		free_page((unsigned long)rmm_pdev);
+	return ret;
+}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index c5a568cb5674..f1580308777b 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -12,13 +12,26 @@
 #include <linux/pci-ide.h>
 #include <linux/pci-tsm.h>
 
+/**
+ * struct cca_host_pdev_dsc - Common RMM pdev context
+ * @rmm_pdev: Delegated page backing the RMM pdev object
+ * @object_lock: Serializes access to the RMM pdev object and PF0/TDI caches
+ */
+struct cca_host_pdev_dsc {
+	void *rmm_pdev;
+	/* lock kept here to simplify the generic lock/unlock paths. */
+	struct mutex object_lock;
+};
+
 /**
  * struct cca_host_pf0_ep_dsc - PF0 endpoint device security context.
  * @pci: Physical Function 0 TDISP link context
+ * @pdev: pdev communication context
  * @sel_stream: Selective IDE Stream descriptor
  */
 struct cca_host_pf0_ep_dsc {
 	struct pci_tsm_pf0 pci;
+	struct cca_host_pdev_dsc pdev;
 	struct pci_ide *sel_stream;
 };
 
@@ -43,4 +56,17 @@ static inline struct cca_host_fn_dsc *to_cca_fn_dsc(struct pci_dev *pdev)
 	return container_of(tsm, struct cca_host_fn_dsc, pci);
 }
 
+static inline struct cca_host_pdev_dsc *to_cca_pdev_dsc(struct pci_dev *pdev)
+{
+	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
+
+	pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
+	if (pf0_ep_dsc)
+		return &pf0_ep_dsc->pdev;
+
+	return NULL;
+}
+
+int cca_pdev_create(struct pci_dev *pdev);
+
 #endif
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index 746257d77dd6..850ac8e230e2 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -8,6 +8,7 @@
 
 #include <linux/arm-smccc-rmi.h>
 #include <linux/bug.h>
+#include <linux/gfp_types.h>
 #include <linux/types.h>
 
 #define RMI_MAX_ADDR_LIST	256
@@ -675,4 +676,14 @@ static inline long rmi_rtt_unprot_unmap(unsigned long rd,
 	return ret;
 }
 
+static inline unsigned long rmi_pdev_get_state(unsigned long pdev_phys, enum rmi_pdev_state *state)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_GET_STATE, pdev_phys, &res);
+
+	*state = res.a1;
+	return res.a0;
+}
+
 #endif
diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc-rmi.h
index 3eb88caf4096..7241da55c753 100644
--- a/include/linux/arm-smccc-rmi.h
+++ b/include/linux/arm-smccc-rmi.h
@@ -491,4 +491,47 @@ static_assert(sizeof(struct rec_run) == SZ_4K);
 #define RMI_S2AP_DIRECT_WRITE			BIT(0)
 #define RMI_S2AP_DIRECT_READ			BIT(1)
 
+enum rmi_pdev_state {
+	RMI_PDEV_NEW,
+	RMI_PDEV_NEEDS_KEY,
+	RMI_PDEV_HAS_KEY,
+	RMI_PDEV_READY,
+	RMI_PDEV_STOPPED,
+	RMI_PDEV_ERROR,
+};
+
+#define RMI_PDEV_FLAGS_SPDM		BIT(0)
+#define RMI_PDEV_FLAGS_CATEGORY_MASK	GENMASK(2, 1)
+#define RMI_PDEV_FLAGS_CATEGORY_SHIFT	1
+#define RMI_PDEV_FLAGS_P2P		BIT(3)
+
+#define RMI_PDEV_FLAGS_CATEGORY_ROOT_PORT	0x0
+#define RMI_PDEV_FLAGS_CATEGORY_OFF_CHIP_EP	0x1
+#define RMI_PDEV_FLAGS_CATEGORY_ON_CHIP_EP	0x2
+
+struct rmi_pdev_params {
+	union {
+		struct {
+			u64 flags;
+			u64 hb_base;
+			u64 pdev_id;
+			u64 routing_id;
+			u64 id_index;
+			union {
+				u32 rid_base;
+				u8 padding0[8];
+			};
+			union {
+				u32 rid_top;
+				u8 padding1[8];
+			};
+			union {
+				u8 hash_algo;
+				u8 padding2[8];
+			};
+		};
+		u8 padding3[0x1000];
+	};
+};
+
 #endif /* __LINUX_ARM_SMCCC_RMI_H_ */
-- 
2.43.0

