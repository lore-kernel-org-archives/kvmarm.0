From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 6/8] arm64: Add a wrapper for personality() syscall
Date: Thu, 25 Feb 2016 09:52:46 +0000
Message-ID: <1456393968-17386-7-git-send-email-suzuki.poulose@arm.com>
References: <1456393968-17386-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7193D411F6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 04:46:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jkldgNGFrUI0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Feb 2016 04:46:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9E0B49695
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 04:46:23 -0500 (EST)
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

In order to prevent setting PER_LINUX32 on systems without
32bit EL0 support, add a wrapper for personality() syscall.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kernel/sys.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kernel/sys.c b/arch/arm64/kernel/sys.c
index 75151aa..817d860 100644
--- a/arch/arm64/kernel/sys.c
+++ b/arch/arm64/kernel/sys.c
@@ -36,11 +36,17 @@ asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
 	return sys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
 }
 
+SYSCALL_DEFINE1(arm64_personality, unsigned int, personality)
+{
+	return sys_personality(personality);
+}
+
 /*
  * Wrappers to pass the pt_regs argument.
  */
 asmlinkage long sys_rt_sigreturn_wrapper(void);
 #define sys_rt_sigreturn	sys_rt_sigreturn_wrapper
+#define sys_personality		sys_arm64_personality
 
 #undef __SYSCALL
 #define __SYSCALL(nr, sym)	[nr] = sym,
-- 
1.7.9.5
