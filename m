Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3931F91D6
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 02:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768789872; cv=none; b=C4WfmJzVXD1lkGXrszoqdVvLAkl7hmNR63gtmG+4wd/WjLw7NLYS9L29OHsRKXt4KxUn2E4yIpjU1M/udzjNwQjIF99UUibddmE9VpLCCfy6EE9hM58P220+k5QyH8lfZIE8lL3qQh4jqzI16Yqq316asbiRO/4kjefvPaE+rfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768789872; c=relaxed/simple;
	bh=xTk2X0bmbOkUt7/Wyq3aZ7cqHvw/RQzEjB8zWL/SKYM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XdhN6oFzFcQF3YJlmnbRrnglMvcMKf76eHKPNuNYoYjZEY5rGunBbf/LA8o3h0GtY0dl9c+4NbbeyMtV4T4Hvu8uwKIWXx/bnPZK9ci86HFm0ojdZHBf9ruJX/SPkPZQITsEVydeEcyIDJ+4BCr69rIoA+IKgDk000SwuT2VqFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dvZ990xQdzcbQP;
	Mon, 19 Jan 2026 10:27:09 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 382CD4056A;
	Mon, 19 Jan 2026 10:31:02 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 19 Jan 2026 10:31:01 +0800
Received: from huawei.com (10.90.31.46) by kwepemq200004.china.huawei.com
 (7.202.195.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 19 Jan
 2026 10:31:01 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <arnd@arndb.de>, <joey.gouly@arm.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH v8 RESEND 6/7] arm64: Add support for FEAT_{LS64, LS64_V}
Date: Mon, 19 Jan 2026 10:29:27 +0800
Message-ID: <20260119022928.149358-7-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20260119022928.149358-1-wangzhou1@hisilicon.com>
References: <20260119022928.149358-1-wangzhou1@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200004.china.huawei.com (7.202.195.237)

From: Yicong Yang <yangyicong@hisilicon.com>

Armv8.7 introduces single-copy atomic 64-byte loads and stores
instructions and its variants named under FEAT_{LS64, LS64_V}.
These features are identified by ID_AA64ISAR1_EL1.LS64 and the
use of such instructions in userspace (EL0) can be trapped.

As st64bv (FEAT_LS64_V) and st64bv0 (FEAT_LS64_ACCDATA) can not be tell
apart, FEAT_LS64 and FEAT_LS64_ACCDATA which will be supported in later
patch will be exported to userspace, FEAT_LS64_V will be enabled only
in kernel.

In order to support the use of corresponding instructions in userspace:
- Make ID_AA64ISAR1_EL1.LS64 visbile to userspace
- Add identifying and enabling in the cpufeature list
- Expose these support of these features to userspace through HWCAP3
  and cpuinfo

ld64b/st64b (FEAT_LS64) and st64bv (FEAT_LS64_V) is intended for
special memory (device memory) so requires support by the CPU, system
and target memory location (device that support these instructions).
The HWCAP3_LS64, implies the support of CPU and system (since no
identification method from system, so SoC vendors should advertise
support in the CPU if system also support them).

Otherwise for ld64b/st64b the atomicity may not be guaranteed or a
DABT will be generated, so users (probably userspace driver developer)
should make sure the target memory (device) also have the support.
For st64bv 0xffffffffffffffff will be returned as status result for
unsupported memory so user should check it.

Document the restrictions along with HWCAP3_LS64.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 Documentation/arch/arm64/booting.rst    | 12 +++++++++++
 Documentation/arch/arm64/elf_hwcaps.rst |  7 +++++++
 arch/arm64/include/asm/hwcap.h          |  1 +
 arch/arm64/include/uapi/asm/hwcap.h     |  1 +
 arch/arm64/kernel/cpufeature.c          | 28 +++++++++++++++++++++++++
 arch/arm64/kernel/cpuinfo.c             |  1 +
 arch/arm64/tools/cpucaps                |  2 ++
 7 files changed, 52 insertions(+)

diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
index 26efca09aef3..13ef311dace8 100644
--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -556,6 +556,18 @@ Before jumping into the kernel, the following conditions must be met:
 
    - MDCR_EL3.TPM (bit 6) must be initialized to 0b0
 
+  For CPUs with support for 64-byte loads and stores without status (FEAT_LS64):
+
+  - If the kernel is entered at EL1 and EL2 is present:
+
+    - HCRX_EL2.EnALS (bit 1) must be initialised to 0b1.
+
+  For CPUs with support for 64-byte stores with status (FEAT_LS64_V):
+
+  - If the kernel is entered at EL1 and EL2 is present:
+
+    - HCRX_EL2.EnASR (bit 2) must be initialised to 0b1.
+
 The requirements described above for CPU mode, caches, MMUs, architected
 timers, coherency and system registers apply to all CPUs.  All CPUs must
 enter the kernel in the same exception level.  Where the values documented
diff --git a/Documentation/arch/arm64/elf_hwcaps.rst b/Documentation/arch/arm64/elf_hwcaps.rst
index a15df4956849..97315ae6c0da 100644
--- a/Documentation/arch/arm64/elf_hwcaps.rst
+++ b/Documentation/arch/arm64/elf_hwcaps.rst
@@ -444,6 +444,13 @@ HWCAP3_MTE_STORE_ONLY
 HWCAP3_LSFE
     Functionality implied by ID_AA64ISAR3_EL1.LSFE == 0b0001
 
