Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20BF3976A7;
	Mon, 27 Apr 2026 08:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777278531; cv=none; b=GFT9pVstdNi+FFo6LVCoIt+1jR77IR1Tv5LgDMptVydCpc1vrKybivialkjsKx00O4i+coBM52ckU1/qZgMz0JAjdTQ7q6sgFWTK7FZiKT4RbZ6VY89U2cXKll58ziDumhQp/qpIo6VfRX6NchY1JJQ40MIwa4lboKP/H4LBQRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777278531; c=relaxed/simple;
	bh=jNp9qsUFxSqnqXy8TKaLW9c3z208YtDH/OH/IkVAaus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzb5QWpr5H5zZ3Q6xCj4JXVgiDRKDfYDBhkxn3f2KvOpthwLQnQzHWS71QHl0A9FVtU0oYm3XGNm2Q5w4L0CG6oE7bkTQ7bU3Zd0byB+ayjRnRkZYYy8Q1VbbBUem4x0S+gx4WYllZvDbjfBQ6wKWWQmxTGKjs4PDA6VosGtVoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fFWMOqPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fFWMOqPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0599FC2BCB8;
	Mon, 27 Apr 2026 08:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777278530;
	bh=jNp9qsUFxSqnqXy8TKaLW9c3z208YtDH/OH/IkVAaus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFWMOqPwJi48SZarPWAHd4BJJEYN3M48EvZo/ZcW1uVch3BPU4TJTe7P4aXrMXsEa
	 B/GLlZ+TFaS6lQl4SjDQazt2Zj2yYaYDZccxBx7onPzj+9Bsnn3XB4o0RTbGNfKBPA
	 U53qyPu67sGXgYC9yzhY63cIAQcDgZRlwKXxbr+oRFQNsGfjjUQiXM0Dv9E736u8g+
	 3O0fYf98eVcVaHruaj1jQxbXNzA5N5vHymnwJ5urDXOBGbKBJReAp71jgUh0LrO3a8
	 xE+2Py6eLkY0t9J51OcqM53yGqnPAG0GeH5hRbvbfig0XdGU55wJtySce8KRQbwl2b
	 Kkp9oaP3k5q+w==
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
Subject: [RFC PATCH v4 07/11] coco: guest: arm64: Add guest APIs to read host-cached DA objects
Date: Mon, 27 Apr 2026 13:58:01 +0530
Message-ID: <20260427082805.931832-8-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427082805.931832-1-aneesh.kumar@kernel.org>
References: <20260427082805.931832-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce guest-side helpers to read host-cached DA objects
(certificate, VCA, interface report, and measurements).

Add RHI_DA_OBJECT_SIZE and RHI_DA_OBJECT_READ definitions, then implement
rhi_read_cached_object() that:
- queries object size from host
- validates size against MAX_CACHE_OBJ_SIZE
- allocates a shared buffer
- issues OBJECT_READ into shared memory
- copies data into private memory and frees shared pages

Export the helper for later evidence-collection and verification code.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rhi.h             |  8 +++
 drivers/virt/coco/arm-cca-guest/rhi-da.c | 71 ++++++++++++++++++++++++
 drivers/virt/coco/arm-cca-guest/rhi-da.h |  1 +
 drivers/virt/coco/arm-cca-guest/rsi-da.h |  2 +
 4 files changed, 82 insertions(+)

diff --git a/arch/arm64/include/asm/rhi.h b/arch/arm64/include/asm/rhi.h
index 2b56a7760904..dc7a57370945 100644
--- a/arch/arm64/include/asm/rhi.h
+++ b/arch/arm64/include/asm/rhi.h
@@ -48,6 +48,14 @@ unsigned long rhi_get_ipa_change_alignment(void);
 				 RHI_DA_FEATURE_VDEV_SET_TDI_STATE)
 #define RHI_DA_FEATURES			SMC_RHI_CALL(0x004B)
 
+#define RHI_DA_OBJECT_VCA			0x0
+#define RHI_DA_OBJECT_CERTIFICATE		0x1
+#define RHI_DA_OBJECT_MEASUREMENT		0x2
+#define RHI_DA_OBJECT_INTERFACE_REPORT		0x3
+#define RHI_DA_OBJECT_EXTENSION_EVIDENCE	0x4
+#define RHI_DA_OBJECT_SIZE		SMC_RHI_CALL(0x004C)
+#define RHI_DA_OBJECT_READ		SMC_RHI_CALL(0x004D)
+
 #define RHI_DA_VDEV_CONTINUE		SMC_RHI_CALL(0x0051)
 
 #define RHI_VDEV_MEASURE_HASH	0x0
