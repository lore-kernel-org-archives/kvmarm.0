Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E623A7848;
	Mon, 27 Apr 2026 08:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280075; cv=none; b=plszyb453dOBlN9A2AavI3rAUkjR81BgDAmpkiVNsmL8vja/gBS7puCDtKEpnVpCe++t59gxqlaV33LFeb3MfJyGoOjOtFxg6iD/LIPuW6gmoP68w4YMJ4OngN1Qo40ELMgr+NyiLLek0eK88VjWf1BqF/gSqaXzCW1MvISM3qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280075; c=relaxed/simple;
	bh=HoP5ReyaifPvF79Qumt8YpJX3hht02/hAu43N/E/zHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFKqLG/7h0PC7ql8n1F0+WV/ad1N/wqQjmD7E8wLNoJj7NEUMoV9oMlzIbAUYR62yXyS/pyWedvKL9bBQrxQqHL5VGI3pv97X4vOWwxRbnWmJpfvfHwT9O25Jl7pmwLbvGxaT7IDl/SBsIxNqS6TqlCkbIRHeups0SL/Sb+gpKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eiBH86U2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eiBH86U2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2204C19425;
	Mon, 27 Apr 2026 08:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777280074;
	bh=HoP5ReyaifPvF79Qumt8YpJX3hht02/hAu43N/E/zHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eiBH86U2DNdf4f0du7Ehk0tKslaUzKD0QpK0j8ABwIj2d5UMNOdmNT9UZzAHe5dLd
	 S+PEeDwN7vUfqXkLSS8wfmoKha0tkkuZuElKXA5Qx2ymyXGINUJza3eFXxBomYHk+i
	 8N4VF3JPCmU1jn8L6xlAlQ2+I89GxXTPcTqjbITevunyEfIgDyFJY1u3OOJZHZMeZ5
	 U1ZhlWyZRXx0yjdrpG0i0Ns1vh0DDvocOadPdjQ/eMDBFvKSP7PHLjTDMmQuTqAAWe
	 Z73xgePhYYQ0wO5Jv9VA5b8s/wSNgmkMd+KlrHngwZih3atyCDryxQxI6wwKZYPizz
	 +VXVfxdG+GbrQ==
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
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [RFC PATCH v4 06/16] coco: host: arm64: Add support for RMM vdev objects
Date: Mon, 27 Apr 2026 14:23:34 +0530
Message-ID: <20260427085344.941627-7-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427085344.941627-1-aneesh.kumar@kernel.org>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An RMM vdev object represents the binding between a device function and
a Realm. For example, a vdev can represent a physical function of a PCIe
device or a virtual function of a multi-function PCIe device. Each vdev
is associated with one pdev.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rmi_cmds.h        |  22 +++++
 arch/arm64/include/asm/rmi_smc.h         |  22 +++++
 drivers/virt/coco/arm-cca-host/arm-cca.c |  27 +++++-
 drivers/virt/coco/arm-cca-host/rmi-da.c  | 104 +++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h  |   2 +
 5 files changed, 176 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index 2925abde3882..242ce2fac14e 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -903,4 +903,26 @@ static inline unsigned long rmi_vdev_abort(unsigned long vdev_phys)
 	return res.a0;
 }
 
+static inline unsigned long rmi_vdev_create(unsigned long rd,
+		unsigned long pdev_phys, unsigned long vdev_phys,
+		unsigned long vdev_params_phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_CREATE, rd, pdev_phys,
+			     vdev_phys, vdev_params_phys, &res);
+
+	return res.a0;
+}
+
+static inline unsigned long rmi_vdev_lock(unsigned long rd,
+		unsigned long pdev_phys, unsigned long vdev_phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_LOCK, rd, pdev_phys, vdev_phys, &res);
+
+	return res.a0;
+}
+
 #endif /* __ASM_RMI_CMDS_H */
diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 72e4a53b74b0..d14d13a9f169 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -650,4 +650,26 @@ enum rmi_vdev_state {
 	RMI_VDEV_STARTED,
 	RMI_VDEV_ERROR,
 };
+
+#define MAX_VDEV_ADDR_RANGE 8
+
+struct rmi_vdev_params {
+	union {
+		struct {
+			u64 flags;
+			u64 vdev_id;
+			u64 tdi_id;
+			u64 padding1;
+			u64 vsmmu_addr;
+			u64 vsid;
+			u64 num_addr_range;
+		};
+		u8 padding2[0x200];
+	};
+	union { /* 0x200 */
+		struct rmi_addr_range addr_range[MAX_VDEV_ADDR_RANGE];
+		u8 padding3[0x1000 - 0x200];
+	};
+};
+
 #endif /* __ASM_RMI_SMC_H */
diff --git a/drivers/virt/coco/arm-cca-host/arm-cca.c b/drivers/virt/coco/arm-cca-host/arm-cca.c
index 8b1182620872..5930a30dd16f 100644
--- a/drivers/virt/coco/arm-cca-host/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
@@ -12,7 +12,8 @@
 #include <linux/vmalloc.h>
 #include <linux/cleanup.h>
 #include <linux/pci-doe.h>
-
+#include <linux/pci.h>
+#include <linux/kvm_host.h>
 
 #include "rmi-da.h"
 
@@ -449,11 +450,35 @@ static void cca_tsm_disconnect(struct pci_dev *pdev)
 	}
 }
 
