From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH kvm-unit-tests 2/2] arm/arm64: psci: support testing tcg
Date: Mon, 27 Feb 2017 18:32:08 +0100
Message-ID: <20170227173208.14854-3-drjones@redhat.com>
References: <20170227173208.14854-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDF8340C38
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Feb 2017 12:31:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NGlGhNOVAfA0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Feb 2017 12:31:06 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2225D40C3F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Feb 2017 12:31:06 -0500 (EST)
In-Reply-To: <20170227173208.14854-1-drjones@redhat.com>
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
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/psci.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/arm/psci.c b/arm/psci.c
index e571afb92c7e..3c5f43877fde 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -8,12 +8,44 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <libcflat.h>
+#include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/psci.h>
 
+static bool invalid_function_exception;
+
+#ifdef __arm__
+static void invalid_function_handler(struct pt_regs *regs __unused)
+{
+	invalid_function_exception = true;
+}
+#else
+static void invalid_function_handler(struct pt_regs *regs, unsigned int esr __unused)
+{
+	invalid_function_exception = true;
+	regs->pc += 4;
+}
+#endif
+
+static void install_invalid_function_handler(exception_fn handler)
+{
+#ifdef __arm__
+	install_exception_handler(EXCPTN_UND, handler);
+#else
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, handler);
+#endif
+}
+
 static bool psci_invalid_function(void)
 {
-	return psci_invoke(1337, 0, 0, 0) == PSCI_RET_NOT_SUPPORTED;
+	bool pass;
+
+	install_invalid_function_handler(invalid_function_handler);
+
+	pass = psci_invoke(1337, 0, 0, 0) == PSCI_RET_NOT_SUPPORTED || invalid_function_exception;
+
+	install_invalid_function_handler(NULL);
+	return pass;
 }
 
 static int psci_affinity_info(unsigned long target_affinity, uint32_t lowest_affinity_level)
-- 
2.9.3
