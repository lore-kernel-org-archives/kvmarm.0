From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 01/13] arm/arm64: Add new is_kernel_in_hyp_mode predicate
Date: Wed,  8 Jul 2015 17:19:04 +0100
Message-ID: <1436372356-30410-2-git-send-email-marc.zyngier@arm.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

With ARMv8.1 VHE extension, it will be possible to run the kernel
at EL2 (aka HYP mode). In order for the kernel to easily find out
where it is running, add a new predicate that returns whether or
not the kernel is in HYP mode.

For completeness, the 32bit code also get such a predicate (always
returning false) so that code common to both architecture (timers,
KVM) can use it transparently.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/virt.h   |  5 +++++
 arch/arm64/include/asm/virt.h | 10 ++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm/include/asm/virt.h b/arch/arm/include/asm/virt.h
index 4371f45..b6a3cef 100644
--- a/arch/arm/include/asm/virt.h
+++ b/arch/arm/include/asm/virt.h
@@ -74,6 +74,11 @@ static inline bool is_hyp_mode_mismatched(void)
 {
 	return !!(__boot_cpu_mode & BOOT_CPU_MODE_MISMATCH);
 }
+
+static inline bool is_kernel_in_hyp_mode(void)
+{
+	return false;
+}
 #endif
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 7a5df52..9f22dd6 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -23,6 +23,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/ptrace.h>
+
 /*
  * __boot_cpu_mode records what mode CPUs were booted in.
  * A correctly-implemented bootloader must start all CPUs in the same mode:
@@ -50,6 +52,14 @@ static inline bool is_hyp_mode_mismatched(void)
 	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
 }
 
+static inline bool is_kernel_in_hyp_mode(void)
+{
+	u64 el;
+
+	asm("mrs %0, CurrentEL" : "=r" (el));
+	return el == CurrentEL_EL2;
+}
+
 /* The section containing the hypervisor text */
 extern char __hyp_text_start[];
 extern char __hyp_text_end[];
-- 
2.1.4
