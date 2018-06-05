From: Abbott Liu <liuwenliang@huawei.com>
Subject: [PATCH v5 6/6] Enable KASan for arm
Date: Tue, 5 Jun 2018 14:14:16 +0800
Message-ID: <20180605061416.18690-7-liuwenliang__21675.4301953644$1528180479$gmane$org@huawei.com>
References: <20180605061416.18690-1-liuwenliang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 818DB4A0F5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jun 2018 02:25:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jDCuaB0L770c for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jun 2018 02:24:41 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 48E9649F87
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jun 2018 02:24:41 -0400 (EDT)
In-Reply-To: <20180605061416.18690-1-liuwenliang@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: aryabinin@virtuozzo.com, glider@google.com, dvyukov@google.com, corbet@lwn.net, linux@armlinux.org.uk, christoffer.dall@arm.com, marc.zyngier@arm.com, arnd@arndb.de, nicolas.pitre@linaro.org, vladimir.murzin@arm.com, keescook@chromium.org, jinb.park7@gmail.com, alexandre.belloni@bootlin.com, ard.biesheuvel@linaro.org, daniel.lezcano@linaro.org, pombredanne@nexb.com, kstewart@linuxfoundation.org, liuwenliang@huawei.com, rob@landley.net, gregkh@linuxfoundation.org, f.fainelli@gmail.com, mawilcox@microsoft.com, akpm@linux-foundation.org, mark.rutland@arm.com, catalin.marinas@arm.com, yamada.masahiro@socionext.com, alexander.levin@verizon.com, tglx@linutronix.de, thgarnie@google.com, dhowells@redhat.com, geert@linux-m68k.org, andre.przywara@arm.com, julien.thierry@arm.com, drjones@redhat.com, philip@cog.sys
Cc: a.ryabinin@samsung.com, ryabinin.a.a@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Andrey Ryabinin <ryabinin@virtuozzo.com>

This patch enable kernel address sanitizer for arm.

Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Joel Stanley <joel@jms.id.au>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Abbott Liu <liuwenliang@huawei.com>
Signed-off-by: Abbott Liu <liuwenliang@huawei.com>
---
 Documentation/dev-tools/kasan.rst | 2 +-
 arch/arm/Kconfig                  | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
index f7a18f2..d92120d 100644
--- a/Documentation/dev-tools/kasan.rst
+++ b/Documentation/dev-tools/kasan.rst
@@ -12,7 +12,7 @@ KASAN uses compile-time instrumentation for checking every memory access,
 therefore you will need a GCC version 4.9.2 or later. GCC 5.0 or later is
 required for detection of out-of-bounds accesses to stack or global variables.
 
-Currently KASAN is supported only for the x86_64 and arm64 architectures.
+Currently KASAN is supported only for the x86_64, arm64 and arm architectures.
 
 Usage
 -----
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a7f8e7f..a43a746 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -50,6 +50,7 @@ config ARM
 	select HAVE_ARCH_BITREVERSE if (CPU_32v7M || CPU_32v7) && !CPU_32v6
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32 && MMU
 	select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32 && MMU
+	select HAVE_ARCH_KASAN if MMU
 	select HAVE_ARCH_MMAP_RND_BITS if MMU
 	select HAVE_ARCH_SECCOMP_FILTER if (AEABI && !OABI_COMPAT)
 	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
-- 
2.9.0
