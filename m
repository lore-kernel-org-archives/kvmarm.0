Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A2264AF692;
	Thu,  1 Oct 2026 08:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844396; cv=none; b=XaIv6aR48OuS6CvYB3W8T8p4LAvdxSoXBK3/q3PMwtuP8QRoojcVk+WeAt48imZuA0g/yK0xBSuxLiGor4R2gmpt9iLro4bWQoOb+pmAcjG+vvw4UTGtMPc1XrvLfrXiVMzfXgcJuRpIVp0I98+bfm2cUk++RK/0u6AJ1zhcc8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844396; c=relaxed/simple;
	bh=hDrXL7uFn7/l8pBf1Kkjko3q50W0Uqiom+6qKj6hc40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lwg06WmABph01WbeDH6RgS4f0c3Xs8g4KAQ+0gsu+E45BEv8m0I+OL87zAvCILulxfxbXjaRwnT7fNDaRaqz+MuIuYEb7CQ7S9Sz9DlLOvALoH/It6KcGvaKM7bMVLDhk48/axe5PXDippSfMiWr5qS5QDL1A5BZkQKuaKSsjo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=uoxHYcGE; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="uoxHYcGE"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79EC4497;
	Thu,  1 Oct 2026 01:46:29 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E1C3A3F85F;
	Thu,  1 Oct 2026 01:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790844392; bh=hDrXL7uFn7/l8pBf1Kkjko3q50W0Uqiom+6qKj6hc40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoxHYcGEqEBc7rj0t3OCguk8v3PDVFNMZE+hmgm49a5bDnB2MfRQgWcAFfoGjq8BF
	 X91akQut8mmVcljSNwVN9OD6YqDo+zScjQihbOba3MHF3MUsew3NcBScycItiAwwrP
	 wrqEOaVpUhYQ/3AtjflCB6jAmsRva9uGrYIkutY8=
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
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v21 2/9] firmware: arm_rmm: Check for RMI support at init
Date: Thu,  1 Oct 2026 09:45:48 +0100
Message-ID: <20261001084555.1456543-3-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001084555.1456543-1-suzuki.poulose@arm.com>
References: <20261001084555.1456543-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Steven Price <steven.price@arm.com>

Query the RMI version number and check if it is a compatible version.
All RMM feature registers are read and exposed for future code to
use.

