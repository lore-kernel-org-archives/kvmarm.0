From: Anna-Maria Gleixner <anna-maria@linutronix.de>
Subject: [patch V2 60/67] KVM/arm/arm64/vgic-new: Convert to hotplug state
 machine
Date: Wed, 13 Jul 2016 17:17:02 -0000
Message-ID: <20160713153337.900484868@linutronix.de>
References: <20160713153219.128052238@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C14049B2F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 13:13:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eydhGI02rj26 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jul 2016 13:13:47 -0400 (EDT)
Received: from Galois.linutronix.de (www.linutronix.de [62.245.132.108])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF02049B1D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 13:13:47 -0400 (EDT)
Content-Disposition: inline;
 filename=0059-KVM-arm-arm64-vgic-new-Convert-to-hotplug-state-mach.patch
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>, Peter Zijlstra <peterz@infradead.org>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, Linus Torvalds <torvalds@linux-foundation.org>, rt@linutronix.de, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Ingo Molnar <mingo@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Anna-Maria Gleixner <anna-maria@linutronix.de>

Install the callbacks via the state machine and let the core invoke
the callbacks on the already online CPUs.

Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Radim Krcmar <rkrcmar@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: kvm@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org
---
 include/linux/cpuhotplug.h    |  1 +
 virt/kvm/arm/vgic/vgic-init.c | 31 +++++++++----------------------
 2 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 078bd22..822df54 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -52,6 +52,7 @@ enum cpuhp_state {
 	CPUHP_AP_QCOM_TIMER_STARTING,
 	CPUHP_AP_MIPS_GIC_TIMER_STARTING,
 	CPUHP_AP_KVM_STARTING,
+	CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
 	CPUHP_AP_KVM_ARM_VGIC_STARTING,
 	CPUHP_AP_KVM_ARM_TIMER_STARTING,
 	CPUHP_AP_ARM_XEN_STARTING,
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index a1442f7..2c7f0d5 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -353,32 +353,19 @@ out:
 
 /* GENERIC PROBE */
 
-static void vgic_init_maintenance_interrupt(void *info)
+static int vgic_init_cpu_starting(unsigned int cpu)
 {
 	enable_percpu_irq(kvm_vgic_global_state.maint_irq, 0);
+	return 0;
 }
 
-static int vgic_cpu_notify(struct notifier_block *self,
-			   unsigned long action, void *cpu)
-{
-	switch (action) {
-	case CPU_STARTING:
-	case CPU_STARTING_FROZEN:
-		vgic_init_maintenance_interrupt(NULL);
-		break;
-	case CPU_DYING:
-	case CPU_DYING_FROZEN:
-		disable_percpu_irq(kvm_vgic_global_state.maint_irq);
-		break;
-	}
 
-	return NOTIFY_OK;
+static int vgic_init_cpu_dying(unsigned int cpu)
+{
+	disable_percpu_irq(kvm_vgic_global_state.maint_irq);
+	return 0;
 }
 
-static struct notifier_block vgic_cpu_nb = {
-	.notifier_call = vgic_cpu_notify,
-};
-
 static irqreturn_t vgic_maintenance_handler(int irq, void *data)
 {
 	/*
@@ -434,14 +421,14 @@ int kvm_vgic_hyp_init(void)
 		return ret;
 	}
 
-	ret = __register_cpu_notifier(&vgic_cpu_nb);
+	ret = cpuhp_setup_state(CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
+				"AP_KVM_ARM_VGIC_INIT_STARTING",
+				vgic_init_cpu_starting, vgic_init_cpu_dying);
 	if (ret) {
 		kvm_err("Cannot register vgic CPU notifier\n");
 		goto out_free_irq;
 	}
 
-	on_each_cpu(vgic_init_maintenance_interrupt, NULL, 1);
-
 	kvm_info("vgic interrupt IRQ%d\n", kvm_vgic_global_state.maint_irq);
 	return 0;
 
-- 
2.8.1
