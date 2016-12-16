From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 09/13] ARM: mark cmpxchg and xchg __always_inline for gcc-4.3
Date: Fri, 16 Dec 2016 11:56:30 +0100
Message-ID: <20161216105634.235457-10-arnd@arndb.de>
References: <20161216105634.235457-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18864405E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xdEWhyCOqXsx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Dec 2016 05:55:40 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A1EA40664
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:40 -0500 (EST)
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

With older compiler versions like gcc-4.3 and CONFIG_OPTIMIZE_INLINING,
I run into link errors:

kernel/task_work.o: In function `__cmpxchg':
task_work.c:(.text+0x8c): undefined reference to `__bad_cmpxchg'
kernel/kthread.o: In function `__xchg':
kthread.c:(.text+0x7bc): undefined reference to `__bad_xchg'

This marks the functions in question as __always_inline to force
inlining.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/cmpxchg.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/cmpxchg.h b/arch/arm/include/asm/cmpxchg.h
index 12215515ba02..218ba0ae90cd 100644
--- a/arch/arm/include/asm/cmpxchg.h
+++ b/arch/arm/include/asm/cmpxchg.h
@@ -24,7 +24,8 @@
 #define swp_is_buggy
 #endif
 
-static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size)
+static __always_inline unsigned long
+__xchg(unsigned long x, volatile void *ptr, int size)
 {
 	extern void __bad_xchg(volatile void *, int);
 	unsigned long ret;
@@ -152,8 +153,8 @@ extern void __bad_cmpxchg(volatile void *ptr, int size);
  * cmpxchg only support 32-bits operands on ARMv6.
  */
 
-static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
+static __always_inline unsigned long
+__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new, int size)
 {
 	unsigned long oldval, res;
 
@@ -213,9 +214,8 @@ static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
 				      sizeof(*(ptr)));			\
 })
 
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-					    unsigned long old,
-					    unsigned long new, int size)
+static __always_inline unsigned long
+__cmpxchg_local(volatile void *ptr, unsigned long old, unsigned long new, int size)
 {
 	unsigned long ret;
 
-- 
2.9.0
