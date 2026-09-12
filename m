Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A1C6416871;
	Sat, 12 Sep 2026 08:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202214; cv=none; b=nMl4FmQq1pPuG6zrlIBsHADJR8q1mkTpUAq2kialI4NUmltRlnasucuEmEOQ6oztyrxruD6fwB31IFRCruf3UBdKWIZnzIxKKgE8VvurwWFB0DcYBUJvY0LqZliunkmTBeVcxRgE8Jq7rxqf4TzrzbXNnTr2SfpG85yWYxbOnoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202214; c=relaxed/simple;
	bh=puuvnSa6ejN/PUES0nbUY9HsX3WVU3O75m5MTU3npto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPfvcgAiVtl8lwrZrQ/6pEGUQSey7/8fmLopbZUM70n2iRyhTTUIfTo/dcvsbWRnD7sIhIjZELI1TgvRp/oVbeTsxZxEG0HkVF1kWLUgw4sRxZPv/rl1uo7xlCTFIrdZKkNtpFTG2ydQiHV4wFkuNeGrslrjQp2FpVznXcH42Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vVyppXQJ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vVyppXQJ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9AFB22BC4;
	Sat, 12 Sep 2026 01:36:44 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9F5653F7B4;
	Sat, 12 Sep 2026 01:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789202208; bh=puuvnSa6ejN/PUES0nbUY9HsX3WVU3O75m5MTU3npto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVyppXQJAB3AW0XcPGd3K8vTMAb5ZsyIOue7IpxtgHPyZq1JdKx9cP+n1sGrL7yym
	 4unJ68+0Gb+vWAe8WsNw4/Fl8y1bqFH1zQHgUCgmVoa8H5GoRPCXdsaRiXxvK0kbK8
	 HvwV9ixdkiRK7c03J2YnnbP3BsagFHtsLXjx9tuM=
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
Subject: [PATCH v18 2/7] firmware: arm_rmm: Check for RMI support at init
Date: Sat, 12 Sep 2026 09:36:05 +0100
Message-ID: <20260912083611.2513845-3-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260912083611.2513845-1-suzuki.poulose@arm.com>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Steven Price <steven.price@arm.com>

Query the RMI version number and check if it is a compatible version.
The first two feature registers are read and exposed for future code to
use.

We only support this for Little Endian kernels, the Big Endian kernel
support is anyway marked BROKEN and is being removed.

Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
v18:
 * Always use arm_smccc_1_2_invoke() for all RMIs making sure the unsused
   parameters are 0 - Sashiko
 * Move rmi_features() calls away from the arm-rmi-cmds.h to rmi.c - Gavin
v17:
 * Rename ARM_RMM to ARM_RMM_RMI to make it easier to add Guest facing RSI
   support, which is also in progress
v16:
 * Update Kconfig text to include PCIe TDISP.
 * Export rmi_feat_reg() here rather than in a later commit.
v15:
 * The code is moved again, this time into the 'firmware' directory.
v14:
 * This moves the basic RMI setup into the 'kernel' directory. This is
   because RMI will be used for some features outside of KVM so should
   be available even if KVM isn't compiled in.
