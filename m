Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 240F62EBB89;
	Wed, 13 May 2026 13:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778678334; cv=none; b=D5RSRakF1FbVPrsia153lklx70wf5JSGOsVWCvuuvj8kxCcGn4DTJCDszmbRZwI/pu6pdV5dbHUby86W79r3++b8FZGkQig9eNvNbteRaYWzQyXZTlZtM2co0YLIPORZqk9Htxr1vQpMV3LIEeCgHGyYkgM5EBT+9c+uTVxn52U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778678334; c=relaxed/simple;
	bh=jLQ4y6Fs7cghe1no72DYDaK6wwzE2W/EDRGN3XEo8/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bj5tZuU7ag+lD+eNIfAUpNlagKbPNwDrYxue2NlXXt46q+s+aBSPQOgvh+q1mhTyOtMnOx0Eh1DC3r+RIQOkaQsuzGZw77B1m5ury5nWSaLtdgUxG2Ls+h9rXTZ6/mh+PLy/T7FQ+TDgb6cEkeHFp7AODlKQebhhjcxEtN6xXuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ma+6UibO; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ma+6UibO"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A6AB237B;
	Wed, 13 May 2026 06:18:46 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.68.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5671C3F836;
	Wed, 13 May 2026 06:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778678331; bh=jLQ4y6Fs7cghe1no72DYDaK6wwzE2W/EDRGN3XEo8/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ma+6UibOwlp7Ggzq9tqM83+0UamZmigpbOs3vlMG0GTg9U63KYgbps4mLrPP7Hc9W
	 jYomBrP59YaUmA4EydjEo8MxNxJTYV01mvcBT/mDL1bon+GBgaY1FTVSlLQcUKtKHO
	 gPnxq9EftFQLfdFUMYFM8FWxIFT2A5c41C3S4ltU=
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
	Lorenzo.Pieralisi2@arm.com
Subject: [PATCH v14 06/44] arm64: RMI: Check for RMI support at init
Date: Wed, 13 May 2026 14:17:14 +0100
Message-ID: <20260513131757.116630-7-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513131757.116630-1-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
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
v14:
 * This moves the basic RMI setup into the 'kernel' directory. This is
   because RMI will be used for some features outside of KVM so should
   be available even if KVM isn't compiled in.
---
 arch/arm64/include/asm/rmi_cmds.h |  3 ++
 arch/arm64/kernel/Makefile        |  2 +-
 arch/arm64/kernel/cpufeature.c    |  1 +
 arch/arm64/kernel/rmi.c           | 65 +++++++++++++++++++++++++++++++
 4 files changed, 70 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kernel/rmi.c

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index 04f7066894e9..9179934925c5 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -10,6 +10,9 @@
 
 #include <asm/rmi_smc.h>
 
+extern unsigned long rmm_feat_reg0;
+extern unsigned long rmm_feat_reg1;
+
 struct rtt_entry {
 	unsigned long walk_level;
 	unsigned long desc;
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 74b76bb70452..d68f351aae75 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -34,7 +34,7 @@ obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   cpufeature.o alternative.o cacheinfo.o		\
 			   smp.o smp_spin_table.o topology.o smccc-call.o	\
 			   syscall.o proton-pack.o idle.o patching.o pi/	\
-			   rsi.o jump_label.o
+			   rsi.o jump_label.o rmi.o
 
 obj-$(CONFIG_COMPAT)			+= sys32.o signal32.o			\
 					   sys_compat.o
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6d53bb15cf7b..8bdd95a8c2de 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -292,6 +292,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar3[] = {
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV2_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_RME_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_DIT_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_AMU_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_MPAM_SHIFT, 4, 0),
diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
new file mode 100644
index 000000000000..99c1ccc35c11
--- /dev/null
+++ b/arch/arm64/kernel/rmi.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2023-2025 ARM Ltd.
+ */
+
+#include <linux/memblock.h>
+
+#include <asm/rmi_cmds.h>
+
+unsigned long rmm_feat_reg0;
+unsigned long rmm_feat_reg1;
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
+static int __init arm64_init_rmi(void)
+{
+	/* Continue without realm support if we can't agree on a version */
+	if (rmi_check_version())
+		return 0;
+
+	if (WARN_ON(rmi_features(0, &rmm_feat_reg0)))
+		return 0;
+	if (WARN_ON(rmi_features(1, &rmm_feat_reg1)))
+		return 0;
+
+	return 0;
+}
+subsys_initcall(arm64_init_rmi);
-- 
2.43.0