diff --git a/drivers/virt/coco/arm-cca-guest/rhi-da.c b/drivers/virt/coco/arm-cca-guest/rhi-da.c
index d0f5ae320f83..73c599802a93 100644
--- a/drivers/virt/coco/arm-cca-guest/rhi-da.c
+++ b/drivers/virt/coco/arm-cca-guest/rhi-da.c
@@ -3,6 +3,8 @@
  * Copyright (C) 2026 ARM Ltd.
  */
 
+#include <linux/string.h>
+
 #include "rsi-da.h"
 #include "rhi-da.h"
 
@@ -283,3 +285,72 @@ int rhi_update_vdev_measurements_cache(struct pci_dev *pdev, const u8 *nonce)
 		pci_err(pdev, "failed to get device measurement (%d)\n", ret);
 	return ret;
 }
+
+int rhi_read_cached_object(int vdev_id, int da_object_type, void **object, int *object_size)
+{
+	int ret;
+	int data_size;
+	void *data_buf_shared;
+	struct page *shared_pages;
+
+	*object_size = 0;
+	*object = NULL;
+
+	struct rsi_host_call *rhicall __free(kfree) =
+		kmalloc(sizeof(struct rsi_host_call), GFP_KERNEL);
+	if (!rhicall)
+		return -ENOMEM;
+
+	rhicall->imm = 0;
+	rhicall->gprs[0] = RHI_DA_OBJECT_SIZE;
+	rhicall->gprs[1] = vdev_id;
+	rhicall->gprs[2] = da_object_type;
+
+	ret = rsi_host_call(rhicall);
+	if (ret != RSI_SUCCESS)
+		return -EIO;
+
+	if (rhicall->gprs[0] != RHI_DA_SUCCESS)
+		return -EIO;
+
+	/* validate against the max cache object size used on host. */
+	data_size = rhicall->gprs[1];
+	if (data_size > MAX_CACHE_OBJ_SIZE || data_size == 0)
+		return -EIO;
+
+	shared_pages = alloc_shared_pages(NUMA_NO_NODE, GFP_KERNEL, data_size);
+	if (!shared_pages)
+		return -ENOMEM;
+
+	data_buf_shared = page_address(shared_pages);
+
+	rhicall->imm = 0;
+	rhicall->gprs[0] = RHI_DA_OBJECT_READ;
+	rhicall->gprs[1] = vdev_id;
+	rhicall->gprs[2] = da_object_type;
+	rhicall->gprs[3] = virt_to_phys(data_buf_shared);
+	rhicall->gprs[4] = data_size;
+	rhicall->gprs[5] = 0; /* offset to read from */
+	ret = rsi_host_call(rhicall);
+	if (ret != RSI_SUCCESS || rhicall->gprs[0] != RHI_DA_SUCCESS) {
+		free_shared_pages(shared_pages, data_size);
+		return -EIO;
+	}
+
+	if (data_size != rhicall->gprs[1]) {
+		/* Short read */
+		free_shared_pages(shared_pages, data_size);
+		return -EIO;
+	}
+
+	void *data_buf_private = kvmemdup(data_buf_shared,
+					  data_size, GFP_KERNEL);
+	/* free the shared pages irrespective of error condition */
+	free_shared_pages(shared_pages, data_size);
+	if (!data_buf_private)
+		return -ENOMEM;
+
+	*object = data_buf_private;
+	*object_size = data_size;
+	return 0;
+}
diff --git a/drivers/virt/coco/arm-cca-guest/rhi-da.h b/drivers/virt/coco/arm-cca-guest/rhi-da.h
index d32ccc48c0d0..f7655d7ecf18 100644
--- a/drivers/virt/coco/arm-cca-guest/rhi-da.h
+++ b/drivers/virt/coco/arm-cca-guest/rhi-da.h
@@ -13,4 +13,5 @@ bool rhi_has_da_support(void);
 int rhi_vdev_set_tdi_state(struct pci_dev *pdev, enum rhi_tdi_state target_state);
 int rhi_update_vdev_interface_report_cache(struct pci_dev *pdev);
 int rhi_update_vdev_measurements_cache(struct pci_dev *pdev, const u8 *nonce);
+int rhi_read_cached_object(int vdev_id, int da_object_type, void **object, int *object_size);
 #endif
diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.h b/drivers/virt/coco/arm-cca-guest/rsi-da.h
index 297cb800edc0..88067d2230ab 100644
--- a/drivers/virt/coco/arm-cca-guest/rsi-da.h
+++ b/drivers/virt/coco/arm-cca-guest/rsi-da.h
@@ -10,6 +10,8 @@
 #include <linux/pci-tsm.h>
 #include <asm/rsi_smc.h>
 
+#define MAX_CACHE_OBJ_SIZE	SZ_16M
+
 struct cca_guest_dsc {
 	struct pci_tsm_devsec pci;
 };
-- 
2.43.0

