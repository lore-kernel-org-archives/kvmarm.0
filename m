From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 26/29] KVM: arm/arm64: arch_timer: Rely on the arch timer to parse the firmware tables
Date: Wed, 11 May 2016 15:30:19 +0200
Message-ID: <1462973422-10021-27-git-send-email-christoffer.dall@linaro.org>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Julien Grall <julien.grall@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Julien Grall <julien.grall@arm.com>

The firmware table is currently parsed by the virtual timer code in
order to retrieve the virtual timer interrupt. However, this is already
done by the arch timer driver.

To avoid code duplication, use the newly function arch_timer_get_kvm_info()
which return all the information required by the virtual timer code.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 40 +++++++++++-----------------------------
 1 file changed, 11 insertions(+), 29 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 9aaa35d..409db33 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/cpu.h>
-#include <linux/of_irq.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/interrupt.h>
@@ -438,45 +437,29 @@ static struct notifier_block kvm_timer_cpu_nb = {
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
+	struct arch_timer_kvm_info *info;
 	int err;
 
-	timecounter = arch_timer_get_timecounter();
-	if (!timecounter)
-		return -ENODEV;
+	info = arch_timer_get_kvm_info();
+	timecounter = &info->timecounter;
 
-	np = of_find_matching_node(NULL, arch_timer_of_match);
-	if (!np) {
-		kvm_err("kvm_arch_timer: can't find DT node\n");
+	if (info->virtual_irq <= 0) {
+		kvm_err("kvm_arch_timer: invalid virtual timer IRQ: %d\n",
+			info->virtual_irq);
 		return -ENODEV;
 	}
+	host_vtimer_irq = info->virtual_irq;
 
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
@@ -489,14 +472,13 @@ int kvm_timer_hyp_init(void)
 		goto out_free;
 	}
 
-	kvm_info("%s IRQ%d\n", np->name, ppi);
+	kvm_info("virtual timer IRQ%d\n", host_vtimer_irq);
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
2.1.2.330.g565301e.dirty

