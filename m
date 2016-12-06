From: Wei Huang <wei@redhat.com>
Subject: [kvm-unit-tests PATCH v14 1/5] arm: rename cp15.h to sysreg.h
Date: Tue,  6 Dec 2016 12:05:24 -0600
Message-ID: <1481047528-16180-2-git-send-email-wei@redhat.com>
References: <1481047528-16180-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1481047528-16180-1-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: cov@codeaurora.org
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org, alistair.francis@xilinx.com, croberts@codeaurora.org, alindsay@codeaurora.org, drjones@redhat.com, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

To prepare for future support of ARMv8 system register, rename cp15.h file
to sysreg.h, with _ASMARM_CP15_H_ renamed to _ASMARM_SYSREG_H_ in header
file.

Signed-off-by: Wei Huang <wei@redhat.com>
---
 arm/cstart.S                     | 2 +-
 lib/arm/asm/{cp15.h => sysreg.h} | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)
 rename lib/arm/asm/{cp15.h => sysreg.h} (94%)

diff --git a/arm/cstart.S b/arm/cstart.S
index 3943867..9822fb7 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -9,7 +9,7 @@
 #include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
 #include <asm/ptrace.h>
-#include <asm/cp15.h>
+#include <asm/sysreg.h>
 
 #define THREAD_START_SP ((THREAD_SIZE - S_FRAME_SIZE * 8) & ~7)
 
diff --git a/lib/arm/asm/cp15.h b/lib/arm/asm/sysreg.h
similarity index 94%
rename from lib/arm/asm/cp15.h
rename to lib/arm/asm/sysreg.h
index 7690a48..3e1ad3a 100644
--- a/lib/arm/asm/cp15.h
+++ b/lib/arm/asm/sysreg.h
@@ -1,5 +1,5 @@
-#ifndef _ASMARM_CP15_H_
-#define _ASMARM_CP15_H_
+#ifndef _ASMARM_SYSREG_H_
+#define _ASMARM_SYSREG_H_
 /*
  * From the Linux kernel arch/arm/include/asm/cp15.h
  *
@@ -34,4 +34,4 @@
 #define CR_AFE	(1 << 29)	/* Access flag enable			*/
 #define CR_TE	(1 << 30)	/* Thumb exception enable		*/
 
-#endif /* _ASMARM_CP15_H_ */
+#endif /* _ASMARM_SYSREG_H_ */
-- 
1.8.3.1

