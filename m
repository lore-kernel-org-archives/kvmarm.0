From: fu.wei@linaro.org
Subject: [PATCH v3 5/6] kvm: arm64: wrapping DT support for virt arch timer
Date: Tue,  2 Feb 2016 04:26:57 +0800
Message-ID: <1454358418-5157-6-git-send-email-fu.wei@linaro.org>
References: <1454358418-5157-1-git-send-email-fu.wei@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454358418-5157-1-git-send-email-fu.wei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net, lenb@kernel.org, daniel.lezcano@linaro.org, tglx@linutronix.de, christoffer.dall@linaro.org, marc.zyngier@arm.com, gleb@kernel.org, pbonzini@redhat.com, hanjun.guo@linaro.org, wei@redhat.com, a.spyridakis@virtualopensystems.com
Cc: linaro-acpi@lists.linaro.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, al.stone@linaro.org, graeme.gregory@linaro.org, davem@davemloft.net, jeffrey.t.kirsher@intel.com, richardcochran@gmail.com, arnd@arndb.de, wim@iguana.be, jcm@redhat.com, leo.duran@amd.com, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, Suravee.Suthikulpanit@amd.com, robherring2@gmail.com, Fu Wei <fu.wei@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Wei Huang <wei@redhat.com>

This patches wrapping DT support for virt arch timer into a function.

[Fu Wei: improve the DT support, and separate ACPI support]

Signed-off-by: Alexander Spyridaki <a.spyridakis@virtualopensystems.com>
Signed-off-by: Wei Huang <wei@redhat.com>
Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
Signed-off-by: Fu Wei <fu.wei@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 49 +++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 69bca185..0a279d3 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -381,9 +381,30 @@ static const struct of_device_id arch_timer_of_match[] = {
 	{},
 };
 
-int kvm_timer_hyp_init(void)
+static int kvm_timer_get_ppi(unsigned int *ppi)
 {
 	struct device_node *np;
+	int ret = -EINVAL;
+
+	np = of_find_matching_node(NULL, arch_timer_of_match);
+	if (!np) {
+		ret = -ENODEV;
+		*ppi = 0;
+		goto skip_of;
+	}
+
+	*ppi = irq_of_parse_and_map(np, VIRT_PPI);
+	of_node_put(np);
+
+skip_of:
+	if (*ppi)
+		return 0;
+
+	return ret;
+}
+
+int kvm_timer_hyp_init(void)
+{
 	unsigned int ppi;
 	int err;
 
@@ -391,17 +412,11 @@ int kvm_timer_hyp_init(void)
 	if (!timecounter)
 		return -ENODEV;
 
-	np = of_find_matching_node(NULL, arch_timer_of_match);
-	if (!np) {
-		kvm_err("kvm_arch_timer: can't find DT node\n");
-		return -ENODEV;
-	}
-
-	ppi = irq_of_parse_and_map(np, 2);
-	if (!ppi) {
-		kvm_err("kvm_arch_timer: no virtual timer interrupt\n");
-		err = -EINVAL;
-		goto out;
+	err = kvm_timer_get_ppi(&ppi);
+	if (err) {
+		kvm_err("kvm_arch_timer: can't find virtual timer info or "
+			"config virtual timer interrupt.\n");
+		return err;
 	}
 
 	err = request_percpu_irq(ppi, kvm_arch_timer_handler,
@@ -409,7 +424,7 @@ int kvm_timer_hyp_init(void)
 	if (err) {
 		kvm_err("kvm_arch_timer: can't request interrupt %d (%d)\n",
 			ppi, err);
-		goto out;
+		return err;
 	}
 
 	host_vtimer_irq = ppi;
@@ -426,14 +441,14 @@ int kvm_timer_hyp_init(void)
 		goto out_free;
 	}
 
-	kvm_info("%s IRQ%d\n", np->name, ppi);
+	kvm_info("timer IRQ%d.\n", ppi);
 	on_each_cpu(kvm_timer_init_interrupt, NULL, 1);
 
-	goto out;
+	return 0;
+
 out_free:
 	free_percpu_irq(ppi, kvm_get_running_vcpus());
-out:
-	of_node_put(np);
+
 	return err;
 }
 
-- 
2.5.0
