Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA6242B327;
	Fri,  4 Sep 2026 10:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518150; cv=none; b=L1i5CyZcC+/6oKGCnujvEYBgpdHwe7aZNSZfPVXdhq2p8uS5Y6cHE4fDAvTUw2Uvgp3SXAFVOWyn6J5v/pONqpvQZJ7AV8+dNeAeJkkfLQtiz4C4G4knpb4eOU3eWj173cX3Uh78xNe7mSwcRtyQwtgyKYzSAe8KEieTohE4k1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518150; c=relaxed/simple;
	bh=SPD7jwCA+0OipeuwCBppuiwCEwdNcIigiEdQ1zr2ctI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRpUYAQmbOocFQyqfwUIwFREIOMcfZDshYllKd69xjYRPDkZI3Sj5aTlum10Lav5dKVjau7QWiBBy1J4rXHOnPSQP7L6HpSjZD6W6UbsWSZo5Ayxn8cck+A8TyiNPmD9yAhXKChyc7cZXseUW/ZSQgdzsV0JBLb3BetUbft3iZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=afAcEPt7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="afAcEPt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8701F00A3D;
	Fri,  4 Sep 2026 10:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518147;
	bh=ZGmY6QlBMQ2SHa5L+lxqX371JcTBS0qRTbNtw3modBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=afAcEPt7t2fdenCPFl8yuDLqP8SmdEH9gpHntfCODggDHUt2jjg5qreIkzdmOXlYA
	 x4ews9cAZJ9O6CjUnfOam1vQY8XW1bLQoMaElEYjJfzdeQwdVPo57aMaQ+MYlChkb/
	 jncSj7jtk42gDhf5YfbIGQoKcLXDMu//IB+ZnaE6FdCfUulrbI7zRbsNHkkNJHD+WN
	 tEzMjDkLTHrxH477gaEEWmumqlAOVuF7yPiFMW93YQOQ7KzLNllD7yjHdOLglOkK7q
	 waPxaRvuNvR1faxdAgrGT1UZ63WzM64kCzi8pg8+2UjETDcJ5i1i+0lJGOoibAt5rf
	 1EUc3qohWpZBA==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v6 8/9] arm64: realm: Add RHI helper to query IPA state change alignment
Date: Fri,  4 Sep 2026 16:04:51 +0530
Message-ID: <20260904103452.1197239-9-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260904103452.1197239-1-aneesh.kumar@kernel.org>
References: <20260904103452.1197239-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Arm CCA guests need to know the granularity at which the host expects IPA
state changes to be performed. This can be larger than the guest page size
and is needed when deciding the alignment for memory shared with the host.

Add the Realm Host Interface host configuration definitions and an
get_ipa_state_change_alignment() helper. The helper uses RSI_HOST_CALL to
query the supported HostConf version and features, reads the IPA change
alignment when available, and falls back to PAGE_SIZE if the interface is
unavailable or returns an invalid value.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/firmware/arm_rmm/rsi.c | 46 ++++++++++++++++++++++++++++++++++
 include/linux/arm-rsi-cmds.h   | 10 ++++++++
 include/linux/arm-smccc-rhi.h  | 25 ++++++++++++++++++
 include/linux/arm-smccc-rsi.h  |  7 ++++++
 4 files changed, 88 insertions(+)
 create mode 100644 include/linux/arm-smccc-rhi.h

diff --git a/drivers/firmware/arm_rmm/rsi.c b/drivers/firmware/arm_rmm/rsi.c
index 52f40256bd78..2cd53f82432f 100644
--- a/drivers/firmware/arm_rmm/rsi.c
+++ b/drivers/firmware/arm_rmm/rsi.c
@@ -9,6 +9,7 @@
 #include <linux/swiotlb.h>
 #include <linux/platform_device.h>
 #include <linux/arm-rsi-cmds.h>
+#include <linux/arm-smccc-rhi.h>
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
 
@@ -164,6 +165,51 @@ static int realm_register_memory_enc_ops(void)
 	return arm64_mem_crypt_ops_register(&realm_crypt_ops);
 }
 
+/* we need an aligned struct for rsi_host_call. slab is not yet ready */
+static struct rsi_host_call hostconf_call __initdata;
+static unsigned long __maybe_unused __init get_ipa_state_change_alignment(void)
+{
+	long ret;
+	unsigned long shared_granule_size;
+
+	hostconf_call.imm = 0;
+	hostconf_call.gprs[0] = RHI_HOSTCONF_VERSION;
+	ret = rsi_host_call(lm_alias(&hostconf_call));
+	if (ret != RSI_SUCCESS)
+		goto err_out;
+
+	if (hostconf_call.gprs[0] != RHI_HOSTCONF_VER_1_0)
+		goto err_out;
+
+	hostconf_call.imm = 0;
+	hostconf_call.gprs[0] = RHI_HOSTCONF_FEATURES;
+	ret = rsi_host_call(lm_alias(&hostconf_call));
+	if (ret != RSI_SUCCESS)
+		goto err_out;
+
+	if (!(hostconf_call.gprs[0] & __RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT))
+		goto err_out;
+
+	hostconf_call.imm = 0;
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
index 000000000000..91a29996d72d
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
+#define __RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT BIT(0)
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