We only support this for Little Endian kernels, the Big Endian kernel
support is anyway marked BROKEN and is being removed.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
v20:
 * Fix comment : s/RmiFeatureRegister5/RmiFeatureRegister4/
 * rmi_feat_reg() s/unsigned long/unsigned int for index
 * linux/arm-rmi-cmds.h -> Mark the "#endif"
 * Use += rmi.o in Makefile
 * Mask the ID_AA64PFR0_EL1_RME field for KVM guests
 * Add MAINTAINERS entry for header file and arm_rmm directory
   (Potential conflict with Aneesh's smccc series)
v19:
 * Read all implemented RmiFeatureRegisters - 5
 * Use ARRAY_SIZE(rmi_feat_reg_cache) for the loop in rmi_read_features()
 * Fold rmi_features() into rmi_read_features
 * Fix comment for rmi_smccc_invoke()
 * Drop default y
 * Add retry for RMI_BLOCKED and return to caller
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
 MAINTAINERS                       |   2 +
 arch/arm64/Kconfig                |   1 +
 arch/arm64/kernel/cpufeature.c    |   1 +
 arch/arm64/kvm/sys_regs.c         |   2 +
 drivers/firmware/Kconfig          |   1 +
 drivers/firmware/Makefile         |   1 +
 drivers/firmware/arm_rmm/Kconfig  |  25 +++++++
 drivers/firmware/arm_rmm/Makefile |   1 +
 drivers/firmware/arm_rmm/rmi.c    | 109 ++++++++++++++++++++++++++++++
 include/linux/arm-rmi-cmds.h      |  48 +++++++++++++
 10 files changed, 191 insertions(+)
 create mode 100644 drivers/firmware/arm_rmm/Kconfig
 create mode 100644 drivers/firmware/arm_rmm/Makefile
 create mode 100644 drivers/firmware/arm_rmm/rmi.c
 create mode 100644 include/linux/arm-rmi-cmds.h

diff --git a/MAINTAINERS b/MAINTAINERS
index ed82c55bf566f..1646012706823 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3951,8 +3951,10 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git
 F:	Documentation/arch/arm64/
 F:	arch/arm64/
+F:	drivers/firmware/arm_rmm/
 F:	drivers/virt/coco/arm-cca-guest/
 F:	drivers/virt/coco/pkvm-guest/
+F:	include/linux/arm-rmi-cmds.h
 F:	include/linux/arm-smccc-rmi.h
 F:	tools/testing/selftests/arm64/
 X:	arch/arm64/boot/dts/
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
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44aae52c473d7..f0ef348f725b6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2163,6 +2163,8 @@ static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 	 */
 	val &= ~ID_AA64PFR0_EL1_MPAM_MASK;
 
+	val &= ~ID_AA64PFR0_EL1_RME_MASK;
+
 	return val;
 }
 
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
index 0000000000000..a37cba6647360
--- /dev/null
+++ b/drivers/firmware/arm_rmm/Kconfig
@@ -0,0 +1,25 @@
+
+config ARCH_SUPPORTS_RMM
+	bool
+
+config ARM_RMM_RMI
+	bool "Realm Management Interface (RMI) Support"
+	depends on ARCH_SUPPORTS_RMM
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
index 0000000000000..25e6ad80d3a19
--- /dev/null
+++ b/drivers/firmware/arm_rmm/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_ARM_RMM_RMI)	+= rmi.o
diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
new file mode 100644
index 0000000000000..90706a16c8836
--- /dev/null
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2023-2026 ARM Ltd.
+ */
+
+#include <linux/arm-rmi-cmds.h>
+#include <linux/cpufeature.h>
+#include <linux/memblock.h>
+#include <linux/slab.h>
+
+#include <asm/memory.h>
+#include <asm/pgtable-hwdef.h>
+
+/* RMM v2.0 defines RmiFeatureRegister0 to RmiFeatureRegister4. */
+static unsigned long rmi_feat_reg_cache[5] __ro_after_init;
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
+	for (int i = 0; i < ARRAY_SIZE(rmi_feat_reg_cache); i++) {
+		struct arm_smccc_1_2_regs args = {
+			SMC_RMI_FEATURES, i,
+		};
+
+		rmi_smccc_invoke(&args);
+		if (WARN_ON(args.a0 != RMI_SUCCESS))
+			return -EINVAL;
+
+		rmi_feat_reg_cache[i] = args.a1;
+	}
+
+	return 0;
+}
+
+unsigned long rmi_feat_reg(unsigned int index)
+{
+	if (WARN_ON(index >= ARRAY_SIZE(rmi_feat_reg_cache)))
+		return 0;
+
+	return rmi_feat_reg_cache[index];
+}
+EXPORT_SYMBOL_GPL(rmi_feat_reg);
+
+
+static int __init arm64_init_rmi(void)
+{
+	int ret;
+
+	/* If we can't agree on the RMI ABI version, don't proceed further */
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
index 0000000000000..911489b636522
--- /dev/null
+++ b/include/linux/arm-rmi-cmds.h
@@ -0,0 +1,48 @@
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
+#define RMM_BLOCKED_RETRY_COUNT		2
+/*
+ * rmi_smccc_invoke: Invoke the RMI call and return the results, retrying the
+ * command when status is RMI_BUSY. If we encounter RMI_BLOCKED, we retry
+ * it one more time before we give up. The caller is supposed to handle the
+ * result and reissue if required.
+ *
+ * We don't expect to see RMI_BLOCKED on a practical system, except when
+ * there are parallel requests that results in long standing operation,
+ * with one blocking the other.
+ *
+ * @regs: Input parameters filled in. Updated with the ouptput results
+ * after the call.
+ */
+static inline void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs)
+{
+	struct arm_smccc_1_2_regs args = *regs;
+	long status;
+	int i = 0;
+
+	while (i < RMM_BLOCKED_RETRY_COUNT) {
+		arm_smccc_1_2_invoke(&args, regs);
+
+		status = RMI_RESULT_STATUS(regs->a0);
+		if (status != RMI_BUSY && status != RMI_BLOCKED)
+			break;
+		if (status == RMI_BLOCKED)
+			i++;
+		cpu_relax();
+	}
+}
+
+unsigned long rmi_feat_reg(unsigned int index);
+
+#endif	/* __LINUX_ARM_RMI_CMDS_H_ */
-- 
2.43.0

