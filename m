Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2169C2DC783;
	Mon, 21 Sep 2026 14:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790002154; cv=none; b=OHwpOBva7IziTB419E8ITjF9BRvmhEHdCTfLWCFs0lbNCueakEWVNSGwRYsHBgL/DihBVyw+Yj0PhmVcED4jsR1EW3vinfLTIQoHTz+MEeXfAdsSdEYSMTqAxGvzv9bsQ1kgsX4TNFsQFiAJHo28gI4M1/1H3TkKb31A2NRbotM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790002154; c=relaxed/simple;
	bh=ifD/kJ4/+PxNKv2UC8zL5w7iehZmNr46IJQAfLbWwGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5WaxtlVAFBUXBPutdrUuycWg9XFKzaqF/drtV6eHVG7vxZKDf8CRmZ1CZRdBhkWDwuPTgplY/ziBc3/wFUbOCKqf3d9pLkE6T220Ha7CO0IBrDjTwZ92NxbZ2S0c8HNjfIR3L9AqDs7aedV/0ZRw/R8aBdEh8k5ef7HRTj4PjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y+kLs6SQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+kLs6SQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8793A1F00893;
	Mon, 21 Sep 2026 14:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002152;
	bh=JdzsdQpKyf1oi4MN56R5Qf9hEJiO6vl06z2ni7VOm34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y+kLs6SQLu85HXfzZNOLdVmzLtG8mzYHcUSGiSn1iF44uWoScyqBbhGJ5r0nsK/ma
	 FIK15tCOZoLUHS+PwSHzIoVNZTS+z+H9j+yHajmGDZLJeT5W++foKiWJFE27qu/Kvi
	 TbLBk+PmZ6h/KYLkO/NGiXwmBZc2fy/RXSarlfUmbGTkZFi5PWpPHwLO4U66CAKAK1
	 jspex32vrRlNo8fuaOWIMQeW23gztZ9EXJCKytESjUn74vf1svigMLszelQIvmvxrU
	 qZOf+y8QRisgQbX0dfD0v46buL7LDd9OESNuOzlcfExGOhpDBIF4A9TEQW4rUpzpaZ
	 lS+nUdoKGfTdw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	christian.koenig@amd.com,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v7 01/13] arm64: realm: Add RHI helper to query IPA state change alignment
Date: Mon, 21 Sep 2026 20:18:35 +0530
Message-ID: <20260921144847.501151-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921144847.501151-1-aneesh.kumar@kernel.org>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Arm CCA guests can run with a PAGE_SIZE that is smaller than the granule
size used by the host to track Realm IPA state. In that configuration,
changing a guest PAGE_SIZE range between protected and shared state can
cover only part of the host-owned state-change unit.

The Realm Host Interface specification (Arm DEN0148) [1] defines the
Host Configuration interface for querying host capabilities, including
the IPA state change alignment.

Add the RHI HostConf definitions and a get_ipa_state_change_alignment()
helper. The helper uses RSI_HOST_CALL to query the supported HostConf
version and features, and reads the IPA state change alignment when
available. It falls back to PAGE_SIZE if the interface is unavailable or
returns an invalid value.

[1] https://support.arm.com/documentation/den0148/latest/

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 MAINTAINERS                    |  1 +
 drivers/firmware/arm_rmm/rsi.c | 47 ++++++++++++++++++++++++++++++++++
 include/linux/arm-rsi-cmds.h   | 10 ++++++++
 include/linux/arm-smccc-rhi.h  | 25 ++++++++++++++++++
 include/linux/arm-smccc-rsi.h  |  7 +++++
 5 files changed, 90 insertions(+)
 create mode 100644 include/linux/arm-smccc-rhi.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 1e543163a8cc..87ec876868eb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3956,6 +3956,7 @@ F:	drivers/firmware/arm_rmm/
 F:	drivers/virt/coco/arm-cca-guest/
 F:	drivers/virt/coco/pkvm-guest/
 F:	include/linux/arm-rsi-cmds.h
+F:	include/linux/arm-smccc-rhi.h
 F:	include/linux/arm-smccc-rsi.h
 F:	tools/testing/selftests/arm64/
 X:	arch/arm64/boot/dts/
diff --git a/drivers/firmware/arm_rmm/rsi.c b/drivers/firmware/arm_rmm/rsi.c
index 0fcc4e33bd92..883f6091ff95 100644
--- a/drivers/firmware/arm_rmm/rsi.c
+++ b/drivers/firmware/arm_rmm/rsi.c
@@ -8,7 +8,9 @@
 #include <linux/psci.h>
 #include <linux/swiotlb.h>
 #include <linux/arm-rsi-cmds.h>
+#include <linux/arm-smccc-rhi.h>
 #include <linux/kobject.h>
