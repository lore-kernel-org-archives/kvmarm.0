Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAAFD416843;
	Mon,  3 Aug 2026 13:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764674; cv=none; b=JKnjjrpbfaQHPxynXhTHYlezxDrwKXz64pSh7d03FJ7dHZUlCXTpd2P6Cg/2NWIn7MSqtn29eDPJn3WH/3VoA+LcqOvjpz+uJsFxVUJzMjcwtzBGb2qFaltnjErpwyedioEMwb5/4Zepm1L7YMaYYzfbQZRankQuu6dck7sE+cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764674; c=relaxed/simple;
	bh=+YieMOk7OvKlR73r97xaxKE5U8IgmhAkbUHPiPHHxs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzdZCrVHYxGHW2FBk7CeDKFyb+mJtIPGt5FCEHaggyLojRxHhP2rpZPhsTgn53WvQzj+BEJMjH/22NIs+h5MfmA2KdbxVw5Dktp1zr9GKa9HWr+fA7iOhWRtUcedYP8vc37D75NZ9XWWUbj0WFFShwx5HVGXd7qyfw66wfm2Pyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rrQKJhF+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rrQKJhF+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C83015A1;
	Mon,  3 Aug 2026 06:44:28 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 537423F66F;
	Mon,  3 Aug 2026 06:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764672; bh=+YieMOk7OvKlR73r97xaxKE5U8IgmhAkbUHPiPHHxs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrQKJhF+qvHYd7u4WVhFEIcs8ycvTdfz+xkIOa1wxL8mJ33hztGR7mWZi0hFTBcVp
	 iSVK3VRV5oIADwlRJTBdd4q3ATBYjH8OsDl5adIqjL+2U2fVcg26obueNxBWPRiRe3
	 meZlnK2Bc3v8IXT3R3kD4OyKdOvH77JrW06UMPZs=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v16 03/45] firmware: arm_rmm: Check for RMI support at init
Date: Mon,  3 Aug 2026 14:43:19 +0100
Message-ID: <20260803134403.80630-4-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Query the RMI version number and check if it is a compatible version.
The first two feature registers are read and exposed for future code to
use.

Signed-off-by: Steven Price <steven.price@arm.com>
---
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
 drivers/firmware/arm_rmm/Kconfig  |  26 ++++++++
 drivers/firmware/arm_rmm/Makefile |   2 +
 drivers/firmware/arm_rmm/rmi.c    | 101 ++++++++++++++++++++++++++++++
 include/linux/arm-rmi-cmds.h      |   2 +
 8 files changed, 135 insertions(+)
 create mode 100644 drivers/firmware/arm_rmm/Kconfig
 create mode 100644 drivers/firmware/arm_rmm/Makefile
 create mode 100644 drivers/firmware/arm_rmm/rmi.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b3afe0688919..0f1956edf130 100644
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
index 9a22df0c5120..4ae63c89cda9 100644
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
index 12dc70254842..55542879fbb8 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -301,5 +301,6 @@ source "drivers/firmware/samsung/Kconfig"
 source "drivers/firmware/smccc/Kconfig"
 source "drivers/firmware/tegra/Kconfig"
 source "drivers/firmware/xilinx/Kconfig"
+source "drivers/firmware/arm_rmm/Kconfig"
 
 endmenu
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 4ddec2820c96..07e8ca1789b4 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -38,3 +38,4 @@ obj-y				+= samsung/
 obj-y				+= smccc/
 obj-y				+= tegra/
 obj-y				+= xilinx/
+obj-y				+= arm_rmm/
diff --git a/drivers/firmware/arm_rmm/Kconfig b/drivers/firmware/arm_rmm/Kconfig
new file mode 100644
index 000000000000..6f154f7d55dc
--- /dev/null
+++ b/drivers/firmware/arm_rmm/Kconfig
@@ -0,0 +1,26 @@
+
+config ARCH_SUPPORTS_RMM
+	bool
+
+config ARM_RMM
+	bool "Realm Management Monitor (RMM) Support"
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
index 000000000000..51aef5cc04b0
--- /dev/null
+++ b/drivers/firmware/arm_rmm/Makefile
@@ -0,0 +1,2 @@
+
+obj-$(CONFIG_ARM_RMM)	= rmi.o
diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
new file mode 100644
index 000000000000..008a783407b4
--- /dev/null
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -0,0 +1,101 @@
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
+static __ro_after_init unsigned long rmi_feat_reg_cache[RMI_FEAT_REG_COUNT];
+
+unsigned long rmi_feat_reg(unsigned long id)
+{
+	if (WARN_ON(id >= RMI_FEAT_REG_COUNT))
+		return 0;
+
+	return rmi_feat_reg_cache[id];
+}
+EXPORT_SYMBOL_GPL(rmi_feat_reg);
+
+static int rmi_check_version(void)
+{
+	struct arm_smccc_res res;
+	unsigned short version_major, version_minor;
+	unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
+						     RMI_ABI_MINOR_VERSION);
+	unsigned long aa64pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+
+	/* If RME isn't supported, then RMI can't be */
+	if (cpuid_feature_extract_unsigned_field(aa64pfr0, ID_AA64PFR0_EL1_RME_SHIFT) == 0)
+		return -ENXIO;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
+
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
index 5ee94da96e4a..c97a70e771a6 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -12,6 +12,8 @@
 
 #include <asm/page.h>
 
+unsigned long rmi_feat_reg(unsigned long id);
+
 /**
  * rmi_rmm_config_set() - Configure the RMM
  * @cfg_ptr: PA of a struct rmm_config
-- 
2.43.0

