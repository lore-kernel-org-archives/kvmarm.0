From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH v2 2/6] KVM: arm/arm64: arch_timer: Rely on the arch timer to
 parse the firmware tables
Date: Thu, 11 Feb 2016 15:33:20 +0000
Message-ID: <1455204804-31830-3-git-send-email-julien.grall@arm.com>
References: <1455204804-31830-1-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FD4749BDE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 10:27:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z8ZFFNW5lQH8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 10:27:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EEAF549BDD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 10:27:40 -0500 (EST)
In-Reply-To: <1455204804-31830-1-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, fu.wei@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The firmware table is currently parsed by the virt timer code in order
to retrieve the virtual interrupt. However, this is already done by the
arch timer driver and therefore make the parsing code duplicated twice.

Introduce an helper to get the virtual interrupt number and use it in
the virtual timer code.

With this changes, the support for ACPI is coming free.

Signed-off-by: Julien Grall <julien.grall@arm.com>

---
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/clocksource/arm_arch_timer.c |  2 ++
 include/clocksource/arm_arch_timer.h |  1 +
 virt/kvm/arm/arch_timer.c            | 33 +++++++--------------------------
 3 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 6eb2c5d..3cdbefd 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -451,6 +451,8 @@ static struct arch_timer_kvm_info arch_timer_kvm_info;
 
 struct arch_timer_kvm_info *arch_timer_get_kvm_info(void)
 {
+	arch_timer_kvm_info.virtual_irq = arch_timer_ppi[VIRT_PPI];
+
 	return &arch_timer_kvm_info;
 }
 
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 4d487f8..8890552 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -51,6 +51,7 @@ enum arch_timer_reg {
 
 struct arch_timer_kvm_info {
 	struct timecounter timecounter;
+	int virtual_irq;
 };
 
 #ifdef CONFIG_ARM_ARCH_TIMER
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index a669c6a..e4de549 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/cpu.h>
-#include <linux/of_irq.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/interrupt.h>
@@ -375,45 +374,28 @@ static struct notifier_block kvm_timer_cpu_nb = {
 	.notifier_call = kvm_timer_cpu_notify,
 };
 
-static const struct of_device_id arch_timer_of_match[] = {
-	{ .compatible	= "arm,armv7-timer",	},
-	{ .compatible	= "arm,armv8-timer",	},
-	{},
-};
-
 int kvm_timer_hyp_init(void)
 {
-	struct device_node *np;
-	unsigned int ppi;
 	struct arch_timer_kvm_info *info;
 	int err;
 
 	info = arch_timer_get_kvm_info();
 	timecounter = &info->timecounter;
 
-	np = of_find_matching_node(NULL, arch_timer_of_match);
-	if (!np) {
-		kvm_err("kvm_arch_timer: can't find DT node\n");
+	host_vtimer_irq = info->virtual_irq;
+	if (host_vtimer_irq <= 0) {
+		kvm_err("kvm_arch_timer: can't find virtual timer info or config virtual timer interrupt\n");
 		return -ENODEV;
 	}
 
-	ppi = irq_of_parse_and_map(np, 2);
-	if (!ppi) {
-		kvm_err("kvm_arch_timer: no virtual timer interrupt\n");
-		err = -EINVAL;
-		goto out;
-	}
-
-	err = request_percpu_irq(ppi, kvm_arch_timer_handler,
+	err = request_percpu_irq(host_vtimer_irq, kvm_arch_timer_handler,
 				 "kvm guest timer", kvm_get_running_vcpus());
 	if (err) {
 		kvm_err("kvm_arch_timer: can't request interrupt %d (%d)\n",
-			ppi, err);
+			host_vtimer_irq, err);
 		goto out;
 	}
 
-	host_vtimer_irq = ppi;
-
 	err = __register_cpu_notifier(&kvm_timer_cpu_nb);
 	if (err) {
 		kvm_err("Cannot register timer CPU notifier\n");
@@ -426,14 +408,13 @@ int kvm_timer_hyp_init(void)
 		goto out_free;
 	}
 
-	kvm_info("%s IRQ%d\n", np->name, ppi);
+	kvm_info("vtimer IRQ%d\n", host_vtimer_irq);
 	on_each_cpu(kvm_timer_init_interrupt, NULL, 1);
 
 	goto out;
 out_free:
-	free_percpu_irq(ppi, kvm_get_running_vcpus());
+	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
 out:
-	of_node_put(np);
 	return err;
 }
 
-- 
1.9.1
