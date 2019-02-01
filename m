From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH v2 5/5] lib: arm: Fallback to psci_system_off()
 in exit()
Date: Fri,  1 Feb 2019 11:16:41 +0000
Message-ID: <20190201111641.8299-6-alexandru.elisei@arm.com>
References: <20190201111641.8299-1-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D56B14A391
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 06:17:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Od-UlUF7G8Aa for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Feb 2019 06:17:00 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C01094A399
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 06:17:00 -0500 (EST)
In-Reply-To: <20190201111641.8299-1-alexandru.elisei@arm.com>
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
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On arm and arm64, kvm-unit-tests uses the QEMU chr-testdev device to shut
down the virtual machine at the end of a test. The function
psci_system_off() provides another mechanism for terminating the virtual
machine.

chr-testdev is implemented on top of virtio console. If the virtual machine
manager doesn't emulate a virtio console, then chr_testdev_exit() will fail.
If this happens, try to use psci_system_off() to terminate the test.

This patch makes it possible for a virtual machine manager which doesn't
have support for chr-testdev, but has been configured not to emulate a
virtio console, to gracefully terminate a virtual machine after a test has
been completed.

There is one limitation to using psci_system_off() to terminate a test:
chr-testdev allows kvm-unit-tests to specify an exit code;
psci_system_off() has no such mechanism.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/arm/io.c b/lib/arm/io.c
index 0d5ab9510ec8..bbb93e63fa3d 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -12,6 +12,7 @@
 #include <devicetree.h>
 #include <chr-testdev.h>
 #include <config.h>
+#include <asm/psci.h>
 #include <asm/spinlock.h>
 #include <asm/io.h>
 
@@ -90,6 +91,7 @@ void puts(const char *s)
 void exit(int code)
 {
 	chr_testdev_exit(code);
+	psci_system_off();
 	halt(code);
 	__builtin_unreachable();
 }
-- 
2.17.0
