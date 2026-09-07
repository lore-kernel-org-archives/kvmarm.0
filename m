Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828FD4570CD;
	Mon,  7 Sep 2026 10:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788775205; cv=none; b=hWc4NbQpAEm69rq/gI6nWNIig2C2rfcf0wY2+y6Qf50uoXSEGG/t5VEfTGDnnu4DJ3LBa3DKkTkfCJsCMsUNve25sVE9alhApNZfiSKmMMYCc6q4rW2XbG5Cp7JebXiTZpsghFbX3LVIXyzdlc2dgxlnlsAIbK1VF+obYX7sFQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788775205; c=relaxed/simple;
	bh=tuAFupYWCi/JFuVDRYTyDnJkPl9ERItmrGX6MZpEGXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCNgIl7Xc2Q0A+Xf65Z/lPBOtNf48J33zo49DjsDiIjfvNTJbvke58sZfOMzoLuO9yD/7097dq13/aEiFSbidb08dBuGLXROeZjeaynhg9ZletoAVMPiUo99RnkST4cb5h6kR+B87vO55tXeiKQmJatpoEDCGzHoLlQQNhWjbFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=uq06EAQi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="uq06EAQi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E6871477;
	Mon,  7 Sep 2026 02:59:58 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1CAD53F7B4;
	Mon,  7 Sep 2026 02:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788775201; bh=tuAFupYWCi/JFuVDRYTyDnJkPl9ERItmrGX6MZpEGXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uq06EAQiF5fnTU8E3hvtIxvSjbO9yhQCRYFdVawFbi5hA1Jgeu7tJXoIep/XnfYxU
	 86QT98EqSi1jGxiJZl9d31WRnBKLBUwJwHfROEUT6CrT1+OqJ4tvn8HZ1Ja6uXs7Ov
	 IIklcZecR+Ilb1GYVBVDzyq544cfi5oR5HDfiwzc=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v17 1/7] firmware: arm_rmm: Add SMC definitions for calling the RMM
Date: Mon,  7 Sep 2026 10:59:35 +0100
Message-ID: <20260907095942.1140734-2-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907095942.1140734-1-suzuki.poulose@arm.com>
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Steven Price <steven.price@arm.com>

The RMM (Realm Management Monitor) provides functionality that can be
accessed by SMC calls from the host.

The SMC definitions are based on DEN0137[1] version 2.0-bet3

[1] https://developer.arm.com/documentation/den0137/2-0bet3/

Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 Changes since v16:
  * Updated definitions to RMM specification v2.0-bet3.
 Changes since v15:
  * Dropped unused symbols REC_MAX_GIC_NUM_LRS and RMI_PERMITTED_GICV3_HCR_BITS.
  * Output is now (partially) generated from the spec source.
 Changes since v14:
  * Updated to RMM spec v2.0-bet2 but without the changes to move
    metadata out of individual address range descriptors as this is
    expected to be reverted in a future spec release.
 Changes since v13:
  * Updated to RMM spec v2.0-bet1
 Changes since v12:
  * Updated to RMM spec v2.0-bet0
 Changes since v9:
  * Corrected size of 'ripas_value' in struct rec_exit. The spec states
    this is an 8-bit type with padding afterwards (rather than a u64).
 Changes since v8:
  * Added RMI_PERMITTED_GICV3_HCR_BITS to define which bits the RMM
    permits to be modified.
 Changes since v6:
  * Renamed REC_ENTER_xxx defines to include 'FLAG' to make it obvious
    these are flag values.
 Changes since v5:
  * Sorted the SMC #defines by value.
  * Renamed SMI_RxI_CALL to SMI_RMI_CALL since the macro is only used for
    RMI calls.
  * Renamed REC_GIC_NUM_LRS to REC_MAX_GIC_NUM_LRS since the actual
    number of available list registers could be lower.
  * Provided a define for the reserved fields of FeatureRegister0.
  * Fix inconsistent names for padding fields.
 Changes since v4:
  * Update to point to final released RMM spec.
  * Minor rearrangements.
 Changes since v3:
  * Update to match RMM spec v1.0-rel0-rc1.
 Changes since v2:
  * Fix specification link.
  * Rename rec_entry->rec_enter to match spec.
  * Fix size of pmu_ovf_status to match spec.
