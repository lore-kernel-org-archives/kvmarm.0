Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E162D949F;
	Thu, 12 Mar 2026 08:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302533; cv=none; b=nzoiSabZkzGlGhUtrAglpWD4e82VsU06JtogJSx06a7aFgVyUcWMJsuieKX4HY9vmNA4VXyLxzEhjKchYOft4kuBI2mJsB8PiVklCpVDLf8G5us50n80VcMGAYQ32IC6q5ui09+BkXi0I6oT/psyzfpeB5e1VeUDpee70dEWz9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302533; c=relaxed/simple;
	bh=OyePJXIGmU9NZm7ifAgf6slvGQOVTPSVDx7SSqyYN24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mk7mdJpgRUkL+aitOm/gahxla1yq9DcsFeSjYNj3JtQiwekqkNycdu9aBLY6iZaNWWszpd0l6JCulcyV+GtAvmaL/u/g7RBoFYs72L/9H4yH1XeokGLBeIOQnxHKGCAfnUPsLkzJwewxhVKYtom+oMq27PI4wj+8d6798PZ8x/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=er/G/rtt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="er/G/rtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452A7C2BC87;
	Thu, 12 Mar 2026 08:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302533;
	bh=OyePJXIGmU9NZm7ifAgf6slvGQOVTPSVDx7SSqyYN24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=er/G/rttM2NUdbMTDk8RmgeqamR5oNe/GBlF2hFiWPY1ORMHN3n6u4v98wj1Qu1CH
	 gRUa0NA4pEKjdcLu7xl35uNwVGwdS+D5eC+TKM3cCMALEmWCVZDcye/TxSoFhKclOB
	 NR033IUQ0X61kf6A/dXien2pN6smixuK+gBkcPiFGxMsl1XEpPJTs6+tE38AKLbjyX
	 0KFwYSP0zt0G07Kgqz+bBOruzcs4UaJkDUi2cdhQXMA1IBvNp1x8foL2d21ZMg9jVn
	 aEbFoZzOxoxnsqsflJgWMPPDgelLFkT63mWWfWwbSgTBgB60nUyY/smEIN2vfA/Wc0
	 8oIXz8HQXg3iQ==
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
Subject: [RFC PATCH v3 03/10] coco: host: arm64: Build and register RMM pdev descriptors
Date: Thu, 12 Mar 2026 13:31:22 +0530
Message-ID: <20260312080129.3483585-4-aneesh.kumar@kernel.org>
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

Add the SMCCC plumbing for RMI_PDEV_AUX_COUNT, RMI_PDEV_CREATE, and
RMI_PDEV_GET_STATE, describe the pdev state enum/flags in rmi_smc.h,
and extend the PF0 descriptor so we can hold the RMM-side pdev handle
plus its auxiliary granules.

Implement pdev_create() to delegate backing pages, populate the pdev
parameters from the device's RID, ECAM window, IDE stream, and
non-coherent address ranges, and invoke RMI_PDEV_CREATE. The helper
keeps track of the allocated/assigned granules and unwinds them on
failure, so the host driver can reliably establish the pdev channel
before kicking off further IDE/TSM setup.

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
 arch/arm64/include/asm/rmi_cmds.h       |  31 +++++
 arch/arm64/include/asm/rmi_smc.h        |  95 ++++++++++++++-
 drivers/virt/coco/arm-cca-host/Makefile |   2 +-
 drivers/virt/coco/arm-cca-host/rmi-da.c | 156 ++++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h |   8 ++
 5 files changed, 290 insertions(+), 2 deletions(-)
 create mode 100644 drivers/virt/coco/arm-cca-host/rmi-da.c

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index ef53147c1984..4547ce0901a6 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -505,4 +505,35 @@ static inline int rmi_rtt_unmap_unprotected(unsigned long rd,
 	return res.a0;
 }
 
