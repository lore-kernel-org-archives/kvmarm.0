From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 6/5] arm/arm64: selftest.vectors-user: clean up PSCI exit
Date: Tue,  5 Feb 2019 15:29:01 +0100
Message-ID: <20190205142901.13019-1-drjones@redhat.com>
References: <20190204134412.47877-1-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F2F34A2D3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Feb 2019 09:29:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 18nZuv10NK+k for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Feb 2019 09:29:07 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D11DC4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Feb 2019 09:29:07 -0500 (EST)
In-Reply-To: <20190204134412.47877-1-alexandru.elisei@arm.com>
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

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---

The original posting didn't consider arm32. I kept Alexandru's tags
for this new version though, as the tweaks should be safe. Also
added __builtin_unreachable as suggested by Alexandru.

 arm/selftest.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arm/selftest.c b/arm/selftest.c
index ea5101ef7217..28a17f7a7531 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -17,6 +17,13 @@
 #include <asm/smp.h>
 #include <asm/barrier.h>
 
+static void __user_psci_system_off(void)
+{
+	psci_system_off();
+	halt();
+	__builtin_unreachable();
+}
+
 static void check_setup(int argc, char **argv)
 {
 	int nr_tests = 0, len, i;
@@ -154,6 +161,11 @@ static bool check_svc(void)
 
 	return svc_works;
 }
+
+static void user_psci_system_off(struct pt_regs *regs)
+{
+	__user_psci_system_off();
+}
 #elif defined(__aarch64__)
 
 /*
@@ -270,12 +282,25 @@ static bool check_svc(void)
 
 	return svc_works;
 }
+
+static void user_psci_system_off(struct pt_regs *regs, unsigned int esr)
+{
+	__user_psci_system_off();
+}
 #endif
 
 static void check_vectors(void *arg __unused)
 {
 	report("und", check_und());
 	report("svc", check_svc());
+	if (is_user()) {
+#ifdef __arm__
+		install_exception_handler(EXCPTN_UND, user_psci_system_off);
+#else
+		install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_UNKNOWN,
+					  user_psci_system_off);
+#endif
+	}
 	exit(report_summary());
 }
 
-- 
2.18.1
