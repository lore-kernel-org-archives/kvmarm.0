From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 2/3] arm64: Add hypervisor safe helper for checking
 constant capabilities
Date: Mon, 31 Oct 2016 16:03:44 +0000
Message-ID: <1477929825-5907-3-git-send-email-suzuki.poulose@arm.com>
References: <1477929825-5907-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACAEB40430
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Oct 2016 12:04:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DDK-WdC5kvyS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Oct 2016 12:04:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0478040416
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Oct 2016 12:04:01 -0400 (EDT)
In-Reply-To: <1477929825-5907-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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