+static inline unsigned long rmi_pdev_aux_count(unsigned long flags, u64 *aux_count)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_AUX_COUNT, flags, &res);
+
+	*aux_count = res.a1;
+	return res.a0;
+}
+
+static inline unsigned long rmi_pdev_create(unsigned long pdev_phys,
+					    unsigned long pdev_params_phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_CREATE,
+			     pdev_phys, pdev_params_phys, &res);
+
+	return res.a0;
+}
+
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
 #endif /* __ASM_RMI_CMDS_H */
diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 9f8b6aa5ea06..58106740c1f7 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -26,7 +26,7 @@
 #define SMC_RMI_DATA_CREATE		SMC_RMI_CALL(0x0153)
 #define SMC_RMI_DATA_CREATE_UNKNOWN	SMC_RMI_CALL(0x0154)
 #define SMC_RMI_DATA_DESTROY		SMC_RMI_CALL(0x0155)
-
+#define SMC_RMI_PDEV_AUX_COUNT		SMC_RMI_CALL(0x0156)
 #define SMC_RMI_REALM_ACTIVATE		SMC_RMI_CALL(0x0157)
 #define SMC_RMI_REALM_CREATE		SMC_RMI_CALL(0x0158)
 #define SMC_RMI_REALM_DESTROY		SMC_RMI_CALL(0x0159)
@@ -47,6 +47,9 @@
 #define SMC_RMI_RTT_INIT_RIPAS		SMC_RMI_CALL(0x0168)
 #define SMC_RMI_RTT_SET_RIPAS		SMC_RMI_CALL(0x0169)
 
+#define SMC_RMI_PDEV_CREATE             SMC_RMI_CALL(0x0176)
+#define SMC_RMI_PDEV_GET_STATE		SMC_RMI_CALL(0x0178)
+
 #define RMI_ABI_MAJOR_VERSION	1
 #define RMI_ABI_MINOR_VERSION	0
 
@@ -269,4 +272,94 @@ struct rec_run {
 	struct rec_exit exit;
 };
 
+enum rmi_pdev_state {
+	RMI_PDEV_NEW,
+	RMI_PDEV_NEEDS_KEY,
+	RMI_PDEV_HAS_KEY,
+	RMI_PDEV_READY,
+	RMI_PDEV_IDE_RESETTING,
+	RMI_PDEV_COMMUNICATING,
+	RMI_PDEV_STOPPING,
+	RMI_PDEV_STOPPED,
+	RMI_PDEV_ERROR,
+};
+
+#define MAX_PDEV_AUX_GRANULES	32
+#define MAX_IOCOH_ADDR_RANGE	16
+#define MAX_FCOH_ADDR_RANGE	4
+
+#define RMI_PDEV_FLAGS_SPDM		BIT(0)
+#define RMI_PDEV_FLAGS_NCOH_IDE		BIT(1)
+#define RMI_PDEV_FLAGS_NCOH_ADDR	BIT(2)
+#define RMI_PDEV_FLAGS_COH_IDE		BIT(3)
+#define RMI_PDEV_FLAGS_COH_ADDR		BIT(4)
+#define RMI_PDEV_FLAGS_P2P		BIT(5)
+#define RMI_PDEV_FLAGS_COMP_TRUST	BIT(6)
+#define RMI_PDEV_FLAGS_CATEGORY_MASK	GENMASK(8, 7)
+#define RMI_PDEV_FLAGS_CATEGORY_SHIFT	7
+
+#define RMI_PDEV_FLAGS_CATEGORY_CMEM_CXL	0x1
+
+#define RMI_HASH_SHA_256	0
+#define RMI_HASH_SHA_512	1
+
+struct rmi_pdev_addr_range {
+	u64 base;
+	u64 top;
+};
+
+struct rmi_pdev_params {
+	union {
+		struct {
+			u64 flags;
+			u64 pdev_id;
+			union {
+				u8 segment_id;
+				u64 padding0;
+			};
+			u64 ecam_addr;
+			union {
+				u16 root_id;
+				u64 padding1;
+			};
+			u64 cert_id;
+			union {
+				u16 rid_base;
+				u64 padding2;
+			};
+			union {
+				u16 rid_top;
+				u64 padding3;
+			};
+			union {
+				u8 hash_algo;
+				u64 padding4;
+			};
+			u64 num_aux;
+			u64 ncoh_ide_sid;
+			u64 ncoh_num_addr_range;
+			u64 coh_num_addr_range;
+		};
+		u8 padding5[0x100];
+	};
+
+	union { /* 0x100 */
+		u64 aux_granule[MAX_PDEV_AUX_GRANULES];
+		u8 padding6[0x100];
+	};
+
+	union { /* 0x200 */
+		struct {
+			struct rmi_pdev_addr_range ncoh_addr_range[MAX_IOCOH_ADDR_RANGE];
+		};
+		u8 padding7[0x100];
+	};
+	union { /* 0x300 */
+		struct {
+			struct rmi_pdev_addr_range coh_addr_range[MAX_FCOH_ADDR_RANGE];
+		};
+		u8 padding8[0x100];
+	};
+};
+
 #endif /* __ASM_RMI_SMC_H */