---
 arch/arm64/Kconfig                |   1 +
 arch/arm64/kernel/cpufeature.c    |   1 +
 drivers/firmware/Kconfig          |   1 +
 drivers/firmware/Makefile         |   1 +
 drivers/firmware/arm_rmm/Kconfig  |  26 +++++++
 drivers/firmware/arm_rmm/Makefile |   2 +
 drivers/firmware/arm_rmm/rmi.c    | 122 ++++++++++++++++++++++++++++++
 include/linux/arm-rmi-cmds.h      |  36 +++++++++
 8 files changed, 190 insertions(+)
 create mode 100644 drivers/firmware/arm_rmm/Kconfig
 create mode 100644 drivers/firmware/arm_rmm/Makefile
 create mode 100644 drivers/firmware/arm_rmm/rmi.c
 create mode 100644 include/linux/arm-rmi-cmds.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b5a51b0ef9440..ff9565d3ffa59 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -38,6 +38,7 @@ config ARM64
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_MEM_ENCRYPT
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
+	select ARCH_SUPPORTS_RMM
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_NONLEAF_PMD_YOUNG if ARM64_HAFT
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 32102c3912fa7..e8b29983b0021 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -293,6 +293,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar3[] = {
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV2_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_RME_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_DIT_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_AMU_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_MPAM_SHIFT, 4, 0),
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index b7cc11e4fbfa6..62660bf520a8d 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -310,5 +310,6 @@ source "drivers/firmware/samsung/Kconfig"
 source "drivers/firmware/smccc/Kconfig"
 source "drivers/firmware/tegra/Kconfig"
 source "drivers/firmware/xilinx/Kconfig"
+source "drivers/firmware/arm_rmm/Kconfig"
 
 endmenu
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index be46f1e1dc77f..196a650ccf025 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -39,3 +39,4 @@ obj-y				+= samsung/
 obj-y				+= smccc/
 obj-y				+= tegra/
 obj-y				+= xilinx/
