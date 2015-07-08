From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 03/13] arm64: Add ARM64_HAS_VIRT_HOST_EXTN feature
Date: Wed,  8 Jul 2015 17:19:06 +0100
Message-ID: <1436372356-30410-4-git-send-email-marc.zyngier@arm.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B40B580C7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:08:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5nMNkqKc6mBD for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2015 12:07:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31CCD580DB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:07:59 -0400 (EDT)
In-Reply-To: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Add a new ARM64_HAS_VIRT_HOST_EXTN features to indicate that the
CPU has the ARMv8,1 VHE capability.

This will be used to trigger kernel patching in KVM.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |  3 ++-
 arch/arm64/kernel/cpufeature.c      | 11 +++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index c104421..6c3742d 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -25,8 +25,9 @@
 #define ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE	1
 #define ARM64_WORKAROUND_845719			2
 #define ARM64_HAS_SYSREG_GIC_CPUIF		3
+#define ARM64_HAS_VIRT_HOST_EXTN		4
 
-#define ARM64_NCAPS				4
+#define ARM64_NCAPS				5
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 5ad86ce..e1dcd63 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -21,6 +21,7 @@
 #include <linux/types.h>
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
+#include <asm/virt.h>
 
 static bool
 has_id_aa64pfr0_feature(const struct arm64_cpu_capabilities *entry)
@@ -31,6 +32,11 @@ has_id_aa64pfr0_feature(const struct arm64_cpu_capabilities *entry)
 	return (val & entry->register_mask) == entry->register_value;
 }
 
+static bool runs_at_el2(const struct arm64_cpu_capabilities *entry)
+{
+	return is_kernel_in_hyp_mode();
+}
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "GIC system register CPU interface",
@@ -39,6 +45,11 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.register_mask = (0xf << 24),
 		.register_value = (1 << 24),
 	},
+	{
+		.desc = "Virtualization Host Extensions",
+		.capability = ARM64_HAS_VIRT_HOST_EXTN,
+		.matches = runs_at_el2,
+	},
 	{},
 };
 
-- 
2.1.4
