Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE342DA775;
	Thu, 12 Mar 2026 08:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302728; cv=none; b=dGftZ7BO/NubfjYyHqOiQcjsrvfjDdROA0/TnmNdb8bD5pqe4yi5L/t/T0wBijTPGMs/S5AOhb87sAHeN41+hD0+QntHw7SBCPsOpVpx9sAlnJpBNiFrKejiVlXPW0iYDGY1KaF+DUEIp0pmMoELAk4zjfABm43Xzcz09Qbu0kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302728; c=relaxed/simple;
	bh=XIr4gNW1jlBalBO6JtSnGoH5HWlLWagg++XO5DPfrLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhdP0G2bIOMwIwqhOrTZ49q/LXi5XHOunCvD2cXmuXTf5/Li9HZCu0f4Kf1T+qAZ/+xOjCyE5IYQsy9OuLWOW2ob5SKbFqU8T+muF7mdeQ9V4dFBJqPj3gf16G7W9I03RSezg0NfPw+aGKJxgWEqNjQPiYXBee+abGNwqRCGQcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bK6wJPIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bK6wJPIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1DFC116C6;
	Thu, 12 Mar 2026 08:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302728;
	bh=XIr4gNW1jlBalBO6JtSnGoH5HWlLWagg++XO5DPfrLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bK6wJPIN1d9E1RmWTBAFxDV+vdTWU2nAP854sgx/3f2p5deDV9XzRrt1pxQ1I4RRy
	 +5yicdVNGiAASe1oky74ige8F69o1B7dsrPIXkylVnQCdggGsEhZVYnSdb/tzoNLKX
	 8wSF3MLZRcs7k9OynmIfjCphND+FycO7GmlFPTm/kAr1Bw8Ir+lLiS51J1VMhM1DnF
	 ktdPm9PCnuCa/AESyPX7OHu+QHD1N+Yrm8LgcCyF/nsdxh1Hmg8teGE45YHmgNtAVq
	 LNnA9HytC0PgLxkAqUvebXzN/H00Jn3jc4qyjeVH+/1qrdBlk2Wy+oLsMYSmsZv6JC
	 BHTjqTF61/0fA==
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
Subject: [RFC PATCH v3 06/11] coco: guest: arm64: Add measurement refresh via RHI_DA_VDEV_GET_MEASUREMENTS
Date: Thu, 12 Mar 2026 13:34:37 +0530
Message-ID: <20260312080442.3485633-7-aneesh.kumar@kernel.org>
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

Add guest support to request fresh device measurements using
RHI_DA_VDEV_GET_MEASUREMENTS.

Define measurement request parameters (flags + nonce), request RAW
measurements, and implement cookie-based continuation for incomplete DA
operations. Extend cca_update_device_object_cache() to refresh both
interface report and measurements.

Because RHI buffers are shared with the host, add shared-page allocation
helpers that convert pages to decrypted/shared memory before use and restore
them to encrypted/private state on free.

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
 arch/arm64/include/asm/rhi.h              | 13 ++++
 drivers/virt/coco/arm-cca-guest/arm-cca.c |  1 +
 drivers/virt/coco/arm-cca-guest/rhi-da.c  | 79 +++++++++++++++++++++++
 drivers/virt/coco/arm-cca-guest/rhi-da.h  |  1 +
 drivers/virt/coco/arm-cca-guest/rsi-da.c  | 42 +++++++++++-
 drivers/virt/coco/arm-cca-guest/rsi-da.h  |  2 +
 6 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/rhi.h b/arch/arm64/include/asm/rhi.h
index 076aecbce1c5..d4759f410a17 100644
--- a/arch/arm64/include/asm/rhi.h
+++ b/arch/arm64/include/asm/rhi.h
@@ -49,6 +49,19 @@ unsigned long rhi_get_ipa_change_alignment(void);
 #define RHI_DA_FEATURES			SMC_RHI_CALL(0x004B)
 
 #define RHI_DA_VDEV_CONTINUE		SMC_RHI_CALL(0x0051)
