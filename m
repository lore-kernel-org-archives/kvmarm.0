From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH] lib: arm: Use correct halt() prototype from
 smp.h
Date: Mon,  8 Apr 2019 16:11:25 +0100
Message-ID: <20190408151125.32080-1-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 649644A426
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 11:11:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q10ZgDEqrD5F for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 11:11:40 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CE664A3B3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 11:11:40 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The prototype for the halt() function is incorrect, because halt() doesn't
take any arguments. Fix it by using the prototype from smp.h.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/arm/io.c b/lib/arm/io.c
index 8226b765bdc5..6d3d7afed002 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -15,11 +15,10 @@
 #include <asm/psci.h>
 #include <asm/spinlock.h>
 #include <asm/io.h>
+#include <asm/smp.h>
 
 #include "io.h"
 
-extern void halt(int code);
-
 static struct spinlock uart_lock;
 /*
  * Use this guess for the uart base in order to make an attempt at
@@ -93,6 +92,6 @@ void exit(int code)
 {
 	chr_testdev_exit(code);
 	psci_system_off();
-	halt(code);
+	halt();
 	__builtin_unreachable();
 }
-- 
2.17.0
