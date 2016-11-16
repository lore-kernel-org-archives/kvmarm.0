From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH] arm/arm64: introduce is_aarch32
Date: Wed, 16 Nov 2016 15:38:36 +0100
Message-ID: <1479307116-6355-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00641401B9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2016 09:38:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rs3yTC9udo-H for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2016 09:38:10 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DFAA940190
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2016 09:38:10 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

ARMv7-A isn't exactly the same as ARMv8-A32 (AArch32). This
function allows unit tests to make the distinction.

Signed-off-by: Andrew Jones <drjones@redhat.com>

---
I'm actually unsure if there's a feature bit or not that I could
probe instead. It'd be nice if somebody can confirm. Thanks, drew

 lib/arm/asm/processor.h   | 20 ++++++++++++++++++++
 lib/arm64/asm/processor.h |  5 +++++
 2 files changed, 25 insertions(+)

diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index f25e7eee3666..223e54beb72a 100644
--- a/lib/arm/asm/processor.h
+++ b/lib/arm/asm/processor.h
@@ -5,6 +5,7 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
+#include <bitops.h>
 #include <asm/ptrace.h>
 
 enum vector {
@@ -46,4 +47,23 @@ static inline unsigned int get_mpidr(void)
 extern void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr);
 extern bool is_user(void);
 
+/*
+ * ARMv7-A isn't exactly the same as ARMv8-A32 (AArch32). This
+ * function allows unit tests to make the distinction.
+ */
+static inline bool is_aarch32(void)
+{
+	/*
+	 * XXX: Unfortunately there's no feature bit we can probe for
+	 * this, so we do a hacky check for the processor type not being
+	 * a Cortex-A15, which is the only v7 type we currently use.
+	 */
+	unsigned long midr;
+
+	asm volatile("MRC p15, 0, %0, c0, c0, 0" : "=r" (midr));
+	midr &= GENMASK(31, 24) | GENMASK(15, 4);
+
+	return midr != ((0x41 << 24) | (0xc0f << 4));
+}
+
 #endif /* _ASMARM_PROCESSOR_H_ */
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 84d5c7ce752b..b602e1fbbc2d 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -81,5 +81,10 @@ DEFINE_GET_SYSREG32(mpidr)
 extern void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr);
 extern bool is_user(void);
 
+static inline bool is_aarch32(void)
+{
+	return false;
+}
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM64_PROCESSOR_H_ */
-- 
2.7.4
