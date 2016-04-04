From: Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH] arm64: KVM: unregister notifiers in hyp mode teardown path
Date: Mon,  4 Apr 2016 14:46:51 +0100
Message-ID: <1459777611-22592-1-git-send-email-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38FCD409A2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 09:45:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eZhO1gNTeMOt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 09:45:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC962400E9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 09:45:50 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Sudeep Holla <sudeep.holla@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

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
---
 arch/arm/kvm/arm.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 6accd66d26f0..42b3a1f83271 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1101,10 +1101,17 @@ static void __init hyp_cpu_pm_init(void)
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
@@ -1166,6 +1173,8 @@ static void teardown_hyp_mode(void)
 	free_hyp_pgds();
 	for_each_possible_cpu(cpu)
 		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
+	unregister_cpu_notifier(&hyp_init_cpu_nb);
+	hyp_cpu_pm_exit();
 }
 
 static int init_vhe_mode(void)
@@ -1270,12 +1279,7 @@ static int init_hyp_mode(void)
 	free_boot_hyp_pgd();
 #endif
 
-	cpu_notifier_register_begin();
-
-	err = __register_cpu_notifier(&hyp_init_cpu_nb);
-
-	cpu_notifier_register_done();
-
+	err = register_cpu_notifier(&hyp_init_cpu_nb);
 	if (err) {
 		kvm_err("Cannot register HYP init CPU notifier (%d)\n", err);
 		goto out_err;
-- 
1.9.1