---
 include/linux/arm-smccc-rmi.h | 494 ++++++++++++++++++++++++++++++++++
 1 file changed, 494 insertions(+)
 create mode 100644 include/linux/arm-smccc-rmi.h

diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc-rmi.h
new file mode 100644
index 0000000000000..3eb88caf40964
--- /dev/null
+++ b/include/linux/arm-smccc-rmi.h
@@ -0,0 +1,494 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2023-2026 ARM Ltd.
+ *
+ * The values and structures in this file are from the Realm Management Monitor
+ * specification (DEN0137) version 2.0-bet3:
+ * https://developer.arm.com/documentation/den0137/2-0bet3/
+ */
+
+#ifndef __LINUX_ARM_SMCCC_RMI_H_
+#define __LINUX_ARM_SMCCC_RMI_H_
+
+#include <linux/arm-smccc.h>
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+#include <linux/build_bug.h>
+#include <linux/sizes.h>
+
+#include <asm/page.h>
+
+#define SMC_RMI_CALL(func)				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+			   ARM_SMCCC_SMC_64,		\
+			   ARM_SMCCC_OWNER_STANDARD,	\
+			   (func))
+
+#define SMC_RMI_VERSION				SMC_RMI_CALL(0x0150)
+
+#define SMC_RMI_RTT_DATA_MAP_INIT		SMC_RMI_CALL(0x0153)
+
+#define SMC_RMI_REALM_ACTIVATE			SMC_RMI_CALL(0x0157)
+#define SMC_RMI_REALM_CREATE			SMC_RMI_CALL(0x0158)
+#define SMC_RMI_REALM_DESTROY			SMC_RMI_CALL(0x0159)
+#define SMC_RMI_REC_CREATE			SMC_RMI_CALL(0x015a)
+#define SMC_RMI_REC_DESTROY			SMC_RMI_CALL(0x015b)
+#define SMC_RMI_REC_ENTER			SMC_RMI_CALL(0x015c)
+#define SMC_RMI_RTT_CREATE			SMC_RMI_CALL(0x015d)
+#define SMC_RMI_RTT_DESTROY			SMC_RMI_CALL(0x015e)
+
+#define SMC_RMI_RTT_READ_ENTRY			SMC_RMI_CALL(0x0161)
+
+#define SMC_RMI_RTT_DEV_VALIDATE		SMC_RMI_CALL(0x0163)
+#define SMC_RMI_PSCI_COMPLETE			SMC_RMI_CALL(0x0164)
+#define SMC_RMI_FEATURES			SMC_RMI_CALL(0x0165)
+#define SMC_RMI_RTT_FOLD			SMC_RMI_CALL(0x0166)
+
+#define SMC_RMI_RTT_INIT_RIPAS			SMC_RMI_CALL(0x0168)
+#define SMC_RMI_RTT_SET_RIPAS			SMC_RMI_CALL(0x0169)
+#define SMC_RMI_VSMMU_CREATE			SMC_RMI_CALL(0x016a)
+#define SMC_RMI_VSMMU_DESTROY			SMC_RMI_CALL(0x016b)
+
+#define SMC_RMI_RMM_CONFIG_SET			SMC_RMI_CALL(0x016e)
+#define SMC_RMI_PSMMU_IRQ_NOTIFY		SMC_RMI_CALL(0x016f)
+#define SMC_RMI_ATTEST_PLAT_TOKEN_REFRESH	SMC_RMI_CALL(0x0170)
+
+#define SMC_RMI_PDEV_ABORT			SMC_RMI_CALL(0x0174)
+#define SMC_RMI_PDEV_COMMUNICATE		SMC_RMI_CALL(0x0175)
+#define SMC_RMI_PDEV_CREATE			SMC_RMI_CALL(0x0176)
+#define SMC_RMI_PDEV_DESTROY			SMC_RMI_CALL(0x0177)
+#define SMC_RMI_PDEV_GET_STATE			SMC_RMI_CALL(0x0178)
+
+#define SMC_RMI_PDEV_STREAM_KEY_REFRESH		SMC_RMI_CALL(0x017a)
+#define SMC_RMI_PDEV_SET_PUBKEY			SMC_RMI_CALL(0x017b)
+#define SMC_RMI_PDEV_STOP			SMC_RMI_CALL(0x017c)
+#define SMC_RMI_RTT_AUX_CREATE			SMC_RMI_CALL(0x017d)
+#define SMC_RMI_RTT_AUX_DESTROY			SMC_RMI_CALL(0x017e)
+#define SMC_RMI_RTT_AUX_FOLD			SMC_RMI_CALL(0x017f)
+
+#define SMC_RMI_VDEV_ABORT			SMC_RMI_CALL(0x0185)
+#define SMC_RMI_VDEV_COMMUNICATE		SMC_RMI_CALL(0x0186)
+#define SMC_RMI_VDEV_CREATE			SMC_RMI_CALL(0x0187)
+#define SMC_RMI_VDEV_DESTROY			SMC_RMI_CALL(0x0188)
+#define SMC_RMI_VDEV_GET_STATE			SMC_RMI_CALL(0x0189)
+#define SMC_RMI_VDEV_UNLOCK			SMC_RMI_CALL(0x018a)
+#define SMC_RMI_RTT_SET_S2AP			SMC_RMI_CALL(0x018b)
+
+#define SMC_RMI_VDEV_GET_INTERFACE_REPORT	SMC_RMI_CALL(0x01d0)
+#define SMC_RMI_VDEV_GET_MEASUREMENTS		SMC_RMI_CALL(0x01d1)
+#define SMC_RMI_VDEV_LOCK			SMC_RMI_CALL(0x01d2)
+#define SMC_RMI_VDEV_START			SMC_RMI_CALL(0x01d3)
+
+#define SMC_RMI_VSMMU_EVENT_HANDLE		SMC_RMI_CALL(0x01d6)
+#define SMC_RMI_PSMMU_ACTIVATE			SMC_RMI_CALL(0x01d7)
+#define SMC_RMI_PSMMU_DEACTIVATE		SMC_RMI_CALL(0x01d8)
+
+#define SMC_RMI_PSMMU_ST_L2_CREATE		SMC_RMI_CALL(0x01db)
+#define SMC_RMI_PSMMU_ST_L2_DESTROY		SMC_RMI_CALL(0x01dc)
+#define SMC_RMI_DPT_L0_CREATE			SMC_RMI_CALL(0x01dd)
+#define SMC_RMI_DPT_L0_DESTROY			SMC_RMI_CALL(0x01de)
+#define SMC_RMI_DPT_L1_CREATE			SMC_RMI_CALL(0x01df)
+#define SMC_RMI_DPT_L1_DESTROY			SMC_RMI_CALL(0x01e0)
+#define SMC_RMI_GRANULE_TRACKING_GET		SMC_RMI_CALL(0x01e1)
+
+#define SMC_RMI_GRANULE_TRACKING_SET		SMC_RMI_CALL(0x01e3)
+
+#define SMC_RMI_RMM_CONFIG_GET			SMC_RMI_CALL(0x01ec)
+
+#define SMC_RMI_RMM_STATE_GET			SMC_RMI_CALL(0x01ee)
+
+#define SMC_RMI_PSMMU_EVENT_CONSUME		SMC_RMI_CALL(0x01f0)
+#define SMC_RMI_GRANULE_RANGE_DELEGATE		SMC_RMI_CALL(0x01f1)
+#define SMC_RMI_GRANULE_RANGE_UNDELEGATE	SMC_RMI_CALL(0x01f2)
+#define SMC_RMI_GPT_L1_CREATE			SMC_RMI_CALL(0x01f3)
+#define SMC_RMI_GPT_L1_DESTROY			SMC_RMI_CALL(0x01f4)
+#define SMC_RMI_RTT_DATA_MAP			SMC_RMI_CALL(0x01f5)
+#define SMC_RMI_RTT_DATA_UNMAP			SMC_RMI_CALL(0x01f6)
+#define SMC_RMI_RTT_DEV_MAP			SMC_RMI_CALL(0x01f7)
+#define SMC_RMI_RTT_DEV_UNMAP			SMC_RMI_CALL(0x01f8)
+#define SMC_RMI_RTT_ARCH_DEV_MAP		SMC_RMI_CALL(0x01f9)
+#define SMC_RMI_RTT_ARCH_DEV_UNMAP		SMC_RMI_CALL(0x01fa)
+#define SMC_RMI_RTT_UNPROT_MAP			SMC_RMI_CALL(0x01fb)
+#define SMC_RMI_RTT_UNPROT_UNMAP		SMC_RMI_CALL(0x01fc)
+#define SMC_RMI_RTT_AUX_PROT_MAP		SMC_RMI_CALL(0x01fd)
+#define SMC_RMI_RTT_AUX_PROT_UNMAP		SMC_RMI_CALL(0x01fe)
+#define SMC_RMI_RTT_AUX_UNPROT_MAP		SMC_RMI_CALL(0x01ff)
+#define SMC_RMI_RTT_AUX_UNPROT_UNMAP		SMC_RMI_CALL(0x0200)
+#define SMC_RMI_REALM_TERMINATE			SMC_RMI_CALL(0x0201)
+#define SMC_RMI_RMM_ACTIVATE			SMC_RMI_CALL(0x0202)
+#define SMC_RMI_OP_CONTINUE			SMC_RMI_CALL(0x0203)
+#define SMC_RMI_PDEV_STREAM_CONNECT		SMC_RMI_CALL(0x0204)
+#define SMC_RMI_PDEV_STREAM_DISCONNECT		SMC_RMI_CALL(0x0205)
+#define SMC_RMI_PDEV_STREAM_COMPLETE		SMC_RMI_CALL(0x0206)
+#define SMC_RMI_PDEV_STREAM_KEY_PURGE		SMC_RMI_CALL(0x0207)
+#define SMC_RMI_OP_MEM_DONATE			SMC_RMI_CALL(0x0208)
+#define SMC_RMI_OP_MEM_RECLAIM			SMC_RMI_CALL(0x0209)
+#define SMC_RMI_OP_CANCEL			SMC_RMI_CALL(0x020a)
+#define SMC_RMI_VSMMU_FEATURES			SMC_RMI_CALL(0x020b)
+#define SMC_RMI_VSMMU_CMD_GET			SMC_RMI_CALL(0x020c)
+#define SMC_RMI_VSMMU_CMD_COMPLETE		SMC_RMI_CALL(0x020d)
+#define SMC_RMI_PSMMU_INFO			SMC_RMI_CALL(0x020e)
+#define SMC_RMI_RMM_DEACTIVATE			SMC_RMI_CALL(0x020f)
+#define SMC_RMI_PDEV_STREAM_INFO		SMC_RMI_CALL(0x0210)
+#define SMC_RMI_GPT_INFO			SMC_RMI_CALL(0x0211)
+
+#define RMI_ABI_MAJOR_VERSION	2
+#define RMI_ABI_MINOR_VERSION	0
+
+#define RMI_ABI_VERSION_GET_MAJOR(version) ((version) >> 16)
+#define RMI_ABI_VERSION_GET_MINOR(version) ((version) & 0xFFFF)
+#define RMI_ABI_VERSION(major, minor)      (((major) << 16) | (minor))
+
+#define RMI_RETURN_STATUS_MASK		(0xFFUL)
+#define RMI_RETURN_INDEX_MASK		(0xFFUL << 8)
+#define RMI_RETURN_MEMREQ_MASK		(0x3UL << 8)
+#define RMI_RETURN_CAN_CANCEL_MASK	(0x1UL << 10)
+
+#define RMI_RETURN_STATUS(ret)		FIELD_GET(RMI_RETURN_STATUS_MASK, ret)
+#define RMI_RETURN_INDEX(ret)		FIELD_GET(RMI_RETURN_INDEX_MASK, ret)
+#define RMI_RETURN_MEMREQ(ret)		FIELD_GET(RMI_RETURN_MEMREQ_MASK, ret)
+#define RMI_RETURN_CAN_CANCEL(ret)	FIELD_GET(RMI_RETURN_CAN_CANCEL_MASK, ret)
+
+#define RMI_SUCCESS			0
+#define RMI_ERROR_INPUT			1
+#define RMI_ERROR_REALM			2
+#define RMI_ERROR_REC			3
+#define RMI_ERROR_RTT			4
+#define RMI_ERROR_NOT_SUPPORTED		5
+#define RMI_ERROR_DEVICE		6
+#define RMI_ERROR_RTT_AUX		7
+#define RMI_ERROR_PSMMU_ST		8
+#define RMI_ERROR_DPT			9
+#define RMI_BUSY			10
+#define RMI_ERROR_GLOBAL		11
+#define RMI_ERROR_TRACKING		12
+#define RMI_INCOMPLETE			13
+#define RMI_BLOCKED			14
+#define RMI_ERROR_GPT			15
+#define RMI_ERROR_GRANULE		16
+
+#define RMI_CONTINUE_KEEP_GOING		0
+#define RMI_CONTINUE_STOP		1
+
+#define RMI_OP_MEM_REQ_NONE		0
+#define RMI_OP_MEM_REQ_DONATE		1
+#define RMI_OP_MEM_REQ_RECLAIM		2
+
+#define RMI_DONATE_SIZE_MASK		3UL
+#define RMI_DONATE_COUNT_MASK		GENMASK(15, 2)
+#define RMI_DONATE_CONTIG_MASK		BIT(16)
+#define RMI_DONATE_STATE_MASK		GENMASK(18, 17)
+
+#define RMI_DONATE_SIZE(req)		FIELD_GET(RMI_DONATE_SIZE_MASK, req)
+#define RMI_DONATE_COUNT(req)		FIELD_GET(RMI_DONATE_COUNT_MASK, req)
+#define RMI_DONATE_CONTIG(req)		FIELD_GET(RMI_DONATE_CONTIG_MASK, req)
+#define RMI_DONATE_STATE(req)		FIELD_GET(RMI_DONATE_STATE_MASK, req)
+
+#define RMI_OP_MEM_DELEGATED		0
+#define RMI_OP_MEM_UNDELEGATED		1
+#define RMI_OP_MEM_CONDITIONAL		2
+
+#define RMI_ADDR_TYPE_NONE		0
+#define RMI_ADDR_TYPE_SINGLE		1
+#define RMI_ADDR_TYPE_LIST		2
+
+#define RMI_ADDR_RANGE_SIZE_MASK	GENMASK(1, 0)
+#define RMI_ADDR_RANGE_COUNT_MASK	GENMASK(PAGE_SHIFT - 1, 2)
+#define RMI_ADDR_RANGE_ADDR_MASK	(PAGE_MASK & GENMASK(51, 0))
+#define RMI_ADDR_RANGE_STATE_MASK	GENMASK(63, 62)
+
+#define RMI_ADDR_RANGE_SIZE(ar)		(FIELD_GET(RMI_ADDR_RANGE_SIZE_MASK, \
+						   (ar)))
+#define RMI_ADDR_RANGE_COUNT(ar)	(FIELD_GET(RMI_ADDR_RANGE_COUNT_MASK, \
+						   (ar)))
+#define RMI_ADDR_RANGE_ADDR(ar)		((ar) & RMI_ADDR_RANGE_ADDR_MASK)
+#define RMI_ADDR_RANGE_STATE(ar)	(FIELD_GET(RMI_ADDR_RANGE_STATE_MASK, \
+						   (ar)))
+
+enum rmi_ripas {
+	RMI_EMPTY = 0,
+	RMI_RAM = 1,
+	RMI_DESTROYED = 2,
+	RMI_DEV = 3,
+};
+
+#define RMI_NO_MEASURE_CONTENT	0
+#define RMI_MEASURE_CONTENT	1
+
+#define RMI_FEATURE_REGISTER_0_S2SZ		GENMASK(7, 0)
+#define RMI_FEATURE_REGISTER_0_LPA2		BIT(8)
+#define RMI_FEATURE_REGISTER_0_SVE		BIT(9)
+#define RMI_FEATURE_REGISTER_0_SVE_VL		GENMASK(13, 10)
+#define RMI_FEATURE_REGISTER_0_NUM_BPS		GENMASK(19, 14)
+#define RMI_FEATURE_REGISTER_0_NUM_WPS		GENMASK(25, 20)
+#define RMI_FEATURE_REGISTER_0_PMU		BIT(26)
+#define RMI_FEATURE_REGISTER_0_PMU_NUM_CTRS	GENMASK(31, 27)
+#define RMI_FEATURE_REGISTER_0_L0GPT_BLOCK_DELEGATE	BIT(32)
+#define RMI_FEATURE_REGISTER_0_S2OASZ		GENMASK(40, 33)
+
+#define RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_4KB	BIT(0)
+#define RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_16KB	BIT(1)
+#define RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_64KB	BIT(2)
+#define RMI_FEATURE_REGISTER_1_HASH_SHA_256	BIT(3)
+#define RMI_FEATURE_REGISTER_1_HASH_SHA_384	BIT(4)
+#define RMI_FEATURE_REGISTER_1_HASH_SHA_512	BIT(5)
+#define RMI_FEATURE_REGISTER_1_MAX_RECS_ORDER	GENMASK(9, 6)
+#define RMI_FEATURE_REGISTER_1_L0GPTSZ		GENMASK(13, 10)
+#define RMI_FEATURE_REGISTER_1_PPS		GENMASK(16, 14)
+
+#define RMI_FEATURE_REGISTER_2_DA		BIT(0)
+#define RMI_FEATURE_REGISTER_2_DA_COH		BIT(1)
+#define RMI_FEATURE_REGISTER_2_VSMMU		BIT(2)
+#define RMI_FEATURE_REGISTER_2_ATS		BIT(3)
+#define RMI_FEATURE_REGISTER_2_PDEV_MAX_VDEVS_ORDER	GENMASK(7, 4)
+#define RMI_FEATURE_REGISTER_2_VDEV_KROU	BIT(8)
+#define RMI_FEATURE_REGISTER_2_NON_TEE_STREAM	BIT(9)
+#define RMI_FEATURE_REGISTER_2_REALM_MAX_VDEVS_ORDER	GENMASK(14, 10)
+
+#define RMI_FEATURE_REGISTER_3_MAX_NUM_AUX_PLANES	GENMASK(3, 0)
+#define RMI_FEATURE_REGISTER_3_RTT_PLANE		GENMASK(5, 4)
+#define RMI_FEATURE_REGISTER_3_RTT_S2AP_INDIRECT	BIT(6)
+
+#define RMI_FEATURE_REGISTER_4_MEC_COUNT		GENMASK(63, 0)
+
+#define RMI_MEM_CATEGORY_CONVENTIONAL		0
+#define RMI_MEM_CATEGORY_DEV_NCOH		1
+#define RMI_MEM_CATEGORY_DEV_COH		2
+#define RMI_MEM_CATEGORY_NONE			3
+
+#define RMI_TRACKING_RESERVED			0
+#define RMI_TRACKING_NONE			1
+#define RMI_TRACKING_FINE			2
+#define RMI_TRACKING_COARSE			3
+#define RMI_TRACKING_INTERMEDIATE		4
+
+#define RMI_GRANULE_SIZE_4KB	0
+#define RMI_GRANULE_SIZE_16KB	1
+#define RMI_GRANULE_SIZE_64KB	2
+
+#define RMI_GPT_PAR_RESERVED           0U
+#define RMI_GPT_PAR_PLAT               1U
+#define RMI_GPT_PAR_HOST_NOT_CREATED   2U
+#define RMI_GPT_PAR_HOST_CREATED       3U
+
+/*
+ * Note many of these fields are smaller than u64 but all fields have u64
+ * alignment, so use u64 to ensure correct alignment.
+ */
+struct rmm_config {
+	union { /* 0x0 */
+		struct {
+			u64 tracking_region_size;
+			u64 rmi_granule_size;
+		};
+		u8 sizer[SZ_4K];
+	};
+};
+
+static_assert(sizeof(struct rmm_config) == SZ_4K);
+
+#define RMI_REALM_PARAM_FLAG_SVE		BIT(1)
+#define RMI_REALM_PARAM_FLAG_PMU		BIT(2)
+#define RMI_REALM_PARAM_FLAG_DA			BIT(3)
+#define RMI_REALM_PARAM_FLAG_LFA_POLICY		GENMASK(6, 5)
+#define RMI_REALM_PARAM_FLAG_MEC_POLICY		GENMASK(8, 7)
+
+#define RMI_HASH_SHA_256			0
+#define RMI_HASH_SHA_512			1
+#define RMI_HASH_SHA_384			2
+
+struct realm_params {
+	union { /* 0x0 */
+		struct {
+			u64 flags0;
+			u64 s2sz;
+			u64 sve_vl;
+			u64 num_bps;
+			u64 num_wps;
+			u64 pmu_num_ctrs;
+			u64 hash_algo;
+			u64 num_aux_planes;
+		};
+		u8 padding0[0x400];
+	};
+	union { /* 0x400 */
+		struct {
+			u8 rpv[64];
+			u64 ats_plane;
+		};
+		u8 padding1[0x400];
+	};
+	union { /* 0x800 */
+		struct {
+			u64 padding2;
+			u64 rtt_base;
+			s64 rtt_level_start;
+			u64 rtt_num_start;
+			u64 flags1;
+			u64 max_num_vdevs;
+		};
+		u8 padding3[0x700];
+	};
+	union { /* 0xf00 */
+		struct {
+			u8 padding4[0x80];
+			u64 aux_rtt_base[3];
+		};
+		u8 padding5[0x100];
+	};
+};
+
+static_assert(sizeof(struct realm_params) == SZ_4K);
+
+/*
+ * The number of GPRs (starting from X0) that are
+ * configured by the host when a REC is created.
+ */
+#define REC_CREATE_NR_GPRS		8
+
+#define REC_PARAMS_FLAG_RUNNABLE	BIT(0)
+
+struct rec_params {
+	union { /* 0x0 */
+		u64 flags;
+		u8 padding0[0x100];
+	};
+	union { /* 0x100 */
+		u64 mpidr;
+		u8 padding1[0x100];
+	};
+	union { /* 0x200 */
+		u64 pc;
+		u8 padding2[0x100];
+	};
+	union { /* 0x300 */
+		u64 gprs[REC_CREATE_NR_GPRS];
+		u8 padding3[0xd00];
+	};
+};
+
+static_assert(sizeof(struct rec_params) == SZ_4K);
+
+#define REC_ENTER_FLAG_EMULATED_MMIO	BIT(0)
+#define REC_ENTER_FLAG_INJECT_SEA	BIT(1)
+#define REC_ENTER_FLAG_TRAP_WFI		BIT(2)
+#define REC_ENTER_FLAG_TRAP_WFE		BIT(3)
+#define REC_ENTER_FLAG_RIPAS_RESPONSE	BIT(4)
+#define REC_ENTER_FLAG_S2AP_RESPONSE	BIT(5)
+#define REC_ENTER_FLAG_DEV_MEM_RESPONSE	BIT(6)
+#define REC_ENTER_FLAG_FORCE_P0		BIT(7)
+
+#define REC_RUN_GPRS			31
+
+struct rec_enter {
+	union { /* 0x000 */
+		u64 flags;
+		u8 padding0[0x200];
+	};
+	union { /* 0x200 */
+		u64 gprs[REC_RUN_GPRS];
+		u8 padding1[0x600];
+	};
+};
+
+static_assert(sizeof(struct rec_enter) == SZ_2K);
+
+#define RMI_EXIT_SYNC			0x00
+#define RMI_EXIT_IRQ			0x01
+#define RMI_EXIT_FIQ			0x02
+#define RMI_EXIT_PSCI			0x03
+#define RMI_EXIT_RIPAS_CHANGE		0x04
+#define RMI_EXIT_HOST_CALL		0x05
+#define RMI_EXIT_SERROR			0x06
+#define RMI_EXIT_S2AP_CHANGE		0x07
+#define RMI_EXIT_VDEV_VALIDATE_MAPPING	0x08
+#define RMI_EXIT_VSMMU_COMMAND		0x0a
+
+struct rec_exit {
+	union { /* 0x000 */
+		u8 exit_reason;
+		u8 padding0[0x100];
+	};
+	union { /* 0x100 */
+		struct {
+			u64 esr;
+			u64 far;
+			u64 hpfar;
+			u64 rtt_tree;
+		};
+		u8 padding1[0x100];
+	};
+	union { /* 0x200 */
+		u64 gprs[REC_RUN_GPRS];
+		u8 padding2[0x100];
+	};
+	union { /* 0x300 */
+		u8 padding3[0x100];
+	};
+	union { /* 0x400 */
+		struct {
+			u64 cntp_ctl;
+			u64 cntp_cval;
+			u64 cntv_ctl;
+			u64 cntv_cval;
+		};
+		u8 padding4[0x100];
+	};
+	union { /* 0x500 */
+		struct {
+			u64 ripas_base;
+			u64 ripas_top;
+			u8 ripas_value;
+			u8 padding5[0xf];
+			u64 s2ap_base;
+			u64 s2ap_top;
+			u64 vdev_id_1;
+			u64 vdev_id_2;
+			u64 dev_mem_base;
+			u64 dev_mem_top;
+			u64 dev_mem_pa;
+		};
+		u8 padding6[0x100];
+	};
+	union { /* 0x600 */
+		struct {
+			u16 imm;
+			u8 padding7[0x6];
+			u64 plane;
+		};
+		u8 padding8[0x100];
+	};
+	union { /* 0x700 */
+		struct {
+			u8 pmu_ovf_status;
+			u8 padding9[0xf];
+			u64 vsmmu;
+		};
+		u8 padding10[0x100];
+	};
+};
+
+static_assert(sizeof(struct rec_exit) == SZ_2K);
+
+struct rec_run {
+	struct rec_enter enter;
+	struct rec_exit exit;
+};
+
+static_assert(sizeof(struct rec_run) == SZ_4K);
+
+/* RMI_RTT_UNPROT_MAP_FLAGS definitions */
+#define RMI_RTT_UNPROT_MAP_FLAGS_OADDR_TYPE	GENMASK(1, 0)
+#define RMI_RTT_UNPROT_MAP_FLAGS_LIST_COUNT	GENMASK(15, 2)
+#define RMI_RTT_UNPROT_MAP_FLAGS_MEMATTR	GENMASK(18, 16)
+#define RMI_RTT_UNPROT_MAP_FLAGS_S2AP		GENMASK(22, 19)
+
+/* RMI_RTT_PROT_MAP_FLAGS definitions */
+#define RMI_RTT_PROT_MAP_FLAGS_OADDR_TYPE	GENMASK(1, 0)
+#define RMI_RTT_PROT_MAP_FLAGS_LIST_COUNT	GENMASK(15, 2)
+
+/* S2AP Direct Encodings, used in RMI_RTT_UNPROT_MAP_FLAGS_S2AP */
+#define RMI_S2AP_DIRECT_WRITE			BIT(0)
+#define RMI_S2AP_DIRECT_READ			BIT(1)
+
+#endif /* __LINUX_ARM_SMCCC_RMI_H_ */
-- 
2.43.0

