Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AF82DEA95;
	Thu, 12 Mar 2026 08:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302709; cv=none; b=Z7bqGCJfZ9e6SeAz/isFioIa2KVJK26B8FacJ+qghzTOYhF3YC0NoD603Er7uYCRPHG7dcdVJWpT4nylr5XcVcZJ1uqZBn1adWriau1Yl4v5rY5nimNIwVWFD+ZLybHHTJgWmD9PMmiFV4vCfzebaMwuJ70iRlGRPoVlcIsZLVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302709; c=relaxed/simple;
	bh=Cs3+6+wk9JTF3NHoik0ZLmLLLmjDdYn0+4+5JTMfico=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8agqI1YahYnWEGyzyUvues1L8xc8S8WbKalzy6Fb2dGEMOT44vw7rE5SatX8um++GOgGbjnzSbwDwfT17keMP8OR0oDmU4g1aIzY+pD09pQ6gGz9frPckzp48tdJOe4Kf2babswlbx/JYx8qvXeTc5ZtevFqt6qRba99meavU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ojQnlPSj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojQnlPSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A90C116C6;
	Thu, 12 Mar 2026 08:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302709;
	bh=Cs3+6+wk9JTF3NHoik0ZLmLLLmjDdYn0+4+5JTMfico=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojQnlPSje7hrYPC2DGbrRQ8r3wIOkKXoxSHltIqp4x8d3afhjQuM8GWUQLlQKOZRx
	 7Geej2YXO4LcYniVSzn25L0RFp8Eh0+XWma57uWOoHuVvukTZ28AFgZch34zsJrRdl
	 Qp082YxTuBCcBImIlEXrz9xtXbRJisqtr7P4EJhiKK2jCRoyc7DoC5/Ojqs0N2/sap
	 rl3vz5c7C1Za10nCkTV0BxfIdKnbaMY4ZDRnjJHh0PPbdERCG4YiYT6VrRG3FM3roQ
	 //dVbbMrwZDwmb7Qj9y06lG43NdQlSV3Xu2tCFqXrxJ26RAh6Lc6kYU5p3luIzmp0j
	 WiL6owzLbE91A==
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
Subject: [RFC PATCH v3 03/11] coco: guest: arm64: Add Realm Host Interface and guest DA helper
Date: Thu, 12 Mar 2026 13:34:34 +0530
Message-ID: <20260312080442.3485633-4-aneesh.kumar@kernel.org>
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

- Add  guest-side `rhi-da` helper that drives the vdev TDI state machine
  via RHI host calls and translates the firmware status codes

This provides the basic RHI plumbing that later DA features rely on.

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
 arch/arm64/include/asm/rhi.h              |  37 +++++
 drivers/virt/coco/arm-cca-guest/Makefile  |   1 +
 drivers/virt/coco/arm-cca-guest/arm-cca.c |   3 +-
 drivers/virt/coco/arm-cca-guest/rhi-da.c  | 158 ++++++++++++++++++++++
 drivers/virt/coco/arm-cca-guest/rhi-da.h  |  14 ++
 5 files changed, 212 insertions(+), 1 deletion(-)
 create mode 100644 drivers/virt/coco/arm-cca-guest/rhi-da.c
 create mode 100644 drivers/virt/coco/arm-cca-guest/rhi-da.h

diff --git a/arch/arm64/include/asm/rhi.h b/arch/arm64/include/asm/rhi.h
index 0895dd92ea1d..029ccd77cfbf 100644
--- a/arch/arm64/include/asm/rhi.h
+++ b/arch/arm64/include/asm/rhi.h
@@ -21,4 +21,41 @@ unsigned long rhi_get_ipa_change_alignment(void);
 #define __RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT BIT(0)
 #define RHI_HOSTCONF_FEATURES		SMC_RHI_CALL(0x004F)
 #define RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT	SMC_RHI_CALL(0x0050)