+obj-y				+= arm_rmm/
diff --git a/drivers/firmware/arm_rmm/Kconfig b/drivers/firmware/arm_rmm/Kconfig
new file mode 100644
index 0000000000000..82724ee23186d
--- /dev/null
+++ b/drivers/firmware/arm_rmm/Kconfig
@@ -0,0 +1,26 @@
+
+config ARCH_SUPPORTS_RMM
+	bool
+
+config ARM_RMM_RMI
+	bool "Realm Management Interface (RMI) Support"
+	depends on ARCH_SUPPORTS_RMM
+	default y
+	help
+	  Support the Realm Management Monitor (RMM) on Arm systems that
+	  implement the Realm Management Extension (RME), as defined by the
+	  Arm Confidential Compute Architecture.
+
+	  The RMM runs at EL2 in the Realm world and provides the Realm
+	  Management Interface (RMI) used by a Normal World host to create,
+	  manage and run protected virtual machines called Realms. The RMM can
+	  also act as a TSM, as defined by the PCIe TDISP and can manage the
+	  PCI IDE setup for securing the PCIe links.
+
+	  This option builds the host-side RMI support used by KVM to detect a
+	  compatible RMM, configure it, manage delegated memory and enable
+	  Realm guests.
+
+	  Selecting this option does not by itself make Realm guests available:
+	  the system must also provide RME-capable hardware and firmware with a
+	  compatible RMM implementation.
diff --git a/drivers/firmware/arm_rmm/Makefile b/drivers/firmware/arm_rmm/Makefile
new file mode 100644
index 0000000000000..65171988fdcae
--- /dev/null
+++ b/drivers/firmware/arm_rmm/Makefile
@@ -0,0 +1,2 @@
+
+obj-$(CONFIG_ARM_RMM_RMI)	= rmi.o
diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
new file mode 100644
index 0000000000000..2fd538c937dca
--- /dev/null
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2023-2026 ARM Ltd.
+ */
+
+#include <linux/cpufeature.h>
+#include <linux/memblock.h>
+#include <linux/arm-rmi-cmds.h>
+#include <linux/slab.h>
+
+#include <asm/memory.h>
+#include <asm/pgtable-hwdef.h>
+
+/* Currently only the first 2 registers are used by Linux */
+#define RMI_FEAT_REG_COUNT	2
+static unsigned long rmi_feat_reg_cache[RMI_FEAT_REG_COUNT] __ro_after_init;
+
+/**
+ * rmi_features() - Read feature register
+ * @index: Feature register index
+ * @out: Feature register value is written to this pointer
+ *
+ * Return: RMI return code
+ */
+static int rmi_features(unsigned long index, unsigned long *out)
+{
+	struct arm_smccc_1_2_regs args = {
+		SMC_RMI_FEATURES, index
+	};
+
+	rmi_smccc_invoke(&args);
+	if (args.a0 == RMI_SUCCESS && out)
+		*out = args.a1;
+
+	return args.a0;
+}
+
+unsigned long rmi_feat_reg(unsigned long index)
+{
+	if (WARN_ON(index >= RMI_FEAT_REG_COUNT))
+		return 0;
+
+	return rmi_feat_reg_cache[index];
+}
+EXPORT_SYMBOL_GPL(rmi_feat_reg);
+
+static int rmi_check_version(void)
+{
+	unsigned short version_major, version_minor;
+	unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
+						     RMI_ABI_MINOR_VERSION);
+	unsigned long aa64pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+	struct arm_smccc_1_2_regs res = {
+		SMC_RMI_VERSION, host_version,
+	};
+
+	/* If RME isn't supported, then RMI can't be */
+	if (cpuid_feature_extract_unsigned_field(aa64pfr0, ID_AA64PFR0_EL1_RME_SHIFT) == 0)
+		return -ENXIO;
+
+	rmi_smccc_invoke(&res);
+	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
+		return -ENXIO;
+
+	version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
+	version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
+
+	if (res.a0 != RMI_SUCCESS) {
+		unsigned short high_version_major, high_version_minor;
+
+		high_version_major = RMI_ABI_VERSION_GET_MAJOR(res.a2);
+		high_version_minor = RMI_ABI_VERSION_GET_MINOR(res.a2);
+
+		pr_err("Unsupported RMI ABI (v%d.%d - v%d.%d) we want v%d.%d\n",
+		       version_major, version_minor,
+		       high_version_major, high_version_minor,
+		       RMI_ABI_MAJOR_VERSION,
+		       RMI_ABI_MINOR_VERSION);
+		return -ENXIO;
+	}
+
+	pr_info("RMI ABI version %d.%d\n", version_major, version_minor);
+
+	return 0;
+}
+
+static int rmi_read_features(void)
+{
+	/*
+	 * Since we've negotiated a compatible version these feature registers
+	 * should always be available
+	 */
+	for (int i = 0; i < RMI_FEAT_REG_COUNT; i++) {
+		if (WARN_ON(rmi_features(i, &rmi_feat_reg_cache[i])))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __init arm64_init_rmi(void)
+{
+	int ret;
+
+	/* Continue without realm support if we can't agree on a version */
+	ret = rmi_check_version();
+	if (ret)
+		return ret;
+
+	ret = rmi_read_features();
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/*
+ * Note arm64_init_rmi() must be called before kvm_init_rmi() otherwise KVM
+ * will not support realm guests. subsys_initcall() is called before
+ * module_init() (used for KVM) so this is OK.
+ */
+subsys_initcall(arm64_init_rmi);
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
new file mode 100644
index 0000000000000..9792bf0e00cb9
--- /dev/null
+++ b/include/linux/arm-rmi-cmds.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+
+#ifndef __LINUX_ARM_RMI_CMDS_H_
+#define __LINUX_ARM_RMI_CMDS_H_
+
+#include <linux/arm-smccc-rmi.h>
+#include <linux/bug.h>
+#include <linux/processor.h>
+#include <linux/types.h>
+
+
+/*
+ * rmi_smccc_invoke: Invoke the RMI call and return the results in @regs_out
+ * @regs_in: Registers with the arguments filled in.
+ * @regs_out: Ouptput results from the call.
+ */
+static inline void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs)
+{
+	struct arm_smccc_1_2_regs args = *regs;
+	unsigned long status;
+
+	while (1) {
+		arm_smccc_1_2_invoke(&args, regs);
+		status = RMI_RETURN_STATUS(regs->a0);
+		if (status != RMI_BUSY && status != RMI_BLOCKED)
+			break;
+		cpu_relax();
+	}
+}
+
+unsigned long rmi_feat_reg(unsigned long index);
+
+#endif
-- 
2.43.0

