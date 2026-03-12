Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0C12DA775;
	Thu, 12 Mar 2026 08:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302722; cv=none; b=fP+pRdLkYYksZInJJuRQ3UwdjYeIqjz9KB2UzZX7FW2s1jr0vdV0ZiVrjw3ncpbvc528Ns+P+srUKsT5+1WBo5nMzLlA0nB8muN7aKjaqM44jbJbtwH4lGVb/gVg3NtdG4LXtR/DuofcO/v5Ku8vY9H7iAD4Ab3cH4VkAoHdb9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302722; c=relaxed/simple;
	bh=DkO/R9INwpiXbkUZ7Y5YuPYANwhfaZ7AaTmvxjGcFgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiTbMA0Yx+PsGVAbjwlIxGdtryKGauNUpv5idLucdf+rQDOBiDzw54hLCKe6SBXccxUmNXISjHfBEYt6JmpcVW6TLjXWg0/FtCCkzmeiNEynuZaAXA6bxz/cHrhpdfoqa/LDK2HAMBVPvrYtxRnbiUGYQYic3KiXlEmdFBM+fVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j7OS/fOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j7OS/fOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F514C19424;
	Thu, 12 Mar 2026 08:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302722;
	bh=DkO/R9INwpiXbkUZ7Y5YuPYANwhfaZ7AaTmvxjGcFgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7OS/fOD5rRJj4PQUyc6TU63NPlqG8LagC0g8p6Q7VgXvfTSOO0b73Mtb1zr6Tail
	 LpClAXyZevOqBY6TVbSkhmgKu6vkTIWY++E3ANvLX/p62wmMmAlVk+cgl8KNE4DdIe
	 B40bsk56OWtwYCi7Uw6HP/K93IPbmbn22wDUpthopZLY0yIMBUk9HeatzGMiLmHCKl
	 GJqYCMFEfPAxJweFaUfgJoaavlO9sDhb2+R55DCJaXl9b+PEpVSqx2JOWdTm1sIbP3
	 TexFIi8OfO2+UGT5YCSbze2EsUTq5cJsOb7yIMvApiHPj02uGmJVib6Fx6+OZR0hjP
	 5tMtp6+ebLEig==
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
Subject: [RFC PATCH v3 05/11] coco: guest: arm64: Refresh interface-report cache during device lock
Date: Thu, 12 Mar 2026 13:34:36 +0530
Message-ID: <20260312080442.3485633-6-aneesh.kumar@kernel.org>
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

Add support for RHI_DA_VDEV_GET_INTERFACE_REPORT and use it to refresh the
host-side cached interface report when a device is locked.

Implement rhi_update_vdev_interface_report_cache() with busy retry and
cookie-based CONTINUE handling for incomplete operations. Surface the flow
through cca_update_device_object_cache(), and call it from the lock path so
the interface report is fetched before lock succeeds.

On refresh failure, unwind by unlocking the device and returning the error.

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
 arch/arm64/include/asm/rhi.h              |  1 +
 drivers/virt/coco/arm-cca-guest/arm-cca.c |  6 ++++
 drivers/virt/coco/arm-cca-guest/rhi-da.c  | 44 +++++++++++++++++++++++
 drivers/virt/coco/arm-cca-guest/rhi-da.h  |  1 +
 drivers/virt/coco/arm-cca-guest/rsi-da.c  | 13 +++++++
 drivers/virt/coco/arm-cca-guest/rsi-da.h  |  1 +
 6 files changed, 66 insertions(+)

diff --git a/arch/arm64/include/asm/rhi.h b/arch/arm64/include/asm/rhi.h
index 029ccd77cfbf..076aecbce1c5 100644
--- a/arch/arm64/include/asm/rhi.h
+++ b/arch/arm64/include/asm/rhi.h
@@ -49,6 +49,7 @@ unsigned long rhi_get_ipa_change_alignment(void);
 #define RHI_DA_FEATURES			SMC_RHI_CALL(0x004B)
 
 #define RHI_DA_VDEV_CONTINUE		SMC_RHI_CALL(0x0051)