+static struct pci_tdi *cca_tsm_bind(struct pci_dev *pdev, struct kvm *kvm, u32 tdi_id)
+{
+	void *rmm_vdev;
+	struct pci_dev *dsm_dev = pdev->tsm->dsm_dev;
+	struct realm *realm = &kvm->arch.realm;
+
+	struct cca_host_tdi *host_tdi __free(kfree) =
+		kzalloc(sizeof(struct cca_host_tdi), GFP_KERNEL);
+	if (!host_tdi)
+		return ERR_PTR(-ENOMEM);
+
+	pci_tsm_tdi_constructor(pdev, &host_tdi->tdi, kvm, tdi_id);
+	/* Assign the tdi such that vdev_create can use that to lookup */
+	pdev->tsm->tdi = &host_tdi->tdi;
+	rmm_vdev = cca_vdev_create(realm, pdev, dsm_dev, tdi_id);
+	if (IS_ERR_OR_NULL(rmm_vdev)) {
+		pdev->tsm->tdi = NULL;
+		return rmm_vdev;
+	}
+
+	return &no_free_ptr(host_tdi)->tdi;
+}
+
 static struct pci_tsm_ops cca_link_pci_ops = {
 	.probe = cca_tsm_pci_probe,
 	.remove = cca_tsm_pci_remove,
 	.connect = cca_tsm_connect,
 	.disconnect = cca_tsm_disconnect,
+	.bind = cca_tsm_bind,
 };
 
 static void cca_link_tsm_remove(void *tsm_dev)
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index d61c3191c038..84f0b2211cd1 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -934,3 +934,107 @@ int cca_pdev_disconnect_stream(struct pci_dev *pdev1,
 
 	return submit_stream_work(pdev1, pdev2, stream_handle);
 }
+
+static unsigned long pci_get_tdi_id(struct pci_dev *pdev)
+{
+	/* requester segment is marked reserved. */
+	return pci_dev_id(pdev);
+}
+
+static void init_vdev_params_mmio_range(struct pci_dev *pdev,
+		struct rmi_vdev_params *params)
+{
+	int index = 0;
+
+	for (int i = 0; i < PCI_STD_NUM_BARS; i++) {
+		struct resource *res = &pdev->resource[i];
+
+		if (!(res->flags & IORESOURCE_MEM))
+			continue;
+
+		if (resource_size(res) == 0)
+			continue;
+
+		index = insert_addr_range_sorted(params->addr_range, index,
+						 res->start, res->end + 1);
+	}
+
+	params->num_addr_range = index;
+}
+
+
+void *cca_vdev_create(struct realm *realm, struct pci_dev *pdev,
+		struct pci_dev *pf0_dev, u32 guest_rid)
+{
+	phys_addr_t rd_phys = virt_to_phys(realm->rd);
+	struct rmi_vdev_params *params = NULL;
+	struct cca_host_pdev_dsc *pdev_dsc;
+	struct cca_host_tdi *host_tdi;
+	phys_addr_t rmm_pdev_phys;
+	phys_addr_t rmm_vdev_phys;
+	bool should_free = true;
+	void *rmm_vdev;
+	int ret;
+
+	pdev_dsc = to_cca_pdev_dsc(pf0_dev);
+	if (!pdev_dsc->rmm_pdev) {
+		ret = -EINVAL;
+		goto err_out;
+	}
+
+	rmm_vdev = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!rmm_vdev) {
+		ret =  -ENOMEM;
+		goto err_out;
+	}
+
+	rmm_vdev_phys = virt_to_phys(rmm_vdev);
+	if (rmi_delegate_page(rmm_vdev_phys)) {
+		ret = -ENXIO;
+		goto err_granule_delegate;
+	}
+
+	params = (struct rmi_vdev_params *)get_zeroed_page(GFP_KERNEL);
+	if (!params) {
+		ret = -ENOMEM;
+		goto err_params_alloc;
+	}
+
+	params->flags = 0;
+	params->vdev_id = guest_rid;
+	params->tdi_id = pci_get_tdi_id(pdev);
+
+	init_vdev_params_mmio_range(pdev, params);
+
+	rmm_pdev_phys = virt_to_phys(pdev_dsc->rmm_pdev);
+	if (rmi_vdev_create(rd_phys, rmm_pdev_phys,
+			    rmm_vdev_phys, virt_to_phys(params))) {
+		ret = -ENXIO;
+		goto err_vdev_create;
+	}
+
+	/* setup host_tdi before call to device communicate */
+	host_tdi = to_cca_host_tdi(pdev);
+	host_tdi->rmm_vdev = rmm_vdev;
+	host_tdi->realm = realm;
+
+	submit_vdev_state_transition_work(pdev, RMI_VDEV_UNLOCKED);
+
+	ret = rmi_vdev_lock(rd_phys, rmm_pdev_phys, rmm_vdev_phys);
+
+	submit_vdev_state_transition_work(pdev, RMI_VDEV_LOCKED);
+
+	free_page((unsigned long)params);
+	return rmm_vdev;
+
+err_vdev_create:
+	free_page((unsigned long)params);
+err_params_alloc:
+	if (rmi_undelegate_page(rmm_vdev_phys))
+		should_free = false;
+err_granule_delegate:
+	if (should_free)
+		free_page((unsigned long)rmm_vdev);
+err_out:
+	return ERR_PTR(ret);
+}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index 88fa428f788e..cd13cbf650d5 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -233,5 +233,7 @@ int cca_pdev_stream_connect(struct pci_dev *pdev1, struct pci_dev *pdev2,
 		unsigned long *stream_handle);
 int cca_pdev_disconnect_stream(struct pci_dev *pdev1,
 		struct pci_dev *pdev2, unsigned long stream_handle);
+void *cca_vdev_create(struct realm *realm, struct pci_dev *pdev,
+		struct pci_dev *pf0_dev, u32 guest_rid);
 
 #endif
-- 
2.43.0

