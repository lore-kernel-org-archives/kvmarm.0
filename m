From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvm-unit-tests PATCH v2 1/4] mark exit() and abort() as
 non-returning functions
Date: Fri, 20 Jul 2018 16:39:39 +0100
Message-ID: <20180720153942.26821-2-andre.przywara@arm.com>
References: <20180720153942.26821-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73C0B4A0CB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jul 2018 11:26:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ixe14L5vQnCl for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Jul 2018 11:26:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D04040196
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jul 2018 11:26:44 -0400 (EDT)
In-Reply-To: <20180720153942.26821-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

exit() and abort() are functions that never return, and (at least)
GCC has an attribute to flag those functions accordingly. This allows
the compiler to do further optimizations and to omit various warnings
about uninitialized variables, for instance.
Since the actual "play-dead" function is in (inline) assembly, the
compiler does not recognize its fatal nature, so help it with the
__builtin_unreachable() hint.
Flag the prototypes of our fatal functions accordingly.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 lib/arm/io.c     | 1 +
 lib/libcflat.h   | 7 ++++---
 lib/powerpc/io.c | 1 +
 lib/x86/io.c     | 1 +
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/lib/arm/io.c b/lib/arm/io.c
index 603456f..d2c1a07 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -83,4 +83,5 @@ void exit(int code)
 {
 	chr_testdev_exit(code);
 	halt(code);
+	__builtin_unreachable();
 }
diff --git a/lib/libcflat.h b/lib/libcflat.h
index cc56553..7529958 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -84,8 +84,8 @@ typedef u64			phys_addr_t;
 extern void puts(const char *s);
 extern int __getchar(void);
 extern int getchar(void);
-extern void exit(int code);
-extern void abort(void);
+extern void exit(int code) __attribute__((noreturn));
+extern void abort(void) __attribute__((noreturn));
 extern long atol(const char *ptr);
 extern char *getenv(const char *name);
 
@@ -107,7 +107,8 @@ extern void report(const char *msg_fmt, bool pass, ...)
 extern void report_xfail(const char *msg_fmt, bool xfail, bool pass, ...)
 					__attribute__((format(printf, 1, 4)));
 extern void report_abort(const char *msg_fmt, ...)
-					__attribute__((format(printf, 1, 2)));
+					__attribute__((format(printf, 1, 2)))
+					__attribute__((noreturn));
 extern void report_skip(const char *msg_fmt, ...)
 					__attribute__((format(printf, 1, 2)));
 extern void report_info(const char *msg_fmt, ...)
diff --git a/lib/powerpc/io.c b/lib/powerpc/io.c
index 915e12e..217eb07 100644
--- a/lib/powerpc/io.c
+++ b/lib/powerpc/io.c
@@ -35,4 +35,5 @@ void exit(int code)
 	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
 	rtas_power_off();
 	halt(code);
+	__builtin_unreachable();
 }
diff --git a/lib/x86/io.c b/lib/x86/io.c
index 7e1c16d..057f579 100644
--- a/lib/x86/io.c
+++ b/lib/x86/io.c
@@ -82,6 +82,7 @@ void exit(int code)
 #else
         asm volatile("out %0, %1" : : "a"(code), "d"((short)0xf4));
 #endif
+	__builtin_unreachable();
 }
 
 void __iomem *ioremap(phys_addr_t phys_addr, size_t size)
-- 
2.14.4
