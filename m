From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 13/13] ARM: avoid 'Q' asm constraint for gcc-4.1 and earlier
Date: Fri, 16 Dec 2016 11:56:34 +0100
Message-ID: <20161216105634.235457-14-arnd@arndb.de>
References: <20161216105634.235457-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A93454075C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0cFQsejnG8li for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Dec 2016 05:55:50 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5090540822
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:42 -0500 (EST)
In-Reply-To: <20161216105634.235457-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, kernel-build-reports@lists.linaro.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Building with ancient gcc versions results in a stream of build errors
like:

arch/arm/include/asm/io.h:100: error: impossible constraint in 'asm'
arch/arm/include/asm/io.h:118: error: impossible constraint in 'asm'

This reverts to an older version of __raw_readl, __raw_writel
and __my_cpu_offset, which seem to be the only functions affected
by this.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/io.h     | 8 ++++++++
 arch/arm/include/asm/percpu.h | 5 ++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 6f89a4d9fc85..d0f89c4cb8e2 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -97,8 +97,12 @@ static inline void __raw_writeb(u8 val, volatile void __iomem *addr)
 #define __raw_writel __raw_writel
 static inline void __raw_writel(u32 val, volatile void __iomem *addr)
 {
+#if GCC_VERSION < 40200
+	*(volatile u32 __force *)addr = val;
+#else
 	asm volatile("str %1, %0"
 		     : : "Qo" (*(volatile u32 __force *)addr), "r" (val));
+#endif
 }
 
 #define __raw_readb __raw_readb
@@ -115,9 +119,13 @@ static inline u8 __raw_readb(const volatile void __iomem *addr)
 static inline u32 __raw_readl(const volatile void __iomem *addr)
 {
 	u32 val;
+#if GCC_VERSION < 40200
+	val = *(volatile u32 __force *)addr;
+#else
 	asm volatile("ldr %0, %1"
 		     : "=r" (val)
 		     : "Qo" (*(volatile u32 __force *)addr));
+#endif
 	return val;
 }
 
diff --git a/arch/arm/include/asm/percpu.h b/arch/arm/include/asm/percpu.h
index a89b4076cde4..dee4c89b4458 100644
--- a/arch/arm/include/asm/percpu.h
+++ b/arch/arm/include/asm/percpu.h
@@ -36,9 +36,12 @@ static inline unsigned long __my_cpu_offset(void)
 	 * We want to allow caching the value, so avoid using volatile and
 	 * instead use a fake stack read to hazard against barrier().
 	 */
+#if GCC_VERSION < 40200
+	asm("mrc p15, 0, %0, c13, c0, 4" : "=r" (off) : : "memory");
+#else
 	asm("mrc p15, 0, %0, c13, c0, 4" : "=r" (off)
 		: "Q" (*(const unsigned long *)current_stack_pointer));
-
+#endif
 	return off;
 }
 #define __my_cpu_offset __my_cpu_offset()
-- 
2.9.0
