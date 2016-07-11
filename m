From: Anna-Maria Gleixner <anna-maria@linutronix.de>
Subject: [patch 48/66] arm: kvm: arch_timer: Convert to hotplug state machine
Date: Mon, 11 Jul 2016 12:28:56 -0000
Message-ID: <20160711122534.680908905@linutronix.de>
References: <20160711122450.923603742@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline;
 filename=0048-arm-kvm-arch_timer-Convert-to-hotplug-state-machine.patch
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Richard Cochran <rcochran@linutronix.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Anna-Maria Gleixner <anna-maria@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

From: Richard Cochran <rcochran@linutronix.de>

Install the callbacks via the state machine and let the core invoke
the callbacks on the already online CPUs.

Signed-off-by: Richard Cochran <rcochran@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org
Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
---
 include/linux/cpuhotplug.h |    1 +
 virt/kvm/arm/arch_timer.c  |   35 +++++++++++------------------------
 2 files changed, 12 insertions(+), 24 deletions(-)

--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -48,6 +48,7 @@ enum cpuhp_state {
 	CPUHP_AP_MIPS_GIC_TIMER_STARTING,
 	CPUHP_AP_KVM_STARTING,
 	CPUHP_AP_KVM_ARM_VGIC_STARTING,
+	CPUHP_AP_KVM_ARM_TIMER_STARTING,
 	CPUHP_AP_LEDTRIG_STARTING,
 	CPUHP_AP_NOTIFY_STARTING,
 	CPUHP_AP_ONLINE,
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -405,26 +405,17 @@ u64 kvm_arm_timer_get_reg(struct kvm_vcp
 	return (u64)-1;
 }
 
-static int kvm_timer_cpu_notify(struct notifier_block *self,
-				unsigned long action, void *cpu)
+static int kvm_timer_starting_cpu(unsigned int cpu)
 {
-	switch (action) {
-	case CPU_STARTING:
-	case CPU_STARTING_FROZEN:
-		kvm_timer_init_interrupt(NULL);
-		break;
-	case CPU_DYING:
-	case CPU_DYING_FROZEN:
-		disable_percpu_irq(host_vtimer_irq);
-		break;
-	}
-
-	return NOTIFY_OK;
+	kvm_timer_init_interrupt(NULL);
+	return 0;
 }
 
-static struct notifier_block kvm_timer_cpu_nb = {
-	.notifier_call = kvm_timer_cpu_notify,
-};
+static int kvm_timer_dying_cpu(unsigned int cpu)
+{
+	disable_percpu_irq(host_vtimer_irq);
+	return 0;
+}
 
 int kvm_timer_hyp_init(void)
 {
@@ -449,12 +440,6 @@ int kvm_timer_hyp_init(void)
 		goto out;
 	}
 
-	err = __register_cpu_notifier(&kvm_timer_cpu_nb);
-	if (err) {
-		kvm_err("Cannot register timer CPU notifier\n");
-		goto out_free;
-	}
-
 	wqueue = create_singlethread_workqueue("kvm_arch_timer");
 	if (!wqueue) {
 		err = -ENOMEM;
@@ -462,8 +447,10 @@ int kvm_timer_hyp_init(void)
 	}
 
 	kvm_info("virtual timer IRQ%d\n", host_vtimer_irq);
-	on_each_cpu(kvm_timer_init_interrupt, NULL, 1);
 
+	cpuhp_setup_state(CPUHP_AP_KVM_ARM_TIMER_STARTING,
+			  "AP_KVM_ARM_TIMER_STARTING", kvm_timer_starting_cpu,
+			  kvm_timer_dying_cpu);
 	goto out;
 out_free:
 	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
