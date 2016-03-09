From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 34/95] arm64: Add ARM64_HAS_VIRT_HOST_EXTN feature
Date: Wed,  9 Mar 2016 07:30:28 +0000
Message-ID: <1457508689-19672-35-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63D3C41145
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:33:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4WS8gkOc7lzJ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:33:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B84549B44
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:33:21 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Add a new ARM64_HAS_VIRT_HOST_EXTN features to indicate that the
CPU has the ARMv8.1 VHE capability.

This will be used to trigger kernel patching in KVM.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |  6 +++++-
 arch/arm64/kernel/cpufeature.c      | 11 +++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 8f271b8..a5c769b 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -30,8 +30,12 @@
 #define ARM64_HAS_LSE_ATOMICS			5
 #define ARM64_WORKAROUND_CAVIUM_23154		6
 #define ARM64_WORKAROUND_834220			7
+/* #define ARM64_HAS_NO_HW_PREFETCH		8 */
+/* #define ARM64_HAS_UAO			9 */
+/* #define ARM64_ALT_PAN_NOT_UAO		10 */
+#define ARM64_HAS_VIRT_HOST_EXTN		11
 
-#define ARM64_NCAPS				8
+#define ARM64_NCAPS				12
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 5c90aa4..ba74519 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -26,6 +26,7 @@
 #include <asm/cpu_ops.h>
 #include <asm/processor.h>
 #include <asm/sysreg.h>
+#include <asm/virt.h>
 
 unsigned long elf_hwcap __read_mostly;
 EXPORT_SYMBOL_GPL(elf_hwcap);
@@ -621,6 +622,11 @@ static bool has_useable_gicv3_cpuif(const struct arm64_cpu_capabilities *entry)
 	return has_sre;
 }
 
+static bool runs_at_el2(const struct arm64_cpu_capabilities *entry)
+{
+	return is_kernel_in_hyp_mode();
+}
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "GIC system register CPU interface",
@@ -651,6 +657,11 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = 2,
 	},
 #endif /* CONFIG_AS_LSE && CONFIG_ARM64_LSE_ATOMICS */
+	{
+		.desc = "Virtualization Host Extensions",
+		.capability = ARM64_HAS_VIRT_HOST_EXTN,
+		.matches = runs_at_el2,
+	},
 	{},
 };
 
-- 
2.1.4