+#define RHI_VDEV_MEASURE_HASH	0x0
+#define RHI_VDEV_MEASURE_RAW	0x1
+struct rhi_vdev_measurement_params {
+	union {
+		u64 flags;
+		u8 padding0[256];
+	};
+	union {
+		u8 nonce[32];
+		u8 padding1[256];
+	};
+};
+#define RHI_DA_VDEV_GET_MEASUREMENTS	SMC_RHI_CALL(0x0052)
 #define RHI_DA_VDEV_GET_INTERFACE_REPORT SMC_RHI_CALL(0x0053)
 
 enum rhi_tdi_state {
diff --git a/drivers/virt/coco/arm-cca-guest/arm-cca.c b/drivers/virt/coco/arm-cca-guest/arm-cca.c
index cb9f389be8b8..435645e97ab4 100644
--- a/drivers/virt/coco/arm-cca-guest/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-guest/arm-cca.c
@@ -215,6 +215,7 @@ static struct pci_tsm *cca_tsm_lock(struct tsm_dev *tsm_dev, struct pci_dev *pde
 	if (ret)
 		return ERR_PTR(ret);
 
+	/* collect evidence without nonce */
 	ret = cca_update_device_object_cache(pdev, NULL);
 	if (ret) {
 		cca_device_unlock(pdev);
diff --git a/drivers/virt/coco/arm-cca-guest/rhi-da.c b/drivers/virt/coco/arm-cca-guest/rhi-da.c
index 4597fb87044e..5130d4911f3a 100644
--- a/drivers/virt/coco/arm-cca-guest/rhi-da.c
+++ b/drivers/virt/coco/arm-cca-guest/rhi-da.c
@@ -200,3 +200,82 @@ int rhi_update_vdev_interface_report_cache(struct pci_dev *pdev)
 
 	return ret;
 }
+
+static inline int rhi_vdev_get_measurements(unsigned long vdev_id,
+					    phys_addr_t vdev_meas_phys,
+					    unsigned long *cookie)
+{
+	unsigned long ret;
+
+	struct rsi_host_call *rhi_call __free(kfree) =
+		kmalloc(sizeof(*rhi_call), GFP_KERNEL);
+	if (!rhi_call)
+		return -ENOMEM;
+
+	rhi_call->imm = 0;
+	rhi_call->gprs[0] = RHI_DA_VDEV_GET_MEASUREMENTS;
+	rhi_call->gprs[1] = vdev_id;
+	rhi_call->gprs[2] = vdev_meas_phys;
+
+	ret = rsi_host_call(rhi_call);
+	if (ret != RSI_SUCCESS)
+		return -EIO;
+
+	*cookie = rhi_call->gprs[1];
+	return map_rhi_da_error(rhi_call->gprs[0]);
+}
+
+static inline struct rhi_vdev_measurement_params *alloc_vdev_meas_params(void)
+{
+	struct page *pages;
+
+	pages = alloc_shared_pages(NUMA_NO_NODE, GFP_KERNEL, sizeof(struct rhi_vdev_measurement_params));
+	if (!pages)
+		return NULL;
+	return page_address(pages);
+}
+
+static inline void vdev_meas_params_free(struct rhi_vdev_measurement_params *params)
+{
+	struct page *pages = virt_to_page(params);
+
+	free_shared_pages(pages, sizeof(struct rhi_vdev_measurement_params));
+}
+
+DEFINE_FREE(vdev_meas_params_free, struct rhi_vdev_measurement_params *, if (_T) vdev_meas_params_free(_T))
+int rhi_update_vdev_measurements_cache(struct pci_dev *pdev, const u8 *nonce)
+{
+	int ret;
+	unsigned long cookie;
+	int vdev_id = rsi_vdev_id(pdev);
+	phys_addr_t vdev_meas_phys;
+
+	struct rhi_vdev_measurement_params *dev_meas __free(vdev_meas_params_free) =
+		alloc_vdev_meas_params();
+	if (!dev_meas)
+		return -ENOMEM;
+
+	vdev_meas_phys = virt_to_phys(dev_meas);
+	/* request for raw bitstream */
+	dev_meas->flags = RHI_VDEV_MEASURE_RAW;
+	if (nonce)
+		memcpy(dev_meas->nonce, nonce, 32);
+
+	for (;;) {
+		ret = rhi_vdev_get_measurements(vdev_id, vdev_meas_phys, &cookie);
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
+	if (ret)
+		pci_err(pdev, "failed to get device measurement (%d)\n", ret);
+	return ret;
+}
+
diff --git a/drivers/virt/coco/arm-cca-guest/rhi-da.h b/drivers/virt/coco/arm-cca-guest/rhi-da.h
index 8b7faf4d1c8a..d32ccc48c0d0 100644
--- a/drivers/virt/coco/arm-cca-guest/rhi-da.h
+++ b/drivers/virt/coco/arm-cca-guest/rhi-da.h
@@ -12,4 +12,5 @@ struct pci_dev;
 bool rhi_has_da_support(void);
 int rhi_vdev_set_tdi_state(struct pci_dev *pdev, enum rhi_tdi_state target_state);
 int rhi_update_vdev_interface_report_cache(struct pci_dev *pdev);
+int rhi_update_vdev_measurements_cache(struct pci_dev *pdev, const u8 *nonce);
 #endif
diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.c b/drivers/virt/coco/arm-cca-guest/rsi-da.c
index 6c78f0e2f3a1..9f9e54174813 100644
--- a/drivers/virt/coco/arm-cca-guest/rsi-da.c
+++ b/drivers/virt/coco/arm-cca-guest/rsi-da.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/pci.h>
+#include <linux/mem_encrypt.h>
 #include <asm/rsi_cmds.h>
 
 #include "rsi-da.h"
@@ -33,6 +34,45 @@ int cca_device_unlock(struct pci_dev *pdev)
 	return 0;
 }
 
+struct page *alloc_shared_pages(int nid, gfp_t gfp_mask, unsigned long min_size)
+{
+	int ret;
+	struct page *page;
+	/* We should normalize the size based on hypervisor page size */
+	int page_order = get_order(min_size);
+
+	page = alloc_pages_node(nid, gfp_mask | __GFP_ZERO, page_order);
+	if (!page)
+		return NULL;
+
+	ret = set_memory_decrypted((unsigned long)page_address(page),
+				   1 << page_order);
+	/*
+	 * If set_memory_decrypted() fails then we don't know what state the
+	 * page is in, so we can't free it. Instead we leak it.
+	 * set_memory_decrypted() will already have WARNed.
+	 */
+	if (ret)
+		return NULL;
+
+	return page;
+}
+
+int free_shared_pages(struct page *page, unsigned long size)
+{
+	int ret;
+	/* We should normalize the size based on hypervisor page size */
+	int page_order = get_order(size);
+
+	ret = set_memory_encrypted((unsigned long)page_address(page), 1 << page_order);
+	/* If we fail to mark it encrypted don't free it back */
+	if (ret)
+		return ret;
+
+	__free_pages(page, page_order);
+	return 0;
+}
+
 int cca_update_device_object_cache(struct pci_dev *pdev, const u8 *nonce)
 {
 	int ret;
@@ -43,5 +83,5 @@ int cca_update_device_object_cache(struct pci_dev *pdev, const u8 *nonce)
 		return ret;
 	}
 
-	return 0;
+	return rhi_update_vdev_measurements_cache(pdev, nonce);
 }
diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.h b/drivers/virt/coco/arm-cca-guest/rsi-da.h
index 9ab3408d6354..2e3440f7c849 100644
--- a/drivers/virt/coco/arm-cca-guest/rsi-da.h
+++ b/drivers/virt/coco/arm-cca-guest/rsi-da.h
@@ -35,4 +35,6 @@ static inline int rsi_vdev_id(struct pci_dev *pdev)
 int cca_device_lock(struct pci_dev *pdev);
 int cca_device_unlock(struct pci_dev *pdev);
 int cca_update_device_object_cache(struct pci_dev *pdev, const u8 *nonce);
+struct page *alloc_shared_pages(int nid, gfp_t gfp_mask, unsigned long min_size);
+int free_shared_pages(struct page *page, unsigned long min_size);
 #endif
-- 
2.43.0