+#define RHI_DA_VDEV_GET_INTERFACE_REPORT SMC_RHI_CALL(0x0053)
 
 enum rhi_tdi_state {
 	RHI_DA_TDI_CONFIG_UNLOCKED,
diff --git a/drivers/virt/coco/arm-cca-guest/arm-cca.c b/drivers/virt/coco/arm-cca-guest/arm-cca.c
index 5e3a66315c70..cb9f389be8b8 100644
--- a/drivers/virt/coco/arm-cca-guest/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-guest/arm-cca.c
@@ -215,6 +215,12 @@ static struct pci_tsm *cca_tsm_lock(struct tsm_dev *tsm_dev, struct pci_dev *pde
 	if (ret)
 		return ERR_PTR(ret);
 
+	ret = cca_update_device_object_cache(pdev, NULL);
+	if (ret) {
+		cca_device_unlock(pdev);
+		return ERR_PTR(ret);
+	}
+
 	return &no_free_ptr(cca_dsc)->pci.base_tsm;
 }
 
diff --git a/drivers/virt/coco/arm-cca-guest/rhi-da.c b/drivers/virt/coco/arm-cca-guest/rhi-da.c
index 0a04c0ec9320..4597fb87044e 100644
--- a/drivers/virt/coco/arm-cca-guest/rhi-da.c
+++ b/drivers/virt/coco/arm-cca-guest/rhi-da.c
@@ -156,3 +156,47 @@ int rhi_vdev_set_tdi_state(struct pci_dev *pdev, enum rhi_tdi_state target_state
 
 	return ret;
 }
+
+static inline int rhi_vdev_get_interface_report(unsigned long vdev_id,
+						unsigned long *cookie)
+{
+	unsigned long ret;
+
+	struct rsi_host_call *rhi_call __free(kfree) =
+		kmalloc(sizeof(struct rsi_host_call), GFP_KERNEL);
+	if (!rhi_call)
+		return -ENOMEM;
+
+	rhi_call->imm = 0;
+	rhi_call->gprs[0] = RHI_DA_VDEV_GET_INTERFACE_REPORT;
+	rhi_call->gprs[1] = vdev_id;
+
+	ret = rsi_host_call(rhi_call);
+	if (ret != RSI_SUCCESS)
+		return -EIO;
+
+	*cookie = rhi_call->gprs[1];
+	return map_rhi_da_error(rhi_call->gprs[0]);
+}
+
+int rhi_update_vdev_interface_report_cache(struct pci_dev *pdev)
+{
+	int ret;
+	unsigned long cookie;
+	int vdev_id = rsi_vdev_id(pdev);
+
+	for (;;) {
+		ret = rhi_vdev_get_interface_report(vdev_id, &cookie);
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
index 43c1cda8738d..8b7faf4d1c8a 100644
--- a/drivers/virt/coco/arm-cca-guest/rhi-da.h
+++ b/drivers/virt/coco/arm-cca-guest/rhi-da.h
@@ -11,4 +11,5 @@
 struct pci_dev;
 bool rhi_has_da_support(void);
 int rhi_vdev_set_tdi_state(struct pci_dev *pdev, enum rhi_tdi_state target_state);
+int rhi_update_vdev_interface_report_cache(struct pci_dev *pdev);
 #endif
diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.c b/drivers/virt/coco/arm-cca-guest/rsi-da.c
index 2c3017933fb0..6c78f0e2f3a1 100644
--- a/drivers/virt/coco/arm-cca-guest/rsi-da.c
+++ b/drivers/virt/coco/arm-cca-guest/rsi-da.c
@@ -32,3 +32,16 @@ int cca_device_unlock(struct pci_dev *pdev)
 	}
 	return 0;
 }
+
+int cca_update_device_object_cache(struct pci_dev *pdev, const u8 *nonce)
+{
+	int ret;
+
+	ret = rhi_update_vdev_interface_report_cache(pdev);
+	if (ret) {
+		pci_err(pdev, "failed to get interface report (%d)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.h b/drivers/virt/coco/arm-cca-guest/rsi-da.h
index 3619a75e160e..9ab3408d6354 100644
--- a/drivers/virt/coco/arm-cca-guest/rsi-da.h
+++ b/drivers/virt/coco/arm-cca-guest/rsi-da.h
@@ -34,4 +34,5 @@ static inline int rsi_vdev_id(struct pci_dev *pdev)
 
 int cca_device_lock(struct pci_dev *pdev);
 int cca_device_unlock(struct pci_dev *pdev);
+int cca_update_device_object_cache(struct pci_dev *pdev, const u8 *nonce);
 #endif
-- 
2.43.0