+HWCAP3_LS64
+    Functionality implied by ID_AA64ISAR1_EL1.LS64 == 0b0001. Note that
+    the function of instruction ld64b/st64b requires support by CPU, system
+    and target (device) memory location and HWCAP3_LS64 implies the support
+    of CPU. User should only use ld64b/st64b on supported target (device)
+    memory location, otherwise fallback to the non-atomic alternatives.
+
 
 4. Unused AT_HWCAP bits
 -----------------------
diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index 1f63814ae6c4..72ea4bda79f3 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -179,6 +179,7 @@
 #define KERNEL_HWCAP_MTE_FAR		__khwcap3_feature(MTE_FAR)
 #define KERNEL_HWCAP_MTE_STORE_ONLY	__khwcap3_feature(MTE_STORE_ONLY)
 #define KERNEL_HWCAP_LSFE		__khwcap3_feature(LSFE)
+#define KERNEL_HWCAP_LS64		__khwcap3_feature(LS64)
 
 /*
  * This yields a mask that user programs can use to figure out what
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index 575564ecdb0b..06f83ca8de56 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -146,5 +146,6 @@
 #define HWCAP3_MTE_FAR		(1UL << 0)
 #define HWCAP3_MTE_STORE_ONLY		(1UL << 1)
 #define HWCAP3_LSFE		(1UL << 2)
+#define HWCAP3_LS64		(1UL << 3)
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c840a93b9ef9..6cab77e2ffa9 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -240,6 +240,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_LS64_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_XS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_I8MM_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_DGH_SHIFT, 4, 0),
@@ -2260,6 +2261,16 @@ static void cpu_enable_e0pd(struct arm64_cpu_capabilities const *cap)
 }
 #endif /* CONFIG_ARM64_E0PD */
 
+static void cpu_enable_ls64(struct arm64_cpu_capabilities const *cap)
+{
+	sysreg_clear_set(sctlr_el1, SCTLR_EL1_EnALS, SCTLR_EL1_EnALS);
+}
+
+static void cpu_enable_ls64_v(struct arm64_cpu_capabilities const *cap)
+{
+	sysreg_clear_set(sctlr_el1, SCTLR_EL1_EnASR, 0);
+}
+
 #ifdef CONFIG_ARM64_PSEUDO_NMI
 static bool can_use_gic_priorities(const struct arm64_cpu_capabilities *entry,
 				   int scope)
@@ -3148,6 +3159,22 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, XNX, IMP)
 	},
+	{
+		.desc = "LS64",
+		.capability = ARM64_HAS_LS64,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		.cpu_enable = cpu_enable_ls64,
+		ARM64_CPUID_FIELDS(ID_AA64ISAR1_EL1, LS64, LS64)
+	},
+	{
+		.desc = "LS64_V",
+		.capability = ARM64_HAS_LS64_V,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		.cpu_enable = cpu_enable_ls64_v,
+		ARM64_CPUID_FIELDS(ID_AA64ISAR1_EL1, LS64, LS64_V)
+	},
 	{},
 };
 
@@ -3267,6 +3294,7 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 	HWCAP_CAP(ID_AA64ISAR1_EL1, BF16, EBF16, CAP_HWCAP, KERNEL_HWCAP_EBF16),
 	HWCAP_CAP(ID_AA64ISAR1_EL1, DGH, IMP, CAP_HWCAP, KERNEL_HWCAP_DGH),
 	HWCAP_CAP(ID_AA64ISAR1_EL1, I8MM, IMP, CAP_HWCAP, KERNEL_HWCAP_I8MM),
+	HWCAP_CAP(ID_AA64ISAR1_EL1, LS64, LS64, CAP_HWCAP, KERNEL_HWCAP_LS64),
 	HWCAP_CAP(ID_AA64ISAR2_EL1, LUT, IMP, CAP_HWCAP, KERNEL_HWCAP_LUT),
 	HWCAP_CAP(ID_AA64ISAR3_EL1, FAMINMAX, IMP, CAP_HWCAP, KERNEL_HWCAP_FAMINMAX),
 	HWCAP_CAP(ID_AA64ISAR3_EL1, LSFE, IMP, CAP_HWCAP, KERNEL_HWCAP_LSFE),
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index c44e6d94f5de..6149bc91251d 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -81,6 +81,7 @@ static const char *const hwcap_str[] = {
 	[KERNEL_HWCAP_PACA]		= "paca",
 	[KERNEL_HWCAP_PACG]		= "pacg",
 	[KERNEL_HWCAP_GCS]		= "gcs",
+	[KERNEL_HWCAP_LS64]		= "ls64",
 	[KERNEL_HWCAP_DCPODP]		= "dcpodp",
 	[KERNEL_HWCAP_SVE2]		= "sve2",
 	[KERNEL_HWCAP_SVEAES]		= "sveaes",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 0fac75f01534..50a0c695f340 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -46,6 +46,8 @@ HAS_HCX
 HAS_LDAPR
 HAS_LPA2
 HAS_LSE_ATOMICS
+HAS_LS64
+HAS_LS64_V
 HAS_MOPS
 HAS_NESTED_VIRT
 HAS_BBML2_NOABORT
-- 
2.33.0