+#include <linux/string.h>
 #include <linux/sysfs.h>
 
 #include <asm/io.h>
@@ -162,6 +164,51 @@ static int realm_register_memory_enc_ops(void)
 	return arm64_mem_crypt_ops_register(&realm_crypt_ops);
 }
 
+/* we need an aligned struct for rsi_host_call. slab is not yet ready */
+static struct rsi_host_call hostconf_call __initdata;
+static unsigned long __maybe_unused __init get_ipa_state_change_alignment(void)
+{
+	long ret;
+	unsigned long shared_granule_size;
+
+	memset(&hostconf_call, 0, sizeof(hostconf_call));
+	hostconf_call.gprs[0] = RHI_HOSTCONF_VERSION;
+	ret = rsi_host_call(lm_alias(&hostconf_call));
+	if (ret != RSI_SUCCESS)
+		goto err_out;
+
+	if (hostconf_call.gprs[0] != RHI_HOSTCONF_VER_1_0)
+		goto err_out;
+
+	memset(&hostconf_call, 0, sizeof(hostconf_call));
+	hostconf_call.gprs[0] = RHI_HOSTCONF_FEATURES;
+	ret = rsi_host_call(lm_alias(&hostconf_call));
+	if (ret != RSI_SUCCESS)
+		goto err_out;
+
+	if (!(hostconf_call.gprs[0] & RHI_HOSTCONF_FEATURE_GET_IPA_CHANGE_ALIGNMENT))
+		goto err_out;
+
+	memset(&hostconf_call, 0, sizeof(hostconf_call));
+	hostconf_call.gprs[0] = RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT;
+	ret = rsi_host_call(lm_alias(&hostconf_call));
+	if (ret != RSI_SUCCESS)
+		goto err_out;
+
+	shared_granule_size = hostconf_call.gprs[0];
+	if (shared_granule_size & (SZ_4K - 1) ||
+	    !is_power_of_2(shared_granule_size))
+		goto err_out;
+
+	return max(PAGE_SIZE, shared_granule_size);
+err_out:
+	/*
+	 * For failure condition assume host is built with 4K page size
+	 * and hence IPA state change alignment can be guest PAGE_SIZE.
+	 */
+	return PAGE_SIZE;
+}
+
 void __init arm64_rsi_init(void)
 {
 	if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_SMC)
diff --git a/include/linux/arm-rsi-cmds.h b/include/linux/arm-rsi-cmds.h
index 3f7a6a833993..996f1621b996 100644
--- a/include/linux/arm-rsi-cmds.h
+++ b/include/linux/arm-rsi-cmds.h
@@ -236,4 +236,14 @@ static inline unsigned long rsi_attestation_token_continue(phys_addr_t granule,
 	return res.a0;
 }
 
+static inline unsigned long rsi_host_call(struct rsi_host_call *rhi_call)
+{
+	phys_addr_t addr = virt_to_phys(rhi_call);
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RSI_HOST_CALL, addr, &res);
+
+	return res.a0;
+}
+
 #endif /* __LINUX_ARM_RSI_CMDS_H_ */
diff --git a/include/linux/arm-smccc-rhi.h b/include/linux/arm-smccc-rhi.h
new file mode 100644
index 000000000000..be89185cddae
--- /dev/null
+++ b/include/linux/arm-smccc-rhi.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+
+#ifndef __LINUX_ARM_SMCCC_RHI_H_
+#define __LINUX_ARM_SMCCC_RHI_H_
+
+#include <linux/arm-smccc.h>
+
+#define SMC_RHI_CALL(func)				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+			   ARM_SMCCC_SMC_64,		\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,\
+			   (func))
+
+#define RHI_HOSTCONF_VER_1_0		0x10000
+#define RHI_HOSTCONF_VERSION		SMC_RHI_CALL(0x004E)
+
+#define RHI_HOSTCONF_FEATURE_GET_IPA_CHANGE_ALIGNMENT	BIT(0)
+#define RHI_HOSTCONF_FEATURES		SMC_RHI_CALL(0x004F)
+
+#define RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT	SMC_RHI_CALL(0x0050)
+
+#endif /* __LINUX_ARM_SMCCC_RHI_H_ */
diff --git a/include/linux/arm-smccc-rsi.h b/include/linux/arm-smccc-rsi.h
index fddb77986f70..3532a3f08f4e 100644
--- a/include/linux/arm-smccc-rsi.h
+++ b/include/linux/arm-smccc-rsi.h
@@ -182,6 +182,13 @@ struct realm_config {
  */
 #define SMC_RSI_IPA_STATE_GET			SMC_RSI_FID(0x198)
 
+struct rsi_host_call {
+	union {
+		u16 imm;
+		u64 padding0;
+	};
+	u64 gprs[31];
+} __aligned(0x100);
 /*
  * Make a Host call.
  *
-- 
2.43.0

