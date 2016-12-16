From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 10/13] asm-generic: mark cmpxchg as __always_inline for gcc-4.3
Date: Fri, 16 Dec 2016 11:56:31 +0100
Message-ID: <20161216105634.235457-11-arnd@arndb.de>
References: <20161216105634.235457-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEFBE4078A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kagt77ix2676 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Dec 2016 05:55:40 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 900DD4044B
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

With CONFIG_OPTIMIZE_INLINING and older compilers, we can get
a link error such as

kernel/task_work.o: In function `__cmpxchg_local_generic':
task_work.c:(.text+0x14c): undefined reference to `wrong_size_cmpxchg'
kernel/locking/rtmutex.o: In function `__cmpxchg_local_generic':
rtmutex.c:(.text+0x5ec): undefined reference to `wrong_size_cmpxchg'
kernel/trace/ring_buffer.o: In function `__cmpxchg_local_generic':

Marking the functions in question as __always_inline avoids that
possibility.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/cmpxchg-local.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/cmpxchg-local.h b/include/asm-generic/cmpxchg-local.h
index 70bef78912b7..e82d7032b1b8 100644
--- a/include/asm-generic/cmpxchg-local.h
+++ b/include/asm-generic/cmpxchg-local.h
@@ -11,7 +11,8 @@ extern unsigned long wrong_size_cmpxchg(volatile void *ptr)
  * Generic version of __cmpxchg_local (disables interrupts). Takes an unsigned
  * long parameter, supporting various types of architectures.
  */
-static inline unsigned long __cmpxchg_local_generic(volatile void *ptr,
+static __always_inline unsigned long
+__cmpxchg_local_generic(volatile void *ptr,
 		unsigned long old, unsigned long new, int size)
 {
 	unsigned long flags, prev;
@@ -50,8 +51,8 @@ static inline unsigned long __cmpxchg_local_generic(volatile void *ptr,
 /*
  * Generic version of __cmpxchg64_local. Takes an u64 parameter.
  */
-static inline u64 __cmpxchg64_local_generic(volatile void *ptr,
-		u64 old, u64 new)
+static __always_inline u64
+__cmpxchg64_local_generic(volatile void *ptr, u64 old, u64 new)
 {
 	u64 prev;
 	unsigned long flags;
-- 
2.9.0
