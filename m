Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183DC2D8DDB;
	Thu, 12 Mar 2026 08:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302761; cv=none; b=q+mgb185zCtjfMzWenQFMRgnhQRupxiJ9rKG2V0xLNRzaff6MIrOhE7c8FnPYjcGccdCcL+BGa8pJJ29SGwBAyIaaxUSheagZAw26Bj/4Rp/cD3OfKrubDHj3xVQ+3dJz52uobFec+dt5Z2txUVYCGK4h61sXx2Eqx/WMW9eUN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302761; c=relaxed/simple;
	bh=GrsKvOZ6VufbBgYbhrd6xHH3pkcwgPsCkJfdzsv8h80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S600ZwuXJLjzou02K/S4jN7dZa7lugcII3NwBYztdBL547rqcwDomVXgKipp4lJ5mLDSl/swi/8Pj05ZD5tnae2sH6AHkX5/vvNUUxVNBD14VH4o/+xdOqlaBfSP1n4eY8P35dyPItJFAAzuiHZXzMVQnPhHSL4GgTOpoMeeleE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L+xYzgEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+xYzgEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F92C4CEF7;
	Thu, 12 Mar 2026 08:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302760;
	bh=GrsKvOZ6VufbBgYbhrd6xHH3pkcwgPsCkJfdzsv8h80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+xYzgEzmUqSoms73n0IBLxp2/AjrTR5NE6GxICk3JjchloFho4SdZODXCqLkLDt2
	 V/8ra8nSHv2A7KbfblknEAe8f0/tWRV9PjcGfLU6FZwZ7RfI+1M59Qvszk7qh8bv5+
	 RsvqPRmp+AWYmCe2BM/8G2vNbZghAF5QPRFKM2TCW/MaY4AbB6KcfDO3/GUQIcRXoV
	 7HzAmy+zsSBWAH3cBIOQVRfxGwBU9b3qCUt7SU944LyB1pVM7aQySy4uKxq+tr6z3k
	 QUoTN/QeLHDxPK+w855b770kNjB8P0x1uJxsSx7rrn74HwIzTn/UwgF4GIWH8HgKTH
	 rWL49xyQTaHww==
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
	Steven Price <steven.price@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: [RFC PATCH v3 11/11] coco: guest: arm64: Enable vdev DMA after attestation
Date: Thu, 12 Mar 2026 13:34:42 +0530
Message-ID: <20260312080442.3485633-12-aneesh.kumar@kernel.org>
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

- define SMC_RSI_VDEV_DMA_ENABLE and add wrapper in rsi_cmds.h
- invoke the new helper from the guest accept path once the device
  passes attestation, rolling back to TDI_LOCKED on failure

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
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rsi_cmds.h        | 16 ++++++++++++++++
 arch/arm64/include/asm/rsi_smc.h         |  2 ++
 drivers/virt/coco/arm-cca-guest/rsi-da.c | 14 ++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
index f72d8e0cd422..1e0d1cd8841a 100644
--- a/arch/arm64/include/asm/rsi_cmds.h
+++ b/arch/arm64/include/asm/rsi_cmds.h
@@ -226,4 +226,20 @@ static inline unsigned long rsi_vdev_get_info(unsigned long vdev_id,
 	return res.a0;
 }
 
+static inline unsigned long __rsi_vdev_dma_enable(unsigned long vdev_id,
+						  unsigned long flags,
+						  unsigned long non_ats_plane,
+						  unsigned long lock_nonce,
+						  unsigned long meas_nonce,
+						  unsigned long report_nonce)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RSI_VDEV_DMA_ENABLE, vdev_id, flags,
+			     non_ats_plane, lock_nonce,
+			     meas_nonce, report_nonce, &res);
+
+	return res.a0;
+}
+
 #endif /* __ASM_RSI_CMDS_H */
diff --git a/arch/arm64/include/asm/rsi_smc.h b/arch/arm64/include/asm/rsi_smc.h
index 5f1837282237..d2ea3656ea8f 100644
--- a/arch/arm64/include/asm/rsi_smc.h
+++ b/arch/arm64/include/asm/rsi_smc.h
@@ -186,6 +186,8 @@ struct realm_config {
  */
 #define SMC_RSI_IPA_STATE_GET			SMC_RSI_FID(0x198)
 
+#define SMC_RSI_VDEV_DMA_ENABLE			SMC_RSI_FID(0x19C)
+
 struct rsi_vdevice_info {
 	union {
 		struct {
diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.c b/drivers/virt/coco/arm-cca-guest/rsi-da.c
index 4030fa213ff4..74594066f46c 100644
--- a/drivers/virt/coco/arm-cca-guest/rsi-da.c
+++ b/drivers/virt/coco/arm-cca-guest/rsi-da.c
@@ -231,9 +231,17 @@ int cca_verify_digests(u64 hash_algo,
 	return 0;
 }
 
+static inline int rsi_vdev_enable_dma(int vdev_id, struct dsm_device_info *dev_info)
+{
+	/* No ATS support */
+	return __rsi_vdev_dma_enable(vdev_id, 0, 0, dev_info->lock_nonce,
+				     dev_info->meas_nonce, dev_info->report_nonce);
+}
+
 int cca_device_accept(struct pci_dev *pdev, unsigned long lock_nonce)
 {
 	int ret;
+	int vdev_id = rsi_vdev_id(pdev);
 	struct cca_guest_dsc *dsc = to_cca_guest_dsc(pdev);
 
 	if (lock_nonce != dsc->dev_info.lock_nonce) {
@@ -270,6 +278,12 @@ int cca_device_accept(struct pci_dev *pdev, unsigned long lock_nonce)
 		return ret;
 	}
 
+	if (rsi_vdev_enable_dma(vdev_id, &dsc->dev_info)) {
+		rhi_vdev_set_tdi_state(pdev, RHI_DA_TDI_CONFIG_LOCKED);
+		pci_err(pdev, "failed to enable DMA from the device\n");
+		return -EIO;
+	}
+
 	dsc->pci.mmio = no_free_ptr(tsm_mmio);
 	return 0;
 }
-- 
2.43.0