+
+#define RHI_DA_SUCCESS				0x0
+#define RHI_DA_ERROR_INCOMPLETE			0x1
+#define RHI_DA_ERROR_DATA_NOT_AVAILABLE		0x2
+#define RHI_DA_ERROR_INVALID_VDEV_ID		0x3
+#define RHI_DA_ERROR_INVALID_OBJECT		0x4
+#define RHI_DA_ERROR_INPUT			0x5
+#define RHI_DA_ERROR_DEVICE			0x6
+#define RHI_DA_ERROR_INVALID_OFFSET		0x7
+#define RHI_DA_ERROR_ACCESS_FAILED		0x8
+#define RHI_DA_ERROR_BUSY			0x9
+#define RHI_DA_ABORTED_OPERATION_HAD_COMPLETED	0xA
+
+#define RHI_DA_FEATURE_OBJECT_SIZE		BIT(0)
+#define RHI_DA_FEATURE_OBJECT_READ		BIT(1)
+#define RHI_DA_FEATURE_VDEV_CONTINUE		BIT(2)
+#define RHI_DA_FEATURE_VDEV_GET_MEASUREMENT	BIT(3)
+#define RHI_DA_FEATURE_VDEV_GET_INTF_REPORT	BIT(4)
+#define RHI_DA_FEATURE_VDEV_SET_TDI_STATE	BIT(5)
+
+#define RHI_DA_BASE_FEATURE	(RHI_DA_FEATURE_OBJECT_SIZE |		\
+				 RHI_DA_FEATURE_OBJECT_READ |		\
+				 RHI_DA_FEATURE_VDEV_GET_INTF_REPORT |	\
+				 RHI_DA_FEATURE_VDEV_GET_MEASUREMENT |	\
+				 RHI_DA_FEATURE_VDEV_SET_TDI_STATE)
+#define RHI_DA_FEATURES			SMC_RHI_CALL(0x004B)
+
+#define RHI_DA_VDEV_CONTINUE		SMC_RHI_CALL(0x0051)
+
+enum rhi_tdi_state {
+	RHI_DA_TDI_CONFIG_UNLOCKED,
+	RHI_DA_TDI_CONFIG_LOCKED,
+	RHI_DA_TDI_CONFIG_RUN,
+};
+#define RHI_DA_VDEV_SET_TDI_STATE	SMC_RHI_CALL(0x0054)
+#define RHI_DA_VDEV_ABORT		SMC_RHI_CALL(0x0056)
+
 #endif
diff --git a/drivers/virt/coco/arm-cca-guest/Makefile b/drivers/virt/coco/arm-cca-guest/Makefile
index 75a120e24fda..65c4cc52c154 100644
--- a/drivers/virt/coco/arm-cca-guest/Makefile
+++ b/drivers/virt/coco/arm-cca-guest/Makefile
@@ -2,3 +2,4 @@
 obj-$(CONFIG_ARM_CCA_GUEST) += arm-cca-guest.o
 
 arm-cca-guest-y +=  arm-cca.o
+arm-cca-guest-$(CONFIG_PCI_TSM) +=  rhi-da.o
diff --git a/drivers/virt/coco/arm-cca-guest/arm-cca.c b/drivers/virt/coco/arm-cca-guest/arm-cca.c
index 1d78727702be..07f74f67d22c 100644
--- a/drivers/virt/coco/arm-cca-guest/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-guest/arm-cca.c
@@ -17,6 +17,7 @@
 
 #ifdef CONFIG_PCI_TSM
 #include "rsi-da.h"
+#include "rhi-da.h"
 #endif
 
 /**
@@ -265,7 +266,7 @@ static int cca_devsec_tsm_probe(struct auxiliary_device *adev,
 
 #ifdef CONFIG_PCI_TSM
 	/* Allow tsm report even if tsm_register fails */
-	if (rsi_has_da_feature())
+	if (rsi_has_da_feature() && rhi_has_da_support())
 		cca_devsec_tsm_register(adev);
 #endif
 
