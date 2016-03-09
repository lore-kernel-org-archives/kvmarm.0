From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 32/95] arm/arm64: Add new is_kernel_in_hyp_mode predicate
Date: Wed,  9 Mar 2016 07:30:26 +0000
Message-ID: <1457508689-19672-33-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48616412D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:33:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8Dafw00j1-Zg for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:33:15 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23CB648531
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:33:15 -0500 (EST)
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

With ARMv8.1 VHE extension, it will be possible to run the kernel
at EL2 (aka HYP mode). In order for the kernel to easily find out
where it is running, add a new predicate that returns whether or
not the kernel is in HYP mode.

For completeness, the 32bit code also get such a predicate (always
returning false) so that code common to both architecture (timers,
KVM) can use it transparently.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/virt.h   |  5 +++++
 arch/arm64/include/asm/virt.h | 10 ++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm/include/asm/virt.h b/arch/arm/include/asm/virt.h
index 5fdbfea..d4ceaf5 100644
--- a/arch/arm/include/asm/virt.h
+++ b/arch/arm/include/asm/virt.h
@@ -75,6 +75,11 @@ static inline bool is_hyp_mode_mismatched(void)
 	return !!(__boot_cpu_mode & BOOT_CPU_MODE_MISMATCH);
 }
 
+static inline bool is_kernel_in_hyp_mode(void)
+{
+	return false;
+}
+
 /* The section containing the hypervisor text */
 extern char __hyp_text_start[];
 extern char __hyp_text_end[];
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
