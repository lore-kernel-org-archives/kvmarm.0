Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD813BFAED;
	Mon,  6 Jul 2026 06:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783317953; cv=none; b=syT7DbURdRZDBVXS7fTsHEs9hHz7MbH2OqAjMyxthFIwFrL9wdWsY8RXtx0sgsQ4Uh/LoNoWYJmAJ0M9nGsYl8cqcQrtNlqcdQMBHOVCQbkmWiSUJedlfEviaaLTm7/RWhDq1iJWJE7cHqmh9yZf5licgPKq5rWFQB2uZrFw3pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783317953; c=relaxed/simple;
	bh=fgi7IkWdjgTFULBH3BGXLl6fsl9Ltd35CNP2YfDaqQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaiOlPfJMD2JWwMWkUllV2sUHDl5YslKXIOwGFONarstZQ//QGch/2jXPuHn5EDHotA8bHEKDqs6ouTe980d6BVs0/qM8YgNA/zRFmX8zBOYo5LC0cHOk35Y/RF0l7oYR9d/Wxx0PjpmWYbtjB783jGdJa6G/UUm3UkNuM26N6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ML+XEgAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ML+XEgAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A75E1F00A3A;
	Mon,  6 Jul 2026 06:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783317952;
	bh=7h7cJwiX8vrFgUCEKpAhuPHMfFcggvP5dwukeGSwBWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ML+XEgAAaBZseTHAUrqHcVYvgNhHln7E1bo2wLvwT8GSParIIi+YAwaXk/WQx61FG
	 vj1V4tVnH71XSD3N0yng5+t3siGVA16WOfMMJGltnDKj7SXce13rXnvQ4yCVzPIOck
	 dOFAKpaTZQBHp+c2XVAz5Z8PRrX719QgbTB8D5pdxMcoQG31UluLcrUq5kLcF3Asfl
	 tYsnrU8+/3nNzJLG/i+/rVHAy+bEPk5xFVXZ31D04dwBDPGcrSw7i306w1IAa3iBAt
	 K+cEj42REpiady2+T21rj7VREMSXU3Mdx1DnFTYIM0jiHMZGBgcpEG3HcJEUBFa9Je
	 sTgxKaDS3tNVA==
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
Subject: [PATCH v5 09/10] arm64: realm: Add RHI helper to query IPA state change alignment
Date: Mon,  6 Jul 2026 11:34:31 +0530
Message-ID: <20260706060432.1375570-10-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260706060432.1375570-1-aneesh.kumar@kernel.org>
References: <20260706060432.1375570-1-aneesh.kumar@kernel.org>
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
 arch/arm64/include/asm/rsi_cmds.h | 10 +++++++
 arch/arm64/kernel/rsi.c           | 45 +++++++++++++++++++++++++++++++
 include/linux/arm-smccc-rhi.h     | 25 +++++++++++++++++
 include/linux/arm-smccc-rsi.h     |  7 +++++
 4 files changed, 87 insertions(+)
 create mode 100644 include/linux/arm-smccc-rhi.h

diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
index 8537d0fd3da6..c890e2334a15 100644
--- a/arch/arm64/include/asm/rsi_cmds.h
+++ b/arch/arm64/include/asm/rsi_cmds.h
@@ -86,4 +86,14 @@ static inline long rsi_set_addr_range_state(phys_addr_t start,
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
 #endif /* __ASM_RSI_CMDS_H */
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index 5c566700974c..f52f240bb44c 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -11,6 +11,7 @@
 #include <linux/platform_device.h>
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
+#include <linux/arm-smccc-rhi.h>
 
 #include <asm/io.h>
 #include <asm/mem_encrypt.h>
@@ -177,6 +178,50 @@ static int realm_register_memory_enc_ops(void)
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
+	if (shared_granule_size & (SZ_4K - 1))
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
index ae663aa8fd7f..e33487ab000c 100644
--- a/include/linux/arm-smccc-rsi.h
+++ b/include/linux/arm-smccc-rsi.h
@@ -184,6 +184,13 @@ struct realm_config {
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

