From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH v6 08/10] KVM: arm/arm64: arch_timer: Rely on the arch timer
 to parse the firmware tables
Date: Mon, 11 Apr 2016 16:32:58 +0100
Message-ID: <1460388780-914-9-git-send-email-julien.grall@arm.com>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EECEA40F77
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 11:31:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id waxy2oTnUv0P for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2016 11:31:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 136E4409A2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 11:31:53 -0400 (EDT)
In-Reply-To: <1460388780-914-1-git-send-email-julien.grall@arm.com>
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
Cc: al.stone@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, fu.wei@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

The firmware table is currently parsed by the virtual timer code in
order to retrieve the virtual timer interrupt. However, this is already
done by the arch timer driver.

To avoid code duplication, use the newly function arch_timer_get_kvm_info()
which return all the information required by the virtual timer code.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

---
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>

    Changes in v4:
        - Add Christoffer's acked-by

    Changes in v3:
        - Patch added
---
 virt/kvm/arm/arch_timer.c | 40 +++++++++++-----------------------------
 1 file changed, 11 insertions(+), 29 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index a9ad4fe..c6a6f8e 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/cpu.h>
-#include <linux/of_irq.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/interrupt.h>
@@ -409,45 +408,29 @@ static struct notifier_block kvm_timer_cpu_nb = {
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
@@ -460,14 +443,13 @@ int kvm_timer_hyp_init(void)
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
1.9.1
