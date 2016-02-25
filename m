From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 7/8] arm64: compat: Check for AArch32 state
Date: Thu, 25 Feb 2016 09:52:47 +0000
Message-ID: <1456393968-17386-8-git-send-email-suzuki.poulose@arm.com>
References: <1456393968-17386-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CD0049680
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 04:46:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xPFjLkq5wqnV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Feb 2016 04:46:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81F1C411AA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 04:46:25 -0500 (EST)
In-Reply-To: <1456393968-17386-1-git-send-email-suzuki.poulose@arm.com>
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
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, ynorov@caviumnetworks.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Yury Norov <ynorov@caviumnetworks.com>

Make sure we have AArch32 state available for running COMPAT
binaries and also for switching the personality to PER_LINUX32.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
[ Added checks for ELF HWCAP, Use cap bit in cap_hwcaps ]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/elf.h   |    3 ++-
 arch/arm64/kernel/cpufeature.c |    7 +++++--
 arch/arm64/kernel/sys.c        |    4 ++++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index faad6df..a1946f2 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -173,7 +173,8 @@ typedef compat_elf_greg_t		compat_elf_gregset_t[COMPAT_ELF_NGREG];
 
 /* AArch32 EABI. */
 #define EF_ARM_EABI_MASK		0xff000000
-#define compat_elf_check_arch(x)	(((x)->e_machine == EM_ARM) && \
+#define compat_elf_check_arch(x)	(system_supports_32bit_el0() && \
+					 ((x)->e_machine == EM_ARM) && \
 					 ((x)->e_flags & EF_ARM_EABI_MASK))
 
 #define compat_start_thread		compat_start_thread
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 8f6b674..1ae545e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -929,7 +929,8 @@ void verify_local_cpu_capabilities(void)
 
 	verify_local_cpu_features(arm64_features);
 	verify_local_elf_hwcaps(arm64_elf_hwcaps);
-	verify_local_elf_hwcaps(compat_elf_hwcaps);
+	if (system_supports_32bit_el0())
+		verify_local_elf_hwcaps(compat_elf_hwcaps);
 }
 
 static void __init setup_feature_capabilities(void)
@@ -946,7 +947,9 @@ void __init setup_cpu_features(void)
 	/* Set the CPU feature capabilies */
 	setup_feature_capabilities();
 	setup_elf_hwcaps(arm64_elf_hwcaps);
-	setup_elf_hwcaps(compat_elf_hwcaps);
+
+	if (system_supports_32bit_el0())
+		setup_elf_hwcaps(compat_elf_hwcaps);
 
 	/* Advertise that we have computed the system capabilities */
 	set_sys_caps_initialised();
diff --git a/arch/arm64/kernel/sys.c b/arch/arm64/kernel/sys.c
index 817d860..26fe8ea 100644
--- a/arch/arm64/kernel/sys.c
+++ b/arch/arm64/kernel/sys.c
@@ -25,6 +25,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
+#include <asm/cpufeature.h>
 
 asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
 			 unsigned long prot, unsigned long flags,
@@ -38,6 +39,9 @@ asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
 
 SYSCALL_DEFINE1(arm64_personality, unsigned int, personality)
 {
+	if (personality(personality) == PER_LINUX32 &&
+		!system_supports_32bit_el0())
+		return -EINVAL;
 	return sys_personality(personality);
 }
 
-- 
1.7.9.5