diff --git a/drivers/virt/coco/arm-cca-guest/rhi-da.c b/drivers/virt/coco/arm-cca-guest/rhi-da.c
new file mode 100644
index 000000000000..0a04c0ec9320
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-guest/rhi-da.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+
+#include "rsi-da.h"
+#include "rhi-da.h"
+
+/* return value to indicate the need to call rhi_vdev_continue*/
+#define E_INCOMPLETE	1
+static inline int map_rhi_da_error(unsigned long rhi_da_error)
+{
+	switch (rhi_da_error) {
+	case RHI_DA_SUCCESS:
+		return 0;
+	case RHI_DA_ERROR_INCOMPLETE:
+		return E_INCOMPLETE;
+	case RHI_DA_ERROR_BUSY:
+		return -EBUSY;
+	case RHI_DA_ERROR_INPUT:
+	case RHI_DA_ERROR_INVALID_VDEV_ID:
+		return -EINVAL;
+	case RHI_DA_ERROR_ACCESS_FAILED:
+		return -EFAULT;
+	case RHI_DA_ERROR_DEVICE:
+		return -EIO;
+	case RHI_DA_ERROR_INVALID_OBJECT:
+		return -EINVAL;
+	default:
+		return -EIO;
+	}
+}
+
+bool rhi_has_da_support(void)
+{
+	int ret;
+
+	struct rsi_host_call *rhi_call __free(kfree) =
+		kmalloc(sizeof(*rhi_call), GFP_KERNEL);
+	if (!rhi_call)
+		return -ENOMEM;
+
+	rhi_call->imm = 0;
+	rhi_call->gprs[0] = RHI_DA_FEATURES;
+
+	ret = rsi_host_call(rhi_call);
+	if (ret != RSI_SUCCESS || rhi_call->gprs[0] == SMCCC_RET_NOT_SUPPORTED)
+		return false;
+
+	/* For base DA to work we need these to be supported */
+	if ((rhi_call->gprs[0] & RHI_DA_BASE_FEATURE) == RHI_DA_BASE_FEATURE)
+		return true;
+
+	return false;
+}
+
+static inline int rhi_vdev_continue(unsigned long vdev_id, unsigned long cookie)
+{
+	unsigned long ret;
+
+	struct rsi_host_call *rhi_call __free(kfree) =
+		kmalloc(sizeof(*rhi_call), GFP_KERNEL);
+	if (!rhi_call)
+		return -ENOMEM;
+
+	rhi_call->imm = 0;
+	rhi_call->gprs[0] = RHI_DA_VDEV_CONTINUE;
+	rhi_call->gprs[1] = vdev_id;
+	rhi_call->gprs[2] = cookie;
+
+	ret = rsi_host_call(rhi_call);
+	if (ret != RSI_SUCCESS)
+		return -EIO;
+
+	return map_rhi_da_error(rhi_call->gprs[0]);
+}
+
+static int __rhi_vdev_abort(unsigned long vdev_id, unsigned long *da_error)
+{
+	unsigned long ret;
+	struct rsi_host_call *rhi_call __free(kfree) =
+		kmalloc(sizeof(struct rsi_host_call), GFP_KERNEL);
+	if (!rhi_call)
+		return -ENOMEM;
+
+	rhi_call->imm = 0;
+	rhi_call->gprs[0] = RHI_DA_VDEV_ABORT;
+	rhi_call->gprs[1] = vdev_id;
+
+	ret = rsi_host_call(rhi_call);
+	if (ret != RSI_SUCCESS)
+		return -EIO;
+
+	*da_error = rhi_call->gprs[0];
+	return 0;
+}
+
+static bool should_abort_rhi_call_loop(unsigned long vdev_id)
+{
+	int ret;
+
+	cond_resched();
+	if (signal_pending(current)) {
+		unsigned long da_error;
+
+		ret = __rhi_vdev_abort(vdev_id, &da_error);
+		/* consider all kind of error as not aborted */
+		if (!ret && (da_error == RHI_DA_SUCCESS))
+			return true;
+	}
+	return false;
+}
+
+static int __rhi_vdev_set_tdi_state(unsigned long vdev_id,
+				    enum rhi_tdi_state target_state,
+				    unsigned long *cookie)
+{
+	unsigned long ret;
+
+	struct rsi_host_call *rhi_call __free(kfree) =
+		kmalloc(sizeof(struct rsi_host_call), GFP_KERNEL);
+	if (!rhi_call)
+		return -ENOMEM;
+
+	rhi_call->imm = 0;
+	rhi_call->gprs[0] = RHI_DA_VDEV_SET_TDI_STATE;
+	rhi_call->gprs[1] = vdev_id;
+	rhi_call->gprs[2] = target_state;
+
+	ret = rsi_host_call(rhi_call);
+	if (ret != RSI_SUCCESS)
+		return -EIO;
+
+	*cookie = rhi_call->gprs[1];
+	return map_rhi_da_error(rhi_call->gprs[0]);
+}
+
+int rhi_vdev_set_tdi_state(struct pci_dev *pdev, enum rhi_tdi_state target_state)
+{
+	int ret;
+	unsigned long cookie;
+	int vdev_id = rsi_vdev_id(pdev);
+
+	for (;;) {
+		ret = __rhi_vdev_set_tdi_state(vdev_id, target_state, &cookie);
+		if (ret != -EBUSY)
+			break;
+		cond_resched();
+	}
+
+	while (ret == E_INCOMPLETE) {
+		if (should_abort_rhi_call_loop(vdev_id))
+			return -EINTR;
+		ret = rhi_vdev_continue(vdev_id, cookie);
+	}
+
+	return ret;
+}
diff --git a/drivers/virt/coco/arm-cca-guest/rhi-da.h b/drivers/virt/coco/arm-cca-guest/rhi-da.h
new file mode 100644
index 000000000000..43c1cda8738d
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-guest/rhi-da.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+
+#ifndef _VIRT_COCO_RHI_DA_H_
+#define _VIRT_COCO_RHI_DA_H_
+
+#include <asm/rhi.h>
+
+struct pci_dev;
+bool rhi_has_da_support(void);
+int rhi_vdev_set_tdi_state(struct pci_dev *pdev, enum rhi_tdi_state target_state);
+#endif
-- 
2.43.0

