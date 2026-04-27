Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79ED0399375;
	Mon, 27 Apr 2026 08:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777278520; cv=none; b=s71rxQaJDFns1uG7ctTtODKcMz6CP7KYZ8/5ik3AkmneWGvVNw3eTjgx2NliXgId8ozZluOFTlNHznXFlmKL96arC1yxgfFG9ft+UPJfZSSGmBgPb/BxgE8rc49sPhNwwnsKZOLF5G/fBO05NxDUaqgrQLTA8Vyiv9NxLrGrcKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777278520; c=relaxed/simple;
	bh=cUKMVmGtfrho+jfrzN1+rtbjtRwloe9DETwZisu/zN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJcmWWkL9r5pTK6x8sqXr4QnN7JQKbrKIUmoOigwrWdRH84Un9ThRGAyEA+Aaba3ayvX9DVQ4aYd3yB77wbLMwYzTnrbs3lOMdO3OHKYbzwyyIYoL6k7Bh+xXgRu89UBn6YyVAlLxl/6EyjH03v578urDZu2YLWVo6jw4zWCes8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T9VByCMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T9VByCMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C9FC2BCB4;
	Mon, 27 Apr 2026 08:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777278520;
	bh=cUKMVmGtfrho+jfrzN1+rtbjtRwloe9DETwZisu/zN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9VByCMFux0mkmCJFxDhBohTSupzlNjtN43Sel1QfTF695K91/uNFXfMxD/jVVsAi
	 yg7TlQErsAaSUXafjEJ8R3eJvbpDpW6Sr9mUvag4/YME0JDTZaM3FNeq70dwYPAy+L
	 nB5fDfUU11lO1axE3q8dTXh2Od32HSsCu6u7aPkXlw2Xp3H9bSAkMBdRxvLnRq4sdt
	 D4D3Na7tthrxskbqRvsUYn6q+cE1oTwLkAEtWmLJUUSkSKdSlwyRt5nF32po0oAz11
	 Qi/caP818ZuAMjwJ9jUdvrcBYRQKoXg6ZGQ2gzQ2ax0IHrzzBTaIFDymBT9v1PIBX6
	 PMoKpmS+Of9EA==
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
Subject: [RFC PATCH v4 05/11] coco: guest: arm64: Refresh interface-report cache during device lock
Date: Mon, 27 Apr 2026 13:57:59 +0530
Message-ID: <20260427082805.931832-6-aneesh.kumar@kernel.org>
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

Add support for RHI_DA_VDEV_GET_INTERFACE_REPORT and use it to refresh the
host-side cached interface report when a device is locked.

Implement rhi_update_vdev_interface_report_cache() with busy retry and
cookie-based CONTINUE handling for incomplete operations. Surface the flow
through cca_update_device_object_cache(), and call it from the lock path so
the interface report is fetched before lock succeeds.

On refresh failure, unwind by unlocking the device and returning the error.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rhi.h              |  2 ++
 drivers/virt/coco/arm-cca-guest/arm-cca.c |  6 ++++
 drivers/virt/coco/arm-cca-guest/rhi-da.c  | 44 +++++++++++++++++++++++
 drivers/virt/coco/arm-cca-guest/rhi-da.h  |  1 +
 drivers/virt/coco/arm-cca-guest/rsi-da.c  | 13 +++++++
 drivers/virt/coco/arm-cca-guest/rsi-da.h  |  1 +
 6 files changed, 67 insertions(+)

diff --git a/arch/arm64/include/asm/rhi.h b/arch/arm64/include/asm/rhi.h
index 88de2d9b34d1..15946fe64484 100644
--- a/arch/arm64/include/asm/rhi.h
+++ b/arch/arm64/include/asm/rhi.h
@@ -50,6 +50,8 @@ unsigned long rhi_get_ipa_change_alignment(void);
 
 #define RHI_DA_VDEV_CONTINUE		SMC_RHI_CALL(0x0051)
 
+#define RHI_DA_VDEV_GET_INTERFACE_REPORT SMC_RHI_CALL(0x0053)
+
 enum rhi_tdi_state {
 	RHI_DA_TDI_CONFIG_UNLOCKED,
 	RHI_DA_TDI_CONFIG_LOCKED,
diff --git a/drivers/virt/coco/arm-cca-guest/arm-cca.c b/drivers/virt/coco/arm-cca-guest/arm-cca.c
index d4880ca59fc5..411cbbaa5d26 100644
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
index 5b48c8d6ebe3..5078136a4cc6 100644
--- a/drivers/virt/coco/arm-cca-guest/rhi-da.c
+++ b/drivers/virt/coco/arm-cca-guest/rhi-da.c
@@ -161,3 +161,47 @@ int rhi_vdev_set_tdi_state(struct pci_dev *pdev, enum rhi_tdi_state target_state
 
 	return ret;
 }
+
+static inline int rhi_vdev_get_interface_report(unsigned long vdev_id,
+		unsigned long *cookie)
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
+	while (ret == RHI_DA_INCOMPLETE) {
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
index 06fcea95d888..dda8026a1c3f 100644
--- a/drivers/virt/coco/arm-cca-guest/rsi-da.h
+++ b/drivers/virt/coco/arm-cca-guest/rsi-da.h
@@ -34,5 +34,6 @@ static inline int rsi_vdev_id(struct pci_dev *pdev)
 
 int cca_device_lock(struct pci_dev *pdev);
 int cca_device_unlock(struct pci_dev *pdev);
+int cca_update_device_object_cache(struct pci_dev *pdev, const u8 *nonce);
 
 #endif
-- 
2.43.0