diff --git a/drivers/virt/coco/arm-cca-host/Makefile b/drivers/virt/coco/arm-cca-host/Makefile
index c236827f002c..d48e8940af46 100644
--- a/drivers/virt/coco/arm-cca-host/Makefile
+++ b/drivers/virt/coco/arm-cca-host/Makefile
@@ -2,4 +2,4 @@
 #
 obj-$(CONFIG_ARM_CCA_HOST) += arm-cca-host.o
 
-arm-cca-host-y	+=  arm-cca.o
+arm-cca-host-y	+=  arm-cca.o rmi-da.o
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
new file mode 100644
index 000000000000..89b61ad5bc00
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -0,0 +1,156 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+
+#include <linux/pci.h>
+#include <linux/pci-ecam.h>
+#include <asm/rmi_cmds.h>
+
+#include "rmi-da.h"
+
+static int pci_dev_addr_range(struct pci_dev *pdev,
+			      struct rmi_pdev_addr_range *pdev_addr,
+			      struct pci_ide_partner *partner)
+{
+	int naddr = 0;
+	struct pci_dev *br;
+	struct resource *mem, *pref;
+
+	br = pci_upstream_bridge(pdev);
+	if (!br)
+		return 0;
+
+	mem = pci_resource_n(br, PCI_BRIDGE_MEM_WINDOW);
+	pref = pci_resource_n(br, PCI_BRIDGE_PREF_MEM_WINDOW);
+	if (resource_assigned(mem)) {
+		pdev_addr[naddr].base = mem->start;
+		pdev_addr[naddr].top  = mem->end + 1;
+		naddr++;
+	}
+	if (resource_assigned(pref)) {
+		pdev_addr[naddr].base = pref->start;
+		pdev_addr[naddr].top  = pref->end + 1;
+		naddr++;
+	}
+	return naddr;
+}
+
+static void free_aux_pages(int cnt, void *aux[])
+{
+	int ret;
+
+	while (cnt--) {
+		ret = rmi_granule_undelegate(virt_to_phys(aux[cnt]));
+		if (!ret)
+			free_page((unsigned long)aux[cnt]);
+	}
+}
+
+static int init_pdev_params(struct pci_dev *pdev, struct rmi_pdev_params *params)
+{
+	int rid, ret, i;
+	phys_addr_t aux_phys;
+	struct pci_config_window *cfg = pdev->bus->sysdata;
+	struct cca_host_pf0_dsc *pf0_dsc = to_cca_pf0_dsc(pdev);
+	struct pci_ide *ide = pf0_dsc->sel_stream;
+
+	/* assign the ep device with RMM */
+	rid = pci_dev_id(pdev);
+	params->pdev_id = rid;
+	/* slot number for certificate chain */
+	params->cert_id = 0;
+	/* io coherent spdm/ide and non p2p */
+	params->flags = RMI_PDEV_FLAGS_SPDM | RMI_PDEV_FLAGS_NCOH_IDE |
+			RMI_PDEV_FLAGS_NCOH_ADDR;
+	params->ncoh_ide_sid = ide->stream_id;
+	params->hash_algo = RMI_HASH_SHA_256;
+	/* use the rid and MMIO resources of the end point pdev */
+	params->rid_base = rid;
+	params->rid_top = params->rid_base + 1;
+	params->ecam_addr = cfg->res.start;
+	params->root_id = pci_dev_id(pcie_find_root_port(pdev));
+
+	params->ncoh_num_addr_range = pci_dev_addr_range(pdev,
+						params->ncoh_addr_range,
+						&ide->partner[PCI_IDE_RP]);
+
+	ret = rmi_pdev_aux_count(params->flags, &params->num_aux);
+	if (ret)
+		return -EIO;
+
+	pf0_dsc->num_aux = params->num_aux;
+	for (i = 0; i < params->num_aux; i++) {
+		void *aux = (void *)__get_free_page(GFP_KERNEL);
+
+		if (!aux) {
+			ret = -ENOMEM;
+			goto err_free_aux;
+		}
+
+		aux_phys = virt_to_phys(aux);
+		if (rmi_granule_delegate(aux_phys)) {
+			ret = -EIO;
+			free_page((unsigned long)aux);
+			goto err_free_aux;
+		}
+		params->aux_granule[i] = aux_phys;
+		pf0_dsc->aux[i] = aux;
+	}
+	return 0;
+
+err_free_aux:
+	free_aux_pages(i, pf0_dsc->aux);
+	return ret;
+}
+
+int cca_pdev_create(struct pci_dev *pci_dev)
+{
+	int ret;
+	void *rmm_pdev;
+	bool should_free = true;
+	phys_addr_t rmm_pdev_phys;
+	struct rmi_pdev_params *params;
+	struct cca_host_pf0_dsc *pf0_dsc = to_cca_pf0_dsc(pci_dev);
+
+	rmm_pdev = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!rmm_pdev)
+		return -ENOMEM;
+
+	rmm_pdev_phys = virt_to_phys(rmm_pdev);
+	if (rmi_granule_delegate(rmm_pdev_phys)) {
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
+	if (rmi_pdev_create(rmm_pdev_phys, virt_to_phys(params))) {
+		ret = -EIO;
+		goto err_pdev_create;
+	}
+
+	pf0_dsc->rmm_pdev = rmm_pdev;
+	free_page((unsigned long)params);
+	return 0;
+
+err_pdev_create:
+	free_aux_pages(pf0_dsc->num_aux, pf0_dsc->aux);
+err_init_pdev_params:
+	free_page((unsigned long)params);
+err_param_alloc:
+	if (rmi_granule_undelegate(rmm_pdev_phys))
+		should_free = false;
+err_granule_delegate:
+	if (should_free)
+		free_page((unsigned long)rmm_pdev);
+	return ret;
+}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index a23955f84e4f..229f3ff6dc6f 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -15,10 +15,17 @@
  * struct cca_host_pf0_dsc - Device Security Context for physical function 0.
  * @pci: Physical Function 0 TDISP link context
  * @sel_stream: Selective IDE Stream descriptor
+ * @rmm_pdev: Delegated granule address of rmm pdev object
+ * @num_ax: Number of auxiliary granules allocated for pdev
+ * @aux: Delegated auxiliary granules
  */
 struct cca_host_pf0_dsc {
 	struct pci_tsm_pf0 pci;
 	struct pci_ide *sel_stream;
+
+	void *rmm_pdev;
+	int num_aux;
+	void *aux[MAX_PDEV_AUX_GRANULES];
 };
 
 struct cca_host_fn_dsc {
@@ -42,4 +49,5 @@ static inline struct cca_host_fn_dsc *to_cca_fn_dsc(struct pci_dev *pdev)
 	return container_of(tsm, struct cca_host_fn_dsc, pci);
 }
 
+int cca_pdev_create(struct pci_dev *pdev);
 #endif
-- 
2.43.0

