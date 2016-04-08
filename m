From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 4/4] arm64: KVM: unregister notifiers in hyp mode teardown path
Date: Fri,  8 Apr 2016 11:52:15 +0200
Message-ID: <1460109135-6612-5-git-send-email-christoffer.dall@linaro.org>
References: <1460109135-6612-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7787E40F77
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 05:50:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WyNR6+rCXYX9 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2016 05:50:48 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C815412A6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2016 05:50:48 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id v188so12767087wme.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2016 02:52:14 -0700 (PDT)
In-Reply-To: <1460109135-6612-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Sudeep Holla <sudeep.holla@arm.com>

Commit 1e947bad0b63 ("arm64: KVM: Skip HYP setup when already running
in HYP") re-organized the hyp init code and ended up leaving the CPU
hotplug and PM notifier even if hyp mode initialization fails.

Since KVM is not yet supported with ACPI, the above mentioned commit
breaks CPU hotplug in ACPI boot.

This patch fixes teardown_hyp_mode to properly unregister both CPU
hotplug and PM notifiers in the teardown path.

Fixes: 1e947bad0b63 ("arm64: KVM: Skip HYP setup when already running in HYP")
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index b538431..dded1b7 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1112,10 +1112,17 @@ static void __init hyp_cpu_pm_init(void)
 {
 	cpu_pm_register_notifier(&hyp_init_cpu_pm_nb);
 }
+static void __init hyp_cpu_pm_exit(void)
+{
+	cpu_pm_unregister_notifier(&hyp_init_cpu_pm_nb);
+}
 #else
 static inline void hyp_cpu_pm_init(void)
 {
 }
+static inline void hyp_cpu_pm_exit(void)
+{
+}
 #endif
 
 static void teardown_common_resources(void)
@@ -1141,9 +1148,7 @@ static int init_subsystems(void)
 	/*
 	 * Register CPU Hotplug notifier
 	 */
-	cpu_notifier_register_begin();
-	err = __register_cpu_notifier(&hyp_init_cpu_nb);
-	cpu_notifier_register_done();
+	err = register_cpu_notifier(&hyp_init_cpu_nb);
 	if (err) {
 		kvm_err("Cannot register KVM init CPU notifier (%d)\n", err);
 		return err;
@@ -1193,6 +1198,8 @@ static void teardown_hyp_mode(void)
 	free_hyp_pgds();
 	for_each_possible_cpu(cpu)
 		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
+	unregister_cpu_notifier(&hyp_init_cpu_nb);
+	hyp_cpu_pm_exit();
 }
 
 static int init_vhe_mode(void)
-- 
2.1.2.330.g565301e.dirty
