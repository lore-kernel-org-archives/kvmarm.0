From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 1/2] arm64: Add hypervisor safe helper for checking constant capabilities
Date: Tue, 25 Oct 2016 14:50:32 +0100
Message-ID: <1477403433-2279-2-git-send-email-suzuki.poulose@arm.com>
References: <1477403433-2279-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477403433-2279-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, ard.biesheuvel@linaro.org, mark.rutland@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The hypervisor may not have full access to the kernel data structures
and hence cannot safely use cpus_have_cap() helper for checking the
system capability. Add a safe helper for hypervisors to check a constant
system capability, which *doesn't* fall back to checking the bitmap
maintained by the kernel.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 758d74f..ae5e994 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -9,8 +9,6 @@
 #ifndef __ASM_CPUFEATURE_H
 #define __ASM_CPUFEATURE_H
 
-#include <linux/jump_label.h>
-
 #include <asm/hwcap.h>
 #include <asm/sysreg.h>
 
@@ -45,6 +43,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/bug.h>
+#include <linux/jump_label.h>
 #include <linux/kernel.h>
 
 /* CPU feature register tracking */
@@ -122,6 +122,16 @@ static inline bool cpu_have_feature(unsigned int num)
 	return elf_hwcap & (1UL << num);
 }
 
+/* System capability check for constant caps */
+static inline bool cpus_have_const_cap(int num)
+{
+	if (__builtin_constant_p(num))
+		return static_branch_unlikely(&cpu_hwcap_keys[num]);
+	BUILD_BUG();
+	/* unreachable */
+	return false;
+}
+
 static inline bool cpus_have_cap(unsigned int num)
 {
 	if (num >= ARM64_NCAPS)
@@ -218,7 +228,7 @@ static inline bool cpu_supports_mixed_endian_el0(void)
 
 static inline bool system_supports_32bit_el0(void)
 {
-	return cpus_have_cap(ARM64_HAS_32BIT_EL0);
+	return cpus_have_const_cap(ARM64_HAS_32BIT_EL0);
 }
 
 static inline bool system_supports_mixed_endian_el0(void)
-- 
2.7.4
