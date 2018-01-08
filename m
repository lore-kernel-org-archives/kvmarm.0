From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v6 09/16] arm64: uaccess: Add PAN helper
Date: Mon,  8 Jan 2018 15:38:11 +0000
Message-ID: <20180108153818.22743-10-james.morse@arm.com>
References: <20180108153818.22743-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108153818.22743-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, Heyi Guo <guoheyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Add __uaccess_{en,dis}able_hw_pan() helpers to set/clear the PSTATE.PAN
bit.

Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
---
 arch/arm64/include/asm/uaccess.h | 12 ++++++++++++
 arch/arm64/kernel/suspend.c      |  4 ++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 6eadf55ebaf0..3821fab01d7d 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -168,6 +168,18 @@ static inline bool uaccess_ttbr0_enable(void)
 }
 #endif
 
+static inline void __uaccess_disable_hw_pan(void)
+{
+	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), ARM64_HAS_PAN,
+			CONFIG_ARM64_PAN));
+}
+
+static inline void __uaccess_enable_hw_pan(void)
+{
+	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,
+			CONFIG_ARM64_PAN));
+}
+
 #define __uaccess_disable(alt)						\
 do {									\
 	if (!uaccess_ttbr0_disable())					\
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index 3fe5ad884418..a307b9e13392 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -2,6 +2,7 @@
 #include <linux/ftrace.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
+#include <linux/uaccess.h>
 #include <asm/alternative.h>
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
@@ -51,8 +52,7 @@ void notrace __cpu_suspend_exit(void)
 	 * PSTATE was not saved over suspend/resume, re-enable any detected
 	 * features that might not have been set correctly.
 	 */
-	asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,
-			CONFIG_ARM64_PAN));
+	__uaccess_enable_hw_pan();
 	uao_thread_switch(current);
 
 	/*
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
